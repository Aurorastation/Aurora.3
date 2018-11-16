# Map Conflict Fixer/Helper

The map conflict fixer is a script that can help you fix map conflicts easier and faster. Here's how it works:


## Before using

You need git for this, of course. Make sure your development branch is up to date before starting a map edit to ensure the script outputs a correct fix.

## Dictionary mode

Dictionary conflicts are the easiest to fix, you simply need to create more models to accommodate your changes and everyone elses.

When you run in this mode, if the script finishes successfully the map should be ready to be committed.

If the script fails in dictionary mode, you can run it again in full fix mode.

## Full Fix mode

When you and someone else edit the same coordinate, there is no easy way to fix the conflict. You need to get your hands dirty.

The script will mark every tile with a marker type to help you identify what needs fixing in the map editor.

After you edit and fix a marked map, you should run it through the map merger. The .backup file should be the same you used before.

## Priorities

In Full Fix mode, the script needs to know which map version has higher priority, yours or someone elses. This important so tiles with multiple area and turf types aren't created.

Your version has priority - In each conflicted coordinate, your floor type and your area type will be used Their version has priority - In each conflicted coordinate, your floor type and your area type will not be used

### IMPORTANT

This script is in a testing phase and you should not consider any output to be safe. Always verify the maps this script produced to make sure nothing is out of place.

### Map Conflict Fixer/Helper guide
1. **Check out work branch** - Checkout your own branch.
2. **Prepare Maps** - Run "Prepare Maps.bat" in the tools/mapmerge2/ directory. 
3. **Pull** - Merge desired branch into your branch.
4. **Run map conflict fixer** - Run "Run Map Conflict Fixer.bat" in the tools/mapmerge2/map_conflict_fixer directory. 
5. **Mode 0. Mode 1 if necessary** - Try using mode 0, if it does not work you would have to manually resolve issue using mode 1.
6. **Check manually** - Check the file manually, open map file that ends with .fixed
7. **Rename .fixed.dmm to be the original** - After conflicts are resolved replace original file with .fixed.dmm file. Make sure to remove .fixed.dmm into normal format(.dmm)
8. **Run mapmerge** - Run "mapmerge.bat" in the tools/mapmerge2/ directory.