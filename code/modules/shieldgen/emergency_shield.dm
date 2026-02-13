/obj/machinery/shieldgen
	name = "emergency shield projector"
	desc = "Used to seal minor hull breaches."
	icon = 'icons/obj/machinery/shielding.dmi'
	icon_state = "shieldoff"
	density = TRUE
	opacity = FALSE
	anchored = FALSE
	req_access = list(ACCESS_ENGINE)
	var/health = 100
	var/active = FALSE
	/// Malfunction causes parts of the shield to slowly dissipate
	var/malfunction = FALSE
	var/list/deployed_shields = list()
	var/list/regenerating = list()
	/// Range at which it can project shields.
	var/range = 4
	panel_open = FALSE
	var/locked = FALSE
	/// Periodically recheck if we need to rebuild a shield.
	var/check_delay = 60
	use_power = POWER_USE_OFF
	idle_power_usage = 0

/obj/machinery/shieldgen/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "This machine's primary function is to project energy shields calibrated for atmospheric containment; these shields keep the air in and the vacuum out."
	. += "If activated while within <b>[range]</b> tiles of a 'space' turf, an 'open space' turf, or an otherwise 'airless' turf, it will automatically project shields there, making it extremely useful for containing hull breaches."
	. += "It will also project energy shields onto any engineering tape within range that has been toggled as a 'shield marker' using a multitool."
	. += "ALT-click the [src] to lock or unlock it (if you have the appropriate ID access)."

/obj/machinery/shieldgen/Destroy()
	collapse_shields()
	return ..()

/obj/machinery/shieldgen/proc/shields_up()
	if(active) return FALSE //If it's already turned on, how did this get called?

	src.active = TRUE
	update_icon()

	create_shields()

	var/shield_power_usage
	for(var/obj/machinery/shield/shield_tile in deployed_shields)
		shield_power_usage += shield_tile.shield_idle_power

	change_power_consumption(shield_power_usage, POWER_USE_IDLE)
	update_use_power(POWER_USE_IDLE)

/obj/machinery/shieldgen/proc/shields_down()
	if(!active) return FALSE //If it's already off, how did this get called?

	src.active = FALSE
	update_icon()

	collapse_shields()

	update_use_power(POWER_USE_OFF)

/obj/machinery/shieldgen/proc/create_shields()
	for(var/T in RANGE_TURFS(range, src))
		var/turf/target_tile = T
		if(locate(/obj/machinery/shield) in target_tile)
			continue
		var/obj/item/tape/engineering/E = locate() in target_tile
		if(E?.shield_marker)
			deploy_shield(target_tile)
		else if(istype(target_tile,/turf/space) || istype(target_tile,/turf/simulated/open) || istype(target_tile,/turf/simulated/floor/exoplanet/asteroid/ash) || istype(target_tile,/turf/simulated/floor/airless))
			if(malfunction && prob(33) || !malfunction)
				deploy_shield(target_tile)

/obj/machinery/shieldgen/proc/deploy_shield(var/turf/T)
	var/obj/machinery/shield/S = new /obj/machinery/shield(T)
	deployed_shields += S
	use_power_oneoff(S.shield_generate_power)

/obj/machinery/shieldgen/proc/collapse_shields()
	for(var/obj/machinery/shield/shield_tile in deployed_shields)
		qdel(shield_tile)
	QDEL_LIST(deployed_shields)

/obj/machinery/shieldgen/power_change()
	..()
	if(!active) return
	if(stat & NOPOWER)
		collapse_shields()
	else
		create_shields()
	update_icon()

/obj/machinery/shieldgen/process()
	if(stat & NOPOWER)
		if(active)
			visible_message(SPAN_WARNING("\The [src] shuts down due to a lack of power."), SPAN_NOTICE("You hear a heavy droning fade out."))
			active = FALSE
			collapse_shields()
		return

	if(malfunction)
		if(deployed_shields.len && prob(5))
			qdel(pick(deployed_shields))
	else
		if (check_delay <= 0)
			create_shields()

			var/new_power_usage = 0
			for(var/obj/machinery/shield/shield_tile in deployed_shields)
				new_power_usage += shield_tile.shield_idle_power

			if (new_power_usage != idle_power_usage)
				change_power_consumption(new_power_usage, POWER_USE_IDLE)
				use_power_oneoff(0)

			check_delay = 30
		else
			check_delay--

