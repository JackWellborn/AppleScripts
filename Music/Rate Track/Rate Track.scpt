on rateTrack(trackToRate, newRating)
	tell application "Music"
		set the rating of the trackToRate to newRating
		
		-- Love songs that have a rating of four or more stars
		if the rating of the trackToRate is greater than or equal to 80 then
			set disliked of the trackToRate to false
			set loved of the trackToRate to true
		end if
		
		-- Dislike a song that have a rating of less than 3 stars
		if the rating of the trackToRate is less than or equal to 40 then
			set loved of the trackToRate to false
			set disliked of the trackToRate to true
		end if
		
		-- Build the text output that can be returned to Shortcuts or Automator for displaying a notification, etc…  
		set {updatedArtist, updatedAlbum, updatedSong, updatedRating} to the {artist, album, name, rating} of the trackToRate
		
		set singleDigitRating to updatedRating / 20
		set starRating to ""
		repeat singleDigitRating times
			set starRating to starRating & "★"
		end repeat
		
		set response to "Rated “" & updatedSong & "“ by " & updatedArtist & " to " & starRating
		return response
	end tell
end rateTrack

(* By default, both Shortcuts and Automator provide the dictionary {input, parameters} as the run handler's parameter, but this makes the Script Editor throw an error whenever you use additional handler like "rateTrack". Using just a single input parameter works around this error and lets me continue to test this script in Script Editor without extraneous modifications. *)
on run input
	set today to date (short date string of (current date)) -- e.g. Friday, May 27, 2022 at 12:00:00 AM
	set useUIAutomation to false
	set newRating to 60 -- The default value for testing
	
	if (count of input) is greater than 0 then
		-- Get the rating from the input
		set newRating to the (first item of input) * 1
	end if
	
	(* When run via Shortcuts, the system's current application is some Shortcuts helper. This below gets the user facing current application. *)
	tell application "System Events"
		set currentAppProcess to the first process whose visible is true and frontmost is true
	end tell
	set currentApp to application (name of currentAppProcess as text)
	
	tell application "Music"
		(* As far as I can tell, there is now way to tell if the current track is playing from Apple Music, so I am using "kind" as proxy, which seems to be "" with Apple Music tracks not in our libary. I am assuming the current track is in our library if kind has a value. The good news is that Music doesn't seem to re-add tracks already added. *)
		if kind of current track is not "" then
			return my rateTrack(current track, newRating)
		else
			set {artistName, albumName, songName, songLength} to the {artist, album, name, time} of the current track
			set matchedTracks to (every track whose name is songName and album is albumName and artist is artistName)
			
			-- We don't want to add tracks from Apple Music that are practically identical to ones that already exist in the library.
			if (count of matchedTracks) is greater than 0 then
				return my rateTrack(first item of matchedTracks, newRating)
			else
				try
					duplicate current track to source "Library"
				on error
					(* The above only works from songs played from albums on Apple Music. It doesn’t work if the song happens to be playing from a “station”. For songs playing on stations we have to use UI automation to add the track to the library. Did you just vomit? Yeah, me too. *)
					set useUIAutomation to true
					activate
				end try
				
				if useUIAutomation is true then
					(* The easiest way to “Add to Library“ in the UI is via the “Song“ menu in the menu bar. Here's the rub. Similar to the "duplicate" command, this doesn't work as expected when the song happens to be playing from a “station“ because the entire song menu is entirely grayed out. Luckily, I more recently discovered this isn't the case when the MiniPlayer window is frontmost. So instead of the projectile vomit inducing UI automation that existed before, we have a much smaller UI automation that only makes you vomit in your mouth just a little. This new automation does two things. It ensure the MiniPlayer window is frontmost and clicks “Add to Library“ in the “Song“ menu. *)
					
					tell application "System Events"
						tell application process "Music"
							if the name of the first window is not "MiniPlayer" then
								if (windows whose name is "MiniPlayer") = {} then
									tell menu bar 1
										tell menu "Window"
											tell menu item "MiniPlayer"
												click
											end tell
										end tell
									end tell
								else
									tell (the first window whose name is "MiniPlayer")
										perform action "AXRaise"
									end tell
								end if
							end if
							tell menu bar 1
								tell menu "Song"
									if (menu items whose name is "Add to Library") is not {} then
										click (the first menu item whose name is "Add to Library")
									end if
								end tell
							end tell
						end tell
					end tell
					tell currentApp
						activate
					end tell
				end if
				(* There also doesn't seem to by a way to deterministically identify the duplicated library track so I am using a handful of criteria to find it. Additionally, duplicating the track to the library takes a few seconds so I am using a while loop to constantly check when we can get songs that match the provided criteria, which includes song length for added specificity. *)
				set matchedTracks to (every track whose name is songName and album is albumName and artist is artistName and date added is greater than today)
				
				repeat while (count of matchedTracks) is 0
					set matchedTracks to (every track whose name is songName and album is albumName and artist is artistName and time is songLength)
				end repeat
				return my rateTrack(first item of matchedTracks, newRating)
			end if
		end if
		
	end tell
end run