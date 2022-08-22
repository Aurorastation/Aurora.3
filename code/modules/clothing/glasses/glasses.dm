///////////////////////////////////////////////////////////////////////
//Glasses
/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
          // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/
/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/clothing/lefthand_glasses.dmi',
		slot_r_hand_str = 'icons/mob/items/clothing/righthand_glasses.dmi'
		)
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_EYES
	body_parts_covered = EYES
	var/vision_flags = 0
	var/darkness_view = 0//Base human is 2
	var/prescription = 0
	var/see_invisible = -1
	var/toggleable = 0
	var/toggle_changes_appearance = TRUE
	var/off_state = "degoggles"
	var/active = 1
	var/activation_sound = 'sound/items/goggles_charge.ogg'
	var/obj/screen/overlay = null
	var/obj/item/clothing/glasses/hud/hud = null	// Hud glasses, if any
	var/activated_color = null
	var/normal_layer = TRUE
	var/shatter_material = /obj/item/material/shard
	sprite_sheets = list(
		BODYTYPE_VAURCA_WARFORM = 'icons/mob/species/warriorform/eyes.dmi'
		)
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER)
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

// Called in mob/RangedAttack() and mob/UnarmedAttack.
/obj/item/clothing/glasses/proc/Look(var/atom/A, mob/user, var/proximity)
	return 0 // return 1 to cancel attack_hand/RangedAttack()

/obj/item/clothing/glasses/verb/change_layer()
	set category = "Object"
	set name = "Change Glasses Layer"
	set src in usr

	normal_layer = !normal_layer
	to_chat(usr, SPAN_NOTICE("\The [src] will now layer [normal_layer ? "under" : "over"] your hair."))
	update_clothing_icon()

/obj/item/clothing/glasses/protects_eyestab(var/obj/stab_item, var/stabbed = FALSE)
	if(stabbed && (body_parts_covered & EYES) && !(item_flags & THICKMATERIAL) && shatter_material && prob(stab_item.force * 5))
		var/mob/M = loc
		M.visible_message(SPAN_WARNING("\The [src] [M] is wearing gets shattered!"))
		playsound(loc, /decl/sound_category/glass_break_sound, 70, TRUE)
		new shatter_material(M.loc)
		qdel(src)
		return FALSE
	return ..()

/obj/item/clothing/glasses/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_glasses()

/obj/item/clothing/glasses/attack_self(mob/user)
	if(toggleable)
		if(active)
			active = 0
			if(toggle_changes_appearance)
				icon_state = off_state
				item_state = off_state
				user.update_inv_glasses()
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			to_chat(usr, "You deactivate the optical matrix on the [src].")
			if(activated_color)
				set_light(0)
		else
			active = 1
			if(toggle_changes_appearance)
				icon_state = initial(icon_state)
				item_state = initial(icon_state)
				user.update_inv_glasses()
			if(activation_sound)
				sound_to(usr, activation_sound)
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			to_chat(usr, "You activate the optical matrix on the [src].")
			if(activated_color)
				set_light(2, 0.4, activated_color)
	user.update_action_buttons()
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

/obj/item/clothing/glasses/proc/is_sec_hud()
	return FALSE

/obj/item/clothing/glasses/proc/is_med_hud()
	return FALSE


/obj/item/clothing/glasses/meson
	name = "optical meson scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state = "meson"
	action_button_name = "Toggle Goggles"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	toggleable = 1
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	item_flags = AIRTIGHT
	activated_color = LIGHT_COLOR_GREEN

/obj/item/clothing/glasses/meson/Initialize()
	. = ..()
	overlay = global_hud.meson

/obj/item/clothing/glasses/meson/prescription
	name = "prescription mesons"
	desc = "Optical Meson Scanner with prescription lenses."
	prescription = 7

/obj/item/clothing/glasses/meson/aviator
	name = "engineering aviators"
	desc = "Modified aviator glasses with a toggled meson interface. Comes with bonus prescription overlay."
	icon_state = "aviator_eng"
	off_state = "aviator_eng_off"
	action_button_name = "Toggle HUD"
	activation_sound = 'sound/effects/pop.ogg'
	prescription = 7

/obj/item/clothing/glasses/meson/aviator/verb/toggle()
	set category = "Object"
	set name = "Toggle Aviators"
	set src in usr

	attack_self(usr)

/obj/item/clothing/glasses/hud/health/aviator
	name = "medical HUD aviators"
	desc = "Modified aviator glasses with a toggled health HUD. Comes with bonus prescription overlay."
	icon_state = "aviator_med"
	off_state = "aviator_med_off"
	action_button_name = "Toggle Mode"
	toggleable = 1
	activation_sound = 'sound/effects/pop.ogg'
	prescription = 7

