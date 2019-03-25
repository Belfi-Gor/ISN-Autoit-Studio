;Globale Variablen für den Helperthread
Global $sProcess = "autoit3"
If @AutoItX64 Then Global $sProcess = $sProcess & "_x64" ; setting to "autoit3_x64.exe" for 64-bit process :)
$sProcess &= '.exe'
Global Const $AC_SRC_ALPHA = 1
Global $Leeres_Array[1] ;Leeres Array
_ArrayDelete($Leeres_Array, 0) ;Für leeres Array
Global $smallIconsdll = @scriptdir & "\data\smallIcons.dll"
Global $bigiconsdll = @scriptdir & "\data\grandIcons.dll"
Global $Skin_is_used = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Skin_is_used")
Global $poCounter ;dummy
Global $_PDH_iCPUCount ;dummy
Global $iProcessID
Global $ISN_Dark_Mode = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$ISN_Dark_Mode")
Global $RUNNING_SCRIPT
Global $Files_to_Scan = $Leeres_Array
Global $aCPUCounters=""
Global $iTotalCPUs=""
Global $hPDHQuery=""
Global $SCI_AUTOCLIST=""
Global $Configfile = $ISN_AutoIt_Studio_Config_Path
Global $SCI_Autocompletelist_backup=""
Global $AutoIt3Wrapper_exe_path=""
Global $Clientsize_diff_width = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Clientsize_diff_width")
Global $Clientsize_diff_height = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Clientsize_diff_height")
Global $autoitexe =""
Global $DPI = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$DPI")
Global $starttime
Global $Studioversion
Global $StudioFenster_MenuHandle = ""
Global $readenpath
Global $readenchangelog
Global $autoupdate_searchtimer
Global $GUIMINWID = 640, $GUIMINHT = 480 ;Default für alle Fenster
Global $Programmupdate_width = 0, $Programmupdate_height = 0
Global $VersionBuild
Global $Gui_Size_Saving_Array[1][2]
_ArrayDelete($Gui_Size_Saving_Array, 0) ;Delete first row
Global $Erweitertes_debugging = _ISNPlugin_Studio_Config_Read_Value("enhanced_debugging", "false")
Global $starte_Skripts_mit_au3Wrapper = _ISNPlugin_Studio_Config_Read_Value("run_scripts_with_au3wrapper", "false")
Global $showdebuggui = _ISNPlugin_Studio_Config_Read_Value("showdebuggui", "true")
Global $Runonmonitor = _ISNPlugin_Studio_Config_Read_Value("runonmonitor", "1")
Global $ISN_Save_Positions_mode = _ISNPlugin_Studio_Config_Read_Value("ISN_save_window_position_mode", "1")
Global $Immer_am_primaeren_monitor_starten = _ISNPlugin_Studio_Config_Read_Value("run_always_on_primary_screen", "true")
Global $__MonitorList[1][5]
Global $Default_font = _ISNPlugin_Studio_Config_Read_Value("default_font", "Segoe UI")
Global $Default_font_size = _ISNPlugin_Studio_Config_Read_Value("default_font_size", "8.5")
Global $disableautocomplete = _ISNPlugin_Studio_Config_Read_Value("disableautocomplete", "false")
Global $Fenster_Hintergrundfarbe = 0xFFFFFF
Global $Titel_Schriftfarbe = 0x003399
Global $Schriftfarbe = 0x000000
Global $Allow_Gui_Size_Saving = 1
Global $Autoitextension = "au3"
Global $skin = _ISNPlugin_Studio_Config_Read_Value("skin", "#none#")
_GetMonitors() ;Lese Monitore ($__MonitorList wird dadurch befüllt)
Global $Loading1_Ani = @scriptdir & "\data\isn_loading_1.ani"
Global $Loading2_Ani = @scriptdir & "\data\isn_loading_2.ani"
Global $proxy_server = _ISNPlugin_Studio_Config_Read_Value("proxy_server", "")
Global $proxy_port = _ISNPlugin_Studio_Config_Read_Value("proxy_port", "8080")
Global $proxy_username = _ISNPlugin_Studio_Config_Read_Value("proxy_username", "")
Global $proxy_PW = _ISNPlugin_Studio_Config_Read_Value("proxy_PW", "")
Global $globalautocomplete_current_script = _ISNPlugin_Studio_Config_Read_Value("globalautocomplete_current_script", "false")
Global $globalautocomplete_variables_return_only_global = _ISNPlugin_Studio_Config_Read_Value("globalautocomplete_variables_return_only_global", "false")
Global $Use_Proxy = _ISNPlugin_Studio_Config_Read_Value("Use_Proxy", "false")
Global $Languagefile = _ISNPlugin_Studio_Config_Read_Value("language", "german.lng")
Global $autoit_editor_encoding = _ISNPlugin_Studio_Config_Read_Value("autoit_editor_encoding", "2") ;1 = ansi; 2 = utf8
Global $Studiomodus = 1
Global $globalautocomplete = _ISNPlugin_Studio_Config_Read_Value("globalautocomplete", "true")
Global $hidefunctionstree = _ISNPlugin_Studio_Config_Read_Value("hidefunctionstree", "false")
Global $showfunctions = _ISNPlugin_Studio_Config_Read_Value("showfunctions", "true")
Global $Skriptbaum_Funcs_alphabetisch_sortieren = _ISNPlugin_Studio_Config_Read_Value("scripttree_sort_funcs_alphabetical", "true")
Global $expandfunctions = _ISNPlugin_Studio_Config_Read_Value("expandfunctions", "true")
Global $showglobalvariables = _ISNPlugin_Studio_Config_Read_Value("showglobalvariables", "true")
Global $expandglobalvariables = _ISNPlugin_Studio_Config_Read_Value("expandglobalvariables", "true")
Global $showlocalvariables = _ISNPlugin_Studio_Config_Read_Value("showlocalvariables", "true")
Global $expandlocalvariables = _ISNPlugin_Studio_Config_Read_Value("expandlocalvariables", "false")
Global $showincludes = _ISNPlugin_Studio_Config_Read_Value("showincludes", "true")
Global $expandincludes = _ISNPlugin_Studio_Config_Read_Value("expandincludes", "false")
Global $showforms = _ISNPlugin_Studio_Config_Read_Value("showforms", "true")
Global $expandforms = _ISNPlugin_Studio_Config_Read_Value("expandforms", "false")
Global $showregions = _ISNPlugin_Studio_Config_Read_Value("showregions", "true")
Global $expandregions = _ISNPlugin_Studio_Config_Read_Value("expandregions", "true")
Global $treefont_font = _ISNPlugin_Studio_Config_Read_Value("treefont_font", "Segoe UI")
Global $treefont_size = _ISNPlugin_Studio_Config_Read_Value("treefont_size", "8.5")
Global $treefont_colour = _ISNPlugin_Studio_Config_Read_Value("treefont_colour", "0x000000")
Global $loadcontrols = _ISNPlugin_Studio_Config_Read_Value("loadcontrols", "false")
Global $Programmupdate_width = (532*$DPI)+$Clientsize_diff_width, $Programmupdate_height = (430*$DPI)+$Clientsize_diff_height
Global $Changelog_GUI_width = (820*$DPI)+$Clientsize_diff_width, $Changelog_GUI_height = (490*$DPI)+$Clientsize_diff_height
Global $Scripttree_dummy_in_ISN = ""
Global $ISN_hTreeview2_searchinput_handle = ""
Global $Scripttree_dummy_Control_pos_Array_Old = ""
Global $Scripttree_Array_Empty[1][30]
Global $Scripttree_Functions_Array = $Scripttree_Array_Empty
Global $Scripttree_Local_Variables_Array = $Scripttree_Array_Empty
Global $Scripttree_Global_Variables_Array = $Scripttree_Array_Empty
Global $Scripttree_Includes_Array = $Scripttree_Array_Empty
Global $Scripttree_Regions_Array = $Scripttree_Array_Empty
Global $ISN_Tabs_Filepaths[30]
Global $ISN_Tabs_Filepaths_backup[30]
Global $ISN_WS_EX_MDICHILD = $WS_EX_MDICHILD
Global $ISN_Scintilla_Handles[30]
Global $Scripttree_current_tab = -1
Global $Scripttree_Generated_Functions_Array = $Leeres_Array
Global $Scripttree_Generated_Local_Variables_Array = $Leeres_Array
Global $Scripttree_Generated_Global_Variables_Array = $Leeres_Array
Global $Scripttree_Generated_Includes_Array = $Leeres_Array
Global $Scripttree_Generated_Regions_Array = $Leeres_Array
Global $Scripttree_Last_Selected_Items_Array = $Scripttree_Array_Empty
Global $Scripttree_old_Scroll_Array = $Scripttree_Array_Empty
Global $Scripttree_old_expanded_items_Array = $Scripttree_Array_Empty
Global $Skriptbaum_Filter_Array = $Leeres_Array
Global $Scripttree_Scriptroot = ""
Global $Scripttree_Projectroot = ""
Global $functiontree = ""
Global $globalvariablestree = ""
Global $localvariablestree = ""
Global $includestree = ""
Global $regionstree = ""
Global $formstree = ""
Global $user32 = DllOpen("user32.dll")
Global $kernel32 = DllOpen("kernel32.dll")
Global $Treeview_Search_LastSearch = ""
Global $Treeview_Search_count = 0
Global $Skriptbaum_Suchfeld_Hintergrundfarbe = 0xFFFFFF
Global $Skriptbaum_Suchfeld_Schriftfarbe = 0x000000
Global $Splitter_Rand = 3
Global $Control_Flashes = 0 ;1 wenn ein error gerade in einem input angezeigt wird (s. _Input_Error_FX() )

