/*
IconProcs README

A BYOND library for manipulating icons and colors

by Lummox JR

version 1.0

The IconProcs library was made to make a lot of common icon operations much easier. BYOND's icon manipulation
routines are very capable but some of the advanced capabilities like using alpha transparency can be unintuitive to beginners.

CHANGING ICONS

Several new procs have been added to the /icon datum to simplify working with icons. To use them,
remember you first need to setup an /icon var like so:

GLOBAL_DATUM_INIT(my_icon, /icon, new('iconfile.dmi'))

icon/ChangeOpacity(amount = 1)
	A very common operation in DM is to try to make an icon more or less transparent. Making an icon more
	transparent is usually much easier than making it less so, however. This proc basically is a frontend
	for MapColors() which can change opacity any way you like, in much the same way that SetIntensity()
	can make an icon lighter or darker. If amount is 0.5, the opacity of the icon will be cut in half.
	If amount is 2, opacity is doubled and anything more than half-opaque will become fully opaque.
icon/GrayScale()
	Converts the icon to grayscale instead of a fully colored icon. Alpha values are left intact.
icon/ColorTone(tone)
	Similar to GrayScale(), this proc converts the icon to a range of black -> tone -> white, where tone is an
	RGB color (its alpha is ignored). This can be used to create a sepia tone or similar effect.
	See also the global ColorTone() proc.
icon/MinColors(icon)
	The icon is blended with a second icon where the minimum of each RGB pixel is the result.
	Transparency may increase, as if the icons were blended with ICON_ADD. You may supply a color in place of an icon.
icon/MaxColors(icon)
	The icon is blended with a second icon where the maximum of each RGB pixel is the result.
	Opacity may increase, as if the icons were blended with ICON_OR. You may supply a color in place of an icon.
icon/Opaque(background = "#000000")
	All alpha values are set to 255 throughout the icon. Transparent pixels become black, or whatever background color you specify.
icon/BecomeAlphaMask()
	You can convert a simple grayscale icon into an alpha mask to use with other icons very easily with this proc.
	The black parts become transparent, the white parts stay white, and anything in between becomes a translucent shade of white.
icon/AddAlphaMask(mask)
	The alpha values of the mask icon will be blended with the current icon. Anywhere the mask is opaque,
	the current icon is untouched. Anywhere the mask is transparent, the current icon becomes transparent.
	Where the mask is translucent, the current icon becomes more transparent.
icon/UseAlphaMask(mask, mode)
	Sometimes you may want to take the alpha values from one icon and use them on a different icon.
	This proc will do that. Just supply the icon whose alpha mask you want to use, and src will change
	so it has the same colors as before but uses the mask for opacity.

COLOR MANAGEMENT AND HSV

RGB isn't the only way to represent color. Sometimes it's more useful to work with a model called HSV, which stands for hue, saturation, and value.

	* The hue of a color describes where it is along the color wheel. It goes from red to yellow to green to
	cyan to blue to magenta and back to red.
	* The saturation of a color is how much color is in it. A color with low saturation will be more gray,
	and with no saturation at all it is a shade of gray.
	* The value of a color determines how bright it is. A high-value color is vivid, moderate value is dark,
	and no value at all is black.

While rgb is typically stored in the #rrggbb" format (with optional "aa" on the end), HSV never needs to be displayed.
Most procs that work in HSV "space" will simply accept RGB inputs and convert them in place using rgb2num(color, space = COLORSPACE_HSV).

That said, if you want to manually modify these values rgb2hsv() will hand you back a list in the format list(hue, saturation, value, alpha).
Converting back is simple, just a hsv2rgb(hsv) call

Hue ranges from 0 to 360 (it's in degrees of a color wheel)
Saturation ranges from 0 to 100
Value ranges from 0 to 100

Knowing this, you can figure out that red is list(0, 100, 100) in HSV format, which is hue 0 (red), saturation 100 (as colorful as possible),
value 255 (as bright as possible). Green is list(120, 100, 100) and blue is list(240, 100, 100).

It is worth noting that while we do not have helpers for them currently, these same ideas apply to all of byond's color spaces
HSV (hue saturation value), HSL (hue satriation luminosity) and HCY (hue chroma luminosity)

Here are some procs you can use for color management:

BlendRGB(rgb1, rgb2, amount)
	Blends between two RGB or RGBA colors using regular RGB blending. If amount is 0, the first color is the result;
	if 1, the second color is the result. 0.5 produces an average of the two. Values outside the 0 to 1 range are allowed as well.
	Returns an RGB or RGBA string
BlendHSV(rgb1, rgb2, amount)
	Blends between two RGB or RGBA colors using HSV blending, which tends to produce nicer results than regular RGB
	blending because the brightness of the color is left intact. If amount is 0, the first color is the result; if 1,
	the second color is the result. 0.5 produces an average of the two. Values outside the 0 to 1 range are allowed as well.
	Returns an RGB or RGBA string
HueToAngle(hue)
	Converts a hue to an angle range of 0 to 360. Angle 0 is red, 120 is green, and 240 is blue.
AngleToHue(hue)
	Converts an angle to a hue in the valid range.
RotateHue(rgb, angle)
	Takes an RGB or RGBA value and rotates the hue forward through red, green, and blue by an angle from 0 to 360.
	(Rotating red by 60° produces yellow.)
	Returns an RGB or RGBA string
GrayScale(rgb)
	Takes an RGB or RGBA color and converts it to grayscale. Returns an RGB or RGBA string.
ColorTone(rgb, tone)
	Similar to GrayScale(), this proc converts an RGB or RGBA color to a range of black -> tone -> white instead of
	using strict shades of gray. The tone value is an RGB color; any alpha value is ignored.
*/