/obj/item/clothing/glasses/hud/health/aviator/verb/toggle()
	set category = "Object"
	set name = "Toggle Aviators"
	set src in usr

	attack_self(usr)

/obj/item/clothing/glasses/hud/health/aviator/visor
	name = "medical HUD visor"
	desc = "Modified visor glasses with a toggled health HUD. Comes with bonus prescription overlay."
	icon_state = "visor_medhud"
	off_state = "visor_medhud_off"

/obj/item/clothing/glasses/science
	name = "science goggles"
	desc = "Used to protect your eyes against harmful chemicals!"
	icon_state = "purple"
	item_state = "purple"
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/eyes.dmi'
	)
	toggleable = 1
	unacidable = 1
	item_flags = AIRTIGHT

/obj/item/clothing/glasses/science/Initialize()
	. = ..()
	overlay = global_hud.science

/obj/item/clothing/glasses/night
	name = "night vision goggles"
	desc = "You can totally see in the dark now!"
	icon_state = "night"
	item_state = "glasses"
	action_button_name = "Toggle Goggles"
	origin_tech = list(TECH_MAGNET = 2)
	darkness_view = 7
	toggleable = 1
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	off_state = "denight"

/obj/item/clothing/glasses/night/Initialize()
	. = ..()
	overlay = global_hud.nvg

/obj/item/clothing/glasses/night/aviator
	name = "aviators"
	desc = "Modified aviator glasses with a toggled night vision interface. Comes with prescription overlay."
	icon_state = "aviator_nv"
	off_state = "aviator_off"
	action_button_name = "Toggle Mode"
	toggleable = 1
	activation_sound = 'sound/effects/pop.ogg'
	prescription = 7

/obj/item/clothing/glasses/night/aviator/verb/toggle()
	set category = "Object"
	set name = "Toggle Aviators"
	set src in usr

	attack_self(usr)

/obj/item/clothing/glasses/safety
	name = "safety glasses"
	desc = "A simple pair of safety glasses. Thinner than their goggle counterparts, for those who can't decide between safety and style."
	icon_state = "plaingoggles"
	item_state = "plaingoggles"
	item_flags = AIRTIGHT|THICKMATERIAL
	unacidable = 1

/obj/item/clothing/glasses/safety/goggles
	name = "safety goggles"
	desc = "A simple pair of safety goggles. It's general chemistry all over again."
	icon_state = "goggles_standard"
	item_state = "goggles_standard"
	off_state = "goggles_standard"
	action_button_name = "Flip Goggles"
	var/flip_down = "down to protect your eyes."
	var/flip_up = "up out of your face."
	var/up = 0

/obj/item/clothing/glasses/safety/goggles/attack_self()
	toggle()

/obj/item/clothing/glasses/safety/goggles/verb/toggle()
	set category = "Object"
	set name = "Adjust goggles"
	set src in usr

	if(use_check_and_message(usr))
		return
	if(src.up)
		src.up = !src.up
		flags_inv |= HIDEEYES
		body_parts_covered |= EYES
		icon_state = initial(item_state)
		to_chat(usr, SPAN_NOTICE("You flip \the [src] [flip_down]"))
	else
		src.up = !src.up
		flags_inv &= ~HIDEEYES
		body_parts_covered &= ~EYES
		icon_state = "[initial(icon_state)]_up"
		to_chat(usr, SPAN_NOTICE("You push \the [src] [flip_up]"))
	update_clothing_icon()
	update_icon()
	usr.update_action_buttons()

/obj/item/clothing/glasses/safety/goggles/wasteland
	name = "wasteland goggles"
	desc = "A pair of old goggles common in the Wasteland. A few denizens unfortunate enough to not \
	keep this protection on them after the nukes dropped no longer have the ability to see."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "wasteland_goggles"
	item_state = "wasteland_goggles"
	off_state = "wasteland_goggles"
	contained_sprite = TRUE
	flip_down = "up to protect your eyes."
	flip_up = "and let it hang around your neck."

/obj/item/clothing/glasses/safety/goggles/wasteland/toggle()
	..()
	icon_state = initial(icon_state)
	if(up)
		item_state = "[initial(item_state)]_up"
	else
		item_state = initial(icon_state)
	update_worn_icon()
	update_clothing_icon()
	update_icon()

/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Yarr."
	icon_state = "eyepatch"
	item_state = "eyepatch"
	body_parts_covered = 0
	var/flipped = 0
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/clothing/glasses/eyepatch/verb/flip_patch()
	set name = "Flip Patch"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return
	handle_flipping(usr)

