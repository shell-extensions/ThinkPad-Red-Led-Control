# PR notes (sudo helper)

## Aenderungen
- Ersetzt pkexec-Aufrufe durch sudo -n + Helper unter /usr/local/bin/thinkpad-red-led-helper.
- Fuegt "Setup Helper" Aktion mit sudoers-Anleitung hinzu (Standardpfad ~/.local/share/...).
- Fuegt tools/thinkpad-red-led-helper hinzu (root helper fuer on/off/blink/morse).
- Validiert Morse-Input (0-9, a-z, space) vor dem Helper-Aufruf.

## Warum
- pkexec/Polkit scheitert in manchen Umgebungen mit "Check your credentials".
- Vermeidet staendige Passwortabfragen nach einmaligem sudoers-Eintrag.

## Setup fuer Nutzer
- Helper installieren und sudoers setzen:
  EXT_SRC="$HOME/.local/share/gnome-shell/extensions/thinkpad-red-led@juanmagd.dev/tools/thinkpad-red-led-helper"
  sudo install -o root -g root -m 0755 "$EXT_SRC" /usr/local/bin/thinkpad-red-led-helper
  sudo visudo -f /etc/sudoers.d/thinkpad-red-led
  $USER ALL=(root) NOPASSWD: /usr/local/bin/thinkpad-red-led-helper
- Bei systemweiter Installation:
  EXT_SRC="/usr/share/gnome-shell/extensions/thinkpad-red-led@juanmagd.dev/tools/thinkpad-red-led-helper"

## Test
- Extension laden, "Setup Helper" anzeigen, LED on/off/blink/morse pruefen.
