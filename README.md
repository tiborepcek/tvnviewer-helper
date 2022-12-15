# TightVNC Viewer Helper

TightVNC Viewer Helper - shows a list of IP address and also name and description. It is written in [AutoIt scripting language](https://www.autoitscript.com/). This is how to [run AutoIt source code](https://www.autoitscript.com/autoit3/docs/intro/running.htm) (text file with au3 extension).

![This is an image](https://github.com/tiborepcek/tvnviewer-helper/blob/main/tvnviewer_helper.png)

![This is an image](https://github.com/tiborepcek/tvnviewer-helper/blob/main/crypt_tool_for_tvnviewer_helper.png)

## How it works

1. Define IP addresses, names, descriptions and password (if needed) in `tvnviewer_helper.ini` file.
1. If password is needed, encrypt it first using `crypt_tool_for_tvnviewer_helper.au3` file.
1. Run `tvnviewer_helper.au3` file and connect by double click a list item or single click the button below.
1. The connection is established by calling `tvnviewer.exe` file (download it from [this link](https://www.tightvnc.com/download-old.php) - viewer executable) from the current working directory of the `tvnviewer_helper.au3` file, providing IP address and password via command line interface.

## How to run

Donwload [latest release](https://github.com/tiborepcek/tvnviewer-helper/releases/) and follow the instructions.

## To do

- Handle errors and exceptions little bit better :)
