#!/bin/sh
args="-DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++"
use_auth=""
rootcmd () {
	if [ "$use_auth" = "su" ]; then
		su root -c "`echo $@`"
	else
		$use_auth $@
	fi
}
for auth in doas sudo su; do
	which $auth >/dev/null 2>&1
	if [ "$?" = "0" ]; then
		echo "$auth would work (probably)"
		use_auth="$auth"
		break
	fi
done
for i in $@; do
	case "$i" in
		--prefix=*)
			args="$args -DCMAKE_INSTALL_PREFIX=`echo $i | sed "s/--prefix=//g"`"
			rootcmd ln -fs `echo $i | sed "s/--prefix=//g"`/bin/moc-qt1 /usr/bin/moc-qt1
			LD_LIBRARY_PATH="$LD_LIBRARY_PATH:`echo $i | sed "s/--prefix=//g"`/lib"
			export LD_LIBRARY_PATH
			;;
	esac
done
count=`grep processor /proc/cpuinfo | wc -l | sed "s/ //g"`
if [ "$count" = "0" ]; then
	count=4
fi

for i in qt1 kdelibs kdebase kdegames kdeutils; do
	echo "--- $i"
	mkdir -p $i/build
	cd $i/build
	if [ ! -e "configured" ]; then
		cmake .. $args || exit 1
		touch configured
	fi
	if [ ! -e "built" ]; then
		make -j$count || exit 1
		touch built
	fi
	if [ ! -e "installed" ]; then
		rootcmd make install || exit 1
		touch installed
	fi
	cd ../..
done