/*
Get Flat Icon DEMO by DarkCampainger

This is a test for the get flat icon proc, modified approprietly for icons and their states.
Probably not a good idea to run this unless you want to see how the proc works in detail.
mob
	icon = 'old_or_unused.dmi'
	icon_state = "green"

	Login()
		// Testing image underlays
		underlays += image(icon='old_or_unused.dmi',icon_state="red")
		underlays += image(icon='old_or_unused.dmi',icon_state="red", pixel_x = 32)
		underlays += image(icon='old_or_unused.dmi',icon_state="red", pixel_x = -32)

		// Testing image overlays
		AddOverlays(image(icon='old_or_unused.dmi',icon_state="green", pixel_x = 32, pixel_y = -32))
		AddOverlays(image(icon='old_or_unused.dmi',icon_state="green", pixel_x = 32, pixel_y = 32))
		AddOverlays(image(icon='old_or_unused.dmi',icon_state="green", pixel_x = -32, pixel_y = -32))

		// Testing icon file overlays (defaults to mob's state)
		AddOverlays('_flat_demoIcons2.dmi')

		// Testing icon_state overlays (defaults to mob's icon)
		AddOverlays("white")

		// Testing dynamic icon overlays
		var/icon/I = icon('old_or_unused.dmi', icon_state="aqua")
		I.Shift(NORTH,16,1)
		AddOverlays(I)

		// Testing dynamic image overlays
		I=image(icon=I,pixel_x = -32, pixel_y = 32)
		AddOverlays(I)

		// Testing object types (and layers)
		AddOverlays(/obj/effect/overlay_test)

		loc = locate (10,10,1)
	verb
		Browse_Icon()
			set name = "1. Browse Icon"
			// Give it a name for the cache
			var/iconName = "[ckey(src.name)]_flattened.dmi"
			// Send the icon to src's local cache
			src<<browse_rsc(getFlatIcon(src), iconName)
			// Display the icon in their browser
			src<<browse("<body bgcolor='#000000'><p><img src='[iconName]'></p></body>")

		Output_Icon()
			set name = "2. Output Icon"
			to_chat(src, "Icon is: [icon2base64html(getFlatIcon(src))]")

		Label_Icon()
			set name = "3. Label Icon"
			// Give it a name for the cache
			var/iconName = "[ckey(src.name)]_flattened.dmi"
			// Copy the file to the rsc manually
			var/icon/I = fcopy_rsc(getFlatIcon(src))
			// Send the icon to src's local cache
			src<<browse_rsc(I, iconName)
			// Update the label to show it
			winset(src,"imageLabel","image='[REF(I)]'");

		AddOverlays()
			set name = "4. Add Overlay"
			AddOverlays(image(icon='old_or_unused.dmi',icon_state="yellow",pixel_x = rand(-64,32), pixel_y = rand(-64,32))

		Stress_Test()
			set name = "5. Stress Test"
			for(var/i = 0 to 1000)
				// The third parameter forces it to generate a new one, even if it's already cached
				getFlatIcon(src,0,2)
				if(prob(5))
					AddOverlays()
			Browse_Icon()

		Cache_Test()
			set name = "6. Cache Test"
			for(var/i = 0 to 1000)
				getFlatIcon(src)
			Browse_Icon()

/obj/effect/overlay_test
	icon = 'old_or_unused.dmi'
	icon_state = "blue"
	pixel_x = -24
	pixel_y = 24
	layer = TURF_LAYER // Should appear below the rest of the overlays

world
	view = "7x7"
	maxx = 20
	maxy = 20
	maxz = 1
*/

#define TO_HEX_DIGIT(n) ascii2text((n&15) + ((n&15)<10 ? 48 : 87))


/icon/proc/BecomeLying()
	Turn(90)
	Shift(SOUTH,6)
	Shift(EAST,1)

/// Multiply all alpha values by this float
/icon/proc/ChangeOpacity(opacity = 1)
	MapColors(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,opacity, 0,0,0,0)

/// Convert to grayscale
/icon/proc/GrayScale()
	MapColors(0.3,0.3,0.3, 0.59,0.59,0.59, 0.11,0.11,0.11, 0,0,0)

/icon/proc/ColorTone(tone)
	GrayScale()

	var/list/TONE = rgb2num(tone)
	var/gray = round(TONE[1]*0.3 + TONE[2]*0.59 + TONE[3]*0.11, 1)

	var/icon/upper = (255-gray) ? new(src) : null

	if(gray)
		MapColors(255/gray,0,0, 0,255/gray,0, 0,0,255/gray, 0,0,0)
		Blend(tone, ICON_MULTIPLY)
	else SetIntensity(0)
	if(255-gray)
		upper.Blend(rgb(gray,gray,gray), ICON_SUBTRACT)
		upper.MapColors((255-TONE[1])/(255-gray),0,0,0, 0,(255-TONE[2])/(255-gray),0,0, 0,0,(255-TONE[3])/(255-gray),0, 0,0,0,0, 0,0,0,1)
		Blend(upper, ICON_ADD)

/// Take the minimum color of two icons; combine transparency as if blending with ICON_ADD
/icon/proc/MinColors(icon)
	var/icon/new_icon = new(src)
	new_icon.Opaque()
	new_icon.Blend(icon, ICON_SUBTRACT)
	Blend(new_icon, ICON_SUBTRACT)

/// Take the maximum color of two icons; combine opacity as if blending with ICON_OR
/icon/proc/MaxColors(icon)
	var/icon/new_icon
	if(isicon(icon))
		new_icon = new(icon)
	else
		// solid color
		new_icon = new(src)
		new_icon.Blend("#000000", ICON_OVERLAY)
		new_icon.SwapColor("#000000", null)
		new_icon.Blend(icon, ICON_OVERLAY)
	var/icon/blend_icon = new(src)
	blend_icon.Opaque()
	new_icon.Blend(blend_icon, ICON_SUBTRACT)
	Blend(new_icon, ICON_OR)

/// make this icon fully opaque--transparent pixels become black
/icon/proc/Opaque(background = "#000000")
	SwapColor(null, background)
	MapColors(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,1)

/**
 * Change a grayscale icon into a white icon where the original color becomes the alpha
 * I.e., black -> transparent, gray -> translucent white, white -> solid white
 */
/icon/proc/BecomeAlphaMask()
	SwapColor(null, "#000000ff") // don't let transparent become gray
	MapColors(0,0,0,0.3, 0,0,0,0.59, 0,0,0,0.11, 0,0,0,0, 1,1,1,0)

/icon/proc/UseAlphaMask(mask)
	Opaque()
	AddAlphaMask(mask)

/icon/proc/AddAlphaMask(mask)
	var/icon/mask_icon = new(mask)
	mask_icon.Blend("#ffffff", ICON_SUBTRACT)
	// apply mask
	Blend(mask_icon, ICON_ADD)

/*
	HSV format is represented as "#hhhssvv" or "#hhhssvvaa"

	Hue ranges from 0 to 0x5ff (1535)

		0x000 = red
		0x100 = yellow
		0x200 = green
		0x300 = cyan
		0x400 = blue
		0x500 = magenta

	Saturation is from 0 to 0xff (255)

		More saturation = more color
		Less saturation = more gray

	Value ranges from 0 to 0xff (255)

		Higher value means brighter color
 */
