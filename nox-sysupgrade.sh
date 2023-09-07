#!/bin/sh

# Initialize the variable for set names
SET_NAMES=""

# Check the arguments
for arg in "$@"
do
    case $arg in
        --nox)
            SET_NAMES="${SET_NAMES} -x*"
            ;;
        --nogame)
            SET_NAMES="${SET_NAMES} -game*"
            ;;
        *)
            # Print an error for unknown arguments and exit
            echo "Error: Unknown argument $arg"
            exit 1
            ;;
    esac
done

# If no valid arguments are given, exit
if [ -z "${SET_NAMES}" ]; then
    echo "Error: No valid arguments provided. Use -nox or -nogame."
    exit 1
fi

# Run sysupgrade
sysupgrade -n

# Create file /auto_upgrade.conf
cat > /auto_upgrade.conf <<EOF
Location of sets = disk
Pathname to the sets = /home/_sysupgrade/
Set name(s) = ${SET_NAMES}
Set name(s) = done
Directory does not contain SHA256.sig. Continue without verification = yes
EOF

# show /auto_upgrade.conf
echo "show /auto_upgrade.conf:"
cat /auto_upgrade.conf

# Ask the user if they want to reboot
echo -n "Do you want to reboot now? (y/N): "; read choice

case $choice in
    [Yy]* )
        reboot
        ;;
    * )
        echo "Not rebooting. You can reboot manually when ready."
        ;;
esac
