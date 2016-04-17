# AWUS036AC-linux

AWUS036AC Ubuntu linux driver.

This driver comes from Alfa Network:
[AWUS036AC driver](http://www.alfa.com.tw/download_show.php?combo_0=11)

Some fixes was needed to get driver working on Ubuntu:

 - file_path is now an exported symbol, there will be an error for redefinition: redeclared as different kind of symbol.
 - Avoid using strnicmp, since that's not in the c standard. 
   Quick hack was to put a #define strnicmp strncasecmp in `rtw_android.c` file. 

The driver should compile *out-of-the-box* on Ubuntu.

For more informations you can go on : http://feiraspromove.com.br/posts/2015-12-08-Alfa-awus036ac.html

To install the driver: 

`sudo ./install.sh`
