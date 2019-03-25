#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
	#AutoIt3Wrapper_Icon=..\installer_icon.ico
	#AutoIt3Wrapper_Res_Comment=https://www.isnetwork.at
	#AutoIt3Wrapper_Res_Description=ISN AutoIt Studio Update Installer
	#AutoIt3Wrapper_Res_Fileversion=1.0.0.2
	#AutoIt3Wrapper_Res_ProductVersion=1.0.0.2
	#AutoIt3Wrapper_Res_LegalCopyright=ISI360
	#AutoIt3Wrapper_Res_Language=1031
	#AutoIt3Wrapper_Res_Field=ProductName|ISN AutoIt Studio Update Installer
	#AutoIt3Wrapper_Run_Au3Stripper=y
	#Au3Stripper_Parameters=/mo
	#AutoIt3Wrapper_Res_HiDpi=Y
	#AutoIt3Wrapper_UseUpx=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs
	;Parameter für den installer:
	/source = Zu entpackende ZIP Datei (Kompletter Pfad)
	/destination = Zielpfad (Wohin die ZIP Entpackt wird)
	/runafter [optional]  = Zu Startende Datei nach dem Entpacken (Wird bei Fehlern ignoriert)
	/killbefore [optional] = Liste von Prozessen, die vor dem Entpacken beendet werden sollen. zb. "java.exe|explorer.exe". Getrennt wird mit |

	Beispiel:
	update_installer.exe "/source C:\temp\update.zip" "/destination C:\temp" "/runafter C:\temp\123.exe" "/killbefore java.exe|explorer.exe"
#ce

Global $Quelldatei = ""
Global $Zielpfad = ""
Global $Zu_startende_Datei_nach_install = ""
Global $Zu_beendende_Prozesse = ""
Global $Pfad_zur_Sprachdatei = @ScriptDir & "\Data\Language\german.lng"
Global $DPI = _GetDPI() ;Aus Windows hohlen
Global $Loading1_Ani = @ScriptDir & "\data\isn_loading_1.ani"


;CMD Befehle
If IsArray($CmdLine) Then
	For $x = 1 To $CmdLine[0]

		;/Source
		If StringInStr($CmdLine[$x], "/source ") Then
			$Quelldatei = StringStripWS(StringReplace($CmdLine[$x], "/source ", ""), 3)
		EndIf

		;/destination
		If StringInStr($CmdLine[$x], "/destination ") Then
			$Zielpfad = StringStripWS(StringReplace($CmdLine[$x], "/destination ", ""), 3)
		EndIf

		;/runafter
		If StringInStr($CmdLine[$x], "/runafter ") Then
			$Zu_startende_Datei_nach_install = StringStripWS(StringReplace($CmdLine[$x], "/runafter ", ""), 3)
		EndIf

		;/killbefore
		If StringInStr($CmdLine[$x], "/killbefore ") Then
			$Zu_beendende_Prozesse = StringStripWS(StringReplace($CmdLine[$x], "/killbefore ", ""), 3)
		EndIf

		;/languagefile
		If StringInStr($CmdLine[$x], "/languagefile ") Then
			$Pfad_zur_Sprachdatei = StringStripWS(StringReplace($CmdLine[$x], "/languagefile ", ""), 3)
		EndIf


		;/?
		If StringInStr($CmdLine[$x], "/?") Then
			MsgBox(0, "ISN AutoIt Studio Update Installer", "ISN AutoIt Studio Update Installer (c) 2017 by Christian Faderl" & @CRLF & "" & @CRLF & "Syntax:" & @CRLF & "	/source = Zu entpackende ZIP Datei (Kompletter Pfad)" & @CRLF & "	/destination = Zielpfad (Wohin die ZIP Entpackt wird)" & @CRLF & "	/runafter [optional]  = Zu startende Datei nach dem Entpacken (Wird bei Fehlern ignoriert)" & @CRLF & "	/languagefile = Pfad Zur Sprachdatei des ISN AutoIt Studios (für Texte)" & @CRLF & "	/killbefore [optional] = Liste von Prozessen, die vor dem Entpacken beendet werden sollen. zb. 'java.exe|explorer.exe'. Getrennt wird mit |" & @CRLF & "" & @CRLF & "	Beispiel:" & @CRLF & "	update_installer.exe '/source C:\temp\update.zip' '/destination C:\temp' '/runafter C:\temp\123.exe' '/killbefore java.exe|explorer.exe'", 0)
			Exit
		EndIf

	Next
