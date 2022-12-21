/obj/item/melee/arm_blade
	name = "arm blade"
	desc = "A grotesque blade made out of bone and flesh that cleaves through people like a hot knife through butter."
	icon = 'icons/obj/changeling.dmi'
	icon_state = "arm_blade"
	item_state = "arm_blade"
	contained_sprite = TRUE
	w_class = ITEMSIZE_LARGE
	force = 30
	sharp = TRUE
	edge = TRUE
	anchored = TRUE
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	can_embed = FALSE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	canremove = FALSE
	var/mob/living/creator

/obj/item/melee/arm_blade/New()
	..()
	START_PROCESSING(SSprocessing, src)

/obj/item/melee/arm_blade/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/melee/arm_blade/dropped(var/mob/living/user)
	visible_message("<span class='danger'>With a sickening crunch, [user] reforms their arm blade into an arm!</span>",
	"<span class='warning'>You hear organic matter ripping and tearing!</span>")
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/melee/arm_blade/process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		QDEL_IN(src, 1)

/obj/item/melee/arm_blade/iscrowbar()
	if(creator.a_intent == I_HELP)
		return TRUE
	return FALSE

/obj/item/melee/arm_blade/pre_attack(var/mob/living/target, var/mob/living/user)
	if(istype(target))
		cleave(user, target)
	return ..()

/obj/item/melee/arm_blade/resolve_attackby(atom/A, mob/living/user, var/click_parameters)
	if(istype(A,/turf/simulated/floor) && user.a_intent != I_HELP)
		return
	else
		..()

/obj/item/shield/riot/changeling
	name = "shield-like mass"
	desc = "A mass of tough, boney tissue. You can still see the fingers as a twisted pattern in the shield."
	icon = 'icons/obj/changeling.dmi'
	icon_state = "ling_shield"
	item_state = "ling_shield"
	contained_sprite = TRUE
	force = 15 //Bash the crap out of people
	slot_flags = null
	anchored = TRUE
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	can_embed = FALSE
	base_block_chance = 70
	var/mob/living/creator

/obj/item/shield/riot/changeling/New()
	..()
	START_PROCESSING(SSprocessing, src)

/obj/item/shield/riot/changeling/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/shield/riot/changeling/dropped(var/mob/living/user)
	visible_message("<span class='danger'>With a sickening crunch, [user] reforms their shield into an arm!</span>",
	"<span class='warning'>You hear organic matter ripping and tearing!</span>")
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/shield/riot/changeling/process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		QDEL_IN(src, 1)

/obj/item/shield/riot/changeling/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		if((is_sharp(P) && damage > 10) || istype(P, /obj/item/projectile/beam))
			return base_block_chance / 2 //lings still have a 35% chance of blocking these kinds of attacks
	return base_block_chance

/obj/item/bone_dart
	name = "bone dart"
	desc = "A sharp piece of bone shapped as small dart."
	icon = 'icons/obj/changeling.dmi'
	icon_state = "bone_dart"
	item_state = "bolt"
	sharp = TRUE
	edge = FALSE
	throwforce = 5
	w_class = ITEMSIZE_SMALL

/obj/item/gun/projectile/changeling
	name = "bone launcher"
	desc = "A disgusting arrangement of flesh and tendons that seems to specialize in flinging chunks of sharpened bone."
	icon = 'icons/obj/guns/bone_launcher.dmi'
	icon_state = "bone_launcher"
	item_state = "bone_launcher"
	caliber = "bone"
	accuracy = 1
	offhand_accuracy = 1
	fire_sound = 'sound/effects/cardboard_break3.ogg'
	magazine_type = /obj/item/ammo_magazine/bone_mag
	load_method = MAGAZINE
	handle_casings = DELETE_CASINGS
	has_safety = FALSE
	show_magazine = FALSE
	needspin = FALSE

	var/mob/living/creator

/obj/item/gun/projectile/changeling/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/item/gun/projectile/changeling/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/gun/projectile/changeling/dropped(var/mob/living/user)
	visible_message(SPAN_DANGER("With a sickening crunch, [user] reforms their bone launcher into an arm!"), SPAN_WARNING("You hear organic matter ripping and tearing!"))
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/gun/projectile/changeling/afterattack(atom/A, mob/living/user)
	..()
	if(ammo_magazine && !length(ammo_magazine.stored_ammo))
		creator.drop_from_inventory(src, creator.loc)

/obj/item/gun/projectile/changeling/process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(ishuman(loc))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		QDEL_IN(src, 1)

/obj/item/gun/projectile/changeling/load_ammo(var/obj/item/A, mob/user)
	return

/obj/item/gun/projectile/changeling/unload_ammo(mob/user, var/allow_dump = 1, var/drop_mag = FALSE)
	return

/obj/item/ammo_magazine/bone_mag
	name = "bone mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/bone_bullet
	caliber = "bone"
	max_ammo = 15

/obj/item/ammo_casing/bone_bullet
	desc = "A bone bullet."
	caliber = "bone"
	projectile_type = /obj/item/projectile/bullet/pistol/medium/bone
	max_stack = 10
