/mob/living/MouseDrop(atom/over)
	if(usr == src && usr != over)
		if(istype(over, /mob/living/heavy_vehicle))
			if(usr.mob_size >= MOB_SMALL && usr.mob_size <= MOB_MEDIUM)
				var/mob/living/heavy_vehicle/M = over
				if(M.enter(src))
					return
			else
				usr << "<span class='warning'>You cannot pilot a mech of this size.</span>"
				return
	return ..()


/mob/living/heavy_vehicle/ClickOn(var/atom/A, var/params, var/mob/user)
	if(!user || incapacitated() || user.incapacitated())
		return

	if(!loc) return
	var/adj = A.Adjacent(src) // Why in the fuck isn't Adjacent() commutative.

	var/modifiers = params2list(params)
	if(modifiers["shift"])
		A.examine(user)
		return

	if(user != pilot && user != src)
		return

	if(!canClick())
		return

	face_atom(A)

	if(!arms)
		user << "<span class='warning'>\The [src] has no manipulators!</span>"
		setClickCooldown(3)
		return

	if(!arms.motivator) //TODO: Re-add !arms.is_component_functioning("motivator")
		user << "<span class='warning'>Your motivators are damaged! You can't use your manipulators!</span>"
		setClickCooldown(15)
		return

	// You may attack the target with your MECH FIST if you're malfunctioning.
	if(!((hallucination>EMP_ATTACK_DISRUPT) && prob(hallucination*2)))
		if(selected_system)
			if(selected_system == A)
				selected_system.attack_self(user)
				setClickCooldown(5)
				return

			// Mounted non-exosuit systems have some hacky loc juggling
			// to make sure that they work.
			var/system_moved
			var/obj/item/temp_system
			if(istype(selected_system, /obj/item/weapon/mecha_equipment))
				var/obj/item/weapon/mecha_equipment/ME = selected_system
				temp_system = ME.get_effective_obj()
				if(temp_system in ME)
					system_moved = 1
					temp_system.forceMove(src)
			else
				temp_system = selected_system

			// Slip up and attack yourself maybe.
			if(hallucination>EMP_MOVE_DISRUPT && prob(10))
				A = src
				adj = 1

			var/resolved
			if(adj) resolved = A.attackby(temp_system, src)
			if(!resolved && A && temp_system)
				temp_system.afterattack(A,src,adj,params)
			setClickCooldown(arms ? arms.action_delay : 15)
			if(system_moved)
				temp_system.forceMove(selected_system)
			return

	if(A == src)
		setClickCooldown(5)
		return attack_self(pilot)
	else if(adj)
		setClickCooldown(arms ? arms.action_delay : 15)
		return A.attack_generic(src, arms.melee_damage, "attacked")
	return

/mob/living/heavy_vehicle/proc/set_hardpoint(var/hardpoint_tag)
	clear_selected_hardpoint()
	if(hardpoints[hardpoint_tag])
		// Set the new system.
		selected_system = hardpoints[hardpoint_tag]
		selected_hardpoint = hardpoint_tag
		return 1 // The element calling this proc will set its own icon.
	return 0

/mob/living/heavy_vehicle/proc/clear_selected_hardpoint()

	if(selected_hardpoint)
		for(var/hardpoint in hardpoints)
			if(hardpoint != selected_hardpoint)
				continue
			var/obj/screen/movable/mecha/hardpoint/H = hardpoint_hud_elements[hardpoint]
			if(istype(H))
				H.icon_state = "hardpoint"
				break
		selected_system = null
	selected_hardpoint = null

/mob/living/heavy_vehicle/proc/enter(var/mob/user)
	if(!user || user.incapacitated())
		return
	if(!user.Adjacent(src))
		return
	if(hatch_locked)
		user << "<span class='warning'>The [body.hatch_descriptor] is locked.</span>"
		return
	if(hatch_closed)
		user << "<span class='warning'>The [body.hatch_descriptor] is closed.</span>"
		return
	if(pilot)
		user << "<span class='warning'>\The [src] is occupied.</span>"
		return
	user << "<span class='notice'>You start climbing into \the [src]...</span>"
	if(!do_after(user, 30))
		return
	if(!user || user.incapacitated())
		return
	if(hatch_locked)
		user << "<span class='warning'>The [body.hatch_descriptor] is locked.</span>"
		return
	if(hatch_closed)
		user << "<span class='warning'>The [body.hatch_descriptor] is closed.</span>"
		return
	if(pilot)
		user << "<span class='warning'>\The [src] is occupied.</span>"
		return
	user << "<span class='notice'>You climb into \the [src].</span>"
	user.forceMove(src)
	pilot = user
	sync_access()
	update_pilot_overlay()
	playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
	pilot << sound('sound/mecha/nominal.ogg',volume=50)
	if(user.client) user.client.screen |= hud_elements
	update_mecha_icon()
	return 1

