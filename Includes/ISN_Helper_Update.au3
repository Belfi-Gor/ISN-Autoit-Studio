
Func _Show_Changelog()
	GUICtrlSetData($Changelog_GUI_Edit, "")
	GUICtrlSetData($Changelog_GUI_Edit, @CRLF & _Get_langstr(660) & @CRLF & StringReplace($readenchangelog, "[BREAK]", @CRLF) & @CRLF)
	GUISetState(@SW_SHOW, $Changelog_GUI)
	GUISetState(@SW_DISABLE, $Update_GUI)
EndFunc   ;==>_Show_Changelog

Func _Hide_Changelog()
	GUISetState(@SW_ENABLE, $Update_GUI)
	GUISetState(@SW_HIDE, $Changelog_GUI)
EndFunc   ;==>_Hide_Changelog



Func _Beginne_Suche_nach_updates()

	If FileExists($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\update.web") Then FileDelete($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\update.web")

	;Teste Internetverbindung
	GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(339))
	Sleep(1000) ;Waiting
	_Debug_zur_ISN_Konsole("Searching for Updates...", 1)
	If Ping("www.google.com", 1000) Then
		GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(7) & @CRLF)
	Else
		GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(817) & @CRLF)
		_Debug_zur_ISN_Konsole("|--> Ping 1 test failed! (www.google.com)", 2)
	EndIf

	;Teste Verbindung zu isnetwork.at
	GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(341))
	If Ping("www.isnetwork.at", 1000) Then
		GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(7) & @CRLF)
	Else
		GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(817) & @CRLF)
		_Debug_zur_ISN_Konsole("|--> Ping 2 test failed! (www.isnetwork.at)", 2)
	EndIf

	;Hole textfile
	GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(337))
	GUICtrlSetData($update_status, _Get_langstr(337))
	DirCreate($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache")
	$result = Download_File("https://www.isnetwork.at/ISNUPDATE/isnupdate.web", $ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web")
	If $result == -2 Then
		GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(25) & @CRLF)
		GUICtrlSetData($update_newversion, _Get_langstr(334) & " ?")
		GUICtrlSetData($update_status, _Get_langstr(340))
		GUICtrlSetColor($update_status, 0xFF0000)
		GUICtrlSetImage($Loading_logo, $bigiconsdll, 180)
		Button_AddIcon($update_cancelbutton, $smallIconsdll, 314, 0)
		GUICtrlSetData($update_cancelbutton, _Get_langstr(249))
		_Debug_zur_ISN_Konsole("|--> Error while searching for updates!", 3)
		Return 0
	Else
		GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(7) & " (" & $result & " Bytes " & _Get_langstr(345) & ")" & @CRLF)
	EndIf

	;Analysiere Textfile
	GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(346))
	If Not FileExists($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web") Then
		GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(25) & @CRLF)
		GUICtrlSetData($update_newversion, _Get_langstr(334) & " ?")
		GUICtrlSetData($update_status, _Get_langstr(340))
		GUICtrlSetColor($update_status, 0xFF0000)
		GUICtrlSetImage($Loading_logo, $bigiconsdll, 180)
		Button_AddIcon($update_cancelbutton, $smallIconsdll, 314, 0)
		GUICtrlSetData($update_cancelbutton, _Get_langstr(249))
		_Debug_zur_ISN_Konsole("|--> Error while searching for updates!", 3)
		Return 0
	Else
		$readenbuild = IniRead($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web", "ISNAUTOITSTUDIO", "build", "0")
		$readenversion = IniRead($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web", "ISNAUTOITSTUDIO", "version", "?")
		$readenpath = IniRead($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web", "ISNAUTOITSTUDIO", "path", "?")
		$readenchangelog = IniRead($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web", "ISNAUTOITSTUDIO", "changelog", "")

		If $readenbuild > $VersionBuild Then
			GUICtrlSetData($update_status, _Get_langstr(344))
			GUICtrlSetData($update_newversion, _Get_langstr(334) & " " & $readenversion & " (" & $readenbuild & ")")
			GUICtrlSetData($Update_gefunden_GUI_gefundene_Version, _Get_langstr(334) & " " & $readenversion & " (" & $readenbuild & ")")
			GUICtrlSetColor($Update_gefunden_GUI_aktuelle_Version, 0xFF0000)
			GUICtrlSetColor($update_currentversion, 0xFF0000)
			GUICtrlSetColor($update_status, 0xFF0000)
			GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(7) & @CRLF & @CRLF)
			GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(343) & " " & $readenversion & " (" & $readenbuild & ")" & @CRLF)
			GUICtrlSetState($update_gobutton, $GUI_ENABLE)
			GUICtrlSetState($update_changelog_button, $GUI_ENABLE)
			GUICtrlSetImage($Loading_logo, $bigiconsdll, 513)
			_Debug_zur_ISN_Konsole("|--> New update found! (" & $readenbuild & ")", 2)
			FileDelete($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web")
			Return 1
		Else
			GUICtrlSetData($update_newversion, _Get_langstr(334) & " " & $readenversion & " (" & $readenbuild & ")")
			GUICtrlSetData($Update_gefunden_GUI_gefundene_Version, _Get_langstr(334) & " " & $readenversion & " (" & $readenbuild & ")")
			GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(7) & @CRLF & @CRLF)
			GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(342) & @CRLF)
			GUICtrlSetData($update_status, _Get_langstr(342))
			GUICtrlSetColor($update_currentversion, 0x0B9C04)
			GUICtrlSetColor($Update_gefunden_GUI_aktuelle_Version, 0x0B9C04)
			GUICtrlSetColor($update_status, 0x0B9C04)
			GUICtrlSetState($update_gobutton, $GUI_DISABLE)
			GUICtrlSetImage($Loading_logo, $bigiconsdll, 9)
			Button_AddIcon($update_cancelbutton, $smallIconsdll, 314, 0)
			GUICtrlSetData($update_cancelbutton, _Get_langstr(249))
			_ISNPlugin_Studio_Config_Write_Value("autoupdate_lastdate", _NowCalcDate())
			_Debug_zur_ISN_Konsole("|--> No update found!", 1)
			FileDelete(@ScriptDir & "\Data\Cache\isnupdate.web")
			Return 2
		EndIf
	EndIf

EndFunc   ;==>_Beginne_Suche_nach_updates

Func _ISN_AutoIt_Studio_Install_Update($file = "")
	If $file = "" Then Return

	;Und los gehts..als erstes laufende ISN instanzen beenden
	AdlibUnRegister("_ISNPlugin_watch_guard") ;Unregister Watch Guard
	_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Exit_Force")
	GUISetState(@SW_HIDE, $Update_GUI)
	GUISetState(@SW_SHOW, $Update_Warte_GUI)
	Opt("WinTitleMatchMode", 2)
	Sleep(1000)
	For $tieout = 30000 To 0 Step -100
		If ProcessExists("Autoit_Studio.exe") = 0 And ProcessExists($ISN_AutoIt_Studio_PID) = 0 Then ExitLoop
		Sleep(100)
	Next
	Opt("WinTitleMatchMode", 1)
	ProcessClose("Autoit_Studio.exe")
	Sleep(1000)
	$Zu_entpackendes_Archiv = $file
	$Zielpfad = @ScriptDir
	$Runafter = @ScriptDir & "\Autoit_Studio.exe /finishupdate"
	$Killbefore = "Autoit_Studio.exe"

	If Not _Directory_Is_Accessible(@ScriptDir & "\Data") Then
		;Wir benötigen Admin Rechte um das Update zu installieren...da hilft uns die ISN_Adme.exe
		ShellExecute(@ScriptDir & '\Data\ISN_Adme.exe', '"/runasadmin ' & FileGetShortName(@ScriptDir & "\update_installer.exe") & '" "/source ' & $Zu_entpackendes_Archiv & '" "/destination ' & $Zielpfad & '" "/runafter ' & $Runafter & '" "/killbefore ' & $Killbefore & '" "/languagefile ' & $ISN_AutoIt_Studio_Languagefile_Path & '"', @ScriptDir & "\Data")
	Else
		;Admin Rechte sind nicht nötig
		ShellExecute(@ScriptDir & "\update_installer.exe", '"/source ' & $Zu_entpackendes_Archiv & '" "/destination ' & $Zielpfad & '" "/runafter ' & $Runafter & '" "/killbefore ' & $Killbefore & '" "/languagefile ' & $ISN_AutoIt_Studio_Languagefile_Path & '"', @ScriptDir & "\Data")
	EndIf
	If @error Then MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(359), 0)

	_GDIPlus_Shutdown()
	_USkin_Exit()
	Exit
