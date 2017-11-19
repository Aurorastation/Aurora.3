
/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	//w_class = 2.0
	//slot_flags = SLOT_EYES
	//var/vision_flags = 0
	//var/darkness_view = 0//Base human is 2
	var/prescription = 0
	var/toggleable = 0
	var/off_state = "degoggles"
	var/active = 1
	var/activation_sound = 'sound/items/goggles_charge.ogg'
	var/obj/screen/overlay = null
	var/obj/item/clothing/glasses/hud/hud = null	// Hud glasses, if any
	var/activated_color = null

/obj/item/clothing/glasses/attack_self(mob/user)
	if(toggleable)
		if(active)
			active = 0
			icon_state = off_state
			user.update_inv_glasses()
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			usr << "You deactivate the optical matrix on the [src]."
			if(activated_color)
				set_light(0)
		else
			active = 1
			icon_state = initial(icon_state)
			user.update_inv_glasses()
			if(activation_sound)
				usr << activation_sound
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			usr << "You activate the optical matrix on the [src]."
			if(activated_color)
				set_light(2, 0.4, activated_color)
		user.update_action_buttons()

/obj/item/clothing/glasses/meson
	name = "optical meson scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state = "glasses"
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

/obj/item/clothing/glasses/science
	name = "science goggles"
	desc = "Used to protect your eyes against harmful chemicals!"
	icon_state = "purple"
	item_state = "glasses"
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

/obj/item/clothing/glasses/goggles
	name = "goggles"
	desc = "A simple pair of plain goggles."
	icon_state = "plaingoggles"
	item_flags = AIRTIGHT


/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Yarr."
	icon_state = "eyepatch"
	item_state = "eyepatch"
	body_parts_covered = 0
	var/flipped = 0

/obj/item/clothing/glasses/eyepatch/attack_self(mob/user)
	src.flipped = !src.flipped
	if(src.flipped)
		src.icon_state = "[icon_state]_1"
		src.item_state = "[icon_state]_1"
		to_chat(user, "You change \the [src] to cover the left eye.")
	else
		src.icon_state = initial(icon_state)
		src.icon_state = initial(icon_state)
		to_chat(user, "You change \the [src] to cover the right eye.")
	user.update_inv_glasses()

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state = "headset" // lol
	body_parts_covered = 0

/obj/item/clothing/glasses/material
	name = "optical material scanner"
	desc = "Very confusing glasses."
	icon_state = "material"
	item_state = "glasses"
	action_button_name = "Toggle Goggles"
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	toggleable = 1
	vision_flags = SEE_OBJS
	item_flags = AIRTIGHT

/obj/item/clothing/glasses/regular
	name = "prescription glasses"
	desc = "Made by Nerd. Co."
	icon_state = "glasses"
	item_state = "glasses"
	prescription = 1
	body_parts_covered = 0

/obj/item/clothing/glasses/regular/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/clothing/glasses/hud/health))
		user.drop_item()
		qdel(W)
		user << "<span class='notice'>You attach a set of medical HUDs to your glasses.</span>"
		var/turf/T = get_turf(src)
		new /obj/item/clothing/glasses/hud/health/prescription(T)
		user.drop_from_inventory(src)
		qdel(src)
	if(istype(W, /obj/item/clothing/glasses/hud/security))
		user.drop_item()
		qdel(W)
		user << "<span class='notice'>You attach a set of security HUDs to your glasses.</span>"
		var/turf/T = get_turf(src)
		new /obj/item/clothing/glasses/hud/security/prescription(T)
		user.drop_from_inventory(src)
		qdel(src)

/obj/item/clothing/glasses/regular/scanners
	name = "scanning goggles"
	desc = "A very oddly shaped pair of goggles with bits of wire poking out the sides. A soft humming sound emanates from it."
	icon_state = "uzenwa_sissra_1"

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
	item_state = "sunglasses"
	darkness_view = -1
	flash_protection = FLASH_PROTECTION_MODERATE

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
			item_state = initial(item_state)
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			usr << "You flip \the [src] down to protect your eyes."
		else
			src.up = !src.up
			flags_inv &= ~HIDEEYES
			body_parts_covered &= ~EYES
			icon_state = "[initial(icon_state)]up"
			item_state = "[initial(item_state)]up"
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			usr << "You push \the [src] up out of your face."
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


/obj/item/clothing/glasses/sunglasses/blinders
	name = "vaurcae blinders"
	desc = "Specially designed Vaurca blindfold, designed to let in just enough light to see."
	icon_state = "blinders"
	item_state = "blinders"

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
	item_state = "bigsunglasses"

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
	item_flags = AIRTIGHT

/obj/item/clothing/glasses/thermal
	name = "optical thermal scanner"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state = "glasses"
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
		M << "<span class='danger'>\The [src] overloads and blinds you!</span>"
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
	name = "thermoncle"
	desc = "A monocle thermal."
	icon_state = "thermoncle"
	flags = null //doesn't protect eyes because it's a monocle, duh
	item_flags = null

	body_parts_covered = 0

/obj/item/clothing/glasses/thermal/plain/eyepatch
	name = "optical thermal eyepatch"
	desc = "An eyepatch with built-in thermal optics"
	icon_state = "eyepatch"
	item_state = "eyepatch"
	body_parts_covered = 0
	item_flags = null

/obj/item/clothing/glasses/thermal/plain/jensen
	name = "optical thermal implants"
	desc = "A set of implantable lenses designed to augment your vision"
	icon_state = "thermalimplants"
	item_state = "syringe_kit"
	item_flags = null