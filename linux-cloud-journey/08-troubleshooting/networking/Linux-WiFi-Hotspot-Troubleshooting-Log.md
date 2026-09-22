# Linux Wi-Fi → Hotspot Troubleshooting Log

**Machine:** HP EliteBook 850 G3

**Wi-Fi adapter:** Intel Wireless 8260

**Linux interface:** `wlp2s0`

**Wi-Fi network:** `Mkopa X20`

**Goal:** Stay connected to M-KOPA through Wi-Fi while simultaneously broadcasting a Wi-Fi hotspot from the same laptop.

Target:

```
```

```
M-KOPA X20
     ↓
Intel 8260 / wlp2s0
     ↓
   Ubuntu
     ↓
Wi-Fi hotspot "Morris"
     ↓
 Phone / other devices
```

---

# 1. Verified Bluetooth — unrelated to hotspot

You initially tested Bluetooth with:

```
```

```
bluetoothctl
```

Bluetooth detected:

```
```

```
Controller B4:69:21:98:7E:10
Pairable: yes
Agent registered
```

You tried:

```
```

```
start
```

Result:

```
```

```
Invalid command in menu main: start
```

### What happened

`start` isn't a valid `bluetoothctl` command.

Then:

```
```

```
scan
```

gave:

```
```

```
Missing on/off/bredr/le argument
```

Correct syntax was:

```
```

```
scan on
```

You then tried:

```
```

```
scan on
```

Result:

```
```

```
SetDiscoveryFilter failed: org.bluez.Error.NotReady
Failed to start discovery: org.bluez.Error.NotReady
```

### Conclusion

Bluetooth was detected, but wasn't ready for discovery.

**This was unrelated to the Wi-Fi hotspot problem.**

---

# 2. Confirmed Linux can create a Wi-Fi hotspot in principle

We checked:

```
```

```
iw list | grep -A 15 "Supported interface modes"
```

Your Intel 8260 reported:

```
```

```
Supported interface modes:
    * IBSS
    * managed
    * AP
    * AP/VLAN
    * monitor
    * P2P-client
    * P2P-GO
    * P2P-device
```

### Important

`AP` means the hardware/driver exposes Wi-Fi Access Point capability.

So the adapter isn't simply a Wi-Fi-only client adapter.

---

# 3. Checked simultaneous Wi-Fi client + AP capability

You ran:

```
```

```
iw list | grep -A 20 "valid interface combinations"
```

The important result was:

```
```

```
#{ managed } <= 1, #{ AP, P2P-client, P2P-GO } <= 1,
#{ P2P-device } <= 1, #channels <= 1
```

### What this means

Linux's wireless capability information says the device supports:

```
```

```
1 managed interface
+
1 AP interface
```

with the important restriction:

```
```

```
#channels <= 1
```

So the client and AP need to use the same channel.

At this point we had strong evidence that simultaneous operation **should be possible at the driver capability level**.

---

# 4. Confirmed your actual Wi-Fi connection

You ran:

```
```

```
nmcli
```

and got:

```
```

```
wlp2s0: connected to Mkopa X20
"Intel 8260"
wifi (iwlwifi)
B4:69:21:98:7E:0C
inet4 192.168.100.76/24
route4 default via 192.168.100.1
```

Then:

```
```

```
nmcli device
```

showed:

```
```

```
DEVICE          TYPE      STATE       CONNECTION
wlp2s0          wifi      connected   Mkopa X20
```

### Conclusion

Your Internet connection is:

```
```

```
wlp2s0
  ↓
Mkopa X20
  ↓
192.168.100.76
```

and is working normally.

---

# 5. Tested NetworkManager's normal hotspot function

We tried:

```
```

```
nmcli device wifi hotspot ifname wlp2s0 con-name Morris-Hotspot ssid Morris-Hotspot password "Morris12345"
```

### Result

NetworkManager disconnected the existing:

```
```

```
Mkopa X20
```

connection.

### Why this happened

