#!/bin/bash

mkdir -p logs
exec >> logs/health-check.log 2>&1

echo ""
echo "=================================="
echo "HEALTH CHECK STARTED: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=================================="

echo "=================================="
echo "   LINUX SERVER HEALTH CHECK"
echo "=================================="

echo ""
echo "OVERALL CPU UTILISATION"
echo "----------------------------------"

read user1 nice1 system1 idle1 iowait1 irq1 softirq1 steal1 < <(awk '$1 == "cpu" {print $2, $3, $4, $5, $6, $7, $8, $9; exit}' /proc/stat)

sleep 1

read user2 nice2 system2 idle2 iowait2 irq2 softirq2 steal2 < <(awk '$1 == "cpu" {print $2, $3, $4, $5, $6, $7, $8, $9; exit}' /proc/stat)

total_delta=$(( (user2-user1) + (nice2-nice1) + (system2-system1) + (idle2-idle1) + (iowait2-iowait1) + (irq2-irq1) + (softirq2-softirq1) + (steal2-steal1) ))

idle_delta=$((idle2-idle1))
iowait_delta=$((iowait2-iowait1))

non_idle_delta=$((total_delta - idle_delta - iowait_delta))

if [ "$total_delta" -gt 0 ]; then
    awk -v busy="$non_idle_delta" -v total="$total_delta" 'BEGIN {printf "Overall CPU Usage: %.2f%%\n", (busy / total) * 100}'
else
    echo "Unable to calculate CPU utilisation."
fi

echo ""
echo "DISK SPACE CHECK"
echo "----------------------------------"
df -h

echo ""
echo "MEMORY USAGE CHECK"
echo "----------------------------------"
free -h

echo ""
echo "TOP CPU-CONSUMING PROCESSES"
echo "----------------------------------"
ps aux --sort=-%cpu | head -n 10

echo ""
echo "FAILED SERVICES CHECK"
echo "----------------------------------"
systemctl --failed

echo ""
echo "RECENT SYSTEM ERROR LOGS"
echo "----------------------------------"
journalctl -p err --since "30 minutes ago" --no-pager