/obj/item/clothing/glasses/eyepatch/proc/handle_flipping(var/mob/user)
	src.flipped = !src.flipped
	if(src.flipped)
		src.icon_state = "[icon_state]_r"
	else
		src.icon_state = initial(icon_state)
	to_chat(usr, "You change \the [src] to cover the [src.flipped ? "left" : "right"] eye.")
	update_clothing_icon()
	update_icon()

/obj/item/clothing/glasses/eyepatch/white
	name = "eyepatch"
	desc = "A simple eyepatch made out of a strip of cloth."
	icon_state = "eyepatch_white"
	item_state = "eyepatch_white"

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state = "monocle"
	body_parts_covered = 0

/obj/item/clothing/glasses/material
	name = "optical material scanner"
	desc = "Very confusing glasses."
	icon_state = "material"
	item_state = "material"
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/eyes.dmi'
	)
	action_button_name = "Toggle Goggles"
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	toggleable = 1
	vision_flags = SEE_OBJS
	item_flags = AIRTIGHT

/obj/item/clothing/glasses/material/aviator
	name = "material aviators"
	desc = "Modified aviator glasses with a toggled ability to make your head ache. Comes with bonus prescription interface."
	icon_state = "aviator_mat"
	off_state = "aviator_off"
	action_button_name = "Toggle Mode"
	activation_sound = 'sound/effects/pop.ogg'
	prescription = 7

/obj/item/clothing/glasses/material/aviator/verb/toggle()
	set category = "Object"
	set name = "Toggle Aviators"
	set src in usr

	attack_self(usr)

/obj/item/clothing/glasses/regular
	name = "prescription glasses"
	desc = "Made by Nerd. Co."
	icon_state = "glasses"
	item_state = "glasses"
	prescription = 7
	body_parts_covered = 0

/obj/item/clothing/glasses/regular/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/clothing/glasses/hud/health))
		user.drop_item(W)
		qdel(W)
		to_chat(user, SPAN_NOTICE("You attach a set of medical HUDs to your glasses."))
		playsound(src.loc, 'sound/weapons/blade_open.ogg', 50, 1)
		var/obj/item/clothing/glasses/hud/health/prescription/P = new /obj/item/clothing/glasses/hud/health/prescription(user.loc)
		P.glasses_type = src.type
		user.put_in_hands(P)
		qdel(src)
	if(istype(W, /obj/item/clothing/glasses/hud/security))
		user.drop_item(W)
		qdel(W)
		to_chat(user, SPAN_NOTICE("You attach a set of security HUDs to your glasses."))
		playsound(src.loc, 'sound/weapons/blade_open.ogg', 50, 1)
		var/obj/item/clothing/glasses/hud/security/prescription/P = new /obj/item/clothing/glasses/hud/security/prescription(user.loc)
		P.glasses_type = src.type
		user.put_in_hands(P)
		qdel(src)

/obj/item/clothing/glasses/regular/scanners
	name = "scanning goggles"
	desc = "A very oddly shaped pair of goggles with bits of wire poking out the sides. A soft humming sound emanates from it."
	icon_state = "scanning"

/obj/item/clothing/glasses/regular/scanners/glasses_examine_atom(var/atom/A, var/user)
	if(isobj(A))
		var/obj/O = A
		if(length(O.origin_tech))
			to_chat(user, FONT_SMALL("\The [O] grants these tech levels when deconstructed:"))
			for(var/tech in O.origin_tech)
				to_chat(user, FONT_SMALL("[capitalize_first_letters(tech)]: [O.origin_tech[tech]]"))

/obj/item/clothing/glasses/regular/hipster
	name = "prescription glasses"
	desc = "Made by Uncool. Co."
	icon_state = "hipster_glasses"
	item_state = "hipster_glasses"

/obj/item/clothing/glasses/threedglasses
	desc = "A long time ago, people used these glasses to makes images from screens threedimensional."
	name = "3D glasses"
	icon_state = "3d"
	item_state = "3d"
	body_parts_covered = 0

/obj/item/clothing/glasses/regular/jamjar
	name = "jamjar glasses"
	desc = "Also known as Virginity Protectors."
	icon_state = "jamjar_glasses"
	item_state = "jamjar_glasses"

/obj/item/clothing/glasses/regular/circle
	name = "circle glasses"
	desc = "Why would you wear something so controversial yet so brave?"
	icon_state = "circle_glasses"
	item_state = "circle_glasses"

