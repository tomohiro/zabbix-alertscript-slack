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

extract-tag() {
  local message=$1
  local tag=$2
  echo "${message}" | awk -F "${tag}: " '{ print $2 }' | tr -d '\012'
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

host=$(extract-tag "${message}" 'Host conn')
event_id=$(extract-tag "${message}" 'Event ID')
trigger=$(extract-tag "${message}" 'Trigger')
trigger_id=$(extract-tag "${message}" 'Trigger ID')
url="https://${host}/tr_events.php?triggerid=${trigger_id}&eventid=${event_id}"

status=$(extract-tag "${message}" 'Trigger status')
severity=$(extract-tag "${message}" 'Trigger severity')
item_name=$(extract-tag "${message}" 'Item name')
item_value=$(extract-tag "${message}" 'Item value')
datetime=$(extract-tag "${message}" 'Datetime')

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
          \"title\": \"${item_name}\",
          \"value\": \"${item_value}\",
          \"short\": true
        },
        {
          \"title\": \"Datetime\",
          \"value\": \"${datetime}\",
          \"short\": true
        }
      ]
    }
  ]
}"

echo "[$(date)] notification to ${channel}"
curl --data-urlencode "${payload}" "${webhook_url}"
