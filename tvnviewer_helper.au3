#cs
TightVNC Viewer Helper - shows a list of IP address and also name and description
Author: Tibor Repček
Web: https://github.com/tiborepcek/tvnviewer-helper
#ce

#pragma compile(ProductName, TightVNC Viewer Helper - shows a list of IP address and also name and description)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 1.0.0.0)
#pragma compile(CompanyName, 'tiborepcek.com')
#pragma compile(FileDescription, TightVNC Viewer Helper - shows a list of IP address and also name and description.)

#NoTrayIcon
Opt("GUICloseOnESC", 0)

#include <Crypt.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <ListViewConstants.au3>
#include <Misc.au3>
#include <StructureConstants.au3>
#include <WindowsConstants.au3>

$GUI_name = "TightVNC Viewer Helper"
$GUI_version = "1.0"
$crypt_password = "super.Strong.Password4crypt&decrypt" ; Declare a password string to decrypt/encrypt the data. This has to be the same as in crypt_tool_for_tvnviewer_helper.au3 file - variable $crypt_password
$ini_file = @ScriptDir & "\tvnviewer_helper.ini" ; file with list of names, IPs, passwords and descriptions
$ip_addresses = IniReadSectionNames($ini_file)

If _Singleton($GUI_name & " " & $GUI_version, 1) = 0 Then Exit

