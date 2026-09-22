# Btop & Brightnessctl

Linux tools for **system monitoring** and **display brightness control**.

---

## 1. Btop

### What is btop?

`btop` is a terminal-based system monitor. It provides a real-time view of:

- CPU usage
- RAM usage
- Swap usage
- Disk usage
- Network activity
- Running processes
- CPU temperatures (when supported)

It is useful for checking system performance, especially when using a lightweight window manager such as **i3**.

### Installation

On Ubuntu/Debian:

```bash
sudo apt update
sudo apt install btop
```

### Start btop

```bash
btop
```

To exit:

```text
q
```

### Useful controls

| Key | Action |
|---|---|
| `q` | Quit |
| `Esc` | Close menu / go back |
| `↑` / `↓` | Navigate processes |
| `Enter` | Select |
| `k` | Kill selected process |
| `m` | Sort/process menu options |
| `f` | Filter processes |
| `r` | Reverse sorting |
| `+` / `-` | Change update interval |

> Key bindings can vary slightly between btop versions. Press `Esc` or `?` inside btop to view the available controls.

### i3 shortcut

To launch btop using an i3 keybinding, add this to:

```text
~/.config/i3/config
```

```i3
bindsym $mod+b exec btop
```

Then reload i3:

```text
Mod + Shift + R
```

---

# 2. Brightnessctl

### What is brightnessctl?

`brightnessctl` is a command-line utility for controlling the brightness of supported displays/backlights.

It is especially useful in a minimal Linux environment such as **i3**, where desktop-environment brightness controls may not be available.

### Installation

```bash
sudo apt update
sudo apt install brightnessctl
```

### Check brightness

```bash
brightnessctl
```

Example output:

```text
Device 'intel_backlight' of class 'backlight':
    Current brightness: 500 (20%)
    Max brightness: 2500
```

### Increase brightness

Increase by 10%:

```bash
brightnessctl set +10%
```

### Decrease brightness

Decrease by 10%:

```bash
brightnessctl set 10%-
```

### Set a specific brightness

Set brightness to 50%:

```bash
brightnessctl set 50%
```

Set brightness to 100%:

```bash
brightnessctl set 100%
```

Set brightness to 20%:

```bash
brightnessctl set 20%
```

---

## 3. i3 Brightness Keybindings

Edit:

```text
~/.config/i3/config
```

Add:

```i3
# Brightness controls
bindsym XF86MonBrightnessUp exec brightnessctl set +10%
bindsym XF86MonBrightnessDown exec brightnessctl set 10%-
```

These normally connect the laptop's **brightness up/down keys** to `brightnessctl`.

Reload i3:

```text
Mod + Shift + R
```

### If the brightness keys do not work

First test the commands directly:

```bash
brightnessctl set +10%
```

and:

```bash
brightnessctl set 10%-
```

If those work but the keyboard keys do not, check the key names detected by i3:

```bash
xev
```

Press the brightness key and look for its reported key symbol.

---

## 4. Useful Commands

### List brightness devices

```bash
brightnessctl -l
```

### Show current brightness

```bash
brightnessctl get
```

### Show maximum brightness

```bash
brightnessctl max
```

### Set brightness using a percentage

```bash
brightnessctl set 70%
```

### Increase brightness

```bash
brightnessctl set +5%
```

### Decrease brightness

```bash
brightnessctl set 5%-
```

---

## 5. Quick Reference

### Btop

```bash
# Launch
btop
```

### Brightnessctl

```bash
# Check brightness
brightnessctl

# Increase
brightnessctl set +10%

# Decrease
brightnessctl set 10%-

# Set 50%
brightnessctl set 50%

# List devices
brightnessctl -l
```

---

## 6. Configuration Files

| Component | Location |
|---|---|
| i3 configuration | `~/.config/i3/config` |
| Linux documentation | `~/Documents/Linux-Documentation/` |
| btop | `/usr/bin/btop` |
| brightnessctl | `/usr/bin/brightnessctl` |

> Package locations can differ slightly depending on the distribution and installation method.

---

## 7. Why I Use These Tools

### btop

I use `btop` to monitor system resources from the terminal without needing a heavy graphical system monitor.

### brightnessctl

I use `brightnessctl` to control display brightness from the terminal and connect brightness controls to i3 keyboard shortcuts.

---

## 8. Installation Record

Installed tools:

- [x] `btop`
- [x] `brightnessctl`

Installation commands:

```bash
sudo apt install btop brightnessctl
```
