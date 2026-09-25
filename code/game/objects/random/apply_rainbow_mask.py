
#
#
# Explanation
#
# This is a really quick and dirty script
#
# It takes the `random.dmi` file, opens it,
# gets the `rainbow_template` icon state,
# and applies it to the last icon state in the file.
#
# Made it to avoid having to open up an image editor when just adding a single new random obj spawner.
#
#

import sys
from pathlib import Path
from PIL import Image, ImageChops

# Navigate up to the repository root (D:\Git\Aurora.3) and add to sys.path
REPO_ROOT = Path(__file__).resolve().parents[4]
sys.path.insert(0, str(REPO_ROOT))

from tools.dmi import Dmi

def apply_rainbow_overlay():
    filename = REPO_ROOT / "icons" / "obj" / "random.dmi"
    lightness = 0.4             # 0.0 = dark/saturated, 0.5 = soft pastel tint
    blend_strength = 0.85       # How much of the rainbow effect to keep vs original

    # Open the .dmi file
    dmi = Dmi.from_file(filename)

    # Get the rainbow template (first state)
    # Using get_state ensures we grab the exact one, even if it shifts from the 0 index
    rainbow_state = dmi.get_state("rainbow_template")
    rainbow_img = rainbow_state.frames[0].convert("RGB")

    # Lighten the rainbow mask by blending it with pure white
    white_bg = Image.new("RGB", rainbow_img.size, (255, 255, 255))
    soft_rainbow = Image.blend(rainbow_img, white_bg, lightness)

    # Get the very last state in the DMI file
    last_state = dmi.states[-1]

    # Loop through all frames/directions of the last state
    for i in range(len(last_state.frames)):
        base_img = last_state.frames[i]
        base_rgb = base_img.convert("RGB")

        # Multiply with the softened rainbow
        multiplied = ImageChops.multiply(base_rgb, soft_rainbow)

        # Mix back a small amount of the original to retain highlights
        blended_rgb = Image.blend(base_rgb, multiplied, blend_strength)

        # Restore original transparency
        final_frame = blended_rgb.convert("RGBA")
        if "A" in base_img.getbands():
            final_frame.putalpha(base_img.getchannel("A"))

        last_state.frames[i] = final_frame

    # Pack it back up into a new file
    dmi.to_file(filename)
    print(f"Successfully applied rainbow to '{last_state.name}' and saved to {filename}")

# Run the function
if __name__ == "__main__":
    apply_rainbow_overlay()
