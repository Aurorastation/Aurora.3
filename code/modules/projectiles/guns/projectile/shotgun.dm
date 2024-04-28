/obj/item/gun/projectile/shotgun
	name = "strange shotgun"
	desc = DESC_PARENT
	desc_info = "This is a shotgun, chambered for various shells and slugs. To fire the weapon, toggle the safety with CTRL-Click or enable 'HARM' intent, then click where \
	you want to fire. To pump a pump-action shotgun, use the Unique-Action hotkey or the button in the bottom right of your screen. To reload, insert shells or a magazine \
	into the shotgun, then pump the shotgun to chamber a fresh round."
	accuracy = -1
	accuracy_wielded = 1
	var/can_sawoff = FALSE
	var/sawnoff_workmsg
	var/sawing_in_progress = FALSE

/obj/item/gun/projectile/shotgun/attackby(obj/item/attacking_item, mob/user)
	if (!can_sawoff || sawing_in_progress)
		return ..()

	var/static/list/barrel_cutting_tools = typecacheof(list(
		/obj/item/surgery/circular_saw,
		/obj/item/melee/energy,
		/obj/item/gun/energy/plasmacutter	// does this even work?
	))
	if(is_type_in_typecache(attacking_item, barrel_cutting_tools) && w_class != 3)
		to_chat(user, "<span class='notice'>You begin to [sawnoff_workmsg] of \the [src].</span>")
		if(loaded.len)
			for(var/i in 1 to max_shells)
				Fire(user, user)	//will this work? //it will. we call it twice, for twice the FUN
			user.visible_message("<span class='danger'>\The [src] goes off!</span>", "<span class='danger'>\The [src] goes off in your face!</span>")
			return

		sawing_in_progress = TRUE
		if(attacking_item.use_tool(src, user, 30, volume = 50))	//SHIT IS STEALTHY EYYYYY
			sawing_in_progress = FALSE
			saw_off(user, attacking_item)
		else
			sawing_in_progress = FALSE
	else
		..()

// called on a SUCCESSFUL saw-off.
/obj/item/gun/projectile/shotgun/proc/saw_off(mob/user, obj/item/tool)
	to_chat(user, "<span class='notice'>You attempt to cut [src]'s barrel with [tool], but nothing happens.</span>")
	LOG_DEBUG("shotgun: attempt to saw-off shotgun with no saw-off behavior.")

/obj/item/gun/projectile/shotgun/pump
	name = "pump shotgun"
	desc = "An ubiquitous unbranded shotgun. Useful for sweeping alleys."
	desc_info = "This is a ballistic weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  After firing, you will need to pump the gun, by using the unique-action verb.  To reload, load more shotgun \
	shells into the gun."
	icon = 'icons/obj/guns/shotgun.dmi'
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 7 // max of 8
	w_class = ITEMSIZE_LARGE
	force = 15
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING|SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	handle_casings = HOLD_CASINGS
	fire_sound = 'sound/weapons/gunshot/gunshot_shotgun2.ogg'
	is_wieldable = TRUE
	var/rack_sound = /singleton/sound_category/shotgun_pump
	var/rack_verb = "pump"
	///Whether the item icon has a cycling animation
	var/cycle_anim = TRUE

/obj/item/gun/projectile/shotgun/pump/handle_maptext()
	var/ammo = length(loaded)
	if(ammo > 9)
		maptext_x = 12
	else
		maptext_x = 16
	var/ammo_display = "[ammo]+[chambered?.BB ? "1" : "0"]"
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">[ammo_display]</span>"

/obj/item/gun/projectile/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/gun/projectile/shotgun/pump/unique_action(mob/living/user)
	if(jam_num)
		to_chat(user, SPAN_WARNING("\The [src] is jammed!"))
		return
	pump(user)

/obj/item/gun/projectile/shotgun/pump/proc/pump(mob/M)
	playsound(M, rack_sound, 60, FALSE)
	to_chat(M, SPAN_NOTICE("You [rack_verb] \the [src]!"))
	if(cycle_anim)
		flick("[icon_state]-cycling", src)

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
	accuracy_wielded = 2
	max_shells = 13 // holds a max of 14 shells at once
	ammo_type = /obj/item/ammo_casing/shotgun
	fire_sound = 'sound/weapons/gunshot/gunshot_shotgun.ogg'
	cycle_anim = FALSE

/obj/item/gun/projectile/shotgun/pump/combat/sol
	name = "solarian combat shotgun"
	desc = "A compact combat shotgun manufactured by Zavodskoi Interstellar for the Solarian Armed Forces, the M63 is most frequently employed by assaulters fighting in close-quarters environments, though it is also uncommonly used as a defensive weapon by Navy crewmen. Chambered in 12 gauge."
	icon = 'icons/obj/guns/sol_shotgun.dmi'
	icon_state = "malella"
	item_state = "malella"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 3, TECH_ILLEGAL = 2)
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	cycle_anim = FALSE

