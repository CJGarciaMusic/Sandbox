-- tell application "System Events"
--     set appName to name of the first process whose frontmost is true
-- end tell
-- try
--     tell application "System Events"
--         tell process appName
--             set theFont "Menlo"
--             keystroke "|"
--             key code 123 using shift down
--             set {a, b} to value of attribute "AXSelectedTextRange" text area 1 of window 1
--         end tell
--         set font of characters a through b to theFont
--     end tell
-- on error
--         set theAlertText to "A Stream Deck error has occurred."
--         set theAlertMessage to "The keystroke wasn't able to be completed.\n\nPlease try again."
--         display alert theAlertText message theAlertMessage as critical
--         return false
-- end try

set the clipboard to "?"

tell application "System Events"
    keystroke "v" using command down
end tell