NetworkManager attempted to use `wlp2s0` itself as the AP instead of maintaining the existing client connection in the way we needed.

This demonstrated that the simple:

```
```

```
nmcli device wifi hotspot
```

method wasn't sufficient.

---

# 6. Created a virtual AP interface with `iw`

We tried:

```
```

```
sudo iw dev wlp2s0 interface add hotspot0 type __ap
```

It didn't immediately report an error.

Then:

```
```

```
iw dev
```

showed:

```
```

```
Interface hotspot0
    type managed
```

rather than:

```
```

```
type AP
```

### Result

The requested AP interface wasn't actually exposed as an AP interface.

Then:

```
```

```
sudo ip link set hotspot0 up
```

gave:

```
```

```
RTNETLINK answers: Device or resource busy
```

### Conclusion

This particular manual virtual-interface approach wasn't working.

We removed/attempted to clean up the interface during subsequent testing.

---

# 7. Checked the M-KOPA channel

We ran:

```
```

```
iw dev wlp2s0 link
```

Result:

```
```

```
SSID: Mkopa X20
freq: 2412.0
```

Later `iw dev` explicitly showed:

```
```

```
channel 1 (2412 MHz)
width: 40 MHz
```

Therefore:

```
```

```
M-KOPA
Channel 1
2412 MHz
```

This is important because the Intel 8260 reported:

```
```

```
#channels <= 1
```

for simultaneous managed/AP operation.

---

# 8. Installed `create_ap`

You went to:

```
```

```
~/Downloads/create_ap-master
```

and initially tried:

```
```

```
sudo make install
```

but got:

```
```

```
sudo: make: command not found
```

### What this meant

The `make` build utility wasn't installed.

We installed it with:

```
```

```
sudo apt update
sudo apt install make
```

Then `create_ap` could be installed/built.

---

# 9. First `create_ap` attempt

You ran:

```
```

```
sudo create_ap wlp2s0 wlp2s0 Morris morris1234
```

The important output was:

```
```

```
wlp2s0 is already associated with channel 0 (2412.0 MHz)
Creating a virtual WiFi interface... ap0 created.

ERROR: Your adapter can not transmit to channel 0, frequency band 2.4GHz.
```

### At first this looked like a driver/channel problem.

But we noticed:

```
```

```
2412.0
```

instead of:

```
```

```
2412
```

That led to the next investigation.

---

# 10. Found the `create_ap` frequency parsing problem

We inspected:

```
```

```
sed -n '330,360p' /usr/bin/create_ap
```

The function contained:

```
```

```
ieee80211_frequency_to_channel() {
    local FREQ=$1
```

and then arithmetic operations such as:

```
```

```
[[ $FREQ -eq 2484 ]]
```

A value of:

```
```

```
2412.0
```

is problematic for those Bash arithmetic operations.

We changed:

```
```

```
local FREQ=$1
```

to:

```
```

```
local FREQ=${1%.*}
```

This converts:

```
```

```
2412.0
```

to:

```
```

```
2412
```

---

# 11. Confirmed the frequency conversion fix

We checked:

```
```

```
grep -A3 'ieee80211_frequency_to_channel()' /usr/bin/create_ap
```

and confirmed:

```
```

```
ieee80211_frequency_to_channel() {
    local FREQ=${1%.*}
```

So that particular bug was fixed.

---

# 12. `create_ap` then correctly detected channel 1

After the patch, we ran:

```
```

```
sudo create_ap wlp2s0 wlp2s0 Morris morris1234
```

and got:

```
```

```
wlp2s0 is already associated with channel 1 (2412.0 MHz)
Creating a virtual WiFi interface... ap0 created.
```

This was progress.

The earlier false:

```
```

```
channel 0
```

problem was gone.

But we still got:

```
```

```
ERROR: Your adapter can not transmit to channel 1, frequency band 2.4GHz.
```

So there was another parsing/check problem.

---

# 13. Inspected `can_transmit_to_channel()`

You ran:

```
```

```
grep -n "can_transmit_to_channel" -A 25 ~/Downloads/create_ap-master/create_ap | head -40
```

