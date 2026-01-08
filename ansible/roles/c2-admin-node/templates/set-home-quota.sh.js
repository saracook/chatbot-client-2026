#!/bin/bash 

# Parameters for quota POST request
# ssh c2-admin-01 /admin/bin/set-home-quota.sh
ISILON_USER="root"
ISILON_PASSWORD=$(wallet get file password/its-rc/carina-nero/c2-powerscale-h700-root-password)
QUOTA_SIZE=26843545600 # 25Gb
ISILON_URL="https://h700.mgmt.carina:8080/platform/8/quota/quotas"
JSON_DATA=$(cat <<EOF
{
  "include_snapshots": False,
  "path": "$HOMEBASE/$PAM_USER"
  "thresholds": {
    "hard": $QUOTA_SIZE
  },
  "type": "directory"
}
EOF
)

# Set quota on home directory
curl -k -u "${ISILON_USER}:${ISILON_PASSWORD}" \
  -X POST \
  -H "Content-Type: application/json" \
  -d "$JSON_DATA" \
  "$ISILON_URL"

