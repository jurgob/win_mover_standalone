set screens to {}
set command to "defaults read /Library/Preferences/com.apple.windowserver.plist|grep -m 1 '),' -B 300|grep 'UnmirroredHeight\\|UnmirroredWidth \\|UnmirroredOriginX\\|UnmirroredOriginY' |awk '{print $3 \"###\"  }'|tr -d '\"'|tr -d ';'|tr -d '\\n'"
set output to (do shell script command)
--set output to items of output
set AppleScript's text item delimiters to "###"
set output to text items of output
set AppleScript's text item delimiters to ""
repeat with n from 1 to (count) of output
set _idx to (n - 1) mod 4
if _idx = 0 and n < (count of output) then
set end of screens to {item (n + 1) of output as integer, item (n + 2) of output as integer, item (n + 3) of output as integer, item (n + 0) of output as integer}
--set end of screens to n
end if
end repeat

tell application "Finder"
set _b to bounds of window of desktop
set _left to item 1 of _b
set _top to item 2 of _b
set _width to item 3 of _b
set _height to item 4 of _b
end tell

--bad, bad patch
repeat with nscrCheck from 1 to count of screens
set _scrCheck to item nscrCheck of screens
if ((item 3 of _scrCheck) = (item 3 of _b)) and ((item 4 of _scrCheck) = (item 4 of _b)) then
set screens to {_b}
exit repeat
end if
end repeat
--end bad, bad patch

set screenNumbers to count of screens
set curScreenIdx to 0

tell application "System Events"
set _everyProcess to every process
repeat with n from 1 to count of _everyProcess
set _frontMost to frontmost of item n of _everyProcess
if _frontMost is true then set _frontMostApp to process n
end repeat

set _window to window 1 of _frontMostApp
set _winPos to position of _window
set _winLeft to item 1 of _winPos
set _winTop to item 2 of _winPos

repeat with nscr from 1 to count of screens
set _scr to item nscr of screens
set _s_x to item 1 of _scr
set _s_y to item 2 of _scr
set _s_w to item 3 of _scr
set _s_h to item 4 of _scr

if (_s_y ≤ _winTop and _winTop ≤ (_s_y + _s_h)) and (_s_x ≤ _winLeft and _winLeft ≤ (_s_x + _s_w)) then
set curScreenIdx to nscr
end if
end repeat

set curScreen to item curScreenIdx of screens
set _top to item 1 of curScreen
set _left to item 2 of curScreen
set _width to item 3 of curScreen
set _height to item 4 of curScreen

set position of _window to {_left + (_width / 2), _top}
set size of _window to {_width / 2, _height}

end tell

-- tell first window of application (path to frontmost application as Unicode text) to set bounds to {_width / 2, 0, _width, _height}