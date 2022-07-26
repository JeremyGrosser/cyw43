package GSPI.Registers is

   REG_TEST_RO          : constant := 16#0014#;
   REG_TEST_RW          : constant := 16#0018#;
   REG_RESPONSE_DELAY   : constant := 16#001C#;

   type Status is record
      Data_Not_Available   : Boolean;
      Underflow            : Boolean;
      Overflow             : Boolean;
      F2_Interrupt         : Boolean;
      F2_RX_Ready          : Boolean;
      F2_Packet_Available  : Boolean;
      F2_Packet_Length     : UInt10;
   end record
      with Size => 32;
   for Status use record
      Data_Not_Available   at 0 range 0 .. 0;
      Underflow            at 0 range 1 .. 1;
      Overflow             at 0 range 2 .. 2;
      F2_Interrupt         at 0 range 3 .. 3;
      F2_RX_Ready          at 0 range 5 .. 5;
      F2_Packet_Available  at 0 range 8 .. 8;
      F2_Packet_Length     at 0 range 9 .. 19;
   end record;

   --  Figure 12. gSPI Command Structure
   type Command_C_Field is (Read, Write)
      with Size => 1;
   type Command_A_Field is (Fixed_Address, Incremental_Address)
      with Size => 1;
   subtype Command_F_Field is UInt2;
   subtype Command_Addr_Field is UInt17;
   subtype Command_Length_Field is UInt11;

   type Command is record
      C        : Command_C_Field := Read;
      A        : Command_A_Field := Fixed_Address;
      F        : Command_F_Field := 2#00#;
      Addr     : Command_Addr_Field := 0;
      Length   : Command_Length_Field := 0; -- Length = 0 represents 2048 bytes
   end record
      with Size => 32;
   for Command use record
      C        at 0 range 31 .. 31;
      A        at 0 range 30 .. 30;
      F        at 0 range 28 .. 29;
      Addr     at 0 range 11 .. 27;
      Length   at 0 range 0 .. 10;
   end record;
   function To_UInt32 is new Ada.Unchecked_Conversion
      (Source => Command, Target => UInt32);

   type Word_Length_Field is (Word_Length_16, Word_Length_32)
      with Size => 1;
   type Endian_Field is (Little, Big)
      with Size => 1;

   type Bus_Control is record
      Word_Length          : Word_Length_Field := Word_Length_16;
      Endian               : Endian_Field := Little;
      Clock_Phase          : Boolean := False; --  undocumented
      Clock_Polarity       : Boolean := False; --  undocumented
      High_Speed           : Boolean := True;
      Interrupt_Polarity   : Boolean := True;
      Wake_Up              : Boolean := False;
   end record
      with Size => 16;
   for Bus_Control use record
      Word_Length          at 0 range 0 .. 0;
      Endian               at 0 range 1 .. 1;
      Clock_Phase          at 0 range 2 .. 2;
      Clock_Polarity       at 0 range 3 .. 3;
      High_Speed           at 0 range 4 .. 4;
      Interrupt_Polarity   at 0 range 5 .. 5;
      Wake_Up              at 0 range 7 .. 7;
   end record;

end GSPI.Registers;
