--------------------------------------------------------
-- This file is autogenerated by pioasm; do not edit! --
--------------------------------------------------------

pragma Style_Checks (Off);

with RP.PIO;

package GSPI_PIO is

   -------------------
   -- Gspi_Transmit --
   -------------------

   Gspi_Transmit_Wrap_Target : constant := 0;
   Gspi_Transmit_Wrap        : constant := 4;

   Gspi_Transmit_Program_Instructions : RP.PIO.Program := (
                    --  .wrap_target
         16#a022#,  --   0: mov    x, y            side 0     
         16#6001#,  --   1: out    pins, 1         side 0     
         16#1041#,  --   2: jmp    x--, 1          side 1     
         16#00e0#,  --   3: jmp    !osre, 0        side 0     
         16#c020#); --   4: irq    wait 0          side 0     
                    --  .wrap

   ------------------
   -- Gspi_Receive --
   ------------------

   Gspi_Receive_Wrap_Target : constant := 0;
   Gspi_Receive_Wrap        : constant := 4;

   Gspi_Receive_Program_Instructions : RP.PIO.Program := (
                    --  .wrap_target
         16#a022#,  --   0: mov    x, y            side 0     
         16#4001#,  --   1: in     pins, 1         side 0     
         16#1041#,  --   2: jmp    x--, 1          side 1     
         16#af42#,  --   3: nop                    side 0 [15]
         16#c020#); --   4: irq    wait 0          side 0     
                    --  .wrap

end GSPI_PIO;
