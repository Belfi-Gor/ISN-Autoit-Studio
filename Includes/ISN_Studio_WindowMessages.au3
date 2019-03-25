
Func _WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)

	_WM_NOTIFY_EDITOR($hWnd, $iMsg, $iwParam, $ilParam) ;Versuche zuerst NOTIFY´s für das Scintilla Control

	;Return..if it´s a Scintilla control
	Local $structNMHDR = DllStructCreate("hwnd hWndFrom;int IDFrom;int Code", $ilParam) ; tagNMHDR
	Local $sClassName = DllCall("User32.dll", "int", "GetClassName", "hwnd", DllStructGetData($structNMHDR, 1), "str", "", "int", 512)
	$sClassName = $sClassName[2]
	If $sClassName = "Scintilla" Then Return 'GUI_RUNDEFMSG'


	$nID = BitAND($iwParam, 0x0000FFFF) ;für Alle ;)

	;########################### NOTIF´s für den TAB und die Debug Console ###########################
	Local $hWndtabView, $tNMHDR, $hwndFrom, $iCode
	If Not IsHWnd($hWndtabView) Then $hWndtabView = GUICtrlGetHandle($hWndtabView)
	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hwndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hwndFrom

		Case $quickview_tab_dummy
			Switch $iCode
				Case $NM_CLICK
					_QuickView_Tab_Event()
			EndSwitch


		Case GUICtrlGetHandle($htab)
			Switch $iCode
				Case $NM_RCLICK

					Local $tPOINT = _WinAPI_GetMousePos(True, $hwndFrom)
					Local $iX = DllStructGetData($tPOINT, "X")
					Local $iY = DllStructGetData($tPOINT, "Y")
					Local $hItem = _GUICtrlTab_HitTest($hwndFrom, $iX, $iY)
					If $hItem <> 0 Then
						If $hItem[0] = _GUICtrlTab_GetCurFocus($htab) Then Return
						_GUICtrlTab_ActivateTabX($htab, $hItem[0])
						_Show_Tab($hItem[0])
					EndIf

			EndSwitch
	EndSwitch





	;########################### Debug Console (Rich Edit) ###########################
	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hwndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hwndFrom
		Case $console_chatbox
			Select
				Case $iCode = $EN_MSGFILTER
					$tMsgFilter = DllStructCreate($tagMSGFILTER, $ilParam)
					If DllStructGetData($tMsgFilter, "msg") = $WM_LBUTTONDOWN Then
						If GUICtrlRead($debug_console_selecttextmode_checkbox) = $GUI_UNCHECKED Then GUICtrlSetState($console_commandinput, $GUI_FOCUS)
					EndIf
			EndSelect
	EndSwitch





	;########################### NOTIF´s für diverse Listviews (Startupscreen,Einstellungen...) ###########################
	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hwndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")



	Switch $iCode

		Case $TTN_GETDISPINFOW, $TTN_GETDISPINFO ;Tooltips for Tabitems
			Local $tagNMTTDISPINFOW = "hwnd hWndFrom;int IDFrom;int Code;ptr lpszText;wchar szText[80];hwnd hinst;uint uFlags;"
			Local $NMHDR = DllStructCreate($tagNMTTDISPINFOW, $ilParam)
			Local $IdFrom = DllStructGetData($NMHDR, 2)
			Local $g_tStruct = DllStructCreate($tagPOINT)
			DllStructSetData($g_tStruct, "x", MouseGetPos(0))
			DllStructSetData($g_tStruct, "y", MouseGetPos(1))
			$FromPoint_control = _WinAPI_WindowFromPoint($g_tStruct)
			Switch $FromPoint_control

				Case GUICtrlGetHandle($htab)
				   if $IdFrom < 0 OR $IdFrom > 29 then return
					Local $tooltip_text = $Datei_pfad[$IdFrom]
					_GUIToolTip_UpdateTipText($hToolTip_StudioFenster, 0, GUICtrlGetHandle($htab), $tooltip_text)

				Case $quickview_tab_dummy
					If $QuickView_NoTextinTabs = "true" Then
						_GUIToolTip_UpdateTipText($hToolTip_QuickView_GUI, 0, $quickview_tab_dummy, _QuickView_Get_TabTextfromIndex($IdFrom))
					Else
						_GUIToolTip_UpdateTipText($hToolTip_QuickView_GUI, 0, $quickview_tab_dummy, "")
					EndIf

			EndSwitch





		Case $LVN_KEYDOWN
			If _IsPressed("26", $user32) Or _IsPressed("28", $user32) Then
				If $nID = $changelogmanager_listview Then AdlibRegister("_changelogmanager_lade_eintrag", 1)
				If $nID = $Projects_Listview_projectman Then AdlibRegister("_Load_Details_Manager", 1)
				If $nID = $Pugins_Listview Then AdlibRegister("_load_plugindetails", 1)
				If $nID = $config_skin_list Then AdlibRegister("_load_skindetails", 1)
			EndIf


			;Färbung für Listviews
		Case $NM_CUSTOMDRAW
			Local $tNMLVCUSTOMDRAW = DllStructCreate($tagNMLVCUSTOMDRAW, $ilParam)
			Local $dwDrawStage = DllStructGetData($tNMLVCUSTOMDRAW, "dwDrawStage")
			Switch $dwDrawStage
				Case $CDDS_PREPAINT
					Return $CDRF_NOTIFYITEMDRAW
				Case $CDDS_ITEMPREPAINT
					Return $CDRF_NOTIFYSUBITEMDRAW
				Case BitOR($CDDS_ITEMPREPAINT, $CDDS_SUBITEM)
					Local $iSubItem = DllStructGetData($tNMLVCUSTOMDRAW, "iSubItem")
					Local $dwItemSpec = DllStructGetData($tNMLVCUSTOMDRAW, "dwItemSpec")
					Local $hDC = DllStructGetData($tNMLVCUSTOMDRAW, "HDC")
					Switch $nID

						; DllStructSetData( $tNMLVCUSTOMDRAW, "ClrText", Listview_ColorConvert(0x000000))
						Case $quick_view_ToDoList_Listview
							$color = _ToDo_Liste_Kategoriefarbe_nach_Item_herausfinden($quick_view_ToDoList_Listview, $dwItemSpec)
							If $color <> "" Then DllStructSetData($tNMLVCUSTOMDRAW, "ClrTextBk", Listview_ColorConvert($color))

						Case $ToDoList_Listview
							$color = _ToDo_Liste_Kategoriefarbe_nach_Item_herausfinden($ToDoList_Listview, $dwItemSpec)
							If $color <> "" Then DllStructSetData($tNMLVCUSTOMDRAW, "ClrTextBk", Listview_ColorConvert($color))

						Case $Category_Manager_Listview
							$color = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", _GUICtrlListView_GetItemText($Category_Manager_Listview, $dwItemSpec, 0) & "_color", "")
							If $color <> "" Then DllStructSetData($tNMLVCUSTOMDRAW, "ClrTextBk", Listview_ColorConvert($color))

						Case $ParameterEditor_ListView
							$color = ""
							If _GUICtrlListView_GetItemText($ParameterEditor_ListView, $dwItemSpec, 0) = _Get_langstr(1359) Or _GUICtrlListView_GetItemText($ParameterEditor_ListView, $dwItemSpec, 0) = _Get_langstr(1360) Then $color = $scripteditor_rowcolour
							If $color <> "" Then DllStructSetData($tNMLVCUSTOMDRAW, "ClrTextBk", Listview_ColorConvert($color))


					EndSwitch
					Return $CDRF_NEWFONT
			EndSwitch



		Case $LVN_BEGINDRAG
			$tNMLISTVIEW = DllStructCreate($tagNMLISTVIEW, $ilParam)
			$iEndIndex = DllStructGetData($tNMLISTVIEW, 'Item')
			$iEndSubIndex = DllStructGetData($tNMLISTVIEW, 'SubItem')
			Switch $nID

				;Bei folgenden Listviews gibt es eine Aktion wenn etwas via Dag and Drop versucht wird. Das ganze geht an die $LVN_HOTTRACK weiter...
				Case $quick_view_ToDoList_Listview
					$Listview_Drag_aktiv = 1

				Case $ToDoList_Listview
					$Listview_Drag_aktiv = 1

				Case $Projects_Listview_projectman
					$Listview_Drag_aktiv = 1

			EndSwitch


		Case $LVN_HOTTRACK
			If $Listview_Drag_aktiv = 1 Then ;Nur wen bereits eine Drag and Drop aktion läuft
				$Listview_Drag_aktiv = 0
				$tNMLISTVIEW = DllStructCreate($tagNMLISTVIEW, $ilParam)
				$iEndIndex = DllStructGetData($tNMLISTVIEW, 'Item')
				$iEndSubIndex = DllStructGetData($tNMLISTVIEW, 'SubItem')

				Switch $nID

					Case $quick_view_ToDoList_Listview
						_ToDo_Liste_Aufgabe_in_andere_Kategorie_verschieben($quick_view_ToDoList_Listview, _GUICtrlListView_GetItemText($quick_view_ToDoList_Listview, $iEndIndex, 1))

					Case $ToDoList_Listview
						_ToDo_Liste_Aufgabe_in_andere_Kategorie_verschieben($ToDoList_Listview, _GUICtrlListView_GetItemText($ToDoList_Listview, $iEndIndex, 1))

					Case $Projects_Listview_projectman
						_Projectmanager_move_project_to_new_location_drag(_GUICtrlListView_GetItemText($Projects_Listview_projectman, $iEndIndex, 3))



				EndSwitch
			EndIf

		Case $TVN_SELCHANGEDA, $TVN_SELCHANGEDW
			If $nID = $config_selectorlist Then _select_settingscategory()
			If $nID = $projekteinstellungen_navigation Then _Projekteinstellungen_Navigation_Event()


		Case $NM_CLICK

			If $nID = $listview_projectrules Then _load_ruledetails()
			If $nID = $Pugins_Listview Then _load_plugindetails()
			If $nID = $config_skin_list Then _load_skindetails()
			If $nID = $Projects_Listview_projectman Then _Load_Details_Manager()
			If $nID = $changelogmanager_listview Then _changelogmanager_lade_eintrag()
			If $nID = $FuncListview Then GUICtrlSetData($Funcinput, _GUICtrlListView_GetItemText($FuncListview, _GUICtrlListView_GetSelectionMark($FuncListview), 0))


		Case $NM_DBLCLK
			If $nID = $Projects_Listview Then _Try_to_Open_project()
			If $nID = $new_rule_triggerlist Then _edit_trigger()
			If $nID = $listview_projectrules Then _Editiere_Regel()
			If $nID = $makro_auswaehlen_listview Then _AU3_mit_vorhandenen_Makro_kompilieren_Makro_auswaehlen()
			If $nID = $Projects_Listview_projectman Then _Try_to_Open_projectman()
			If $nID = $vorlagen_Listview_projectman Then _Try_to_Open_template()
			If $nID = $new_rule_actionlist Then _edit_action()
			If $nID = $settings_hotkeylistview Then _show_Edit_Hotkey()
			If $nID = $einstellungen_toolbar_verfuegbareelemente_listview Then _Einstellungen_Toolbar_Eintrag_hinzufuegen()
			If $nID = $einstellungen_toolbar_aktiveelemente_listview Then _Einstellungen_Toolbar_entferne_Eintrag()
			If $nID = $in_dateien_suchen_gefundene_elemente_listview Then _In_Datei_suchen_Eintrag_oeffnen()
			If $nID = $FuncListview Then
				GUICtrlSetData($Funcinput, _GUICtrlListView_GetItemText($FuncListview, _GUICtrlListView_GetSelectionMark($FuncListview), 0))
				_func_select_ok()
			EndIf
			If $nID = $Category_Manager_Listview Then _ToDo_Liste_Kategorien_verwalten_Markierte_Kategorie_bearbeiten()
			If $nID = $ToDoList_Listview Then _ToDo_Liste_Aufgabe_Bearbeiten_Manager()
			If $nID = $quick_view_ToDoList_Listview Then _ToDo_Liste_Aufgabe_Bearbeiten_QuickView()

		Case $LVN_COLUMNCLICK ; A column was clicked
			$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
			$iColumnIndex = DllStructGetData($tInfo, "SubItem")
			If $nID = $Projects_Listview Then _HeaderSort($Projects_Listview, $iColumnIndex)
			If $nID = $Projects_Listview_projectman Then _Sortiere_Listview($Projects_Listview_projectman, $iColumnIndex)
			If $nID = $vorlagen_Listview_projectman Then _HeaderSort($vorlagen_Listview_projectman, $iColumnIndex)
			If $nID = $FuncListview Then _HeaderSort($FuncListview, $iColumnIndex)
			If $nID = $settings_hotkeylistview Then _Sortiere_Listview($settings_hotkeylistview, $iColumnIndex)







		Case $NM_RCLICK
			If $nID = $Projects_Listview_projectman Then _Load_Details_Manager()

			$tPOINT = _WinAPI_GetMousePos(True, $Studiofenster)
			Local $iX = DllStructGetData($tPOINT, "X")
			Local $iY = DllStructGetData($tPOINT, "Y")

			Local $aPos = ControlGetPos($Studiofenster, "", $htab)

			Local $aHit = _GUICtrlTab_HitTest($htab, $iX - $aPos[0], $iY - $aPos[1])
			If $aHit[0] <> -1 And _GUICtrlTab_GetCurFocus($htab) <> -1 Then _GUICtrlTab_SetCurSel($htab, _GUICtrlTab_GetCurFocus($htab))
			If _GUICtrlTab_GetCurFocus($htab) = -1 And _GUICtrlTab_GetItemCount($htab) > 0 Then
				_GUICtrlTab_SetCurSel($htab, 0)
				_Show_Tab(0)
			EndIf

	EndSwitch

	;########################### NOTIF´s für die Toolbar (Dropdown zb. für Dropdownmenüs) ###########################
	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hwndFrom = DllStructGetData($tNMHDR, "hWndFrom")
	$IdFrom = DllStructGetData($tNMHDR, "IDFrom")
	$code = DllStructGetData($tNMHDR, "Code")

	Switch $hwndFrom
		Case $hToolbar
			Switch $code
				Case $TBN_DROPDOWN

					$hMenu = _GUICtrlMenu_CreatePopup()
					Switch $iItem
						Case $id1
							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(154), $Toolbarmenu1)
							_GUICtrlMenu_SetItemBmp($hMenu, 0, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 1788, 16, 16))
							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(1094) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Create_Temp_Au3_Script), $Kontextmenu_tempau3file)
							_GUICtrlMenu_SetItemBmp($hMenu, 1, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 1788, 16, 16))
							If $Studiomodus = 1 Then
								_GUICtrlMenu_SetItemGrayed($hMenu, 1, False)
							Else
								_GUICtrlMenu_SetItemGrayed($hMenu, 1, True)
							EndIf
							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(153), $Toolbarmenu2)
							_GUICtrlMenu_SetItemBmp($hMenu, 2, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 780, 16, 16))
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 1, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 780, 16, 16), 1, 1))
							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(155), $Toolbarmenu3)
							_GUICtrlMenu_SetItemBmp($hMenu, 3, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 1176, 16, 16))
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 2, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 1176, 16, 16), 1, 1))
							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(156), $Toolbarmenu4)
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 3, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 1177, 16, 16), 1, 1))
							_GUICtrlMenu_SetItemBmp($hMenu, 4, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 1177, 16, 16))

						Case $id7
							If $Studiomodus = 1 Then
								_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(50) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt), $Toolbarmenu_project1)
								_GUICtrlMenu_SetItemGrayed($hMenu, 0, False)
							Else
								_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(668) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt), $Toolbarmenu_project1)
								_GUICtrlMenu_SetItemGrayed($hMenu, 0, True)
								If Not _GUICtrlTab_GetItemCount($htab) = 0 Then
									Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
									If $GUICtrlTab_GetCurFocus <> -1 Then
										If StringTrimLeft($Datei_pfad[$GUICtrlTab_GetCurFocus], StringInStr($Datei_pfad[$GUICtrlTab_GetCurFocus], ".", 0, -1)) = $Autoitextension Then
											_GUICtrlMenu_SetItemGrayed($hMenu, 0, False)
										EndIf
									EndIf
								EndIf
							EndIf
							_GUICtrlMenu_SetItemBmp($hMenu, 0, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 220, 16, 16))
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 0, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 220, 16, 16), 1, 1))
							If $Studiomodus = 1 Then
								_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(488) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt_ohne_Parameter), $Toolbarmenu_project2)
								_GUICtrlMenu_SetItemGrayed($hMenu, 1, False)
							Else
								_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(669) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt_ohne_Parameter), $Toolbarmenu_project2)
								_GUICtrlMenu_SetItemGrayed($hMenu, 1, True)
								Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
								If _GUICtrlTab_GetItemCount($htab) <> 0 And $GUICtrlTab_GetCurFocus <> -1 Then
									If StringTrimLeft($Datei_pfad[$GUICtrlTab_GetCurFocus], StringInStr($Datei_pfad[$GUICtrlTab_GetCurFocus], ".", 0, -1)) = $Autoitextension Then
										_GUICtrlMenu_SetItemGrayed($hMenu, 1, False)
									EndIf
								EndIf
							EndIf
							_GUICtrlMenu_SetItemBmp($hMenu, 1, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 220, 16, 16))
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 1, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 220, 16, 16), 1, 1))
							_GUICtrlMenu_AddMenuItem($hMenu, "")
							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(490), $Toolbarmenu_project3)
							_GUICtrlMenu_SetItemBmp($hMenu, 3, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 1376, 16, 16))
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 3, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 1376, 16, 16), 1, 1))

						Case $id8
							$str = ""
							If $Studiomodus = 1 Then
								$str = _Get_langstr(52)
							Else
								$str = _Get_langstr(601)
							EndIf
							_GUICtrlMenu_AddMenuItem($hMenu, $str & @TAB & _Keycode_zu_Text($Hotkey_Keycode_compile), $Toolbarmenu_compile1)
							_GUICtrlMenu_SetItemBmp($hMenu, 0, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 527, 16, 16))
							_GUICtrlMenu_SetItemGrayed($hMenu, 0, True)
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 0, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 527, 16, 16), 1, 1))
							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(1063), $Toolbarmenu_compile_daten_waehlen)
							_GUICtrlMenu_SetItemBmp($hMenu, 1, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 529, 16, 16))
							_GUICtrlMenu_SetItemGrayed($hMenu, 1, True)

							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(563) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_compile_Settings), $Toolbarmenu_compile2)
							_GUICtrlMenu_SetItemBmp($hMenu, 2, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 529, 16, 16))
							_GUICtrlMenu_SetItemGrayed($hMenu, 2, True)
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 1, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 529, 16, 16), 1, 1))
							If $Studiomodus = 1 Then
								_GUICtrlMenu_SetItemGrayed($hMenu, 0, False)
								_GUICtrlMenu_SetItemGrayed($hMenu, 1, False)
								_GUICtrlMenu_SetItemGrayed($hMenu, 2, False)
							EndIf
							If $Studiomodus = 2 And _GUICtrlTab_GetItemCount($htab) <> 0 Then
								Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
								If $GUICtrlTab_GetCurFocus <> -1 Then
									If StringTrimLeft($Datei_pfad[$GUICtrlTab_GetCurFocus], StringInStr($Datei_pfad[$GUICtrlTab_GetCurFocus], ".", 0, -1)) = $Autoitextension Then
										_GUICtrlMenu_SetItemGrayed($hMenu, 0, False)
										_GUICtrlMenu_SetItemGrayed($hMenu, 1, True)
										_GUICtrlMenu_SetItemGrayed($hMenu, 2, False)
									EndIf
								EndIf
							EndIf

					EndSwitch
					$aRet = _GetToolbarButtonScreenPos($Studiofenster, $hToolbar, $iItem, 2)
					If Not IsArray($aRet) Then
						Dim $aRet[2] = [-1, -1]
					EndIf

					; send button dropdown menu item commandID to dummy control for use in GuiGetMsg() or GUICtrlSetOnEvent()
					; allows quick return from message handler : See warning for GUIRegisterMsg() in helpfile
					$iMenuID = _GUICtrlMenu_TrackPopupMenu($hMenu, $hToolbar, $aRet[0], $aRet[1], 1, 1, 2)
					If $iMenuID = $Toolbarmenu1 Then _Show_new_Filgui_au3()
					If $iMenuID = $Kontextmenu_tempau3file Then _erstelle_neues_temporaeres_skript()
					If $iMenuID = $Toolbarmenu2 Then _Show_new_Filgui_isf()
					If $iMenuID = $Toolbarmenu3 Then _Show_new_Filgui_ini()
					If $iMenuID = $Toolbarmenu4 Then _Show_new_Filgui_txt()
					If $iMenuID = $Toolbarmenu_project1 Then _ISN_Projekt_Testen()
					If $iMenuID = $Toolbarmenu_project2 Then _ISN_Projekt_Testen_ohne_Parameter()
					If $iMenuID = $Toolbarmenu_project3 Then _Show_Parameterconfig()
					If $iMenuID = $Toolbarmenu_compile1 Then _Start_Compiling()
					If $iMenuID = $Toolbarmenu_compile2 Then _Show_Compile()
					If $iMenuID = $Toolbarmenu_compile_daten_waehlen Then _Weitere_Dateien_zum_Kompilieren_waehlen()
					_GUICtrlMenu_DestroyMenu($hMenu)
					;If $iMenuID Then Return $TBDDRET_TREATPRESSED
					Return $TBDDRET_DEFAULT

				Case $TBN_HOTITEMCHANGE
					$tNMTBHOTITEM = DllStructCreate($tagNMTBHOTITEM, $ilParam)
					$i_idOld = DllStructGetData($tNMTBHOTITEM, "idOld")
					$i_idNew = DllStructGetData($tNMTBHOTITEM, "idNew")
					$iItem = $i_idNew
					$dwFlags = DllStructGetData($tNMTBHOTITEM, "dwFlags")

			EndSwitch
	EndSwitch



	;########################### Tooltips für die Toolbar (musste ab 1.03 über WIM gelöst werden, da sonst die Toolbar nicht skaliert werden kann)###########################
	Local $tNMHDR2, $hWndFrom2, $iCode2
	$tNMHDR2 = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom2 = HWnd(DllStructGetData($tNMHDR2, "hWndFrom"))
	$iIDFrom2 = DllStructGetData($tNMHDR2, "IDFrom")
	$iCode2 = DllStructGetData($tNMHDR2, "Code")
	$tInfo = DllStructCreate($tagNMTTDISPINFO, $ilParam)
	$iCode = DllStructGetData($tInfo, "Code")

	;Native Tooltips für Toolbar OHNE SKIN!
	If $iCode = $TTN_GETDISPINFOW Then
		$iID = DllStructGetData($tInfo, "IDFrom")
		Switch $iID
			Case $id1 ;new file
				DllStructSetData($tInfo, "aText", _Get_langstr(43))
			Case $id2 ;new folder
				DllStructSetData($tInfo, "aText", _Get_langstr(46))
			Case $id3 ;import
				DllStructSetData($tInfo, "aText", _Get_langstr(44))
			Case $id4 ;export
				DllStructSetData($tInfo, "aText", _Get_langstr(49))
			Case $id5 ;löschen
				DllStructSetData($tInfo, "aText", _Get_langstr(45))
			Case $id6 ;projecttree
				DllStructSetData($tInfo, "aText", _Get_langstr(53))
			Case $id7 ;testproject
				DllStructSetData($tInfo, "aText", _Get_langstr(50))
			Case $id8 ;Projekt kompilieren
				DllStructSetData($tInfo, "aText", _Get_langstr(52))
			Case $id9 ;Projekt Eigenschaften
				DllStructSetData($tInfo, "aText", _Get_langstr(51))
			Case $id10 ;speichern
				DllStructSetData($tInfo, "aText", _Get_langstr(54))
			Case $id11 ;undo
				DllStructSetData($tInfo, "aText", _Get_langstr(55))
			Case $id12 ;redo
				DllStructSetData($tInfo, "aText", _Get_langstr(56))
			Case $id13 ;closetab
				DllStructSetData($tInfo, "aText", _Get_langstr(80))
			Case $id14 ;testscript
				DllStructSetData($tInfo, "aText", _Get_langstr(82))
			Case $id15 ;stopscript
				DllStructSetData($tInfo, "aText", _Get_langstr(106))
			Case $id16 ;search
				DllStructSetData($tInfo, "aText", _Get_langstr(85))
			Case $id17 ;syntaxcheck
				DllStructSetData($tInfo, "aText", _Get_langstr(108))
			Case $id18 ;tidy
				DllStructSetData($tInfo, "aText", _Get_langstr(327))
			Case $id19 ;import folder
				DllStructSetData($tInfo, "aText", _Get_langstr(455))
			Case $id20 ;fullscreenmode
				DllStructSetData($tInfo, "aText", _Get_langstr(457))
			Case $id22 ;macros
				DllStructSetData($tInfo, "aText", _Get_langstr(519))
			Case $id21 ;comment out
				DllStructSetData($tInfo, "aText", _Get_langstr(328))
			Case $id23 ;window info tool
				DllStructSetData($tInfo, "aText", _Get_langstr(609))
			Case $id24 ;macro 1
				DllStructSetData($tInfo, "aText", _Macroslot_get_name(1))
			Case $id25 ;macro 2
				DllStructSetData($tInfo, "aText", _Macroslot_get_name(2))
			Case $id26 ;macro 3
				DllStructSetData($tInfo, "aText", _Macroslot_get_name(3))
			Case $id27 ;macro 4
				DllStructSetData($tInfo, "aText", _Macroslot_get_name(4))
			Case $id28 ;macro 5
				DllStructSetData($tInfo, "aText", _Macroslot_get_name(5))
			Case $Toolbar_makroslot6 ;macro 6
				DllStructSetData($tInfo, "aText", _Macroslot_get_name(6))
			Case $Toolbar_makroslot7 ;macro 7
				DllStructSetData($tInfo, "aText", _Macroslot_get_name(7))
			Case $id29 ;save all tabs
				DllStructSetData($tInfo, "aText", _Get_langstr(649))
			Case $Toolbarmenu_aenderungsprotokoll
				DllStructSetData($tInfo, "aText", _Get_langstr(911))
			Case $Toolbarmenu_programmeinstellungen
				DllStructSetData($tInfo, "aText", _Get_langstr(42))
			Case $Toolbarmenu_projekteinstellungen
				DllStructSetData($tInfo, "aText", _Get_langstr(1078))
			Case $Toolbarmenu_Farbtoolbox
				DllStructSetData($tInfo, "aText", _Get_langstr(651))
			Case $Toolbarmenu_closeproject
				DllStructSetData($tInfo, "aText", _Get_langstr(41))
			Case $Toolbarmenu_pluginslot1
				DllStructSetData($tInfo, "aText", _AdvancedISNPlugin_get_name(1))
			Case $Toolbarmenu_pluginslot2
				DllStructSetData($tInfo, "aText", _AdvancedISNPlugin_get_name(2))
			Case $Toolbarmenu_pluginslot3
				DllStructSetData($tInfo, "aText", _AdvancedISNPlugin_get_name(3))
			Case $Toolbarmenu_pluginslot4
				DllStructSetData($tInfo, "aText", _AdvancedISNPlugin_get_name(4))
			Case $Toolbarmenu_pluginslot5
				DllStructSetData($tInfo, "aText", _AdvancedISNPlugin_get_name(5))
			Case $Toolbarmenu_pluginslot6
				DllStructSetData($tInfo, "aText", _AdvancedISNPlugin_get_name(6))
			Case $Toolbarmenu_pluginslot7
				DllStructSetData($tInfo, "aText", _AdvancedISNPlugin_get_name(7))
		EndSwitch
	EndIf

	;Tooltips für Toolbar MIT SKIN!
	If $hwndFrom = $hToolbar Then
		If $iCode = $NM_LDOWN And $Skin_is_used = "true" Then ToolTip("") ;Tooltip löschen
		If $iCode = $TBN_HOTITEMCHANGE And $Skin_is_used = "true" Then
			$tNMTBHOTITEM = DllStructCreate($tagNMTBHOTITEM, $ilParam)
			$iOld = DllStructGetData($tNMTBHOTITEM, "idOld")
			$iNew = DllStructGetData($tNMTBHOTITEM, "idNew")
			$g_iItem = $iNew
			$iFlags = DllStructGetData($tNMTBHOTITEM, "dwFlags")
			If BitAND($iFlags, $HICF_LEAVING) = $HICF_LEAVING Then
				ToolTip("") ;Tooltip löschen
			Else
				$winpos = WinGetPos($Studiofenster)
				If Not IsArray($winpos) Then Return
				$winpos_clientsize = WinGetClientSize($Studiofenster)
				If Not IsArray($winpos_clientsize) Then Return
				$aRect = _GUICtrlToolbar_GetButtonRect($hToolbar, $iNew)
				If Not IsArray($aRect) Then Return

				;Deaktivierte Buttons ignorieren
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $iNew), $TBSTATE_ENABLED) Then
					ToolTip("")
					Return
				EndIf

				Switch $iNew

					Case $id1 ;new file
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(43), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id2 ;new folder
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(46), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id3 ;import
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(44), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id4 ;export
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(49), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id5 ;löschen
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(45), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id6 ;projecttree
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(53), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id7 ;testproject
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(50), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id8 ;Projekt kompilieren
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(52), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id9 ;Projekt Eigenschaften
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(51), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id10 ;speichern
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(54), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id11 ;undo
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(55), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id12 ;redo
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(56), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id13 ;closetab
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(80), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id14 ;testscript
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(82), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id15 ;stopscript
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(106), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id16 ;search
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(85), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id17 ;syntaxcheck
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(108), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id18 ;tidy
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(327), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id19 ;import folder
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(455), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id20 ;fullscreenmode
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(457), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id22 ;macros
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(519), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id21 ;comment out
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(328), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id23 ;window info tool
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(609), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id24 ;macro 1
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Macroslot_get_name(1), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id25 ;macro 2
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Macroslot_get_name(2), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id26 ;macro 3
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Macroslot_get_name(3), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id27 ;macro 4
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Macroslot_get_name(4), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id28 ;macro 5
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Macroslot_get_name(5), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbar_makroslot6 ;macro 6
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Macroslot_get_name(6), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbar_makroslot7 ;macro 7
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Macroslot_get_name(7), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id29 ;save all tabs
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(649), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_aenderungsprotokoll
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(911), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_programmeinstellungen
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(42), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_projekteinstellungen
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(1078), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_Farbtoolbox
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(651), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_closeproject
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(41), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_pluginslot1
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_AdvancedISNPlugin_get_name(1), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_pluginslot2
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_AdvancedISNPlugin_get_name(2), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_pluginslot3
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_AdvancedISNPlugin_get_name(3), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_pluginslot4
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_AdvancedISNPlugin_get_name(4), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_pluginslot5
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_AdvancedISNPlugin_get_name(5), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_pluginslot6
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_AdvancedISNPlugin_get_name(6), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_pluginslot7
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_AdvancedISNPlugin_get_name(7), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

				EndSwitch

			EndIf

		EndIf
	EndIf






	;########################### NOTIF´s für den Dateiexplorer (TVExplorer UDF) ###########################
