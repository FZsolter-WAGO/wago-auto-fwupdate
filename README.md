# wago-auto-fwupdate
A script that downloads a firmware and starts the fwupdate process in the controller.
```
wget -qO- https://raw.githubusercontent.com/FZsolter-WAGO/wago-auto-fwupdate/main/bin/wago-auto-fwupdate | bash -s
```
### You have to manually apply the changes after the install. You can check the current state with...
```
/etc/config-tools/fwupdate status
```
On "unconfirmed" run...
```
/etc/config-tools/fwupdate finish
```
On "finished" or "error" run...
```
/etc/config-tools/fwupdate clear
```
