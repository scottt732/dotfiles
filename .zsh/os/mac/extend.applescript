tell application "System Settings"
	activate
	reveal pane id "com.apple.Displays-Settings.extension"
	delay 2 -- Adjust based on how quickly your System Settings opens
	tell application "System Events"
		tell first window of application process "System Settings"
			tell group 1 of group 2 of splitter group 1 of group 1
				click pop up button 1
				delay 2 -- Wait for the menu to appear
				tell menu 1 of pop up button 1
					set found to false
					repeat with aMenuItem in menu items
						if name of aMenuItem contains "Mirror or Extend to" then
							set found to true
						end if
						if name of aMenuItem contains "iPad" and found then
							click aMenuItem
							exit repeat
						end if
					end repeat
				end tell
			end tell
		end tell
	end tell
end tell
