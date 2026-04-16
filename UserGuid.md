
D&D Companion App
User Guide

Team One Piece
iOS Capstone Project | Swift & SwiftUI | Spring 2025

Team Member	Role
Skylar	Team Leader / Scheduler
Ivan Garcia	Frontend Development
Barrett Emerson	Backend Development
Jagadeesh Kumar	UI/UX Designer
Reese Roberts	Data Management
Zy Burris	Facilitator

1. Introduction
The D&D Companion app is designed for players to easily keep track of their character sheets, provide a method of rolling, note taking, and spell management. With this, players will not have to worry about keeping a piece of paper around that can easily be ruined from one mishap. 

2. Installation & Setup
The app is distributed as source code via GitHub and run directly through Xcode — no App Store download or paid Apple Developer account is required.

2.1 Cloning the Repository
1.	Open the terminal on your mac (applications  utilities)
2.	Navigate to the folder where you want to store the project: example: cd ~/Documents/Projects
3.	Clone the repository: git clone https://github.com/one-piece-app/dnd.git
4.	A new folder named dnd will appear in your current directory.
2.2 Opening in Xcode
1.	Launch Xcode. If not installed, download it free from the Mac App Store.
2.	Select Open an existing project or file from the Welcome screen (or File  Open).
3.	Navigate to the cloned folder, select the dnd folder and hit open.
4.	Wait for Xcode to finish indexing the project before building.
5.	If prompted about Trust & Open, click Trust and Open
2.3 Running on the iOS Simulator
1.	In the Xcode toolbar, click the device selector and choose a simulator.
2.	Press the Run button (which looks like a play button) or use the keyboard shortcut Command + R to build and launch.
3.	The iOS Simulator will open automatically with the app running.

3. App Overview & Navigation
When the app is launched, you will first see the Characters page. If you do not already have a created Character you will be prompted to create one. If you have an already created character you will see the Character’s name along with the race, class, and level of the character. From there if you select a character you will be taken to the quick access page. Here at the top and bottom of the page you will see quick information for your character. From there you will have buttons that lead to the Dice roller, Character Sheet, Notes, and Settings. Clicking each individual button will take you to their designated page.

4. Feature Guide
4.1 Dice Roller
The dice roller is designed to give the players access to all the types of commonly used dice in dnd. This is to allow players to have a back up if they usually use physical dice or to allow players to use this in lieu of carrying around physical dice. The dice roll history is saved between sessions.

Available Dice
•	d4, d6, d8, d10, d12, d20, d100

How to Roll
1.	Tap Dice Roller from the Quick Access page.
2.	Select the die type you want to roll.
3.	Adjust the quantity using the + / − controls if rolling multiple dice.
4.	Add a modifier if needed (e.g., +5 for an attack roll bonus).
5.	Tap Roll. The result is displayed on screen and is added to roll history.
4.2 Character Sheet
The Character sheet shows information for the character such as level, AC, HP, Stats, Skills, and spells. In this page you will see the selected character at the top allowing you to swap between the stats, skills, and spells through the tabs below the character name, level, AC, and HP. 

Viewing a Character — Stats, Skills, and Spells
After selecting a character, the Character screen displays three tabs:
•	Stats — Shows core character info: name, race, class, level, AC, and all six ability scores with calculated modifiers. Along with this it shows your proficiency bonus that will be applied to skills you are proficient in.
•	Skills — Lists all D&D skill checks with modifiers. Along with this you can select whether or not your character is proficient in the skill by tapping the toggle. This will automatically add your proficiency bonus to the skill.
•	Spells — You are able to add spells for your character. In the add spell page you can give the spell a name, the level of the spell, and a description. Once a spell is created you can use the toggle button to designate whether or not the spell is prepared for the character.


⚠ Note	Character data is stored locally. There is no cloud sync — data will be lost if the app is uninstalled.

4.3 Notes & Campaign Tracking
The notes allow for a player to create a note with categories ranging from Campaign, NPC, Quest, and Session. This allows for players to break up their notes in ways that are easier to keep track of.
Creating a Note
1.	Tap Notes from the Home Screen.
2.	Tap + to create a new note.
3.	Choose a category
4.	Enter a title and write your note in the body field.
5.	Tap Save and the note appears in your notes list.

Organizing & Editing Notes
1.	Notes are organized by category: Campaign Notes, NPC Info, Quest Log, Session Recap.
2.	Tap any note to open and edit it.
3.	Tap Save to commit changes.
4.	Swipe left on a note and tap Delete to remove it.

4.4 Settings
The settings page currently only allows for disabling sound.

Settings
•	Toggle sound on and off