;~	Local $tNMTREEVIEW = DllStructCreate($tagNMTREEVIEW, $ilParam)


	If @AutoItX64 Then
		Local $tNMTREEVIEW = DllStructCreate($tagNMHDR & ';uint Aligment1;uint Action;uint Aligment2;uint OldMask;ptr OldhItem;uint OldState;uint OldStateMask;ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;lparam OldParam;uint Aligment3;uint NewMask;ptr NewhItem;uint NewState;uint NewStateMask;ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;lparam NewParam;int X; int Y', $ilParam)
	Else
		Local $tNMTREEVIEW = DllStructCreate($tagNMHDR & ';uint Action;uint OldMask;ptr OldhItem;uint OldState;uint OldStateMask;ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;lparam OldParam;uint NewMask;ptr NewhItem;uint NewState;uint NewStateMask;ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;lparam NewParam;int X; int Y', $ilParam)
	EndIf
	Local $hTV = DllStructGetData($tNMTREEVIEW, 'hWndFrom')
	Local $Index = _TV_Index($hTV)

	If (Not $Index) Or ($tvData[$Index][27]) Then
		Return 'GUI_RUNDEFMSG'
	EndIf

	Local $hItem = DllStructGetData($tNMTREEVIEW, 'NewhItem')
	Local $hPrev = DllStructGetData($tNMTREEVIEW, 'OldhItem')
	Local $state = DllStructGetData($tNMTREEVIEW, 'NewState')
	Local $ID = DllStructGetData($tNMTREEVIEW, 'Code')
	Local $Mode = _WinAPI_SetErrorMode(BitOR($SEM_FAILCRITICALERRORS, $SEM_NOOPENFILEERRORBOX))
	Local $tPOINT, $flag, $path
	Local $tTVHTI

	Do
		Switch $ID

			Case $TVN_ITEMEXPANDINGW
				If $tvData[$Index][28] Then
					ExitLoop
				EndIf
				If Not _GUICtrlTreeView_ExpandedOnce($hTV, $hItem) Then