/obj/item/clothing/glasses/aug/glasses
	name = "corrective lenses"
	desc = "Corrective lenses made for those who have trouble seeing."
	icon_state = "glasses"
	item_state = "glasses"
	prescription = 7
	body_parts_covered = 0
	canremove = FALSE

/obj/item/clothing/glasses/sunglasses
	name = "sunglasses"
	desc = "Strangely ancient technology used to help provide rudimentary eye cover."
	icon_state = "sun"
	item_state = "sun"
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/eyes.dmi'
	)
	darkness_view = -1
	flash_protection = FLASH_PROTECTION_MODERATE

/obj/item/clothing/glasses/sunglasses/Initialize()
	. = ..()
	desc += " Enhanced shielding blocks many flashes."

/obj/item/clothing/glasses/sunglasses/aviator
	name = "aviators"
	desc = "A pair of designer sunglasses. They should put HUDs in these."
	icon_state = "aviator"
	item_state = "aviator"
	prescription = 7

/obj/item/clothing/glasses/sunglasses/prescription
	name = "prescription sunglasses"
	prescription = 7

/obj/item/clothing/glasses/sunglasses/prescription/Initialize()
	. = ..()
	desc += " Comes with built-in prescription lenses."

/obj/item/clothing/glasses/sunglasses/big
	icon_state = "bigsunglasses"
	item_state = "sun"

/obj/item/clothing/glasses/sunglasses/visor
	name = "visor sunglasses"
	desc = "A pair of visor sunglasses."
	icon_state = "visor"
	item_state = "visor"

//For style with no powergaming connotations.

/obj/item/clothing/glasses/fakesunglasses
	name = "stylish sunglasses"
	desc = "A pair of designer sunglasses."
	icon_state = "sun"
	item_state = "sun"
	darkness_view = -1

/obj/item/clothing/glasses/fakesunglasses/Initialize()
	. = ..()
	desc += " Doesn't seem like it'll block flashes."

/obj/item/clothing/glasses/fakesunglasses/aviator
	name = "stylish aviators"
	desc = "A pair of designer sunglasses. They should put HUDs in these."
	icon_state = "aviator"
	item_state = "aviator"
	prescription = 7

/obj/item/clothing/glasses/fakesunglasses/prescription
	name = "stylish prescription sunglasses"
	prescription = 7

/obj/item/clothing/glasses/fakesunglasses/prescription/Initialize()
	. = ..()
	desc += " Comes with built-in prescription lenses."

/obj/item/clothing/glasses/fakesunglasses/big
	icon_state = "bigsunglasses"
	item_state = "sun"

/obj/item/clothing/glasses/fakesunglasses/visor
	name = "stylish visor sunglasses"
	desc = "A pair of designer visor sunglasses."
	icon_state = "visor"
	item_state = "visor"

/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association."
	icon_state = "welding-g"
	item_state = "welding-g"
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/eyes.dmi'
	)
	action_button_name = "Flip Welding Goggles"

	var/up = 0
	item_flags = THICKMATERIAL
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_HEAVY

/obj/item/clothing/glasses/welding/attack_self()
	toggle()

/obj/item/clothing/glasses/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding goggles"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(src.up)
			src.up = !src.up
			flags_inv |= HIDEEYES
			body_parts_covered |= EYES
			icon_state = initial(icon_state)
			item_state = initial(icon_state)
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			to_chat(usr, "You flip \the [src] down to protect your eyes.")
		else
			src.up = !src.up
			flags_inv &= ~HIDEEYES
			body_parts_covered &= ~EYES
			icon_state = "[initial(icon_state)]up"
			item_state = "[initial(item_state)]up"
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			to_chat(usr, "You push \the [src] up out of your face.")
		update_clothing_icon()
		usr.update_action_buttons()
		usr.handle_vision()

/obj/item/clothing/glasses/aug/welding
	name = "glare dampeners"
	desc = "A subdermal implant installed just above the brow line that deploys a thin sheath of hyperpolycarbonate that protects from eye damage associated with arc flash."
	icon = 'icons/clothing/eyes/welding_goggles.dmi'
	icon_state = "welding-aug"
	item_state = "welding-aug"
	contained_sprite = TRUE
	item_flags = THICKMATERIAL
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_HEAVY
	canremove = FALSE

/obj/item/clothing/glasses/aug/throw_at()
	usr.drop_from_inventory(src)

/obj/item/clothing/glasses/aug/dropped()
	loc = null
	qdel(src)

/obj/item/clothing/glasses/welding/superior
	name = "superior welding goggles"
	desc = "Welding goggles made from more expensive materials, strangely smells like potatoes."
	icon_state = "rwelding-g"
	item_state = "rwelding-g"
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/eyes.dmi'
	)
	tint = TINT_MODERATE

