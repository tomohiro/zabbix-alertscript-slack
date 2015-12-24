#!/bin/bash

if [ -z "$SLACK_WEBHOOK_TOKEN" ]; then
  echo "Please set the Slack webhook token to `SLACK_WEBHOOK_TOKEN`."
  exit 1
fi

webhook_url="https://hooks.slack.com/services/${SLACK_WEBHOOK_TOKEN}"
username="zabbix"
channel="$1"
subject="$2"
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
