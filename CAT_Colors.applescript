on errorMessage(displayMessage)
	tell application "System Events"
		set theAlertText to "JetStream Alert"
		set theAlertMessage to displayMessage
		display alert theAlertText message theAlertMessage as critical
	end tell
end errorMessage

on changeColors(colorList)
	tell application "System Events"
		--key code 48 using command down
		set appName to name of the first process whose frontmost is true
	end tell
	
	if appName does not contain "Finale" then
		errorMessage("Please make sure Finale is the front application")
		return false
	end if
	
	try
		tell application "System Events"
			tell process appName
				set activeMenuItem to enabled of menu item "Document Options…" of menu "Document" of menu bar 1
				if activeMenuItem is true then
					click menu item "Document Options…" of menu "Document" of menu bar 1
				else
					error
				end if
				if not (exists (window "Document Options - Notes & Rests")) then
					repeat 25 times
						key code 125
					end repeat
					repeat 8 times
						key code 126
					end repeat
				end if
				set colorLength to (count of colorList)
				repeat with myColor from 1 to colorLength
					click color well myColor of window "Document Options - Notes & Rests"
					click UI element 2 of toolbar 1 of window "Colors"
					set focused of text field 4 of splitter group 1 of window "Colors" to true
					set value of text field 4 of splitter group 1 of window "Colors" to ((item myColor of colorList) as text)
					click text field 4 of splitter group 1 of window "Colors"
					click UI element 3 of toolbar 1 of window "Colors"
					click UI element 2 of toolbar 1 of window "Colors"
				end repeat
				click UI element 2 of window "Colors"
				click button "Apply" of window "Document Options - Notes & Rests"
				click button "OK" of window "Document Options - Notes & Rests"
			end tell
		end tell
	on error
		errorMessage("Unable to change colors, Please be sure you have a document in focus and try again.")
		return false
	end try
end changeColors

set myBlack to "000000"
set myOrange to "FF9900"
set myBlue to "0000FF"
set myYellow to "FFFF00"
set myGreen to "0BFA0B"
set myWhite to "FFFFFF"

set SFard to {myBlack, myOrange, myBlue, myYellow, myGreen, myWhite, myWhite, myWhite, myWhite, myWhite, myWhite, myWhite}

changeColors(SFard)