# Aktueller Stand (Snapshot)

## Kontext
- Repo: thinkpad-red-led@juanmagd.dev
- Installierte Kopie gespiegelt: ~/.local/share/gnome-shell/extensions/thinkpad-red-led@juanmagd.dev

## Funktion
- Extension ruft /usr/local/bin/thinkpad-red-led-helper via sudo -n auf.
- LED Aktionen: on/off/blink/morse; UI startet mit "Led On".
- Kein Persistieren des LED-Status ueber Reboot.

## Helper
- Schreibt ueber ec_sys nach /sys/kernel/debug/ec/ec0/io.
- write_support wird via modprobe gesetzt; kann durch Kernel Lockdown/Secure Boot blockiert sein.
- Setup ueber install.sh bzw. "Setup Helper" Dialog.

## Bisherige Eintraege
- PR_NOTES.md: ByteArray-Import entfernt, TextDecoder genutzt (GNOME 46+ Fix).
