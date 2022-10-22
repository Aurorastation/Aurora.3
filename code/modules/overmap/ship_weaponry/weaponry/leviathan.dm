/obj/machinery/ship_weapon/leviathan
	name = "leviathan zero-point artillery"
	desc = "A hulking structure made up of an insane amount of moving parts, components and capacitors. It has no branding other than the \"ZAT\" inscription on the sides."
	icon = 'icons/obj/machines/ship_guns/leviathan.dmi'
	icon_state = "weapon_off"
	special_firing_mechanism = TRUE
	max_damage = 10000

	projectile_type = /obj/item/projectile/ship_ammo/leviathan
	use_ammunition = FALSE
	heavy_firing_sound = 'sound/weapons/gunshot/ship_weapons/leviathan_fire.ogg'
	caliber = SHIP_CALIBER_ZTA
	firing_effects = FIRING_EFFECT_FLAG_THROW_MOBS|FIRING_EFFECT_FLAG_EXTREMELY_LOUD
	screenshake_type = SHIP_GUN_SCREENSHAKE_ALL_MOBS
	layer = ABOVE_MOB_LAYER

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
		for(var/mob/M in living_mob_list)
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
			for(var/mob/M in living_mob_list)
				if(AreConnectedZLevels(M.z, z) && (get_area(M) != get_area(src)))
					to_chat(M, SPAN_DANGER("<font size=4>A gigantic shock courses through the hull of the ship!</font>"))
			. = ..()
	else
		visible_message(SPAN_DANGER("<font size=4>\The [src]'s capacitors fizzle out!</font>"))
		. = FALSE
	disable()

/obj/machinery/ship_weapon/leviathan/process()
	if(firing)
		for(var/mob/M in living_mob_list)
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
	for(var/mob/living/L in living_mob_list)
		if(get_area(L) == get_area(src))
			sound_to(L, 'sound/effects/ship_weapons/leviathan_powerdown.ogg')
	visible_message(SPAN_DANGER("<font size=4>\The [src]'s humming comes to an abrupt halt.</font>"))
	update_use_power(POWER_USE_OFF)
	icon_state = "weapon_off"

/obj/machinery/ship_weapon/leviathan/enable()
	couple_to_smes()
	if(!smes)
		visible_message(SPAN_DANGER("\The [src] doesn't light up at all! Its maintenance display indicates there is no SMES to draw power from."))
		return
	for(var/mob/living/L in living_mob_list)
		if(get_area(L) == get_area(src))
			sound_to(L, 'sound/effects/ship_weapons/leviathan_powerup.ogg')
	visible_message(SPAN_DANGER("<font size=4>\The [src] lights up with a powerful hum...</font>"))
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
	caliber = SHIP_CALIBER_ZTA
	impact_type = SHIP_AMMO_IMPACT_ZTA
	overmap_icon_state = "heavy_pulse"

/obj/item/ship_ammunition/leviathan/Initialize()
	. = ..()
	set_light(3, 3, LIGHT_COLOR_PURPLE)

/obj/item/projectile/ship_ammo/leviathan
	name = "zero-point artillery beam"
	desc = "A concentrated stream of pure energy."
	icon_state = "pulse"
	damage = 10000
	armor_penetration = 1000
	penetrating = 100
	hitscan = TRUE

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
	desc = "An old-style lever that couples the Leviathan's capacitors. <span class='danger'>Flicking this will cause extreme power usage!</span>"
	icon = 'icons/obj/power.dmi'
	icon_state = "lever1"
	var/obj/machinery/ship_weapon/leviathan/ZTA
	var/toggled = FALSE

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
	if(!use_check_and_message(user, USE_DISALLOW_SILICONS) && !stat)
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

/obj/item/leviathan_key
	name = "leviathan activation key"
	desc = "A key made of hardlight used to activate the Leviathan. It is a software-controlled morphing key that uses self-replicating encryption: \
			it cannot be replicated at all. Most importantly, if it is stolen, it can simply be deactivated by the SCC. A marvel of modern technology!"
	icon = 'icons/obj/machines/ship_guns/zat_confirmation_terminals.dmi'
	icon_state = "cannon_key"

