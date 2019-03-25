;==================================================================================================
; ISN Debug Console
;==================================================================================================

#include "..\Forms\ISN_Debug_Console.isf" ;Debug Console
_ISN_Gui_Size_Saving_Restore_Settings_by_Keyname("debugconsole")
_Resize_Debug_Console()
if $SHOW_DEBUG_CONSOLE = "true" then
	GUISetState(@SW_SHOW,$console_GUI)
endif


func _Resize_Debug_Console()
$ConsoleGUI_Size = WinGetClientSize($console_GUI)
if IsArray($ConsoleGUI_Size) Then
GUICtrlSetPos($console_commandlabel,0,$ConsoleGUI_Size[1]-20,72,20)
GUICtrlSetPos($console_commandinput,72,$ConsoleGUI_Size[1]-20,$ConsoleGUI_Size[0]-72,20)
controlmove($console_GUI,"",$console_chatbox,0,40*$DPI,$ConsoleGUI_Size[0],$ConsoleGUI_Size[1]-(40*$DPI)-20)
endif
EndFunc



func _Write_ISN_Debug_Console($String="",$level=2,$break=1,$notime=0,$notitle=0,$Category="")
if $SHOW_DEBUG_CONSOLE <> "true" then return

  if $level = 1 AND GuiCtrlRead($debug_console_info_checkbox) = $GUI_UNCHECKED  Then return
  if $level = 2 AND GuiCtrlRead($debug_console_warning_checkbox) = $GUI_UNCHECKED  Then return
  if $level = 3 AND GuiCtrlRead($debug_console_critical_checkbox) = $GUI_UNCHECKED  Then return
  if $Category = "" AND GuiCtrlRead($debug_console_ISNstuff_checkbox) = $GUI_UNCHECKED Then return
  if $Category = $ISN_Debug_Console_Category_Plugin AND GuiCtrlRead($debug_console_plugin_checkbox) = $GUI_UNCHECKED Then return
  if $Category = $ISN_Debug_Console_Category_Hotkey AND GuiCtrlRead($debug_console_hotkey_checkbox) = $GUI_UNCHECKED Then return

