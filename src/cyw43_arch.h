#ifndef CYW43_ARCH_H
#define CYW43_ARCH_H
#include <assert.h>
#include <stdint.h>
#include <stdbool.h>

/* macros copied from pico-sdk/src/rp2_common/pico_platform/include/pico/platform.h */
#ifndef count_of
#define count_of(a) (sizeof(a)/sizeof((a)[0]))
#endif

#ifndef MAX
#define MAX(a, b) ((a)>(b)?(a):(b))
#endif

#ifndef MIN
#define MIN(a, b) ((b)>(a)?(a):(b))
#endif

#ifndef STATIC
#define STATIC static
#endif

// Note, these are negated, because cyw43_driver negates them before returning!
#define CYW43_EPERM            (-1) // Operation not permitted
#define CYW43_EIO              (-2) // I/O error
#define CYW43_EINVAL           (-3) // Invalid argument
#define CYW43_ETIMEDOUT        (-4) // Connection timed out

static bool cyw43_poll_required = false;
#define CYW43_SDPCM_SEND_COMMON_WAIT 0; // cyw43_poll_required = true;
#define CYW43_DO_IOCTL_WAIT 0; // cyw43_poll_required = true;

#define CYW43_ARRAY_SIZE(a) count_of(a)

/* HAL */
#define CYW43_NUM_GPIOS 3
#define CYW43_PIN_WL_REG_ON 23
#define CYW43_PIN_WL_HOST_WAKE 24
#define CYW43_PIN_WL_SDIO_1 24

#define CYW43_HAL_PIN_PULL_NONE 0

#define CYW43_HAL_PIN_MODE_OUTPUT 0
#define CYW43_HAL_PIN_MODE_INPUT 1

extern void cyw43_hal_pin_config(int pin, int mode, int pull, int alt); 
extern void cyw43_hal_pin_high(int pin);
extern void cyw43_hal_pin_low(int pin);
extern int cyw43_hal_pin_read(int pin);

extern uint32_t cyw43_hal_ticks_us(void);
extern uint32_t cyw43_hal_ticks_ms(void);
extern void cyw43_delay_ms(uint32_t ms);
extern void cyw43_delay_us(uint32_t us);

extern void cyw43_hal_get_mac(int idx, uint8_t buf[6]);
extern void cyw43_hal_generate_laa_mac(int idx, uint8_t buf[6]);

extern void cyw43_schedule_internal_poll_dispatch(void (*func)(void));

extern void cyw43_thread_enter(void);
extern void cyw43_thread_exit(void);
extern void cyw43_thread_lock_check(void);
#define CYW43_THREAD_ENTER cyw43_thread_enter();
#define CYW43_THREAD_EXIT cyw43_thread_exit();
#define CYW43_THREAD_LOCK_CHECK cyw43_thread_lock_check();

#endif // CYW43_ARCH_H