EndFunc   ;==>_ISN_AutoIt_Studio_Install_Update


Func _Do_update()
	AdlibUnRegister("_ISNPlugin_watch_guard") ;Unregister Watch Guard
	GUICtrlSetImage($Loading_logo, $Loading2_Ani)
	GUICtrlSetState($Loading_logo, $GUI_SHOW)
	GUICtrlSetState($update_gobutton, $GUI_DISABLE)
	GUICtrlSetState($update_changelog_button, $GUI_DISABLE)
	FileDelete($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\update.web")
	GUICtrlSetData($update_log, GUICtrlRead($update_log) & @CRLF & _Get_langstr(348))
	GUICtrlSetData($update_status, _Get_langstr(348))
	GUICtrlSetColor($update_status, $Schriftfarbe)
	Sleep(1500) ;Waiting
	DllCall("user32.dll", "int", "RedrawWindow", "hwnd", $Update_GUI, "int", 0, "int", 0, "int", 0x1)
	_Debug_zur_ISN_Konsole("|--> Downloading updatefile...", 1, 0)
	$result = Download_File($readenpath, $ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\update.web")
	If $result == -2 Then
		GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(25) & @CRLF)
		GUICtrlSetData($update_status, _Get_langstr(340))
		GUICtrlSetColor($update_status, 0xFF0000)
		GUICtrlSetImage($Loading_logo, $bigiconsdll, 180)
		_Debug_zur_ISN_Konsole("ERROR", 3, 1, 1, 1)
		Return
	Else
		GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(7) & " (" & Round($result / 1024, 0) & " KB " & _Get_langstr(345) & ")" & @CRLF)
		GUICtrlSetState($update_cancelbutton, $GUI_DISABLE)
		GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(352))
		_ISNPlugin_Studio_Config_Write_Value("autoupdate_lastdate", _NowCalcDate())
		$localsize = FileGetSize($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\update.web")
		$websize = $result
		Sleep(500)
		If $localsize == $websize Then
			GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(7) & @CRLF)
			_Debug_zur_ISN_Konsole("done", 1, 1, 1, 1)
			GUICtrlSetImage($Loading_logo, $bigiconsdll, 9)

			MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(349), 0, $Update_GUI)
			_ISN_AutoIt_Studio_Install_Update($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\update.web")
			Return
		Else
			GUICtrlSetData($update_log, GUICtrlRead($update_log) & _Get_langstr(25) & @CRLF)
			GUICtrlSetData($update_status, _Get_langstr(340))
			GUICtrlSetColor($update_status, 0xFF0000)
			GUICtrlSetImage($Loading_logo, $bigiconsdll, 180)
			GUICtrlSetState($update_cancelbutton, $GUI_ENABLE)
			Return
		EndIf
	EndIf
EndFunc   ;==>_Do_update


Func Download_File($Source, $Dest)
	GUICtrlSetData($update_prgressbar, 0)
	$sUrl = $Source
	$sPath = $Dest
	If FileExists($sPath) Then
		FileDelete($Dest)
	EndIf
	$iFileSize = InetGetSize($sUrl, 1)
	$hDL = InetGet($sUrl, $sPath, 1, 1)
	Do
		$aInfo = InetGetInfo($hDL)
		$a = GUIGetCursorInfo($Update_GUI)
		If $a[4] = $update_cancelbutton And $a[2] = 1 Then
			InetClose($hDL)
			ExitLoop
		EndIf

		$iPercent = Round($aInfo[0] / $iFileSize * 100, 0)
		If $iPercent <> GUICtrlRead($update_prgressbar) Then
			GUICtrlSetData($update_prgressbar, $iPercent)
			GUICtrlSetData($update_prgressbarlabel, $iPercent & " %")
		EndIf
		Sleep(150)
	Until $aInfo[2]
	If $aInfo[3] Then
		;GUICtrlSetData($idHinweis, "erfolgreich heruntergeladen!")
		; MsgBox(0, "Fertig!", $sUrl & " wurde erfolgreich heruntergeladen!")
		GUICtrlSetData($update_prgressbar, 0)
		GUICtrlSetData($update_prgressbarlabel, "0 %")
		Return $iFileSize
	Else
		; GUICtrlSetData($idHinweis, "Download nicht erfolgreich, Internetverbindung prüfen")
		; MsgBox(0, "Fehler", $sUrl & "Internetverbindung prüfen!")
		GUICtrlSetData($update_prgressbar, 0)
		GUICtrlSetData($update_prgressbarlabel, "0 %")
		Return -2
	EndIf
	InetClose($hDL)
EndFunc   ;==>Download_File


Func _ISNHelper_Updater_exit()
	GUISetState(@SW_HIDE, $Update_GUI)
	FileDelete($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web")
	FileDelete($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\update.web")
	_GDIPlus_Shutdown()
	_USkin_Exit()
	Exit
EndFunc   ;==>_ISNHelper_Updater_exit


; #FUNCTION# ;===============================================================================
;
; Name...........: _Auto_Update_jetzt_nicht
; Description ...: Blendet das Fenster "Update verfügbar" aus. Der Timer wird dabei NICHT wiedergestartet
; Syntax.........: _Auto_Update_jetzt_nicht()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: -> Nächste Prüfung ist beim erneuten Programmstart
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Auto_Update_jetzt_nicht()
	GUISetState(@SW_HIDE, $Update_gefunden_GUI)
	;Der Timer wird hier bewusst nicht mehr gestartet da die Meldung sonst wieder erscheinen würde -> Nächste erinnerung ist beim erneuten Programmstart
	_ISNHelper_Updater_exit()
EndFunc   ;==>_Auto_Update_jetzt_nicht

; #FUNCTION# ;===============================================================================
;
; Name...........: _Auto_Update_in_X_Tagen_erinnern
; Description ...: Blendet das Fenster "Update verfügbar" aus und setzte den letzten erfolgreichen Suchvorgang auf das aktuelle Datum.
; Syntax.........: _Auto_Update_in_X_Tagen_erinnern()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Der Timer wird dabei NICHT wiedergestartet
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Auto_Update_in_X_Tagen_erinnern()
	GUISetState(@SW_HIDE, $Update_gefunden_GUI)
	;Der Timer wird hier bewusst nicht mehr gestartet da die Meldung sonst wieder erscheinen würde -> Nächste erinnerung ist in X Tagen
	_ISNPlugin_Studio_Config_Write_Value("autoupdate_lastdate", _NowCalcDate()) ;Suche wieder in X Tagen...
	_ISNHelper_Updater_exit()
EndFunc   ;==>_Auto_Update_in_X_Tagen_erinnern
