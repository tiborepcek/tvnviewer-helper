# TightVNC Viewer Helper

TightVNC Viewer Helper - shows a list of IP address and also name and description

SCREENSHOT

## How it works

1. Define IP addresses, names, descriptions and password (if needed) in `tvnviewer_helper.ini` file.
1. If password is needed, encrypt it first using `crypt_tool_for_tvnviewer_helper.au3` file.
1. Run `tvnviewer_helper.au3` file and connect by double click a list item or single click the button below.
1. The connection is established by calling `tvnviewer.exe` (download it from [this link](https://www.tightvnc.com/download-old.php) - viewer executable) file from the current working directory of the `tvnviewer_helper.au3` file, providing IP address and password via command line interface.

## To do

- Handle errors and exceptions little bit better :)
