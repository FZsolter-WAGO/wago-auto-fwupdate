# DEPRECATED
# wago-autodownload-fwupdate
A script that downloads a firmware and starts the fwupdate process in the controller.
By running this script the user is accepting the [WAGO Software License Terms](https://www.wago.com/global/d/softwarelicence).
## List out the available firmware revisions
```
sudo wget -qO- https://raw.githubusercontent.com/FZsolter-WAGO/wago-auto-fwupdate/main/bin/wago-autodownload-fwupdate | bash -s list
```
## Start the installation (replace "04.03.03(25)" with your desired input)
```
sudo wget -qO- https://raw.githubusercontent.com/FZsolter-WAGO/wago-auto-fwupdate/main/bin/wago-autodownload-fwupdate | bash -s install "04.03.03(25)"
```
## Finish the installation once the device rebooted
```
sudo wget -qO- https://raw.githubusercontent.com/FZsolter-WAGO/wago-auto-fwupdate/main/bin/wago-autodownload-fwupdate | bash -s finish
```
