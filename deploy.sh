#!/bin/sh

# Sample deployment script for sublima.
# Use -t to deploy as test (http://www.example.com/test/)

# Define appname here. The default is sublima, 
# http://www.example.com/sublima/

appname=sublima

source=/usr/src/sublima/sublima-webapp/target/sublima-webapp-1.0-SNAPSHOT.war
target_dir=/var/lib/tomcat5/webapps

if [ x$1 = x-t ]
then
    target=$target_dir/test
else
    target=$target_dir/$appname
fi

echo Deploying $target

cd $target_dir
mv $target.war $target.war.old

echo Waiting for tomcat to undeploy
while [ -d $target ] ; do sleep 1 ; done

# Re-deploying without restarting tomcat seems to cause a memory
# leak. YMMV.

sudo /etc/init.d/tomcat5 stop

cp $source $target.war
chmod 644 $target.war

sudo /etc/init.d/tomcat5 start

source=
target_dir=
target=
