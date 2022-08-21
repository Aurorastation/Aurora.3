/obj/item/gun/projectile/shotgun
	name = "strange shotgun"
	desc = "A strange shotgun that doesn't seem to belong anywhere. You feel like you shouldn't be able to see this and should... submit an issue?"
	var/can_sawoff = FALSE
	var/sawnoff_workmsg
	var/sawing_in_progress = FALSE

/obj/item/gun/projectile/shotgun/attackby(obj/item/A, mob/user)
	if (!can_sawoff || sawing_in_progress)
		return ..()

	var/static/list/barrel_cutting_tools = typecacheof(list(
		/obj/item/surgery/circular_saw,
		/obj/item/melee/energy,
		/obj/item/gun/energy/plasmacutter	// does this even work?
	))
	if(is_type_in_typecache(A, barrel_cutting_tools) && w_class != 3)
		to_chat(user, "<span class='notice'>You begin to [sawnoff_workmsg] of \the [src].</span>")
		if(loaded.len)
			for(var/i in 1 to max_shells)
				Fire(user, user)	//will this work? //it will. we call it twice, for twice the FUN
			user.visible_message("<span class='danger'>\The [src] goes off!</span>", "<span class='danger'>\The [src] goes off in your face!</span>")
			return

		sawing_in_progress = TRUE
		if(A.use_tool(src, user, 30, volume = 50))	//SHIT IS STEALTHY EYYYYY
			sawing_in_progress = FALSE
			saw_off(user, A)
		else
			sawing_in_progress = FALSE
	else
		..()

// called on a SUCCESSFUL saw-off.
/obj/item/gun/projectile/shotgun/proc/saw_off(mob/user, obj/item/tool)
	to_chat(user, "<span class='notice'>You attempt to cut [src]'s barrel with [tool], but nothing happens.</span>")
	log_debug("shotgun: attempt to saw-off shotgun with no saw-off behavior.")

/obj/item/gun/projectile/shotgun/pump
	name = "pump shotgun"
	desc = "An ubiquitous unbranded shotgun. Useful for sweeping alleys."
	desc_info = "This is a ballistic weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  After firing, you will need to pump the gun, by using the unique-action verb.  To reload, load more shotgun \
	shells into the gun."
	icon = 'icons/obj/guns/shotgun.dmi'
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	w_class = ITEMSIZE_LARGE
	force = 10
	flags = CONDUCT
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING|SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	handle_casings = HOLD_CASINGS
	fire_sound = 'sound/weapons/gunshot/gunshot_shotgun2.ogg'
	is_wieldable = TRUE
	var/recentpump = 0 // to prevent spammage
	var/rack_sound = 'sound/weapons/shotgun_pump.ogg'
	var/rack_verb = "pump"

/obj/item/gun/projectile/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/gun/projectile/shotgun/pump/unique_action(mob/living/user)
	if(jam_num)
		to_chat(user, SPAN_WARNING("\The [src] is jammed!"))
		return
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/gun/projectile/shotgun/pump/proc/pump(mob/M)
	if(!wielded)
		if(!do_after(M, 20, TRUE)) // have to stand still for 2 seconds instead of doing it instantly. bad idea during a shootout
			return

	playsound(M, rack_sound, 60, FALSE)
	to_chat(M, SPAN_NOTICE("You [rack_verb] \the [src]!"))

	if(chambered)//We have a shell in the chamber
		chambered.forceMove(get_turf(src)) //Eject casing
		playsound(src.loc, chambered.drop_sound, DROP_SOUND_VOLUME, FALSE, required_asfx_toggles = ASFX_DROPSOUND)
		chambered = null

	handle_pump_loading()

	update_maptext()
	update_icon()

/obj/item/gun/projectile/shotgun/pump/proc/handle_pump_loading()
	if(length(loaded))
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

/obj/item/gun/projectile/shotgun/pump/combat
	name = "combat shotgun"
	desc = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders."
	icon = 'icons/obj/guns/cshotgun.dmi'
	icon_state = "cshotgun"
	item_state = "cshotgun"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	max_shells = 7 //match the ammo box capacity, also it can hold a round in the chamber anyways, for a total of 8.
	ammo_type = /obj/item/ammo_casing/shotgun
	fire_sound = 'sound/weapons/gunshot/gunshot_shotgun.ogg'

