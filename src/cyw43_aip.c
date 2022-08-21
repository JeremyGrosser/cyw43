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

#ifndef CYW43_HOST_NAME
#define CYW43_HOST_NAME "PYBD"
#endif

void cyw43_cb_tcpip_init(cyw43_t *self, int itf) {
    /*
    ip_addr_t ipconfig[4];
    #if LWIP_IPV6
    #define IP(x) ((x).u_addr.ip4)
    #else
    #define IP(x) (x)
    #endif
    if (itf == 0) {
        // need to zero out to get isconnected() working
        IP4_ADDR(&IP(ipconfig[0]), 0, 0, 0, 0);
        IP4_ADDR(&IP(ipconfig[2]), 192, 168, 0, 1);
    } else {
        IP4_ADDR(&IP(ipconfig[0]), 192, 168, 4, 1);
        IP4_ADDR(&IP(ipconfig[2]), 192, 168, 4, 1);
    }
    IP4_ADDR(&IP(ipconfig[1]), 255, 255, 255, 0);
    IP4_ADDR(&IP(ipconfig[3]), 8, 8, 8, 8);
    #undef IP

    struct netif *n = &self->netif[itf];
    n->name[0] = 'w';
    n->name[1] = '0' + itf;
    #if NO_SYS
    #if LWIP_IPV6
    netif_add(n, &ipconfig[0].u_addr.ip4, &ipconfig[1].u_addr.ip4, &ipconfig[2].u_addr.ip4, self, cyw43_netif_init, ethernet_input);
    #else
    netif_add(n, &ipconfig[0], &ipconfig[1], &ipconfig[2], self, cyw43_netif_init, ethernet_input);
    #endif
    #else
    netif_add(n, &ipconfig[0], &ipconfig[1], &ipconfig[2], self, cyw43_netif_init, tcpip_input);
    #endif
    netif_set_hostname(n, CYW43_HOST_NAME);
    netif_set_default(n);
    netif_set_up(n);

//    #ifndef NDEBUG
//    netif_set_status_callback(n, netif_status_callback);
//    #endif

    if (itf == CYW43_ITF_STA) {
        dns_setserver(0, &ipconfig[3]);
        dhcp_set_struct(n, &self->dhcp_client);
        dhcp_start(n);
    } else {
        #if CYW43_NETUTILS
        dhcp_server_init(&self->dhcp_server, &ipconfig[0], &ipconfig[1]);
        #endif
    }

    #if LWIP_MDNS_RESPONDER
    // TODO better to call after IP address is set
    char mdns_hostname[9];
    memcpy(&mdns_hostname[0], CYW43_HOST_NAME, 4);
    cyw43_hal_get_mac_ascii(CYW43_HAL_MAC_WLAN0, 8, 4, &mdns_hostname[4]);
    mdns_hostname[8] = '\0';
    mdns_resp_add_netif(n, mdns_hostname, 60);
    #endif
    */
}

void cyw43_cb_tcpip_deinit(cyw43_t *self, int itf) {
    /*
    struct netif *n = &self->netif[itf];
    if (itf == CYW43_ITF_STA) {
        dhcp_stop(n);
    } else {
        #if CYW43_NETUTILS
        dhcp_server_deinit(&self->dhcp_server);
        #endif
    }
    #if LWIP_MDNS_RESPONDER
    mdns_resp_remove_netif(n);
    #endif
    for (struct netif *netif = netif_list; netif != NULL; netif = netif->next) {
        if (netif == n) {
            netif_remove(netif);
            netif->ip_addr.addr = 0;
            netif->flags = 0;
        }
    }
    */
}

void cyw43_cb_process_ethernet(void *cb_data, int itf, size_t len, const uint8_t *buf) {
    /*
    cyw43_t *self = cb_data;
    struct netif *netif = &self->netif[itf];
    #if CYW43_NETUTILS
    if (self->trace_flags) {
        cyw43_ethernet_trace(self, netif, len, buf, NETUTILS_TRACE_NEWLINE);
    }
    #endif
    if (netif->flags & NETIF_FLAG_LINK_UP) {
        struct pbuf *p = pbuf_alloc(PBUF_RAW, len, PBUF_POOL);
        if (p != NULL) {
            pbuf_take(p, buf, len);
            if (netif->input(p, netif) != ERR_OK) {
                pbuf_free(p);
            }
            CYW43_STAT_INC(PACKET_IN_COUNT);
        }
    }
    */
}

void cyw43_cb_tcpip_set_link_up(cyw43_t *self, int itf) {
    /*
    netif_set_link_up(&self->netif[itf]);
    */
}

void cyw43_cb_tcpip_set_link_down(cyw43_t *self, int itf) {
    /*
    netif_set_link_down(&self->netif[itf]);
    */
}

int cyw43_tcpip_link_status(cyw43_t *self, int itf) {
    /*
    struct netif *netif = &self->netif[itf];
    if ((netif->flags & (NETIF_FLAG_UP | NETIF_FLAG_LINK_UP))
        == (NETIF_FLAG_UP | NETIF_FLAG_LINK_UP)) {
        if (netif->ip_addr.addr != 0) {
            return CYW43_LINK_UP;
        } else {
            return CYW43_LINK_NOIP;
        }
    } else {
        return cyw43_wifi_link_status(self, itf);
    }
    */
}
