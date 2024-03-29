/obj/item/gun/energy/scythe
	name = "\improper Purpose munitions scythe"
	desc = "<span class='warning'>A seemingly innocuous metal construction the size of a human arm. Through forces unknown, it produces alloy flechettes \
			capable of piercing even the strongest armor known to the Spur.</span>"
	icon = 'icons/obj/guns/scythe.dmi'
	icon_state = "hunterkiller_scythe"
	item_state = "hunterkiller_scythe"
	w_class = ITEMSIZE_HUGE
	force = 31
	armor_penetration = 30
	slot_flags = SLOT_BACK
	fire_sound = 'sound/weapons/railgun.ogg'
	safetyoff_sound = 'sound/weapons/railgun_insert.ogg'
	hitsound = 'sound/weapons/heavysmash.ogg'
	can_suppress = FALSE
	has_safety = FALSE
	has_item_ratio = FALSE

	max_shots = 20
	self_recharge = TRUE
	reliability = 100
	projectile_type = /obj/item/projectile/bullet/flechette

	firemodes = list(
		list(mode_name="semiauto", burst=1, projectile_type=/obj/item/projectile/bullet/flechette),
		list(mode_name="3-round bursts", burst=3, burst_delay=ROF_SUPERHEAVY, burst_accuracy=list(2,1,1), dispersion=list(0, 10, 15), projectile_type=/obj/item/projectile/bullet/flechette),
		list(mode_name="explosive", burst=1, projectile_type=/obj/item/projectile/bullet/flechette/explosive)
	)


	fire_delay = ROF_UNWIELDY
	accuracy = 2
	scoped_accuracy = 3

/obj/item/gun/energy/scythe/get_cell()
	return DEVICE_NO_CELL

/obj/item/gun/energy/scythe/fire_checks(atom/target, mob/living/user, clickparams, pointblank, reflex)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/terminator = user

	if(!isipc(terminator))
		to_chat(terminator, SPAN_WARNING("You have no idea how to even use this. Where's the trigger...?"))
		return FALSE

	if(!istype(terminator.species, /datum/species/machine/hunter_killer))
		to_chat(terminator, SPAN_WARNING("You can't interface with this weapon's systems at all. It feels entirely alien."))
		return FALSE

	. = ..()

/obj/item/gun/energy/scythe/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set src in usr

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/terminator = usr
	if(!terminator.use_check_and_message())
		return

	if(!isipc(terminator))
		to_chat(terminator, SPAN_WARNING("You have no idea where to even look..."))
		return

	if(!istype(terminator.species, /datum/species/machine/hunter_killer))
		to_chat(terminator, SPAN_WARNING("These systems are far too alien for even you to figure out."))
		return

	if(wielded)
		playsound(terminator, 'sound/items/goggles_charge.ogg', 40)
		toggle_scope(2, terminator)
	else
		to_chat(terminator, SPAN_WARNING("You can't look through the scope without stabilizing the rifle!"))