We found:

```
```

```
can_transmit_to_channel() {
    local IFACE CHANNEL_NUM CHANNEL_INFO
```

and specifically:

```
```

```
CHANNEL_INFO=$(get_adapter_info ${IFACE} | grep " 24[0-9][0-9] MHz \[${CHANNEL_NUM}\]")
```

This pattern expected:

```
```

```
2412 MHz
```

while modern `iw` reports:

```
```

```
2412.0 MHz
```

---

# 14. Verified what `iw` actually reports

You ran:

```
```

```
iw phy phy0 info | grep -A 20 -B 5 "2412"
```

and got:

```
```

```
* 2412.0 MHz [1] (22.0 dBm)
* 2417.0 MHz [2] (22.0 dBm)
* 2422.0 MHz [3] (22.0 dBm)
...
```

This was very important.

It proves Linux itself reports:

```
```

```
2412.0 MHz [1]
```

and channel 1 is available.

It was **not disabled**.

---

# 15. Patched `can_transmit_to_channel()`

We initially changed the pattern incorrectly, using regular `grep` with extended-regex syntax.

You showed the function contained:

```
```

```
grep -E " 24[0-9][0-9](\.0)?  MHz ...
```

There were two issues:

1.  The pattern needed extended regex. 
2.  There was an incorrect extra space before `MHz`. 

We corrected it to:

```
```

```
CHANNEL_INFO=$(get_adapter_info ${IFACE} | grep -E " 24[0-9][0-9](\.0)? MHz \[${CHANNEL_NUM}\]")
```

---

# 16. Verified the new regex independently

You ran:

```
```

```
iw phy phy0 info | grep -E " 24[0-9][0-9](\.0)? MHz \[1\]"
```

and got:

```
```

```
* 2412.0 MHz [1] (22.0 dBm)
```

### This proves

The regex itself correctly matches:

```
```

```
2412.0 MHz [1]
```

So that specific regex is valid.

---

# 17. `create_ap` still failed

Despite the regex fix, you ran:

```
```

```
sudo create_ap wlp2s0 wlp2s0 Morris morris1234
```

and still got:

```
```

```
wlp2s0 is already associated with channel 1 (2412.0 MHz)
Creating a virtual WiFi interface... ap0 created.

ERROR: Your adapter can not transmit to channel 1, frequency band 2.4GHz.
```

### Current conclusion about `create_ap`

We have established that:

-  The adapter supports AP mode. 
-  The adapter reports channel 1. 
-  The M-KOPA connection is on channel 1. 
- `ap0` can be created. 
- `create_ap` correctly identifies channel 1 after our first patch. 
-  The old `create_ap` implementation still fails its transmit-channel test. 

Therefore **continuing to patch this old `create_ap` version isn't currently justified** without inspecting exactly what `get_adapter_info()` returns and how that function interacts with the channel check.

---

# 18. Started investigating maintained `linux-wifi-hotspot`

We then moved to the newer project:

```
```

```
linux-wifi-hotspot
```

You obtained:

```
```

```
linux-wifi-hotspot_5.0.0_amd64.deb
```

This is a prebuilt Debian package.

We discussed installing it with:

```
```

```
sudo apt install ./linux-wifi-hotspot_5.0.0_amd64.deb
```

However, you instead entered the source directory:

```
```

```
~/Downloads/linux-wifi-hotspot-5.0.0
```

and tried:

```
```

```
sudo make install
```

---

# 19. `linux-wifi-hotspot` build failed

You got:

```
```

```
Installing...
cd src && make install
make[1]: Entering directory
...
make[1]: *** No rule to make target '../build/wihotspot-gui', needed by 'install'. Stop.
```

### What this means

The project expected:

```
```

```
build/wihotspot-gui
```

to already exist.

It didn't.

So:

```
```

```
sudo make install
```

was attempted before the required GUI binary was built.

The correct build sequence is normally:

```
```

```
make
   ↓
build/wihotspot-gui
   ↓
sudo make install
```

