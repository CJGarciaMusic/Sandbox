on errorMessage(displayMessage)
	tell application "System Events"
		set theAlertText to "JetStream Alert"
		set theAlertMessage to displayMessage
		display alert theAlertText message theAlertMessage as critical
	end tell
end errorMessage

on editClear(theMenuName, theMenuItemName, filterItems)
	tell application "System Events"
		set appName to name of the first process whose frontmost is true
	end tell
	
	if appName does not contain "Finale" then
		errorMessage("Please make sure Finale is the front application")
		return false
	end if
	
	try
		tell application "System Events"
			tell process appName
				set activeMenuItem to enabled of menu item theMenuItemName of menu theMenuName of menu bar 1
				if activeMenuItem is true then
					click menu item theMenuItemName of menu theMenuName of menu bar 1
					click button "None" of window "Clear Selected Items"
					repeat with filterItem in filterItems
						click checkbox filterItem of window "Clear Selected Items"
					end repeat
					click button "OK" of window "Clear Selected Items"
					return true
				else
					error
				end if
			end tell
		end tell
	on error
		errorMessage(theMenuItemName & " wasn't able to be selected.\n\nPlease select a region and try again.")
		return false
	end try
end editClear

-- editClear("Edit", "Clear Selected Items�", {"Expressions: Dynamics, Expressive Text,"})

--osascript JetStream.scpt argument1 argument2 in terminal
on run argv
	display dialog (item 1 of argv) & (item 2 of argv) & "."
end run
