--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL; use HAL;
with AIP.NIF;
with RP.Timer;
with RP.GPIO;
with GSPI;

package CYW43 is

   Delays : RP.Timer.Delays;
   --  Delays is global because the cyw43_delay_ms and cyw43_delay_us don't
   --  have a driver context.

   type Device
      (Port   : not null access GSPI.GSPI_Port;
       REG_ON : not null access RP.GPIO.GPIO_Point)
   is tagged record
      Nid : AIP.NIF.Netif_Id;
   end record;

   procedure Initialize
      (This : in out Device);

   --  The third_party/cyw43-driver code depends on the following symbols for
   --  portability to different RTOS environments. We don't really have an
   --  RTOS, but we have enough RP2040 drivers to pretend we do.
   --
   --  These symbols are also defined in cyw43_arch.h and these definitions
   --  should be kept in sync if cyw43-driver is updated.

   procedure HAL_Pin_Config
      (Pin, Mode, Pull, Alt : Integer)
   with Export, Convention => C, External_Name => "cyw43_hal_pin_config";

   procedure HAL_Pin_High
      (Pin : Integer)
   with Export, Convention => C, External_Name => "cyw43_hal_pin_high";

   procedure HAL_Pin_Low
      (Pin : Integer)
   with Export, Convention => C, External_Name => "cyw43_hal_pin_low";

   function HAL_Pin_Read
      (Pin : Integer)
      return Integer
   with Export, Convention => C, External_Name => "cyw43_hal_pin_read";

   function HAL_Ticks_Ms
      return UInt32
   with Export, Convention => C, External_Name => "cyw43_hal_ticks_ms";

   function HAL_Ticks_Us
      return UInt32
   with Export, Convention => C, External_Name => "cyw43_hal_ticks_us";

   procedure Delay_Ms
      (Ms : UInt32)
   with Export, Convention => C, External_Name => "cyw43_delay_ms";

   procedure Delay_Us
      (Us : UInt32)
   with Export, Convention => C, External_Name => "cyw43_delay_us";

   procedure HAL_Get_MAC
      (Idx : Integer;
       Buf : out AIP.Ethernet_Address)
   with Export, Convention => C, External_Name => "cyw43_hal_get_mac";

   procedure HAL_Generate_LAA_MAC
      (Idx : Integer;
       Buf : out AIP.Ethernet_Address)
   with Export, Convention => C, External_Name => "cyw43_hal_generate_laa_mac";

   type Poll_Callback is access procedure
      with Convention => C;

   procedure Schedule_Internal_Poll_Dispatch
      (Func : Poll_Callback)
   with Export, Convention => C, External_Name => "cyw43_schedule_internal_poll_dispatch";

   --  "Threads" are just critical sections that shouldn't be interrupted.
   --  We use Atomic to implement these.
   procedure Thread_Enter
      with Export, Convention => C, External_Name => "cyw43_thread_enter";

   procedure Thread_Exit
      with Export, Convention => C, External_Name => "cyw43_thread_exit";

   procedure Thread_Lock_Check
      with Export, Convention => C, External_Name => "cyw43_thread_lock_check";

end CYW43;
