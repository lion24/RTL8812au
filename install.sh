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
#			Recent GCCs error if the build is non-reproducible because of using the date or time macros. In the driver directory, add the following to the Makefile:
#			EXTRA_CFLAGS += -Wno-error=date-time
#
#			http://feiraspromove.com.br/posts/2015-12-08-Alfa-awus036ac.html
################################################################################
echo "EXTRA_CFLAGS += -Wno-error=date-time" > /tmp/tmp-makefile
cat Makefile >> /tmp/tmp-makefile
cp /tmp/tmp-makefile Makefile

################################################################################
#			Edit [2016-05-03]: On upgrading to Ubuntu 16.04, with its 4.4 kernel,
#			there was an additional change. In the driver directory, in rtw_debug.h,
#			there are a couple errors because seq_printf is void, not int.
#			So, there are two places where you’ll need to get rid of the if surrounding
#			use of _seqdump, which is on lines 232 and 242.
#
# 		http://feiraspromove.com.br/posts/2015-12-08-Alfa-awus036ac.html
################################################################################
AffectedKernels=("4.4")
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

for i in "${!AffectedKernels[@]}"
do
   :
   if [ "$KernelVersion" = "${AffectedKernels[$i]}" ]; then
		sed -i '232s/.*/ _seqdump\(sel, fmt, ##arg\)\; \\/' include/rtw_debug.h
		sed -i '242s/.*/_seqdump\(sel, fmt, ##arg\)\; \\/' include/rtw_debug.h
		break
   fi
done

################################################################################
#                       install via dkms
################################################################################

if [ $(dpkg-query -W -f='${Status}' dkms 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	echo "##################################################"
	echo -e "\nPackage 'dkms' is not installed."
	echo -e "Please install it using 'sudo apt-get install dkms -y'"
	echo -e "INSTALLATION FAILED!\n"
	echo "##################################################"
	exit 1
else
	sudo cp -R . /usr/src/rtl8812AU_linux-5.2.9
	sudo dkms add -m rtl8812AU_linux -v 5.2.9
	sudo dkms build -m rtl8812AU_linux -v 5.2.9
	sudo dkms install -m rtl8812AU_linux -v 5.2.9

	echo "##################################################"
	echo "The Setup Script is completed !"
	echo "##################################################"
fi
