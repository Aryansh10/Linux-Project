#!/bin/bash
# Real-Time Data Plotter from Multiple Sensors (Shell Simulation)

NUM_SENSORS=4
PLOT_INTERVAL=2   # seconds between plots
DATA_FILE="/tmp/sensor_data.txt"
RUNNING=true

# Clean up on exit
cleanup() {
    RUNNING=false
    rm -f "$DATA_FILE"
    echo -e "\n[INFO] Stopped all sensors and plotter."
    exit 0
}
trap cleanup SIGINT

# Initialize data file
> "$DATA_FILE"

# --- Sensor Simulation ---
sensor() {
    local id=$1
    while $RUNNING; do
        # Generate random sensor value (0–100)
        value=$((RANDOM % 101))
        timestamp=$(date +%s)
        echo "$id $value $timestamp" >> "$DATA_FILE"
        sleep $((RANDOM % 3 + 1))  # random delay between 1–3s
    done
}

# --- Plotter Function ---
plotter() {
    while $RUNNING; do
        clear
        echo "===== REAL-TIME SENSOR DATA PLOT ====="
        echo "Timestamp: $(date)"
        echo "--------------------------------------"

        # Read and aggregate data
        for ((i=1; i<=NUM_SENSORS; i++)); do
            latest=$(grep "^$i " "$DATA_FILE" | tail -1 | awk '{print $2}')
            if [ -z "$latest" ]; then
                latest=0
            fi

            # Make ASCII bar
            bar=$(printf "%-${latest}s" "#" | cut -c1-50)
            echo "Sensor $i: [${bar// /#}] ($latest)"
        done

        echo "--------------------------------------"
        echo "Press Ctrl+C to stop."
        sleep $PLOT_INTERVAL
    done
}

# Start sensor threads in background
echo "[INFO] Starting $NUM_SENSORS sensors..."
for ((i=1; i<=NUM_SENSORS; i++)); do
    sensor $i &
done

# Start the plotter
plotter


