#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=I:\Icon.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Description=CS:GO Helper
#AutoIt3Wrapper_Res_Fileversion=1.0.3.4
#AutoIt3Wrapper_Res_ProductVersion=1.0.3.4
#AutoIt3Wrapper_Res_LegalCopyright=Copyright by NguyennAnhh
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "NomadMemory.au3"
#include <Misc.au3>

HotKeySet("{DEL}","_Exit")

If FileExists(@ScriptDir & "\Offsets.ini") Then
	$dwLocalPlayer = IniRead(@ScriptDir & "\Offsets.ini","Signatures","dwLocalPlayer",0)
	$dwEntityList = IniRead(@ScriptDir & "\Offsets.ini","Signatures","dwEntityList",0)
	$dwGlowObjectManager = IniRead(@ScriptDir & "\Offsets.ini","Signatures","dwGlowObjectManager",0)
	$dwForceJump = IniRead(@ScriptDir & "\Offsets.ini","Signatures","dwForceJump",0)
	$Client = IniRead(@ScriptDir & "\Offsets.ini","Signatures","Client",0)
	
	$m_iTeamNum = IniRead(@ScriptDir & "\Offsets.ini","NetVars","m_iTeamNum",0)
	$m_iCrosshairId = IniRead(@ScriptDir & "\Offsets.ini","NetVars","m_iCrosshairId",0)
	$EntLoop = IniRead(@ScriptDir & "\Offsets.ini","NetVars","EntLoop",0)
	$flashDuration = IniRead(@ScriptDir & "\Offsets.ini","NetVars","flashDuration",0)
	$m_bSpotted = IniRead(@ScriptDir & "\Offsets.ini","NetVars","m_bSpotted",0)
	$m_iGlowIndex = IniRead(@ScriptDir & "\Offsets.ini","NetVars","m_iGlowIndex",0)
	$m_fFlags = IniRead(@ScriptDir & "\Offsets.ini","NetVars","m_fFlags",0)
Else
	MsgBox(16,"Error","Offsets.ini is missing from your computer !!!")
EndIf

#Region Hack Function
Func _TriggerBot()
	While 1
	If ProcessExists("csgo.exe") Then
		If _IsPressed(12) Then
	$process= ProcessExists("csgo.exe")
	$procId = _MemoryOpen($process)
	
	Local $LocalPlayer = _MemoryRead($Client + $dwLocalPlayer,$procId,"dword")
	Local $Id = _MemoryRead($LocalPlayer + $m_iCrosshairId,$procId,"dword")
	If $Id > 0 And  $Id < 64 Then

		$Entity = _MemoryRead($Client + $dwEntityList + (($Id - 1) * $EntLoop),$procId,"dword")
		$myTeam = _MemoryRead($LocalPlayer + $m_iTeamNum,$procId,"dword")
		$EntTeam = _MemoryRead($Entity + $m_iTeamNum,$procId,"dword")
		If $myTeam <> $EntTeam Then
			MouseClick("left")
		EndIf
	EndIf
		EndIf
	EndIf
		WEnd
EndFunc


Func _NoFlash()
	If ProcessExists("csgo.exe") Then
	$process= ProcessExists("csgo.exe")
	$procId = _MemoryOpen($process)
	EndIf
	While 1
		Local $LocalPlayer = _MemoryRead($Client + $dwLocalPlayer,$procId,"dword")
		$flashDur = _MemoryRead($LocalPlayer + $flashDuration,$procId,"int")
		If $flashDur > 0 Then
			_MemoryWrite($LocalPlayer + $flashDuration,$procId,0,"int")
		EndIf
	WEnd
EndFunc


Func _Radar2D()
	If ProcessExists("csgo.exe") Then
	$process= ProcessExists("csgo.exe")
	$procId = _MemoryOpen($process)
	EndIf
	While 1
		Local $LocalPlayer = _MemoryRead($Client + $dwLocalPlayer,$procId,"dword")
		For $i = 0 To 64 Step 1
			$Ent = _MemoryRead(($Client + $dwEntityList) + $i * $EntLoop,$procId,"dword")
			_MemoryWrite($Ent + $m_bSpotted,$procId,true,"BOOL")
		Next
	WEnd
EndFunc


Func _GlowESP()
	If ProcessExists("csgo.exe") Then
	$process= ProcessExists("csgo.exe")
	$procId = _MemoryOpen($process)
	EndIf
	While 1
		Local $LocalPlayer = _MemoryRead($Client + $dwLocalPlayer,$procId,"dword")
		$glowObject = _MemoryRead($Client + $dwGlowObjectManager,$procId,"dword")
		$Team = _MemoryRead($LocalPlayer + $m_iTeamNum,$procId,"int")
		For $a = 0 To 64 Step 1
			$dwEnt = _MemoryRead(($Client + $dwEntityList) + $a * $EntLoop,$procId,"dword")
			If $dwEnt <> Null Then
				$glowIndex = _MemoryRead($dwEnt + $m_iGlowIndex,$procId,"int")
				$entityTeam = _MemoryRead($dwEnt + $m_iTeamNum,$procId,"int")
				If $Team == $entityTeam Then
					_MemoryWrite($glowObject + (($glowIndex * 0x38) + 0x4),$procId,0,"float")
					_MemoryWrite($glowObject + (($glowIndex * 0x38) + 0x8),$procId,0,"float")
					_MemoryWrite($glowObject + (($glowIndex * 0x38) + 0xC),$procId,0,"float")
					_MemoryWrite($glowObject + (($glowIndex * 0x38) + 0x10),$procId,0.4,"float")
				Else
					_MemoryWrite($glowObject + (($glowIndex * 0x38) + 0x4),$procId,2,"float")
					_MemoryWrite($glowObject + (($glowIndex * 0x38) + 0x8),$procId,0,"float")
					_MemoryWrite($glowObject + (($glowIndex * 0x38) + 0xC),$procId,0,"float")
					_MemoryWrite($glowObject + (($glowIndex * 0x38) + 0x10),$procId,0.4,"float")
				EndIf
				_MemoryWrite($glowObject + (($glowIndex * 0x38) + 0x24),$procId,true,"BOOL")
				_MemoryWrite($glowObject + (($glowIndex * 0x38) + 0x25),$procId,false,"BOOL")
			EndIf
		Next
	WEnd
EndFunc


Func _Bunnyhop()
	If ProcessExists("csgo.exe") Then
	$process= ProcessExists("csgo.exe")
	$procId = _MemoryOpen($process)
	EndIf
	While 1
		Local $LocalPlayer = _MemoryRead($Client + $dwLocalPlayer,$procId,"dword")
		$flag = _MemoryRead($LocalPlayer + $m_fFlags,$procId,"dword")
		If $flag == 257 And _IsPressed(20) Then
			_MemoryWrite($Client + $dwForceJump,$procId,6,"dword")
		EndIf
	WEnd
EndFunc
#EndRegion

Func _Exit()
	Beep(500,800)
	Exit
EndFunc

