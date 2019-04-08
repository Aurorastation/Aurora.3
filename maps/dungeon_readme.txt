This is the readme file for asteroid dungeons. Create all new dungeons in this directory here so that they may be loaded in the game.

Step by step:
0. Learn how to actually map, including how to use mapmerge and how to use git.
1. Open DreamMaker
2. Create a new .tgm file at the directory maps/dungeon_spawns
3. Make sure that the settings are x: 32, y: 32, z:1. Anything else may be wonky.
4. Ensure that you have the correct area set (/area/mine/unexplored), unless your dungeon uses its own special area (for power, and whatnot).
5. Ensure that you have the correct non-dungeon tile set (/turf/unsimulated/chasm_mask).
6. Apply map changes.
7. ENSURE THAT THE MAP FILE IS UNCHECKED IN THE FILE PANE WINDOW ON THE LEFT HAND SIDE AND THAT IT'S NOT INCLUDED IN AURORASTATION.DME.
8. ENSURE THAT THE MAP FILE IS UNCHECKED IN THE FILE PANE WINDOW ON THE LEFT HAND SIDE AND THAT IT'S NOT INCLUDED IN AURORASTATION.DME.
9. Go to tools, and run Prepare Maps - Random Dungeons in one of the mapmerge directories.
10. Run Map Merge - TGM
11. Merge the dungeons you made.
12. Ensure that you're not a fuckup and did everything right.
13. Do git magic here.

Final Notes:
If the dungeon is meant to be unique, append "_unique" at the end of the filename (like "snowflake_unique") so it can only spawn once. Otherwise, your dungeon may occur multiple times.

Ensure that your dungeon actually works if you've added anything complex like a powernet or some other complex thing. You can do this by temporarily deleting all the rest of the dungeon files so your unique dungeon will always spawn.