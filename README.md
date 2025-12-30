# ThinkPad Red LED Control Extension for GNOME

<p align="center">
  <img src="img/screenshot.png" alt="ThinkPad LED Control Screenshot">
</p>

This GNOME Shell extension allows you to control the red LED light on the back of ThinkPad laptops. With this extension, you can toggle between different LED states such as:

- **LED Off**
- **LED On**
- **LED Blinking**

The extension interacts directly with the kernel to manage the LED states via the **ec_sys** module.

<p align="center">
  <a href="https://extensions.gnome.org/extension/7820/thinkpad-red-led/">
    <img src="img/ego.svg" alt="Get it on GNOME Extensions">
  </a>
</p>

## Features

- **LED Control**: Turn the LED on, off, or make it blink
- **Morse Code Message**: Input a text message and the extension will flash the LED in Morse code
- **Boot Persistence**: Automatically restore LED state after reboot (requires helper setup)
- **No password prompts**: After initial setup, LED control works without authentication dialogs

## Installation

### From GNOME Extensions Website

The easiest way to install is from [GNOME Extensions](https://extensions.gnome.org/extension/7820/thinkpad-red-led/).

### Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/juanmagdev/ThinkPad-Red-Led-Control.git
   cd ThinkPad-Red-Led-Control
   ```

2. Copy to extensions directory:
   ```bash
   mkdir -p ~/.local/share/gnome-shell/extensions/thinkpad-red-led@juanmagd.dev
   cp -r * ~/.local/share/gnome-shell/extensions/thinkpad-red-led@juanmagd.dev/
   ```

3. Restart GNOME Shell (press `Alt+F2`, type `r`, press Enter) or log out and back in

4. Enable the extension using GNOME Extensions app or:
   ```bash
   gnome-extensions enable thinkpad-red-led@juanmagd.dev
   ```

## Helper Setup (Recommended)

The extension uses a helper script to control the LED without requiring password prompts each time. Run the install script to set it up:

```bash
./install.sh
```

This will:
- Install the helper to `/usr/local/bin/thinkpad-red-led-helper`
- Configure sudoers for passwordless execution
- Install and enable a systemd service for boot persistence

### Manual Helper Setup

If the install script doesn't work, you can set up the helper manually:

1. **Install the helper:**
   ```bash
   sudo install -o root -g root -m 0755 \
     ~/.local/share/gnome-shell/extensions/thinkpad-red-led@juanmagd.dev/tools/thinkpad-red-led-helper \
     /usr/local/bin/thinkpad-red-led-helper
   ```

2. **Configure sudoers:**
   ```bash
   sudo visudo -f /etc/sudoers.d/thinkpad-red-led
   ```
   Add this line (replace `YOUR_USERNAME` with your actual username):
   ```
   YOUR_USERNAME ALL=(root) NOPASSWD: /usr/local/bin/thinkpad-red-led-helper
   ```

3. **Enable boot persistence (optional):**
   ```bash
   sudo install -o root -g root -m 0644 \
     ~/.local/share/gnome-shell/extensions/thinkpad-red-led@juanmagd.dev/tools/thinkpad-red-led-restore.service \
     /etc/systemd/system/thinkpad-red-led-restore.service
   sudo systemctl daemon-reload
   sudo systemctl enable thinkpad-red-led-restore.service
   ```

## How It Works

The extension controls the ThinkPad LED by writing to the Embedded Controller (EC) interface at `/sys/kernel/debug/ec/ec0/io`.

### LED States

The LED state is controlled by the **12th byte** of the EC interface:

| State    | Hex Value | Description |
|----------|-----------|-------------|
| Off      | `0x0a`    | LED is off |
| On       | `0x8a`    | LED is on |
| Blinking | `0xca`    | LED blinks |

### Helper Commands

The helper script (`thinkpad-red-led-helper`) supports these commands:

```bash
sudo thinkpad-red-led-helper on      # Turn LED on
sudo thinkpad-red-led-helper off     # Turn LED off
sudo thinkpad-red-led-helper blink   # Make LED blink
sudo thinkpad-red-led-helper morse "text"  # Flash morse code
sudo thinkpad-red-led-helper restore # Restore last saved state
```

### Verifying LED State

You can check the current EC state with:

```bash
sudo hexdump -C /sys/kernel/debug/ec/ec0/io
```

Look at byte 12 (offset 0x0c) to see the current LED state.

## Troubleshooting

### "Failed to enable ec_sys write_support"

This can happen with Secure Boot or Kernel Lockdown enabled. Solutions:

1. **Add kernel parameter** (recommended):
   Add `ec_sys.write_support=1` to your kernel command line in GRUB

2. **Disable Secure Boot** (if acceptable for your setup)

### "LED path not writable"

The `ec_sys` module needs write support enabled. The helper tries multiple methods automatically, but if it fails:

```bash
# Check if module is loaded
lsmod | grep ec_sys

# Check write_support value
cat /sys/module/ec_sys/parameters/write_support
```

### Extension not appearing

1. Check if the extension is installed:
   ```bash
   gnome-extensions list | grep thinkpad
   ```

2. Check for errors:
   ```bash
   journalctl -f -o cat /usr/bin/gnome-shell
   ```

## TODOs

- [x] Support for GNOME 47, 48
- [x] Support for uppercase letters in Morse code
- [x] Boot persistence via systemd service
- [x] Replace pkexec with sudo helper
- [ ] Add more languages (currently English only)
- [ ] Interface to control Morse code speed

## Compatibility

- **GNOME**: 45, 46, 47, 48
- **ThinkPad models**: Models with the red LED on the back lid (most ThinkPad laptops)

## Credits

- **vali20** for the original idea: [ThinkPad LED Control under GNU/Linux](https://www.reddit.com/r/thinkpad/comments/7n8eyu/thinkpad_led_control_under_gnulinux/)
- **c5e3** for the Morse code script: [Morse Code Script](https://gist.github.com/c5e3/e0264a546b249b635349f2ee6c302f36)
- @yurijde for the persistance method, the sudo setup and fix some errors.

## Contributing

Contributions are welcome! Feel free to open pull requests with bug fixes or feature requests.

## License

This project is licensed under the MIT License.