/proc/ReadRGB(rgb)
	if(!rgb) return

	// interpret the HSV or HSVA value
	var/i=1,start=1
	if(text2ascii(rgb) == 35) ++start // skip opening #
	var/ch,which=0,r=0,g=0,b=0,alpha=0,usealpha
	var/digits=0
	for(i=start, i<=length(rgb), ++i)
		ch = text2ascii(rgb, i)
		if(ch < 48 || (ch > 57 && ch < 65) || (ch > 70 && ch < 97) || ch > 102) break
		++digits
		if(digits == 8) break

	var/single = digits < 6
	if(digits != 3 && digits != 4 && digits != 6 && digits != 8) return
	if(digits == 4 || digits == 8) usealpha = 1
	for(i=start, digits>0, ++i)
		ch = text2ascii(rgb, i)
		if(ch >= 48 && ch <= 57) ch -= 48
		else if(ch >= 65 && ch <= 70) ch -= 55
		else if(ch >= 97 && ch <= 102) ch -= 87
		else break
		--digits
		switch(which)
			if(0)
				r = (r << 4) | ch
				if(single)
					r |= r << 4
					++which
				else if(!(digits & 1)) ++which
			if(1)
				g = (g << 4) | ch
				if(single)
					g |= g << 4
					++which
				else if(!(digits & 1)) ++which
			if(2)
				b = (b << 4) | ch
				if(single)
					b |= b << 4
					++which
				else if(!(digits & 1)) ++which
			if(3)
				alpha = (alpha << 4) | ch
				if(single) alpha |= alpha << 4

	. = list(r, g, b)
	if(usealpha) . += alpha

/proc/ReadHSV(hsv)
	if(!hsv) return

	// interpret the HSV or HSVA value
	var/i=1,start=1
	if(text2ascii(hsv) == 35) ++start // skip opening #
	var/ch,which=0,hue=0,sat=0,val=0,alpha=0,usealpha
	var/digits=0
	for(i=start, i<=length(hsv), ++i)
		ch = text2ascii(hsv, i)
		if(ch < 48 || (ch > 57 && ch < 65) || (ch > 70 && ch < 97) || ch > 102) break
		++digits
		if(digits == 9) break
	if(digits > 7) usealpha = 1
	if(digits <= 4) ++which
	if(digits <= 2) ++which
	for(i=start, digits>0, ++i)
		ch = text2ascii(hsv, i)
		if(ch >= 48 && ch <= 57) ch -= 48
		else if(ch >= 65 && ch <= 70) ch -= 55
		else if(ch >= 97 && ch <= 102) ch -= 87
		else break
		--digits
		switch(which)
			if(0)
				hue = (hue << 4) | ch
				if(digits == (usealpha ? 6 : 4)) ++which
			if(1)
				sat = (sat << 4) | ch
				if(digits == (usealpha ? 4 : 2)) ++which
			if(2)
				val = (val << 4) | ch
				if(digits == (usealpha ? 2 : 0)) ++which
			if(3)
				alpha = (alpha << 4) | ch

	. = list(hue, sat, val)
	if(usealpha) . += alpha

/proc/HSVtoRGB(hsv)
	if(!hsv) return "#000000"
	var/list/HSV = ReadHSV(hsv)
	if(!HSV) return "#000000"

	var/hue = HSV[1]
	var/sat = HSV[2]
	var/val = HSV[3]

	// Compress hue into easier-to-manage range
	hue -= hue >> 8
	if(hue >= 0x5fa) hue -= 0x5fa

	var/hi,mid,lo,r,g,b
	hi = val
	lo = round((255 - sat) * val / 255, 1)
	mid = lo + round(abs(round(hue, 510) - hue) * (hi - lo) / 255, 1)
	if(hue >= 765)
		if(hue >= 1275)      {r=hi;  g=lo;  b=mid}
		else if(hue >= 1020) {r=mid; g=lo;  b=hi }
		else                 {r=lo;  g=mid; b=hi }
	else
		if(hue >= 510)       {r=lo;  g=hi;  b=mid}
		else if(hue >= 255)  {r=mid; g=hi;  b=lo }
		else                 {r=hi;  g=mid; b=lo }

	return (HSV.len > 3) ? rgb(r,g,b,HSV[4]) : rgb(r,g,b)

/proc/RGBtoHSV(rgb)
	if(!rgb) return "#0000000"
	var/list/RGB = ReadRGB(rgb)
	if(!RGB) return "#0000000"

	var/r = RGB[1]
	var/g = RGB[2]
	var/b = RGB[3]
	var/hi = max(r,g,b)
	var/lo = min(r,g,b)

	var/val = hi
	var/sat = hi ? round((hi-lo) * 255 / hi, 1) : 0
	var/hue = 0

	if(sat)
		var/dir
		var/mid
		if(hi == r)
			if(lo == b) {hue=0; dir=1; mid=g}
			else {hue=1535; dir=-1; mid=b}
		else if(hi == g)
			if(lo == r) {hue=512; dir=1; mid=b}
			else {hue=511; dir=-1; mid=r}
		else if(hi == b)
			if(lo == g) {hue=1024; dir=1; mid=r}
			else {hue=1023; dir=-1; mid=g}
		hue += dir * round((mid-lo) * 255 / (hi-lo), 1)

	return hsv(hue, sat, val, (RGB.len>3 ? RGB[4] : null))

/proc/hsv(hue, sat, val, alpha)
	if(hue < 0 || hue >= 1536) hue %= 1536
	if(hue < 0) hue += 1536
	if((hue & 0xFF) == 0xFF)
		++hue
		if(hue >= 1536) hue = 0
	if(sat < 0) sat = 0
	if(sat > 255) sat = 255
	if(val < 0) val = 0
	if(val > 255) val = 255
	. = "#"
	. += TO_HEX_DIGIT(hue >> 8)
	. += TO_HEX_DIGIT(hue >> 4)
	. += TO_HEX_DIGIT(hue)
	. += TO_HEX_DIGIT(sat >> 4)
	. += TO_HEX_DIGIT(sat)
	. += TO_HEX_DIGIT(val >> 4)
	. += TO_HEX_DIGIT(val)
	if(!isnull(alpha))
		if(alpha < 0) alpha = 0
		if(alpha > 255) alpha = 255
		. += TO_HEX_DIGIT(alpha >> 4)
		. += TO_HEX_DIGIT(alpha)

/*
	Smooth blend between HSV colors

	amount=0 is the first color
	amount=1 is the second color
	amount=0.5 is directly between the two colors

	amount<0 or amount>1 are allowed
 */
/proc/BlendHSV(hsv1, hsv2, amount)
	return hsv_gradient(amount, 0, hsv1, 1, hsv2, "loop")

/*
	Smooth blend between RGB colors

	amount=0 is the first color
	amount=1 is the second color
	amount=0.5 is directly between the two colors

	amount<0 or amount>1 are allowed
 */
/proc/BlendRGB(rgb1, rgb2, amount)
	return rgb_gradient(amount, 0, rgb1, 1, rgb2, "loop")

