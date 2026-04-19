#!/bin/bash
# Ripple NAISC overnight WA alert loop
# Fires to Recipe 7 every 60 min, varied HR values

LOG=~/tmp/ripple_overnight.log
RECIPE7='https://webhooks.trial.workato.com/webhooks/rest/75c7e434-bc99-44b9-99e7-705948d0a35d/ripple-live-alert'
INTERVAL=3600  # 60 min

# Schedule: t+0 already sent manually, these are t+60..t+300
HR_VALUES=(152 177 148 168 183)
NOTES=("stress spike" "mid-sleep startle" "REM dream spike" "early-morning rise" "wake-up anomaly")

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Overnight loop START (${#HR_VALUES[@]} alerts, ${INTERVAL}s apart)" >> $LOG

for i in "${!HR_VALUES[@]}"; do
  sleep $INTERVAL
  HR=${HR_VALUES[$i]}
  NOTE=${NOTES[$i]}
  TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  IDX=$((i+2))  # alert 2..6
  TS_LOCAL=$(date '+%Y-%m-%d %H:%M:%S')
  
  echo "[$TS_LOCAL] Firing alert #${IDX} HR=${HR} note=${NOTE}" >> $LOG
  
  RESP=$(curl -s -w "\nHTTP %{http_code} t=%{time_total}s" -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"metric\":\"heart_rate\",\"value\":${HR},\"unit\":\"bpm\",\"source\":\"claude_overnight_${IDX}\",\"ts\":\"${TS}\",\"note\":\"${NOTE}\"}" \
    "$RECIPE7")
  echo "$RESP" >> $LOG
  echo "" >> $LOG
done

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Overnight loop END" >> $LOG
