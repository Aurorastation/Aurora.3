/obj/item/clothing/under/unathi
	name = "sinta tunic"
	desc = "A tunic common on both Moghes and Ouerea. It's simple and easily-manufactured design makes it \
	universally favorable."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "tunic"
	item_state = "tunic"
	contained_sprite = TRUE

	rolled_down = FALSE
	rolled_sleeves = FALSE

/obj/item/clothing/under/unathi/jizixi
	name = "jizixi dress"
	desc = "A striking, modern dress typically worn by Moghean women of high birth."
	icon_state = "jizixi"
	item_state = "jizixi"

/obj/item/clothing/under/unathi/sashes
	name = "gy'zao sashes"
	gender = PLURAL
	desc = "An androgynous set of sashes worn by Unathi when they want to bask under the sun. Not appropriate \
	to wear outside of that."
	icon_state = "gyzao"
	item_state = "gyzao"

/obj/item/clothing/under/unathi/mogazali
	name = "mogazali attire"
	desc = "A traditional Moghean uniform worn by men of high status, whether merchants, priests, or nobility."
	icon_state = "mogazali"
	item_state = "mogazali"

/obj/item/clothing/under/unathi/zazali
	name = "zazali garb"
	desc = "An old fashioned, extremely striking garb for a Unathi man with pointy shoulders. It's typically \
	worn by those in the warrior caste or those with something to prove."
	icon_state = "zazali"
	item_state = "zazali"
	build_from_parts = TRUE
	worn_overlay = "top", "belt"
	var/additional_color = COLOR_GRAY // The default color.

/obj/item/clothing/under/unathi/zazali/worn_overlays(icon_file, contained_flag)
	. = ..()
	if(contained_flag == WORN_UNDER)
		var/image/top = image(icon_file, null, "zazali_un_top")
		top.appearance_flags = RESET_COLOR
		top.color = additional_color
		. += top
		var/image/belt = image(icon_file, null, "zazali_un_belt")
		belt.appearance_flags = RESET_COLOR
		. += belt

/obj/item/clothing/under/unathi/huytai
	name = "huytai outfit"
	desc = "Typically worn by Unathi women who engage in a trade. Popular with fisherwomen especially!"
	icon_state = "huytai"
	item_state = "huytai"

/obj/item/clothing/under/unathi/zozo
	name = "zo'zo top"
	desc = "A modern blend of Ouerean and Moghean style for anyone on the go. Great for sunbathing!"
	icon_state = "zozo"
	item_state = "zozo"

/obj/item/clothing/suit/unathi/mantle/wrapping
	name = "Th'akhist body wrappings"
	desc = "A bunch of stitched together clothing with bandages covering them. Looks tailored for a Unathi."
	desc_fluff = "This is considered humble Sinta wear for Th'akh shamans— most Unathi don't wear these, barring Aut'akh."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "thakh_wrappings" //special thanks to Araskael
	item_state = "thakh_wrappings"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT|HIDETAIL
	species_restricted = list(BODYTYPE_UNATHI)
	contained_sprite = TRUE

/obj/item/clothing/mask/gas/wrapping
	name = "Th'akhist head wrappings"
	desc = "A bunch of stitched together bandages on a fibreglass breath mask that also contains openings for the \
	eyes. Looks tailored for a Unathi."
	desc_fluff = "This is considered humble Sinta wear for Th'akh shamans— most Unathi don't wear these, barring Aut'akh."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "thakh_mask" //special thanks to Araskael
	item_state = "thakh_mask"
	species_restricted = list(BODYTYPE_UNATHI)
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/unathimantle
	name = "desert hide mantle"
	desc = "The cured hide and skin of a large beast, tapered off with a colorful collar. This one is a popular \
	trophy among Wastelanders: someone's been hunting!"
	desc_fluff = "With the expansion of the Touched Lands, the normal beasts that prowl and stalk the dunes have \
	proliferated at unprecedented rates. Those stranded outside of the greenery of the Izweski take up arms to cull \
	the herdes of klazd, and their skins make valuable mantles to protect wearers from the sun."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "mantle-unathi"
	item_state = "mantle-unathi"
	icon_override = null
	contained_sprite = TRUE
	build_from_parts = TRUE
	worn_overlay = "desert"

/obj/item/clothing/accessory/poncho/unathimantle/forest
	name = "forest hide mantle"
	desc = "The cured hide and skin of a large beast, tapered off with a colorful collar. These are seen exclusively \
	by warriors, nobles, and those with credits to spare."
	desc_fluff = "After the Contact War, the prized horns of the tul quickly vanished from the market. Nobles and \
	wealthy guildsmen were swift to monopolize and purchase all the remaining cloaks; a peasant seen with one of \
	these is likely enough a death sentence."
	worn_overlay = "forest"

/obj/item/clothing/accessory/poncho/unathimantle/mountain
	name = "mountain hide mantle"
	desc = "The cured hide and skin of a large beast, tapered off with a colorful collar. Mountainous arbek, massive \
	snakes longer than a bus, have a long enough hide for multiple mantles."
	desc_fluff = "Hunting an arbek is no easy task. Brave Zo'saa looking to prove themselves in battle and be \
	promoted to Saa rarely understand the gravity of these trials. Serpents large enough to swallow Unathi whole, \
	they can live up to half a millenia— should enough foolish adventurers try to slay it, that is."
	worn_overlay = "mountain"

