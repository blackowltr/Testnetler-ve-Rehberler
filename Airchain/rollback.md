# Automated Service Monitoring and Recovery Script

This script is designed to monitor the logs of the `tracksd` service and perform automatic recovery actions if specific errors are detected. It runs in an infinite loop, checking the logs every hour. If errors are found, it stops the necessary services, updates the application, runs a rollback, and restarts the services.

## Prerequisites

- Git
- Go programming language
- `systemctl` and `service` commands available on your system

## Usage

1. Save the script to a file, e.g., `monitor.sh`.
2. Make the script executable:
   ```bash
   chmod +x monitor.sh
   ```
3. Run the script:
   ```bash
   ./monitor.sh
   ```

## Script Breakdown

### Infinite Loop

The script runs in an infinite loop to continuously monitor the logs and take action when necessary.

```bash
while true
do
    ...
    sleep 3600
done
```

### Log Monitoring

The script checks the logs of the `tracksd` service for specific error messages using `journalctl`.

```bash
if journalctl -u tracksd -n 100 --no-pager --no-hostname -o cat | grep -Eq "rpc error: code = Unknown desc = failed to execute message|Failed to get transaction by hash: not found"; then
    ...
else
    echo "No error found, waiting for 1 hour..."
    sleep 3600
fi
```

### Error Handling and Recovery

If errors are found, the script performs the following actions:

1. **Stops the `cron` and `tracksd` services.**

   ```bash
   service cron stop
   systemctl stop tracksd
   ```

2. **Pulls the latest updates from the Git repository and builds the application.**

   ```bash
   git pull
   make build
   ```

3. **Runs the rollback process up to 5 times if needed.**

   ```bash
   for i in {1..5}
   do
       go run cmd/main.go rollback
       if [ $? -ne 0 ]; then
           echo "Rollback failed. Retrying..."
           continue 2
       fi
   done
   ```

4. **Restarts the `tracksd` and `cron` services.**

   ```bash
   systemctl restart tracksd
   service cron start
   ```

### Logging and Status Messages

The script outputs status messages to indicate the progress and any issues encountered during the process.

```bash
echo "Error found, initiating recovery process..."
...
echo "No error found, waiting for 1 hour..."
```

## Important Notes

- Ensure that the script has appropriate permissions to stop and start services, pull from Git, and run Go commands.
- The script sleeps for 1 hour (`3600` seconds) between checks to avoid excessive log monitoring and resource usage.

## Author

This script was created to automate the monitoring and recovery of services, ensuring minimal downtime and efficient error handling.

Feel free to modify any part as needed to better suit your specific use case or any additional details you wish to include.

[Follow me on X](https://x.com/brsbtc)
