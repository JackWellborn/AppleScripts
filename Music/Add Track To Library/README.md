# Add Track to Library

## What
Currently a work in progress. This script's sole purpose is to add the currently playing Apple Music track to the library if it isn't already added.

## Why
I mostly listen to music passively in that I have music playing while doing something else, usually working. While easier than [rating music][wv], adding music to the library involves multiple steps.

1. Stop what I am doing
2. Switch to Music
3. Click a tiny "..." icon
4. Click "Add to Library"
5. Resume work

You might think that listing out each minuscule step is disingenuous, but each one takes me farther out of my flow state. Furthermore, getting back to that flow will likely take longer than the seconds it takes to perform those steps. Left to the UI alone, I would likely never add music to my library. Automation bound to keyboard shortcut lets me add music to the library without disrupting my flow state. Once a given song is added, I can then easily pass it to some other automation to rate it, add it to a playlist, etc...

## How (To Use)
### Creating a Workflow
#### Using the Shortcuts App (Recommended)
On macOS 12 (Monterey) and higher, you can do this in the included Shortcuts app. 

1. Open **Shortcuts**
2. Click the **File** menu in the Menu Bar, then click **New Shortcut**
3. Search for **Run AppleScript**, and add it to the workflow
4. Copy contents of Add Script To Library.scpt and paste them in between `on run...` and `end run`
5. When you have Apple Music playing, click the play button on the righthand of the title bar to run and test the shortcut
6. Grant permissions if/when prompted (see disclaimer below)
7. Click "Shortcut Name" in the titlebar to name the shortcut "Add Current Song to Library" (or any other name). 
8. You can also optionally change the shortcut's icon by clicking its icon in the title bar

#### Using the Automator App
On macOS 12 and older versions of macOS, you can create in the included Automator app. 

1. Open **Automator**
2. Click **New Document**
3. Click **Quick Action**
4. Configure so that the Quick Action receives **No Input** in **Any Application** using the drop-down menus at the top of the workflow
5. You can also optionally change the Quick Action's image and color via the subsequent drop-downs here
6. Search for **Run AppleScript**, and add it to the workflow
7. Copy contents of Add Script To Library.scpt and paste them between `on run...` and `end run`
8. When you have Apple Music playing, click the play button on the righthand of the title bar to run and test the Quick Action 
9. Grant permissions if/when prompted (see disclaimer below)
10. Save with the name it "Add Current Song to Library" (or any other name)

### Create a Keyboard Shortcut 
1. Open **System Preferences**
2. Open **Keyboard** preference pane
3. Navigate to **Shortcuts** and select **Services** ("Services" is effectively a synonym for "Quick Actions")
4. Scroll to find "Add Current Song to Library" (or the name used)
5. Click on **none** to assign a keyboard shortcut

## How (It Works)
This returns the library version of the currently playing track via three strategies, in this order:

1. Searches to see if the track already exists in the library using the song, artist, and album names. 
2. If the track does not already exist in the library, it attempts to add it via the `duplicate` command. In theory, this should work all of the time, but for some reason it errors when the current song is being played from an Apple Music station.
3. If the script can't duplicate the current track, this script uses UI automation to attempt to manually click the "Add to Library" menu item. This is why I call this a work in progress. UI automation is notoriously brittle, and that's particularly true for this part of the script. That's because it requires crawling the UI hierarchy to get to the elipsis button of a given song, then crawling back out to click "Add to Library" in the context menu. Making matters worse, many UI elements are generically labeled. What this means is that this logic will likely break with different versions of Apple Music where the hierarchy could change. I had originally hoped to use the elipsis button in the "Now Playing" section, but that only appears on hover and thus isn't accessible to AppleScript.

## Disclaimer
Be aware that this solution uses automation to control keyboard input, and access Music. It operates locally, and requires special permissions. That said, this author recommends further scrutiny when any solution requires elevated privileges.

[wv]: https://wormsandviruses.com/2020/11/why-rate-songs-using-automation/
