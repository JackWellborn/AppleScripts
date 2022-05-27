# Add Track to Library

## What
This script's sole purpose is to add the currently playing Apple Music track to the library if it isn't already added.

## Why
I mostly listen to music passively in that I have music playing while doing something else, usually working. While easier than [rating music][wv], adding music to the library involves multiple steps.

1. Stop what I am doing
2. Switch to Music
3. Click a tiny "..." icon
4. Click "Add to Library"
5. Resume work

You might think that listing out each minuscule step is disingenuous, but each one takes me farther out of my flow state. Furthermore, getting back to that flow will likely take longer than the seconds it takes to perform those steps. Left to the UI alone, I would likely never add music to my library. Automation bound to keyboard shortcut lets me add music to the library without disrupting my flow state. Once a given song is added, I can then easily pass it to some other automation to rate it, add it to a playlist, etc...

## How (To Use)
You can see an example of how this is used in [the Rate Track section of this repo][rt].

## How (It Works)
This returns the library version of the currently playing track via three strategies, in this order:

1. Searches to see if the track already exists in the library using the song, artist, and album names. 
2. If the track does not already exist in the library, it attempts to add it via the `duplicate` command. In theory, this should work all of the time, but for some reason it errors when the current song is being played from an Apple Music station.
3. If the script can't duplicate the current track, this script uses UI automation to attempt to manually click the "Add to Library" in the "Song" menu. 

## Disclaimer
Be aware that this solution uses automation to control keyboard input, and access Music. It operates locally, and requires special permissions. That said, this author recommends further scrutiny when any solution requires elevated privileges.

[wv]: https://wormsandviruses.com/2020/11/why-rate-songs-using-automation/
[rt]: https://github.com/JackWellborn/AppleScripts/tree/main/Music/Rate%20Track
