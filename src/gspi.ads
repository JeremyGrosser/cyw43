--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Ada.Unchecked_Conversion;
with HAL; use HAL;
with RP.Timer.Interrupts;
with RP.GPIO;
with RP.PIO;
with RP.DMA;

package GSPI is

   type GSPI_Port
      (PIO     : not null access RP.PIO.PIO_Device;
       SM      : RP.PIO.PIO_SM;
       Offset  : RP.PIO.PIO_Address;
       CLK     : not null access RP.GPIO.GPIO_Point;
       DAT     : not null access RP.GPIO.GPIO_Point;
       CS      : not null access RP.GPIO.GPIO_Point;
       Delays  : not null access RP.Timer.Interrupts.Delays;
       Channel : RP.DMA.DMA_Channel_Id)
   is tagged private;

   procedure Initialize
      (This : in out GSPI_Port);

   procedure Write
      (This    : in out GSPI_Port;
       Command : UInt32;
       Data    : UInt32_Array);

   procedure Read
      (This    : in out GSPI_Port;
       Command : UInt32;
       Data    : out UInt32_Array);

private

   type GSPI_State is (Init, Transmitting, Receiving);

   type GSPI_Port
      (PIO     : not null access RP.PIO.PIO_Device;
       SM      : RP.PIO.PIO_SM;
       Offset  : RP.PIO.PIO_Address;
       CLK     : not null access RP.GPIO.GPIO_Point;
       DAT     : not null access RP.GPIO.GPIO_Point;
       CS      : not null access RP.GPIO.GPIO_Point;
       Delays  : not null access RP.Timer.Interrupts.Delays;
       Channel : RP.DMA.DMA_Channel_Id)
   is tagged record
      Config : RP.PIO.PIO_SM_Config;
      Transmit_Offset, Receive_Offset : RP.PIO.PIO_Address;
      State : GSPI_State := Init;
   end record;

   procedure Transmit
      (This : in out GSPI_Port;
       Data : UInt32_Array);

   procedure Receive
      (This : in out GSPI_Port;
       Data : out UInt32_Array);

   function Swap_32 (X : UInt32) return UInt32;

end GSPI;
