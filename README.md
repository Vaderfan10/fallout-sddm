# Fallout SDDM

A Fallout-inspired SDDM login theme built for Qt 6 and SDDM 0.21+.

![Fallout SDDM login screen](Screenshots/fallout-login.png)

## Features

- Qt6 native (`sddm-greeter-qt6`)
- Fallout-style terminal boot sequence
- Randomized terminal typing sounds
- Power-on startup sound
- Power-off authentication sound
- Manual virtual keyboard toggle
- Adjustable volume controls
- Designed for Arch Linux but should work on any SDDM installation supporting Qt6

## Requirements

- SDDM 0.21+
- Qt6
- Qt Multimedia
- Qt Virtual Keyboard (optional)

## Installation

Copy the theme:

```bash
sudo cp -r fallout-sddm /usr/share/sddm/themes/
```

Set it as the active theme:

```bash
printf "[Theme]\nCurrent=fallout-sddm\n" | sudo tee /etc/sddm.conf
```

Verify:

```bash
cat /etc/sddm.conf
```

Expected:

```ini
[Theme]
Current=fallout-sddm
```

## Sound Controls

Near the top of `Main.qml`:

```qml
property real keyVolume: 0.5
property real systemVolume: 1.0
```

| Setting | Description |
|---|---|
| `keyVolume` | Typing and terminal sounds |
| `systemVolume` | Power-on and power-off sounds |

## Virtual Keyboard

The theme includes a manual virtual keyboard toggle in the lower-right corner.

Virtual keyboard support is optional. To enable SDDM's Qt Virtual Keyboard, create an SDDM configuration file containing:

```ini
[General]
InputMethod=qtvirtualkeyboard
```

## Directory Layout

```text
fallout-sddm/
├── Main.qml
├── metadata.desktop
├── Sounds/
├── Themes/
│   └── fallout.conf
├── translations/
└── Screenshots/
```

## Screenshots

### Authentication

![Fallout SDDM authentication screen](Screenshots/fallout-Auth.png)

### Boot Sequence

![Fallout SDDM boot sequence](Screenshots/fallout-boot.png)

## Acknowledgements

Several of the terminal sound effects included with this theme were sourced from the Hyper ROBCO project created by smiley.

Project:
https://github.com/smiley/hyper-robco

The following audio assets were adapted for use in this theme:

- ui_hacking_charsingle_01.wav
- ui_hacking_charsingle_02.wav
- ui_hacking_charsingle_03.wav
- ui_hacking_charsingle_04.wav
- ui_hacking_charsingle_05.wav
- ui_hacking_charsingle_06.wav
- ui_hacking_charenter_01.wav
- ui_hacking_charenter_02.wav
- ui_hacking_charenter_03.wav

Additional startup and shutdown audio included with this theme was derived from and converted from assets included with the Hyper ROBCO project.

Special thanks to smiley for making the original project available.

## License

MIT