/proc/HueToAngle(hue)
	// normalize hsv in case anything is screwy
	if(hue < 0 || hue >= 1536)
		hue %= 1536
	if(hue < 0)
		hue += 1536
	// Compress hue into easier-to-manage range
	hue -= hue >> 8
	return hue / (1530/360)

/proc/AngleToHue(angle)
	// normalize hsv in case anything is screwy
	if(angle < 0 || angle >= 360)
		angle -= 360 * round(angle / 360)
	var/hue = angle * (1530/360)
	// Decompress hue
	hue += round(hue / 255)
	return hue


// positive angle rotates forward through red->green->blue
/proc/RotateHue(hsv, angle)
	var/list/HSV = ReadHSV(hsv)

	// normalize hsv in case anything is screwy
	if(HSV[1] >= 1536) HSV[1] %= 1536
	if(HSV[1] < 0) HSV[1] += 1536

	// Compress hue into easier-to-manage range
	HSV[1] -= HSV[1] >> 8

	if(angle < 0 || angle >= 360) angle -= 360 * round(angle / 360)
	HSV[1] = round(HSV[1] + angle * (1530/360), 1)

	// normalize hue
	if(HSV[1] < 0 || HSV[1] >= 1530) HSV[1] %= 1530
	if(HSV[1] < 0) HSV[1] += 1530
	// decompress hue
	HSV[1] += round(HSV[1] / 255)

	return hsv(HSV[1], HSV[2], HSV[3], (HSV.len > 3 ? HSV[4] : null))

// Convert an rgb color to grayscale
/proc/GrayScale(rgb)
	var/list/RGB = ReadRGB(rgb)
	var/gray = RGB[1]*0.3 + RGB[2]*0.59 + RGB[3]*0.11
	return (RGB.len > 3) ? rgb(gray, gray, gray, RGB[4]) : rgb(gray, gray, gray)

// Change grayscale color to black->tone->white range
/proc/ColorTone(rgb, tone)
	var/list/RGB = ReadRGB(rgb)
	var/list/TONE = ReadRGB(tone)

	var/gray = RGB[1]*0.3 + RGB[2]*0.59 + RGB[3]*0.11
	var/tone_gray = TONE[1]*0.3 + TONE[2]*0.59 + TONE[3]*0.11

	if(gray <= tone_gray) return BlendRGB("#000000", tone, gray/(tone_gray || 1))
	else return BlendRGB(tone, "#ffffff", (gray-tone_gray)/((255-tone_gray) || 1))


/// Create a single [/icon] from a given [/atom] or [/image].
///
/// Very low-performance. Should usually only be used for HTML, where BYOND's
/// appearance system (overlays/underlays, etc.) is not available.
///
/// Only the first argument is required.
/proc/getFlatIcon(image/appearance, defdir, deficon, defstate, defblend, start = TRUE, no_anim = FALSE)
	// Loop through the underlays, then overlays, sorting them into the layers list
	#define PROCESS_OVERLAYS_OR_UNDERLAYS(flat, process, base_layer) \
		for (var/i in 1 to process.len) { \
			var/image/current = process[i]; \
			if (!current) { \
				continue; \
			} \
			if (current.plane != FLOAT_PLANE && current.plane != appearance.plane) { \
				continue; \
			} \
			var/current_layer = current.layer; \
			if (current_layer < 0) { \
				if (current_layer <= -1000) { \
					return flat; \
				} \
				current_layer = base_layer + appearance.layer + current_layer / 1000; \
			} \
			for (var/index_to_compare_to in 1 to layers.len) { \
				var/compare_to = layers[index_to_compare_to]; \
				if (current_layer < layers[compare_to]) { \
					layers.Insert(index_to_compare_to, current); \
					break; \
				} \
			} \
			layers[current] = current_layer; \
		}

	var/static/icon/flat_template = icon('icons/blanks/32x32.dmi', "nothing")

	if(!appearance || appearance.alpha <= 0)
		return icon(flat_template)

	if(start)
		if(!defdir)
			defdir = appearance.dir
		if(!deficon)
			deficon = appearance.icon
		if(!defstate)
			defstate = appearance.icon_state
		if(!defblend)
			defblend = appearance.blend_mode

	var/curicon = appearance.icon || deficon
	var/curstate = appearance.icon_state || defstate
	var/curdir = (!appearance.dir || appearance.dir == SOUTH) ? defdir : appearance.dir

	var/render_icon = curicon

	if (render_icon)
		var/curstates = icon_states(curicon)
		if(!(curstate in curstates))
			if ("" in curstates)
				curstate = ""
			else
				render_icon = FALSE

	// We'll use this to get the icon state to display if not null BUT NOT pass it to overlays as the dir we have
	var/base_icon_dir

	//Try to remove/optimize this section ASAP, CPU hog.
	//Determines if there's directionals.
	if(render_icon && curdir != SOUTH)
		if (
			!length(icon_states(icon(curicon, curstate, NORTH))) \
			&& !length(icon_states(icon(curicon, curstate, EAST))) \
			&& !length(icon_states(icon(curicon, curstate, WEST))) \
		)
			base_icon_dir = SOUTH

	if(!base_icon_dir)
		base_icon_dir = curdir

	var/curblend = appearance.blend_mode || defblend

	if(appearance.overlays.len || appearance.underlays.len)
		var/icon/flat = icon(flat_template)
		// Layers will be a sorted list of icons/overlays, based on the order in which they are displayed
		var/list/layers = list()
		var/image/copy
		// Add the atom's icon itself, without pixel_x/y offsets.
		if(render_icon)
			copy = image(icon=curicon, icon_state=curstate, layer=appearance.layer, dir=base_icon_dir)
			copy.color = appearance.color
			copy.alpha = appearance.alpha
			copy.blend_mode = curblend
			layers[copy] = appearance.layer

		PROCESS_OVERLAYS_OR_UNDERLAYS(flat, appearance.underlays, 0)
		PROCESS_OVERLAYS_OR_UNDERLAYS(flat, appearance.overlays, 1)

		// Icon of overlay being added
		var/icon/add

		var/flatX1 = 1
		var/flatX2 = flat.Width()
		var/flatY1 = 1
		var/flatY2 = flat.Height()

		var/addX1 = 0
		var/addX2 = 0
		var/addY1 = 0
		var/addY2 = 0

		for(var/image/layer_image as anything in layers)
			if(layer_image.alpha == 0)
				continue

			if(layer_image == copy) // 'layer_image' is an /image based on the object being flattened.
				curblend = BLEND_OVERLAY
				add = icon(layer_image.icon, layer_image.icon_state, base_icon_dir)
			else // 'I' is an appearance object.
				add = getFlatIcon(image(layer_image), curdir, curicon, curstate, curblend, FALSE, no_anim)
			if(!add)
				continue

			// Find the new dimensions of the flat icon to fit the added overlay
			addX1 = min(flatX1, layer_image.pixel_x + 1)
			addX2 = max(flatX2, layer_image.pixel_x + add.Width())
			addY1 = min(flatY1, layer_image.pixel_y + 1)
			addY2 = max(flatY2, layer_image.pixel_y + add.Height())

			if (
				addX1 != flatX1 \
				&& addX2 != flatX2 \
				&& addY1 != flatY1 \
				&& addY2 != flatY2 \
			)
				// Resize the flattened icon so the new icon fits
				flat.Crop(
					addX1 - flatX1 + 1,
					addY1 - flatY1 + 1,
					addX2 - flatX1 + 1,
					addY2 - flatY1 + 1
				)

				flatX1 = addX1
				flatX2 = addY1
				flatY1 = addX2
				flatY2 = addY2

			// Blend the overlay into the flattened icon
			flat.Blend(add, blendMode2iconMode(curblend), layer_image.pixel_x + 2 - flatX1, layer_image.pixel_y + 2 - flatY1)

		if(appearance.color)
			if(islist(appearance.color))
				flat.MapColors(arglist(appearance.color))
			else
				flat.Blend(appearance.color, ICON_MULTIPLY)

		if(appearance.alpha < 255)
			flat.Blend(rgb(255, 255, 255, appearance.alpha), ICON_MULTIPLY)

		if(no_anim)
			//Clean up repeated frames
			var/icon/cleaned = new /icon()
			cleaned.Insert(flat, "", SOUTH, 1, 0)
			return cleaned
		else
			return icon(flat, "", SOUTH)
	else if (render_icon) // There's no overlays.
		var/icon/final_icon = icon(icon(curicon, curstate, base_icon_dir), "", SOUTH, no_anim ? TRUE : null)

		if (appearance.alpha < 255)
			final_icon.Blend(rgb(255,255,255, appearance.alpha), ICON_MULTIPLY)

		if (appearance.color)
			if (islist(appearance.color))
				final_icon.MapColors(arglist(appearance.color))
			else
				final_icon.Blend(appearance.color, ICON_MULTIPLY)

		return final_icon

	#undef PROCESS_OVERLAYS_OR_UNDERLAYS

