# AWUS036AC-linux
# Provides support for Jetson Nano

AWUS036AC Ubuntu linux driver.

This driver comes from Alfa Network:
[AWUS036AC driver](http://www.alfa.com.tw/download_show.php?combo_0=11)

Some fixes was needed to get driver working on Ubuntu:

 - file_path is now an exported symbol, there will be an error for redefinition: redeclared as different kind of symbol.
 - Avoid using strnicmp, since that's not in the c standard. 
   Quick hack was to put a #define strnicmp strncasecmp in `rtw_android.c` file. 
 - Recent GCCs error if the build is non-reproducible because of using the date or time macros. In the driver directory, add the following to the Makefile:
 `EXTRA_CFLAGS += -Wno-error=date-time`
 - On upgrading to Ubuntu 16.04, with its 4.4 kernel, there was an additional change. In the driver directory, in rtw_debug.h, there are a couple errors because seq_printf is void, not int. So, there are two places where you’ll need to get rid of the if surrounding use of _seqdump, which is on lines 232 and 242.

The driver should compile *out-of-the-box* on Ubuntu.

For more informations you can go on : http://feiraspromove.com.br/posts/2015-12-08-Alfa-awus036ac.html

To install the driver: 

`sudo ./install.sh`

## To compile on Jetson-Nano

```
CONFIG_PLATFORM_ARM_JET_NANO = y
CONFIG_PLATFORM_I386_PC = n
```

To test 
```
sudo insmod 8812au.ko
```







