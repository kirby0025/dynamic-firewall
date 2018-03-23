#!/bin/bash
#allow a dyndns name

HOSTNAME=dyn.hyrule.ovh
LOGFILE=/tmp/batch.update-firewall

Current_IP=$(host $HOSTNAME | cut -f4 -d' ')

if [ $LOGFILE = "" ] ; then
  iptables -I INPUT -i eth1 -s $Current_IP -j ACCEPT
  echo $Current_IP > $LOGFILE
else

  Old_IP=$(cat $LOGFILE)

  if [ "$Current_IP" = "$Old_IP" ] ; then
    echo IP address has not changed
  else
    iptables -D INPUT -i eth0 -s $Old_IP -j ACCEPT
    iptables -I INPUT -i eth0 -s $Current_IP -j ACCEPT
    /sbin/iptables-save > /etc/iptables/rules.v4 
    echo $Current_IP > $LOGFILE
    echo iptables have been updated
  fi
fi