/obj/item/clothing/glasses/welding/emergency
	name = "emergency welding goggles"
	desc = "A cheaper version of standard welding goggles, approved for emergency use by the NanoTrasen Safety Board."
	icon = 'icons/clothing/eyes/welding_goggles.dmi'
	icon_state = "ewelding-g"
	item_state = "ewelding-g"
	contained_sprite = TRUE
	tint = TINT_BLIND // yes, this is on purpose

/obj/item/clothing/glasses/sunglasses/blindfold
	name = "blindfold"
	desc = "Covers the eyes, preventing sight."
	icon_state = "blindfold"
	item_state = "blindfold"
	tint = TINT_BLIND
	shatter_material = FALSE
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/clothing/glasses/sunglasses/blindfold/white
	icon_state = "blindfoldwhite"
	item_state = "blindfoldwhite"

/obj/item/clothing/glasses/sunglasses/blindfold/white/seethrough
	desc = "A blindfold that covers the eyes, this one seems to be made of thinner material."
	tint = TINT_NONE // It's practically a fluff thing anyway, so.

/obj/item/clothing/glasses/sunglasses/blinders
	name = "vaurcae blinders"
	desc = "Specially designed Vaurca blindfold, designed to let in just enough light to see."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "blinders"
	item_state = "blinders"
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/eyes.dmi', BODYTYPE_VAURCA_WARFORM = 'icons/mob/species/warriorform/eyes.dmi'
	)
	contained_sprite = TRUE
	shatter_material = FALSE
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/clothing/glasses/sunglasses/blindfold/tape
	name = "length of tape"
	desc = "It's a robust DIY blindfold!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state = null
	w_class = ITEMSIZE_TINY

/obj/item/clothing/glasses/sunglasses/sechud
	name = "HUDsunglasses"
	desc = "Sunglasses in the colours of NanoTrasen security. They come with a blue-tinted HUD."
	icon_state = "sunhud"

/obj/item/clothing/glasses/sunglasses/sechud/Initialize()
	. = ..()
	src.hud = new/obj/item/clothing/glasses/hud/security(src)
	return

/obj/item/clothing/glasses/sunglasses/sechud/is_sec_hud()
	return active

/obj/item/clothing/glasses/sunglasses/sechud/big
	name = "fat HUDsunglasses"
	desc = "Fat sunglasses in the colours of NanoTrasen security. They come with a blue-tinted HUD."
	icon_state = "bigsunglasses_hud"

/obj/item/clothing/glasses/sunglasses/sechud/zavod
	name = "Zavodskoi HUDsunglasses"
	desc = "Sunglasses in the colours of Zavodskoi Interstellar. They come with a red-tinted HUD."
	icon_state = "sunhud_zavod"

/obj/item/clothing/glasses/sunglasses/sechud/big/zavod
	name = "fat Zavodskoi HUDsunglasses"
	desc = "Fat sunglasses in the colours of Zavodskoi Interstellar. They come with a red-tinted HUD."
	icon_state = "bigsunglasses_hud_zavod"

/obj/item/clothing/glasses/sunglasses/sechud/pmc
	name = "PMCG HUDsunglasses"
	desc = "Sunglasses in the colours of the Private Military Contracting Group. They come with a blue-tinted HUD and a chrome finish."
	icon_state = "sunhud_pmcg"

/obj/item/clothing/glasses/sunglasses/sechud/big/pmc
	name = "fat PMCG HUDsunglasses"
	desc = "Fat sunglasses in the colours of the Private Military Contracting Group. They come with a blue-tinted HUD and a chrome finish."
	icon_state = "bigsunglasses_hud_pmcg"

/obj/item/clothing/glasses/sunglasses/sechud/idris
	name = "Idris HUDsunglasses"
	desc = "Sunglasses in the colours of Idris Incorporated. They come with a teal-tinted HUD and a chrome finish."
	icon_state = "sunhud_idris"

/obj/item/clothing/glasses/sunglasses/sechud/big/idris
	name = "fat Idris HUDsunglasses"
	desc = "Fat sunglasses in the colours of Idris Incorporated. They come with a teal-tinted HUD and a chrome finish."
	icon_state = "bigsunglasses_hud_idris"

/obj/item/clothing/glasses/sunglasses/sechud/tactical
	name = "tactical HUD"
	desc = "Flash-resistant goggles with inbuilt combat and security information."
	icon_state = "swatgoggles"
	item_state = "swatgoggles"
	item_flags = AIRTIGHT|THICKMATERIAL

