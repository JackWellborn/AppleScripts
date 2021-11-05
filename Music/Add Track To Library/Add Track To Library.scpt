set useUIAutomation to false
tell application "System Events"
	tell application "Music"
		set {artistName, albumName, songName, songLength} to the {artist, album, name, time} of the current track
		set matchedTracks to (every track whose name is songName and album is albumName and artist is artistName)
		
		-- We don't want to add tracks from Apple Music that have already been added to the library via other means.
		if (count of matchedTracks) is greater than 0 then
			return the first item of matchedTracks
		end if
		
		(* As far as I can tell, there is now way to tell if the current track is playing  from Apple Music, so I am using "cloud status" as proxy in that Apple Music  tracks not in our libary seem to have `missing value` as the cloud status. I am assumung the current track is in our library if cloud status has a value. The good news is that Music doesn't seem to re-add tracks already added. *)
		
		if cloud status of current track is missing value and (count of matchedTracks) is 0 then
			try
				duplicate current track to source "Library"
			on error
				(* The above only works from songs played from albums on Apple Music. It doesn’t work if the song happens to be playing from a “station”. For songs playing on stations we have to use UI automation to add the track to the library. Did you just vomit a litte? Yeah, me too. *)
				set useUIAutomation to true
				activate
			end try
		end if
	end tell
	
	if useUIAutomation is true then
		tell process "Music"
			keystroke "l" using command down
			delay 1
			set topLevel to (the first splitter group of window 1)
			tell topLevel
				tell group 1
					tell group 1
						tell scroll area 1
							set appleMusic to the first UI element
							tell appleMusic
								tell table 1 in group 3
									repeat with currentRow in rows
										tell the second UI element of currentRow
											set rowTitle to ""
											if the role of the first UI element is "AXGroup" then
												-- explicit songs use a different layout
												set rowTitle to the (title of first checkbox in group 1)
											else
												set rowTitle to the title of the first checkbox
											end if
											
											if rowTitle is songName then
												tell the third UI element of currentRow
													description of UI elements in group 3
													click first button in group 3
													activate
												end tell
												exit repeat
											end if
										end tell
									end repeat
								end tell
							end tell
						end tell
					end tell
					if (count of menus) is greater than 0 then
						-- In Monterey, the context menu was here for some reason.
						set contextMenuFound to true
						tell the first menu
							try
								click (the first menu item whose title is "Add to Library")
								delay 3
							on error
								key code 53
							end try
						end tell
					else
						set contextMenuFound to false
					end if
				end tell
			end tell
			if contextMenuFound is false then
				-- In Big Sur, the context menu sensibly belongs to the window.
				tell the first window
					-- Weird bug where selecting the menu directly (`tell first menu`) didn't work.
					tell (the first UI element whose description is "menu")
						try
							click (the first menu item whose title is "Add to Library")
							delay 3
						on error
							key code 53
						end try
					end tell
				end tell
			end if
		end tell
	end if
	
	tell application "Music"
		(* There also doesn't seem to by a way to deterministically identify the duplicated library track so I am using a handful of criteria to find it. Additionally, duplicating the track to the library takes a few seconds so I am using a while loop to constantly check when we can get songs that match the provided criteria, which includes song length for added specificity. *)
		
		set matchedTracks to (every track whose name is songName and album is albumName and artist is artistName and time is songLength)
		
		repeat while (count of matchedTracks) is 0
			set matchedTracks to (every track whose name is songName and album is albumName and artist is artistName and time is songLength)
		end repeat
		return the first item of matchedTracks
	end tell
end tell