/obj/machinery/shieldgen/proc/checkhp()
	if(health <= 30)
		src.malfunction = TRUE
	if(health <= 0)
		spawn(0)
			explosion(get_turf(src.loc), 0, 0, 1, 0, 0, 0)
		qdel(src)
	update_icon()
	return

/obj/machinery/shieldgen/ex_act(severity)
	switch(severity)
		if(1.0)
			src.health -= 75
			src.checkhp()
		if(2.0)
			src.health -= 30
			if (prob(15))
				src.malfunction = 1
			src.checkhp()
		if(3.0)
			src.health -= 10
			src.checkhp()
	return

/obj/machinery/shieldgen/emp_act(severity)
	. = ..()

	switch(severity)
		if(EMP_HEAVY)
			src.health /= 2 //cut health in half
			malfunction = TRUE
			locked = pick(0,1)
		if(EMP_LIGHT)
			if(prob(50))
				src.health *= 0.3 //chop off a third of the health
				malfunction = TRUE
	checkhp()

/obj/machinery/shieldgen/attack_hand(mob/user)
	if(locked)
		to_chat(user, SPAN_WARNING("The machine is locked!"))
		return
	if(panel_open)
		to_chat(user, SPAN_WARNING("The panel must be closed before operating this machine."))
		return

	if (src.active)
		user.visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] [user] deactivates the shield generator."), \
			SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] You deactivate the shield generator."), \
			"You hear heavy droning fade out.")
		src.shields_down()
	else
		if(anchored)
			user.visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] [user] activate the shield generator."), \
				SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] You activate the shield generator."), \
				"You hear heavy droning.")
			src.shields_up()
		else
			to_chat(user, SPAN_WARNING("The device must first be secured to the floor."))
	return

/obj/machinery/shieldgen/emag_act(var/remaining_charges, var/mob/user)
	if(!malfunction)
		malfunction = TRUE
		update_icon()
		return TRUE

/obj/machinery/shieldgen/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour == TOOL_SCREWDRIVER)
		update_icon()
		attacking_item.play_tool_sound(get_turf(src), 50)
		if(panel_open)
			to_chat(user, SPAN_NOTICE("You close the panel."))
			panel_open = FALSE
		else
			to_chat(user, SPAN_NOTICE("You open the panel and expose the wiring."))
			panel_open = TRUE

	else if(attacking_item.tool_behaviour == TOOL_CABLECOIL && malfunction && panel_open)
		var/obj/item/stack/cable_coil/coil = attacking_item
		to_chat(user, SPAN_NOTICE("You begin to replace the wires."))
		//if(do_after(user, min(60, round( ((maxhealth/health)*10)+(malfunction*10) ))) //Take longer to repair heavier damage
		if(attacking_item.use_tool(src, user, 30, volume = 50))
			if (coil.use(1))
				health = initial(health)
				malfunction = FALSE
				to_chat(user, SPAN_NOTICE("You repair the [src]!"))
				update_icon()

	else if(attacking_item.tool_behaviour == TOOL_WRENCH)
		if(locked)
			playsound(src, 'sound/machines/terminal/terminal_error.ogg', 25, FALSE)
			balloon_alert(user, "locked!")
			return
		if(attacking_item.use_tool(src, user, 1 SECONDS, volume = 50))
			anchored = !anchored
			add_fingerprint(user)
			var/others_msg = anchored ? "<b>[user]</b> secures the external reinforcing bolts to the floor." : "<b>[user]</b> unsecures the external reinforcing bolts."
			var/self_msg = anchored ? "You secure the external reinforcing bolts to the floor." : "You unsecure the external reinforcing bolts."
			user.visible_message(others_msg, SPAN_NOTICE(self_msg), SPAN_NOTICE("You hear a ratcheting noise."))
			update_icon()
			return

	else
		..()

/obj/machinery/shieldgen/AltClick(mob/user)
	if(Adjacent(user))
		add_fingerprint(user)
		if(allowed(user))
			locked = !locked
			if(locked)
				playsound(src, 'sound/machines/terminal/terminal_button03.ogg', 35, FALSE)
			else
				playsound(src, 'sound/machines/terminal/terminal_button01.ogg', 35, FALSE)
			balloon_alert(user, locked ? "locked" : "unlocked")
		else
			to_chat(user, SPAN_WARNING("Access denied."))
			playsound(src, 'sound/machines/terminal/terminal_error.ogg', 25, FALSE)
			balloon_alert(user, "access denied!")

