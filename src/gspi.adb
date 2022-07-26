with RP.PIO.Encoding; use RP.PIO.Encoding;
with GSPI_PIO;

package body GSPI is

   procedure Initialize
      (This : in out GSPI_Port)
   is
      use RP.PIO;
   begin
      This.CS.Configure (RP.GPIO.Output, RP.GPIO.Pull_Both);
      This.CS.Set;

      This.Config := Default_SM_Config;
      Set_Out_Pins (This.Config, This.DAT.Pin, 1);
      Set_Set_Pins (This.Config, This.DAT.Pin, 1);
      Set_In_Pins (This.Config, This.DAT.Pin);
      Set_Sideset (This.Config,
         Bit_Count => 1,
         Optional  => False,
         Pindirs   => False);
      Set_Sideset_Pins (This.Config, This.CLK.Pin);
      Set_In_Shift (This.Config,
         Shift_Right    => False,
         Autopush       => True,
         Push_Threshold => 32);
      Set_Out_Shift (This.Config,
         Shift_Right    => False,
         Autopull       => True,
         Pull_Threshold => 32);
      Set_Clock_Frequency (This.Config, 20_000_000);

      This.PIO.Enable;
      This.Transmit_Offset := This.Offset;
      This.Receive_Offset := This.Offset + GSPI_PIO.Gspi_Transmit_Program_Instructions'Length;
      This.PIO.Load (GSPI_PIO.Gspi_Transmit_Program_Instructions, This.Transmit_Offset);
      This.PIO.Load (GSPI_PIO.Gspi_Receive_Program_Instructions, This.Receive_Offset);

      This.DAT.Configure (RP.GPIO.Output, RP.GPIO.Pull_Both, This.PIO.GPIO_Function);
      This.CLK.Configure (RP.GPIO.Output, RP.GPIO.Pull_Both, This.PIO.GPIO_Function);
   end Initialize;

   procedure Write
      (This    : in out GSPI_Port;
       Command : UInt32;
       Data    : UInt32_Array)
   is
      Status : UInt32_Array (1 .. 1);
   begin
      This.CS.Clear;
      This.Transmit (UInt32_Array'(1 => Command));
      This.Transmit (Data);
      This.Receive (Status);
      This.CS.Set;
   end Write;

   procedure Read
      (This    : in out GSPI_Port;
       Command : UInt32;
       Data    : out UInt32_Array)
   is
      Status : UInt32_Array (1 .. 1);
   begin
      This.CS.Clear;
      This.Transmit (UInt32_Array'(1 => Command));
      This.CS.Set;

      This.Delays.Delay_Milliseconds (15);

      This.CS.Clear;
      This.Receive (Data);
      This.Receive (Status);
      This.CS.Set;
   end Read;

   procedure Transmit
      (This : in out GSPI_Port;
       Data : UInt32_Array)
   is
   begin
      if This.State /= Transmitting then
         RP.PIO.Set_Wrap (This.Config,
            Wrap_Target => This.Transmit_Offset + GSPI_PIO.Gspi_Transmit_Wrap_Target,
            Wrap        => This.Transmit_Offset + GSPI_PIO.Gspi_Transmit_Wrap);
         This.PIO.SM_Initialize (This.SM, This.Transmit_Offset, This.Config);
         This.PIO.Set_Pin_Direction (This.SM, This.CLK.Pin, RP.PIO.Output);
         This.PIO.Set_Pin_Direction (This.SM, This.DAT.Pin, RP.PIO.Output);
         This.PIO.Execute (This.SM, Encode (SET'(Destination => Y, Data => UInt5 (31), others => <>)));
         This.PIO.Ack_SM_IRQ (0);
         This.PIO.Set_Enabled (This.SM, True);
      end if;

      for D of Data loop
         This.PIO.Ack_SM_IRQ (0);
         This.PIO.Put (This.SM, Swap_32 (D));
      end loop;

      while not This.PIO.SM_IRQ_Status (0) loop
         null;
      end loop;
   end Transmit;

   procedure Receive
      (This : in out GSPI_Port;
       Data : out UInt32_Array)
   is
      D : UInt32;
   begin
      if This.State /= Receiving then
         This.PIO.Set_Enabled (This.SM, False);
         RP.PIO.Set_Wrap (This.Config,
            Wrap_Target => This.Receive_Offset + GSPI_PIO.Gspi_Receive_Wrap_Target,
            Wrap        => This.Receive_Offset + GSPI_PIO.Gspi_Receive_Wrap);
         This.PIO.SM_Initialize (This.SM, This.Receive_Offset, This.Config);
         This.PIO.Set_Pin_Direction (This.SM, This.CLK.Pin, RP.PIO.Output);
         This.PIO.Set_Pin_Direction (This.SM, This.DAT.Pin, RP.PIO.Input);
         This.PIO.Execute (This.SM, Encode (SET'(Destination => Y, Data => UInt5 (31), others => <>)));
         This.PIO.Ack_SM_IRQ (0);
         This.PIO.Set_Enabled (This.SM, True);
      end if;

      for I in Data'Range loop
         This.PIO.Get (This.SM, D);
         Data (I) := Swap_32 (D);
         while not This.PIO.SM_IRQ_Status (0) loop
            null;
         end loop;

         if I /= Data'Last then
            This.PIO.Ack_SM_IRQ (0);
         end if;
      end loop;
   end Receive;

   function Swap_32 (X : UInt32) return UInt32
   is ((Shift_Right (X, 16) or Shift_Left (X, 16)));

end GSPI;
