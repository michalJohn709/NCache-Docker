#!/bin/sh
while [ "$1" != "" ]; do
    case $1 in
	-d | --dotnethome )	shift
			DOTNETHOME=$1
			;;
				
	-i | --ipaddress )	shift
			IP=$1
			;;

	-p | --installpath )	shift
			DESTINATION=$1
			;;	

	-f | --firstname )	shift
			FIRST_NAME=$1
			;;

	-l | --lastname )	shift
			LAST_NAME=$1
			;;

	-c | --company )	shift
			COMPANY=$1
			;;
			
	-k | --installkey )	shift
			KEY=$1
			;;
	
	-m | --installmode )	shift
			INSTALLMODE=$1
			;;

	-e | --email )	shift
			EMAIL=$1
			;;
			
	-v | --verbose )
			VERBOSE="true"
			;;

	-h | --help )		
			exit
			;;

	* )	
			exit 1
    esac
    shift
done

if [ -z $DESTINATION ]
then 
	DESTINATION="/opt"
fi

if [ -z $PASSWORD ]
then
	PASSWORD="ncache"
fi

setup_file="ncache.pro.net.tar.gz"

if [ ! -e "$setup_file"  ]; then
    echo "Error: $setup_file does not exist."
	exit 1
fi

#--- Untaring and installing NCache
tar -zxf $setup_file
cd ncache-professional

./install --firstname $FIRST_NAME --lastname $LAST_NAME --email $EMAIL --company $COMPANY --installkey $KEY --installmode $INSTALLMODE

cd ..
#--- Removing installation resources
rm -f $setup_file
rm -rf ncache-professional/

mkdir /home/ncache
#--- Updating permissions and ownership
chmod -R 775 /home/ncache /opt/ncache/bin/service /opt/ncache/lib /opt/ncache/libexec 
chown -R ncache:root /app
chown -R ncache:ncache /home/ncache

#--- Adding the user to the root group
usermod -a -G root ncache

#--- Remove installer sh file, no more need from this point onwards
rm -f installncache.sh
