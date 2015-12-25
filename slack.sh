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

function extract-tag() {
    local message=$1
    local tag=$2
    echo "${message}" | awk -F "${tag}: " '{ print $2 }' | tr -d '\012'
}


webhook_url="${SLACK_WEBHOOK_URL}"
username="zabbix"
channel="$1"
subject="$2"
message="$3"
color="good"

payload="payload={
  \"channel\": \"${channel}\",
  \"username\": \"${username}\",
  \"attachments\": [
    {
      \"color\": \"${color}\",
      \"title\": \"${subject}\"
    }
  ]
}"

echo "[$(date)] notification to ${channel}"
curl --data-urlencode "${payload}" "${webhook_url}"