/proc/getIconMask(atom/atom_to_mask)//By yours truly. Creates a dynamic mask for a mob/whatever. /N
	var/icon/alpha_mask = new(atom_to_mask.icon, atom_to_mask.icon_state)//So we want the default icon and icon state of atom_to_mask.
	for(var/iterated_image in atom_to_mask.overlays)//For every image in overlays. var/image/image will not work, don't try it.
		var/image/image = iterated_image
		if(image.layer > atom_to_mask.layer)
			continue//If layer is greater than what we need, skip it.
		var/icon/image_overlay = new(image.icon, image.icon_state)//Blend only works with icon objects.
		//Also, icons cannot directly set icon_state. Slower than changing variables but whatever.
		alpha_mask.Blend(image_overlay, ICON_OR)//OR so they are lumped together in a nice overlay.
	return alpha_mask//And now return the mask.

/**
 * Helper proc to generate a cutout alpha mask out of an icon.
 *
 * Why is it a helper if it's so simple?
 *
 * Because BYOND's documentation is hot garbage and I don't trust anyone to actually
 * figure this out on their own without sinking countless hours into it. Yes, it's that
 * simple, now enjoy.
 *
 * But why not use filters?
 *
 * Filters do not allow for masks that are not the exact same on every dir. An example of a
 * need for that can be found in [/proc/generate_left_leg_mask()].
 *
 * Arguments:
 * * icon_to_mask - The icon file you want to generate an alpha mask out of.
 * * icon_state_to_mask - The specific icon_state you want to generate an alpha mask out of.
 *
 * Returns an `/icon` that is the alpha mask of the provided icon and icon_state.
 */
/proc/generate_icon_alpha_mask(icon_to_mask, icon_state_to_mask)
	var/icon/mask_icon = icon(icon_to_mask, icon_state_to_mask)
	// I hate the MapColors documentation, so I'll explain what happens here.
	// Basically, what we do here is that we invert the mask by using none of the original
	// colors, and then the fourth group of number arguments is actually the alpha values of
	// each of the original colors, which we multiply by 255 and subtract a value of 255 to the
	// result for the matching pixels, while starting with a base color of white everywhere.
	mask_icon.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 255,255,255,-255, 1,1,1,1)
	return mask_icon

/mob/proc/AddCamoOverlay(atom/A)//A is the atom which we are using as the overlay.
	var/icon/opacity_icon = new(A.icon, A.icon_state)//Don't really care for overlays/underlays.
	//Now we need to culculate overlays+underlays and add them together to form an image for a mask.
	var/icon/alpha_mask = getIconMask(src)//getFlatIcon(src) is accurate but SLOW. Not designed for running each tick. This is also a little slow since it's blending a bunch of icons together but good enough.
	opacity_icon.AddAlphaMask(alpha_mask)//Likely the main source of lag for this proc. Probably not designed to run each tick.
	opacity_icon.ChangeOpacity(0.4)//Front end for MapColors so it's fast. 0.5 means half opacity and looks the best in my opinion.
	for(var/i in 1 to 5)//And now we add it as overlays. It's faster than creating an icon and then merging it.
		var/image/camo_image = image("icon" = opacity_icon, "icon_state" = A.icon_state, "layer" = layer+0.8)//So it's above other stuff but below weapons and the like.
		switch(i)//Now to determine offset so the result is somewhat blurred.
			if(2)
				camo_image.pixel_x--
			if(3)
				camo_image.pixel_x++
			if(4)
				camo_image.pixel_y--
			if(5)
				camo_image.pixel_y++
		AddOverlays(camo_image)//And finally add the overlay.

/proc/build_disappear_icon(atom/A)
	var/icon/disappear_icon = new(getFlatIcon(A))
	var/W = disappear_icon.Width()
	var/H = disappear_icon.Height()
	var/icon/T = icon('icons/effects/effects.dmi',"disappear")
	if(W != world.icon_size || H != world.icon_size)
		T.Scale(W, H)
	T.BecomeAlphaMask()
	disappear_icon.MapColors(rgb(45,45,45), rgb(70,70,70), rgb(30,30,30), rgb(0,0,0))
	disappear_icon.AddAlphaMask(T)
	return disappear_icon

//For photo camera.
/proc/build_composite_icon(atom/A)
	var/icon/composite = icon(A.icon, A.icon_state, A.dir, 1)
	for(var/O in A.overlays)
		var/image/I = O
		composite.Blend(icon(I.icon, I.icon_state, I.dir, 1), ICON_OVERLAY)
	return composite