/obj/item/gun/projectile/shotgun/doublebarrel
	name = "double-barreled shotgun"
	desc = "A true classic."
	icon = 'icons/obj/guns/dshotgun.dmi'
	icon_state = "dshotgun"
	item_state = "dshotgun"
	//SPEEDLOADER because rapid unloading.
	//In principle someone could make a speedloader for it, so it makes sense.
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = CYCLE_CASINGS
	max_shells = 2
	w_class = ITEMSIZE_LARGE
	force = 15
	obj_flags = OBJ_FLAG_CONDUCTABLE
	is_wieldable = TRUE
	var/has_wield_state = TRUE
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	fire_sound = 'sound/weapons/gunshot/gunshot_shotgun2.ogg'
	fire_delay = ROF_INTERMEDIATE

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
	accuracy = 0
	is_wieldable = FALSE
	w_class = ITEMSIZE_NORMAL
	force = 11
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
	accuracy = 0
	is_wieldable = FALSE
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	w_class = ITEMSIZE_NORMAL
	force = 11

/obj/item/gun/projectile/shotgun/foldable
	name = "foldable shotgun"
	desc = "A single-shot shotgun that can be folded for easy concealment."
	icon = 'icons/obj/guns/overunder.dmi'
	icon_state = "overunder"
	item_state = "overunder"
	accuracy = 0
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

/obj/item/gun/projectile/shotgun/foldable/cameragun
	name = "camera"
	desc = "A polaroid camera"
	icon = 'icons/obj/guns/cameragun.dmi'
	icon_state = "cameragun"
	item_state = "cameragun"
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	magazine_type = /obj/item/ammo_magazine/mc9mm
	allowed_magazines = list(/obj/item/ammo_magazine/mc9mm)
	fire_delay = ROF_PISTOL
	load_method = MAGAZINE
	max_shells = 12
	caliber = "9mm"
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)

/obj/item/gun/projectile/shotgun/foldable/cameragun/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += SPAN_NOTICE("Upon closer inspection, this is not a camera at all, but a 9mm firearm concealed inside the shell of one, which can be deployed by pressing a button.")

/obj/item/gun/projectile/shotgun/wallgun
	name = "wall gun"
	desc = "A small yet powerful shotgun of Unathi make."
	desc_extended = "The Moghesian wall gun, a classic Hegemonic weapon that saw plenty of service before and during the Contact War. This small-sized, break-action shotgun manages to pack a serious punch despite being barely larger than a pistol, however, it comes at the cost of extremely limited capacity. The wall gun is still produced and distributed nowadays, generally given to vehicle and ship crews and law enforcers."
	icon = 'icons/obj/guns/unathi_ballistics.dmi'
	icon_state = "wallgun"
	item_state = "wallgun"
	accuracy = 0
	is_wieldable = TRUE
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/shotgun/moghes
	load_method = SINGLE_CASING|SPEEDLOADER
	w_class = ITEMSIZE_NORMAL
	fire_delay = ROF_INTERMEDIATE
	force = 5
	max_shells = 1
	caliber = "shotgun"
	fire_sound = 'sound/weapons/gunshot/gunshot_shotgun2.ogg'
	handle_casings = HOLD_CASINGS
	///Whether the shotgun's chamber is open
	var/open = FALSE

/obj/item/gun/projectile/shotgun/wallgun/update_icon()
	if(open)
		icon_state = "wallgun-open"
	else
		icon_state = "wallgun"
	..()
/obj/item/gun/projectile/shotgun/wallgun/unique_action(mob/user)
	if(!open)
		open = TRUE
		update_icon()
		unload_ammo(user, TRUE)
	else
		open = FALSE
		update_icon()

/obj/item/gun/projectile/shotgun/wallgun/unload_ammo(user, allow_dump)
	if(open)
		..(user, allow_dump=1)

/obj/item/gun/projectile/shotgun/wallgun/load_ammo(obj/item/A, mob/user)
	if(!open)
		to_chat(user, SPAN_WARNING("You need to open the cover to load \the[src]."))
		return
	..()

/obj/item/gun/projectile/shotgun/wallgun/handle_post_fire(mob/user)
	..()
	if(wielded)
		return
	else
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.mob_size <10)
				H.visible_message(SPAN_WARNING("\The [src] flies out of \the [H]'s' hand!"), SPAN_WARNING("\The [src] flies out of your hand!"))
				H.drop_item(src)
				src.throw_at(get_edge_target_turf(src, GLOB.reverse_dir[H.dir]), 4, 4)

				var/obj/item/organ/external/LH = H.get_organ(BP_L_HAND)
				var/obj/item/organ/external/RH = H.get_organ(BP_R_HAND)

				if(H.hand)
					LH.take_damage(30)
				else
					RH.take_damage(30)
