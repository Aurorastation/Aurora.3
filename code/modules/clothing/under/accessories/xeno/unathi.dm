/obj/item/clothing/accessory/sinta_hood
	name = "clan hood"
	desc = "A hood worn commonly by unathi away from home. No better way of both representing your clan to \
	foreigners and keeping the sun out of your eyes in style!"
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "sinta_hood"
	item_state = "sinta_hood_up"
	slot_flags = SLOT_TIE|SLOT_HEAD|SLOT_EARS
	flags_inv = BLOCKHAIR|BLOCKHEADHAIR
	contained_sprite = TRUE
	action_button_name = "Adjust Hood"
	var/up = TRUE

/obj/item/clothing/accessory/sinta_hood/get_ear_examine_text(var/mob/user, var/ear_text = "left")
	return "on [user.get_pronoun("his")] head"

/obj/item/clothing/accessory/sinta_hood/attack_self()
	toggle()

/obj/item/clothing/accessory/sinta_hood/verb/toggle()
	set category = "Object"
	set name = "Adjust Hood"
	set src in usr

	if(use_check_and_message(usr))
		return
	up = !up
	if(up)
		flags_inv = BLOCKHAIR|BLOCKHEADHAIR
		body_parts_covered = HEAD
		item_state = "sinta_hood_up"
		to_chat(usr, SPAN_NOTICE("You flip \the [src] up."))
	else
		flags_inv = 0
		body_parts_covered = 0
		item_state = "sinta_hood"
		to_chat(usr, SPAN_NOTICE("You flip \the [src] down."))
	update_worn_icon()
	update_clothing_icon()
	update_icon()
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.update_hair()

/obj/item/clothing/accessory/unathi
	name = "gyazo belt"
	desc = "A simple belt fashioned from cloth, the gyazo belt is an adornment that can be paired with practically \
	any Unathite outfit and is a staple for any Sinta. Fashionable and comes in a variety of colors!"
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "sash"
	item_state = "sash"
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/maxtlatl
	name = "Th'akhist maxtlatl"
	desc = "A traditional garment worn by Th'akh shamans. Popular adornments include dried and pressed grass and \
	flowers, in addition to colorful stones placed into and hanging off of the mantle."
	desc_extended = "The term \" maxtlatl\" was given by humanity upon seeing this due to its resemblance to ancient \
	human cultures. However, it is more appropriately called a zlukti, or 'spirit garb'. Each adornment, whether \
	feathers, stones, or metals, is made by another shaman who has passed away: the more colorful the attire, the \
	older it is."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "maxtlatl"
	item_state = "maxtlatl"
	icon_override = null
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/unathimantle
	name = "desert hide mantle"
	desc = "The cured hide and skin of a large beast, tapered off with a colorful collar. This one is a popular \
	trophy among Wastelanders: someone's been hunting!"
	desc_extended = "With the expansion of the Touched Lands, the normal beasts that prowl and stalk the dunes have \
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
	desc_extended = "After the Contact War, the prized horns of the tul quickly vanished from the market. Nobles and \
	wealthy guildsmen were swift to monopolize and purchase all the remaining cloaks; a peasant seen with one of \
	these is likely enough a death sentence."
	worn_overlay = "forest"

/obj/item/clothing/accessory/poncho/unathimantle/mountain
	name = "mountain hide mantle"
	desc = "The cured hide and skin of a large beast, tapered off with a colorful collar. Mountainous arbek, massive \
	snakes longer than a bus, have a long enough hide for multiple mantles."
	desc_extended = "Hunting an arbek is no easy task. Brave Zo'saa looking to prove themselves in battle and be \
	promoted to Saa rarely understand the gravity of these trials. Serpents large enough to swallow Unathi whole, \
	they can live up to half a millenia- should enough foolish adventurers try to slay it, that is."
	worn_overlay = "mountain"

/obj/item/clothing/accessory/poncho/rockstone
	name = "rockstone cape"
	desc = "A cape seen exclusively on nobility. The chain is adorned with precious, multi-color stones, hence its name."
	desc_extended = "A simple drape over the shoulder is done easily; the distinguishing part between the commoners and \
	nobility is the sheer elegance of the rockstone cape. Vibrant stones adorn the heavy collar, and the cape itself \
	is embroidered with gold."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "rockstone"
	item_state = "rockstone"
	icon_override = null
	contained_sprite = TRUE
	var/additional_color = COLOR_GRAY

/obj/item/clothing/accessory/poncho/rockstone/update_icon()
	cut_overlays()
	var/image/gem = image(icon, null, "rockstone_gem")
	gem.appearance_flags = RESET_COLOR
	gem.color = additional_color
	add_overlay(gem)
	var/image/chain = image(icon, null, "rockstone_chain")
	chain.appearance_flags = RESET_COLOR
	add_overlay(chain)

/obj/item/clothing/accessory/poncho/rockstone/get_mob_overlay(var/mob/living/carbon/human/H, var/mob_icon, var/mob_state, var/slot)
	var/image/I = ..()
	if(slot == slot_wear_suit_str)
		var/image/gem = image(mob_icon, null, "rockstone_un_gem")
		gem.appearance_flags = RESET_COLOR
		gem.color = additional_color
		I.add_overlay(gem)
		var/image/chain = image(mob_icon, null, "rockstone_un_chain")
		chain.appearance_flags = RESET_COLOR
		I.add_overlay(chain)
	return I

/obj/item/clothing/accessory/poncho/rockstone/get_accessory_mob_overlay(mob/living/carbon/human/H, force)
	var/image/base = ..()
	var/image/gem = image(icon, null, "rockstone_un_gem")
	gem.appearance_flags = RESET_COLOR
	gem.color = additional_color
	base.add_overlay(gem)
	var/image/chain = image(icon, null, "rockstone_un_chain")
	chain.appearance_flags = RESET_COLOR
	base.add_overlay(chain)
	return base
