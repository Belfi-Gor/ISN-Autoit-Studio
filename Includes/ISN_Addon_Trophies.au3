Global $Trophy0 = @ScriptDir & "\Data\trophy_black.png"
Global $Trophy1 = @ScriptDir & "\Data\trophy_bronze.png"
Global $Trophy2 = @ScriptDir & "\Data\trophy_silver.png"
Global $Trophy3 = @ScriptDir & "\Data\trophy_gold.png"


Func _Earn_trophy($trophy, $mode = 1)
	If $Studiomodus = 2 Then Return
	If $allow_trophys = "false" Then Return
	If IniRead($Configfile, "trophies", "TROP" & $trophy, "0") <> 0 Then Return
	While 1
		If WinExists("#TROPHY_ISNAUTOITSTUDIO#") = 0 Then ExitLoop
		Sleep(100)
	WEnd
	SoundPlay(@ScriptDir & "\Data\Trophy.mp3", 0)
	; Load PNG file as GDI bitmap
	_GDIPlus_Startup()
	$pngSrc = @ScriptDir & "\Data\Trophy.png"
	Global $hImageTROP = _GDIPlus_ImageLoadFromFile($pngSrc)
	$hImageTROP = _GDIPlus_ImageScale($hImageTROP, $DPI, $DPI, $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC)
	; Extract image width and height from PNG
	$width = _GDIPlus_ImageGetWidth($hImageTROP)
	$height = _GDIPlus_ImageGetHeight($hImageTROP)

	; Create layered window
	Global $TROPHYPNG = GUICreate("", $width, $height, 40, 80, $WS_POPUP, $WS_EX_LAYERED, $Studiofenster)
	SetBitmap($TROPHYPNG, $hImageTROP, 0)
	GUISetState()
	WinSetOnTop($TROPHYPNG, "", 1)
	SetBitmap($TROPHYPNG, $hImageTROP, 255)
	$str = ""
	If $trophy = 1 Then $str = _Get_langstr(265)
	If $trophy = 2 Then $str = _Get_langstr(270)
	If $trophy = 3 Then $str = _Get_langstr(272)
	If $trophy = 4 Then $str = _Get_langstr(276)
	If $trophy = 5 Then $str = _Get_langstr(278)
	If $trophy = 6 Then $str = _Get_langstr(280)
	If $trophy = 7 Then $str = _Get_langstr(282)
	If $trophy = 8 Then $str = _Get_langstr(285)
	If $trophy = 9 Then $str = _Get_langstr(287)
	If $trophy = 10 Then $str = _Get_langstr(289)
	If $trophy = 11 Then $str = _Get_langstr(291)
	If $trophy = 12 Then $str = _Get_langstr(293)
	If $trophy = 13 Then $str = _Get_langstr(556)
	If $trophy = 14 Then $str = _Get_langstr(558)


	Global $controlGui = GUICreate("#TROPHY_ISNAUTOITSTUDIO#", 300 * $DPI, 50 * $DPI, 65, 90, $WS_POPUP, -1, $TROPHYPNG)
	GUISetBkColor(0x3B3F40, $controlGui)
	GUICtrlCreatePic("", 0, 0, 50, 50, -1, -1)
	_Control_set_DPI_Scaling(-1)
	If $mode = 1 Then _SetImage(-1, $Trophy1)
	If $mode = 2 Then _SetImage(-1, $Trophy2)
	If $mode = 3 Then _SetImage(-1, $Trophy3)
	GUICtrlCreateLabel(_Get_langstr(274), 65, 4, 291, 33, -1, -1)
	_Control_set_DPI_Scaling(-1)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont(-1, 10, 800, Default, "Arial")
	GUICtrlCreateLabel($str, 65, 23, 291, 33, -1, -1)
	_Control_set_DPI_Scaling(-1)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont(-1, 14, 800, Default, "Arial")
	GUISetState()




	IniWrite($Configfile, "trophies", "TROP" & $trophy, "1")
	AdlibRegister("_hide_achivgui", 3000)

	If IniRead($Configfile, "trophies", "TROP1", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP2", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP3", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP4", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP5", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP6", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP7", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP8", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP9", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP10", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP11", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP13", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP14", "0") = 1 Then
		_Earn_trophy(12, 3)
	Else
		IniWrite($Configfile, "trophies", "TROP12", "0")
	EndIf


EndFunc   ;==>_Earn_trophy


Func _hide_achivgui()
	AdlibUnRegister("_hide_achivgui")
	GUIDelete($controlGui)
	For $i = 255 To 0 Step -5
		SetBitmap($TROPHYPNG, $hImageTROP, $i)
	Next
	GUIDelete($TROPHYPNG)
	_WinAPI_DeleteObject($hImageTROP)
	_GDIPlus_Shutdown()