EndIf


#include <GUIConstantsEx.au3>
#include "Includes\ISN_UDF_Zip32.au3"
#include "Forms\ISN_Update_wird_installiert.isf"
#include <array.au3>

If Not IsArray($CmdLine) Then Exit
If $CmdLine[0] = 0 Then
	MsgBox(16 + 262144, "ISN AutoIt Studio Update Installer - Error", "No parameters specified!", 0)
	Exit ;Es müssen Parameter angegeben werden!
EndIf


GUISetState(@SW_SHOW, $Update_GUI)


;Initialisiere unzip-Engine
_UnZip_Init("_UnZIP_PrintFunc", "UnZIP_ReplaceFunc", "_UnZIP_PasswordFunc", "_UnZIP_SendAppMsgFunc", "_UnZIP_ServiceFunc")
_UnZIP_SetOptions()


;~ ConsoleWrite($Quelldatei & @CRLF)
;~ ConsoleWrite($Zielpfad & @CRLF)
;~ ConsoleWrite($Zu_startende_Datei_nach_install & @CRLF)
;~ ConsoleWrite($Zu_beendende_Prozesse & @CRLF)


;Quelldatei prüfen
If $Quelldatei = "" Or $Zielpfad = "" Then
	MsgBox(16, "ISN AutoIt Studio Update Installer - " & _Get_langstr(25), "Too few parameters specified!", 0, $Update_GUI)
	Exit
EndIf


If Not FileExists($Quelldatei) Then
	MsgBox(16, "ISN AutoIt Studio Update Installer - " & _Get_langstr(25), "File (" & $Quelldatei & ") not found!", 0, $Update_GUI)
	Exit
EndIf

Sleep(1500) ;Warte noch 1,5 Sekunden

;zuerst prozesse killen
If $Zu_beendende_Prozesse <> "" Then
	$Prozesse_Array = StringSplit($Zu_beendende_Prozesse, "|", 3)
	If IsArray($Prozesse_Array) Then
		For $cnt = 0 To UBound($Prozesse_Array) - 1
			ProcessClose($Prozesse_Array[$cnt])
		Next
	EndIf
	Sleep(500)
EndIf


;Update instellieren
$update_result = _UnZIP_Unzip($Quelldatei, $Zielpfad)
If $update_result = 1 Then
	FileDelete($Quelldatei)
Else
	MsgBox(262160, "ISN AutoIt Studio Update Installer - " & _Get_langstr(25), _Get_langstr(359) & @CRLF & "Code: " & $update_result, 0, $Update_GUI)
	Exit
EndIf


;Runafter
If $Zu_startende_Datei_nach_install <> "" Then
	Run($Zu_startende_Datei_nach_install)
EndIf


Exit ;Und tschüss


;Gibt den gewünschten String (ID) in der aktuellen Sprache zurück ($Languagefile)
Func _Get_langstr($str)
	$get = IniRead($Pfad_zur_Sprachdatei, "ISNAUTOITSTUDIO", "str" & $str, "#LANGUAGE_ERROR#ID#" & $str)
	Return $get
EndFunc   ;==>_Get_langstr


;==========================# UnZIP Dll-callback functions #========================================
Func _UnZIP_PrintFunc($sName, $sPos)
	ConsoleWrite("---> _UnZIP_PrintFunc: " & $sName & @LF)
EndFunc   ;==>_UnZIP_PrintFunc

Func UnZIP_ReplaceFunc($sReplace)
	If MsgBox(4 + 32, "Overwrite", "File " & $sReplace & " is exists." & @LF & "Do you want to overwrite all file?") = 6 Then
		Return $IDM_REPLACE_ALL
	Else
		Return $IDM_REPLACE_NONE
	EndIf
EndFunc   ;==>UnZIP_ReplaceFunc

Func _UnZIP_PasswordFunc($sPWD, $sX, $sS2, $sName)
	ConsoleWrite("!> UnZIP_PasswordFunc: " & $sPWD & @LF)

	Local $iPass = InputBox("Password require", "Enter the password for decrypt", "", "", 300, 120)
	If $iPass = "" Then Return 1

	Local $PassBuff = DllStructCreate("char[256]", $sPWD)
	DllStructSetData($PassBuff, 1, $iPass)
EndFunc   ;==>_UnZIP_PasswordFunc