$String = StringReplace($String,"\","\\")



if $break = 1 Then
$br = @CRLF
Else
$br = ""
EndIf

if $notime = 1 Then
$time = ""
Else
$time = @hour&":"&@MIN&":"&@SEC&"  "
EndIf


if $notitle = 1 Then
$title = ""
Else
$title = ""
if $level = 1 then 	$title = "<INFO>      "
if $level = 2 then 	$title = "<WARNING>   "
if $level = 3 then 	$title = "<CRITICAL>  "
EndIf

$str = ""
if $level = 0 then
$str = "[c=#FFFFFF]" &$String & "[/c] "&$br
$str = StringReplace($str,$Plugin_System_Delimiter,"[/c][c=#00CCFF] ║ [/c][c=#FFFFFF]")
EndIf

if $level = 1 then
$str = "[c=#00FF00]" &$title&$time&$String & "[/c] "&$br
$str = StringReplace($str,$Plugin_System_Delimiter,"[/c][c=#00CCFF] ║ [/c][c=#00FF00]")
EndIf

if $level = 2 then
$str = "[c=#FCFF00]" &$title&$time&$String & "[/c] "&$br
$str = StringReplace($str,$Plugin_System_Delimiter,"[/c][c=#00CCFF] ║ [/c][c=#FCFF00]")
EndIf

if $level = 3 then
$str = "[c=#FF0000]" &$title&$time&$String & "[/c] "&$br
$str = StringReplace($str,$Plugin_System_Delimiter,"[/c][c=#00CCFF] ║ [/c][c=#FF0000]")
EndIf

_GUICtrlRichEdit_SetFont($console_chatbox , floor(11*floor($DPI)), "Consolas")
_ChatBoxAdd($console_chatbox,$str)
if GuiCtrlRead($debug_console_autoscroll_checkbox) = $GUI_CHECKED Then _SendMessage($console_chatbox, $WM_VSCROLL, $SB_BOTTOM, 0)
EndFunc




func _Send_consolCommand()
$to_exec = guictrlread($console_commandinput)
if $to_exec = "" then return

GUICtrlSetData($console_commandinput, guictrlread($console_commandinput), guictrlread($console_commandinput))
_GUICtrlComboBox_SetEditText ( $console_commandinput, "" )

if stringinstr($to_exec,"print ") OR stringinstr($to_exec,"pt ") Then
$value = StringReplace($to_exec,"print ","")
$value = StringReplace($to_exec,"pt ","")
_Write_ISN_Debug_Console("Value of "&$value&": "&StringReplace(Execute($value),"\","\\"),0)
return
EndIf


if $to_exec = "clip" OR $to_exec = "cp" then
ClipPut (_GUICtrlRichEdit_GetText ($console_chatbox,true))
_Write_ISN_Debug_Console("Content copied to the clipboard!",0)
return
EndIf

if $to_exec = "restart" OR $to_exec = "r" then
_Restart_ISN_AutoIt_Studio()
return
EndIf

if $to_exec = "clear" OR $to_exec = "cls" then
_ChatBoxClear($console_chatbox)
return
EndIf

if $to_exec = "listthreads" OR $to_exec = "lt" then
_Debug_List_ISN_Threads()
return
EndIf


if $to_exec = "exit" OR $to_exec = "q" then
   $AskExit = "false"
   AdlibRegister("_exit", 1)
   Return
Endif

if $to_exec = "localupgrade" OR $to_exec = "lu"  then
   _install_local_upgrade_file()
   Return
Endif

if $to_exec = "help" OR $to_exec = "?" then
$str = "Available commands:"&@crlf& _
"---------------------"&@crlf&@crlf& _
"clear [cls]"&@tab&@tab&@tab&@tab&@tab&"Clear this console"&@crlf& _
"clip [cp]"&@tab&@tab&@tab&@tab&@tab&"Copy the content of this console in the clipboard"&@crlf& _
"help [?]"&@tab&@tab&@tab&@tab&@tab&"This Text"&@crlf& _
"restart [r]"&@tab&@tab&@tab&@tab&@tab&"Restarts the ISN AutoIt Studio"&@crlf& _
"localupgrade [lu]"&@tab&@tab&@tab&@tab&"Forces the ISN AutoIt Studio Updater to install a local updatefile"&@crlf& _
"listthreads [lt]"&@tab&@tab&@tab&@tab&"Displays a list with all runing ISN Helper threads (PID and handle)"&@crlf& _
"print [pt] VALUE OR FUNCTION"&@tab&@tab&"Prints the content of a $ value or the result of a function"&@crlf& _
"exit [q]"&@tab&@tab&@tab&@tab&@tab&"Shutdown (Exit) the ISN AutoIt Studio"&@crlf& _
"---------------------"&@crlf& _
"NOTE: The value in brackets is the short version of the command."&@crlf&@crlf
_Write_ISN_Debug_Console($str,0)
return
EndIf

$result = Execute($to_exec)
if @error then
   _Write_ISN_Debug_Console("Command '"&$to_exec&"' not found!",3,1,1,1)
Else
_Write_ISN_Debug_Console("Result of '"&$to_exec&"': "&$result,0)
endif

endfunc

func _Debug_List_ISN_Threads()
$str = "Currently active ISN Threads:"&@crlf& _
"------------------------------------------"&@crlf& _
"Thread"&@tab&@tab&"PID"&@tab&@tab&"Handle"&@crlf& _
"------------------------------------------"&@crlf
$str = $str&_ArrayToString ($ISN_Helper_Threads,@tab&@tab)&@crlf& _
"------------------------------------------"&@crlf&@crlf
_Write_ISN_Debug_Console($str,0)
EndFunc

func _Restart_ISN_AutoIt_Studio()
$AskExit = "false"
$ISN_Restart_initiated = 1
AdlibRegister("_exit", 1)
EndFunc

func _Shutdown_ISN_AutoIt_Studio()
$AskExit = "false"
AdlibRegister("_exit", 1)
EndFunc

func _debug_console_set_on_top()
   if GuiCtrlRead($debug_console_ontopmode_checkbox) = $GUI_CHECKED Then
	  WinSetOnTop($console_GUI,"",1)
	Else
	  WinSetOnTop($console_GUI,"",0)
	endif
endfunc