;~					_GUICtrlTreeView_SetState($hTV, $hItem, $TVIS_EXPANDEDONCE, 1)
					_TV_Send(3, $Index, $hItem)
				EndIf
			Case $TVN_ITEMEXPANDEDW
				$path = _TV_GetPath($Index, $hItem)
				If BitAND($TVIS_EXPANDED, $state) Then
					$flag = 1
				Else
					$flag = 0
				EndIf
				If FileExists($path) Then
					_TV_SetImage($hTV, $hItem, _TV_AddIcon($Index, $path, $flag))
				Else
					_TV_Send(4, $Index, $hItem)
				EndIf
			Case $TVN_SELCHANGEDW
				If BitAND($TVIS_SELECTED, $state) Then
					_TV_Send(4, $Index, $hItem)
				EndIf
			Case $TVN_DELETEITEMW
				_TV_DeleteShortcut($Index, $hPrev)
			Case -5 ; NM_RCLICK
				If $tvData[$Index][28] Then
					ExitLoop
				EndIf
				$tPOINT = _WinAPI_GetMousePos(1, $hTV)
				$tTVHTI = _GUICtrlTreeView_HitTestEx($hTV, DllStructGetData($tPOINT, 1), DllStructGetData($tPOINT, 2))
				$hItem = DllStructGetData($tTVHTI, 'Item')
				If BitAND(DllStructGetData($tTVHTI, 'Flags'), $TVHT_ONITEM) Then
					_GUICtrlTreeView_SelectItem($hTV, $hItem)
					$path = _TV_GetPath($Index, $hItem)
					If FileExists($path) Then
						_TV_SetSelected($Index, $hItem)
						_TV_Send(7, $Index, $hItem)
					Else
						_TV_Send(4, $Index, $hItem)
					EndIf
				EndIf
			Case -3 ; NM_DBLCLK
				If $tvData[$Index][28] Then
					ExitLoop
				EndIf
				$tPOINT = _WinAPI_GetMousePos(1, $hTV)
				$tTVHTI = _GUICtrlTreeView_HitTestEx($hTV, DllStructGetData($tPOINT, 1), DllStructGetData($tPOINT, 2))
				$hItem = DllStructGetData($tTVHTI, 'Item')
				If BitAND(DllStructGetData($tTVHTI, 'Flags'), $TVHT_ONITEM) Then
					$path = _TV_GetPath($Index, $hItem)
					If Not _WinAPI_PathIsDirectory($path) Then
						_TV_Send(6, $Index, $hItem)
					EndIf
				EndIf
			Case $TVN_BEGINDRAGA, $TVN_BEGINDRAGW ;Beginne Drag&Drop Aktion
				Local $zielpfad = ""
				Local $Quelldatei = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
				$hItemHover = TreeItemFromPoint($hTV)

				;On click Drag fix
				If $Quelldatei <> _TV_GetPath($Index, $hItemHover) Then
					MouseUp("primary")
					Return
				EndIf

				Local $copy_mode = 0
				While _IsPressed("01", $user32)
					Sleep(50)
					$MausPosition = MouseGetPos()
					$hItemHover = TreeItemFromPoint($hTV)
					$zielpfad = _TV_GetPath($Index, $hItemHover)

					;Kopie erstellen wenn STRG gedrückt gehalten wird
					If _IsPressed("11", $user32) Then
						$copy_mode = 1
					Else
						$copy_mode = 0
					EndIf
					If IsArray($MausPosition) Then
						If _Pruefe_Ob_Drag_and_Drop_erlaubt_ist($Quelldatei, $zielpfad, $copy_mode) = 1 Then

							GUISetCursor(2, 1, $Studiofenster)
							If $copy_mode = 0 Then
								ToolTip(_Get_langstr(152) & " " & StringReplace($zielpfad, $Offenes_Projekt & "\", ""), $MausPosition[0] + 10, $MausPosition[1], StringTrimLeft($Quelldatei, StringInStr($Quelldatei, "\", 0, -1)))
							Else
								ToolTip(_Get_langstr(371) & " " & StringReplace($zielpfad, $Offenes_Projekt & "\", ""), $MausPosition[0] + 10, $MausPosition[1], StringTrimLeft($Quelldatei, StringInStr($Quelldatei, "\", 0, -1)))
							EndIf
						Else
							GUISetCursor(7, 1, $Studiofenster)
							ToolTip("")
						EndIf
					EndIf

					If $hItemHover = 1 Then
						;nix
					Else
						_SendMessage($hTV, $TVM_SELECTITEM, $TVGN_DROPHILITE, $hItemHover) ;add DropTarget
					EndIf
				WEnd

				_SendMessage($hTV, $TVM_SELECTITEM, $TVGN_DROPHILITE, 0) ;remove DropTarget
				ToolTip("")
				GUISetCursor(2, 0, $Studiofenster)
				_Try_to_move_file_drag_and_Drop($Quelldatei, $zielpfad, $copy_mode)

		EndSwitch
	Until 1
	_WinAPI_SetErrorMode($Mode)



;~ 	If @AutoItX64 Then
;~ 		Local $tNMTREEVIEW = DllStructCreate($tagNMHDR & ';uint Aligment1;uint Action;uint Aligment2;uint OldMask;ptr OldhItem;uint OldState;uint OldStateMask;ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;lparam OldParam;uint Aligment3;uint NewMask;ptr NewhItem;uint NewState;uint NewStateMask;ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;lparam NewParam;int X; int Y', $ilParam)
;~ 	Else
;~ 		Local $tNMTREEVIEW = DllStructCreate($tagNMHDR & ';uint Action;uint OldMask;ptr OldhItem;uint OldState;uint OldStateMask;ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;lparam OldParam;uint NewMask;ptr NewhItem;uint NewState;uint NewStateMask;ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;lparam NewParam;int X; int Y', $ilParam)
;~ 	EndIf
;~ 	Local $hTV = DllStructGetData($tNMTREEVIEW, 'hWndFrom')
;~ 	Local $Index = _TV_Index($hTV)

;~ 	If (Not $Index) Or ($tvData[$Index][27]) Then
;~ 		Return 'GUI_RUNDEFMSG'
;~ 	EndIf

;~ 	Local $hItem = DllStructGetData($tNMTREEVIEW, 'NewhItem')
;~ 	Local $hPrev = DllStructGetData($tNMTREEVIEW, 'OldhItem')
;~ 	Local $state = DllStructGetData($tNMTREEVIEW, 'NewState')
;~ 	Local $id = DllStructGetData($tNMTREEVIEW, 'Code')
;~ 	Local $Mode = _WinAPI_SetErrorMode(BitOR($SEM_FAILCRITICALERRORS, $SEM_NOOPENFILEERRORBOX))
;~ 	Local $tPOINT, $flag, $path
;~ 	Local $tTVHTI

;~ 	Do
;~ 		Switch $id
;~ 			Case $TVN_BEGINDRAGA, $TVN_BEGINDRAGW ;Beginne Drag&Drop Aktion

;~ 				$Quelldatei = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
;~ 				$hItemHover = TreeItemFromPoint($hTV)

;~ 				;On click Drag fix
;~ 				If $Quelldatei <> _TV_GetPath($Index, $hItemHover) Then
;~ 					MouseUp("primary")
;~ 					Return
;~ 				EndIf

;~ 				Local $copy_mode = 0
;~ 				While _IsPressed("01", $user32)
;~ 					Sleep(50)
;~ 					$MausPosition = MouseGetPos()
;~ 					$hItemHover = TreeItemFromPoint($hTV)
;~ 					$zielpfad = _TV_GetPath($Index, $hItemHover)

;~ 					;Kopie erstellen wenn STRG gedrückt gehalten wird
;~ 					If _IsPressed("11", $user32) Then
;~ 						$copy_mode = 1
;~ 					Else
;~ 						$copy_mode = 0
;~ 					EndIf
;~ 					If IsArray($MausPosition) Then
;~ 						If _Pruefe_Ob_Drag_and_Drop_erlaubt_ist($Quelldatei, $zielpfad, $copy_mode) = 1 Then

;~ 							GUISetCursor(2, 1, $Studiofenster)
;~ 							If $copy_mode = 0 Then
;~ 								ToolTip(_Get_langstr(152) & " " & StringReplace($zielpfad, $Offenes_Projekt & "\", ""), $MausPosition[0] + 10, $MausPosition[1], StringTrimLeft($Quelldatei, StringInStr($Quelldatei, "\", 0, -1)))
;~ 							Else
;~ 								ToolTip(_Get_langstr(371) & " " & StringReplace($zielpfad, $Offenes_Projekt & "\", ""), $MausPosition[0] + 10, $MausPosition[1], StringTrimLeft($Quelldatei, StringInStr($Quelldatei, "\", 0, -1)))
;~ 							EndIf
;~ 						Else
;~ 							GUISetCursor(7, 1, $Studiofenster)
;~ 							ToolTip("")
;~ 						EndIf
;~ 					EndIf

;~ 					If $hItemHover = 1 Then
;~ 						;nix
;~ 					Else
;~ 						_SendMessage($hTV, $TVM_SELECTITEM, $TVGN_DROPHILITE, $hItemHover) ;add DropTarget
;~ 					EndIf
;~ 				WEnd

;~ 				_SendMessage($hTV, $TVM_SELECTITEM, $TVGN_DROPHILITE, 0) ;remove DropTarget
;~ 				ToolTip("")
;~ 				GUISetCursor(2, 0, $Studiofenster)
;~ 				_Try_to_move_file_drag_and_Drop($Quelldatei, $zielpfad, $copy_mode)

;~ 			Case $TVN_ITEMEXPANDINGW
;~ 				If $tvData[$Index][28] Then
;~ 					ExitLoop
;~ 				EndIf
;~ 				If Not _GUICtrlTreeView_ExpandedOnce($hTV, $hItem) Then
	;_GUICtrlTreeView_SetState($hTV, $hItem, $TVIS_EXPANDEDONCE, 1)
;~ 					_TV_Send(3, $Index, $hItem)
;~ 				EndIf
;~ 			Case $TVN_ITEMEXPANDEDW
;~ 				$path = _TV_GetPath($Index, $hItem)
;~ 				If BitAND($TVIS_EXPANDED, $state) Then
;~ 					$flag = 1
;~ 				Else
;~ 					$flag = 0
;~ 				EndIf
;~ 				If FileExists($path) Then
;~ 					_TV_SetImage($hTV, $hItem, _TV_AddIcon($Index, $path, $flag))
;~ 				Else
;~ 					_TV_Send(4, $Index, $hItem)
;~ 				EndIf
;~ 			Case $TVN_SELCHANGEDW
;~ 				If BitAND($TVIS_SELECTED, $state) Then
;~ 					_TV_Send(4, $Index, $hItem)
;~ 				EndIf
;~ 			Case $TVN_DELETEITEMW
;~ 				_TV_DeleteShortcut($Index, $hPrev)
;~ 			Case -5 ; NM_RCLICK
;~ 				If $tvData[$Index][28] Then
;~ 					ExitLoop
;~ 				EndIf
;~ 				$tPOINT = _WinAPI_GetMousePos(1, $hTV)
;~ 				$tTVHTI = _GUICtrlTreeView_HitTestEx($hTV, DllStructGetData($tPOINT, 1), DllStructGetData($tPOINT, 2))
;~ 				$hItem = DllStructGetData($tTVHTI, 'Item')
;~ 				If BitAND(DllStructGetData($tTVHTI, 'Flags'), $TVHT_ONITEM) Then
;~ 					_GUICtrlTreeView_SelectItem($hTV, $hItem)
;~ 					$path = _TV_GetPath($Index, $hItem)
;~ 					If FileExists($path) Then
;~ 						_TV_SetSelected($Index, $hItem)
;~ 						_TV_Send(7, $Index, $hItem)
;~ 					Else
;~ 						_TV_Send(4, $Index, $hItem)
;~ 					EndIf
;~ 				EndIf
;~ 			Case -3 ; NM_DBLCLK
;~ 				If $tvData[$Index][28] Then
;~ 					ExitLoop
;~ 				EndIf
;~ 				$tPOINT = _WinAPI_GetMousePos(1, $hTV)
;~ 				$tTVHTI = _GUICtrlTreeView_HitTestEx($hTV, DllStructGetData($tPOINT, 1), DllStructGetData($tPOINT, 2))
;~ 				$hItem = DllStructGetData($tTVHTI, 'Item')
;~ 				If BitAND(DllStructGetData($tTVHTI, 'Flags'), $TVHT_ONITEM) Then
;~ 					$path = _TV_GetPath($Index, $hItem)
;~ 					If Not _WinAPI_PathIsDirectory($path) Then
;~ 						_TV_Send(6, $Index, $hItem)
;~ 					EndIf
;~ 				EndIf
;~ 		EndSwitch
;~ 	Until 1
;~ 	_WinAPI_SetErrorMode($Mode)


	;########################### NOTIF´s für Checkboxen in einem Treeview (TristateTreeViewLib UDF) ###########################
	_WM_NOTIFY_Treeview($hWnd, $iMsg, $iwParam, $ilParam, $hWndFrom2) ;Versuche zuerst NOTIFY´s für das Scintilla Control

;~ 	Return
;~

	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_NOTIFY

Func _WM_NOTIFY_EDITOR($hWnd, $iMsg, $iwParam, $ilParam)
	If $Can_open_new_tab = 0 Then Return

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	$nID = BitAND($iwParam, 0x0000FFFF)

	;Extraswitch für Listview Events (Parameter Editor)
	Switch $iCode
		Case $NM_CLICK
			If $nID = $ParameterEditor_ListView Then _Parameter_Editor_Listview_select_row()


	EndSwitch


	;-----------------------------------SCRIPTEDITOR
	Local $tagNMHDR, $event
	Local $structNMHDR = DllStructCreate("hwnd hWndFrom;int IDFrom;int Code", $ilParam) ; tagNMHDR
	Local $sClassName = DllCall("User32.dll", "int", "GetClassName", "hwnd", DllStructGetData($structNMHDR, 1), "str", "", "int", 512)

	$sClassName = $sClassName[2]

	If $sClassName <> "Scintilla" Then Return 'GUI_RUNDEFMSG'
	$structNMHDR = DllStructCreate($tagSCNotification, $ilParam)
	If @error Then Return 'GUI_RUNDEFMSG'


	Global $SCI_Zeile
	Local $hwndFrom = DllStructGetData($structNMHDR, 1)
	Local $Sci = $hwndFrom
	If Not IsHWnd($Sci) Then $Sci = HWnd($Sci)
	Local $IdFrom = DllStructGetData($structNMHDR, 2)
	Local $event = DllStructGetData($structNMHDR, 3)
	Local $position = DllStructGetData($structNMHDR, 4)
	Local $ch = DllStructGetData($structNMHDR, 5)
	Local $modificationType = DllStructGetData($structNMHDR, 7)
	Local $updated = DllStructGetData($structNMHDR, 23)
	Local $Char = DllStructGetData($structNMHDR, 8)
	Local $Length = DllStructGetData($structNMHDR, 9)
	Local $selections = SendMessage($Sci, $SCI_GETSELECTIONS, 0, 0)

	If $Sci = $ParameterEditor_Vorschau_Fertiger_Befehl_SCE Or $Sci = $QuickView_Notes_Scintilla Then Return


;~ 	#cs
;~
;~Local $modifiers = DllStructGetData($structNMHDR, 6)
;~ 		Local $char = DllStructGetData($structNMHDR, 8)
;~ 		Local $length = DllStructGetData($structNMHDR, 9)
;~ 		Local $linesAdded = DllStructGetData($structNMHDR, 10)

;~ 		Local $message = DllStructGetData($structNMHDR, 11)
;~ 		Local $uptr_t = DllStructGetData($structNMHDR, 12)
;~ 		Local $sptr_t = DllStructGetData($structNMHDR, 13)
;~ 		Local $Line = DllStructGetData($structNMHDR, 14)

;~ 		Local $foldLevelNow = DllStructGetData($structNMHDR, 15)
;~ 		Local $foldLevelPrev = DllStructGetData($structNMHDR, 16)
;~ 		Local $margin = DllStructGetData($structNMHDR, 17)
;~ 		Local $listType = DllStructGetData($structNMHDR, 18)

;~ 		Local $X = DllStructGetData($structNMHDR, 19)
;~ 		Local $Y = DllStructGetData($structNMHDR, 20)
;~ 	#ce



;~ 	ConsoleWrite("lll" & _WinAPI_GetClassName($Sci) & @CRLF)
	Local $line_number = SendMessage($Sci, $SCI_LINEFROMPOSITION, $position, 0)


	;Wenn mehr als eine Zeile Markiert ist -> überstringe diese Funktion
;~ 	if SendMessage($Sci, $SCI_LINEFROMPOSITION, SendMessage($Sci, $SCI_GETSELECTIONSTART, 0, 0), 0) <> SendMessage($Sci, $SCI_LINEFROMPOSITION, SendMessage($Sci, $SCI_GETSELECTIONEND, 0, 0), 0) Then
;~ 	  Return 'GUI_RUNDEFMSG'
;~     endif



	;Nicht beim Debug Editor
	$line = Sci_GetLineFromPos($Sci, Sci_GetCurrentPos($Sci))
	;Current pos to statusbar
	If $Sci <> $Debug_log And $selections = 1 Then _GUICtrlStatusBar_SetText_ISN($Status_bar, "li=" & $line + 1 & " co=" & (Sci_GetCurrentPos($Sci) - Sci_GetLineStartPos($Sci, $line)) + 1)


	;falls sich aktuelle zeile ändert -> weg mit dem colourpicker
	If Sci_GetLineFromPos($Sci, Sci_GetCurrentPos($Sci)) <> $SCIE_letzte_zeile Then
		$farb_picker_GUIstate = WinGetState($mini_farb_picker_GUI, "")
		If BitAND($farb_picker_GUIstate, 2) Then _Colour_Calltipp_Set_State("hide", $Sci)
	EndIf
	$SCIE_letzte_zeile = Sci_GetLineFromPos($Sci, Sci_GetCurrentPos($Sci))


	;Select
	;Case $hwndFrom = $Sci
	;If IsHWnd($Sci) Then
	Local $Word, $WordPos, $CurrentLine, $PreviousLine, $Tabs, $TabsAdd, $style, $CurrentPos, $pos, $Replace, $AllVariables, $AllVariablesSplit, $AllWords, $err, $Variable
	Switch $event

		Case $SCN_CALLTIPCLICK


			If SendMessage($Sci, $SCI_CALLTIPACTIVE, 0, 0) Then
				Switch $position

					Case 1
						If IsArray($SCI_sCallTipFoundIndices) And $SCI_sCallTipSelectedIndice > 0 Then
							$SCI_sCallTipSelectedIndice -= 1
							$SCI_sCallTip = Chr(1) & $SCI_sCallTipSelectedIndice + 1 & "/" & UBound($SCI_sCallTipFoundIndices) & Chr(2) & $SCI_sCallTip_Array[$SCI_sCallTipFoundIndices[$SCI_sCallTipSelectedIndice]]
							$SCI_sCallTip = StringRegExpReplace(StringReplace($SCI_sCallTip, ")", ")" & @LF, 1), "([.:])", "$1" & @LF)
							SendMessageString($Sci, $SCI_CALLTIPSHOW, $SCI_sCallTipPos, $SCI_sCallTip)
						EndIf

					Case 2
						If IsArray($SCI_sCallTipFoundIndices) And $SCI_sCallTipSelectedIndice < UBound($SCI_sCallTipFoundIndices) - 1 Then
							$SCI_sCallTipSelectedIndice += 1
							$SCI_sCallTip = Chr(1) & $SCI_sCallTipSelectedIndice + 1 & "/" & UBound($SCI_sCallTipFoundIndices) & Chr(2) & $SCI_sCallTip_Array[$SCI_sCallTipFoundIndices[$SCI_sCallTipSelectedIndice]]
							$SCI_sCallTip = StringRegExpReplace(StringReplace($SCI_sCallTip, ")", ")" & @LF, 1), "([.:])", "$1" & @LF)
							SendMessageString($Sci, $SCI_CALLTIPSHOW, $SCI_sCallTipPos, $SCI_sCallTip)
						EndIf
				EndSwitch
			EndIf

		Case $SCN_DOUBLECLICK
			If $Sci = $Debug_log Then
				_trytofinderror()
				Return
			EndIf
			$Selection = Sci_GetSelection($Sci)
			If IsArray($Selection) Then
				If Sci_GetChar($Sci, $Selection[0] - 1) = "$" Or Sci_GetChar($Sci, $Selection[0] - 1) = "@" Or Sci_GetChar($Sci, $Selection[0] - 1) = "#" Then
					Sci_SetSelection($Sci, $Selection[0] - 1, $Selection[1])
				EndIf
			EndIf

			If $SkriptEditor_Doppelklick_ParameterEditor = "true" And $Tools_Parameter_Editor_aktiviert = "true" Then
				$Aktuelles_Wort_Doppelclick = StringStripWS(SCI_GetTextRange($Sci, $Selection[0], $Selection[1]), 3)
				$Aktuelles_Wort_Doppelclick = StringReplace($Aktuelles_Wort_Doppelclick, "(", "")
				$Aktuelles_Wort_Doppelclick = StringReplace($Aktuelles_Wort_Doppelclick, ")", "")
				_Pruefe_Doppelklickwort_im_Skripteditor($Aktuelles_Wort_Doppelclick, $Selection[1])
			EndIf




		Case $SCN_CHARADDED


			If SendMessage($Sci, $SCI_GETREADONLY, 0, 0) Then
				$ParameterEditor_GUI_State = WinGetState($ParameterEditor_GUI, "")
				If BitAND($ParameterEditor_GUI_State, 2) And $Sci <> $ParameterEditor_SCIEditor Then
					$aktuelle_pos_SCE_Window = WinGetPos($Sci)
					$aktuelle_pos = Sci_GetCurrentPos($Sci)
					$x = SendMessage($Sci, $SCI_POINTXFROMPOSITION, 0, $aktuelle_pos) + $aktuelle_pos_SCE_Window[0]
					$y = SendMessage($Sci, $SCI_POINTYFROMPOSITION, 0, $aktuelle_pos) + $aktuelle_pos_SCE_Window[1] + 10
					_ISNTooltip_with_Timer(StringReplace(_Get_langstr(1296), "%1", WinGetTitle($ParameterEditor_GUI)), $x, $y, _Get_langstr(25), 3, 1)
				EndIf
				Return
			EndIf

			If $selections > 1 Then Return ;Stop here at multi coursor

			;Stuff for AutoFormat Correction (thx to jacobslusser)
			$caretPos = Sci_GetCurrentPos($Sci)
			$docStart = $caretPos == 1
			$docEnd = $caretPos == Sci_GetLenght($Sci)
			$charPrev = $docStart ? Sci_GetChar($Sci, $caretPos) : Sci_GetChar($Sci, $caretPos - 2)
			$charNext = Sci_GetChar($Sci, $caretPos)
			$isCharPrevBlank = $charPrev == ' ' Or $charPrev == @tab Or $charPrev == @crlf Or $charPrev == @cr
			$isCharNextBlank = $charNext == ' ' Or $charNext == @tab Or $charNext == @crlf Or $charNext == @cr Or $docEnd
			$isEnclosed = ($charPrev == '(' And $charNext == ')') Or ($charPrev == '{' And $charNext == '}') Or ($charPrev == '[' And $charNext == ']')
			$isEnclosed2 = ($charPrev == '"' And $charNext == '"') Or ($charPrev == "'" And $charNext == "'")
			$isSpaceEnclosed = ($charPrev == '(' And $isCharNextBlank) Or ($isCharPrevBlank And $charNext == ')') Or ($charPrev == '{' And $isCharNextBlank) Or ($isCharPrevBlank And $charNext == '}') Or ($charPrev == '[' And $isCharNextBlank) Or ($isCharPrevBlank And $charNext == ']')
			$charNextIsCharOrString = $charNext == '"' Or $charNext == "'"
			$isCharOrString = ($isCharPrevBlank And $isCharNextBlank) Or $isEnclosed Or $isSpaceEnclosed
			$isCharOrString2 = ($isCharPrevBlank) Or $isEnclosed Or $isSpaceEnclosed
			$QuoteAllowed = ($charPrev == '(' OR $charNext == ')') OR ($charPrev == ',' OR $charNext == ',') OR $isCharNextBlank


			If SendMessage($Sci, $SCI_GETLEXER, 0, 0) = $SCLEX_AU3 Then
				Switch Chr($ch)


					Case "("
						If $ScriptEditor_Autocomplete_Brackets = "true" And $Scintilla_LastInsertedChar = Chr($ch) Then Sci_InsertText($Sci, Sci_GetCurrentPos($Sci), ")")
						If _Is_Comment($Sci) Then Return
						_Scintilla_CallTip_ShowHide_Check($Sci)


					Case ","
						Sleep(10) ;Style bugfix..without this $SCI_GETSTYLEAT returns 0 ?!?!?
						If SendMessage($Sci, $SCI_GETSTYLEAT, Sci_GetCurrentPos($Sci) - 1, 0) = $SCE_AU3_OPERATOR And $ScriptEditor_UseAutoFormat_Correction = "true" Then
							Sci_AddText($Sci, ' ')
						EndIf
						If _Is_Comment($Sci) Then Return
						_Scintilla_CallTip_ShowHide_Check($Sci)

					Case "&", "=", "+", "/", "*", ">", "?", ":"
						Sleep(10) ;Style bugfix..without this $SCI_GETSTYLEAT returns 0 ?!?!?
						If SendMessage($Sci, $SCI_GETSTYLEAT, Sci_GetCurrentPos($Sci) - 1, 0) = $SCE_AU3_OPERATOR And $ScriptEditor_UseAutoFormat_Correction = "true" Then
							Sci_AddText($Sci, ' ')
						EndIf

					Case ")"
						_Colour_Calltipp_Set_State("hide", $Sci)
						If SendMessage($Sci, $SCI_CALLTIPACTIVE, 0, 0) Then SendMessage($Sci, $SCI_CALLTIPCANCEL, 0, 0)
						_Scintilla_check_Brace_highlighting($Sci,-1)


					Case "'"
						If _Is_Comment($Sci) Then Return
						If ($isCharOrString2) And $ScriptEditor_Autocomplete_Brackets = "true" And $Scintilla_LastInsertedChar = Chr($ch) AND $QuoteAllowed Then Sci_InsertText($Sci, Sci_GetCurrentPos($Sci), "'")

					Case "{"
						If _Is_Comment($Sci) Then Return
						If ($isEnclosed2) And $ScriptEditor_Autocomplete_Brackets = "true" And $Scintilla_LastInsertedChar = Chr($ch) Then Sci_InsertText($Sci, Sci_GetCurrentPos($Sci), "}")


					Case @LF
						_Colour_Calltipp_Set_State("hide", $Sci)
						If $Sci = $ParameterEditor_SCIEditor Then
							$Old = Sci_GetText($ParameterEditor_SCIEditor)
;~ 						if $autoit_editor_encoding = "2" then $Old = _ANSI2UNICODE($Old)
							$Old = StringReplace($Old, @CRLF, "")
							$Old = StringReplace($Old, @LF, "")
							$Old = StringReplace($Old, @CR, "")
							Sci_SetText($ParameterEditor_SCIEditor, $Old)
;~ 						If _IsPressed("11", $user32) Then
;~ 							_Parameter_Editor_Parameter_hinzufuegen()
;~ 						EndIf
							Return
						EndIf


					Case @CR
						If $AutoEnd_Keywords = "true" And $Sci <> $ParameterEditor_SCIEditor Then
							_Autocomplete_nach_Enter($Sci)
						EndIf
						_Colour_Calltipp_Set_State("hide", $Sci)


					Case "<", '"'
						If _Is_Comment($Sci) Then Return
						Sleep(10) ;Style bugfix..without this $SCI_GETSTYLEAT returns 0 ?!?!?
						If Chr($ch) = "<" Then
							If SendMessage($Sci, $SCI_GETSTYLEAT, Sci_GetCurrentPos($Sci) - 1, 0) = $SCE_AU3_OPERATOR And $ScriptEditor_UseAutoFormat_Correction = "true" And $Scintilla_LastInsertedChar = Chr($ch) Then
								Sci_AddText($Sci, ' ')
							EndIf
						EndIf


						If ($isCharOrString2) And $ScriptEditor_Autocomplete_Brackets = "true" And Chr($ch) = '"' AND $QuoteAllowed Then Sci_InsertText($Sci, Sci_GetCurrentPos($Sci), '"')
						If ($isCharOrString2) And $ScriptEditor_Autocomplete_Brackets = "true" And Chr($ch) = '<' And SendMessage($Sci, $SCI_GETSTYLEAT, Sci_GetCurrentPos($Sci) - 1, 0) = $SCE_AU3_STRING Then Sci_InsertText($Sci, Sci_GetCurrentPos($Sci), '>')


						;Autocomplete for includes
						If $disableautocomplete = "true" Then Return
						$style = SendMessage($Sci, $SCI_GETSTYLEAT, SCI_GetCurrentPos($Sci), 0)
						If Not SendMessage($Sci, $SCI_AUTOCACTIVE, 0, 0) And _
								$style <> $SCE_AU3_COMMENT And $style <> $SCE_AU3_COMMENTBLOCK _
								And $style <> $SCE_AU3_SENT Then
							_Scintilla_CallTip_ShowHide_Check($Sci)
						EndIf



					Case " "

						If SendMessage($Sci, $SCI_AUTOCACTIVE, 0, 0) And $allow_autocomplete_with_spacekey = "true" Then
							SendMessage($Sci, $SCI_AUTOCCOMPLETE, 0, 0) ;Allow autocomplete with tab key
						EndIf

						$CurrentPos = SCI_GetCurrentPos($Sci)

						If $Auto_dollar_for_declarations = "true" And Not _Is_Comment($Sci) Then
							$Letztes_Wort = SCI_GetWordFromPos($Sci, SCI_GetCurrentPos($Sci) - 2)

							$TabsAdd = ""
							$Tabs = StringSplit(SCI_GetLine($Sci, SCI_GetCurrentLine($Sci) - 1), @TAB)
							If IsArray($Tabs) Then
								If $Tabs[0] > 1 Then
									For $i = 1 To $Tabs[0] - 1
										If Not $Tabs[$i] = "" Then ExitLoop
										$TabsAdd &= @TAB

									Next
								EndIf
							EndIf


							If $Auto_dollar_for_declarations = "true" And Not StringInStr(SCI_GetLine($Sci, SCI_GetCurrentLine($Sci) - 1), "$") Then
								Switch $Letztes_Wort

									Case "global"
										Send("$")

									Case "local"
										Send("$")

									Case "const"
										Send("$")

								EndSwitch
							EndIf


						EndIf


						$style = SendMessage($Sci, $SCI_GETSTYLEAT, $CurrentPos - 2, 0)
						If $style = $SCE_AU3_EXPAND Then
							$WordPos = SCI_GetWordPositions($Sci, $CurrentPos - 2)
							$Replace = StringRegExp($SCI_ABBREVFILE, "(?:\n|\r|\A)" & StringLower(SCI_GETTEXTRANGE($Sci, $WordPos[0], $WordPos[1])) & "=(.*)", 1)
							If Not @error Then
								$Replace = StringFormat(StringRegExpReplace($Replace[0], "\r|\n", ""))

								SCI_SetSelection($Sci, $WordPos[0], $WordPos[1] + 1)
								$WordPos[0] += StringInStr($Replace, "|", 1, 1) - 1
								If Not StringInStr($Replace, "|", 1, 1) Then $WordPos[0] = $WordPos[1] + 1
								SendMessageString($Sci, $SCI_REPLACESEL, 0, StringReplace($Replace, "|", "", 1))
								SCI_SetCurrentPos($Sci, $WordPos[0])

								_Scintilla_CallTip_ShowHide_Check($Sci)

							EndIf
						EndIf

					Case Else

						SendMessage($sci, $SCI_BRACEHIGHLIGHT, $INVALID_POSITION, $INVALID_POSITION) ;Remove BRACEHIGHLIGHT

;~ 						#CS ; Uncomment this to add autocomplete for variables
						Sleep(10) ;Otherwise GETSTYLEAT will not work??
						$style = SendMessage($Sci, $SCI_GETSTYLEAT, SCI_GetCurrentPos($Sci)-1, 0)

						If Not SendMessage($Sci, $SCI_AUTOCACTIVE, 0, 0) And _
								$style <> $SCE_AU3_COMMENT And $style <> $SCE_AU3_COMMENTBLOCK _
								And $style <> $SCE_AU3_STRING And $style <> $SCE_AU3_SENT Then

;~ 						$Word = SCI_GetCurrentWordEx($Sci, 0, 1)
							$Word = SCI_GetWord_ISN_Special($Sci)
							While $Word And Not StringRegExp($Word, "\A([@$#_]|\w)")
								$Word = StringTrimLeft($Word, 1)
							WEnd
							While $Word And Not StringRegExp($Word, "([@$#_]|\w)\Z")
								$Word = StringTrimRight($Word, 1)
							WEnd


							If StringLeft($Word, 1) = "$" And $disableautocomplete = "false" Then

								$AllVariables = $SCI_Autocompletelist_Variables
								SendMessage($Sci, $SCI_AUTOCSETORDER, $SC_ORDER_PERFORMSORT, 0) ;Autocomplete Liste durch Scintilla sortieren (Wichtig: Verhindert den $_ Bug!)

								If $Word = "_" And $Skript_Editor_Autocomplete_UDF_ab_zweitem_Zeichen = "true" Then
									If StringLen($Word) > 1 Then SendMessageString($Sci, $SCI_AUTOCSHOW, StringLen($Word), $AllVariables)
								Else
									SendMessageString($Sci, $SCI_AUTOCSHOW, StringLen($Word), $AllVariables)
								EndIf


							ElseIf StringLen($Word) Then

								;by isi360
								$linechecker = Sci_GetLine($Sci, Sci_GetCurrentLine($Sci) - 1)
								$linechecker = StringReplace($linechecker, " ", "")
								$linechecker = StringReplace($linechecker, @TAB, "")
								If StringInStr($linechecker, "=") Then $linechecker = ""
								$linechecker = StringTrimRight($linechecker, StringLen($linechecker) - 1)
								If $disableautocomplete = "false" And $linechecker <> "$" Then
;~ 								If Not SendMessage($Sci, $SCI_AUTOCACTIVE, 0,0) Then
;~ 							ConsoleWrite($Word & @CRLF)

									If StringRegExp($Word, "\A[A-Za-z0-9_@#]+\Z") Then ;And StringInStr(@CR & $SCI_AUTOCLIST,@CR & $Word,0) Then

										Local $pos = ArraySearchAll($SCI_AUTOCLIST, $Word, 1, 0, 1)
										If $pos = -1 Then Return 'GUI_RUNDEFMSG'
;~ 									_ArraySort($SCI_AUTOCLIST,0,1)
										$AllVariables = _ArrayToString($SCI_AUTOCLIST, @CR, $pos[0], $pos[UBound($pos) - 1])

;~ 									$AllVariables = _ArrayToString($SCI_AUTOCLIST, @CR,1)
;~ 										ConsoleWrite($AllVariables & @CRLF)
										SendMessage($Sci, $SCI_AUTOCSETORDER, $SC_ORDER_PERFORMSORT, 0) ;Autocomplete Liste durch Scintilla sortieren (Wichtig: Verhindert den $_ Bug!)

										If $Word = "_" And $Skript_Editor_Autocomplete_UDF_ab_zweitem_Zeichen = "true" Then
											If StringLen($Word) > 1 Then SendMessageString($Sci, $SCI_AUTOCSHOW, StringLen($Word), $AllVariables)
										Else
											SendMessageString($Sci, $SCI_AUTOCSHOW, StringLen($Word), $AllVariables)
										EndIf

									EndIf
;~ 								EndIf

								EndIf
							EndIf
						EndIf
;~ 						#CE
						;		EndIf
				EndSwitch

				;Auto correct operators for exmaple: < > = <>
				If $ScriptEditor_UseAutoFormat_Correction = "true" And SendMessage($Sci, $SCI_GETSTYLEAT, $caretPos - 3, 0) = $SCE_AU3_OPERATOR Then
					Switch Chr($ch)

						Case "&", "=", "+", "*", "<", ">", ":"
							Switch Sci_GetChar($Sci, $caretPos - 3)

								Case "=", "+", "<", ">", "&", "/", "*", "-", "?"
									If Sci_GetChar($Sci, $caretPos - 4) = " " Then
										SendMessage($Sci, $SCI_SETTARGETRANGE, $caretPos - 2, $caretPos - 1)
										SendMessage($Sci, $SCI_REPLACETARGET, StringLen(""), "")
									EndIf

							EndSwitch
					EndSwitch
				EndIf

			EndIf

		Case $SCN_AUTOCCOMPLETED
			If SendMessage($Sci, $SCI_GETLEXER, 0, 0) = $SCLEX_AU3 Then
				$CompletedWord = SCI_GetCurrentWordEx($Sci, $position)
				Sleep(10)
				$Wordstyle = SendMessage($Sci, $SCI_GETSTYLEAT, $position, 0)
				If Sci_GetChar($Sci, $position) = " " Then $Wordstyle = SendMessage($Sci, $SCI_GETSTYLEAT, $position + 1, 0)

				If $ScriptEditor_UseAutoFormat_Correction = "true" Then

					;Autocomplete brackets..if needet [example: GUICreate(  ]
					$SCI_sCallTipFoundIndices = ArraySearchAll($SCI_sCallTip_Array, $CompletedWord, 0, 0, 1)
					If IsArray($SCI_sCallTipFoundIndices) Then
						If StringInStr($SCI_sCallTip_Array[$SCI_sCallTipFoundIndices[0]], "(") And ($Wordstyle = $SCE_AU3_FUNCTION Or $Wordstyle = $SCE_AU3_UDF) And Sci_GetChar($Sci, Sci_GetCurrentPos($Sci)) <> "(" Then Send("(")
					EndIf

					;Autocomplete a space after the keywoard
					;Auto mode
					If $Wordstyle = $SCE_AU3_KEYWORD Then
						Send(" ")
					EndIf

					;Manual mode
					Switch StringLower(StringStripWS($CompletedWord, 3))
						Case "include", "pragma", "onautoitatartregister", "region"
							Send(" ")
					EndSwitch

					;Brace highlighting (thx to jacobslusser)
					_Scintilla_check_Brace_highlighting($Sci)
				EndIf
			EndIf


		Case $SCN_UPDATEUI
			If $Sci <> $Debug_log And $Sci <> $ParameterEditor_SCIEditor And $Sci <> $scintilla_Codeausschnitt And $Sci <> $Makro_Codeausschnitt_GUI_scintilla And $Last_Used_Scintilla_Control <> $Sci And $pelock_obfuscator_GUI_Ausgabe_scintilla <> $Sci And $pelock_obfuscator_GUI_Eingabe_scintilla <> $Sci Then $Last_Used_Scintilla_Control = $Sci


			$Automatische_Speicherung_eingabecounter = 0 ;Eingabecounter resetten
			$SCI_Pos_vor_Enter = (Sci_GetCurrentPos($Sci) - Sci_GetLineStartPos($Sci, $line)) + 1
			_Zeige_Detailinfos_zu_aktuellem_Wort(SCI_GetWordFromPos($Sci, SendMessage($Sci, $Sci_GetCurrentPos, 0, 0), 1), $Sci)


			;Brace highlighting (thx to jacobslusser)
			_Scintilla_check_Brace_highlighting($Sci)

			;Für inteli Matches
			If SendMessage($Sci, $SCI_GETSELECTIONSTART, 0, 0) <> 0 And $verwende_intelimark = "true" Then
				$Selection = Sci_GetSelection($Sci)
				If IsArray($Selection) Then
					If ($Selection[1] - $Selection[0] > 3) And ($Selection[1] - $Selection[0] < 201) Then ;erst ab 3 wörtern suchen (max. 200 zeichen)
						Local $Suchwort = SCI_GetTextRange($Sci, $Selection[0], $Selection[1])
						Local $Use_SearchGUI_Filters = 0
						If StringStripWS($Suchwort, 3) = "" Then Return
						If Not _String_is_unique($Suchwort) Then Return

						If BitAND(WinGetState($fFind1, ""), 2) Then $Use_SearchGUI_Filters = 1 ;If Search GUI is visible..we use the style filters
						If StringLen($Suchwort) < StringLen($letztes_Suchwort) Then
							$letztes_Suchwort = ""
						EndIf
						If $letztes_Suchwort <> $Suchwort Then
							SendMessage($Sci, $SCI_INDICATORCLEARRANGE, 0, Sci_GetLenght($Sci))
							$letztes_Suchwort = $Suchwort
							Local $Array_Gefundene_Elemente[1]
							$pos = 0
							For $zeile = 0 To Sci_GetLineCount($Sci)
								$Search = Sci_Search($Sci, $Suchwort, $pos)
								If $Search = -1 Then ExitLoop ;Nichts mehr gefunden
								If $Search <> -1 Then
									_ArrayAdd($Array_Gefundene_Elemente, $Search)
									$pos = $Search + 1
								EndIf
							Next
							_ArrayDelete($Array_Gefundene_Elemente, 0)
							SendMessage($Sci, $SCI_INDICSETSTYLE, 0, 8) ; Markierungsstyle
							$r = _ColorGetRed($scripteditor_highlightcolour)
							$g = _ColorGetGreen($scripteditor_highlightcolour)
							$B = _ColorGetBlue($scripteditor_highlightcolour)
							$bgclr = "0x" & Hex($B, 2) & Hex($g, 2) & Hex($r, 2)
							SendMessage($Sci, $SCI_INDICSETFORE, 0, $bgclr)
							GUIRegisterMsg($WM_NOTIFY, '') ;Disable the Message to speed up the MarkerADD Stuff
							For $x = 0 To UBound($Array_Gefundene_Elemente) - 1
								$Xline = Sci_GetLineFromPos($Sci, $Array_Gefundene_Elemente[$x])
								If $Use_SearchGUI_Filters = 1 Then
									If StringInStr($SearchGUI_Styles_to_Ignore_Buffer, "," & SendMessage($Sci, $SCI_GETSTYLEAT, $Array_Gefundene_Elemente[$x], 0) & ",") Then ContinueLoop ;We do not want this element
									If $Array_Gefundene_Elemente[$x] = $Selection[0] Then SendMessage($Sci, $SCI_MARKERADD, $Xline, 7)
								EndIf

								If $Array_Gefundene_Elemente[$x] = $Selection[0] Then ContinueLoop ;Makierung selbst überspringen
								SendMessage($Sci, $SCI_INDICATORFILLRANGE, $Array_Gefundene_Elemente[$x], StringLen($Suchwort))
								;Set a marker to the line (if enebled)
								If $intelimark_also_mark_line = "true" And $Xline <> Sci_GetLineFromPos($Sci, $Selection[0]) Then SendMessage($Sci, $SCI_MARKERADD, $Xline, 6)

							Next
							GUIRegisterMsg($WM_NOTIFY, '_WM_NOTIFY')
						EndIf

					Else
						SendMessage($Sci, $SCI_INDICATORCLEARRANGE, 0, Sci_GetLenght($Sci))
						SendMessage($Sci, $SCI_MARKERDELETEALL, 6, 0)
						SendMessage($Sci, $SCI_MARKERDELETEALL, 7, 0)
						$letztes_Suchwort = ""
					EndIf
				Else
					SendMessage($Sci, $SCI_INDICATORCLEARRANGE, 0, Sci_GetLenght($Sci))
					SendMessage($Sci, $SCI_MARKERDELETEALL, 6, 0)
					SendMessage($Sci, $SCI_MARKERDELETEALL, 7, 0)
					$letztes_Suchwort = ""
				EndIf
			Else

				SendMessage($Sci, $SCI_INDICATORCLEARRANGE, 0, Sci_GetLenght($Sci))
				SendMessage($Sci, $SCI_MARKERDELETEALL, 6, 0)
				SendMessage($Sci, $SCI_MARKERDELETEALL, 7, 0)
				$letztes_Suchwort = ""
			EndIf
			If BitAND($updated, $SC_UPDATE_SELECTION) Then $Bearbeitende_Function_im_skriptbaum_markieren_Freigegeben = "1"
			If $Bearbeitende_Function_im_skriptbaum_markieren_Modus = "2" And BitAND($updated, $SC_UPDATE_SELECTION) Then _Sci_get_Functionname_from_Position($Sci)


			;Check Text before inserting (also predo the indent stuff)
		Case $SCN_MODIFIED

			If BitAND($modificationType, $SC_MOD_BEFOREDELETE) And SendMessage($Sci, $SCI_GETLEXER, 0, 0) = $SCLEX_AU3 And $Scripteditor_AllowBracketpairs = "true" Then
				If (_IsPressed("10", $user32) Or _IsPressed("12", $user32)) Then
					$Scintilla_LastDeletedText = SCI_GetTextRange($Sci, $position, $position + $Length)
				Else
					$Scintilla_LastDeletedText = ""
;~ 					 $Scintilla_LastDeletedText = Sci_GetChar($Sci, $position)
				EndIf

			EndIf

			If BitAND($modificationType, $SC_MOD_INSERTCHECK) And SendMessage($Sci, $SCI_GETLEXER, 0, 0) = $SCLEX_AU3 Then

				Local $tChar = DllStructCreate("char[" & $Length & "]", $Char)
				Local $Inserted_Text = DllStructGetData($tChar, 1)
				$Scintilla_LastInsertedChar2 = $Scintilla_LastInsertedChar ;copy latest to last
				$Scintilla_LastInsertedChar = $Inserted_Text
				Local $current_pos = Sci_GetCurrentPos($Sci)
				Local $current_style = SendMessage($Sci, $SCI_GETSTYLEAT, $current_pos, 0)

				Switch $Inserted_Text

					Case @CRLF ;Enter
						Local $Indent = 0
						$PreviousLine = SCI_GetLine($Sci, Sci_GetLineFromPos($Sci, $current_pos))

						If $PreviousLine = "" Then Return


						;Tab Indent
						If StringInStr($PreviousLine, "then") Or StringInStr($PreviousLine, "while ") Or StringInStr($PreviousLine, "with ") Or StringInStr($PreviousLine, "func ") Or StringInStr($PreviousLine, "for ") Or StringInStr($PreviousLine, "select ") Or StringInStr($PreviousLine, "switch ") Or StringInStr($PreviousLine, "if ") Or StringInStr($PreviousLine, "elseif ") Or StringInStr($PreviousLine, "case") Then $Indent = 1
						If StringStripWS($PreviousLine, 8) = "do" Or StringStripWS($PreviousLine, 8) = "else" Then $Indent = 1
						If StringInStr($PreviousLine, ";") Then $Indent = 0
						If StringInStr($PreviousLine, "return") Then $Indent = 0
						If StringInStr($PreviousLine, "exit") Then $Indent = 0
						If StringInStr($PreviousLine, "exitloop") Then $Indent = 0
;~ 					if StringInStr($PreviousLine, "if ") AND StringInStr($PreviousLine, "(") AND StringInStr($PreviousLine, ")") then $Indent = 0

						Local $TabsAdd = ""
						$PreviousLine = StringTrimRight($PreviousLine, (Sci_GetLineStartPos($Sci, Sci_GetLineFromPos($Sci, $current_pos)) + StringLen($PreviousLine)) - $current_pos) ;Trim all Tabs after the coursor
						$Tabs = StringSplit($PreviousLine, @TAB)

						If $Tabs[0] > 1 Then
							For $i = 1 To $Tabs[0] - 1
								If Not $Tabs[$i] = "" Then ExitLoop
								$TabsAdd &= @TAB

							Next
						EndIf
						If $Indent = 1 Then $TabsAdd = $TabsAdd & @TAB

						$TabsAdd = @CRLF & $TabsAdd

						;Modify the users input
						SendMessageString($Sci, $SCI_CHANGEINSERTION, StringLen($TabsAdd), $TabsAdd)


					Case "(", "[", "{"
						_Scintilla_InsertBracketsAroundSelection($Sci, $Inserted_Text)



					 ;Allow to overwrite some chars, if autoformat is enabled
					Case ")", "}"
						If $ScriptEditor_UseAutoFormat_Correction = "true" Then
							If $current_style <> $SCE_AU3_COMMENT And $current_style <> $SCE_AU3_COMMENTBLOCK AND $Scintilla_LastInsertedChar2 <> "(" AND $Scintilla_LastInsertedChar2 <> "{" Then
							    _Scintilla_check_Brace_highlighting($Sci,1) ;Set offset
								If $current_pos = $bracePos1 Or $current_pos = $bracePos2 Then
									SendMessageString($Sci, $SCI_CHANGEINSERTION, StringLen(""), "")
									Sci_SetCurrentPos($Sci, $current_pos + 1)
								   _Scintilla_check_Brace_highlighting($Sci)
								EndIf
							EndIf
						EndIf

					Case '"', "'", ">"
						If _Scintilla_InsertBracketsAroundSelection($Sci, $Inserted_Text) = 1 Then Return

						If $ScriptEditor_UseAutoFormat_Correction = "true" Then
							If $current_style = $SCE_AU3_STRING Then
								$lineendpos = Sci_GetLineEndPos($Sci, Sci_GetLineFromPos($Sci, $current_pos))
								If $current_pos + 1 <= $lineendpos And SendMessage($Sci, $SCI_GETSTYLEAT, $current_pos + 1, 0) <> $SCE_AU3_STRING And Sci_GetChar($Sci, $current_pos) = $Inserted_Text Then
									SendMessageString($Sci, $SCI_CHANGEINSERTION, StringLen(""), "")
									Sci_SetCurrentPos($Sci, $current_pos + 1)
									_Scintilla_check_Brace_highlighting($Sci)
								EndIf
							EndIf


						EndIf


					Case "&", "=", "?", "+", "-", "/", "*", "<", "and", "or", "not", ":"
						If $ScriptEditor_UseAutoFormat_Correction = "true" Then
							If Sci_GetChar($Sci, $current_pos - 1) <> " " And $current_style <> $SCE_AU3_COMMENT And $current_style <> $SCE_AU3_COMMENTBLOCK And $current_style <> $SCE_AU3_STRING  And $current_pos <> Sci_GetLineStartPos($Sci, Sci_GetLineFromPos($Sci, $current_pos)) And (SendMessage($Sci, $SCI_GETSTYLEAT, $current_pos - 1, 0) <> $SCE_AU3_OPERATOR Or Sci_GetChar($Sci, $current_pos - 1) = ")" Or Sci_GetChar($Sci, $current_pos - 1) = "]") Then
								SendMessageString($Sci, $SCI_CHANGEINSERTION, StringLen(" " & $Inserted_Text), " " & $Inserted_Text)
							EndIf


						EndIf




				EndSwitch
			EndIf

			If (BitAND($modificationType, $SC_MOD_INSERTTEXT) Or BitAND($modificationType, $SC_MOD_DELETETEXT)) And $Parameter_Editor_Laedt_gerade_text = 0 Then

			   ;Auto COLOURISE over 200 chars
			   if $length > 200 then
				  _ISN_AutoIt_Studio_deactivate_GUI_Messages()
				  SendMessage($Sci, $SCI_COLOURISE, 0, -1)
				  _ISN_AutoIt_Studio_activate_GUI_Messages()
			   endif

				If $Sci <> $Debug_log And $Sci <> $ParameterEditor_SCIEditor And $Sci <> $scintilla_Codeausschnitt And $Sci <> $Makro_Codeausschnitt_GUI_scintilla And $QuickView_Notes_Scintilla <> $Sci And $pelock_obfuscator_GUI_Ausgabe_scintilla <> $Sci And $pelock_obfuscator_GUI_Eingabe_scintilla <> $Sci Then _Check_tabs_for_changes()
				If $selections > 1 Then Return ;Stop here at multi coursor
				If WinActive($ParameterEditor_GUI) And _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView) <> -1 Then
					If $autoit_editor_encoding = "2" Then
						_GUICtrlListView_SetItemText($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), _ANSI2UNICODE(StringReplace(Sci_GetText($ParameterEditor_SCIEditor), @CRLF, "")), 1)
					Else
						_GUICtrlListView_SetItemText($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), StringReplace(Sci_GetText($ParameterEditor_SCIEditor), @CRLF, ""), 1)
					EndIf
					AdlibRegister("_Parameter_Editor_Aktualisiere_Vorschaulabel", 1)
				 EndIf


			EndIf



			;_Scintilla_Refresh_CallTip($Sci)


			If $Bearbeitende_Function_im_skriptbaum_markieren_Modus = "1" Then _Sci_get_Functionname_from_Position($Sci)

		Case $SCN_MARGINCLICK
			SendMessage($Sci, $SCI_TOGGLEFOLD, $line_number, 0)

		Case $SCN_SAVEPOINTREACHED

		Case $SCN_SAVEPOINTLEFT

	EndSwitch


	;EndIf
	;EndSelect
	$structNMHDR = 0
	$event = 0
	$lParam = 0
EndFunc   ;==>_WM_NOTIFY_EDITOR

;########################### NOTIF´s für den Projektbaum ###########################


Func _Projecttree_event($hWnd, $iMsg, $sPath, $hItem)

	Switch $iMsg
		Case $TV_NOTIFY_BEGINUPDATE
			GUISetCursor(1, 0, $Studiofenster)
		Case $TV_NOTIFY_ENDUPDATE
			GUISetCursor(2, 0, $Studiofenster)
		Case $TV_NOTIFY_SELCHANGED
;~ 			; Nothing
		Case $TV_NOTIFY_DBLCLK
			Switch $hWnd

				Case GUICtrlGetHandle($hTreeView)
					If _GUICtrlTreeView_GetSelection($hTreeView) = 0 Then Return
					If StringInStr(_GUICtrlTreeView_GetTree($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)), ".", 1, -1) = 0 Then Return
					Try_to_opten_file(_GUICtrlTVExplorer_GetSelected($hWndTreeview))

				Case GUICtrlGetHandle($Choose_File_Treeview)
					If _GUICtrlTreeView_GetSelection($Choose_File_Treeview) = 0 Then Return
					If StringInStr(_GUICtrlTreeView_GetTree($Choose_File_Treeview, _GUICtrlTreeView_GetSelection($Choose_File_Treeview)), ".", 1, -1) = 0 Then Return
					ControlClick($Choose_File_GUI, "", $Choose_File_GUI_OK)


			EndSwitch


		Case $TV_NOTIFY_RCLICK
			If $hWnd <> $hWndTreeview Then Return ;Rechtsklick nur im Projektbaum!
			;Prüfe was eigentlich markiert wurde
			GUICtrlSetState($TreeviewContextMenu_Item1, $GUI_ENABLE)
			GUICtrlSetState($TreeviewContextMenu_Item2, $GUI_ENABLE)
			GUICtrlSetState($TreeviewContextMenu_Item3, $GUI_ENABLE)
			GUICtrlSetState($TreeviewContextMenu_Item4, $GUI_ENABLE)
			GUICtrlSetState($TreeviewContextMenu_Item7, $GUI_ENABLE)
			GUICtrlSetState($TreeviewContextMenu_Item10, $GUI_ENABLE)
			GUICtrlSetState($TreeviewContextMenu_Item5, $GUI_ENABLE)
			GUICtrlSetState($TreeviewContextMenu_Item_Kompilieren, $GUI_DISABLE)
			GUICtrlSetState($TreeviewContextMenu_Item_Jetzt_Kompilieren, $GUI_DISABLE)
			GUICtrlSetState($TreeviewContextMenu_Item_Makro_kompilieren_neu, $GUI_DISABLE)
			GUICtrlSetState($TreeviewContextMenu_Item_Makro_kompilieren_bestehend, $GUI_DISABLE)

			If $Offenes_Projekt = _ISN_Variablen_aufloesen($Projectfolder & "\" & _GUICtrlTreeView_GetTree($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView))) Then
				GUICtrlSetState($TreeviewContextMenu_Item1, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item3, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item4, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item7, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item10, $GUI_DISABLE)
			EndIf


			If StringInStr(_GUICtrlTVExplorer_GetSelected($hWndTreeview), "." & $Autoitextension) And Not _IsDir(_GUICtrlTVExplorer_GetSelected($hWndTreeview)) Then ;Für Au3 Dateien
				GUICtrlSetState($TreeviewContextMenu_Item_Kompilieren, $GUI_ENABLE)
				GUICtrlSetState($TreeviewContextMenu_Item_Jetzt_Kompilieren, $GUI_ENABLE)
				GUICtrlSetState($TreeviewContextMenu_Item_Makro_kompilieren_neu, $GUI_ENABLE)
				GUICtrlSetState($TreeviewContextMenu_Item_Makro_kompilieren_bestehend, $GUI_ENABLE)

			EndIf

			If _WinAPI_PathIsRoot(_GUICtrlTVExplorer_GetSelected($hWndTreeview)) Or (_GUICtrlTVExplorer_GetSelected($hWndTreeview) == @MyDocumentsDir Or _GUICtrlTVExplorer_GetSelected($hWndTreeview) == @DesktopDir Or _GUICtrlTVExplorer_GetSelected($hWndTreeview) == _ISN_Variablen_aufloesen($Projectfolder)) Then
				GUICtrlSetState($TreeviewContextMenu_Item1, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item2, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item3, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item4, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item7, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item10, $GUI_DISABLE)
			EndIf
			If _GUICtrlTVExplorer_GetSelected($hWndTreeview) == @DesktopDir Then GUICtrlSetState($TreeviewContextMenu_Item5, $GUI_DISABLE)


;~ _GUICtrlMenu_TrackPopupMenu(GUICtrlGetHandle($TreeviewContextMenu), $studiofenster);, $aRet[0], $aRet[1], 1, 1, 2)
			Show_KontextMenu($Studiofenster, $TreeviewContextMenu) ;Zeige Contextmenü für den Projektbaum
			; Nothing
		Case $TV_NOTIFY_VERIFY
			If $hWnd = $Weitere_Dateien_Kompilieren_GUI_hTreeview Then _Weitere_Dateien_Kompilieren_Treeview_Event()

		Case $TV_NOTIFY_DELETINGITEM
			; Nothing
		Case $TV_NOTIFY_DISKMOUNTED
			; Nothing
		Case $TV_NOTIFY_DISKUNMOUNTED
			; Nothing
	EndSwitch
EndFunc   ;==>_Projecttree_event



;Funcs after resizing
Func WM_SIZE($hWnd, $iMsg, $wParam, $lParam)

	Switch $hWnd
;~ 		Case $Studiofenster
;~ 			_Rezize(1)

		Case $pelock_obfuscator_GUI
			_PELock_GUI_Resize()

		Case $Codeausschnitt_GUI
			Codeausschnitt_GUI_Resize()

		Case $Makro_Codeausschnitt_GUI
			_Makro_Codeausschnitt_GUI_Resize()

		Case $QuickView_GUI
			_QuickView_GUI_Resize()

		Case $console_GUI
			_Resize_Debug_Console()

;~ 		Case $config_GUI
;~ 		   _Elemente_an_Fesntergroesse_anpassen($config_GUI)
;~ 		   _ISNSettings_Repos_Configpage()
;~ 			_ISNSettings_Repos_Configpage_withoutScrollresize()
;~    MsgBox(0,"j","j")

		Case $ParameterEditor_GUI
			AdlibRegister("_Parametereditor_Fenster_anpassen", 50)

		Case Else
			;Check if it´s an undocked Plugin window
			Local $index_res = _ArraySearch($ISN_Tabs_Additional_Infos_Array, $hWnd, 0, 0, 0, 0, 1, 0)
			If $index_res = -1 Or @error Then Return $GUI_RUNDEFMSG
			If $ISN_Tabs_Additional_Infos_Array[$index_res][1] <> "1" Then Return $GUI_RUNDEFMSG
			Local $plugsize = WinGetClientSize($SCE_EDITOR[$index_res])
			If Not IsArray($plugsize) Then Return $GUI_RUNDEFMSG
			WinMove($Plugin_Handle[$index_res], "", 0, 0, $plugsize[0], $plugsize[1])
	EndSwitch




	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE

;Funcs while resizing
Func WM_SIZING($hWnd, $iMsg, $wParam, $lParam)

	Switch $hWnd

		Case $Studiofenster
			AdlibRegister("_Resize_with_no_tabrefresh", 10)


		Case $config_GUI
			AdlibRegister("_ISNSettings_Repos_Configpage_withoutScrollresize", 1)



	EndSwitch




	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZING


Func WM_RDC($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $wParam

	Local $aData = _RDC_GetData($lParam)

	If @error Then

		; Do something because notifications will not come from this thread!
		_Write_ISN_Debug_Console('Error: _RDC_GetData() - ' & @error & ', ' & @extended & ', ' & _RDC_GetDirectory($lParam), $ISN_Debug_Console_Errorlevel_Critical)
		_RDC_Delete($lParam)
		Return 0
	EndIf
	For $i = 1 To $aData[0][0]
		If $RDC_sEvents Then
			$RDC_sEvents &= '|'
		EndIf
		$RDC_sEvents &= $aData[$i][1] & '?' & _RDC_GetDirectory($lParam) & '\' & $aData[$i][0]
	Next
	AdlibRegister('_RetrieveDirectoryChanges', 250)
	Return 0
EndFunc   ;==>WM_RDC


Func _WM_NCACTIVATE($hWnd, $iMsg, $wParam, $lParam)
	If $hWnd = $Studiofenster Then
		If Not $wParam Then Return 1
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_NCACTIVATE



Func _WM_WINDOWPOSCHANGING_ausnahmen($hWnd)

	Switch $hWnd

		Case $Studiofenster
			Return False

		Case $QuickView_GUI
			Return False


	EndSwitch


	;Plugins
	If $Offenes_Projekt <> "" Then
		If Not IsArray($SCE_EDITOR) Then Return True
		If Not IsArray($Plugin_Handle) Then Return True
		$SCE_EDITOR_String = _ArrayToString($SCE_EDITOR)
		$Plugin_Handle_String = _ArrayToString($Plugin_Handle)
		If StringInStr($SCE_EDITOR_String, $hWnd) Then Return False
		If StringInStr($Plugin_Handle_String, $hWnd) Then Return False
	EndIf


	Return True
EndFunc   ;==>_WM_WINDOWPOSCHANGING_ausnahmen

Func WM_WINDOWPOSCHANGING($hWnd, $msg, $wParam, $lParam)
	If BitAND(WinGetState($Studiofenster, ""), 16) Then Return ;Nicht wenn Minimiert
	$size_new_resize = WinGetClientSize($Studiofenster, "")
	If Not IsArray($size_new_resize) Then Return
	If $size_new_resize[0] < 0 Then Return
	If $size_new_resize[1] < 0 Then Return
	If $size_new_resize[0] = 0 Then Return ;Fenster ist Minimiert
	If $size_new_resize[1] = 0 Then Return ;Fenster ist Minimiert


;~ If BitAND(WinGetState($Studiofenster, ""), 8) Then

;~ 	if not _Is_GUI_in_Studiofenster($hWnd) Then

;~ ConsoleWrite(WinGetTitle($hWnd)&@crlf)
;~    Local $aWinGetPos = WinGetPos($hWnd)
;~     If @error  Or $aWinGetPos[0] < -30000 Then Return $GUI_RUNDEFMSG
;~     Local $tWindowPos = DllStructCreate($tagWINDOWPOS, $lParam)
;~     DllStructSetData($tWindowPos, 'X', $aWinGetPos[0])
;~     DllStructSetData($tWindowPos, 'Y', $aWinGetPos[1])
;~ 		return
;~ Endif
;~ Endif


	If _WM_WINDOWPOSCHANGING_ausnahmen($hWnd) Then
		Local $stWinPos = DllStructCreate("uint;uint;int;int;int;int;uint", $lParam)

		;Das selbe auch für das QuickView Fenster
		If IsDeclared("QuickView_Dummy_Control") And IsDeclared("Studiofenster") And IsDeclared("QuickView_GUI") Then
			$QuickView_Dummy_Control_Posarray = ControlGetPos($Studiofenster, "", $QuickView_Dummy_Control)
			If IsArray($QuickView_Dummy_Control_Posarray) And $hWnd = $QuickView_GUI Then
				DllStructSetData($stWinPos, 3, $QuickView_Dummy_Control_Posarray[0])
				DllStructSetData($stWinPos, 4, $QuickView_Dummy_Control_Posarray[1])
			EndIf
		EndIf

		Local $iLeft = DllStructGetData($stWinPos, 3)
		Local $iTop = DllStructGetData($stWinPos, 4)
		Local $iWidth = DllStructGetData($stWinPos, 5)
		Local $iHeight = DllStructGetData($stWinPos, 6)

		If $iLeft < $iX_Min - ($iWidth - 160) Then DllStructSetData($stWinPos, 3, $iX_Min - ($iWidth - 160))
		If $iTop < $iY_Min Then DllStructSetData($stWinPos, 4, $iY_Min)
		If $iLeft > $iX_Max - 50 Then DllStructSetData($stWinPos, 3, $iX_Max - 50)
		If $iTop > $iY_Max - 50 Then DllStructSetData($stWinPos, 4, $iY_Max - 50)
	EndIf

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_WINDOWPOSCHANGING

Func WM_WINDOWPOSCHANGING_STARTUP($hWnd, $msg, $wParam, $lParam)
	Local $stWinPos = DllStructCreate("uint;uint;int;int;int;int;uint", $lParam)
	Local $iLeft = DllStructGetData($stWinPos, 3)
	Local $iTop = DllStructGetData($stWinPos, 4)
	Local $iWidth = DllStructGetData($stWinPos, 5)
	Local $iHeight = DllStructGetData($stWinPos, 6)

	If $iLeft < $iX_Min - ($iWidth - 160) Then DllStructSetData($stWinPos, 3, $iX_Min - ($iWidth - 160))
	If $iTop < $iY_Min Then DllStructSetData($stWinPos, 4, $iY_Min)
	If $iLeft > $iX_Max - 50 Then DllStructSetData($stWinPos, 3, $iX_Max - 50)
	If $iTop > $iY_Max - 50 Then DllStructSetData($stWinPos, 4, $iY_Max - 50)

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_WINDOWPOSCHANGING_STARTUP


; Handle WM_CONTEXTMENU messages
Func WM_CONTEXTMENU_EDITOR($hWnd, $iMsg, $iwParam, $ilParam)

	Local $tmenu
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return
	If Not _hit_win($current_Scintilla_Window) Then Return ;Only show the context menu when we are in the window with the focus
	;Check if we need to show the full context menu, or the lite (default) one
	_ArraySearch($SCE_EDITOR, $current_Scintilla_Window)
	If @error Then

		;Check if the "undo" button should be enabled
		If SendMessage($current_Scintilla_Window, $SCI_CANUNDO, 0, 0) = 1 Then
			GUICtrlSetState($ScripteditorDefaultContextMenu_undo, $GUI_ENABLE)
		Else
			GUICtrlSetState($ScripteditorDefaultContextMenu_undo, $GUI_DISABLE)
		EndIf

		;Check if the "redo" button should be enabled
		If SendMessage($current_Scintilla_Window, $SCI_CANREDO, 0, 0) = 1 Then
			GUICtrlSetState($ScripteditorDefaultContextMenu_redo, $GUI_ENABLE)
		Else
			GUICtrlSetState($ScripteditorDefaultContextMenu_redo, $GUI_DISABLE)
		EndIf

		Sleep(10)
		Show_KontextMenu($Studiofenster, $ScripteditorDefaultContextMenu)
		Return
	EndIf

	;Check if the menu "open file" should be enabled. (For example for includes)
	$str = Sci_GetLine($current_Scintilla_Window, Sci_GetCurrentLine($current_Scintilla_Window) - 1)
	If StringInStr($str, "#include") And StringInStr($str, ".") Then
		GUICtrlSetState($SCI_EDITOR_CONTEXT_oeffneInclude, $GUI_ENABLE)
	Else
		GUICtrlSetState($SCI_EDITOR_CONTEXT_oeffneInclude, $GUI_DISABLE)
	EndIf

	;Check for file paths
	$array = _StringBetween($str, '"', '"', -1)
	For $u = 0 To UBound($array) - 1
		If FileExists($array[$u]) Then GUICtrlSetState($SCI_EDITOR_CONTEXT_oeffneInclude, $GUI_ENABLE)
	Next

	$array = _StringBetween($str, "'", "'", -1)
	For $u = 0 To UBound($array) - 1
		If FileExists($array[$u]) Then GUICtrlSetState($SCI_EDITOR_CONTEXT_oeffneInclude, $GUI_ENABLE)
	Next


	;Check if the "undo" button should be enabled
	If SendMessage($current_Scintilla_Window, $SCI_CANUNDO, 0, 0) = 1 Then
		GUICtrlSetState($SCI_EDITOR_CONTEXT_rueckgaengig, $GUI_ENABLE)
	Else
		GUICtrlSetState($SCI_EDITOR_CONTEXT_rueckgaengig, $GUI_DISABLE)
	EndIf

	;Check if the "redo" button should be enabled
	If SendMessage($current_Scintilla_Window, $SCI_CANREDO, 0, 0) = 1 Then
		GUICtrlSetState($SCI_EDITOR_CONTEXT_wiederholen, $GUI_ENABLE)
	Else
		GUICtrlSetState($SCI_EDITOR_CONTEXT_wiederholen, $GUI_DISABLE)
	EndIf


	Sleep(10)
	Show_KontextMenu($Studiofenster, $ScripteditorContextMenu)
	Return True
EndFunc   ;==>WM_CONTEXTMENU_EDITOR

Func WM_GETMINMAXINFO($hWnd, $msg, $wParam, $lParam)
	$tagMaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)

	Switch $hWnd

;~ 		Case $Config_GUI
;~ 			DllStructSetData($tagMaxinfo, 7, $Programmeinstellungen_width)
;~ 			DllStructSetData($tagMaxinfo, 8, $Programmeinstellungen_height)

		Case $NEW_PROJECT_GUI
			DllStructSetData($tagMaxinfo, 7, $Neues_Projekt_width)
			DllStructSetData($tagMaxinfo, 8, $Neues_Projekt_height)

		Case $projectmanager
			DllStructSetData($tagMaxinfo, 7, $Projektverwaltung_width)
			DllStructSetData($tagMaxinfo, 8, $Projektverwaltung_height)

		Case $Projekteinstellungen_GUI
			DllStructSetData($tagMaxinfo, 7, $Projekteinstellungen_width)
			DllStructSetData($tagMaxinfo, 8, $Projekteinstellungen_height)

		Case $ruleseditor
			DllStructSetData($tagMaxinfo, 7, $Makros_width)
			DllStructSetData($tagMaxinfo, 8, $Makros_height)

		Case $skriuptbaum_FilterGUI
			DllStructSetData($tagMaxinfo, 7, $Skriptbaumfilter_width)
			DllStructSetData($tagMaxinfo, 8, $Skriptbaumfilter_height)

		Case $parameter_GUI
			DllStructSetData($tagMaxinfo, 7, $Startparameter_width)
			DllStructSetData($tagMaxinfo, 8, $Startparameter_height)

		Case $Makro_auswaehlen_GUI
			DllStructSetData($tagMaxinfo, 7, $makro_waehlen_width)
			DllStructSetData($tagMaxinfo, 8, $makro_waehlen_height)

		Case $newrule_GUI
			DllStructSetData($tagMaxinfo, 7, $makro_bearbeiten_width)
			DllStructSetData($tagMaxinfo, 8, $makro_bearbeiten_height)

		Case $aenderungs_manager_GUI
			DllStructSetData($tagMaxinfo, 7, $aenderungsprotokolle_width)
			DllStructSetData($tagMaxinfo, 8, $aenderungsprotokolle_height)

		Case $neuer_changelog_eintrag_GUI
			DllStructSetData($tagMaxinfo, 7, $aenderungsprotokolle_neuer_eintrag_width)
			DllStructSetData($tagMaxinfo, 8, $aenderungsprotokolle_neuer_eintrag_height)

		Case $changelog_generieren_GUI
			DllStructSetData($tagMaxinfo, 7, $aenderungsprotokolle_bericht_width)
			DllStructSetData($tagMaxinfo, 8, $aenderungsprotokolle_bericht_height)

		Case $bugtracker
			DllStructSetData($tagMaxinfo, 7, $bugtracker_width)
			DllStructSetData($tagMaxinfo, 8, $bugtracker_height)

		Case $ParameterEditor_GUI
			DllStructSetData($tagMaxinfo, 7, $parameter_editor_width)
			DllStructSetData($tagMaxinfo, 8, $parameter_editor_height)

		Case $Funclist_GUI
			DllStructSetData($tagMaxinfo, 7, $Funclist_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $Funclist_GUI_height)

		Case $ISNSTudio_debug
			DllStructSetData($tagMaxinfo, 7, $ISNSTudio_debug_width)
			DllStructSetData($tagMaxinfo, 8, $ISNSTudio_debug_height)

		Case $pelock_obfuscator_GUI
			DllStructSetData($tagMaxinfo, 7, $pelock_obfuscator_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $pelock_obfuscator_GUI_height)

		Case $ExecuteCommandRuleConfig_GUI
			DllStructSetData($tagMaxinfo, 7, $ExecuteCommandRuleConfig_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $ExecuteCommandRuleConfig_GUI_height)

		Case $TemplateNEU
			DllStructSetData($tagMaxinfo, 7, $TemplateNEU_width)
			DllStructSetData($tagMaxinfo, 8, $TemplateNEU_height)

		Case $ToDo_Liste_neuer_eintrag_GUI
			DllStructSetData($tagMaxinfo, 7, $ToDo_Liste_neuer_eintrag_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $ToDo_Liste_neuer_eintrag_GUI_height)

		Case $ToDoList_Manager
			DllStructSetData($tagMaxinfo, 7, $ToDoList_Manager_width)
			DllStructSetData($tagMaxinfo, 8, $ToDoList_Manager_height)

		Case $macro_runscriptGUI
			DllStructSetData($tagMaxinfo, 7, $macro_runscriptGUI_width)
			DllStructSetData($tagMaxinfo, 8, $macro_runscriptGUI_height)

		Case $rulecompileconfig_gui
			DllStructSetData($tagMaxinfo, 7, $rulecompileconfig_gui_width)
			DllStructSetData($tagMaxinfo, 8, $rulecompileconfig_gui_height)

		Case $rule_fileoperation_configgui
			DllStructSetData($tagMaxinfo, 7, $rule_fileoperation_configgui_width)
			DllStructSetData($tagMaxinfo, 8, $rule_fileoperation_configgui_height)

		Case $msgboxcreator_rule
			DllStructSetData($tagMaxinfo, 7, $msgboxcreator_rule_width)
			DllStructSetData($tagMaxinfo, 8, $msgboxcreator_rule_height)

		Case $runfile_config
			DllStructSetData($tagMaxinfo, 7, $runfile_config_width)
			DllStructSetData($tagMaxinfo, 8, $runfile_config_height)

		Case $parameter_GUI_rule
			DllStructSetData($tagMaxinfo, 7, $parameter_GUI_rule_width)
			DllStructSetData($tagMaxinfo, 8, $parameter_GUI_rule_height)

		Case $addlog_GUI
			DllStructSetData($tagMaxinfo, 7, $addlog_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $addlog_GUI_height)

		Case $stausbar_Set_GUI
			DllStructSetData($tagMaxinfo, 7, $stausbar_Set_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $stausbar_Set_GUI_height)

		Case $Weitere_Dateien_Kompilieren_GUI
			DllStructSetData($tagMaxinfo, 7, $Weitere_Dateien_Kompilieren_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $Weitere_Dateien_Kompilieren_GUI_height)

		Case $fFind1
			DllStructSetData($tagMaxinfo, 7, $fFind1_width)
			DllStructSetData($tagMaxinfo, 8, $fFind1_height)

		Case Else
			DllStructSetData($tagMaxinfo, 7, $GUIMINWID) ; min X
			DllStructSetData($tagMaxinfo, 8, $GUIMINHT) ; min Y

	EndSwitch

	_GUICtrlStatusBar_Resize($Status_bar)
	Return 0
EndFunc   ;==>WM_GETMINMAXINFO


Func WM_WINDOWPOSCHANGEDX($hWndGUI, $MsgID, $wParam, $lParam)
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) > 0 Then
		If _GUICtrlTab_GetCurFocus($htab) = -1 Then Return
		If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] = -1 Then Return
		If $hWndGUI = $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)] Then

			_WinAPI_SetWindowPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], WinGetHandle($Studiofenster), 0, 0, 0, 0, $SWP_NOACTIVATE + $SWP_NOMOVE + $SWP_NOSIZE + $SWP_NOREDRAW + $SWP_NOSENDCHANGING) ;Restore ZOrder of Plugin Container Window
		EndIf
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_WINDOWPOSCHANGEDX






