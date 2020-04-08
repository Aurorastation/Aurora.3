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
		slot_l_hand_str = 'icons/mob/items/lefthand_glasses.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_glasses.dmi'
		)
	w_class = 2.0
	slot_flags = SLOT_EYES
	body_parts_covered = EYES
	var/vision_flags = 0
	var/darkness_view = 0//Base human is 2
	var/prescription = 0
	var/see_invisible = -1
	var/toggleable = 0
	var/off_state = "degoggles"
	var/active = 1
	var/activation_sound = 'sound/items/goggles_charge.ogg'
	var/obj/screen/overlay = null
	var/obj/item/clothing/glasses/hud/hud = null	// Hud glasses, if any
	var/activated_color = null
	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/eyes.dmi',
		"Vaurca Warform" = 'icons/mob/species/warriorform/eyes.dmi'
		)
	species_restricted = list("exclude","Vaurca Breeder")
	drop_sound = 'sound/items/drop/accessory.ogg'

// Called in mob/RangedAttack() and mob/UnarmedAttack.
/obj/item/clothing/glasses/proc/Look(var/atom/A, mob/user, var/proximity)
	return 0 // return 1 to cancel attack_hand/RangedAttack()

/obj/item/clothing/glasses/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_glasses()


/obj/item/clothing/glasses/attack_self(mob/user)
	if(toggleable)
		if(active)
			active = 0
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
	prescription = 1

/obj/item/clothing/glasses/meson/aviator
	name = "engineering aviators"
	desc = "Modified aviator glasses with a toggled meson interface. Comes with bonus prescription overlay."
	icon_state = "aviator_eng"
	off_state = "aviator_eng_off"
	action_button_name = "Toggle HUD"
	activation_sound = 'sound/effects/pop.ogg'
	prescription = 1

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
	prescription = 1

/obj/item/clothing/glasses/hud/health/aviator/verb/toggle()
	set category = "Object"
	set name = "Toggle Aviators"
	set src in usr

	attack_self(usr)


/obj/item/clothing/glasses/science
	name = "science goggles"
	desc = "Used to protect your eyes against harmful chemicals!"
	icon_state = "purple"
	item_state = "purple"
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
	prescription = 1

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
	item_flags = AIRTIGHT
	unacidable = 1

/obj/item/clothing/glasses/safety/goggles
	name = "safety goggles"
	desc = "A simple pair of safety goggles. It's general chemistry all over again."
	icon_state = "goggles_standard"
	item_state = "goggles_standard"
	off_state = "goggles_standard"
	action_button_name = "Flip Goggles"
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
		to_chat(usr, span("notice", "You flip \the [src] down to protect your eyes."))
	else
		src.up = !src.up
		flags_inv &= ~HIDEEYES
		body_parts_covered &= ~EYES
		icon_state = "[initial(icon_state)]_up"
		to_chat(usr, span("notice", "You push \the [src] up out of your face."))
	update_clothing_icon()
	update_icon()
	usr.update_action_buttons()

/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Yarr."
	icon_state = "eyepatch"
	item_state = "eyepatch"
	body_parts_covered = 0
	var/flipped = 0
	drop_sound = 'sound/items/drop/gloves.ogg'

/obj/item/clothing/glasses/eyepatch/verb/flip_patch()
	set name = "Flip Patch"
	set category = "Object"
	set src in usr

	if (usr.stat || usr.restrained())
		return

	src.flipped = !src.flipped
	if(src.flipped)
		src.icon_state = "[icon_state]_r"
	else
		src.icon_state = initial(icon_state)
	to_chat(usr, "You change \the [src] to cover the [src.flipped ? "left" : "right"] eye.")
	update_clothing_icon()
	update_icon()

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
	prescription = 1

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
	prescription = 1
	body_parts_covered = 0

