
extern  unsigned far      tdt_version (void);
extern  void far          tdt_mem (void);
extern  unsigned long far tdt_total_mem (void);
extern  unsigned long far tdt_free_mem (void);
extern  void far          tdt_reboot (void);
extern  void far          tdt_reboot_warm (void);
extern  void far          tdt_reboot_cold (void);
extern  void far          tdt_reboot_keyboard (void);
extern  void far          tdt_call_helper (union REGS *);
extern  void far          tdt_sendevent (unsigned event, unsigned param);
extern  unsigned far      tdt_inp (unsigned port);
extern  void far          tdt_outp (unsigned port, unsigned value);
extern  void tdt_getphys (ULONG physaddress, UCHAR *dest, UINT length);
extern  void tdt_setphys (ULONG physaddress, UCHAR *src, UINT length);
extern  void tdt_getlinear (ULONG linaddress, UCHAR *dest, UINT length);
extern  void tdt_setlinear (ULONG linaddress, UCHAR *src, UINT length);


