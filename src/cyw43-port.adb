with RP.Timer; use RP.Timer;
with RP.GPIO; use RP.GPIO;

package body CYW43.Port is

   function cyw43_hal_ticks_us
      return UInt32
   is (UInt32 (RP.Timer.Clock));

   function cyw43_hal_ticks_ms
      return UInt32
   is (UInt32 (RP.Timer.Clock / (RP.Timer.Ticks_Per_Second / 1_000)));

   function To_GPIO_Point
      (Pin : cyw43_hal_pin_obj_t)
      return GPIO_Point
   is
   begin
      case Pin is
         when WL_REG_ON => return (Pin => 23);
         when WL_SDIO_1 => return (Pin => 24);
      end case;
   end To_GPIO_Point;

   function cyw43_hal_pin_read
      (pin : cyw43_hal_pin_obj_t)
      return int
   is
      Point : constant GPIO_Point := To_GPIO_Point (pin);
   begin
      if Point.Get then
         return 1;
      else
         return 0;
      end if;
   end cyw43_hal_pin_read;

   procedure cyw43_hal_pin_low
      (pin : cyw43_hal_pin_obj_t)
   is
      Point : GPIO_Point := To_GPIO_Point (pin);
   begin
      Point.Clear;
   end cyw43_hal_pin_low;

   procedure cyw43_hal_pin_high
      (pin : cyw43_hal_pin_obj_t)
   is
      Point : GPIO_Point := To_GPIO_Point (pin);
   begin
      Point.Set;
   end cyw43_hal_pin_high;

end CYW43.Port;
