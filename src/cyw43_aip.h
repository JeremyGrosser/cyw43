#pragma once
#include "aip.h"

#define ERR_MAC -2
#define ERR_IF  -3

void cyw43_aip_init(char *Params, Err_T *Err, Netif_Id *Nid);
