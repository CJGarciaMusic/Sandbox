on errorMessage(displayMessage)
	tell application "System Events"
		set theAlertText to "A Stream Deck error has occurred."
		set theAlertMessage to displayMessage
		display alert theAlertText message theAlertMessage as critical
	end tell
end errorMessage

on flipDBScores()
	tell application "System Events"
		set tempoData to display dialog "Enter the tempo you want:" default answer ""
		set tempoNum to text returned of tempoData
		tell application "Finale"
			activate
		end tell
	end tell

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
				click menu item "Play Finale through Audio Units" of menu "MIDI/Audio" of menu bar 1
				click menu item "Reassign Playback Sounds" of menu "MIDI/Audio" of menu bar 1
				repeat until UI element "Yes" of window 1 exists
				end repeat
				click UI element "Yes" of window 1
				delay 0.5
				if not (exists (window "ScoreManager")) then
					keystroke "k" using {command down}
				end if
				set partList to name of every menu item of menu 1 of menu item "Edit Part" of menu 1 of menu bar item "Document" of menu bar 1
				if partList contains "Generate Parts" then
					error
					return false
				end if
				set myCount to (count of partList)
				set inst_list to {}
				set perc_list to {}
				repeat with partNum from 1 to myCount
					if ((item partNum of partList) contains "VOICE") then
						copy (item partNum of partList) to the end of inst_list
					end if
					if ((item partNum of partList) contains "PERC") then
						copy (item partNum of partList) to the end of perc_list
					end if
				end repeat
				
				set inst_count to (count of inst_list)
				repeat with instNum from 1 to inst_count
					click menu item (item instNum of inst_list) of menu 1 of menu item "Edit Part" of menu 1 of menu bar item "Document" of menu bar 1
					click pop up button 1 of row 1 of outline 1 of scroll area 1 of tab group 1 of window "ScoreManager"
					click menu item "Garritan Instruments for Finale" of menu 1 of outline 1 of scroll area 1 of tab group 1 of window "ScoreManager"
					click pop up button 2 of row 1 of outline 1 of scroll area 1 of tab group 1 of window "ScoreManager"
					click menu item "Keyboards" of menu 1 of outline 1 of scroll area 1 of tab group 1 of window "ScoreManager"
					click menu item "Concert D Grand Piano" of menu 1 of menu item "Keyboards" of menu 1 of outline 1 of scroll area 1 of tab group 1 of window "ScoreManager"
				end repeat
				set perc_count to (count of perc_list)
				repeat with instNum from 1 to perc_count
					click menu item (item instNum of perc_list) of menu 1 of menu item "Edit Part" of menu 1 of menu bar item "Document" of menu bar 1
					if (item instNum of perc_list) contains "Mallet" then
						click pop up button 2 of row 1 of outline 1 of scroll area 1 of tab group 1 of window "ScoreManager"
						
						click menu item "Percussion" of menu 1 of outline 1 of scroll area 1 of tab group 1 of window "ScoreManager"
						click menu item "Xylophone" of menu 1 of menu item "Percussion" of menu 1 of outline 1 of scroll area 1 of tab group 1 of window "ScoreManager"
					else
						click pop up button 3 of group 1 of tab group 1 of window "ScoreManager"
						click menu item "Percussion" of menu 1 of pop up button 3 of group 1 of tab group 1 of window "ScoreManager"
						repeat until exists window "Percussion Layout Selection"
						end repeat
						click UI element "Select" of window "Percussion Layout Selection"
						click pop up button 2 of row 1 of outline 1 of scroll area 1 of tab group 1 of window "ScoreManager"
						
						click menu item "Percussion" of menu 1 of outline 1 of scroll area 1 of tab group 1 of window "ScoreManager"
						click menu item "Fusion Drum Kit" of menu 1 of menu item "Percussion" of menu 1 of outline 1 of scroll area 1 of tab group 1 of window "ScoreManager"
						
					end if
				end repeat
				delay 2
				keystroke "k" using {command down}
				key code 44 using {command down, option down}
				-- click menu item "MIDI" of menu 1 of menu item "Tools" of menu bar 1
				-- repeat until exists (UI Element "OK" of window "Human Playback Warning")
				-- end repeat
				-- click UI Element "OK" of window "Human Playback Warning"
				click menu item "MIDI" of menu "Tools" of menu bar 1
				click menu item "Tempo" of menu "MIDI Tool" of menu bar 1
				keystroke "a" using {command down}
				click menu item "Set To…" of menu "MIDI Tool" of menu bar 1
				keystroke tempoNum
				click UI element "OK" of window "Set To"
				click menu item "Selection" of menu "Tools" of menu bar 1
				click menu item "Dallas Brass" of menu of menu item "JW Lua" of menu "Plug-ins" of menu bar 1
				
			end tell
		end tell
		return true
	on error
		errorMessage("You don't appear to have any parts generated. Please Generate Parts and try again.")
		return false
	end try
end flipDBScores

flipDBScores()