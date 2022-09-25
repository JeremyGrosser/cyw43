#pragma once

#define MIN(a, b) ((b)>(a)?(a):(b))
#define STATIC static

#define CYW43_EIO 1
#define CYW43_EINVAL 2
#define CYW43_ETIMEDOUT 3
#define CYW43_EPERM 4

int cyw43_poll_required = 0;
#define CYW43_SDPCM_SEND_COMMON_WAIT cyw43_poll_required = 1;
#define CYW43_DO_IOCTL_WAIT cyw43_poll_required = 1;

#define CYW43_THREAD_ENTER
#define CYW43_THREAD_EXIT
#define CYW43_THREAD_LOCK_CHECK

// get the number of elements in a fixed-size array
#define count_of(a) (sizeof(a)/sizeof((a)[0]))
#define CYW43_ARRAY_SIZE(a) count_of(a)

#define cyw43_hal_pin_obj_t uint32_t

#define CYW43_PIN_WL_REG_ON 1
#define CYW43_PIN_WL_SDIO_1 2

#define GPIO_OUT 0
#define GPIO_IN 1

#define cyw43_delay_ms // todo
#define cyw43_delay_us // todo

#define CYW43_HAL_MAC_WLAN0 0

uint32_t cyw43_hal_ticks_us(void) {
    //return time_us_32();
    return 0;
}

uint32_t cyw43_hal_ticks_ms(void) {
    //return to_ms_since_boot(get_absolute_time());
    return 0;
}

int cyw43_hal_pin_read(cyw43_hal_pin_obj_t pin) {
    //return gpio_get(pin);
    return 0;
}

void cyw43_hal_pin_low(cyw43_hal_pin_obj_t pin) {
    //gpio_clr_mask(1 << pin);
}

void cyw43_hal_pin_high(cyw43_hal_pin_obj_t pin) {
    //gpio_set_mask(1 << pin);
}

#define CYW43_HAL_PIN_MODE_INPUT           (GPIO_IN)
#define CYW43_HAL_PIN_MODE_OUTPUT          (GPIO_OUT)

#define CYW43_HAL_PIN_PULL_NONE            (0)
#define CYW43_HAL_PIN_PULL_UP              (1)
#define CYW43_HAL_PIN_PULL_DOWN            (2)

void cyw43_hal_pin_config(cyw43_hal_pin_obj_t pin, uint32_t mode, uint32_t pull, __unused uint32_t alt) {
    //assert((mode == CYW43_HAL_PIN_MODE_INPUT || mode == CYW43_HAL_PIN_MODE_OUTPUT) && alt == 0);
    //gpio_set_dir(pin, mode);
    //gpio_set_pulls(pin, pull == CYW43_HAL_PIN_PULL_UP, pull == CYW43_HAL_PIN_PULL_DOWN);
}

void cyw43_hal_get_mac(int idx, uint8_t buf[6]);

void cyw43_hal_generate_laa_mac(int idx, uint8_t buf[6]);

void cyw43_schedule_internal_poll_dispatch(void (*func)(void)) {
}
