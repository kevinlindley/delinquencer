# delinquencer
A "sequencer" module for Norns but with a mind of its own.

## Requirements
* Norns

#### Optional 
* A Synth of your choice connected via MIDI

## Background
The Delinquencer is my second ever script for the Norns and I wanted to create a sequencer that allowed a music producer to have fun exploring, mangling and generally being inspired by finding sweet spots in a 64 grid of notes. Essentially, the Delinquencer starts out as a simple 64 grid sequencer but then allows you to experiment quickly.

So it’s the Delinquencer feature complete?

> Well probably not, I’m sure its missing a feature you think will be vital, but I’ve had to draw the line under the Delinquencer project otherwise it would never see the light of day outside of my Norns Shield.

So what makes the Delinquencer something you should try? 

> After all it’s not like the world needs yet another sequencer?
Entering notes into a 64 grid and playing them back is usually the end state for most sequencers but for the Delinquencer that’s the starting point. It’s the ability to mangle and alter over time the playback of these notes that makes the Delinquencer different to many other sequencers.

So is Delinquencer a MIDI sequencer?

> Well yes, but I also dabbled in SuperCollider and ended up producing a new sound engine. I only added it so I could just have a simple sound during development of the Delinquencer. Trouble is, that took on a life of its own. It’s still simplistic but then this was meant to be a sequencer project not a synth-engine project, but it’s fun to play with.

## Mini Manual
![alt text](https://github.com/kevinlindley/DemonCore/blob/55c5bdccfdd51665a203fefc01973fa4af2d7787/DemonCoreSmall.png "Demon Core running on a Norns Shield")
### Screen 1 - Sequencer
#### Navigation Controls
Encoder 1 - Change BPM
Encoder 2 - Menu Item Selection
Encoder 3 - Menu Item Value
Key 1 - System Menu
Key 1*- Reset if Held
Key 2 - Next Menu
Key 3 - Stop/Start
#### Settings
* BPM       - Beats per Minute
* Division  - Divs per Beat
* Loop      - Looping Type
* Scale     - Quantised Scale
* Transpose - Transposition
* Preset    - Patches
### Screen 2 - Note Entry
#### Navigation Controls
* Encoder 1 - Sequencer Cell Position Selection
* Encoder 2 - Menu Item Selection
* Encoder 3 - Menu Item Value
* Key 1 - System Menu
* Key 2 - Next Menu
* Key 3 - Toggle Current Cell
#### Settings
* Note      :  Cell Note Pitch
* Velocity : Cell Note Velocity
* Length : Cell Note Length
* Cell State : On/Off/Rst/Skp
* Probability: 0-100%
* Len Notes  : Set all Note Lengths
### Screen 4 - PatternMaker
#### Navigation Controls
* Encoder 1 - Change BPM
* Encoder 2 - Menu Item Selection
* Encoder 3 - Menu Item Value
* Key 1 - System Menu
* Key 2 - Next Menu
* Key 3 - Stop/Start
#### Settings
* Pattern  - Mod Pattern
* Neutron  - On/Off/Rst/Skp/Ctl
* Proton   - On/Off/Rst/Skp/Ctl
* Mutation - 0-100%
### Screen 4 - Delinquencer
#### Settings
* Encoder 1 - Select Modifier
* Encoder 2 - Menu Item Selection
* Encoder 3 - Menu Item Value
* Key 1 - System Menu
* Key 2 - Next Menu
* Key 3 - Stop/Start
#### Settings
* X-Pat  - Column Pattern
* X-Loop - Column Change Freq
* Y-Pat  - Row Pattern
* Y-Loop - Row Change Freq
* State  - Modifier Setting
* Preset - Presets to try
## Notes on Use
?
## Installation
1. From maiden:
```;install https://github.com/kevinlindley/delinquencer```
2. Power Off and On to install the new Engine provided.
