#include <stdlib.h>
#include <stdint.h>
#include "cyw43_aip.h"
#include "cyw43.h"
#include "cyw43_stats.h"
#include "aip.h"

extern void AIP_allocate_netif(Netif_Id *Nid);

static uint8_t next_if_num = 0;

struct cyw43_priv {
    cyw43_t hw;
    int num;
};
typedef struct cyw43_priv cyw43_priv_t;

static void cyw43_configured(Netif_Id Nid, Err_T *Err) {
    *Err = NOERR;
}

static void cyw43_output(Netif_Id Nid, Buffer_Id p, Err_T *Err) {
    struct netif *netif = AIP_get_netif(Nid);
    cyw43_priv_t *priv = (cyw43_priv_t *)netif->Dev;
    int packet_count = AIP_buffer_tlen(p);
    Buffer_Id packet = p;
    int err;

    while(packet_count > 0) {
        packet = AIP_buffer_next(packet);
        err = cyw43_send_ethernet(&priv->hw, priv->num, AIP_buffer_len(packet), AIP_buffer_payload(packet), false);
        if(err != 0) {
            *Err = ERR_IF;
            return;
        }else{
            packet_count--;
        }
    }
    *Err = NOERR;
}

void cyw43_aip_init(char *Params, Err_T *Err, Netif_Id *Nid) {
    cyw43_priv_t *priv = calloc(1, sizeof(cyw43_priv_t));
    if(priv == NULL) {
        *Err = ERR_MEM;
        return;
    }

    AIP_allocate_netif(Nid);
    if(*Nid == IF_NOID) {
        *Err = ERR_MEM;
        return;
    }

    struct netif *netif;
    netif = AIP_get_netif(*Nid);

    netif->Dev = (void *)priv;
    priv->num = next_if_num++;

    netif->Name[0] = 'w';
    netif->Name[1] = '0' + (char)priv->num;

    netif->Offload[IP_CS] = 0;
    netif->Offload[ICMP_CS] = 0;
    netif->Offload[UDP_CS] = 0;
    netif->Offload[TCP_CS] = 0;

    netif->Configured_CB = cyw43_configured;
    netif->Input_CB = AIP_ip_input;
    netif->Output_CB = AIP_arp_output;
    netif->Link_Output_CB = cyw43_output;

    cyw43_init(&priv->hw);

    if(cyw43_wifi_get_mac(&priv->hw, priv->num, (uint8_t *)netif->LL_Address) != 0) {
        *Err = ERR_MAC;
        return;
    }
    netif->LL_Address_Length = 6;
    netif->MTU = 1500;

    *Err = NOERR;
}
