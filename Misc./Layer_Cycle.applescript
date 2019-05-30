on subMenuItem(theMenuName, theMenuItemName)
	tell application "System Events"
		set appName to name of the first process whose frontmost is true
	end tell
	try
		tell application "System Events"
			tell process appName
                set layer_check to value of attribute "AXMenuItemMarkChar" of menu item "Layer 1" of menu of menu item theMenuItemName of menu theMenuName of menu bar 1
                
                if layer_check is missing value then
                    display dialog "Layer 1 is missing it's value!"
                    -- click menu item "Layer 1" of menu of menu item theMenuItemName of menu theMenuName of menu bar 1 
                else
                    display dialog "Layer 1 " & layer_check
                    -- click menu item "Layer 2" of menu of menu item theMenuItemName of menu theMenuName of menu bar 1
                end if
            end tell
        end tell
		return layer_check
	on error
		set theAlertText to "A Stream Deck error has occurred."
        set theAlertMessage to "Layer wasn't able to be selected.\n\nPlease try again."
        display alert theAlertText message theAlertMessage as critical
		return false
	end try
end subMenuItem

subMenuItem("View", "Select Layer")