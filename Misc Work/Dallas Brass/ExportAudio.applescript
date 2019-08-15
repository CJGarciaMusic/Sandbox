on errorMessage(displayMessage)
	tell application "System Events"
		set theAlertText to "A Stream Deck error has occurred."
		set theAlertMessage to displayMessage
		display alert theAlertText message theAlertMessage as critical
	end tell
end errorMessage

on exportAudio()
	tell application "System Events"
		set appName to name of the first process whose frontmost is true
	end tell
	
	if appName does not contain "Finale" then
		errorMessage("Finale is not in focus, please try again")
		return false
	end if
	
	try
		tell application "System Events"
			tell process appName
				click menu item "Audio File…" of menu of menu item "Export" of menu "File" of menu bar 1
				click button "Save" of window "Save Audio File"
				if sheet 1 of window "Save Audio File" exists
					click UI Element "Replace" of sheet 1 of window "Save Audio File"
				end if
			end tell
		end tell
		return true
	on error
		errorMessage("Nah, brah")
		return false
	end try
end exportAudio

exportAudio()