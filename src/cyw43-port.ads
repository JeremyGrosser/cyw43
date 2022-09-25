with Interfaces.C; use Interfaces.C;
with HAL; use HAL;

package CYW43.Port is

   function cyw43_hal_ticks_us
      return UInt32
   with Export, Convention => C, External_Name => "cyw43_hal_ticks_us";

   function cyw43_hal_ticks_ms
      return UInt32
   with Export, Convention => C, External_Name => "cyw43_hal_ticks_ms";

   type cyw43_hal_pin_obj_t is (WL_REG_ON, WL_SDIO_1)
      with Size => 8;

   function cyw43_hal_pin_read
      (pin : cyw43_hal_pin_obj_t)
      return int
   with Export, Convention => C, External_Name => "cyw43_hal_pin_read";

   procedure cyw43_hal_pin_low
      (pin : cyw43_hal_pin_obj_t)
   with Export, Convention => C, External_Name => "cyw43_hal_pin_low";

   procedure cyw43_hal_pin_high
      (pin : cyw43_hal_pin_obj_t)
   with Export, Convention => C, External_Name => "cyw43_hal_pin_high";

end CYW43.Port;