/obj/item/clothing/glasses/sunglasses/sechud/head
	name = "advanced aviators"
	desc = "Snazzy, advanced aviators with inbuilt combat and security information."
	icon_state = "hosglasses"
	item_state = "hosglasses"
	prescription = 7

/obj/item/clothing/glasses/sunglasses/sechud/aviator
	name = "HUD aviators"
	desc = "NanoTrasen security aviator glasses that can be switched between HUD and flash protection modes. They come with a built-in prescription overlay."
	flash_protection = FLASH_PROTECTION_NONE
	icon_state = "aviator_sec"
	off_state = "aviator_sec_off"
	item_state_slots = list(slot_r_hand_str = "aviator_sec", slot_l_hand_str = "aviator_sec")
	action_button_name = "Toggle Mode"
	var/on = TRUE
	toggleable = TRUE
	activation_sound = 'sound/effects/pop.ogg'
	prescription = 7

	var/hud_holder

/obj/item/clothing/glasses/sunglasses/sechud/aviator/Initialize()
	.=..()
	hud_holder = hud

/obj/item/clothing/glasses/sunglasses/sechud/aviator/Destroy()
	qdel(hud_holder)
	hud_holder = null
	hud = null
	.=..()

/obj/item/clothing/glasses/sunglasses/sechud/aviator/attack_self(mob/user)
	if(toggleable && !user.incapacitated())
		on = !on
		if(on)
			flash_protection = FLASH_PROTECTION_NONE
			active = TRUE
			src.hud = hud_holder
			to_chat(user, "You switch \the [src] to HUD mode.")
		else
			flash_protection = FLASH_PROTECTION_MODERATE
			active = TRUE
			src.hud = null
			to_chat(user, "You switch \the [src] to flash protection mode.")
		update_icon()
		sound_to(user, activation_sound)
		user.update_inv_glasses()
		user.update_action_buttons()

/obj/item/clothing/glasses/sunglasses/sechud/aviator/update_icon()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = off_state

/obj/item/clothing/glasses/sunglasses/sechud/aviator/verb/toggle()
	set category = "Object"
	set name = "Toggle Aviators"
	set src in usr

	attack_self(usr)

/obj/item/clothing/glasses/sunglasses/sechud/aviator/zavod
	name = "Zavodskoi HUD aviators"
	desc = "Zavodskoi security aviator glasses that can be switched between HUD and flash protection modes. They come with a built-in prescription overlay."
	icon_state = "aviator_sec_zavod"
	off_state = "aviator_sec_zavod_off"

/obj/item/clothing/glasses/sunglasses/sechud/aviator/pmc
	name = "PMCG HUD aviators"
	desc = "PMCG security aviator glasses that can be switched between HUD and flash protection modes. They come with a built-in prescription overlay."
	icon_state = "aviator_sec_pmcg"
	off_state = "aviator_sec_pmcg_off"

/obj/item/clothing/glasses/sunglasses/sechud/aviator/idris
	name = "Idris HUD aviators"
	desc = "Idris security aviator glasses that can be switched between HUD and flash protection modes. They come with a built-in prescription overlay."
	icon_state = "aviator_sec_idris"
	off_state = "aviator_sec_idris_off"

obj/item/clothing/glasses/sunglasses/sechud/aviator/visor
	name = "security HUD visor"
	desc = "NanoTrasen security visor glasses that can be switched between HUD and flash protection modes. They come with a built-in prescription overlay."
	icon_state = "visor_sec"
	off_state = "visor_sec_off"
	item_state_slots = list(slot_r_hand_str = "visor_sec", slot_l_hand_str = "visor_sec")

/obj/item/clothing/glasses/thermal
	name = "optical thermal scanner"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state = "thermal"
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/eyes.dmi'
	)
	action_button_name = "Toggle Goggles"
	origin_tech = list(TECH_MAGNET = 3)
	toggleable = 1
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	flash_protection = FLASH_PROTECTION_REDUCED
	item_flags = AIRTIGHT

/obj/item/clothing/glasses/thermal/emp_act(severity)
	if(istype(src.loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = src.loc
		to_chat(M, "<span class='danger'>\The [src] overloads and blinds you!</span>")
		if(M.glasses == src)
			M.eye_blind = 3
			M.eye_blurry = 5
			// Don't cure being nearsighted
			if(!(M.disabilities & NEARSIGHTED))
				M.disabilities |= NEARSIGHTED
				addtimer(CALLBACK(M, /mob/living/carbon/human/.proc/thermal_reset_blindness), 100)
	..()

/obj/item/clothing/glasses/thermal/Initialize()
	. = ..()
	overlay = global_hud.thermal

/mob/living/carbon/human/proc/thermal_reset_blindness()
	disabilities &= ~NEARSIGHTED

/obj/item/clothing/glasses/thermal/syndi	//These are now a traitor item, concealed as mesons.	-Pete
	name = "optical meson scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/eyes.dmi'
	)
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)

