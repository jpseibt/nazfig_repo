#Requires AutoHotkey v2.0
#Warn    ; Enable warnings
#UseHook ; Forces AHK to take priority over Windows shortcuts

SendMode("Input")
SetWorkingDir(A_ScriptDir)
SetTitleMatchMode(2) ; Match anywhere in the title

ToggleApp(win_title, run_cmd)
{
  if (app_id := WinExist(win_title))
  {
    if WinActive("ahk_id " app_id)
    {
      WinMinimize("ahk_id " app_id)
    }
    else
    {
      ; WinGetMinMax returns -1 if minimized or 1 if maximized
      if (WinGetMinMax("ahk_id " app_id) = -1)
      {
        WinRestore("ahk_id " app_id)
      }

      WinActivate("ahk_id " app_id)
    }
  }
  else
  {
    Run(run_cmd)
    WinWait(win_title)
    WinActivate(win_title)
  }
}

;==================================================
; App Toggle Hotkeys
;==================================================
#Enter::ToggleApp("ahk_class Window Class ahk_exe neovide.exe", "neovide.exe --")
^*t::ToggleApp("ahk_exe windowsterminal.exe", "windowsterminal.exe")
#e::ToggleApp("ahk_exe FPilot.exe", "FPilot.exe")
#m::ToggleApp("ahk_exe spotify.exe", "spotify.exe")
#b::ToggleApp("Google Chrome ahk_exe chrome.exe", "chrome.exe")
#n::ToggleApp("naznotes.txt ahk_class Window Class ahk_exe neovide.exe", '"neovide.exe" --grid 80x30 "C:\users\jose.seibt\naznotes.txt"')
#g::ToggleApp("Google Gemini ahk_exe chrome.exe", '"C:\Program Files\Google\Chrome\Application\chrome.exe" --app=https://gemini.google.com/app')
#w::ToggleApp("web.whatsapp.com ahk_exe chrome.exe", '"C:\Program Files\Google\Chrome\Application\chrome.exe" --app=https://web.whatsapp.com')
#;::ToggleApp("Monkeytype ahk_exe chrome.exe", '"C:\Program Files\Google\Chrome\Application\chrome.exe" --app=https://monkeytype.com')


;==================================================
; Window Manipulation
;==================================================
#q::WinClose("A")
#-::WinMinimize("A")
#f::WinMaximize("A")
#^f::WinSetStyle("^0xC00000", "A") ; Toggles the WS_CAPTION style


;==================================================
; Vim-like Navigation Keys
;==================================================
*!h::Send("{Left}")    ; Alt + h = Left Arrow
*!j::Send("{Down}")    ; Alt + j = Down Arrow
*!k::Send("{Up}")      ; Alt + k = Up Arrow
*!l::Send("{Right}")   ; Alt + l = Right Arrow
!w::Send("^{Right}")   ; Alt + w = Ctrl + Right Arrow (word navigation)
!b::Send("^{Left}")    ; Alt + b = Ctrl + Left Arrow (word navigation)
!0::Send("{Home}")     ; Alt + 0 = Home
!$::Send("{End}")      ; Alt + $ = End
!x::Send("{Delete}")   ; Alt + x = Delete
!Space::Send("{Esc}")  ; Alt + Space = Escape


;==================================================
; AHK MODIFIER SYMBOLS REFERENCE
;==================================================
; #  -> Windows Key         (LWin/RWin)
; !  -> Alt Key             (LAlt/RAlt)
; ^  -> Control Key         (LCtrl/RCtrl)
; +  -> Shift Key           (LShift/RShift)
; &  -> Custom Combination  (Custom Combo: Combines ANY two keys, e.g. "CapsLock & j" turns
;                            CapsLock into a modifier. NOTE: The first key loses its native 
;                            function unless specifically re-mapped.)
; <  -> Left key of a pair  (e.g., <! for Left Alt)
; >  -> Right key of a pair (e.g., >! for Right Alt)
; *  -> Wildcard            (Fire even if other modifiers are held)
; ~  -> Passthrough         (Don't block the key's native function)
; $  -> Hook                (Prevents the hotkey from triggering itself)
;==================================================
