#include-once

; [ AutoIt3 Module Handle ]
Global Const $DLL_KERNEL32 = DllOpen('kernel32.dll')
Global Const $DLL_USER32 = DllOpen('user32.dll')
Global Const $DLL_OLE32 = DllOpen('ole32.dll')

; [ WINAPI Module Handle ]
Global Const $MOD_KERNEL32 = WinAPI_GetModuleHandleA('kernel32.dll')
Global Const $MOD_USER32 = WinAPI_GetModuleHandleA('user32.dll')

; [ Function Address Pointer ]
Global Const $PTR_USER32_CharUpperA = WinAPI_GetProcAddress($MOD_USER32, 'CharUpperA')
Global Const $PTR_USER32_CharUpperW = WinAPI_GetProcAddress($MOD_USER32, 'CharUpperW')

Global $CoreFx_WildcardMatchExA
Global $CoreFx_WildcardMatchExW

If @AutoItX64 Then
   $CoreFx_WildcardMatchExA = '0x48895C240848896C2410488974241857415441554883EC20440FB6124D8BE14D8BE8488BEA488BF14584D2744A0F1F004180FA3F750D803E00744E48FFC648FFC5EB2A4180FA2A7444480FBE060FB7D8490FBEC20FB7C841FFD48BCB488BF841FFD448FFC548FFC6483BC7751C440FB655004584D275B9803E007541807D0000753BB801000000EB3632C0EB32488D55014D8BCC4D8BC5488BCE41FFD584C07518380674E4488D4E014D8BCC4D8BC5488BD541FFD584C074D0B001EB0233C0488B5C2440488B6C2448488B7424504883C420415D415C5FC3'
   $CoreFx_WildcardMatchExW = '0x48895C240848896C2410488974241857415441554883EC200FB7024D8BE14D8BE8488BEA488BF16685C074470F1F40006683F83F751066833E00744B4883C6024883C502EB246683F82A743F0FB71E0FB7C841FFD48BCB488BF841FFD44883C5024883C602483BC7751D0FB745006685C075BD66833E00754466837D0000753DB801000000EB3832C0EB34488D55024D8BCC4D8BC5488BCE41FFD584C0751A66833E0074E2488D4E024D8BCC4D8BC5488BD541FFD584C074CEB001EB0233C0488B5C2440488B6C2448488B7424504883C420415D415C5FC34C89442418534883EC20498BD883FA01757DE83D16000085C0750733C0E92A010000E89507000085C07507E87C160000EBE9E8AD150000FF15935C00004889057CAD0000E8A7140000488905209B0000E85B0D000085C07907E862040000EBCBE89313000085C0781FE88A10000085C0781633C9E8B30A000085C0750BFF05E59A0000E9BF000000E8F70F0000EBCA85D2754D8B05CF9A000085C00F8E7AFFFFFFFFC88905BF9A00003915259B00007505E8C20C00004885DB7510E8C40F0000E8FB030000E8E2150000904885DB7577833DD18B0000FF746EE8E2030000EB6783FA027556E8D2030000BAC8020000B901000000E807080000488BD84885C00F8416FFFFFF488BD08B0D9A8B0000FF15B45B0000488BCB85C0741633D2E8C6030000FF15985B0000890348834B08FFEB16E80A070000E9E0FEFFFF83FA03750733C9E835060000B8010000004883C4205BC3'
   Else
   $CoreFx_WildcardMatchExA = '0x558BEC53568B7508578B7D0C8A0784C074353C3F7509803E0074424647EB223C2A74430FBE0E0FBED00FB7C2500FB7D9FF551453894508FF551447463B4508751C8A0784C075CB803E007548803F0075435F5EB8010000005B5DC210005F5E32C05B5DC210008B45148B5D1050538D4F015156FFD384C07512380674E08B55145253574656FFD384C074D25F5EB0015B5DC210005F5E33C05B5DC21000'
   $CoreFx_WildcardMatchExW = '0x558BEC538B5D0C0FB703568B7508576685C0743E6683F83F750E66833E00744A83C60283C302EB226683F82A74450FB73E0FB7C050FF551457894508FF551483C30283C6023B450875200FB7036685C075C266833E00754D66833B0075475F5EB8010000005B5DC210005F5E32C05B5DC210008B45148B7D1050578D4B025156FFD784C0751666833E0074DE8B551452575383C60256FFD784C074CE5F5EB0015B5DC210005F5E33C05B5DC21000'
   EndIf

