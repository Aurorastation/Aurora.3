/obj/machinery/ship_weapon/leviathan
	name = "leviathan zero-point artillery"
	desc = "A hulking structure made up of an uncalculable amount of moving parts, components and capacitors. It has no branding other than the \"ZAT\" inscription on the sides."
	icon = 'icons/obj/machinery/ship_guns/leviathan.dmi'
	icon_state = "weapon_off"
	special_firing_mechanism = TRUE
	max_damage = 10000

	projectile_type = /obj/item/projectile/ship_ammo/leviathan
	use_ammunition = FALSE
	heavy_firing_sound = 'sound/weapons/gunshot/ship_weapons/leviathan_fire.ogg'
	caliber = SHIP_CALIBER_ZTA
	firing_effects = FIRING_EFFECT_FLAG_THROW_MOBS|FIRING_EFFECT_FLAG_EXTREMELY_LOUD
	screenshake_type = SHIP_GUN_SCREENSHAKE_ALL_MOBS
	layer = ABOVE_HUMAN_LAYER

	use_power = POWER_USE_OFF //Start off.
	idle_power_usage = 100 KILOWATTS
	active_power_usage = 20 MEGAWATTS
	var/obj/machinery/power/smes/buildable/smes

/obj/machinery/ship_weapon/leviathan/Destroy()
	smes = null
	return ..()

/obj/machinery/ship_weapon/leviathan/LateInitialize()
	. = ..()
	couple_to_smes()

/obj/machinery/ship_weapon/leviathan/ex_act(severity)
	return //Not happening bro.

/obj/machinery/ship_weapon/leviathan/firing_checks()
	if(use_power == POWER_USE_OFF)
		return FALSE
	if(!istype(smes))
		return FALSE
	if(firing)
		return FALSE
	. = ..()

/obj/machinery/ship_weapon/leviathan/pre_fire(atom/target, obj/effect/landmark/landmark)
	firing = TRUE
	icon_state = "weapon_on"
	visible_message(SPAN_DANGER("<font size=5>\The [src] begins lighting up with a powerful hum...</font>"))
	var/power_draw = smes.drain_power_simple(active_power_usage)
	if(power_draw >= active_power_usage)
		for(var/mob/M in GLOB.living_mob_list)
			if(AreConnectedZLevels(GET_Z(M), z))
				if(get_area(M) != get_area(src))
					to_chat(M, SPAN_DANGER("<font size=4>The ground below you starts shaking...</font>"))
				sound_to(M, sound('sound/weapons/gunshot/ship_weapons/leviathan_chargeup.ogg'))
		flick("weapon_charge", src)
		sleep(10 SECONDS)
		var/obj/item/ship_ammunition/leviathan/L = new()
		ammunition |= L
		if(!stat)
			visible_message(SPAN_DANGER("<font size=6>\The [src] fires, quaking the ground below you!</font>"))
			for(var/mob/M in GLOB.living_mob_list)
				if(AreConnectedZLevels(M.z, z) && (get_area(M) != get_area(src)))
					to_chat(M, SPAN_DANGER("<font size=4>A gigantic shock courses through the hull of the ship!</font>"))
			. = ..()
	else
		visible_message(SPAN_DANGER("<font size=4>\The [src]'s capacitors fizzle out!</font>"))
		. = FALSE
	disable()

/obj/machinery/ship_weapon/leviathan/process()
	if(firing)
		for(var/mob/M in GLOB.living_mob_list)
			if(AreConnectedZLevels(GET_Z(M), z))
				shake_camera(M, 3, 3)

/obj/machinery/ship_weapon/leviathan/power_change()
	. = ..()
	if((stat & NOPOWER) && .)
		disable()

/obj/machinery/ship_weapon/leviathan/update_use_power(new_use_power)
	. = ..()
	if(new_use_power == POWER_USE_OFF && (use_power != POWER_USE_OFF))
		disable()