Func _UnZIP_SendAppMsgFunc($sUcsize, $sCsize, $sCfactor, $sMo, $Dy, $sYr, $sHh, $sMm, $sC, $sFname, $sMeth, $sCRC, $fCrypt)
	;ConsoleWrite("!> _UnZIP_SendAppMsgFunc: " & $sUcsize & @LF)
EndFunc   ;==>_UnZIP_SendAppMsgFunc

Func _UnZIP_ServiceFunc($sName, $sSize)
	;Return 1 for abort the unzip!
	;GUICtrlSetData($edit, $sName & @CRLF, 1)
	$sName = StringReplace($sName, @ScriptDir, "...")
	$sName = StringReplace($sName, "/", "\")
;~    ConsoleWrite($sName&" "&_Get_langstr(360)&" ("& round($sSize/1024,0)&" KB)"&@crlf)



	#cs
		ConsoleWrite("!> Size: " & $sSize & @LF & _
		"!> FileName" & $sName & @LF)
	#ce
EndFunc   ;==>_UnZIP_ServiceFunc

;DPI Func
Func _GetDPI()
	Local $hDC = _WinAPI_GetDC(0)
	Local $DPI = _WinAPI_GetDeviceCaps($hDC, 90)
	_WinAPI_ReleaseDC(0, $hDC)

	Select
		Case $DPI = 0
			$DPI = 1
		Case $DPI < 84
			$DPI /= 105
		Case $DPI < 121
			$DPI /= 96
		Case $DPI < 145
			$DPI /= 95
		Case Else
			$DPI /= 94
	EndSelect

	Return Round($DPI, 2)
EndFunc   ;==>_GetDPI

; #FUNCTION# ====================================================================================================================
; Name ..........: _Fenster_Resizen_und_zentrieren
; Description ...:
; Syntax ........: _Fenster_Resizen_und_zentrieren($win, $txt [, $width=Default [, $height=Default]])
; Parameters ....: $win                 - An unknown value.
;                  $txt                 - A dll struct value.
;                  $width               - [optional] An AutoIt controlID. Default is Default.
;                  $height              - [optional] A handle value. Default is Default.
; Return values .: None
; Author ........: Christian Faderl
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Fenster_Resizen_und_zentrieren($win, $txt, $width = Default, $height = Default)
	Local $size = WinGetClientSize($win, $txt)
	If Not ($width = Default) Then $size[0] = $width
	If Not ($height = Default) Then $size[1] = $height
	Local $x = (@DesktopWidth / 2) - ($size[0] / 2)
	Local $y = (@DesktopHeight / 2) - ($size[1] / 2)
	If $x < 0 Then $x = 0
	If $y < 0 Then $y = 0
	Return WinMove($win, $txt, $x, $y, $size[0], $size[1]) ; second winmove
EndFunc   ;==>_Fenster_Resizen_und_zentrieren


Func _Control_set_DPI_Scaling($handle = "", $no_resize = False)
	If $handle = "" Then Return

	If $DPI == 1 Then Return ;Bei 100% gibt´s nichts zu tun
	If IsHWnd($handle) Then

		$fenster_positionen = WinGetPos($handle)
		$fenster_ClientSize = WinGetClientSize($handle)

		If IsArray($fenster_positionen) And IsArray($fenster_ClientSize) Then

			$Client_size_dif_Width = $fenster_positionen[2] - $fenster_ClientSize[0]
			$Client_size_dif_height = $fenster_positionen[3] - $fenster_ClientSize[1]

			_Fenster_Resizen_und_zentrieren($handle, "", ($fenster_ClientSize[0] * $DPI) + $Client_size_dif_Width, ($fenster_ClientSize[1] * $DPI) + $Client_size_dif_height)

		EndIf
	Else
		$handle = GUICtrlGetHandle($handle)
		$control_positionen = ControlGetPos($handle, "", $handle)
		If IsArray($control_positionen) Then
			If $no_resize Then
				GUICtrlSetPos(_WinAPI_GetDlgCtrlID($handle), $control_positionen[0] * $DPI, $control_positionen[1] * $DPI)
			Else
				GUICtrlSetPos(_WinAPI_GetDlgCtrlID($handle), $control_positionen[0] * $DPI, $control_positionen[1] * $DPI, $control_positionen[2] * $DPI, $control_positionen[3] * $DPI)
			EndIf

		EndIf

	EndIf
EndFunc   ;==>_Control_set_DPI_Scaling
