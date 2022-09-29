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

   procedure cyw43_hal_pin_config
      (pin  : cyw43_hal_pin_obj_t;
       mode : UInt32;
       pull : UInt32;
       alt  : UInt32)
   with Export, Convention => C, External_Name => "cyw43_hal_pin_config";

   subtype MAC_Address is UInt8_Array (1 .. 6);

   procedure cyw43_hal_get_mac
      (idx : int;
       buf : out MAC_Address)
    with Export, Convention => C, External_Name => "cyw43_hal_get_mac";

   procedure cyw43_hal_generate_laa_mac
      (idx : int;
       buf : out MAC_Address)
   with Export, Convention => C, External_Name => "cyw43_hal_generate_laa_mac";

   type Poll_Callback is access procedure
      with Convention => C;

   procedure cyw43_schedule_internal_poll_dispatch
      (func : Poll_Callback)
   with Export, Convention => C, External_Name => "cyw43_schedule_internal_poll_dispatch";

end CYW43.Port;