/obj/machinery/ship_weapon/leviathan/disable()
	firing = FALSE
	if(use_power != POWER_USE_OFF)
		visible_message(SPAN_DANGER("<font size=4>\The [src]'s humming comes to an abrupt halt.</font>"))
		for(var/mob/living/L in GLOB.living_mob_list)
			if(AreConnectedZLevels(L.z, z))
				sound_to(L, 'sound/effects/ship_weapons/leviathan_powerdown.ogg')
				to_chat(L, SPAN_WARNING("The ground below you settles down, no longer vibrating."))
		update_use_power(POWER_USE_OFF)
	icon_state = "weapon_off"

/obj/machinery/ship_weapon/leviathan/enable()
	couple_to_smes()
	if(!smes)
		visible_message(SPAN_DANGER("\The [src] doesn't light up at all! Its maintenance display indicates there is no SMES to draw power from."))
		return
	visible_message(SPAN_DANGER("<font size=4>\The [src] lights up with a powerful hum...</font>"))
	for(var/mob/living/L in GLOB.living_mob_list)
		if(AreConnectedZLevels(L.z, z))
			sound_to(L, 'sound/effects/ship_weapons/leviathan_powerup.ogg')
			to_chat(L, SPAN_WARNING("The ground below you starts vibrating with a slight hum..."))
	update_use_power(POWER_USE_IDLE)
	icon_state = "weapon_on"

/obj/machinery/ship_weapon/leviathan/proc/couple_to_smes()
	if(smes)
		return
	var/list/obj/machinery/power/smes/candidates = list()
	for(var/obj/machinery/power/smes/S in SSmachinery.machinery)
		if(get_area(S) == get_area(src))
			candidates += S
	for(var/obj/machinery/power/smes/buildable/superconducting/SC in candidates)
		if(istype(SC))
			smes = SC
			return
	for(var/obj/machinery/power/smes/buildable/SM in candidates)
		if(istype(SM))
			smes = SM
			return

/obj/item/ship_ammunition/leviathan
	name = "zero-point artillery beam"
	desc = "A beam of pure energy."
	range = OVERMAP_PROJECTILE_RANGE_ULTRAHIGH
	caliber = SHIP_CALIBER_ZTA
	impact_type = SHIP_AMMO_IMPACT_ZTA
	overmap_icon_state = "heavy_pulse"

/obj/item/ship_ammunition/leviathan/Initialize()
	. = ..()
	set_light(3, 3, LIGHT_COLOR_PURPLE)

/obj/item/ship_ammunition/leviathan/get_speed()
	return 2

/obj/item/projectile/ship_ammo/leviathan
	name = "zero-point artillery beam"
	desc = "A concentrated stream of pure energy."
	icon_state = "pulse"
	damage = 10000
	armor_penetration = 1000
	penetrating = 100
	hitscan = TRUE
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_LASER_MEAT, BULLET_IMPACT_METAL = SOUNDS_LASER_METAL)

	muzzle_type = /obj/effect/projectile/muzzle/pulse
	tracer_type = /obj/effect/projectile/tracer/pulse
	impact_type = /obj/effect/projectile/impact/pulse

/obj/item/projectile/ship_ammo/leviathan/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	if(!is_landmark_hit)
		if(ismob(target))
			var/mob/M = target
			M.visible_message(SPAN_DANGER("<font size=6>[M] evaporates as they are engulfed by the beam!</font>"))
			M.dust()
			return
		explosion(target, 6, 6, 6)
	else
		target.visible_message(SPAN_DANGER("<font size=6>A giant, purple laser descends from the sky!</font>"))
		explosion(target, 30, 30, 30)

/obj/item/projectile/ship_ammo/leviathan/check_penetrate(atom/A)
	on_hit(A)
	return TRUE

/obj/machinery/zta_lever
	name = "activation lever"
	desc = "An old-style lever that couples the Leviathan's capacitors. <span class='danger'>Flicking this will result in extreme power usage!</span>"
	icon = 'icons/obj/power.dmi'
	icon_state = "lever1"
	var/obj/machinery/ship_weapon/leviathan/ZTA
	var/toggled = FALSE
	var/cooldown = 0

/obj/machinery/zta_lever/Initialize(mapload, d, populate_components, is_internal)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/zta_lever/LateInitialize()
	for(var/obj/machinery/ship_weapon/leviathan/cannon in get_area(src))
		ZTA = cannon
		break

/obj/machinery/zta_lever/Destroy()
	ZTA = null
	return..()

