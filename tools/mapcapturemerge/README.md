# Map capture merge tool
---

 This is script for merging captured map images using `Capture-Map` verb. 
 
---
Map capture merge tool manual
======

1. Capture desired Z levels using in game verb `Capture-map`
2. Before closing game window, go to cache folder usually located under Documents/BYOND and copy all map capture images named like `map_capture_x1_y33_z1_r32.png` to folder under this tool called `captures`.
3. Install *Python* and *Pillow* library (If you don't have them).
4. Run `python merge.py` and wait for captured images to be merged.
5. After execution you will find all merged map images in this folder.

Notes:
 * This tool been tested with Python 2.7.6 under Windows 10 Bash.
 * This tool also been tested with Python 3.6.1 under Windows 10.