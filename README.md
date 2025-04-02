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
