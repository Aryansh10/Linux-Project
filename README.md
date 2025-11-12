I. How It Works

1. Multiple Simulated Sensors (Parallel Processes)

    Each sensor is a separate background process (launched using &).

    In a loop, each sensor repeatedly generates a random reading (a number between 0 and 100).

    Every new reading (which includes the sensor ID, its value, and a timestamp) is immediately appended to a shared log file located at /tmp/sensor_data.txt.

2. Central Data Collection

    The file /tmp/sensor_data.txt acts as the central, shared data repository.

    All sensor processes write their data into this single file, simulating how multiple physical sensors would send their telemetry to a central system or logging server. This file acts as a simple, thread-safe log.

3. Real-Time Plotting

    A dedicated function, the "plotter," runs continuously in the main part of the script.

    It performs a real-time refresh by clearing the terminal screen every few seconds.

    It then reads the shared file (/tmp/sensor_data.txt), uses tools like tail and awk to extract only the most recent reading for each unique sensor.

    Finally, it prints a simple ASCII bar graph in the console for each sensor, visualizing its latest value.

4. Clean Shutdown (Signal Handling)

    The script uses the trap command to ensure a graceful exit.

    When the user presses Ctrl+C, the trap handler executes:
       It stops all running background sensor processes.
       It removes the temporary data file (/tmp/sensor_data.txt), cleaning up the system before the script terminates.

II. Key Technologies & Commands

The script is built using Bash shell scripting and relies on:
        &: To launch the sensor functions as background processes.
        >>: For file redirection, appending data to the shared log file.
        trap: To handle the script interruption signal (Ctrl+C) for a clean exit.
        grep, awk, tail: Used by the plotter to parse and extract the latest data from the log file.
        sleep and RANDOM: For controlling timing and generating simulated sensor data.
        clear: To refresh the display for the real-time visualization effect.
