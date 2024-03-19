#!/bin/bash
# the time function for auditreduce is honestly not great, and the greatest accuracy i can get is down to the hour
settime="$(date -v-120M "+%Y%m%d%H")"
now="$(date -v-60M "+%Y%m%d%H")"

# seek file logic taken from the auditd input rlog in splunks app
SEEK_FILE=$SPLUNK_HOME/var/run/splunk/bsm_audit_seekfile

if [ -e $SEEK_FILE ] ; then
	SEEK=`head -1 $SEEK_FILE`
else
	SEEK=19910101
	echo "19910101" > $SEEK_FILE
fi


auditreduce -a $SEEK -b $now /var/audit/* | praudit 2>/dev/null

echo $now > $SEEK_FILE

exit 0
