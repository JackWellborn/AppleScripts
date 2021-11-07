# Rate Track

## What
A series of Automator Workflows to rate the currently playing song. Because ratings are more-or-less deprecated, it also automatically “likes” ratings 4 and 5, and “dislikes” ratings 1 and 2.

## Why
Why the hell would someone even want to automate something as simple as rating songs. I have three reasons. First, I can’t judge a song on first listen. My enjoyment of a given song develops and changes over time. Second, I am not an active music listener which is to say I mostly listen to music while am doing something else. Finally, rating songs in Music is both extremely tedious and incredibly disruptive. The last thing I want to do when listening to Music while working is…

1. Stop what I am doing
2. Switch to Music
3. Click a tiny "..." icon
4. Click "Add to Library"
5. Find the song that's been duplicated to my library
6. Try to click a 10-by-10 point star to rate that song
7. Go back to what I am doing

You might think that listing out each minuscule step is disingenuous, but each one takes me farther out of my flow state. Furthermore, getting back to that flow will likely take longer than the seconds it takes to perform those steps. Left to the UI alone, I would likely never curate my library. Automation bound to keyboard shortcut lets me add music to the library without disrupting my flow state. Once a given song is added, I can then easily pass it to some other automation to rate it, add it to a playlist, etc...

## How (To Use)
### Install the Automator Workflows as Services
1. Download Automator Workflows
2. Move to "~/Library/Services/" Create a "Services" folder if one does not already exist.

### Create a Keyboard Shortcut 
1. Open **System Preferences**
2. Open **Keyboard** preference pane
3. Navigate to **Shortcuts** and select **Services** ("Services" is effectively a synonym for "Quick Actions")
4. Scroll to find "Add Current Song to Library" (or the name used)
5. Click on **none** to assign a keyboard shortcut

## How (It Works)
Each workflow contains...
1. A first `Run AppleScript` action that sets a static rating (0-100). 
2. A second `Run AppleScript` action that...
	1. Finds the currently playing track using strategies found in my [Add Track to Library AppleScript][add].
	2. Applies the static rating to the track
	3. Returns a string to be used for notification.
3. Additional actions to display a notification with the new rating.

## Disclaimer
Be aware that this solution uses automation to control keyboard input, and access Music. It operates locally, and requires special permissions. That said, this author recommends further scrutiny when any solution requires elevated privileges.

[add]: https://github.com/JackWellborn/AppleScripts/tree/main/Music/Add%20Track%20To%20Library