/obj/item/clothing/glasses/thermal/plain
	toggleable = 0
	activation_sound = null
	action_button_name = null
	item_flags = AIRTIGHT

/obj/item/clothing/glasses/thermal/plain/monocle
	name = "thermonocle"
	desc = "A monocle thermal."
	icon_state = "thermonocle"
	item_state = "thermonocle"
	flags = null //doesn't protect eyes because it's a monocle, duh
	item_flags = null
	body_parts_covered = 0

/obj/item/clothing/glasses/thermal/plain/jensen
	name = "optical thermal implants"
	desc = "A set of implantable lenses designed to augment your vision"
	icon_state = "thermalimplants"
	item_state = "box"
	item_flags = null

/obj/item/clothing/glasses/thermal/aviator
	name = "aviators"
	desc = "A pair of designer sunglasses. They should put HUDs in these."
	desc_antag = "Modified aviator glasses with a toggled thermal-vision mode."
	icon_state = "aviator_thr"
	off_state = "aviator_off"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")
	action_button_name = "Toggle HUD"
	activation_sound = 'sound/effects/pop.ogg'
	prescription = 7

/obj/item/clothing/glasses/thermal/aviator/verb/toggle()
	set category = "Object"
	set name = "Toggle Aviators"
	set src in usr

	attack_self(usr)

/obj/item/clothing/glasses/eyepatch/hud
	name = "iPatch"
	desc = "For the technologically inclined pirate. It connects directly to the optical nerve of the user, replacing the need for that useless eyeball."
	icon_state = "hudpatch"
	item_state = "hudpatch"
	off_state = "hudpatch"
	action_button_name = "Toggle iPatch"
	prescription = 7 //To emulate not having one eyeball
	toggleable = TRUE
	toggle_changes_appearance = FALSE
	var/eye_color = COLOR_WHITE
	var/image/mob_overlay

/obj/item/clothing/glasses/eyepatch/hud/handle_flipping(mob/user)
	..()
	handle_mob_overlay()

/obj/item/clothing/glasses/eyepatch/hud/proc/handle_mob_overlay()
	if(mob_overlay && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.glasses == src)
			H.cut_overlay(mob_overlay, TRUE)
	mob_overlay = image('icons/obj/clothing/glasses.dmi', "[icon_state]_eye")
	mob_overlay.appearance_flags = RESET_COLOR
	mob_overlay.color = eye_color
	mob_overlay.layer = LIGHTING_LAYER + 1
	if(active && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.glasses == src)
			H.add_overlay(mob_overlay, TRUE)
	update_icon()

/obj/item/clothing/glasses/eyepatch/hud/Initialize()
	. = ..()
	handle_mob_overlay()

/obj/item/clothing/glasses/eyepatch/hud/equipped(mob/user, slot)
	if(active && slot == slot_glasses)
		user.add_overlay(mob_overlay, TRUE)
	else
		user.cut_overlay(mob_overlay, TRUE)
	return ..()

/obj/item/clothing/glasses/eyepatch/hud/Destroy()
	if (ishuman(loc))
		loc.cut_overlay(mob_overlay, TRUE)
	QDEL_NULL(mob_overlay)
	return ..()

/obj/item/clothing/glasses/eyepatch/hud/attack_self()
	..()
	handle_mob_overlay()

/obj/item/clothing/glasses/eyepatch/hud/update_icon()
	cut_overlays()
	if(active)
		var/image/eye = image('icons/obj/clothing/glasses.dmi', "[icon_state]_ovr")
		eye.appearance_flags = RESET_COLOR
		eye.color = eye_color
		add_overlay(eye)

/obj/item/clothing/glasses/eyepatch/hud/forceMove(atom/newloc)
	if (!ishuman(loc))
		return ..()

	var/mob/M = loc
	. = ..()
	if (loc !=M)
		M.cut_overlay(mob_overlay, TRUE)

/obj/item/clothing/glasses/eyepatch/hud/security
	name = "HUDpatch"
	desc = "A Security-type heads-up display that connects directly to the optic nerve of the user, replacing what you lost in Space 'Nam."
	hud = /obj/item/clothing/glasses/hud/security
	eye_color = COLOR_BLUE

/obj/item/clothing/glasses/eyepatch/hud/security/process_hud(var/mob/M)
	process_sec_hud(M, 1)