Func WM_MOUSEACTIVATE($hWndGUI, $MsgID, $wParam, $lParam)
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) > 0 Then
		If _GUICtrlTab_GetCurFocus($htab) = -1 Then Return
		If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] = -1 Then Return
		If $hWndGUI = $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)] Then Return $MA_NOACTIVATEANDEAT ;Stop activating the Plugin Container Window
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_MOUSEACTIVATE



Func WM_NCHITTEST($hWnd, $iMsg, $iwParam, $ilParam)
	If IsDeclared("Logo_PNG") Then
		If $hWnd = $Logo_PNG And ($iMsg = $WM_NCHITTEST) Then Return $HTCAPTION
	EndIf

EndFunc   ;==>WM_NCHITTEST


Func WM_DROPFILES_FUNC($hWnd, $MsgID, $wParam, $lParam)
	Local $nSize, $pFileName
	Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
	For $i = 0 To $nAmt[0] - 1
		$nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
		$nSize = $nSize[0] + 1
		$pFileName = DllStructCreate("char[" & $nSize & "]")
		DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", DllStructGetPtr($pFileName), "int", $nSize)
		ReDim $gaDropFiles[$i + 1]
		$gaDropFiles[$i] = DllStructGetData($pFileName, 1)
		$pFileName = 0
	Next
	_Drag_and_drop_import_file($nAmt[0], $gaDropFiles)
