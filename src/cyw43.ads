--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Interfaces.C;
with HAL; use HAL;
with System;
with AIP.NIF;
with RP.Timer.Interrupts;
with RP.GPIO;
with GSPI;

package CYW43 is

   Delays : RP.Timer.Interrupts.Delays;
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

   function SPI_Init
      (Self : System.Address)
      return Integer
   with Export, Convention => C, External_Name => "cyw43_spi_init";

   procedure SPI_GPIO_Setup
      with Export, Convention => C, External_Name => "cyw43_spi_gpio_setup";

   procedure SPI_Reset
      with Export, Convention => C, External_Name => "cyw43_spi_reset";

   procedure SPI_Deinit
      (Self : System.Address)
   with Export, Convention => C, External_Name => "cyw43_spi_deinit";

   function SDIO_Transfer
      (Cmd  : UInt32;
       Arg  : UInt32;
       Resp : access UInt32_Array)
       return Integer
   with Export, Convention => C, External_Name => "cyw43_sdio_transfer";

   function SDIO_Transfer_Cmd53
      (Write      : Interfaces.C.int;
       Block_Size : UInt32;
       Arg        : UInt32;
       Len        : Interfaces.C.size_t;
       Buf        : access UInt8_Array)
       return Integer
   with Export, Convention => C, External_Name => "cyw43_sdio_transfer_cmd53";

   function Storage_Read_Blocks
      (Dest       : access UInt8_Array;
       Block_Num  : UInt32;
       Num_Blocks : UInt32)
       return UInt32
   with Export, Convention => C, External_Name => "storage_read_blocks";

   type Pbuf is null record;

   function Pbuf_Copy_Partial
      (P       : access constant Pbuf;
       Dataptr : System.Address;
       Len     : UInt16;
       Offset  : UInt16)
       return UInt16
   with Export, Convention => C, External_Name => "pbuf_copy_partial";

   function Read_Reg_U16
      (Self : System.Address;
       Fn   : UInt32;
       Reg  : UInt32)
       return Integer
   with Export, Convention => C, External_Name => "cyw43_read_reg_u16";

   function Write_Reg_U16
      (Self : System.Address;
       Fn   : UInt32;
       Reg  : UInt32;
       Val  : UInt16)
       return Integer
   with Export, Convention => C, External_Name => "cyw43_write_reg_u16";

   function Read_Reg_U32_Swap
      (Self : System.Address;
       Fn   : UInt32;
       Reg  : UInt32)
       return UInt32
   with Export, Convention => C, External_Name => "read_reg_u32_swap";

   function Write_Reg_U32_Swap
      (Self : System.Address;
       Fn   : UInt32;
       Reg  : UInt32;
       Val  : UInt32)
       return Integer
   with Export, Convention => C, External_Name => "write_reg_u32_swap";

end CYW43;
