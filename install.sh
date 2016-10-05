#!/bin/bash
# Auto install for 8192cu
# September, 1 2010 v1.0.0, willisTang
#
# Add make_drv to select chip type
# Novembor, 21 2011 v1.1.0, Jeff Hung
################################################################################

echo "##################################################"
echo "Realtek Wi-Fi driver Auto installation script"
echo "Novembor, 21 2011 v1.1.0"
echo "##################################################"

################################################################################
#			Decompress the driver source tar ball
################################################################################
cd driver
Drvfoulder=`ls |grep .tar.gz`
echo "Decompress the driver source tar ball:"
echo "	"$Drvfoulder
tar zxvf $Drvfoulder

Drvfoulder=`ls |grep -iv '.tar.gz'`
echo "$Drvfoulder"
cd  $Drvfoulder

################################################################################
#			Recent GCCs error if the build is non-reproducible because of using the date or time macros. In the driver directory, add the following to the Makefile:
#			EXTRA_CFLAGS += -Wno-error=date-time
#
#			http://feiraspromove.com.br/posts/2015-12-08-Alfa-awus036ac.html
################################################################################
echo "EXTRA_CFLAGS += -Wno-error=date-time" > /tmp/tmp-makefile
cat Makefile >> /tmp/tmp-makefile
cp /tmp/tmp-makefile Makefile
cat Makefile

################################################################################
#			Edit [2016-05-03]: On upgrading to Ubuntu 16.04, with its 4.4 kernel,
#			there was an additional change. In the driver directory, in rtw_debug.h,
#			there are a couple errors because seq_printf is void, not int.
#			So, there are two places where you’ll need to get rid of the if surrounding
#			use of _seqdump, which is on lines 232 and 242.
#
# 		http://feiraspromove.com.br/posts/2015-12-08-Alfa-awus036ac.html
################################################################################
affectedKernel="4.4"
IN=`uname -r`
arrIN=(${IN//./ })
KernelVersion=""
for i in "${!arrIN[@]}"
do
   :
   # do whatever on $i
   if (($i > 0)); then
   	KernelVersion="$KernelVersion."
   fi
   KernelVersion="$KernelVersion${arrIN[$i]}"

   if (($i == 1)); then
   	break
   fi
done

if [ "$KernelVersion" = "$affectedKernel" ]; then
	sed -i '232s/.*/ _seqdump\(sel, fmt, ##arg\)\; \\/' include/rtw_debug.h
	sed -i '242s/.*/_seqdump\(sel, fmt, ##arg\)\; \\/' include/rtw_debug.h
fi

################################################################################
#			If makd_drv exixt, execute it to select chip type
################################################################################
if [ -e ./make_drv ]; then
	./make_drv
fi

################################################################################
#                       make clean
################################################################################
echo "Authentication requested [root] for make clean:"
if [ "`uname -r |grep fc`" == " " ]; then
        sudo su -c "make clean"; Error=$?
else
        su -c "make clean"; Error=$?
fi

################################################################################
#			Compile the driver
################################################################################
echo "Authentication requested [root] for make driver:"
if [ "`uname -r |grep fc`" == " " ]; then
	sudo su -c make; Error=$?
else	
	su -c make; Error=$?
fi
################################################################################
#			Check whether or not the driver compilation is done
################################################################################
module=`ls |grep -i 'ko'`
echo "##################################################"
if [ "$Error" != 0 ];then
	echo "Compile make driver error: $Error"
	echo "Please check error Mesg"
	echo "##################################################"
	exit
else
	echo "Compile make driver ok!!"	
	echo "##################################################"
fi

if [ "`uname -r |grep fc`" == " " ]; then
	echo "Authentication requested [root] for remove driver:"
	sudo su -c "rmmod $module"
	echo "Authentication requested [root] for insert driver:"
	sudo su -c "insmod $module"
	echo "Authentication requested [root] for install driver:"
	sudo su -c "make install"
else
	echo "Authentication requested [root] for remove driver:"
	su -c "rmmod $module"
	echo "Authentication requested [root] for insert driver:"
	su -c "insmod $module"
	echo "Authentication requested [root] for install driver:"
	su -c "make install"
fi
echo "##################################################"
echo "The Setup Script is completed !"
echo "##################################################"