/proc/adjust_brightness(var/color, var/value)
	if (!color) return "#FFFFFF"
	if (!value) return color

	var/list/RGB = ReadRGB(color)
	RGB[1] = clamp(RGB[1]+value,0,255)
	RGB[2] = clamp(RGB[2]+value,0,255)
	RGB[3] = clamp(RGB[3]+value,0,255)
	return rgb(RGB[1],RGB[2],RGB[3])

/proc/sort_atoms_by_layer(var/list/atoms)
	// Comb sort icons based on levels
	var/list/result = atoms.Copy()
	var/gap = result.len
	var/swapped = 1
	while (gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = round(gap / 1.3) // 1.3 is the emperic comb sort coefficient
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= result.len; i++)
			var/atom/l = result[i]		//Fucking hate
			var/atom/r = result[gap+i]	//how lists work here
			if(l.layer > r.layer)		//no "result[i].layer" for me
				result.Swap(i, gap + i)
				swapped = 1
	return result

/*
generate_image function generates image of specified range and location
arguments tx, ty, tz are target coordinates (requred), range defines render distance to opposite corner (requred)
cap_mode is capturing mode (optional), user is capturing mob (requred only wehen cap_mode = CAPTURE_MODE_REGULAR),
lighting determines lighting capturing (optional), suppress_errors suppreses errors and continues to capture (optional).
*/
/proc/generate_image(var/tx as num, var/ty as num, var/tz as num, var/range as num, var/cap_mode = CAPTURE_MODE_PARTIAL, var/mob/living/user, var/lighting = 1, var/suppress_errors = 1)
	var/list/turfstocapture = list()
	//Lines below determine what tiles will be rendered
	for(var/xoff = 0 to range)
		for(var/yoff = 0 to range)
			var/turf/T = locate(tx + xoff,ty + yoff,tz)
			if(T)
				if(cap_mode == CAPTURE_MODE_REGULAR)
					if(user.can_capture_turf(T))
						turfstocapture.Add(T)
						continue
				else
					turfstocapture.Add(T)
			else
				//Capture includes non-existan turfs
				if(!suppress_errors)
					return

	return generate_image_from_turfs(locate(tx, ty, tz), turfstocapture, range, cap_mode, user, lighting)

/proc/generate_image_from_turfs(turf/topleft, list/turf/turfstocapture, range as num, cap_mode = CAPTURE_MODE_PARTIAL, mob/living/user, lighting = TRUE)
	var/tx = topleft.x
	var/ty = topleft.y
	//Lines below determine what objects will be rendered
	var/list/atoms = list()
	for(var/turf/T in turfstocapture)
		atoms += T
		for(var/atom/A in T)
			if(istype(A, /atom/movable/lighting_overlay)) //Special case for lighting
				continue

			if(A.invisibility)
				continue

			atoms += A

	//Lines below actually render all collected data
	atoms = sort_atoms_by_layer(atoms)
	var/icon/cap = icon('icons/effects/96x96.dmi', "")
	cap.Scale(range*32, range*32)
	cap.Blend("#000", ICON_OVERLAY)
	for(var/atom/A in atoms)
		if(A)
			var/icon/img = getFlatIcon(A)
			if(istype(img, /icon))
				if(istype(A, /mob/living))
					var/mob/living/L = A
					if(L.lying)
						img.BecomeLying()
				var/xoff = (A.x - tx) * 32
				var/yoff = (A.y - ty) * 32
				cap.Blend(img, blendMode2iconMode(A.blend_mode),  A.pixel_x + xoff, A.pixel_y + yoff)

	if (lighting)
		for (var/turf/T in turfstocapture)
			var/icon/im = new(LIGHTING_ICON, "blank")
			var/color = T.get_avg_color()	// We're going to lose some detail, but it's all we can do without color matrixes.
			if (color)
				im.Blend(color, ICON_MULTIPLY)
				cap.Blend(im, ICON_MULTIPLY, (T.x - tx) * 32, (T.y - ty) * 32)

	return cap

/proc/percentage_to_colour(var/P)
	//Takes a value between 0-1
	//Returns a colour - pure green if 1, pure red if 0
	//Inbetween values will gradiant through green, yellow, orange, red


	var/green = min(1, P*2)*255
	var/red = 255 - (min(1, (P-0.5)*2)*255)
	//var/green = (max(0, P-0.5)*2)*255
	//var/red = 255 - (min(1, P*2)*255)

	return rgb(red,green,0)

/// Gets a dummy savefile for usage in icon generation.
/// Savefiles generated from this proc will be empty.
/proc/get_dummy_savefile(from_failure = FALSE)
	var/static/next_id = 0
	if(next_id++ > 9)
		next_id = 0
	var/savefile_path = "tmp/dummy-save-[next_id].sav"
	try
		if(fexists(savefile_path))
			fdel(savefile_path)
		return new /savefile(savefile_path)
	catch(var/exception/error)
		// if we failed to create a dummy once, try again; maybe someone slept somewhere they shouldnt have
		if(from_failure) // this *is* the retry, something fucked up
			CRASH("get_dummy_savefile failed to create a dummy savefile: '[error]'")
		return get_dummy_savefile(from_failure = TRUE)

/**
 * Converts an icon to base64. Operates by putting the icon in the iconCache savefile,
 * exporting it as text, and then parsing the base64 from that.
 * (This relies on byond automatically storing icons in savefiles as base64)
 */
/proc/icon2base64(icon/icon)
	if (!isicon(icon))
		return FALSE
	var/savefile/dummySave = get_dummy_savefile()
	WRITE_FILE(dummySave["dummy"], icon)
	var/iconData = dummySave.ExportText("dummy")
	var/list/partial = splittext(iconData, "{")
	return replacetext(copytext_char(partial[2], 3, -5), "\n", "") //if cleanup fails we want to still return the correct base64

/// generates a filename for a given asset.
/// like generate_asset_name(), except returns the rsc reference and the rsc file hash as well as the asset name (sans extension)
/// used so that certain asset files dont have to be hashed twice
/proc/generate_and_hash_rsc_file(file, dmi_file_path)
	var/rsc_ref = fcopy_rsc(file)
	var/hash
	//if we have a valid dmi file path we can trust md5'ing the rsc file because we know it doesnt have the bug described in http://www.byond.com/forum/post/2611357
	if(dmi_file_path)
		hash = md5(rsc_ref)
	else //otherwise, we need to do the expensive fcopy() workaround
		hash = md5asfile(rsc_ref)

	return list(rsc_ref, hash, "asset.[hash]")