$CoreFx_WildcardMatchExA = CoreFx_DynamicCodeAdd($CoreFx_WildcardMatchExA)
$CoreFx_WildcardMatchExW = CoreFx_DynamicCodeAdd($CoreFx_WildcardMatchExW)

OnAutoItExitRegister('CoreFx_WildCard_Free')

; $CoreFx_WildcardMatchExA/W
; - First Feed to CallWindowProcA/W to give info which address shall be executed.
; - Second Feed to CallWindowProcA/W to give info address of self function to be
;   able call itself as recursive function by function itself. The symbolic name
;   aren't portable so use this method.
; $PTR_USER32_CharUpperA/W
; - Feed CharUpperA/W pointer to function to be used inside of its codeblocks.

Func CoreFx_WildcardMatchExA($string, $patern)
   Local $ret
   $ret = DllCall($DLL_USER32, "bool", "CallWindowProcA", "ptr", $CoreFx_WildcardMatchExA, "str", $string, "str", $patern, "ptr", $CoreFx_WildcardMatchExA, "ptr", $PTR_USER32_CharUpperA)
   If @error Then Return SetError(1, 0, 0)
   Return $ret[0]
EndFunc

Func CoreFx_WildcardMatchExW($string, $patern)
   Local $ret
   $ret = DllCall($DLL_USER32, "bool", "CallWindowProcW", "ptr", $CoreFx_WildcardMatchExW, "wstr", $string, "wstr", $patern, "ptr", $CoreFx_WildcardMatchExW, "ptr", $PTR_USER32_CharUpperW)
   If @error Then Return SetError(1, 0, 0)
   Return $ret[0]
EndFunc

Func CoreFx_WildCard_Free()
   CoreFx_DynamicCodeRem($CoreFx_WildcardMatchExA)
   CoreFx_DynamicCodeRem($CoreFx_WildcardMatchExW)
EndFunc

Func CoreFx_DynamicCodeAdd(ByRef $opcode, $Free = 1)
   	Local $binary, $bufer, $ret

	If Not IsBinary($opcode) Then $opcode = Binary($Opcode)
	$bufer = _MemVirtualAlloc(0, BinaryLen($opcode), $MEM_COMMIT, $PAGE_EXECUTE_READWRITE)

	$binary = DllStructCreate("byte[" & BinaryLen($opcode) & "]", $bufer)
	DllStructSetData($binary, 1, $opcode)

	If $Free Then $opcode = ''
	$binary = 0

	Return $bufer
EndFunc

Func CoreFx_DynamicCodeRem(ByRef $Memory)
   If $Memory = 0 Then Return
   Local $ret
   $ret = _MemVirtualFree($Memory, 0, $MEM_RELEASE)
   If $ret Then $Memory = 0
   Return $ret
EndFunc

Func WinAPI_GetModuleHandleA($lpModuleName)
   Local $ret
   $ret = DllCall($DLL_KERNEL32, 'ptr', 'GetModuleHandleA', 'str', $lpModuleName)
   If @error Or $ret[0] = 0 Then Return SetError(1, @extended, 0)
   Return $ret[0]
EndFunc

Func WinAPI_GetModuleHandleW($lpModuleName)
   Local $ret
   $ret = DllCall($DLL_KERNEL32, 'ptr', 'GetModuleHandleW', 'wstr', $lpModuleName)
   If @error Or $ret[0] = 0 Then Return SetError(1, @extended, 0)
   Return $ret[0]
EndFunc

Func WinAPI_GetProcAddress($hModule, $ProcName)
   Local $ret, $typ = 'str'
   If IsInt($ProcName) Then $typ = 'ptr'
   $ret = DllCall($DLL_KERNEL32, 'ptr', 'GetProcAddress', 'ptr', $hModule, $typ, $ProcName)
   If @error Or $ret[0] = 0 Then Return SetError(1, @extended, 0)
   Return $ret[0]
EndFunc

Func WinAPI_FreeLibrary($hModule)
   Local $ret
   $ret = DllCall($DLL_KERNEL32, 'bool', 'FreeLibrary', 'ptr', $hModule)
   If @error Or $ret[0] = 0 Then Return SetError(1, @extended, 0)
   Return $ret[0]
EndFunc
