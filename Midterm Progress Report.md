D&D Companion App
Team One Piece  —  Midterm Progress Report (Step 3)
 
iOS Capstone Project  •  Swift / SwiftUI  •  Spring 2025
Submitted: March 6, 2025   |   Due: March 6 @ 11:30 PM
Team Member	Roles
Ivan Garcia -	Frontend Development,
Barret Emerson -	Backend Development,
Skylar Beesley -	Team Leader/Scheduler,
Jagadeesh Kumar	- UI/UX Designer,
Reese Roberts	- Data Management,
Zy Burris	- Facilitator


---

  Section 1:  Screen Mockups
-- Add when completed




Screen Labels
Screen Name	Functionality	Navigation
 Home/Dashboard	Central hub with quick-launch tiles for Dice Roller, Characters, and Notes. Shows active character summary.	Tiles -> Feature screens
Dice Roller	All dice types, modifier input, roll history, quick-access roll buttons, haptic feedback	Dashboard
Tab bar -> any screen
Character List	Scrollable list of saved characters. Tap to view, swipe to delete, ‘+’ to create new.	Dashboard
Tap bar -> any screen
Character Detail / Edit	Full stat sheet: ability scores, HP, AC, saving throws.	Character List 
Back -> Character list
Notes	Notes list filtered by category. Search bar at top. Swipe to delete	Dashboard
Tab bar -> any screen
 Notes Details / Edit	Text editor with category select, timestamp, display, formatting toolbar	Back -> Notes List
Settings		 

---

  Section 2:  App Description

App Overview
 The D&D Companion App is an IOS mobile application designed to streamline and enhance the Dungeons & Dragons gamin experience. Built natively with Swift and SwiftUI, the app serves as a comprehensive digital assistant for players – providing dice rolling, character management, and campaign tracking all in one place, eliminating the need for physical rulebooks, paper character sheets, and separate dice apps during sessions.
 

How the App Is Intended to Be Used
 This app is intended to be used for the Player’s. The player will be able to see a home page with three buttons. Dice Roller, Character Creation/Selection, and Notes. When selecting the Dice Roller the user will be taken to a page that allows the player to select the type of dice, the number of dice to roll, and the ability to add a modifier to the roll.
After pressing the Character Selection button, the user will be prompted to create a character if they do not have one already. When creating a character, the player will have the ability to roll for stats to randomize their stats for quick use. Or they can roll in person and edit their stats on their own (In case the Dungeon Master has a specific method of finding stats) Once a character is selected the player will be able to see the character sheet which will show your core ability scores such as strength, dexterity, constitution, intellect, wisdom, and charisma. This page will also show the players’ character name, level, race, class, health and Armor class. The user will then be able to press a button on the character sheet to access the skills page. On this page the player will be able to roll each of the core skill checks in Dungeons and Dragons with their modifiers tied to them for easy rolls.
The third and final set of screens will be the notes page. When hitting the notes button the user will be brought to a notes page which will allow the player to write notes for the session, keep track of character equipment, or plan for the next session. Once the notes are written the user will be able to save it and access the notes later if needed.
 


Key Features & User Interactions

 Digital Dice Roller
•	Supports all standard D&D dice: d4, D6, D8, D10, D12, D20, and D100
•	Multi-dice syntax (e.g., 2d6, 3d8) and modifier expressions (e.g., 1d20 + 5)
•	Visual display of individual roll results and totals; persistent roll history.
•	Quick-access buttons for ability checks, saving throws, and attack rolls.
•	Haptic feedback on each roll via UIKit feedback generators

Character Stats and Information
•	Character profile: name, race, class, and level.
•	All six core abilities (STR, DEX, CON, INT, WIS, CHA) with automatic modifier calculation.
•	Current/max HP tracker, Armor Class display, saving throw bonuses, and skill proficiencies.

Notes and Campaign Tracking
•	Create, edit, and delete notes organized by category: Campaign Notes, NPC info, Quest Log, Session Recap
•	Timestamped entries for session-by-session tracking.

Advanced / Optional Features (Stretch Goals) 
•	Spell Management System: Spell database by class and level, spell slot tracking,
•	D&D 5E Rule Integration: Pre-loaded race/class templates, auto-fill character creation, level progression with automatic feature unlocks, background selection
•	Quality-of-Life Features: Initiative tracker, Condition tracker, XP tracker, Character back up and export functionality Multiple character support

### Changes / Refinements Since Initial Submission

<!-- Fill this in as a team — even small changes count. Examples: -->
<!-- - Simplified home screen to 3 buttons instead of a dashboard tile layout -->
<!-- - Added Skills View screen accessible from Character Sheet -->
<!-- - Added "Roll Stats" option to Character Creation -->
<!-- - Finalized team roles and submitted to instructor -->

---

## Section 3: Progress Summary — 35% Milestone

### Summary Statement

<!-- Add a brief paragraph here summarizing where the team is at -->

### Components Implemented So Far

| Component / Feature | Status | Owner | Notes |

-- Add once the goup has started implementing features

**Status key:** `Complete` | `In Progress` | `Not Started` | `Stretch Goal`

---

## Section 4: GitHub Repository

### Repository Link

<!-- Add GitHub URL here -->

### Final Branch

<!-- Specify which branch is the final/submission branch -->

---

*Team One Piece · D&D Companion App · iOS Capstone · Team_OnePiece_ProgressReport_March6 · March 6, 2025*