/obj/item/clothing/glasses/regular/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/clothing/glasses/hud/health))
		user.drop_item(W)
		qdel(W)
		to_chat(user, span("notice", "You attach a set of medical HUDs to your glasses."))
		playsound(src.loc, 'sound/weapons/blade_open.ogg', 50, 1)
		var/obj/item/clothing/glasses/hud/health/prescription/P = new /obj/item/clothing/glasses/hud/health/prescription(user.loc)
		user.put_in_hands(P)
		qdel(src)
	if(istype(W, /obj/item/clothing/glasses/hud/security))
		user.drop_item(W)
		qdel(W)
		to_chat(user, span("notice", "You attach a set of security HUDs to your glasses."))
		playsound(src.loc, 'sound/weapons/blade_open.ogg', 50, 1)
		var/obj/item/clothing/glasses/hud/security/prescription/P = new /obj/item/clothing/glasses/hud/security/prescription(user.loc)
		user.put_in_hands(P)
		qdel(src)

/obj/item/clothing/glasses/regular/scanners
	name = "scanning goggles"
	desc = "A very oddly shaped pair of goggles with bits of wire poking out the sides. A soft humming sound emanates from it."
	icon_state = "scanning"

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

/obj/item/clothing/glasses/gglasses
	name = "green glasses"
	desc = "Forest green glasses, like the kind you'd wear when hatching a nasty scheme."
	icon_state = "gglasses"
	item_state = "gglasses"
	body_parts_covered = 0

/obj/item/clothing/glasses/sunglasses
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	name = "sunglasses"
	icon_state = "sun"
	item_state = "sun"
	darkness_view = -1
	flash_protection = FLASH_PROTECTION_MODERATE

/obj/item/clothing/glasses/sunglasses/aviator
	name = "aviators"
	desc = "A pair of designer sunglasses. They should put HUDs in these."
	icon_state = "aviator"
	item_state = "aviator"
	prescription = 1

/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association."
	icon_state = "welding-g"
	item_state = "welding-g"
	action_button_name = "Flip Welding Goggles"
	var/up = 0
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
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			to_chat(usr, "You flip \the [src] down to protect your eyes.")
		else
			src.up = !src.up
			flags_inv &= ~HIDEEYES
			body_parts_covered &= ~EYES
			icon_state = "[initial(icon_state)]up"
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			to_chat(usr, "You push \the [src] up out of your face.")
		update_clothing_icon()
		usr.update_action_buttons()

/obj/item/clothing/glasses/welding/superior
	name = "superior welding goggles"
	desc = "Welding goggles made from more expensive materials, strangely smells like potatoes."
	icon_state = "rwelding-g"
	item_state = "rwelding-g"
	tint = TINT_MODERATE

/obj/item/clothing/glasses/sunglasses/blindfold
	name = "blindfold"
	desc = "Covers the eyes, preventing sight."
	icon_state = "blindfold"
	item_state = "blindfold"
	tint = TINT_BLIND
	drop_sound = 'sound/items/drop/gloves.ogg'

/obj/item/clothing/glasses/sunglasses/blinders
	name = "vaurcae blinders"
	desc = "Specially designed Vaurca blindfold, designed to let in just enough light to see."
	icon_state = "blinders"
	item_state = "blindfold"
	drop_sound = 'sound/items/drop/gloves.ogg'

/obj/item/clothing/glasses/sunglasses/blindfold/tape
	name = "length of tape"
	desc = "It's a robust DIY blindfold!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state = null
	w_class = 1

/obj/item/clothing/glasses/sunglasses/prescription
	name = "prescription sunglasses"
	prescription = 1

/obj/item/clothing/glasses/sunglasses/big
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Larger than average enhanced shielding blocks many flashes."
	icon_state = "bigsunglasses"
	item_state = "sun"

/obj/item/clothing/glasses/fakesunglasses //Sunglasses without flash immunity
	name = "stylish sunglasses"
	desc = "A pair of designer sunglasses. Doesn't seem like it'll block flashes."
	icon_state = "sun"
	item_state = "sun"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")

/obj/item/clothing/glasses/fakesunglasses/prescription
	name = "stylish prescription sunglasses"
	prescription = 1

/obj/item/clothing/glasses/fakesunglasses/aviator
	desc = "A pair of designer sunglasses. Doesn't seem like it'll block flashes. Comes with built-in prescription lenses."
	icon_state = "aviator"
	item_state = "aviator"
	prescription = 1