/mob/living/heavy_vehicle/proc/sync_access()
	access_card.access = saved_access.Copy()
	if(!sync_access || !pilot) return
	var/obj/item/weapon/card/id/pilot_id = pilot.GetIdCard()
	if(pilot_id && pilot_id.access) access_card.access |= pilot_id.access
	pilot << "<span class='notice'>Security access permissions synchronized.</span>"

/mob/living/heavy_vehicle/proc/eject(var/mob/user, var/silent)
	if(!user || !(user in src.contents))
		return
	if(hatch_closed)
		if(hatch_locked)
			if(!silent) user << "<span class='warning'>The [body.hatch_descriptor] is locked.</span>"
			return
		hatch_closed = 0
		hud_open.update_icon()
		update_mecha_icon()
		if(!silent)
			user << "<span class='notice'>You open the hatch and climb out of \the [src].</span>"
	else
		if(!silent)
			user << "<span class='notice'>You climb out of \the [src].</span>"

	user.forceMove(get_turf(src))
	if(user.client)
		user.client.screen -= hud_elements
		user.client.eye = user
	if(user == pilot)
		zone_sel = null
		a_intent = I_HURT
		pilot = null
		update_pilot_overlay()
	return

/mob/living/heavy_vehicle/relaymove(var/mob/living/user, var/direction)

	if(world.time < next_move)
		return 0

	if(user != pilot || incapacitated() || user.incapacitated())
		return

	if(!legs)
		user << "<span class='warning'>\The [src] has no means of propulsion!</span>"
		next_move = world.time + 3 // Just to stop them from getting spammed with messages.
		return

	if(!legs.motivator) //TODO: Re-add !legs.is_component_functioning("motivator")
		user << "<span class='warning'>Your motivators are damaged! You can't move!</span>"
		next_move = world.time + 15
		return

	next_move = world.time + legs.move_delay

	if(maintenance_protocols)
		user << "<span class='warning'>Maintenance protocols are in effect.</span>"
		return

	if(hallucination >= EMP_MOVE_DISRUPT && prob(30))
		direction = pick(cardinal)

	if(dir == direction)
		var/turf/target_loc = get_step(src, direction)
		if(!legs.can_move_on(loc, target_loc))
			return
		Move(target_loc, direction)
	else
		playsound(src.loc,mech_turn_sound,40,1)
		set_dir(direction)

/mob/living/heavy_vehicle/Move()
	if(..() && !istype(loc, /turf/space))
		playsound(src.loc,mech_step_sound,40,1)

/mob/living/heavy_vehicle/attackby(var/obj/item/weapon/thing, var/mob/user)
	if(istype(thing, /obj/item/weapon/mecha_equipment))
		if(hardpoints_locked)
			user << "<span class='warning'>Hardpoint system access is disabled.</span>"
			return

		for(var/hardpoint in hardpoints)
			if(install_system(thing, hardpoint, user))
				return
		user << "<span class='warning'>\The [src] has no available, compatible hardpoints to use.</span>"
		return
	else
		if(user.a_intent != I_HURT)
			if(istype(thing, /obj/item/device/multitool))
				if(hardpoints_locked)
					user << "<span class='warning'>Hardpoint system access is disabled.</span>"
					return
				for(var/hardpoint in hardpoints)
					if(remove_system(hardpoint, user))
						return
				user << "<span class='warning'>\The [src] has no hardpoint systems to remove.</span>"
				return
			else if(istype(thing, /obj/item/weapon/wrench))
				if(!maintenance_protocols)
					user << "<span class='warning'>The securing bolts are not visible while maintenance protocols are disabled.</span>"
					return
				user << "<span class='notice'>You dismantle \the [src].</span>"
				dismantle()
				return
	return ..()

/mob/living/heavy_vehicle/attack_hand(var/mob/user)
	// Drag the pilot out if possible.
	if(user.a_intent == I_HURT || user.a_intent == I_GRAB)
		if(!pilot)
			user << "<span class='warning'>There is nobody inside \the [src].</span>"
		else if(!hatch_closed)
			user.visible_message("<span class='danger'>\The [user] is trying to pull \the [pilot] out of \the [src]!</span>")
			if(do_after(user, 30) && user.Adjacent(src) && pilot && !hatch_closed)
				user.visible_message("<span class='danger'>\The [user] drags \the [pilot] out of \the [src]!</span>")
				eject(pilot, silent=1)
		return

	// Otherwise toggle the hatch.
	if(hatch_locked)
		user << "<span class='warning'>The [body.hatch_descriptor] is locked.</span>"
		return
	hatch_closed = !hatch_closed
	user << "<span class='notice'>You [hatch_closed ? "close" : "open"] the [body.hatch_descriptor].</span>"
	hud_open.update_icon()
	update_mecha_icon()
	return


/mob/living/heavy_vehicle/proc/attack_self(var/mob/user)
	return visible_message("\The [src] pokes itself.")