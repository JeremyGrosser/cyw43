--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.GPIO;
with GSPI;

package CYW43 is

   type Device
      (Port   : not null access GSPI.GSPI_Port;
       REG_ON : not null access RP.GPIO.GPIO_Point)
   is tagged null record;

   procedure Initialize
      (This : in out Device);

end CYW43;