Global $Helper_Imagelist = _GUIImageList_Create(16, 16, 5, 1)
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1343) ;folder
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1788) ;au3 file
If $ISN_Dark_Mode = "true" Then
	_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1634) ;global variables (dark)
	_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1393) ;funcs (dark)
Else
	_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1096) ;global variables (while)
	_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1806) ;funcs (while)
EndIf
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1794) ;button
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1813) ;label
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 795) ;input
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1360) ;checkbox
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1174) ;radio
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1818) ;image
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1824) ;slider ;10
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1819) ;progress
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1163) ;updown
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1081) ;icon
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1798) ;combo
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 91) ;edit
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1809) ;group
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1814) ;listbox
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1077) ;tab
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1802) ;date
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1795) ;calendar ;20
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1815) ;listview
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1279) ;include
_GUIImageList_AddIcon($Helper_Imagelist, @ScriptDir & "\autoitstudioicon.ico", 0) ;isn icon
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 117) ;regions
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1031) ;darstellung
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1432) ;ip
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1189) ;softbutton
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1716) ;treeview
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 780) ;isf
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1915) ;menu ;30
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1176) ;com
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 590) ;dummy
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1919) ;toolbar
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 1920) ;statusbar
_GUIImageList_AddIcon($Helper_Imagelist, $smallIconsdll, 471) ;graphic




If $ISN_Dark_Mode = "true" Then
	;Setze Farben für Dark Mode
	$Loading1_Ani = $Loading2_Ani
	$Fenster_Hintergrundfarbe = 0x414141
	$Titel_Schriftfarbe = 0xFFFFFF
	$Schriftfarbe = 0xFFFFFF
	$Skriptbaum_Suchfeld_Hintergrundfarbe = 0x656565
	$Skriptbaum_Suchfeld_Schriftfarbe = 0xFFFFFF
EndIf