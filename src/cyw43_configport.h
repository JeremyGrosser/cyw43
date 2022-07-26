/*
 * Mostly stolen from pico-sdk, so we'll keep their copyright for now.
 */

/*
 * Copyright (c) 2022 Raspberry Pi (Trading) Ltd.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef CYW43_CONFIGPORT_H
#define CYW43_CONFIGPORT_H

#include "cyw43_arch.h"

#ifndef CYW43_HOST_NAME
#define CYW43_HOST_NAME "PicoW"
#endif

#ifndef CYW43_GPIO
#define CYW43_GPIO 1
#endif

#ifndef CYW43_LOGIC_DEBUG
#define CYW43_LOGIC_DEBUG 0
#endif

#ifndef CYW43_USE_OTP_MAC
#define CYW43_USE_OTP_MAC 1
#endif

#ifndef CYW43_NETUTILS
#define CYW43_NETUTILS 0
#endif

#ifndef CYW43_IOCTL_TIMEOUT_US
#define CYW43_IOCTL_TIMEOUT_US 1000000
#endif

#ifndef CYW43_USE_STATS
#define CYW43_USE_STATS 0
#endif

// todo should this be user settable?
#ifndef CYW43_HAL_MAC_WLAN0
#define CYW43_HAL_MAC_WLAN0 0
#endif

#ifndef CYW43_USE_SPI
#define CYW43_USE_SPI 1
#endif

#ifndef CYW43_SPI_PIO
#define CYW43_SPI_PIO 1
#endif

#define CYW43_PRINTF (void)0;

#define CYW43_LWIP 0

#endif