/obj/item/clothing/accessory/poncho/rockstone
	name = "rockstone cape"
	desc = "A cape seen exclusively on nobility. The chain is adorned with precious, multi-color stones, hence its name."
	desc_fluff = "A simple drape over the shoulder is done easily; the distinguishing part between the commoners and \
	nobility is the sheer elegance of the rockstone cape. Vibrant stones adorn the heavy collar, and the cape itself \
	is embroidered with gold."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "rockstone"
	item_state = "rockstone"
	icon_override = null
	contained_sprite = TRUE
	var/additional_color = COLOR_GRAY

/obj/item/clothing/accessory/poncho/rockstone/worn_overlays(icon_file, contained_flag)
	. = ..()
	if(contained_flag == WORN_UNDER || WORN_SUIT)
		var/image/gem = image(icon_file, null, "rockstone_un_gem")
		gem.appearance_flags = RESET_COLOR
		gem.color = additional_color
		. += gem
		var/image/chain = image(icon_file, null, "rockstone_un_chain")
		chain.appearance_flags = RESET_COLOR
		. += chain

/obj/item/clothing/accessory/poncho/maxtlatl
	name = "Th'akhist maxtlatl"
	desc = "A traditional garment worn by Th'akh shamans. Popular adornments include dried and pressed grass and \
	flowers, in addition to colorful stones placed into and hanging off of the mantle."
	desc_fluff = "The term \" maxtlatl\" was given by humanity upon seeing this due to its resemblance to ancient \
	human cultures. However, it is more appropriately called a zlukti, or 'spirit garb'. Each adornment, whether \
	feathers, stones, or metals, is made by another shaman who has passed away: the more colorful the attire, the \
	older it is."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "maxtlatl"
	item_state = "maxtlatl"
	icon_override = null
	contained_sprite = TRUE

/obj/item/clothing/wrists/maxtlatl
	name = "Th'akhist wristguards"
	desc = "A traditional garment worn by Th'akh shamans. Popular adornments include dried and pressed grass and \
	feathers, as well as precious metals and colorful stones in the cuff itself."
	desc_fluff = "Wristguards as a part of the maxtatl did not become prevalent until much later in Th'akh \
	tradition. As time passed and garb was passed down from shaman to shaman, attire became cluttered with \
	adornments. Bracers were designed as a method of adding more charms to remember previous shamans that \
	predate the latest to pass away."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "maxtlatl-wrists"
	item_state = "maxtlatl-wrists"
	gender = PLURAL
	contained_sprite = TRUE

/obj/item/clothing/head/maxtlatl
	name = "Th'akhist headgear"
	desc = "A traditional garment worn by Th'akh shamans. Popular adornments include dried and pressed grass; \
	alternatively, colorful feathers from talented hunters are sometimes used."
	desc_fluff = "The headgear of the Th'akhist ensemble has a special component to it. Besides the emulated \
	frills made with straw or feathers, the authentic Unathite skull is from the bones of the previous owner, the \
	deceased shaman that came before. Other cultures see it as barbaric; Unathi believe that this enables shamans \
	to call upon their predecessors' wisdom as spirits to empower them."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "maxtlatl-head"
	item_state = "maxtlatl-head"
	contained_sprite = TRUE

/obj/item/clothing/head/maxtlatl/worn_overlays(icon_file, slot)
	. = ..()
	if(slot == slot_head)
		var/mutable_appearance/M = mutable_appearance(icon_file, "maxtlatl-head_translate")
		M.appearance_flags = RESET_COLOR|RESET_ALPHA
		M.pixel_y = 12
		. += M

/obj/item/clothing/under/unathi/himation
	name = "himation cloak"
	desc = "The himation is a staple of Unathi fashion. Whether a commoner in practical clothes to a noble looking \
	for leisure wear, the himation has remained stylish for centuries."
	desc_fluff = "The himation while unwrapped is usually a three meter around cloth. Unathi start by putting the \
	front around their waist, bring it over their right shoulder, and then form a sash-like loop by bringing it over \
	their right again. A belt ties it off and drapes a skirt down over their thighs to complete the look. Fashionable \
	for simple noble wear (the cloth can be embroidered), and practical for labor!"
	icon_state = "himation"
	item_state = "himation"
	build_from_parts = TRUE
	worn_overlay = "skirt", "belt2"
	var/additional_color = COLOR_GRAY

/obj/item/clothing/under/unathi/himation/worn_overlays(icon_file, contained_flag)
	. = ..()
	if(contained_flag == WORN_UNDER)
		var/image/skirt = image(icon_file, null, "himation_un_skirt")
		skirt.appearance_flags = RESET_COLOR
		skirt.color = additional_color
		. += skirt
		var/image/belt2 = image(icon_file, null, "himation_un_belt2")
		belt2.appearance_flags = RESET_COLOR
		. += belt2

/obj/item/clothing/wrists/jeweled
	name = "jeweled bracers"
	desc = "Pain."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "noble-bracers"
	item_state = "noble-bracers"
	gender = PLURAL
	contained_sprite = TRUE
	build_from_parts = TRUE
	worn_overlay = "trim2"

/obj/item/clothing/accessory/gyazo
	name = "gyazo belt"
	desc = "A simple belt fashioned from cloth, the gyazo belt is an adornment that can be paired with practically \
	any Unathi outfit. Fashionable and comes in a variety of colors!"
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "sash"
	item_state = "sash"
	contained_sprite = TRUE