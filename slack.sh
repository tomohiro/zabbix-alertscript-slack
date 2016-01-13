#!/bin/bash
#
# Usage:
#
#   $ ./slack.sh <channel> <subject> <message>
#
# Example:
#
#   $ ./slack.sh "#alerts" "[PROBREM] unreachable httpd" "This is example"
#
# References:
#
#   Custom alertscripts document
#   https://www.zabbix.com/documentation/2.4/manual/config/notifications/media/script

if [ -z "$SLACK_WEBHOOK_URL" ]; then
  echo 'Please set the Slack webhook url to `SLACK_WEBHOOK_URL`.'
  exit 1
fi

if [ -z "$ZABBIX_ENDPOINT" ]; then
  echo 'Please set the Zabbix server url to `ZABBIX_ENDPOINT`.'
  exit 1
fi


extract-tag() {
  local message=$1
  local tag=$2
  echo "${message}" | awk -F "${tag}: " '{ print $2 }' | tr -d '\r\n'
}

triage() {
  local severity=$1
  local status=$1

  if [ $status = 'OK' ]; then
    color='good'
  elif [ $status = 'PROBLEM' ]; then
    if [ $severity = 'Information' ]; then
      color='warning'
    elif [ $severity = 'Warning' ]; then
      color='warning'
    else
      color='danger'
    fi
  else
    color=''
  fi
  echo $color
}

webhook_url="${SLACK_WEBHOOK_URL}"
username="zabbix"
channel="$1"
subject="$2"
message="$3"

event_id=$(extract-tag "${message}" 'Event ID')
trigger=$(extract-tag "${message}" 'Trigger')
trigger_id=$(extract-tag "${message}" 'Trigger ID')
url="${ZABBIX_ENDPOINT}/tr_events.php?triggerid=${trigger_id}&eventid=${event_id}"

status=$(extract-tag "${message}" 'Trigger status')
severity=$(extract-tag "${message}" 'Trigger severity')
item_name=$(extract-tag "${message}" 'Item name')
item_value=$(extract-tag "${message}" 'Item value')
datetime=$(extract-tag "${message}" 'DateTime')
host=$(extract-tag "${message}" 'Host')
address=$(extract-tag "${message}" 'IP address')

color=$(triage "${status}" "${severity}")

payload="payload={
  \"channel\": \"${channel}\",
  \"username\": \"${username}\",
  \"text\": \"<${url}|${trigger}>\",
  \"attachments\": [
    {
      \"color\": \"${color}\",
      \"fields\": [
        {
          \"title\": \"Host\",
          \"value\": \"${host}\",
          \"short\": true
        },
        {
          \"title\": \"IP address\",
          \"value\": \"${address}\",
          \"short\": true
        },
        {
          \"title\": \"Severity\",
          \"value\": \"${severity}\",
          \"short\": true
        },
        {
          \"title\": \"Status\",
          \"value\": \"${status}\",
          \"short\": true
        },
        {
          \"title\": \"Item\",
          \"value\": \"${item_name} is ${item_value}\",
          \"short\": true
        },
        {
          \"title\": \"DateTime\",
          \"value\": \"${datetime}\",
          \"short\": true
        }
      ]
    }
  ]
}"

echo "[$(date)] notification to ${channel}"
curl --data-urlencode "${payload}" "${webhook_url}"