/obj/item/gun/projectile/shotgun/pump/combat/sol
	name = "solarian combat shotgun"
	desc = "A compact combat shotgun manufactured by Zavodskoi Interstellar for the Solarian Armed Forces, the M63 is most frequently employed by assaulters fighting in close-quarters environments, though it is also uncommonly used as a defensive weapon by Navy crewmen. Chambered in 12 gauge."
	icon = 'icons/obj/guns/sol_shotgun.dmi'
	icon_state = "malella"
	item_state = "malella"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 3, TECH_ILLEGAL = 2)
	ammo_type = /obj/item/ammo_casing/shotgun/pellet

/obj/item/gun/projectile/shotgun/doublebarrel
	name = "double-barreled shotgun"
	desc = "A true classic."
	desc_info = "Use in hand to unload, alt click to change firemodes."
	icon = 'icons/obj/guns/dshotgun.dmi'
	icon_state = "dshotgun"
	item_state = "dshotgun"
	//SPEEDLOADER because rapid unloading.
	//In principle someone could make a speedloader for it, so it makes sense.
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = CYCLE_CASINGS
	max_shells = 2
	w_class = ITEMSIZE_LARGE
	force = 10
	flags = CONDUCT
	is_wieldable = TRUE
	var/has_wield_state = TRUE
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	fire_sound = 'sound/weapons/gunshot/gunshot_shotgun2.ogg'

	burst_delay = 0
	firemodes = list(
		list(mode_name="fire one barrel at a time", burst=1),
		list(mode_name="fire both barrels at once", burst=2)
		)

	can_sawoff = TRUE
	sawnoff_workmsg = "shorten the barrel"

/obj/item/gun/projectile/shotgun/doublebarrel/unique_action(mob/user)
	unload_ammo(user, TRUE)

/obj/item/gun/projectile/shotgun/doublebarrel/AltClick(mob/user)
	if(Adjacent(user))
		var/datum/firemode/new_mode = switch_firemodes(user)
		if(new_mode)
			to_chat(user, SPAN_NOTICE("\The [src] is now set to [new_mode.name]."))

/obj/item/gun/projectile/shotgun/doublebarrel/pellet
	ammo_type = /obj/item/ammo_casing/shotgun/pellet

/obj/item/gun/projectile/shotgun/doublebarrel/flare
	name = "signal shotgun"
	desc = "A double-barreled shotgun meant to fire signal flash shells."
	ammo_type = /obj/item/ammo_casing/shotgun/flash

/obj/item/gun/projectile/shotgun/doublebarrel/unload_ammo(user, allow_dump)
	..(user, allow_dump=1)

/obj/item/gun/projectile/shotgun/doublebarrel/saw_off(mob/user, obj/item/tool)
	icon = 'icons/obj/guns/sawnshotgun.dmi'
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	is_wieldable = FALSE
	w_class = ITEMSIZE_NORMAL
	force = 5
	slot_flags &= ~SLOT_BACK	//you can't sling it on your back
	slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
	name = "sawn-off shotgun"
	desc = "Omar's coming!"
	to_chat(user, "<span class='warning'>You shorten the barrel of \the [src]!</span>")

/obj/item/gun/projectile/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "Omar's coming!"
	icon = 'icons/obj/guns/sawnshotgun.dmi'
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	is_wieldable = FALSE
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	w_class = ITEMSIZE_NORMAL
	force = 5

/obj/item/gun/projectile/shotgun/foldable
	name = "foldable shotgun"
	desc = "A single-shot shotgun that can be folded for easy concealment."
	icon = 'icons/obj/guns/overunder.dmi'
	icon_state = "overunder"
	item_state = "overunder"
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 1
	caliber = "shotgun"
	fire_sound = 'sound/weapons/gunshot/gunshot_shotgun2.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	var/folded = TRUE

/obj/item/gun/projectile/shotgun/foldable/update_icon()
	if(folded)
		icon_state = initial(icon_state)
		item_state = icon_state
	else
		icon_state = "[initial(icon_state)]-d"
		item_state = "[initial(item_state)]-d"
	update_held_icon()

/obj/item/gun/projectile/shotgun/foldable/proc/toggle_folded(mob/living/user)
	folded = !folded
	if(folded)
		w_class = initial(w_class)
		slot_flags = initial(slot_flags)
		playsound(user, 'sound/weapons/sawclose.ogg', 60, 1)
	else
		w_class = ITEMSIZE_LARGE
		slot_flags &= ~SLOT_BELT
		playsound(user, 'sound/weapons/sawopen.ogg', 60, 1)
	to_chat(user, "You [folded ? "fold" : "unfold"] \the [src].")
	update_icon()

/obj/item/gun/projectile/shotgun/foldable/unique_action(mob/living/user)
	toggle_folded(user)

/obj/item/gun/projectile/shotgun/foldable/special_check(mob/user)
	if(folded)
		toggle_folded(user)
		return FALSE
	return ..()