/obj/machinery/zta_lever/attack_hand(mob/user)
	if(!use_check_and_message(user, USE_DISALLOW_SILICONS) && !stat && (cooldown + 10 SECONDS < world.time))
		if(do_after(user, 1 SECOND))
			visible_message(SPAN_DANGER("[user] pulls \the [src] [toggled ? "up" : "down"]!"))
			toggled = !toggled
			switch(toggled)
				if(FALSE)
					flick("lever3", src)
					ZTA.disable()
					sleep(2)
					icon_state = "lever1"
				if(TRUE)
					flick("lever2", src)
					ZTA.enable()
					sleep(2)
					icon_state = "lever_down"
			playsound(src, 'sound/effects/spring.ogg', 100)
			cooldown = world.time

/obj/item/leviathan_key
	name = "leviathan activation key"
	desc = "A key made of hardlight used to activate the Leviathan. It is a software-controlled morphing key that uses self-replicating encryption: \
			it cannot be replicated at all. Most importantly, if it is stolen, it can simply be deactivated by the SCC. A marvel of modern technology! \
			If you're vain, you could also probably wear it as a necklace."
	icon = 'icons/obj/machinery/ship_guns/zat_confirmation_terminals.dmi'
	icon_state = "cannon_key"
	item_state = "cannon_key"
	contained_sprite = TRUE
	slot_flags = SLOT_MASK

/obj/item/leviathan_case
	name = "leviathan key case"
	desc = "It contains the Leviathan's activation key. The case is made out of authentic ebony wood, while the cushioning on the inside is made of silk."
	icon = 'icons/obj/machinery/ship_guns/zat_confirmation_terminals.dmi'
	icon_state = "key_case"
	var/open = FALSE
	var/obj/item/leviathan_key/LK

/obj/item/leviathan_case/Initialize()
	. = ..()
	LK = new(src)

/obj/item/leviathan_case/Destroy()
	QDEL_NULL(LK)
	return ..()

/obj/item/leviathan_case/attack_self(mob/user)
	if(use_check_and_message(user))
		return
	open = !open
	if(open)
		user.visible_message(SPAN_NOTICE("[user] opens \the [src]."))
		if(LK)
			icon_state = "key_case-o"
		else
			icon_state = "key_case-e"
	else
		user.visible_message(SPAN_NOTICE("[user] closes \the [src]."))
		icon_state = "key_case"

/obj/item/leviathan_case/attack_hand(mob/user)
	if(!open || !LK || !ishuman(loc))
		. = ..()
		return
	if(use_check_and_message(user, USE_FORCE_SRC_IN_USER))
		return
	if(LK)
		user.visible_message(SPAN_NOTICE("[user] retrieves \the [LK]."))
		user.put_in_hands(LK)
		LK = null
		icon_state = "key_case-e"

/obj/item/leviathan_case/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	if(use_check_and_message(user))
		return
	if(!LK && open)
		if(istype(attacking_item, /obj/item/leviathan_key))
			var/obj/item/leviathan_key/key = attacking_item
			user.visible_message(SPAN_NOTICE("[user] puts \the [key] back into \the [src]."))
			LK = key
			user.drop_from_inventory(key, src)
			icon_state = "key_case-o"

/obj/machinery/leviathan_safeguard
	name = "leviathan activation terminal"
	desc = "The terminal used to confirm if you really want to wipe someone out."
	icon = 'icons/obj/machinery/ship_guns/zat_confirmation_terminals.dmi'
	icon_state = "safeguard"
	anchored = TRUE
	density = TRUE
	var/opened = FALSE
	var/locked = FALSE
	var/obj/item/leviathan_key/key
	var/obj/machinery/leviathan_button/button

/obj/machinery/leviathan_safeguard/Initialize(mapload, d, populate_components, is_internal)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/leviathan_safeguard/LateInitialize()
	if(SSatlas.current_map.use_overmap && !linked)
		var/my_sector = GLOB.map_sectors["[z]"]
		if (istype(my_sector, /obj/effect/overmap/visitable))
			attempt_hook_up(my_sector)
	if(linked)
		ASSERT(isnull(linked.levi_safeguard)) //There should only ever be one
		linked.levi_safeguard = src
	for(var/obj/machinery/leviathan_button/LB in range(3, src))
		if(istype(LB))
			button = LB

