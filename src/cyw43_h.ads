pragma Ada_2012;
pragma Style_Checks (Off);

with Interfaces.C; use Interfaces.C;
with cyw43_ll_h;
with System;
with Interfaces.C.Extensions;
with HAL; use HAL;

package cyw43_h is

   CYW43_TRACE_ASYNC_EV : constant := (16#0001#);  --  cyw43.h:65
   CYW43_TRACE_ETH_TX : constant := (16#0002#);  --  cyw43.h:66
   CYW43_TRACE_ETH_RX : constant := (16#0004#);  --  cyw43.h:67
   CYW43_TRACE_ETH_FULL : constant := (16#0008#);  --  cyw43.h:68
   CYW43_TRACE_MAC : constant := (16#0010#);  --  cyw43.h:69

   CYW43_LINK_DOWN : constant := (0);  --  cyw43.h:80
   CYW43_LINK_JOIN : constant := (1);  --  cyw43.h:81
   CYW43_LINK_NOIP : constant := (2);  --  cyw43.h:82
   CYW43_LINK_UP : constant := (3);  --  cyw43.h:83
   CYW43_LINK_FAIL : constant := (-1);  --  cyw43.h:84
   CYW43_LINK_NONET : constant := (-2);  --  cyw43.h:85
   CYW43_LINK_BADAUTH : constant := (-3);  --  cyw43.h:86
   --  unsupported macro: CYW43_DEFAULT_PM cyw43_pm_value(CYW43_PM2_POWERSAVE_MODE, 200, 1, 1, 10)
   --  unsupported macro: CYW43_AGGRESSIVE_PM cyw43_pm_value(CYW43_PM2_POWERSAVE_MODE, 2000, 1, 1, 10)
   --  unsupported macro: CYW43_PERFORMANCE_PM cyw43_pm_value(CYW43_PM2_POWERSAVE_MODE, 20, 1, 1, 1)

   type anon1238_array1073 is array (0 .. 31) of aliased UInt8;
   type anon1238_array1250 is array (0 .. 63) of aliased UInt8;
   type anon1238_array901 is array (0 .. 5) of aliased UInt8;
   type u_cyw43_t is record
      cyw43_ll : aliased cyw43_ll_h.cyw43_ll_t;  -- cyw43.h:90
      itf_state : aliased UInt8;  -- cyw43.h:92
      trace_flags : aliased UInt32;  -- cyw43.h:93
      wifi_scan_state : aliased UInt32;  -- cyw43.h:96
      wifi_join_state : aliased UInt32;  -- cyw43.h:97
      wifi_scan_env : System.Address;  -- cyw43.h:98
      wifi_scan_cb : access function (arg1 : System.Address; arg2 : access constant cyw43_ll_h.cyw43_ev_scan_result_t) return int;  -- cyw43.h:99
      initted : aliased Extensions.bool;  -- cyw43.h:101
      pend_disassoc : aliased Extensions.bool;  -- cyw43.h:103
      pend_rejoin : aliased Extensions.bool;  -- cyw43.h:104
      pend_rejoin_wpa : aliased Extensions.bool;  -- cyw43.h:105
      ap_auth : aliased UInt32;  -- cyw43.h:108
      ap_channel : aliased UInt8;  -- cyw43.h:109
      ap_ssid_len : aliased UInt8;  -- cyw43.h:110
      ap_key_len : aliased UInt8;  -- cyw43.h:111
      ap_ssid : aliased anon1238_array1073;  -- cyw43.h:112
      ap_key : aliased anon1238_array1250;  -- cyw43.h:113
      mac : aliased anon1238_array901;  -- cyw43.h:126
   end record
   with Convention => C_Pass_By_Copy;  -- cyw43.h:89

   subtype cyw43_t is u_cyw43_t;  -- cyw43.h:127

   cyw43_state : aliased cyw43_t  -- cyw43.h:129
   with Import => True,
        Convention => C,
        External_Name => "cyw43_state";

   cyw43_poll : access procedure  -- cyw43.h:130
   with Import => True,
        Convention => C,
        External_Name => "cyw43_poll";

   cyw43_sleep : aliased UInt32  -- cyw43.h:131
   with Import => True,
        Convention => C,
        External_Name => "cyw43_sleep";

   procedure cyw43_init (self : access cyw43_t)  -- cyw43.h:140
   with Import => True,
        Convention => C,
        External_Name => "cyw43_init";

   procedure cyw43_deinit (self : access cyw43_t)  -- cyw43.h:149
   with Import => True,
        Convention => C,
        External_Name => "cyw43_deinit";

   function cyw43_ioctl
     (self : access cyw43_t;
      cmd : UInt32;
      len : size_t;
      buf : access UInt8;
      iface : UInt32) return int  -- cyw43.h:163
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ioctl";

   function cyw43_send_ethernet
     (self : access cyw43_t;
      itf : int;
      len : size_t;
      buf : System.Address;
      is_pbuf : Extensions.bool) return int  -- cyw43.h:177
   with Import => True,
        Convention => C,
        External_Name => "cyw43_send_ethernet";

   function cyw43_wifi_pm (self : access cyw43_t; pm : UInt32) return int  -- cyw43.h:194
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_pm";

   function cyw43_wifi_get_pm (self : access cyw43_t; pm : access UInt32) return int  -- cyw43.h:212
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_get_pm";

   function cyw43_wifi_link_status (self : access cyw43_t; itf : int) return int  -- cyw43.h:234
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_link_status";

   procedure cyw43_wifi_set_up
     (self : access cyw43_t;
      itf : int;
      up : Extensions.bool;
      country : UInt32)  -- cyw43.h:251
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_set_up";

   function cyw43_wifi_get_mac
     (self : access cyw43_t;
      itf : int;
      mac : access UInt8) return int  -- cyw43.h:263
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_get_mac";

   function cyw43_wifi_scan
     (self : access cyw43_t;
      opts : access cyw43_ll_h.cyw43_wifi_scan_options_t;
      env : System.Address;
      result_cb : access function (arg1 : System.Address; arg2 : access constant cyw43_ll_h.cyw43_ev_scan_result_t) return int) return int  -- cyw43.h:278
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_scan";

   function cyw43_wifi_scan_active (self : access cyw43_t) return Extensions.bool  -- cyw43.h:288
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_scan_active";

   function cyw43_wifi_join
     (self : access cyw43_t;
      ssid_len : size_t;
      ssid : access UInt8;
      key_len : size_t;
      key : access UInt8;
      auth_type : UInt32;
      bssid : access UInt8;
      channel : UInt32) return int  -- cyw43.h:311
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_join";

   function cyw43_wifi_leave (self : access cyw43_t; itf : int) return int  -- cyw43.h:322
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_leave";

   procedure cyw43_wifi_ap_get_ssid
     (self : access cyw43_t;
      len : access size_t;
      buf : System.Address)  -- cyw43.h:333
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_ap_get_ssid";

   function cyw43_wifi_ap_get_auth (self : access cyw43_t) return UInt32  -- cyw43.h:346
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_ap_get_auth";

   procedure cyw43_wifi_ap_set_channel (self : access cyw43_t; channel : UInt32)  -- cyw43.h:358
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_ap_set_channel";

   procedure cyw43_wifi_ap_set_ssid
     (self : access cyw43_t;
      len : size_t;
      buf : access UInt8)  -- cyw43.h:371
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_ap_set_ssid";

   procedure cyw43_wifi_ap_set_password
     (self : access cyw43_t;
      len : size_t;
      buf : access UInt8)  -- cyw43.h:385
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_ap_set_password";

   procedure cyw43_wifi_ap_set_auth (self : access cyw43_t; auth : UInt32)  -- cyw43.h:405
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_ap_set_auth";

   procedure cyw43_wifi_ap_get_max_stas (self : access cyw43_t; max_stas : access int)  -- cyw43.h:418
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_ap_get_max_stas";

   procedure cyw43_wifi_ap_get_stas
     (self : access cyw43_t;
      num_stas : access int;
      macs : access UInt8)  -- cyw43.h:432
   with Import => True,
        Convention => C,
        External_Name => "cyw43_wifi_ap_get_stas";

   function cyw43_is_initialized (self : access cyw43_t) return Extensions.bool  -- cyw43.h:442
   with Import => True,
        Convention => C,
        External_Name => "cyw43_is_initialized";

   procedure cyw43_cb_tcpip_init (self : access cyw43_t; itf : int)  -- cyw43.h:455
   with Import => True,
        Convention => C,
        External_Name => "cyw43_cb_tcpip_init";

   procedure cyw43_cb_tcpip_deinit (self : access cyw43_t; itf : int)  -- cyw43.h:466
   with Import => True,
        Convention => C,
        External_Name => "cyw43_cb_tcpip_deinit";

   procedure cyw43_cb_tcpip_set_link_up (self : access cyw43_t; itf : int)  -- cyw43.h:478
   with Import => True,
        Convention => C,
        External_Name => "cyw43_cb_tcpip_set_link_up";

   procedure cyw43_cb_tcpip_set_link_down (self : access cyw43_t; itf : int)  -- cyw43.h:489
   with Import => True,
        Convention => C,
        External_Name => "cyw43_cb_tcpip_set_link_down";

   function cyw43_tcpip_link_status (self : access cyw43_t; itf : int) return int  -- cyw43.h:511
   with Import => True,
        Convention => C,
        External_Name => "cyw43_tcpip_link_status";

   function cyw43_pm_value
     (pm_mode : UInt8;
      pm2_sleep_ret_ms : UInt16;
      li_beacon_period : UInt8;
      li_dtim_period : UInt8;
      li_assoc : UInt8) return UInt32  -- cyw43.h:563
   with Import => True,
        Convention => C,
        External_Name => "cyw43_pm_value";

end cyw43_h;
