#!/bin/bash

echo "=== Explicitly installed packages ==="
pacman -Qe > packages-explicit.txt

echo "=== AUR packages ==="
pacman -Qm > packages-aur.txt

echo "=== Enabled systemd services ==="
systemctl list-unit-files --state=enabled --no-pager > services-enabled.txt

echo "=== fstab ==="
cat /etc/fstab > fstab.backup

echo "Done! Review the generated files."
