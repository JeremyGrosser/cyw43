with RP.Timer; use RP.Timer;
with RP.GPIO; use RP.GPIO;
with RP.Flash;
with HAL.GPIO;

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

   procedure cyw43_hal_pin_config
      (pin  : cyw43_hal_pin_obj_t;
       mode : UInt32;
       pull : UInt32;
       alt  : UInt32)
   is
      pragma Unreferenced (alt);
      Point : GPIO_Point := To_GPIO_Point (pin);
   begin
      Point.Configure (Mode => (if mode = 0 then RP.GPIO.Output else RP.GPIO.Input));
      case pull is
         when 1 =>
            Point.Set_Pull_Resistor (HAL.GPIO.Pull_Up);
         when 2 =>
            Point.Set_Pull_Resistor (HAL.GPIO.Pull_Down);
         when others =>
            Point.Set_Pull_Resistor (HAL.GPIO.Floating);
      end case;
   end cyw43_hal_pin_config;

   procedure cyw43_hal_get_mac
      (idx : int;
       buf : out MAC_Address)
   is
      Id : constant UInt64 := RP.Flash.Unique_Id;
   begin
      buf (1 .. 3) := (16#00#, 16#A0#, 16#50#);
      buf (4) := UInt8 (Shift_Right (Id, 16) and 16#FF#);
      buf (5) := UInt8 (Shift_Right (Id, 8) and 16#FF#);
      buf (6) := UInt8 (Id and 16#FF#) + UInt8 (idx mod 16#FF#);
   end cyw43_hal_get_mac;

   procedure cyw43_hal_generate_laa_mac
      (idx : int;
       buf : out MAC_Address)
   is
   begin
      --  We only generate the MAC from the flash id as there's no OTP flash on
      --  this device. Therefore, both functions do the same thing.
      cyw43_hal_get_mac (idx, buf);
   end cyw43_hal_generate_laa_mac;

   procedure cyw43_schedule_internal_poll_dispatch
      (func : Poll_Callback)
   is null;

end CYW43.Port;
