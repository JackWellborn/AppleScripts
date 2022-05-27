# Rate Track

## What
This script rates the current song in Apple's Music app using the input provided. The expected input is as follows:

* `0` - (No Stars) and Dislike
* `20` - ⭐ and Dislike
* `40` - ⭐⭐ and Dislike
* `60` - ⭐⭐⭐
* `80` - ⭐⭐⭐⭐ and Love
* `100` - ⭐⭐⭐⭐⭐ and Love

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

## How (To Get)
### Shortcuts
On macOS 12 (Monterey) and higher, you can do this in the included Shortcuts app. 

You can find the Shortcuts for rating below:

* [Rate Song][rs]
* [Rate ⭐ and Dislike][1]
* [Rate ⭐⭐ and Dislike][2]
* [Rate ⭐⭐⭐][3]
* [Rate ⭐⭐⭐⭐ and Love][4]
* [Rate ⭐⭐⭐⭐⭐ and Love][5]

#### Creating a Keyboard Shortcuts
Keyboard shortcuts can be configured directly in the Shortcuts app under "Shortcut Details". Keyboard shortcuts can also be added any service in System Preferences.  
1. Open **System Preferences**
2. Open **Keyboard** preference pane
3. Navigate to **Shortcuts** and select **Services** ("Services" is effectively a synonym for "Quick Actions")
4. Scroll to find "Add Current Song to Library" (or the name used)
5. Click on **none** to assign a keyboard shortcut

## How (It Works)
The Shortcuts and Automator workflows all effectively have three actions.
1. A first action that sets a rating (0-100). 
2. A second `Run AppleScript` action that...
	1. Finds the currently playing song using strategies found in my [Add Track to Library AppleScript][add].
	2. Applies the rating to the song
	3. Returns a string to be used for notification.
3. A third action to display a notification with the new rating.

## Disclaimer
Be aware that this solution uses automation to control keyboard input, and access Music. It operates locally, and requires special permissions. That said, this author recommends further scrutiny when any solution requires elevated privileges.

[add]: https://github.com/JackWellborn/AppleScripts/tree/main/Music/Add%20Track%20To%20Library
[rs]: https://www.icloud.com/shortcuts/70084f7a2af14f7893b83fb612416993
[1]: https://www.icloud.com/shortcuts/da841a7c79454326b6e75feffd084777
[2]: https://www.icloud.com/shortcuts/7c7e7db7b8e646a994a55f4134e3b205
[3]: https://www.icloud.com/shortcuts/f8c374b9c3a947ca9619a146d3c4cc73
[4]: https://www.icloud.com/shortcuts/27a27eb733534f8fb9b10b4a20ea8732
[5]: https://www.icloud.com/shortcuts/c7a4efc7549f4112823aff1df61d607c