///given a text string, returns whether it is a valid dmi icons folder path
/proc/is_valid_dmi_file(icon_path)
	if(!istext(icon_path) || !length(icon_path))
		return FALSE

	var/is_in_icon_folder = findtextEx(icon_path, "icons/")
	var/is_dmi_file = findtextEx(icon_path, ".dmi")

	if(is_in_icon_folder && is_dmi_file)
		return TRUE
	return FALSE

/// given an icon object, dmi file path, or atom/image/mutable_appearance, attempts to find and return an associated dmi file path.
/// a weird quirk about dm is that /icon objects represent both compile-time or dynamic icons in the rsc,
/// but stringifying rsc references returns a dmi file path
/// ONLY if that icon represents a completely unchanged dmi file from when the game was compiled.
/// so if the given object is associated with an icon that was in the rsc when the game was compiled, this returns a path. otherwise it returns ""
/proc/get_icon_dmi_path(icon/icon)
	/// the dmi file path we attempt to return if the given object argument is associated with a stringifiable icon
	/// if successful, this looks like 'icons/path/to/dmi_file.dmi'
	var/icon_path = ""

	if(isatom(icon) || istype(icon, /image) || istype(icon, /mutable_appearance))
		var/atom/atom_icon = icon
		icon = atom_icon.icon
		//atom icons compiled in from 'icons/path/to/dmi_file.dmi' are weird and not really icon objects that you generate with icon().
		//if theyre unchanged dmi's then they're stringifiable to 'icons/path/to/dmi_file.dmi'

	if(isicon(icon) && isfile(icon))
		//icons compiled in from 'icons/path/to/dmi_file.dmi' at compile time are weird and arent really /icon objects,
		///but they pass both isicon() and isfile() checks. theyre the easiest case since stringifying them gives us the path we want
		var/icon_ref = text_ref(icon)
		var/locate_icon_string = "[locate(icon_ref)]"

		icon_path = locate_icon_string

	else if(isicon(icon) && "[icon]" == "/icon")
		// icon objects generated from icon() at runtime are icons, but they ARENT files themselves, they represent icon files.
		// if the files they represent are compile time dmi files in the rsc, then
		// the rsc reference returned by fcopy_rsc() will be stringifiable to 'icons/path/to/dmi_file.dmi'
		var/rsc_ref = fcopy_rsc(icon)

		var/icon_ref = text_ref(rsc_ref)

		var/icon_path_string = "[locate(icon_ref)]"

		icon_path = icon_path_string

	else if(istext(icon))
		var/rsc_ref = fcopy_rsc(icon)
		//if its the text path of an existing dmi file, the rsc reference returned by fcopy_rsc() will be stringifiable to a dmi path

		var/rsc_ref_ref = text_ref(rsc_ref)
		var/rsc_ref_string = "[locate(rsc_ref_ref)]"

		icon_path = rsc_ref_string

	if(is_valid_dmi_file(icon_path))
		return icon_path

	return FALSE


/**
 * generate an asset for the given icon or the icon of the given appearance for [thing], and send it to any clients in target.
 * Arguments:
 * * thing - either a /icon object, or an object that has an appearance (atom, image, mutable_appearance).
 * * target - either a reference to or a list of references to /client's or mobs with clients
 * * icon_state - string to force a particular icon_state for the icon to be used
 * * dir - dir number to force a particular direction for the icon to be used
 * * frame - what frame of the icon_state's animation for the icon being used
 * * moving - whether or not to use a moving state for the given icon
 * * sourceonly - if TRUE, only generate the asset and send back the asset url, instead of tags that display the icon to players
 * * extra_clases - string of extra css classes to use when returning the icon string
 */
/proc/icon2html(atom/thing, client/target, icon_state, dir = SOUTH, frame = 1, moving = FALSE, sourceonly = FALSE, extra_classes = null)
	if (!thing)
		return

	var/key
	var/icon/icon2collapse = thing

	if (!target)
		return
	if (target == world)
		target = GLOB.clients

	var/list/targets
	if (!islist(target))
		targets = list(target)
	else
		targets = target
	if(!length(targets))
		return

	//check if the given object is associated with a dmi file in the icons folder. if it is then we dont need to do a lot of work
	//for asset generation to get around byond limitations
	var/icon_path = get_icon_dmi_path(thing)

	if (!isicon(icon2collapse))
		if (isfile(thing)) //special snowflake
			var/name = sanitize_filename("[generate_asset_name(thing)].png")
			if (!SSassets.cache[name])
				SSassets.transport.register_asset(name, thing)
			for (var/thing2 in targets)
				SSassets.transport.send_assets(thing2, name)
			if(sourceonly)
				return SSassets.transport.get_asset_url(name)
			return "<img class='[extra_classes] icon icon-misc' src='[SSassets.transport.get_asset_url(name)]'>"

		//its either an atom, image, or mutable_appearance, we want its icon var
		icon2collapse = thing.icon

		if (isnull(icon_state))
			icon_state = thing.icon_state
			//Despite casting to atom, this code path supports mutable appearances, so let's be nice to them
			if(isnull(icon_state) || (isatom(thing) && thing.atom_flags & ATOM_FLAG_HTML_USE_INITIAL_ICON))
				icon_state = initial(thing.icon_state)
				if (isnull(dir))
					dir = initial(thing.dir)

		if (isnull(dir))
			dir = thing.dir

		if (ishuman(thing)) // Shitty workaround for a BYOND issue.
			var/icon/temp = icon2collapse
			icon2collapse = icon()
			icon2collapse.Insert(temp, dir = SOUTH)
			dir = SOUTH
	else
		if (isnull(dir))
			dir = SOUTH
		if (isnull(icon_state))
			icon_state = ""

	icon2collapse = icon(icon2collapse, icon_state, dir, frame, moving)

	// Pretend that tuples exist
	var/list/name_and_ref = generate_and_hash_rsc_file(icon2collapse, icon_path)

	// Weird object thats not even readable to the debugger, represents a reference to the icons rsc entry
	var/rsc_ref = name_and_ref[1]
	var/file_hash = name_and_ref[2]
	key = "[name_and_ref[3]].png"

	if(!SSassets.cache[key])
		SSassets.transport.register_asset(key, rsc_ref, file_hash, icon_path)
	for (var/client_target in targets)
		SSassets.transport.send_assets(client_target, key)
	if(sourceonly)
		return SSassets.transport.get_asset_url(key)
	return "<img class='[extra_classes] icon icon-[icon_state]' src='[SSassets.transport.get_asset_url(key)]'>"

