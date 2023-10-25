# wago-auto-fwupdate
A script that downloads a firmware and starts the fwupdate process in the controller.
```
sudo wget -qO- https://raw.githubusercontent.com/FZsolter-WAGO/wago-auto-fwupdate/main/bin/wago-auto-fwupdate | bash -s
```
### You have to manually apply the changes after the install. You can check the current state with...
```
sudo /etc/config-tools/fwupdate status
```
On "unconfirmed" run...
```
sudo /etc/config-tools/fwupdate finish
```
On "finished" or "error" run...
```
sudo /etc/config-tools/fwupdate clear
```