/obj/item/clothing/glasses/eyepatch/hud/security/is_sec_hud()
	return active

/obj/item/clothing/glasses/eyepatch/hud/medical
	name = "MEDpatch"
	desc = "A Medical-type heads-up display that connects directly to the optic nerve of the user, giving you information about a patient your department will likely ignore."
	hud = /obj/item/clothing/glasses/hud/health
	eye_color = COLOR_CYAN

/obj/item/clothing/glasses/eyepatch/hud/medical/process_hud(var/mob/M)
	process_med_hud(M, 1)

/obj/item/clothing/glasses/eyepatch/hud/medical/is_med_hud()
	return active

/obj/item/clothing/glasses/eyepatch/hud/meson
	name = "MESpatch"
	desc = "An optical meson scanner display that connects directly to the optic nerve of the user, giving you cool green vision at the low cost of your only other eye."
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	eye_color = COLOR_LIME

/obj/item/clothing/glasses/eyepatch/hud/meson/Initialize()
	. = ..()
	overlay = global_hud.meson

/obj/item/clothing/glasses/eyepatch/hud/material
	name = "MATpatch"
	desc = "An optical material scanner display that connects directly to the optic nerve of the user, making you a professional at I Spy."
	vision_flags = SEE_OBJS
	eye_color = COLOR_LUMINOL

/obj/item/clothing/glasses/eyepatch/hud/science
	name = "SCIpatch"
	desc = "A science-type heads-up display that connects directly to the optic nerve of the user. Does nothing, but at least you won't get acid in your eye socket."
	eye_color = COLOR_PURPLE

/obj/item/clothing/glasses/eyepatch/hud/science/Initialize()
	..()
	overlay = global_hud.science

/obj/item/clothing/glasses/eyepatch/hud/thermal
	name = "HEATpatch"
	desc = "A thermal-type heads-up display that connects directly to the optic nerve of the user. Double the tacticool, half the eyes."
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	eye_color = COLOR_ORANGE

/obj/item/clothing/glasses/eyepatch/hud/thermal/Initialize()
	..()
	overlay = global_hud.thermal

/obj/item/clothing/glasses/eyepatch/hud/welder
	name = "WELDpatch"
	desc = "A light-filtering display that connects directly to the optic nerve of the user, blocking light for exactly one eye. Choose wisely."
	flash_protection = FLASH_PROTECTION_MODERATE
	tint = TINT_MODERATE
	eye_color = COLOR_BLACK

/obj/item/clothing/glasses/eyepatch/hud/night
	name = "NITEpatch"
	desc = "A light-amplifying display that connects directly to the optic nerve of the user. Helps you avoid a battery charge from bumping an officer in the dark."
	darkness_view = 7
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	eye_color = COLOR_GREEN

/obj/item/clothing/glasses/eyepatch/hud/night/Initialize()
	..()
	overlay = global_hud.nvg

//from verkister
/obj/item/clothing/glasses/spiffygogs
	name = "orange goggles"
	desc = "You can almost feel the raw power radiating off these strange specs."
	icon_state = "spiffygogs"
	item_state = "spiffygogs"
	action_button_name = "Adjust Goggles"
	var/up = 0
	item_flags = AIRTIGHT

/obj/item/clothing/glasses/spiffygogs/attack_self()
	toggle()


/obj/item/clothing/glasses/spiffygogs/verb/toggle()
	set category = "Object"
	set name = "Adjust Goggles"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(src.up)
			src.up = !src.up
			flags_inv |= HIDEEYES
			body_parts_covered |= EYES
			icon_state = initial(icon_state)
			item_flags |= AIRTIGHT
			to_chat(usr, "You flip \the [src] down over your eyes.")
		else
			src.up = !src.up
			flags_inv &= ~HIDEEYES
			body_parts_covered &= ~EYES
			icon_state = "[initial(icon_state)]up"
			item_flags &= ~AIRTIGHT
			to_chat(usr, "You push \the [src] up off your eyes.")
		update_clothing_icon()
		usr.update_action_buttons()

/obj/item/clothing/glasses/spiffygogs/offworlder
	name = "starshades"
	desc = "Thick, durable eye protection meant to filter light to an acceptable degree in the long-term."
	icon_state = "starshades"
	item_state = "starshades"
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_MODERATE

/obj/item/clothing/glasses/spiffygogs/offworlder/toggle()
	..()
	if(!up)
		flash_protection = FLASH_PROTECTION_MAJOR
		tint = TINT_MODERATE
	else
		flash_protection = FLASH_PROTECTION_NONE
		tint = TINT_NONE