EndFunc   ;==>WM_DROPFILES_FUNC

Func WM_MOVE($hWnd, $iMsg, $wParam, $lParam)
	Switch $hWnd
		Case $Studiofenster
			_ISN_Move_or_Resize_Plugin_Windows("move")



	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_MOVE



;~    ;Also check Context menu hits of undocked tabs
;~    for $cnt = 0 to ubound($ISN_Tabs_Additional_Infos_Array)-1
;~ 	  if $ISN_Tabs_Additional_Infos_Array[$cnt][1] <> "1" then ContinueLoop
;~ 	  if $nID = $ISN_Tabs_Additional_Infos_Array[$cnt][2] Then
;~ 		 msgbox(0,"j","j",0,$Studiofenster)
;~ 	  Endif
;~    Next



Func _WM_SYSCOMMAND($hWnd, $msg, $wParam, $lParam)
	$nID = BitAND($wParam, 0x0000FFFF)

;~     Switch $nID
;~         Case XXX
;~     EndSwitch

	;check Context menu hits of undocked tabs
	For $cnt = 0 To UBound($ISN_Tabs_Additional_Infos_Array) - 1
		If $ISN_Tabs_Additional_Infos_Array[$cnt][1] <> "1" Then ContinueLoop
		If $nID = $ISN_Tabs_Additional_Infos_Array[$cnt][2] Then
			_ISN_ReDock_Tab($cnt)
		EndIf
	Next
