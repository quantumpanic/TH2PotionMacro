;; Copyright (c) Hambali Hamdan 2024
;; Refer to LICENSE.txt for more info

;; This macro tool was created strictly for hobby purposes to play Diablo Hellfire mod, The Hell 2.
;; You may use and redistribute this file, and make changes while crediting the author.
;; Usage of this tool will adhere to terms set by owners of Diablo Hellfire or its modding communities.
;; Do not remove this copyright.
;; Author is not affiliated with Blizzard, Blizzard North, nor any other associated third parties.

;; ABOUT THIS MACRO
;; A tool to help quick drink potions without using default number keys.
;; Can save a maximum of 3 types of potions. Use keys 1-3 corresponding to each saved potion.
;; Also has a feature to quick drag potions in inventory to belt.
;; Default number of potions to grab from inventory is 4. (Change this using PotionsToTake below.)
;; Currently only works for 1920x1080 resolution, but feel free to test out other resolution.
;; Desktop resolution MUST be the same as game resolution, or the color mapping won't work.
;; Should work on relics and runes as well. (Needs testing.)

;; HOW TO USE
;; Use Alt + Shift + Q on your first belt slot AND the bottom left-most inventory slot. (Both required!)
;; To register a potion type, you will need AT LEAST 2 of the same type.
;; Different tiers don't count (example: healing potion is NOT the same as full healing).
;; Put one potion in the belt slot #1, and the other in the bottom left inventory.
;; Then use Alt + Shift + 1/2/3 to map the color codes for your potion of choice.
;; Hotkey to quick drink potion: 1/2/3
;; Hotkey to quick grab potion from inventory: Alt + 1/2/3

;; Report bugs to me on TH2 Discord (mushroom teriyaki) or send a message on Github (quantumpanic)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#MaxThreadsPerHotkey, 2
Process, Priority,, H
SetBatchLines -1
SetKeyDelay, 0
SetControlDelay, -1
#MenuMaskKey vkFF

; PRESET VALUES
PresetbeltX = 858 ; edit these with your last saved coords
PresetbeltY = 980
PresetinvX = 1309
PresetinvY = 659
PresetP1belt = 0xFFE1BE ; color of full healing potion
PresetP1inv = 0xFFE1BE
PresetP2belt = 0x363636 ; color of full mana potion
PresetP2inv = 0x484848
PresetP3belt = 0xEDF3FF ; color of full holy water
PresetP3inv = 0xEDF3FF
PresetInv = 0xDFC780 ; color of inventory border

ScreenWidth = 1920 ; the width of your game resolution (must be same as display resolution!)
CellSize = 29 ; the size of each cell in inventory or belt
BeltSlots = 8 ; number of potion slots on belt
InvWidth = 10 ; number of inventory cells horizontally
InvHeight = 7 ; number of inventory cells vertically
CurCellX = 0 ; the current inventory cell we are on
CurCellY = 0
CurBelt = 0 ; the current belt slot we are on

PbeltX = 0 ; position of your left-most belt potion
PbeltY = 0
PinvX = 0 ; position of bottom-left cell in inventory
PinvY = 0
Left = 0 ; the inventory border
Down = 0

