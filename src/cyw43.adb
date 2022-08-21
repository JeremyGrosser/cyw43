--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.Flash;
with GSPI.Registers;
with AIP;
with Ada.Text_IO; use Ada.Text_IO;

package body CYW43 is

   procedure Initialize
      (This : in out Device)
   is
      use GSPI.Registers;
      Cmd  : GSPI.Registers.Command;
      Data : UInt32_Array (1 .. 1);
   begin
      This.Port.Initialize;
      This.REG_ON.Configure (RP.GPIO.Output, RP.GPIO.Pull_Up);
      This.REG_ON.Clear;

      if not Delays.Enabled then
         Delays.Enable;
      end if;

      --  19.1.2 Control Signal Timing Diagrams (Two 32.768 KHz cycles, >=6.1ms)
      Delays.Delay_Milliseconds (7);
      This.REG_ON.Set;

      --  4.2.3 Boot-Up Sequence
      --  Delays.Delay_Milliseconds (50);
      Cmd := (Read, Incremental_Address, 0, REG_TEST_RO, 4);
      loop
         This.Port.Read (To_UInt32 (Cmd), Data);
         exit when Data (1) = 16#FEED_BEAD#;
         Delays.Delay_Milliseconds (15);
      end loop;

      loop
         Cmd := (Write, Incremental_Address, 0, REG_TEST_RW, 4);
         Data (1) := 16#CAFE_F00D#;
         This.Port.Write (To_UInt32 (Cmd), Data);
         Cmd.C := Read;
         Data (1) := 0;
         This.Port.Read (To_UInt32 (Cmd), Data);
         exit when Data (1) = 16#CAFE_F00D#;
      end loop;

      --  Send Wake_Up WLAN command
      --  Wait 15ms
      --  Configure the PLL registers
      --  Send firmware blob

      declare
         procedure cyw43_aip_init
            (Params : System.Address;
             Err    : out AIP.Err_T;
             Nid    : out AIP.NIF.Netif_Id)
         with Import, Convention => C, External_Name => "cyw43_aip_init";

         Err : AIP.Err_T;
      begin
         AIP.NIF.Initialize;
         cyw43_aip_init
            (Params => System.Null_Address,
             Err    => Err,
             Nid    => This.Nid);
         if AIP.Any (Err) then
            raise Program_Error with "cyw43_netif_init failed";
         end if;
      end;
   end Initialize;

   procedure HAL_Pin_Config
      (Pin, Mode, Pull, Alt : Integer)
   is
      use RP.GPIO;
      P : GPIO_Point := (Pin => GPIO_Pin (Pin));
   begin
      P.Configure
         (Mode => (if Mode = 1 then Input else Output),
          Pull => (if Pull = 1 then Pull_Up else Floating));
      Put_Line ("HAL_Pin_Config (Pin=" & Pin'Image & ", Mode=" & Mode'Image & ", Pull=" & Pull'Image & ", Alt=" & Alt'Image & ");");
   end HAL_Pin_Config;

   procedure HAL_Pin_High
      (Pin : Integer)
   is
      use RP.GPIO;
      P : GPIO_Point := (Pin => GPIO_Pin (Pin));
   begin
      P.Set;
      Put_Line ("HAL_Pin_High (Pin=" & Pin'Image & ");");
   end HAL_Pin_High;

   procedure HAL_Pin_Low
      (Pin : Integer)
   is
      use RP.GPIO;
      P : GPIO_Point := (Pin => GPIO_Pin (Pin));
   begin
      P.Clear;
      Put_Line ("HAL_Pin_Low (Pin=" & Pin'Image & ");");
   end HAL_Pin_Low;

   function HAL_Pin_Read
      (Pin : Integer)
      return Integer
   is
      use RP.GPIO;
      P : constant GPIO_Point := (Pin => GPIO_Pin (Pin));
   begin
      Put_Line ("HAL_Pin_Read (Pin=" & Pin'Image & ") = 0");
      return (if P.Get then 1 else 0);
   end HAL_Pin_Read;

   function HAL_Ticks_Ms
      return UInt32
   is
      use RP.Timer;
   begin
      return UInt32 ((Clock / (Ticks_Per_Second / 1_000)) mod 2 ** 32);
   end HAL_Ticks_Ms;

   function HAL_Ticks_Us
      return UInt32
   is
      use type RP.Timer.Time;
   begin
      return UInt32 (RP.Timer.Clock mod 2 ** 32);
   end HAL_Ticks_Us;

   procedure Delay_Ms
      (Ms : UInt32)
   is
   begin
      Delays.Delay_Microseconds (Integer (Ms));
   end Delay_Ms;

   procedure Delay_Us
      (Us : UInt32)
   is
   begin
      Delays.Delay_Microseconds (Integer (Us));
   end Delay_Us;

   procedure HAL_Get_MAC
      (Idx : Integer;
       Buf : out AIP.Ethernet_Address)
   is
      Vendor_OUI : constant AIP.LL_Address (1 .. 3) := (16#00#, 16#10#, 16#18#);
      --  Broadcom Corporation
      Uid : UInt64;
   begin
      Uid := RP.Flash.Unique_Id;
      Uid := Uid + UInt64 (Idx);

      Buf (1 .. 3) := Vendor_OUI;
      Buf (4) := AIP.U8_T (Shift_Right (Uid, 16) and 16#FF#);
      Buf (5) := AIP.U8_T (Shift_Right (Uid, 8) and 16#FF#);
      Buf (6) := AIP.U8_T (Shift_Right (Uid, 0) and 16#FF#);
   end HAL_Get_MAC;

   procedure HAL_Generate_LAA_MAC
      (Idx : Integer;
       Buf : out AIP.Ethernet_Address)
   is
      X : UInt8;
   begin
      HAL_Get_MAC (Idx, Buf);
      X := UInt8 (Buf (1));
      X := X or 2#0000_0010#;
      Buf (1) := AIP.U8_T (X);
   end HAL_Generate_LAA_MAC;

   procedure Schedule_Internal_Poll_Dispatch
      (Func : Poll_Callback)
   is
   begin
      Put_Line ("Schedule_Internal_Poll_Dispatch");
   end Schedule_Internal_Poll_Dispatch;

   procedure Thread_Enter
   is
   begin
      Put_Line ("Thread_Enter");
   end Thread_Enter;

   procedure Thread_Exit
   is
   begin
      Put_Line ("Thread_Enter");
   end Thread_Exit;

   procedure Thread_Lock_Check
   is
   begin
      Put_Line ("Thread_Lock_Check");
   end Thread_Lock_Check;

   function SPI_Init
      (Self : System.Address)
      return Integer
   is
   begin
      Put_Line ("SPI_Init (Self=" & Self'Image & ") = 0");
      return 0;
   end SPI_Init;

   procedure SPI_GPIO_Setup is
   begin
      Put_Line ("SPI_GPIO_Setup");
   end SPI_GPIO_Setup;

   procedure SPI_Reset is
   begin
      Put_Line ("SPI_Reset");
   end SPI_Reset;

   procedure SPI_Deinit
      (Self : System.Address)
   is
   begin
      Put_Line ("SPI_Deinit (Self=" & Self'Image & ")");
   end SPI_Deinit;

   function SDIO_Transfer
      (Cmd  : UInt32;
       Arg  : UInt32;
       Resp : Any_UInt32_Array)
       return Integer
   is
   begin
      Put_Line ("SDIO_Transfer (Cmd=" & Cmd'Image & ", Arg=" & Arg'Image & ", Resp=...) = 0");
      return 0;
   end SDIO_Transfer;

   function SDIO_Transfer_Cmd53
      (Write      : Interfaces.C.int;
       Block_Size : UInt32;
       Arg        : UInt32;
       Len        : Interfaces.C.size_t;
       Buf        : Any_UInt8_Array)
       return Integer
   is
   begin
      Put_Line ("SDIO_Transfer_Cmd53 (Write=" & Write'Image & ", Block_Size=" & Block_Size'Image & ", Arg=" & Arg'Image & ", Len=" & Len'Image & ", Buf=...) = 0");
      return 0;
   end SDIO_Transfer_Cmd53;

   function Storage_Read_Blocks
      (Dest       : Any_UInt8_Array;
       Block_Num  : UInt32;
       Num_Blocks : UInt32)
       return UInt32
   is
   begin
      Put_Line ("Storage_Read_Blocks (Dest=... Block_Num=" & Block_Num'Image & ", Num_Blocks=" & Num_Blocks'Image & ") = 0");
      return 0;
   end Storage_Read_Blocks;

   function Pbuf_Copy_Partial
      (P       : access constant Pbuf;
       Dataptr : System.Address;
       Len     : UInt16;
       Offset  : UInt16)
       return UInt16
   is
   begin
      Put_Line ("Pbuf_Copy_Partial (P=..., Dataptr=" & Dataptr'Image & ", Len=" & Len'Image & ", Offset=" & Offset'Image & ") = 0");
      return 0;
   end Pbuf_Copy_Partial;

   function Read_Reg_U16
      (Self : System.Address;
       Fn   : UInt32;
       Reg  : UInt32)
       return Integer
   is
   begin
      Put_Line ("Read_Reg_U16 (Self=" & Self'Image & ", Fn=" & Fn'Image & ", Reg=" & Reg'Image & ") = 0");
      return 0;
   end Read_Reg_U16;

   function Write_Reg_U16
      (Self : System.Address;
       Fn   : UInt32;
       Reg  : UInt32;
       Val  : UInt16)
       return Integer
   is
   begin
      Put_Line ("Write_Reg_U16 (Self=" & Self'Image & ", Fn=" & Fn'Image & ", Reg=" & Reg'Image & ", Val=" & Val'Image & ") = 0");
      return 0;
   end Write_Reg_U16;

   function Read_Reg_U32_Swap
      (Self : System.Address;
       Fn   : UInt32;
       Reg  : UInt32)
       return UInt32
   is
   begin
      Put_Line ("Read_Reg_U32_Swap (Self=" & Self'Image & ", Fn=" & Fn'Image & ", Reg=" & Reg'Image & ") = 0");
      return 0;
   end Read_Reg_U32_Swap;

   function Write_Reg_U32_Swap
      (Self : System.Address;
       Fn   : UInt32;
       Reg  : UInt32;
       Val  : UInt32)
       return Integer
   is
   begin
      Put_Line ("Write_Reg_U32_Swap (Self=" & Self'Image & ", Fn=" & Fn'Image & ", Reg=" & Reg'Image & ", Val=" & Val'Image & ") = 0");
      return 0;
   end Write_Reg_U32_Swap;

end CYW43;