/proc/icon2base64html(thing)
	if (!thing)
		return
	var/static/list/bicon_cache = list()
	if (isicon(thing))
		var/icon/I = thing
		var/icon_base64 = icon2base64(I)

		if (I.Height() > world.icon_size || I.Width() > world.icon_size)
			var/icon_md5 = md5(icon_base64)
			icon_base64 = bicon_cache[icon_md5]
			if (!icon_base64) // Doesn't exist yet, make it.
				bicon_cache[icon_md5] = icon_base64 = icon2base64(I)


		return "<img class='icon icon-misc' src='data:image/png;base64,[icon_base64]'>"

	// Either an atom or somebody fucked up and is gonna get a runtime, which I'm fine with.
	var/atom/A = thing
	var/key = "[istype(A.icon, /icon) ? "[REF(A.icon)]" : A.icon]:[A.icon_state]"


	if (!bicon_cache[key]) // Doesn't exist, make it.
		var/icon/I = icon(A.icon, A.icon_state, SOUTH, 1)
		if (ishuman(thing)) // Shitty workaround for a BYOND issue.
			var/icon/temp = I
			I = icon()
			I.Insert(temp, dir = SOUTH)

		bicon_cache[key] = icon2base64(I)

	return "<img class='icon icon-[A.icon_state]' src='data:image/png;base64,[bicon_cache[key]]'>"

//Costlier version of icon2html() that uses getFlatIcon() to account for overlays, underlays, etc. Use with extreme moderation, ESPECIALLY on mobs.
/proc/costly_icon2html(thing, target, sourceonly = FALSE)
	if (!thing)
		return

	if (isicon(thing))
		return icon2html(thing, target)

	var/icon/I = getFlatIcon(thing)
	return icon2html(I, target, sourceonly = sourceonly)

/**
 * Center's an image.
 * Requires:
 * The Image
 * The x dimension of the icon file used in the image
 * The y dimension of the icon file used in the image
 * eg: center_image(image_to_center, 32,32)
 * eg2: center_image(image_to_center, 96,96)
**/
/proc/center_image(image/image_to_center, x_dimension = 0, y_dimension = 0)
	if(!image_to_center)
		return

	if(!x_dimension || !y_dimension)
		return

	if((x_dimension == world.icon_size) && (y_dimension == world.icon_size))
		return image_to_center

	//Offset the image so that it's bottom left corner is shifted this many pixels
	//This makes it infinitely easier to draw larger inhands/images larger than world.iconsize
	//but still use them in game
	var/x_offset = -((x_dimension / world.icon_size) - 1) * (world.icon_size * 0.5)
	var/y_offset = -((y_dimension / world.icon_size) - 1) * (world.icon_size * 0.5)

	//Correct values under world.icon_size
	if(x_dimension < world.icon_size)
		x_offset *= -1
	if(y_dimension < world.icon_size)
		y_offset *= -1

	image_to_center.pixel_x = x_offset
	image_to_center.pixel_y = y_offset

	return image_to_center

///Flickers an overlay on an atom
/atom/proc/flick_overlay_static(overlay_image, duration)
	set waitfor = FALSE
	if(!overlay_image)
		return
	AddOverlays(overlay_image)
	sleep(duration)
	CutOverlays(overlay_image)

/**
 * Perform a shake on an atom, resets its position afterwards
 *
 * * pixelshiftx - x-axis pixel shift, default 2
 * * pixelshifty - y-axis pixel shift, default 2
 * * duration - how long to shake, default 2.5s
 * * shake_interval = time between shakes, default 0.02 SECONDS
 */
/atom/proc/Shake(pixelshiftx = 2, pixelshifty = 2, duration = 2.5 SECONDS, shake_interval = 0.02 SECONDS)
	var/initialpixelx = pixel_x
	var/initialpixely = pixel_y
	animate(src, pixel_x = initialpixelx + rand(-pixelshiftx,pixelshiftx), pixel_y = initialpixelx + rand(-pixelshifty,pixelshifty), time = shake_interval, flags = ANIMATION_PARALLEL)
	// Start at 3 because we already applied one, and need another to reset.
	for (var/i in 3 to ((duration / shake_interval)))
		animate(pixel_x = initialpixelx + rand(-pixelshiftx,pixelshiftx), pixel_y = initialpixely + rand(-pixelshifty,pixelshifty), time = shake_interval)
	animate(pixel_x = initialpixelx, pixel_y = initialpixely, time = shake_interval)

/**
 * Checks if the given iconstate exists in the given file, caching the result.
 *
 * * file - icon .dmi file
 * * state - which state within the .dmi
 * * scream - if TRUE, will print a stack trace ONCE
 */
/proc/icon_exists(file, state, scream)
	var/static/list/icon_states_cache = list()
	if(icon_states_cache[file]?[state])
		return TRUE

	if(icon_states_cache[file]?[state] == FALSE)
		return FALSE

	var/list/states = icon_states(file)

	if(!icon_states_cache[file])
		icon_states_cache[file] = list()

	if(state in states)
		icon_states_cache[file][state] = TRUE
		return TRUE
	else
		icon_states_cache[file][state] = FALSE
		if(scream)
			stack_trace("Icon Lookup for state: [state] in file [file] failed.")
		return FALSE

/**
 * Returns the size of the sprite in tiles.
 * Takes the icon size and divides it by the world icon size (default 32).
 * This gives the size of the sprite in tiles.
 *
 * @return size of the sprite in tiles
 */
/proc/get_size_in_tiles(obj/target)
	var/icon/size_check = icon(target.icon, target.icon_state)
	var/size = size_check.Width() / world.icon_size

	return size

/**
 * Updates the bounds of a rotated object
 * This ensures that the bounds are always correct,
 * even if the object is rotated after init.
 */
/obj/proc/set_bounds()
	var/size = get_size_in_tiles(src)

	if(dir in list(NORTH, SOUTH))
		bound_width = size * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = size * world.icon_size

/// Cache of the width and height of icon files, to avoid repeating the same expensive operation
GLOBAL_LIST_EMPTY(icon_dimensions)

/**
 * Returns a list containing the width and height of an icon file
 */
/proc/get_icon_dimensions(icon_path)
	// Icons can be a real file(), a rsc backed file(), a dynamic rsc (dyn.rsc) reference (known as a cache reference in byond docs), or an /icon which is pointing to one of those.
	// Runtime generated dynamic icons are an unbounded concept cache identity wise, the same icon can exist millions of ways and holding them in a list as a key can lead to unbounded memory usage if called often by consumers.
	// Check distinctly that this is something that has this unspecified concept, and thus that we should not cache.
	if (!isfile(icon_path) || !length("[icon_path]"))
		var/icon/my_icon = icon(icon_path)
		return list("width" = my_icon.Width(), "height" = my_icon.Height())
	if (isnull(GLOB.icon_dimensions[icon_path]))
		var/icon/my_icon = icon(icon_path)
		GLOB.icon_dimensions[icon_path] = list("width" = my_icon.Width(), "height" = my_icon.Height())
	return GLOB.icon_dimensions[icon_path]