/obj/item/leviathan_case
	name = "leviathan key case"
	desc = "It contains the Leviathan's activation key. The case is made out of authentic ebony wood, while the cushioning on the inside is made of silk."
	icon = 'icons/obj/machines/ship_guns/zat_confirmation_terminals.dmi'
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
	if(!open)
		. = ..()
		return
	if(use_check_and_message(user))
		return
	if(LK)
		user.visible_message(SPAN_NOTICE("[user] retrieves \the [LK]."))
		user.put_in_hands(LK)
		LK = null
		icon_state = "key_case-e"

/obj/item/leviathan_case/attackby(obj/item/I, mob/user)
	. = ..()
	if(use_check_and_message(user))
		return
	if(!LK && open)
		if(istype(I, /obj/item/leviathan_key))
			var/obj/item/leviathan_key/key = I
			user.visible_message(SPAN_NOTICE("[user] puts \the [LK] back into \the [src]."))
			LK = key
			user.drop_from_inventory(key, src)
			icon_state = "key_case-o"
			
/obj/machinery/leviathan_safeguard
	name = "leviathan activation terminal"
	desc = "The terminal used to confirm if you really want to wipe someone out."
	icon = 'icons/obj/machines/ship_guns/zat_confirmation_terminals.dmi'
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

/obj/machinery/leviathan_safeguard/ex_act(severity)
	return

/obj/machinery/leviathan_safeguard/emp_act(severity)
	return

/obj/machinery/leviathan_safeguard/Destroy()
	QDEL_NULL(key)
	button = null
	return ..()
	
/obj/machinery/leviathan_safeguard/LateInitialize()
	if(current_map.use_overmap && !linked)
		var/my_sector = map_sectors["[z]"]
		if (istype(my_sector, /obj/effect/overmap/visitable))
			attempt_hook_up(my_sector)
	if(linked)
		linked.levi_safeguard = src
	for(var/obj/machinery/leviathan_button/LB in range(3, src))
		if(istype(LB))
			button = LB

/obj/machinery/leviathan_safeguard/proc/open()
	opened = TRUE
	flick("safeguard_opening", src)
	icon_state = "safeguard_open"

/obj/machinery/leviathan_safeguard/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/leviathan_key) && !key && !stat && !locked)
		var/obj/item/leviathan_key/LK = I
		if(use_check_and_message(user))
			return
		if(do_after(user, 1 SECOND))
			visible_message(SPAN_WARNING("[user] places \the [LK] inside \the [src]'s keyhole!"))
			key = LK
			user.drop_from_inventory(I, src)
			icon_state = "safeguard_open"
			playsound(src, 'sound/effects/ship_weapons/levi_key_insert.ogg')

/obj/machinery/leviathan_safeguard/attack_hand(mob/user)
	if(key && !stat && !locked)
		if(use_check_and_message(user))
			return
		if(do_after(user, 1 SECOND))
			visible_message(SPAN_WARNING("[user] twists \the [key]!"))
			flick("safeguard_locking", src)
			icon_state = "safeguard_locked"
			locked = TRUE
			playsound(src, 'sound/effects/ship_weapons/levi_key_twist.ogg')
			button.open()

/obj/machinery/leviathan_button
	name = "leviathan fire button"
	desc = "The button that controls the Leviathan's firing mechanism."
	icon = 'icons/obj/machines/ship_guns/zat_confirmation_terminals.dmi'
	icon_state = "button_closed"
	anchored = TRUE
	var/open = FALSE

/obj/machinery/leviathan_button/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/leviathan_button/LateInitialize()
	if(current_map.use_overmap && !linked)
		var/my_sector = map_sectors["[z]"]
		if (istype(my_sector, /obj/effect/overmap/visitable))
			attempt_hook_up(my_sector)

/obj/machinery/leviathan_button/ex_act(severity)
	return

/obj/machinery/leviathan_button/emp_act(severity)
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
			var/targeted_landmark = input(user, "Select an entry point.", "Leviathan Control") as null|anything in possible_entry_points
			if(!targeted_landmark && length(possible_entry_points))
				return
			var/obj/effect/landmark
			if(length(possible_entry_points))
			 landmark = possible_entry_points[targeted_landmark]
			if(do_after(user, 1 SECOND) && !use_check_and_message(user))
				playsound(src, 'sound/effects/ship_weapons/levi_button_press.ogg')
				visible_message(SPAN_DANGER("[user] presses \the [src]!"))
				for(var/obj/machinery/ship_weapon/leviathan/LT in linked.ship_weapons)
					if(istype(LT))
						LT.firing_command(linked.targeting, landmark)