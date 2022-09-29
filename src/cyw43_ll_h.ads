pragma Ada_2012;
pragma Style_Checks (Off);

with Interfaces; use Interfaces;
with Interfaces.C; use Interfaces.C;
with System;
with Interfaces.C.Extensions;
with HAL; use HAL;

package cyw43_ll_h is

   CYW43_IOCTL_GET_SSID : constant := (16#32#);  --  cyw43_ll.h:54
   CYW43_IOCTL_GET_CHANNEL : constant := (16#3a#);  --  cyw43_ll.h:55
   CYW43_IOCTL_SET_DISASSOC : constant := (16#69#);  --  cyw43_ll.h:56
   CYW43_IOCTL_GET_ANTDIV : constant := (16#7e#);  --  cyw43_ll.h:57
   CYW43_IOCTL_SET_ANTDIV : constant := (16#81#);  --  cyw43_ll.h:58
   CYW43_IOCTL_SET_MONITOR : constant := (16#d9#);  --  cyw43_ll.h:59
   CYW43_IOCTL_GET_VAR : constant := (16#20c#);  --  cyw43_ll.h:60
   CYW43_IOCTL_SET_VAR : constant := (16#20f#);  --  cyw43_ll.h:61

   CYW43_EV_SET_SSID : constant := (0);  --  cyw43_ll.h:64
   CYW43_EV_JOIN : constant := (1);  --  cyw43_ll.h:65
   CYW43_EV_AUTH : constant := (3);  --  cyw43_ll.h:66
   CYW43_EV_DEAUTH : constant := (5);  --  cyw43_ll.h:67
   CYW43_EV_DEAUTH_IND : constant := (6);  --  cyw43_ll.h:68
   CYW43_EV_ASSOC : constant := (7);  --  cyw43_ll.h:69
   CYW43_EV_DISASSOC : constant := (11);  --  cyw43_ll.h:70
   CYW43_EV_DISASSOC_IND : constant := (12);  --  cyw43_ll.h:71
   CYW43_EV_LINK : constant := (16);  --  cyw43_ll.h:72
   CYW43_EV_PRUNE : constant := (23);  --  cyw43_ll.h:73
   CYW43_EV_PSK_SUP : constant := (46);  --  cyw43_ll.h:74
   CYW43_EV_ESCAN_RESULT : constant := (69);  --  cyw43_ll.h:75
   CYW43_EV_CSA_COMPLETE_IND : constant := (80);  --  cyw43_ll.h:76
   CYW43_EV_ASSOC_REQ_IE : constant := (87);  --  cyw43_ll.h:77
   CYW43_EV_ASSOC_RESP_IE : constant := (88);  --  cyw43_ll.h:78

   CYW43_STATUS_SUCCESS : constant := (0);  --  cyw43_ll.h:81
   CYW43_STATUS_FAIL : constant := (1);  --  cyw43_ll.h:82
   CYW43_STATUS_TIMEOUT : constant := (2);  --  cyw43_ll.h:83
   CYW43_STATUS_NO_NETWORKS : constant := (3);  --  cyw43_ll.h:84
   CYW43_STATUS_ABORT : constant := (4);  --  cyw43_ll.h:85
   CYW43_STATUS_NO_ACK : constant := (5);  --  cyw43_ll.h:86
   CYW43_STATUS_UNSOLICITED : constant := (6);  --  cyw43_ll.h:87
   CYW43_STATUS_ATTEMPT : constant := (7);  --  cyw43_ll.h:88
   CYW43_STATUS_PARTIAL : constant := (8);  --  cyw43_ll.h:89
   CYW43_STATUS_NEWSCAN : constant := (9);  --  cyw43_ll.h:90
   CYW43_STATUS_NEWASSOC : constant := (10);  --  cyw43_ll.h:91

   CYW43_SUP_DISCONNECTED : constant := (0);  --  cyw43_ll.h:94
   CYW43_SUP_CONNECTING : constant := (1);  --  cyw43_ll.h:95
   CYW43_SUP_IDREQUIRED : constant := (2);  --  cyw43_ll.h:96
   CYW43_SUP_AUTHENTICATING : constant := (3);  --  cyw43_ll.h:97
   CYW43_SUP_AUTHENTICATED : constant := (4);  --  cyw43_ll.h:98
   CYW43_SUP_KEYXCHANGE : constant := (5);  --  cyw43_ll.h:99
   CYW43_SUP_KEYED : constant := (6);  --  cyw43_ll.h:100
   CYW43_SUP_TIMEOUT : constant := (7);  --  cyw43_ll.h:101
   CYW43_SUP_LAST_BASIC_STATE : constant := (8);  --  cyw43_ll.h:102
   --  unsupported macro: CYW43_SUP_KEYXCHANGE_WAIT_M1 CYW43_SUP_AUTHENTICATED
   --  unsupported macro: CYW43_SUP_KEYXCHANGE_PREP_M2 CYW43_SUP_KEYXCHANGE
   --  unsupported macro: CYW43_SUP_KEYXCHANGE_WAIT_M3 CYW43_SUP_LAST_BASIC_STATE

   CYW43_SUP_KEYXCHANGE_PREP_M4 : constant := (9);  --  cyw43_ll.h:106
   CYW43_SUP_KEYXCHANGE_WAIT_G1 : constant := (10);  --  cyw43_ll.h:107
   CYW43_SUP_KEYXCHANGE_PREP_G2 : constant := (11);  --  cyw43_ll.h:108

   CYW43_REASON_INITIAL_ASSOC : constant := (0);  --  cyw43_ll.h:111
   CYW43_REASON_LOW_RSSI : constant := (1);  --  cyw43_ll.h:112
   CYW43_REASON_DEAUTH : constant := (2);  --  cyw43_ll.h:113
   CYW43_REASON_DISASSOC : constant := (3);  --  cyw43_ll.h:114
   CYW43_REASON_BCNS_LOST : constant := (4);  --  cyw43_ll.h:115
   CYW43_REASON_FAST_ROAM_FAILED : constant := (5);  --  cyw43_ll.h:116
   CYW43_REASON_DIRECTED_ROAM : constant := (6);  --  cyw43_ll.h:117
   CYW43_REASON_TSPEC_REJECTED : constant := (7);  --  cyw43_ll.h:118
   CYW43_REASON_BETTER_AP : constant := (8);  --  cyw43_ll.h:119

   CYW43_REASON_PRUNE_ENCR_MISMATCH : constant := (1);  --  cyw43_ll.h:122
   CYW43_REASON_PRUNE_BCAST_BSSID : constant := (2);  --  cyw43_ll.h:123
   CYW43_REASON_PRUNE_MAC_DENY : constant := (3);  --  cyw43_ll.h:124
   CYW43_REASON_PRUNE_MAC_NA : constant := (4);  --  cyw43_ll.h:125
   CYW43_REASON_PRUNE_REG_PASSV : constant := (5);  --  cyw43_ll.h:126
   CYW43_REASON_PRUNE_SPCT_MGMT : constant := (6);  --  cyw43_ll.h:127
   CYW43_REASON_PRUNE_RADAR : constant := (7);  --  cyw43_ll.h:128
   CYW43_REASON_RSN_MISMATCH : constant := (8);  --  cyw43_ll.h:129
   CYW43_REASON_PRUNE_NO_COMMON_RATES : constant := (9);  --  cyw43_ll.h:130
   CYW43_REASON_PRUNE_BASIC_RATES : constant := (10);  --  cyw43_ll.h:131
   CYW43_REASON_PRUNE_CCXFAST_PREVAP : constant := (11);  --  cyw43_ll.h:132
   CYW43_REASON_PRUNE_CIPHER_NA : constant := (12);  --  cyw43_ll.h:133
   CYW43_REASON_PRUNE_KNOWN_STA : constant := (13);  --  cyw43_ll.h:134
   CYW43_REASON_PRUNE_CCXFAST_DROAM : constant := (14);  --  cyw43_ll.h:135
   CYW43_REASON_PRUNE_WDS_PEER : constant := (15);  --  cyw43_ll.h:136
   CYW43_REASON_PRUNE_QBSS_LOAD : constant := (16);  --  cyw43_ll.h:137
   CYW43_REASON_PRUNE_HOME_AP : constant := (17);  --  cyw43_ll.h:138
   CYW43_REASON_PRUNE_AP_BLOCKED : constant := (18);  --  cyw43_ll.h:139
   CYW43_REASON_PRUNE_NO_DIAG_SUPPORT : constant := (19);  --  cyw43_ll.h:140

   CYW43_REASON_SUP_OTHER : constant := (0);  --  cyw43_ll.h:143
   CYW43_REASON_SUP_DECRYPT_KEY_DATA : constant := (1);  --  cyw43_ll.h:144
   CYW43_REASON_SUP_BAD_UCAST_WEP128 : constant := (2);  --  cyw43_ll.h:145
   CYW43_REASON_SUP_BAD_UCAST_WEP40 : constant := (3);  --  cyw43_ll.h:146
   CYW43_REASON_SUP_UNSUP_KEY_LEN : constant := (4);  --  cyw43_ll.h:147
   CYW43_REASON_SUP_PW_KEY_CIPHER : constant := (5);  --  cyw43_ll.h:148
   CYW43_REASON_SUP_MSG3_TOO_MANY_IE : constant := (6);  --  cyw43_ll.h:149
   CYW43_REASON_SUP_MSG3_IE_MISMATCH : constant := (7);  --  cyw43_ll.h:150
   CYW43_REASON_SUP_NO_INSTALL_FLAG : constant := (8);  --  cyw43_ll.h:151
   CYW43_REASON_SUP_MSG3_NO_GTK : constant := (9);  --  cyw43_ll.h:152
   CYW43_REASON_SUP_GRP_KEY_CIPHER : constant := (10);  --  cyw43_ll.h:153
   CYW43_REASON_SUP_GRP_MSG1_NO_GTK : constant := (11);  --  cyw43_ll.h:154
   CYW43_REASON_SUP_GTK_DECRYPT_FAIL : constant := (12);  --  cyw43_ll.h:155
   CYW43_REASON_SUP_SEND_FAIL : constant := (13);  --  cyw43_ll.h:156
   CYW43_REASON_SUP_DEAUTH : constant := (14);  --  cyw43_ll.h:157
   CYW43_REASON_SUP_WPA_PSK_TMO : constant := (15);  --  cyw43_ll.h:158

   CYW43_WPA_AUTH_PSK : constant := (16#0004#);  --  cyw43_ll.h:161
   CYW43_WPA2_AUTH_PSK : constant := (16#0080#);  --  cyw43_ll.h:162

   CYW43_AUTH_OPEN : constant := (0);  --  cyw43_ll.h:170
   CYW43_AUTH_WPA_TKIP_PSK : constant := (16#00200002#);  --  cyw43_ll.h:171
   CYW43_AUTH_WPA2_AES_PSK : constant := (16#00400004#);  --  cyw43_ll.h:172
   CYW43_AUTH_WPA2_MIXED_PSK : constant := (16#00400006#);  --  cyw43_ll.h:173

   CYW43_NO_POWERSAVE_MODE : constant := (0);  --  cyw43_ll.h:179
   CYW43_PM1_POWERSAVE_MODE : constant := (1);  --  cyw43_ll.h:180
   CYW43_PM2_POWERSAVE_MODE : constant := (2);  --  cyw43_ll.h:181

   type anon899_array901 is array (0 .. 4) of aliased UInt32;
   type anon899_array904 is array (0 .. 5) of aliased UInt8;
   type anon899_array906 is array (0 .. 1) of aliased UInt16;
   type anon899_array909 is array (0 .. 31) of aliased UInt8;
   type u_cyw43_ev_scan_result_t is record
      u_0 : aliased anon899_array901;  -- cyw43_ll.h:199
      bssid : aliased anon899_array904;  -- cyw43_ll.h:200
      u_1 : aliased anon899_array906;  -- cyw43_ll.h:201
      ssid_len : aliased UInt8;  -- cyw43_ll.h:202
      ssid : aliased anon899_array909;  -- cyw43_ll.h:203
      u_2 : aliased anon899_array901;  -- cyw43_ll.h:204
      channel : aliased UInt16;  -- cyw43_ll.h:205
      u_3 : aliased UInt16;  -- cyw43_ll.h:206
      auth_mode : aliased UInt8;  -- cyw43_ll.h:207
      rssi : aliased Integer_16;  -- cyw43_ll.h:208
   end record
   with Convention => C_Pass_By_Copy;  -- cyw43_ll.h:198

   subtype cyw43_ev_scan_result_t is u_cyw43_ev_scan_result_t;  -- cyw43_ll.h:209

   type anon912_array914 is array (0 .. 29) of aliased UInt8;
   type anon912_union916 (discr : unsigned := 0) is record
      case discr is
         when others =>
            scan_result : aliased cyw43_ev_scan_result_t;  -- cyw43_ll.h:222
      end case;
   end record
   with Convention => C_Pass_By_Copy,
        Unchecked_Union => True;
   type u_cyw43_async_event_t is record
      u_0 : aliased UInt16;  -- cyw43_ll.h:213
      flags : aliased UInt16;  -- cyw43_ll.h:214
      event_type : aliased UInt32;  -- cyw43_ll.h:215
      status : aliased UInt32;  -- cyw43_ll.h:216
      reason : aliased UInt32;  -- cyw43_ll.h:217
      u_1 : aliased anon912_array914;  -- cyw43_ll.h:218
      c_interface : aliased UInt8;  -- cyw43_ll.h:219
      u_2 : aliased UInt8;  -- cyw43_ll.h:220
      u : aliased anon912_union916;  -- cyw43_ll.h:223
   end record
   with Convention => C_Pass_By_Copy;  -- cyw43_ll.h:212

   subtype cyw43_async_event_t is u_cyw43_async_event_t;  -- cyw43_ll.h:224

   type anon918_array909 is array (0 .. 31) of aliased UInt8;
   type anon918_array904 is array (0 .. 5) of aliased UInt8;
   type anon918_array919 is array (0 .. 0) of aliased UInt16;
   type u_cyw43_wifi_scan_options_t is record
      version : aliased UInt32;  -- cyw43_ll.h:231
      action : aliased UInt16;  -- cyw43_ll.h:232
      u_u : aliased UInt16;  -- cyw43_ll.h:233
      ssid_len : aliased UInt32;  -- cyw43_ll.h:234
      ssid : aliased anon918_array909;  -- cyw43_ll.h:235
      bssid : aliased anon918_array904;  -- cyw43_ll.h:236
      bss_type : aliased Integer_8;  -- cyw43_ll.h:237
      scan_type : aliased Integer_8;  -- cyw43_ll.h:238
      nprobes : aliased Integer_32;  -- cyw43_ll.h:239
      active_time : aliased Integer_32;  -- cyw43_ll.h:240
      passive_time : aliased Integer_32;  -- cyw43_ll.h:241
      home_time : aliased Integer_32;  -- cyw43_ll.h:242
      channel_num : aliased Integer_32;  -- cyw43_ll.h:243
      channel_list : aliased anon918_array919;  -- cyw43_ll.h:244
   end record
   with Convention => C_Pass_By_Copy;  -- cyw43_ll.h:230

   subtype cyw43_wifi_scan_options_t is u_cyw43_wifi_scan_options_t;  -- cyw43_ll.h:245

   type anon922_array924 is array (0 .. 532) of aliased UInt32;
   type u_cyw43_ll_t is record
      opaque : aliased anon922_array924;  -- cyw43_ll.h:249
   end record
   with Convention => C_Pass_By_Copy;  -- cyw43_ll.h:248

   subtype cyw43_ll_t is u_cyw43_ll_t;  -- cyw43_ll.h:250

   procedure cyw43_ll_init (self : access cyw43_ll_t; cb_data : System.Address)  -- cyw43_ll.h:252
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_init";

   procedure cyw43_ll_deinit (self : access cyw43_ll_t)  -- cyw43_ll.h:253
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_deinit";

   function cyw43_ll_bus_init (self : access cyw43_ll_t; mac : access UInt8) return int  -- cyw43_ll.h:255
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_bus_init";

   procedure cyw43_ll_bus_sleep (self : access cyw43_ll_t; can_sleep : Extensions.bool)  -- cyw43_ll.h:256
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_bus_sleep";

   procedure cyw43_ll_process_packets (self : access cyw43_ll_t)  -- cyw43_ll.h:257
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_process_packets";

   function cyw43_ll_ioctl
     (self : access cyw43_ll_t;
      cmd : UInt32;
      len : size_t;
      buf : access UInt8;
      iface : UInt32) return int  -- cyw43_ll.h:258
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_ioctl";

   function cyw43_ll_send_ethernet
     (self : access cyw43_ll_t;
      itf : int;
      len : size_t;
      buf : System.Address;
      is_pbuf : Extensions.bool) return int  -- cyw43_ll.h:259
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_send_ethernet";

   function cyw43_ll_wifi_on (self : access cyw43_ll_t; country : UInt32) return int  -- cyw43_ll.h:261
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_wifi_on";

   function cyw43_ll_wifi_pm
     (self : access cyw43_ll_t;
      pm : UInt32;
      pm_sleep_ret : UInt32;
      li_bcn : UInt32;
      li_dtim : UInt32;
      li_assoc : UInt32) return int  -- cyw43_ll.h:262
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_wifi_pm";

   function cyw43_ll_wifi_get_pm
     (self : access cyw43_ll_t;
      pm : access UInt32;
      pm_sleep_ret : access UInt32;
      li_bcn : access UInt32;
      li_dtim : access UInt32;
      li_assoc : access UInt32) return int  -- cyw43_ll.h:263
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_wifi_get_pm";

   function cyw43_ll_wifi_scan (self : access cyw43_ll_t; opts : access cyw43_wifi_scan_options_t) return int  -- cyw43_ll.h:264
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_wifi_scan";

   function cyw43_ll_wifi_join
     (self : access cyw43_ll_t;
      ssid_len : size_t;
      ssid : access UInt8;
      key_len : size_t;
      key : access UInt8;
      auth_type : UInt32;
      bssid : access UInt8;
      channel : UInt32) return int  -- cyw43_ll.h:266
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_wifi_join";

   procedure cyw43_ll_wifi_set_wpa_auth (self : access cyw43_ll_t)  -- cyw43_ll.h:267
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_wifi_set_wpa_auth";

   procedure cyw43_ll_wifi_rejoin (self : access cyw43_ll_t)  -- cyw43_ll.h:268
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_wifi_rejoin";

   function cyw43_ll_wifi_ap_init
     (self : access cyw43_ll_t;
      ssid_len : size_t;
      ssid : access UInt8;
      auth : UInt32;
      key_len : size_t;
      key : access UInt8;
      channel : UInt32) return int  -- cyw43_ll.h:270
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_wifi_ap_init";

   function cyw43_ll_wifi_ap_set_up (self : access cyw43_ll_t; up : Extensions.bool) return int  -- cyw43_ll.h:271
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_wifi_ap_set_up";

   function cyw43_ll_wifi_ap_get_stas
     (self : access cyw43_ll_t;
      num_stas : access int;
      macs : access UInt8) return int  -- cyw43_ll.h:272
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_wifi_ap_get_stas";

   function cyw43_ll_wifi_get_mac (self_in : access cyw43_ll_t; addr : access UInt8) return int  -- cyw43_ll.h:280
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_wifi_get_mac";

   function cyw43_ll_has_work (self : access cyw43_ll_t) return Extensions.bool  -- cyw43_ll.h:283
   with Import => True,
        Convention => C,
        External_Name => "cyw43_ll_has_work";

   function cyw43_cb_read_host_interrupt_pin (cb_data : System.Address) return int  -- cyw43_ll.h:286
   with Import => True,
        Convention => C,
        External_Name => "cyw43_cb_read_host_interrupt_pin";

   procedure cyw43_cb_ensure_awake (cb_data : System.Address)  -- cyw43_ll.h:287
   with Import => True,
        Convention => C,
        External_Name => "cyw43_cb_ensure_awake";

   procedure cyw43_cb_process_async_event (cb_data : System.Address; ev : access constant cyw43_async_event_t)  -- cyw43_ll.h:288
   with Import => True,
        Convention => C,
        External_Name => "cyw43_cb_process_async_event";

   procedure cyw43_cb_process_ethernet
     (cb_data : System.Address;
      itf : int;
      len : size_t;
      buf : access UInt8)  -- cyw43_ll.h:289
   with Import => True,
        Convention => C,
        External_Name => "cyw43_cb_process_ethernet";

end cyw43_ll_h;
