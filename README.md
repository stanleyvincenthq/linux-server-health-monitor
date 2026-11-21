# Linux Server Health Monitoring and Incident Investigation System

A Bash-based Linux monitoring and incident investigation project designed to collect system health information, monitor resource utilisation, and support basic troubleshooting through system logs.

## Project Overview

This project demonstrates practical Linux system administration, Bash scripting, system monitoring, and incident investigation.

The monitoring script collects system information, automatically creates the required log directory when missing, and appends results to a persistent log file for later review.

## Features

- **CPU Utilisation Monitoring:** Calculates overall CPU utilisation using two readings from `/proc/stat`.
- **Disk Space Monitoring:** Reports filesystem capacity and usage using `df`.
- **Memory Monitoring:** Displays memory and swap usage using `free`.
- **Process Monitoring:** Identifies the top CPU-consuming processes.
- **Failed Service Monitoring:** Checks for failed systemd units.
- **System Error Log Monitoring:** Retrieves recent error-level journal entries.
- **Persistent Logging:** Appends monitoring results and errors to a log file with execution timestamps.

## Project Structure

```text
linux-server-health-monitor/
├── reports/
│   └── wsl-incident-2026-10-26.md
├── scripts/
│   └── health-check.sh
├── logs/                 # Generated locally; excluded from Git
├── docs/
├── tests/
├── .gitignore
└── README.md
```

## Requirements

- Linux environment or Ubuntu on WSL2
- Bash
- systemd
- systemd journal (`journalctl`)
- Standard Linux utilities: `df`, `free`, `ps`, `awk`, `sleep`

## Installation and Usage

Clone the repository:

```bash
git clone https://github.com/stanleyvincenthq/linux-server-health-monitor.git
```

Enter the project directory:

```bash
cd linux-server-health-monitor
```

Make the script executable if necessary:

```bash
chmod +x scripts/health-check.sh
```

Run the health check:

```bash
./scripts/health-check.sh
```

The script appends its output to:

```text
logs/health-check.log
```

Inspect the latest results:

```bash
tail -n 40 logs/health-check.log
```

## CPU Utilisation Calculation

The script reads cumulative CPU counters from `/proc/stat` twice, with a one-second interval between readings.

It calculates the difference between the readings to estimate CPU activity during that interval.

The calculation uses:

```text
CPU Usage (%) = (Non-idle CPU Time / Total CPU Time) × 100
```

Idle time and I/O wait time are excluded from the busy CPU time calculation.

## Incident Investigation

The project includes an incident report documenting WSL startup and connection-check errors observed on October 26, 2026.

The investigation uses:

- `journalctl` for system log analysis
- `systemctl` for service-state checks
- `getent` for DNS resolution checks
- `ping` for network connectivity testing
- `df` for disk usage checks

The original cause of the incident remains undetermined. The report documents the evidence and troubleshooting steps without making unsupported claims.

## Environment

Developed and tested using Ubuntu 22.04.5 LTS running on Windows Subsystem for Linux 2 (WSL2).

## Project Status

The core monitoring script and incident investigation report are implemented. Further development may include automated testing, alerting, and additional monitoring capabilities.

## Author

**stanleyvincenthq**

GitHub: [https://github.com/stanleyvincenthq](https://github.com/stanleyvincenthq)
