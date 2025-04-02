# Hostname Rotator for macOS

This script rotates the macOS hostname (`HostName`, `LocalHostName`, `ComputerName`) by randomly selecting a template from `hostnames.txt` and generating random characters for placeholders.

This can be useful for making a machine blend into typical corporate network traffic by mimicking common device hostnames (printers, workstations, network devices, IoT, etc.).

## Features

*   Randomly selects a hostname template from a configurable list (`hostnames.txt`).
*   Replaces `{NUM}` placeholders with random digits (0-9).
*   Replaces `{HEX}` placeholders with random uppercase hexadecimal characters (0-9, A-F).
*   Sets `HostName`, `LocalHostName`, and `ComputerName` using `scutil`.
*   Requires `sudo` privileges to run.

## Usage

1.  **Clone the repository (or download the files).**
2.  **Review and customize `hostnames.txt`:** Add, remove, or modify templates as desired. Ensure placeholders `{NUM}` and `{HEX}` are used correctly.
3.  **Make the script executable:**
    ```bash
    chmod +x rotate_hostname.sh
    ```
4.  **Run the script with `sudo`:**
    ```bash
    sudo ./rotate_hostname.sh
    ```

    The script will output the selected template and the generated hostname.

**Note:** A system restart might be required for the new hostname to be recognized by all applications and services.

## Customization

Modify the `hostnames.txt` file to add or remove hostname patterns. Each line represents one template.

*   Use `{NUM}` for a random digit.
*   Use `{HEX}` for a random uppercase hex character.

## Requirements

*   macOS
*   Bash shell (standard on macOS)
*   Root privileges (`sudo`) to modify system settings.

## Scheduling (macOS)

To run this script automatically (e.g., daily), you can use `launchd`, macOS's service manager. This requires creating a `.plist` configuration file in `/Library/LaunchDaemons/`.

1.  **Create a `.plist` file:**
    Create a file named `com.yourdomain.rotatehostname.plist` (replace `yourdomain` with something relevant) in `/Library/LaunchDaemons/` using `sudo` and a text editor. Paste the following content, **making sure to replace the placeholder paths** with the actual full paths to the script and its directory:

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>com.yourdomain.rotatehostname</string> <!-- Choose a unique label -->

        <key>ProgramArguments</key>
        <array>
            <!-- Full path to your script -->
            <string>/path/to/your/script/rotate_hostname.sh</string>
        </array>

        <key>WorkingDirectory</key>
        <!-- Full path to the directory containing the script -->
        <string>/path/to/your/script/directory</string>

        <key>RunAtLoad</key>
        <false/>

        <key>StartCalendarInterval</key>
        <dict>
            <!-- Example: Run daily at 3:00 AM -->
            <key>Hour</key>
            <integer>3</integer>
            <key>Minute</key>
            <integer>0</integer>
        </dict>

        <!-- Optional: Redirect output/errors to logs -->
        <!--
        <key>StandardOutPath</key>
        <string>/var/log/rotatehostname.log</string>
        <key>StandardErrorPath</key>
        <string>/var/log/rotatehostname.error.log</string>
        -->

    </dict>
    </plist>
    ```

2.  **Set Permissions:**
    Ensure the file is owned by root:
    ```bash
    sudo chown root:wheel /Library/LaunchDaemons/com.yourdomain.rotatehostname.plist
    sudo chmod 644 /Library/LaunchDaemons/com.yourdomain.rotatehostname.plist
    ```

3.  **Load the Job:**
    Tell `launchd` to load and enable the job:
    ```bash
    sudo launchctl load -w /Library/LaunchDaemons/com.yourdomain.rotatehostname.plist
    ```

The script will now run automatically based on the `StartCalendarInterval` defined in the `.plist` file.
