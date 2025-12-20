# Plan: Boot-Persistenz (Variante 2)

Ziel: LED-Status nach einem Reboot automatisch wieder setzen.

Geplante Schritte:
1) Helper speichert letzten Zustand in /var/lib/thinkpad-red-led/state.
2) Helper erhaelt ein neues Kommando "restore", das den gespeicherten Zustand anwendet.
3) systemd Service (oneshot) ruft "thinkpad-red-led-helper restore" beim Boot auf.
4) install.sh installiert und aktiviert den Service.
5) Setup-Dialog ergaenzen (manuelle Schritte als Fallback).

Notizen:
- Secure Boot / Kernel Lockdown blockiert ec_sys write_support.
- Service sollte nach systemd-modules-load und debugfs-Mount laufen.