EndFunc   ;==>_hide_achivgui


Func _Showtrophies()
	If $allow_trophys = "false" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(303), 0, $studiofenster)
		Return
	EndIf


	If IniRead($Configfile, "trophies", "TROP1", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP2", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP3", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP4", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP5", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP6", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP7", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP8", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP9", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP10", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP11", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP13", "0") = 1 And _
			IniRead($Configfile, "trophies", "TROP14", "0") = 1 Then
		_Earn_trophy(12, 3)
	Else
		IniWrite($Configfile, "trophies", "TROP12", "0")
	EndIf

_GUIToolTip_AddTool($hToolTip_CreditsGUI, 0, _Get_langstr(269),GUICtrlGetHandle($achiv1_icon))
_GUIToolTip_AddTool($hToolTip_CreditsGUI, 0, _Get_langstr(271),GUICtrlGetHandle($achiv2_icon))
_GUIToolTip_AddTool($hToolTip_CreditsGUI, 0, _Get_langstr(273),GUICtrlGetHandle($achiv3_icon))
_GUIToolTip_AddTool($hToolTip_CreditsGUI, 0, _Get_langstr(275),GUICtrlGetHandle($achiv4_icon))
_GUIToolTip_AddTool($hToolTip_CreditsGUI, 0, _Get_langstr(277),GUICtrlGetHandle($achiv5_icon))
_GUIToolTip_AddTool($hToolTip_CreditsGUI, 0, _Get_langstr(279),GUICtrlGetHandle($achiv6_icon))
_GUIToolTip_AddTool($hToolTip_CreditsGUI, 0, _Get_langstr(281),GUICtrlGetHandle($achiv7_icon))
_GUIToolTip_AddTool($hToolTip_CreditsGUI, 0, _Get_langstr(284),GUICtrlGetHandle($achiv8_icon))
_GUIToolTip_AddTool($hToolTip_CreditsGUI, 0, _Get_langstr(286),GUICtrlGetHandle($achiv9_icon))
_GUIToolTip_AddTool($hToolTip_CreditsGUI, 0, _Get_langstr(288),GUICtrlGetHandle($achiv10_icon))
_GUIToolTip_AddTool($hToolTip_CreditsGUI, 0, _Get_langstr(290),GUICtrlGetHandle($achiv11_icon))
_GUIToolTip_AddTool($hToolTip_CreditsGUI, 0, _Get_langstr(292),GUICtrlGetHandle($achiv12_icon))
_GUIToolTip_AddTool($hToolTip_CreditsGUI, 0, _Get_langstr(557),GUICtrlGetHandle($achiv13_icon))
_GUIToolTip_AddTool($hToolTip_CreditsGUI, 0, _Get_langstr(559),GUICtrlGetHandle($achiv14_icon))


	If IniRead($Configfile, "trophies", "TROP1", "0") = 0 Then
		_SetImage($achiv1_icon, $Trophy0)
		GUICtrlSetData($achiv1_txt, "?")
	Else
		_SetImage($achiv1_icon, $Trophy1)
		GUICtrlSetData($achiv1_txt, _Get_langstr(265))
	EndIf

	If IniRead($Configfile, "trophies", "TROP2", "0") = 0 Then
		_SetImage($achiv2_icon, $Trophy0)
		GUICtrlSetData($achiv2_txt, "?")
	Else
		_SetImage($achiv2_icon, $Trophy1)
		GUICtrlSetData($achiv2_txt, _Get_langstr(270))
	EndIf

	If IniRead($Configfile, "trophies", "TROP3", "0") = 0 Then
		_SetImage($achiv3_icon, $Trophy0)
		GUICtrlSetData($achiv3_txt, "?")
	Else
		_SetImage($achiv3_icon, $Trophy1)
		GUICtrlSetData($achiv3_txt, _Get_langstr(272))
	EndIf

	If IniRead($Configfile, "trophies", "TROP4", "0") = 0 Then
		_SetImage($achiv4_icon, $Trophy0)
		GUICtrlSetData($achiv4_txt, "?")
	Else
		_SetImage($achiv4_icon, $Trophy1)
		GUICtrlSetData($achiv4_txt, _Get_langstr(276))
	EndIf

	If IniRead($Configfile, "trophies", "TROP5", "0") = 0 Then
		_SetImage($achiv5_icon, $Trophy0)
		GUICtrlSetData($achiv5_txt, "?")
	Else
		_SetImage($achiv5_icon, $Trophy1)
		GUICtrlSetData($achiv5_txt, _Get_langstr(278))
	EndIf

	If IniRead($Configfile, "trophies", "TROP6", "0") = 0 Then
		_SetImage($achiv6_icon, $Trophy0)
		GUICtrlSetData($achiv6_txt, "?")
	Else
		_SetImage($achiv6_icon, $Trophy1)
		GUICtrlSetData($achiv6_txt, _Get_langstr(280))
	EndIf

	If IniRead($Configfile, "trophies", "TROP7", "0") = 0 Then
		_SetImage($achiv7_icon, $Trophy0)
		GUICtrlSetData($achiv7_txt, "?")
	Else
		_SetImage($achiv7_icon, $Trophy2)
		GUICtrlSetData($achiv7_txt, _Get_langstr(282))
	EndIf

	If IniRead($Configfile, "trophies", "TROP8", "0") = 0 Then
		_SetImage($achiv8_icon, $Trophy0)
		GUICtrlSetData($achiv8_txt, "?")
	Else
		_SetImage($achiv8_icon, $Trophy2)
		GUICtrlSetData($achiv8_txt, _Get_langstr(285))
	EndIf

	If IniRead($Configfile, "trophies", "TROP9", "0") = 0 Then
		_SetImage($achiv9_icon, $Trophy0)
		GUICtrlSetData($achiv9_txt, "?")
	Else
		_SetImage($achiv9_icon, $Trophy2)
		GUICtrlSetData($achiv9_txt, _Get_langstr(287))
	EndIf

	If IniRead($Configfile, "trophies", "TROP10", "0") = 0 Then
		_SetImage($achiv10_icon, $Trophy0)
		GUICtrlSetData($achiv10_txt, "?")
	Else
		_SetImage($achiv10_icon, $Trophy3)
		GUICtrlSetData($achiv10_txt, _Get_langstr(289))
	EndIf

	If IniRead($Configfile, "trophies", "TROP11", "0") = 0 Then
		_SetImage($achiv11_icon, $Trophy0)
		GUICtrlSetData($achiv11_txt, "?")
	Else
		_SetImage($achiv11_icon, $Trophy3)
		GUICtrlSetData($achiv11_txt, _Get_langstr(291))
	EndIf

	If IniRead($Configfile, "trophies", "TROP12", "0") = 0 Then
		_SetImage($achiv12_icon, $Trophy0)
		GUICtrlSetData($achiv12_txt, "?")
	Else
		_SetImage($achiv12_icon, $Trophy3)
		GUICtrlSetData($achiv12_txt, _Get_langstr(293))
	EndIf

	If IniRead($Configfile, "trophies", "TROP13", "0") = 0 Then
		_SetImage($achiv13_icon, $Trophy0)
		GUICtrlSetData($achiv13_txt, "?")
	Else
		_SetImage($achiv13_icon, $Trophy1)
		GUICtrlSetData($achiv13_txt, _Get_langstr(556))
	EndIf

	If IniRead($Configfile, "trophies", "TROP14", "0") = 0 Then
		_SetImage($achiv14_icon, $Trophy0)
		GUICtrlSetData($achiv14_txt, "?")
	Else
		_SetImage($achiv14_icon, $Trophy3)
		GUICtrlSetData($achiv14_txt, _Get_langstr(558))
	EndIf


	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_SHOW, $trophys)