/obj/machinery/shieldgen/update_icon()
	ClearOverlays()
	if(anchored)
		AddOverlays("+bolts")
	if(active && !(stat & NOPOWER))
		src.icon_state = malfunction ? "shieldonbr":"shieldon"
	else
		src.icon_state = malfunction ? "shieldoffbr":"shieldoff"

/obj/machinery/shield
	name = "emergency energy shield"
	desc = "An energy shield used to contain hull breaches."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	unacidable = TRUE
	atmos_canpass = CANPASS_NEVER
	/// The shield can only take so much beating (prevents perma-prisons)
	var/health = 75
	/// How much power we use when first creating the shield
	var/shield_generate_power = 75 KILO WATTS
	/// How much power we use when just being sustained.
	var/shield_idle_power = 30 KILO WATTS

/obj/machinery/shield/malfai
	name = "emergency forcefield"
	desc = "A forcefield which seems to be projected by the station's emergency atmosphere containment field."
	health = 100

/obj/machinery/shield/malfai/New()
	..()
	desc = "A forcefield which seems to be projected by the [station_name(TRUE)]'s emergency atmosphere containment field."

/obj/machinery/shield/malfai/process()
	health -= 0.5 // Slowly lose integrity over time
	check_failure()

/obj/machinery/shield/proc/check_failure()
	var/health_percentage = (health / initial(health)) * 100
	switch(health_percentage)
		if(-INFINITY to 25)
			if(alpha != 150)
				animate(src, 1 SECOND, alpha = 150)
		if(26 to 50)
			if(alpha != 175)
				animate(src, 1 SECOND, alpha = 175)
		if(51 to 75)
			if(alpha != 210)
				animate(src, 1 SECOND, alpha = 210)
		if(76 to 90)
			if(alpha != 230)
				animate(src, 1 SECOND, alpha = 230)
		if(91 to INFINITY)
			if(alpha != initial(alpha))
				animate(src, 1 SECOND, alpha = initial(alpha))
	if(health <= 0)
		visible_message(SPAN_NOTICE("\The [src] dissipates!"))
		qdel(src)
		return

/obj/machinery/shield/New()
	src.set_dir(pick(1,2,3,4))
	..()
	update_nearby_tiles(need_rebuild=1)

/obj/machinery/shield/Destroy()
	opacity = FALSE
	density = FALSE
	update_nearby_tiles()
	return ..()

/obj/machinery/shield/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(mover?.movement_type & PHASING)
		return TRUE

	if(!height || air_group)
		return FALSE
	else
		return ..()

/obj/machinery/shield/attackby(obj/item/attacking_item, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src, attacking_item)
	//Calculate damage
	var/aforce = attacking_item.force
	if(attacking_item.damtype == DAMAGE_BRUTE || attacking_item.damtype == DAMAGE_BURN)
		health -= aforce

	//Play a fitting sound
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 75, 1)

	check_failure()

	..()

/obj/machinery/shield/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	health -= hitting_projectile.get_structure_damage()
	check_failure()
	opacity = 1
	spawn(20) if(src) opacity = FALSE

/obj/machinery/shield/ex_act(severity)
	switch(severity)
		if(1.0)
			if (prob(75))
				qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)
		if(3.0)
			if (prob(25))
				qdel(src)
	return

/obj/machinery/shield/emp_act(severity)
	. = ..()

	switch(severity)
		if(EMP_HEAVY)
			qdel(src)

		if(EMP_LIGHT)
			if(prob(50))
				qdel(src)

/obj/machinery/shield/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	//Let everyone know we've been hit!
	visible_message(SPAN_NOTICE("<B>\[src] was hit by [hitting_atom].</B>"))

	//Super realistic, resource-intensive, real-time damage calculations.
	var/tforce = 0
	if(ismob(hitting_atom))
		tforce = 40
	else if(isobj(hitting_atom))
		var/obj/O = hitting_atom
		tforce = O.throwforce

	src.health -= tforce

	//This seemed to be the best sound for hitting a force field.
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 100, 1)

	check_failure()

	//The shield becomes dense to absorb the blow.. purely asthetic.
	opacity = TRUE
	spawn(20) if(src) opacity = FALSE

	..()
	return
