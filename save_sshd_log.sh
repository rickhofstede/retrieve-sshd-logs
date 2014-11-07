#!/bin/bash

# Script for retrieving sshd logs from Linux and BSD machines.
#
# Author:   Rick Hofstede, University of Twente

HOSTNAME="$(hostname)"
DESTINATION_DIR="<path>" # Use full path; no trailing slash
TMP_DIR="/tmp" # No trailing slash

if [ "$(uname)" = "Darwin" ]; then
    # Determine date of yesterday
    y=`date -v -1d +%Y`
    m=`date -v -1d +%m`
    d=`date -v -1d +%d`

    # Retrieve sshd logs
    if [ -f /var/log/system.log.0.gz ]; then
        gzcat /var/log/system.log.0.gz | grep sshd >> ${TMP_DIR}/${HOSTNAME}_sshd_${y}${m}${d}
    elif [ -f /var/log/system.log.0.bz2 ]; then
        bzcat /var/log/system.log.0.bz2 | grep sshd >> ${TMP_DIR}/${HOSTNAME}_sshd_${y}${m}${d}
    else
        echo "Could not find log file; exiting..."
        exit 1
    fi
else
    # Determine date of yesterday
    y=`date -u -d "-1 day" +%Y`
    m=`date -u -d "-1 day" +%m`
    d=`date -u -d "-1 day" +%d`
    
    # Retrieve sshd logs
    if [ -f /var/log/auth.log.1 ]; then
        grep sshd /var/log/auth.log.1 >> ${TMP_DIR}/${HOSTNAME}_sshd_${y}${m}${d}
    elif [ -f /var/log/auth.log.1.gz ]; then
        gzcat /var/log/auth.log.1.gz | grep sshd >> ${TMP_DIR}/${HOSTNAME}_sshd_${y}${m}${d}
    elif [ -f /var/log/syslog.1.gz ]; then
        gzcat /var/log/syslog.1.gz | grep sshd >> ${TMP_DIR}/${HOSTNAME}_sshd_${y}${m}${d}
    else
        echo "Could not find log file; exiting..."
        exit 1
    fi
fi

# Compress result file
tar -czf ${DESTINATION_DIR}/${HOSTNAME}_sshd_${y}${m}${d}.tar.gz -C ${TMP_DIR} ${HOSTNAME}_sshd_${y}${m}${d}

# Remove temp file
rm ${TMP_DIR}/${HOSTNAME}_sshd_${y}${m}${d}