EndFunc   ;==>_Showtrophies

Func _hide_trophy()
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $trophys)
EndFunc   ;==>_hide_trophy

Func _reset_trophys_config()
	$answer = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(555), 0, $config_GUI)
	If $answer = 6 Then
		IniDelete($Configfile, "trophies")
	EndIf
EndFunc   ;==>_reset_trophys_config

Func _reset_trophys()
	$state = WinGetState($config_GUI, "")
	If BitAND($state, 2) Then
		_reset_trophys_config()
		Return
	EndIf
	$answer = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(555), 0, $trophys)
	If $answer = 6 Then
		IniDelete($Configfile, "trophies")
	EndIf
	_Showtrophies()
EndFunc   ;==>_reset_trophys


; I don't like AutoIt's built in ShellExec. I'd rather do the DLL call myself.
Func _ShellExecute($sCmd, $sArg = "", $sFolder = "", $rState = @SW_SHOWNORMAL)
	$aRet = DllCall("shell32.dll", "long", "ShellExecute", _
			"hwnd", 0, _
			"string", "", _
			"string", $sCmd, _
			"string", $sArg, _
			"string", $sFolder, _
			"int", $rState)
	If @error Then Return 0

	$RetVal = $aRet[0]
	If $RetVal > 32 Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_ShellExecute