/obj/machinery/leviathan_safeguard/Destroy()
	if(linked)
		linked.levi_safeguard = null

	QDEL_NULL(key)
	button = null

	. = ..()

/obj/machinery/leviathan_safeguard/ex_act(severity)
	return

/obj/machinery/leviathan_safeguard/emp_act(severity)
	. = ..()

	return

/obj/machinery/leviathan_safeguard/proc/open()
	opened = TRUE
	flick("safeguard_opening", src)
	icon_state = "safeguard_open"

/obj/machinery/leviathan_safeguard/attackby(obj/item/attacking_item, mob/user)
	if(!opened || locked)
		return
	if(istype(attacking_item, /obj/item/leviathan_key) && !key && !stat)
		var/obj/item/leviathan_key/LK = attacking_item
		if(use_check_and_message(user))
			return
		if(do_after(user, 1 SECOND))
			visible_message(SPAN_WARNING("[user] places \the [LK] inside \the [src]'s keyhole!"))
			key = LK
			user.drop_from_inventory(attacking_item, src)
			icon_state = "safeguard_open"
			playsound(src, 'sound/effects/ship_weapons/levi_key_insert.ogg', 50)

/obj/machinery/leviathan_safeguard/attack_hand(mob/user)
	if(key && !stat && opened && !locked)
		if(use_check_and_message(user))
			return
		if(do_after(user, 1 SECOND))
			visible_message(SPAN_WARNING("[user] twists \the [key]!"))
			flick("safeguard_locking", src)
			icon_state = "safeguard_locked"
			locked = TRUE
			playsound(src, 'sound/effects/ship_weapons/levi_key_twist.ogg', 50)
			button.open()

/obj/machinery/leviathan_button
	name = "leviathan fire button"
	desc = "The button that controls the Leviathan's firing mechanism."
	icon = 'icons/obj/machinery/ship_guns/zat_confirmation_terminals.dmi'
	icon_state = "button_closed"
	anchored = TRUE
	var/open = FALSE

/obj/machinery/leviathan_button/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/leviathan_button/LateInitialize()
	if(SSatlas.current_map.use_overmap && !linked)
		var/my_sector = GLOB.map_sectors["[z]"]
		if (istype(my_sector, /obj/effect/overmap/visitable))
			attempt_hook_up(my_sector)

/obj/machinery/leviathan_button/ex_act(severity)
	return

/obj/machinery/leviathan_button/emp_act(severity)
	. = ..()

	return

/obj/machinery/leviathan_button/proc/open()
	icon_state = "button_open"
	open = TRUE

/obj/machinery/leviathan_button/attack_hand(mob/user)
	set waitfor = FALSE
	if(open)
		if(use_check_and_message(user))
			return
		if(linked.targeting)
			var/list/obj/effect/possible_entry_points = list()
			if(istype(linked.targeting, /obj/effect/overmap/visitable))
				var/obj/effect/overmap/visitable/V = linked.targeting
				for(var/obj/effect/O in V.generic_waypoints)
					possible_entry_points[O.name] = O
				for(var/obj/effect/O in V.entry_points)
					possible_entry_points[O.name] = O
				possible_entry_points = sortList(possible_entry_points)
			if(istype(linked.targeting, /obj/effect/overmap/event))
				possible_entry_points += SHIP_HAZARD_TARGET
			var/targeted_landmark = tgui_input_list(user, "Select an entry point.", "Leviathan Control", possible_entry_points)
			if(!targeted_landmark && length(possible_entry_points))
				return
			var/obj/effect/landmark
			if(length(possible_entry_points) && !(targeted_landmark == SHIP_HAZARD_TARGET))
				landmark = possible_entry_points[targeted_landmark]
			if(do_after(user, 1 SECOND) && !use_check_and_message(user))
				playsound(src, 'sound/effects/ship_weapons/levi_button_press.ogg', 50)
				visible_message(SPAN_DANGER("[user] presses \the [src]!"))
				for(var/obj/machinery/ship_weapon/leviathan/LT in linked.ship_weapons)
					if(istype(LT))
						LT.firing_command(linked.targeting, landmark)