GUICreate($GUI_name & " " & $GUI_version, 800, 600)
	$listView_name_ip = GUICtrlCreateListView("#|Name (IP address)|", 16, 16, 400, 560)
		_GUICtrlListView_SetColumnWidth($listView_name_ip, 1, 360)
		GUICtrlSetFont(-1, 10, 400, 0, "Verdana")
	$lbl_string_name = GUICtrlCreateLabel("Name:", 450, 16, 200, -1)
		GUICtrlSetFont(-1, 12, 400, 0, "Verdana")
	$input_ini_name = GUICtrlCreateInput("", 450, 40, 330, -1, $ES_READONLY)
		GUICtrlSetFont(-1, 10, 400, 0, "Verdana")
	$lbl_string_ip = GUICtrlCreateLabel("IP address:", 450, 100, 200, -1)
		GUICtrlSetFont(-1, 12, 400, 0, "Verdana")
	$input_ini_ip = GUICtrlCreateInput("", 450, 124, 330, -1, $ES_READONLY)
		GUICtrlSetFont(-1, 10, 400, 0, "Verdana")
	$lbl_string_desc = GUICtrlCreateLabel("Description:", 450, 184, 200, -1)
		GUICtrlSetFont(-1, 12, 400, 0, "Verdana")
	$edit_ini_desc = GUICtrlCreateEdit("", 450, 208, 330, 80, $WS_VSCROLL + $ES_READONLY)
		GUICtrlSetFont(-1, 10, 400, 0, "Arial")
	$lbl_status = GUICtrlCreateLabel("Status:", 450, 330, 200, -1)
		GUICtrlSetFont(-1, 12, 400, 0, "Verdana")
	$edit_status = GUICtrlCreateEdit("", 450, 354, 330, 150, $WS_VSCROLL + $ES_READONLY + $ES_WANTRETURN)
		GUICtrlSetFont(-1, 10, 400, 0, "Arial")
	$btn_connect = GUICtrlCreateButton("Connect", 450, 540, 100, 35)
		GUICtrlSetFont(-1, 14, 800, 0, "Verdana")
		GUICtrlSetTip(-1, "Connects to choosen server using TightVNC Viewer command line option")
		GUICtrlSetResizing(-1, $GUI_DOCKHCENTER+$GUI_DOCKVCENTER+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$btn_about = GUICtrlCreateButton("About", 700, 540, 80, 35)
		GUICtrlSetFont(-1, 10, 400, 0, "Verdana")
		GUICtrlSetTip(-1, "Opens web browser with program homepage")
		GUICtrlSetResizing(-1, $GUI_DOCKHCENTER+$GUI_DOCKVCENTER+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	loadList()
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	GUISetState(@SW_SHOW)


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btn_connect
			$input_ip = GUICtrlRead($input_ini_ip)
			_Crypt_Startup() ; Start the crypt library
			$crypt_data = IniRead($ini_file, $input_ip, "pswd", "pswd-NA") ; Data that will be decrypt/encrypt
			$crypt_data_decrypted = BinaryToString(_Crypt_DecryptData($crypt_data, $crypt_password, $CALG_AES_256)) ; Decrypted data
			_Crypt_Shutdown() ; Close the crypt library
			Run(@ComSpec & " /c " & 'tvnviewer.exe ' & $input_ip & ' -password=' & $crypt_data_decrypted, "", @SW_HIDE) ; Find more command line options for tvnviewer.exe on https://www.tightvnc.com/vncviewer.1.php
			$date_time = @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
			GUICtrlSetData($edit_status, $date_time & " - Connect to: " & $input_ip & @CRLF, -1)
		Case $btn_about
			ShellExecute("https://github.com/tiborepcek/tvnviewer-helper")
			$date_time = @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
			GUICtrlSetData($edit_status, $date_time & " - About button clicked" & @CRLF, -1)
	EndSwitch
WEnd


Func WM_NOTIFY($hWnd, $Msg, $wParam, $lParam)
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView
    $hWndListView = $listView_name_ip
    If Not IsHWnd($hWndListView) Then $hWndListView = GUICtrlGetHandle($listView_name_ip)

    $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iCode = DllStructGetData($tNMHDR, "Code")

    Switch $hWndFrom
        Case $hWndListView
            Switch $iCode
                Case $NM_CLICK
                    Local $tInfo = DllStructCreate($tagNMLISTVIEW, $lParam)
                    Local $iItem = DllStructGetData($tInfo, "Item")
                    If $iItem <> -1 Then
						$listView_name_ip_item = _GUICtrlListView_GetItem($listView_name_ip, $iItem, 1)
						$listView_name_ip_item_text = $listView_name_ip_item[3]
						$listView_name_ip_item_text_splitted = StringSplit($listView_name_ip_item_text, "(")
						$listView_name_ip_item_text_ip_only = StringTrimRight($listView_name_ip_item_text_splitted[2], 1)
						$ini_key_name_onClick = IniRead($ini_file, $listView_name_ip_item_text_ip_only, "name", "name-NA")
						$ini_key_desc_onClick = IniRead($ini_file, $listView_name_ip_item_text_ip_only, "desc", "desc-NA")
						$ini_key_pswd_onClick = IniRead($ini_file, $listView_name_ip_item_text_ip_only, "pswd", "pswd-NA")
						GUICtrlSetData($input_ini_name, $ini_key_name_onClick)
						GUICtrlSetData($input_ini_ip, $listView_name_ip_item_text_ip_only)
						GUICtrlSetData($edit_ini_desc, $ini_key_desc_onClick)
						$date_time = @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
						GUICtrlSetData($edit_status, $date_time & " - Single click: " & $listView_name_ip_item_text_ip_only & @CRLF, -1)
					EndIf
				Case $NM_DBLCLK
					Local $tInfo = DllStructCreate($tagNMLISTVIEW, $lParam)
                    Local $iItem = DllStructGetData($tInfo, "Item")
					If $iItem <> -1 Then
						$listView_name_ip_item = _GUICtrlListView_GetItem($listView_name_ip, $iItem, 1)
						$listView_name_ip_item_text = $listView_name_ip_item[3]
						$listView_name_ip_item_text_splitted = StringSplit($listView_name_ip_item_text, "(")
						$listView_name_ip_item_text_ip_only = StringTrimRight($listView_name_ip_item_text_splitted[2], 1)
						$ini_key_name_onClick = IniRead($ini_file, $listView_name_ip_item_text_ip_only, "name", "name-NA")
						$ini_key_desc_onClick = IniRead($ini_file, $listView_name_ip_item_text_ip_only, "desc", "desc-NA")
						$ini_key_pswd_onClick = IniRead($ini_file, $listView_name_ip_item_text_ip_only, "pswd", "pswd-NA")
						_Crypt_Startup() ; Start the crypt library
						$crypt_data = IniRead($ini_file, $listView_name_ip_item_text_ip_only, "pswd", "pswd-NA") ; Data that will be decrypt/encrypt
						$crypt_data_decrypted = BinaryToString(_Crypt_DecryptData($crypt_data, $crypt_password, $CALG_AES_256)) ; Decrypted data
						_Crypt_Shutdown() ; Close the crypt library
						Run(@ComSpec & " /c " & 'tvnviewer.exe ' & $listView_name_ip_item_text_ip_only & ' -password=' & $crypt_data_decrypted, "", @SW_HIDE) ; Find more command line options for tvnviewer.exe on https://www.tightvnc.com/vncviewer.1.php
						$date_time = @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
						GUICtrlSetData($edit_status, $date_time & " - Double click: " & $listView_name_ip_item_text_ip_only & @CRLF, -1)
					EndIf
            EndSwitch
    EndSwitch

    Return $GUI_RUNDEFMSG
EndFunc

Func loadList()
	For $number = 1 to $ip_addresses[0]
		$ini_section_name = $ip_addresses[$number]
		$ini_key_name = IniRead($ini_file, $ini_section_name, "name", "name-NA")
		$ini_key_desc = IniRead($ini_file, $ini_section_name, "desc", "desc-NA")
		$ini_key_pswd = IniRead($ini_file, $ini_section_name, "pswd", "pswd-NA")
		GUICtrlCreateListViewItem($number & "|" & $ini_key_name & " (" & $ini_section_name & ")", $listView_name_ip)
		$date_time = @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
	Next
	GUICtrlSetData($edit_status, $date_time & " - Working directory: " & @ScriptDir & @CRLF, -1)
	GUICtrlSetData($edit_status, $date_time & " - Name and IP list loaded" & @CRLF, -1)
EndFunc