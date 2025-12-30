# PR notes

## Aenderungen
- Entfernt den Import `resource:///org/gnome/shell/misc/byteArray.js` (existiert in GNOME 46+ nicht mehr).
- Fuegt `const TEXT_DECODER = new TextDecoder('utf-8');` hinzu.
- Ersetzt `ByteArray.toString(line)` durch `TEXT_DECODER.decode(line)`.

## Warum
- Behebt: `ImportError: Unable to load file from: resource:///org/gnome/shell/misc/byteArray.js`.

## PR Schritte
1) Fork des Repos erstellen (falls noetig): https://github.com/juanmagdev/ThinkPad-Red-Led-Control
2) Neuer Branch:
   - `git checkout -b fix/bytearray-import`
3) Aenderungen committen:
   - `git add extension.js PR_NOTES.md`
   - `git commit -m "Fix ByteArray import for GNOME 46+"`
4) Pushen:
   - `git push -u origin fix/bytearray-import`
5) Pull Request erstellen und im Text referenzieren:
   - Ursache (ByteArray Import fehlt in GNOME 46+)
   - Fix (TextDecoder Nutzung)
   - Test (Extension geladen / Fehler weg)
