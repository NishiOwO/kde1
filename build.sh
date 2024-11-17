#!/bin/sh
args="-DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++"
use_auth=""
rootcmd () {
	if [ "$use_auth" = "su" ]; then
		su root -c "$@"
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
			;;
	esac
done
count=`grep processor /proc/cpuinfo | wc -l | sed "s/ //g"`

echo "--- Qt1"
mkdir -p qt1/build
cd qt1/build
cmake .. $args || exit 1
make -j$count || exit 1
rootcmd make install || exit 1
cd ../..

echo "--- kdelibs"
mkdir -p kdelibs/build
cd kdelibs/build
cmake .. $args || exit 1
make -j$count || exit 1
rootcmd make install || exit 1
cd ../..

echo "--- kdebase"
mkdir -p kdebase/build
cd kdebase/build
cmake .. $args || exit 1
make -j$count || exit 1
rootcmd make install || exit 1
cd ../..
