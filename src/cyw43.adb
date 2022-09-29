--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.Timer.Interrupts;
with GSPI.Registers;
with HAL; use HAL;
with cyw43_h;

package body CYW43 is

   Delays : RP.Timer.Interrupts.Delays;
   State  : aliased cyw43_h.cyw43_t;

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
         procedure cyw43_init
            (self : access cyw43_h.cyw43_t)
         with Import, Convention => C, External_Name => "cyw43_init";
      begin
         cyw43_init (State'Access);
      end;
   end Initialize;

end CYW43;
