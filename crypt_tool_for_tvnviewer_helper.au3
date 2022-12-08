#cs
Crypt Tool for TightVNC Viewer Helper - encrypts and decrypts a text string
Author: Tibor Repček
Web: https://github.com/tiborepcek/tvnviewer-helper
#ce

#pragma compile(ProductName, Crypt Tool for TightVNC Viewer Helper - encrypts and decrypts a text string)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 1.0.0.0)
#pragma compile(CompanyName, 'tiborepcek.com')
#pragma compile(FileDescription, This script encrypts and decrypts a text string for TightVNC Viewer Helper.)

#NoTrayIcon
Opt("GUICloseOnESC", 0)

#include <Crypt.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <WindowsConstants.au3>

$GUI_name = "Crypt Tool"
$GUI_version = "1.0"
$crypt_password = "super.Strong.Password4crypt&decrypt" ; Declare a password string to decrypt/encrypt the data. This has to be the same as in tvnviewer_helper.au3 file - variable $crypt_password

If _Singleton($GUI_name & " " & $GUI_version, 1) = 0 Then Exit

GUICreate($GUI_name & " " & $GUI_version, 800, 600)
	$lbl_string_encrypt = GUICtrlCreateLabel("Encrypted string:", 16, 16, 200, -1)
		GUICtrlSetFont(-1, 12, 400, 0, "Verdana")
	$edit_string_encrypt = GUICtrlCreateEdit("", 16, 40, 768, 100, $WS_VSCROLL)
		GUICtrlSetState(-1, $GUI_FOCUS)
		GUICtrlSetFont(-1, 12, 400, 0, "Courier")
	$btn_encrypt = GUICtrlCreateButton("Encrypt", 280, 163, 100, 35)
		GUICtrlSetFont(-1, 14, 800, 0, "Verdana")
		GUICtrlSetTip(-1, "Encrypts the string in upper box and puts the result to the box bellow")
		GUICtrlSetResizing(-1, $GUI_DOCKHCENTER+$GUI_DOCKVCENTER+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$btn_decrypt = GUICtrlCreateButton("Decrypt", 410, 163, 100, 35)
		GUICtrlSetFont(-1, 14, 800, 0, "Verdana")
		GUICtrlSetTip(-1, "Decrypts the string in box bellow and puts the result to the upper box")
		GUICtrlSetResizing(-1, $GUI_DOCKHCENTER+$GUI_DOCKVCENTER+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$lbl_string_decrypt = GUICtrlCreateLabel("Decrypted string:", 16, 196, 200, -1)
		GUICtrlSetFont(-1, 12, 400, 0, "Verdana")
	$edit_string_decrypt = GUICtrlCreateEdit("", 16, 220, 768, 100, $WS_VSCROLL)
		GUICtrlSetFont(-1, 12, 400, 0, "Courier")
	$lbl_crypt_status = GUICtrlCreateLabel("Status: ", 16, 396, 600, 21)
		GUICtrlSetFont(-1, 12, 400, 0, "Verdana")
	$edit_string_status = GUICtrlCreateEdit("", 16, 420, 768, 155, $WS_VSCROLL + $ES_READONLY + $ES_WANTRETURN)
		GUICtrlSetFont(-1, 12, 400, 0, "Courier")
	$date_time = @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
	GUICtrlSetData($edit_string_status, $date_time & " - Working directory: " & @ScriptDir & @CRLF, -1)
	GUISetState(@SW_SHOW)


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btn_encrypt
			_Crypt_Startup() ; Start the crypt library
			$crypt_data = GUICtrlRead($edit_string_decrypt) ; Data that will be encrypt
			$crypt_data_encrypted = _Crypt_EncryptData($crypt_data, $crypt_password, $CALG_AES_256) ; Encrypted data
			GUICtrlSetData($edit_string_encrypt, $crypt_data_encrypted)
			_Crypt_Shutdown() ; Close the crypt library
			$date_time = @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
			GUICtrlSetData($edit_string_status, $date_time & " - Text string encryption done." & @CRLF, -1)
		Case $btn_decrypt
			_Crypt_Startup() ; Start the crypt library
			$crypt_data = GUICtrlRead($edit_string_encrypt) ; Data that will be decrypt
			$crypt_data_decrypted = BinaryToString(_Crypt_DecryptData($crypt_data, $crypt_password, $CALG_AES_256)) ; Decrypted data
			GUICtrlSetData($edit_string_decrypt, $crypt_data_decrypted)
			_Crypt_Shutdown() ; Close the crypt library
			$date_time = @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
			GUICtrlSetData($edit_string_status, $date_time & " - Text string decryption done." & @CRLF, -1)
	EndSwitch
WEnd