P1belt_col = 0 ; color of belt potion 1
P2belt_col = 0 ; color of belt potion 2
P3belt_col = 0 ; color of belt potion 3
P1inv_col = 0 ; color of inv potion 1
P2inv_col = 0 ; color of inv potion 2
P3inv_col = 0 ; color of inv potion 3
Inv_col = 0 ; color of the inventory border (to check if it's open)

InvIsOpen = false
PotionsToTake = 4
xPos = 0
yPos = 0
Color = 0

CustomColor = 000000  ; Make transparent the gui
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow
Gui, Color, %CustomColor%

;; This is our main gui
Gui, Add, Text, x10 y10 w300 h12 vInfo cWhite, Shift + Alt + W to load preset. Alt + P to quit.
Gui, Add, Text, x10 y22 w200 h12 vBelt cWhite, Shift + Alt + Q over belt slot #1
Gui, Add, Text, x10 y34 w200 h12 vInv cWhite, Shift + Alt + Q over bottom left inventory slot
Gui, Add, Text, x10 y46 w50 h12 cWhite, P1
Gui, Add, Progress, x30 y47 w10 h12 vP1belt, 100
Gui, Add, Progress, x40 y47 w10 h12 vP1inv, 100
Gui, Add, Text, x60 y46 w50 h12 cWhite, P2
Gui, Add, Progress, x80 y47 w10 h12 vP2belt, 100
Gui, Add, Progress, x90 y47 w10 h12 vP2inv, 100
Gui, Add, Text, x110 y46 w50 h12 cWhite, P3
Gui, Add, Progress, x130 y47 w10 h12 vP3belt, 100
Gui, Add, Progress, x140 y47 w10 h12 vP3inv, 100

; Make the text transluscent
WinSet, TransColor, %CustomColor% 150
Gui, Show, w1000 NoActivate  ; Keep focus on game window
return

+!w:: ; load preset
	PbeltX := PresetbeltX
	PbeltY := PresetbeltY
	PinvX := PresetinvX
	PinvY := PresetinvY
	P1belt_col := PresetP1belt
	P1inv_col := PresetP1inv
	P2belt_col := PresetP2belt
	P2inv_col := PresetP2inv
	P3belt_col := PresetP3belt
	P3inv_col := PresetP3inv
	Inv_col := PresetInv
	
	GuiControl, +c%P1belt_col%, P1belt
	GuiControl, +c%P1inv_col%, P1inv
	GuiControl, +c%P2belt_col%, P2belt
	GuiControl, +c%P2inv_col%, P2inv
	GuiControl, +c%P3belt_col%, P3belt
	GuiControl, +c%P3inv_col%, P3inv
	Guicontrol,, Belt, BeltPos: %PbeltX%,%PbeltY%
	Guicontrol,, Inv, InvPos: %PinvX%,%PinvY%
	Guicontrol,, Info, Preset loaded!

	WindowPosX := PbeltX - 20
	WindowPosY := PbeltY - 105
	GameWindow := WinExist("A")
	Gui, Show, x%WindowPosX% y%WindowPosY%
	WinActivate ahk_id %GameWindow%
return

+!q:: ; set the marker position to check for potions
	MouseGetPos, xPos, yPos
	if (xPos < (ScreenWidth/2)){
		PbeltX := xPos
		PbeltY := yPos
		Guicontrol,, Belt, BeltPos: %PbeltX%,%PbeltY%

		WindowPosX := PbeltX - 20
		WindowPosY := PbeltY - 105
		GameWindow := WinExist("A")
		Guicontrol,, Info, Belt anchor set. Shift + Alt + 1/2/3 to register potion.
		Gui, Show, x%WindowPosX% y%WindowPosY%
		WinActivate ahk_id %GameWindow%
	}
	else {
		PinvX := xPos
		PinvY := yPos
		Left := PinvX - 1
		Down := PinvY + 29
		Inv_col := GetColor(Left, PinvY)
		Guicontrol,, Inv, InvPos: %PinvX%,%PinvY% - Inv color: %Inv_col%
		Guicontrol,, Info, Inventory anchor set. Shift + Alt + 1/2/3 to register potion.
	}
return

GetColor(posx, posy){
	PixelGetColor, Color, posx, posy, RGB
	return Color
}

CheckInventory(){
	; open inventory if it is closed
	global PinvX
	global PinvY
	global Inv_col
	global InvIsOpen

	Left := PinvX - 1
	Down := PinvY + 29
	PixelGetColor, Color, Left, Down, RGB
	if (Color != Inv_col)
	{
		SendInput {I}
		InvIsOpen := false
	} else InvIsOpen := true
}

+!1::
; gets the pixel color of potion from far-left belt slot and set it as Potion type #1
	CheckInventory()
	PixelGetColor, P1belt_col, PbeltX, PbeltY, RGB
	GuiControl, +c%P1belt_col%, P1belt
	PixelGetColor, P1inv_col, PinvX, PinvY, RGB
	GuiControl, +c%P1inv_col%, P1inv
	Guicontrol,, Info, P1 registered using %P1belt_col%-%P1inv_col%
return

+!2::
; gets the pixel color of potion from far-left belt slot and set it as Potion type #2
	CheckInventory()
	PixelGetColor, P2belt_col, PbeltX, PbeltY, RGB
	GuiControl, +c%P2belt_col%, P2belt
	PixelGetColor, P2inv_col, PinvX, PinvY, RGB
	GuiControl, +c%P2inv_col%, P2inv
	Guicontrol,, Info, P2 registered using %P2belt_col%-%P2inv_col%
return

+!3::
; gets the pixel color of potion from far-left belt slot and set it as Potion type #3
	CheckInventory()
	PixelGetColor, P3belt_col, PbeltX, PbeltY, RGB
	GuiControl, +c%P3belt_col%, P3belt
	PixelGetColor, P3inv_col, PinvX, PinvY, RGB
	GuiControl, +c%P3inv_col%, P3inv
	Guicontrol,, Info, P3 registered using %P3belt_col%-%P3inv_col%
return

$1:: ; DrinkP1
	; begin from far left
	Curbelt := 0
	PotionToDrink := 0

	Loop %BeltSlots%
	{
		Xoffset := CurBelt * CellSize
		MouseX := PbeltX + Xoffset
		MouseY := PbeltY
		Color := GetColor(PbeltX, PbeltY)
		PixelGetColor, Color, MouseX, MouseY, RGB
		if (Color == P1belt_col){
			PotionToDrink := CurBelt + 1
			SendInput, %PotionToDrink%
			Curbelt := 0
			return
		}
		else CurBelt := Curbelt + 1
	}
	SendInput, 1
return

$2:: ; DrinkP2
	; begin from far left
	Curbelt := 0
	PotionToDrink := 0

	Loop %BeltSlots%
	{
		Xoffset := CurBelt * CellSize
		MouseX := PbeltX + Xoffset
		MouseY := PbeltY
		Color := GetColor(PbeltX, PbeltY)
		PixelGetColor, Color, MouseX, MouseY, RGB
		if (Color == P2belt_col){
			PotionToDrink := CurBelt + 1
			SendInput, %PotionToDrink%
			Curbelt := 0
			return
		}
		else CurBelt := Curbelt + 1
	}
	SendInput, 2
return

$3:: ; DrinkP3
	; begin from far left
	Curbelt := 0
	PotionToDrink := 0

	Loop %BeltSlots%
	{
		Xoffset := CurBelt * CellSize
		MouseX := PbeltX + Xoffset
		MouseY := PbeltY
		Color := GetColor(PbeltX, PbeltY)
		PixelGetColor, Color, MouseX, MouseY, RGB
		if (Color == P3belt_col){
			PotionToDrink := CurBelt + 1
			SendInput, %PotionToDrink%
			Curbelt := 0
			return
		}
		else CurBelt := Curbelt + 1
	}
	SendInput, 3
return

$!1:: ; fills the belt with Potion 1 from inventory
	CurCellX := 0
	CurCellY := 0
	PotionsTaken := 0

	CheckInventory()
	Sleep 10
		
	Loop %InvHeight% {
		Loop %InvWidth% {
			MouseX := PinvX + (CurCellX * CellSize)
			MouseY := PinvY - (CurCellY * CellSize)
			PixelGetColor, Color, MouseX, MouseY, RGB
			if (Color == P1inv_col)
			{
				MoveThisPotionToBelt(MouseX, MouseY)
				PotionsTaken++
				if (PotionsTaken >= PotionsToTake)
				{
					break 2
				}
			}
			CurCellX := CurCellX + 1
		}
		CurCellX := 0
		CurCellY := CurCellY + 1
	}
	CurCellY := 0

	if (!InvIsOpen)
		SendInput {I}
return

$!2:: ; fills the belt with Potion 2 from inventory
	CurCellX := 0
	CurCellY := 0
	PotionsTaken := 0

	CheckInventory()
	Sleep 10
		
	Loop %InvHeight% {
		Loop %InvWidth% {
			MouseX := PinvX + (CurCellX * CellSize)
			MouseY := PinvY - (CurCellY * CellSize)
			PixelGetColor, Color, MouseX, MouseY, RGB
			if (Color == P2inv_col)
			{
				MoveThisPotionToBelt(MouseX, MouseY)
				PotionsTaken++
				if (PotionsTaken >= PotionsToTake)
				{
					break 2
				}
			}
			CurCellX := CurCellX + 1
		}
		CurCellX := 0
		CurCellY := CurCellY + 1
	}
	CurCellY := 0

	if (!InvIsOpen)
		SendInput {I}
return

$!3:: ; fills the belt with Potion 3 from inventory
	CurCellX := 0
	CurCellY := 0
	PotionsTaken := 0

	CheckInventory()
	Sleep 10
		
	Loop %InvHeight% {
		Loop %InvWidth% {
			MouseX := PinvX + (CurCellX * CellSize)
			MouseY := PinvY - (CurCellY * CellSize)
			PixelGetColor, Color, MouseX, MouseY, RGB
			if (Color == P3inv_col)
			{
				MoveThisPotionToBelt(MouseX, MouseY)
				PotionsTaken++
				if (PotionsTaken >= PotionsToTake)
				{
					break 2
				}
			}
			CurCellX := CurCellX + 1
		}
		CurCellX := 0
		CurCellY := CurCellY + 1
	}
	CurCellY := 0

	if (!InvIsOpen)
		SendInput {I}
return

MoveTo(posx, posy){
	MouseMove, posx, posy
}

MoveThisPotionToBelt(posx, posy){
	BlockInput On
	BlockInput, MouseMove

	Send, {Shift down}
	MouseClick, left, posx, posy
	Send, {Shift up}

	BlockInput Off
	BlockInput, MouseMoveOff
}

CountInBelt(col){
	PotionsInBelt := 0
	Loop %BeltSlots% {
		MouseX := %PbeltX% + (%CurBelt% * %CellSize%)
		MouseY := %PbeltY%
		GetColor(MouseX, MouseY)
		if (Color == col){
			PotionsInBelt += 1
		}
	}
	return PotionsInBelt
}

GuiClose:
ExitApp
return

!p::
ExitApp
return