/obj/item/clothing/glasses/sunglasses/sechud
	name = "HUDsunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunhud"

/obj/item/clothing/glasses/sunglasses/sechud/Initialize()
	. = ..()
	src.hud = new/obj/item/clothing/glasses/hud/security(src)
	return

/obj/item/clothing/glasses/sunglasses/sechud/tactical
	name = "tactical HUD"
	desc = "Flash-resistant goggles with inbuilt combat and security information."
	icon_state = "swatgoggles"
	item_state = "swatgoggles"
	item_flags = AIRTIGHT

/obj/item/clothing/glasses/sunglasses/sechud/head
	name = "advanced aviators"
	desc = "Snazzy, advanced aviators with inbuilt combat and security information."
	icon_state = "hosglasses"
	item_state = "hosglasses"
	prescription = 1

/obj/item/clothing/glasses/sunglasses/sechud/aviator
	name = "HUD aviators"
	desc = "Modified aviator glasses that can be switched between HUD and flash protection modes. Comes with bonus prescription overlay."
	icon_state = "aviator_sec"
	off_state = "aviator_sec_off"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")
	action_button_name = "Toggle Mode"
	var/on = TRUE
	toggleable = TRUE
	activation_sound = 'sound/effects/pop.ogg'
	prescription = 1

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
			src.hud = hud_holder
			to_chat(user, "You switch \the [src] to HUD mode.")
		else
			flash_protection = initial(flash_protection)
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

/obj/item/clothing/glasses/thermal
	name = "optical thermal scanner"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state = "thermal"
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
	desc = "Modified aviator glasses with a toggled thermal-vision mode. Comes with bonus prescription overlay."
	icon_state = "aviator_thr"
	off_state = "aviator_off"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")
	action_button_name = "Toggle HUD"
	activation_sound = 'sound/effects/pop.ogg'
	prescription = 1

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
	prescription = 1 //To emulate not having one eyeball
	toggleable = 1
	var/eye_color = COLOR_WHITE
	var/image/mob_overlay

/obj/item/clothing/glasses/eyepatch/hud/Initialize()
	.  = ..()
	mob_overlay = image('icons/obj/clothing/glasses.dmi', "[icon_state]_eye")
	mob_overlay.appearance_flags = RESET_COLOR
	mob_overlay.color = eye_color
	mob_overlay.layer = LIGHTING_LAYER+1
	update_icon()

/obj/item/clothing/glasses/eyepatch/hud/equipped(mob/user, slot)
	if (slot == slot_glasses)
		user.add_overlay(mob_overlay, TRUE)
	else
		user.cut_overlay(mob_overlay, TRUE)
	. =..()

/obj/item/clothing/glasses/eyepatch/hud/Destroy()
	if (ishuman(loc))
		loc.cut_overlay(mob_overlay, TRUE)
	QDEL_NULL(mob_overlay)
	return ..()

/obj/item/clothing/glasses/eyepatch/hud/attack_self()
	..()
	update_icon()

/obj/item/clothing/glasses/eyepatch/hud/update_icon()
	cut_overlays()
	if(active)
		var/image/eye = image('icons/obj/clothing/glasses.dmi', "[icon_state]_ovr")
		eye.appearance_flags = RESET_COLOR
		eye.color = eye_color
		add_overlay (eye)

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

/obj/item/clothing/glasses/eyepatch/hud/medical
	name = "MEDpatch"
	desc = "A Medical-type heads-up display that connects directly to the optic nerve of the user, giving you information about a patient your department will likely ignore."
	hud = /obj/item/clothing/glasses/hud/health
	eye_color = COLOR_CYAN

/obj/item/clothing/glasses/eyepatch/hud/medical/process_hud(var/mob/M)
	process_med_hud(M, 1)

/obj/item/clothing/glasses/eyepatch/hud/meson
	name = "MESpatch"
	desc = "An optical meson scanner display that connects directly to the optic nerve of the user, giving you cool green vision at the low cost of your only other eye."
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	eye_color = COLOR_LIME

/obj/item/clothing/glasses/eyepatch/hud/meson/Initialize()
	..()
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