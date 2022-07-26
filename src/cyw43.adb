with System;
with RP.Flash;
with GSPI.Registers;
with AIP;

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
   is null;

   procedure HAL_Pin_High
      (Pin : Integer)
   is null;

   procedure HAL_Pin_Low
      (Pin : Integer)
   is null;

   function HAL_Pin_Read
      (Pin : Integer)
      return Integer
   is (0);

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
   is null;

   procedure Thread_Enter
   is null;

   procedure Thread_Exit
   is null;

   procedure Thread_Lock_Check
   is null;

end CYW43;