EndFunc   ;==>_WM_SYSCOMMAND



Func _ISN_AutoIt_Studio_activate_GUI_Messages()
	GUIRegisterMsg($WM_NOTIFY, '_WM_NOTIFY')
	GUIRegisterMsg($WM_COMMAND, "_InputCheck")
	GUIRegisterMsg($WM_SYSCOMMAND, "_WM_SYSCOMMAND")
	GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES_FUNC")
	GUIRegisterMsg($WM_GETMINMAXINFO, "WM_GETMINMAXINFO")
	GUIRegisterMsg($WM_WINDOWPOSCHANGING, "WM_WINDOWPOSCHANGING")
;~ 	GUIRegisterMsg($WM_WINDOWPOSCHANGED, 'WM_WINDOWPOSCHANGED')
	GUIRegisterMsg($WM_SIZE, "WM_SIZE")
	GUIRegisterMsg($WM_SIZING, "WM_SIZING")
	GUIRegisterMsg($WM_NCACTIVATE, "_WM_NCACTIVATE")
	GUIRegisterMsg($WM_RDC, 'WM_RDC')
;~ 	GUIRegisterMsg($WM_MOVE,"WM_MOVE")
;~ 	GUIRegisterMsg($WM_MOUSEACTIVATE, 'WM_MOUSEACTIVATE')
	Return True
EndFunc   ;==>_ISN_AutoIt_Studio_activate_GUI_Messages

Func _ISN_AutoIt_Studio_deactivate_GUI_Messages()
	GUIRegisterMsg($WM_COMMAND, "")
	GUIRegisterMsg($WM_DROPFILES, "")
	GUIRegisterMsg($WM_SYSCOMMAND, "")
	GUIRegisterMsg($WM_GETMINMAXINFO, "")
	GUIRegisterMsg($WM_NOTIFY, '')
	GUIRegisterMsg($WM_WINDOWPOSCHANGING, "")
	GUIRegisterMsg($WM_SIZE, "")
	GUIRegisterMsg($WM_SIZING, "")
	GUIRegisterMsg($WM_NCACTIVATE, "")
	GUIRegisterMsg($WM_RDC, '')
;~ 	GUIRegisterMsg($WM_MOVE, '')
;~ 	GUIRegisterMsg($WM_MOUSEACTIVATE, '')
;~ 	GUIRegisterMsg($WM_WINDOWPOSCHANGED, '')
	Return True
EndFunc   ;==>_ISN_AutoIt_Studio_deactivate_GUI_Messages