However, because you already have a `.deb` package, **building from source may not be necessary at all**.

---

# Current software/tools involved

| ToolInstalled/attemptedPurposeResult |                                     |                                        |                                             |
| ------------------------------------ | ----------------------------------- | -------------------------------------- | ------------------------------------------- |
| `iw`                                 | Yes                                 | Inspect/control wireless interfaces    | Working                                     |
| `iwlist`                             | Available through system tooling    | Legacy wireless channel information    | Used by `create_ap`                         |
| `bluetoothctl`                       | Yes                                 | Bluetooth management                   | Unrelated                                   |
| `nmcli`                              | Yes                                 | NetworkManager control                 | Working                                     |
| NetworkManager                       | Yes                                 | Wi-Fi management                       | Working                                     |
| `make`                               | Installed                           | Build source projects                  | Working                                     |
| `create_ap`                          | Installed                           | Wi-Fi hotspot creation                 | Fails channel/AP check                      |
| `hostapd`                            | Not successfully used yet           | Actual AP daemon                       | Not yet tested directly                     |
| `linux-wifi-hotspot` 5.0.0           | Source downloaded / `.deb` obtained | Modern hotspot frontend/implementation | Not successfully installed yet              |
| `wihotspot-gui`                      | Not built                           | GUI for Linux WiFi Hotspot             | Missing                                     |
| `ap0`                                | Temporarily created                 | Virtual AP interface                   | Created but `create_ap` subsequently failed |
| `hotspot0`                           | Temporarily created                 | Manual AP interface                    | Appeared as `managed`, not AP               |

---

# Current known-good facts

These are the most important facts we have established.

### Wi-Fi hardware

```
```

```
Intel Wireless 8260
```

### Linux driver

```
```

```
iwlwifi
```

### Interface

```
```

```
wlp2s0
```

### Current connection

```
```

```
SSID: Mkopa X20
```

### Frequency

```
```

```
2412.0 MHz
```

### Channel

```
```

```
1
```

### Signal

Approximately:

```
```

```
-30 dBm
```

That's a strong signal.

### AP capability

The adapter reports:

```
```

```
* AP
```

### Simultaneous capability reported by `iw`

```
```

```
managed <= 1
AP <= 1
#channels <= 1
```

### Channel 1 availability

Confirmed by:

```
```

```
iw phy phy0 info
```

which reports:

```
```

```
* 2412.0 MHz [1] (22.0 dBm)
```

---

# What has NOT yet been conclusively tested

This is important because we shouldn't confuse **a failed tool** with **a failed hardware capability**.

We have **not yet successfully tested**:

1.  A current `linux-wifi-hotspot` installation. 
2.  Direct `hostapd` configuration. 
3.  P2P Group Owner (`P2P-GO`) as an alternative AP mechanism. 
4.  A manually created AP interface using a method that preserves the managed interface. 
5.  A newer/current `create_ap` implementation. 
6.  The exact output of `get_adapter_info()` used by the old `create_ap`. 
7.  Whether the `.deb` version of `linux-wifi-hotspot 5.0.0` solves the `iw 6.7+` frequency-format issue. 

So **we should not yet declare the Intel 8260 incapable on Linux.**

---

# Best next step

You already have:

```
```

```
linux-wifi-hotspot_5.0.0_amd64.deb
```

Therefore, I recommend **stopping the old `create_ap` experiments** and installing the prebuilt package instead.

From `~/Downloads`:

```
```

```
sudo apt install ./linux-wifi-hotspot_5.0.0_amd64.deb
```

Then:

```
```

```
dpkg -l | grep linux-wifi-hotspot
```

That gives us a clean starting point with the newer implementation rather than continuing to modify the archived `create_ap`.

### Current objective remains

```
```

```
              ┌── Internet
Mkopa X20 ──→ Intel 8260
              │
              ↓
          Linux hotspot
              │
              ↓
        Phone / laptop
```

And importantly, **we have not yet exhausted the Linux-side solutions.**
