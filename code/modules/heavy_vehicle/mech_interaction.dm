/mob/living/MouseDrop(atom/over)
	if(usr == src && usr != over)
		if(istype(over, /mob/living/heavy_vehicle))
			if(usr.mob_size >= MOB_SMALL && usr.mob_size <= 14)
				var/mob/living/heavy_vehicle/M = over
				if(M.enter(src))
					return
			else
				to_chat(usr, "<span class='warning'>You cannot pilot a mech of this size.</span>")
				return
	return ..()

/mob/living/heavy_vehicle/MouseDrop_T(atom/dropping, mob/user)
	var/obj/machinery/portable_atmospherics/canister/C = dropping
	if(istype(C))
		body.MouseDrop_T(dropping, user)
	else . = ..()

/mob/living/heavy_vehicle/MouseDrop_T(src_object, over_object, src_location, over_location, src_control, over_control, params, var/mob/user)
	if(!user || incapacitated() || user.incapacitated() || lockdown)
		return FALSE

	if(!(user in pilots) && user != src)
		return FALSE

	//This is handled at active module level really, it is the one who has to know if it's supposed to act
	if(selected_system)
		return selected_system.MouseDragInteraction(src_object, over_object, src_location, over_location, src_control, over_control, params, user)


/mob/living/heavy_vehicle/ClickOn(var/atom/A, params, var/mob/user)

	if(!user || incapacitated() || user.incapacitated() || lockdown)
		return

	if(!loc) return
	var/adj = A.Adjacent(src) // Why in the fuck isn't Adjacent() commutative.

	var/modifiers = params2list(params)
	if(modifiers["shift"])
		A.examine(user)
		return

	if(modifiers["alt"])
		if(selected_system)
			if(selected_system == A)
				selected_system.attack_self(user)
				setClickCooldown(5)
			return
	
	if(modifiers["ctrl"])
		if(selected_system)
			if(selected_system == A)
				selected_system.CtrlClick(user)
				setClickCooldown(5)
			return

	if(!(user in pilots) && user != src)
		return

	// Are we facing the target?
	if(!(get_dir(src, A) & dir))
		return

	if(!canClick())
		return

	if(!arms)
		to_chat(user, "<span class='warning'>\The [src] has no manipulators!</span>")
		setClickCooldown(3)
		return

	if(!arms.motivator || !arms.motivator.is_functional())
		to_chat(user, "<span class='warning'>Your motivators are damaged! You can't use your manipulators!</span>")
		setClickCooldown(15)
		return

	if(!(get_cell()?.checked_use(arms.power_use * CELLRATE)))
		to_chat(user, "<span class='warning'>Error: Power levels insufficient.</span>")

	if(user != src)
		a_intent = user.a_intent
		if(user.zone_sel)
			zone_sel.set_selected_zone(user.zone_sel.selecting)
		else
			zone_sel.set_selected_zone("chest")

	// You may attack the target with your exosuit FIST if you're malfunctioning.
	var/failed = FALSE
	if(emp_damage > EMP_ATTACK_DISRUPT && prob(emp_damage*2))
		to_chat(user, "<span class='warning'>The wiring sparks as you attempt to control the exosuit!</span>")
		failed = TRUE

	if(!failed)
		if(selected_system)
			if(selected_system == A)
				selected_system.attack_self(user)
				setClickCooldown(5)
				return

			// Mounted non-exosuit systems have some hacky loc juggling
			// to make sure that they work.
			var/system_moved = FALSE
			var/obj/item/temp_system
			var/obj/item/mecha_equipment/ME
			if(istype(selected_system, /obj/item/mecha_equipment))
				ME = selected_system
				temp_system = ME.get_effective_obj()
				if(temp_system in ME)
					system_moved = 1
					temp_system.forceMove(src)
			else
				temp_system = selected_system

			// Slip up and attack yourself maybe.
			failed = FALSE
			if(emp_damage>EMP_MOVE_DISRUPT && prob(10))
				failed = TRUE

			if(failed)
				var/list/other_atoms = orange(1, A)
				A = null
				while(LAZYLEN(other_atoms))
					var/atom/picked = pick_n_take(other_atoms)
					if(istype(picked) && picked.simulated)
						A = picked
						break
				if(!A)
					A = src
				adj = A.Adjacent(src)

			var/resolved

			if(adj) resolved = temp_system.resolve_attackby(A, src, params)
			if(!resolved && A && temp_system)
				var/mob/ruser = src
				if(!system_moved) //It's more useful to pass along clicker pilot when logic is fully mechside
					ruser = user
				temp_system.afterattack(A,ruser,adj,params)
			if(system_moved) //We are using a proxy system that may not have logging like mech equipment does
				log_and_message_admins("used [temp_system] targetting [A]", user, src.loc)
			//Mech equipment subtypes can add further click delays
			var/extra_delay = 0
			if(ME != null)
				ME = selected_system
				extra_delay = ME.equipment_delay
			setClickCooldown(arms ? arms.action_delay + extra_delay : 15 + extra_delay)
			if(system_moved)
				temp_system.forceMove(selected_system)
			return

	if(A == src)
		setClickCooldown(5)
		return attack_self(user)
	else if(adj)
		setClickCooldown(arms ? arms.action_delay : 15)
		playsound(src.loc, arms.punch_sound, 45 + 25 * (arms.melee_damage / 50), -1 )
		if(ismob(A))
			var/mob/target = A
			user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [target.name] ([target.ckey]) with [arms] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(arms.damagetype)])</font>"
			src.attack_log += "\[[time_stamp()]\]<font color='red'> [user] ([user.ckey]) attacked [target.name] ([target.ckey]) with [arms] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(arms.damagetype)])</font>"
			target.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [arms] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(arms.damagetype)])</font>"
			msg_admin_attack("[key_name(user, highlight_special = 1)] attacked [key_name(target, highlight_special = 1)] with [arms] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(arms.damagetype)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target) )
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

/mob/living/heavy_vehicle/proc/enter(var/mob/user, var/instant = FALSE)
	if(!user || user.incapacitated())
		return
	if(!user.Adjacent(src))
		return
	if(hatch_locked)
		to_chat(user, "<span class='warning'>The [body.hatch_descriptor] is locked.</span>")
		return
	if(hatch_closed)
		to_chat(user, "<span class='warning'>The [body.hatch_descriptor] is closed.</span>")
		return
	if(LAZYLEN(pilots) >= LAZYLEN(body.pilot_positions))
		to_chat(user, "<span class='warning'>\The [src] is occupied.</span>")
		return
	if(!instant)
		to_chat(user, "<span class='notice'>You start climbing into \the [src]...</span>")
		if(!do_after(user, 30))
			return
	if(!user || user.incapacitated())
		return
	if(hatch_locked)
		to_chat(user, "<span class='warning'>The [body.hatch_descriptor] is locked.</span>")
		return
	if(hatch_closed)
		to_chat(user, "<span class='warning'>The [body.hatch_descriptor] is closed.</span>")
		return
	if(LAZYLEN(pilots) >= LAZYLEN(body.pilot_positions))
		to_chat(user, "<span class='warning'>\The [src] is occupied.</span>")
		return
	to_chat(user, "<span class='notice'>You climb into \the [src].</span>")
	user.forceMove(src)
	LAZYDISTINCTADD(pilots, user)
	sync_access()
	update_pilot_overlay()
	playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
	user << sound('sound/mecha/nominal.ogg',volume=50)
	if(user.client) user.client.screen |= hud_elements
	LAZYDISTINCTADD(user.additional_vision_handlers, src)
	update_icon()
	update_pilot_overlay()
	return 1

/mob/living/heavy_vehicle/proc/sync_access()
	access_card.access = saved_access.Copy()
	if(sync_access)
		for(var/mob/pilot in pilots)
			var/obj/item/card/id/pilot_id = pilot.GetIdCard()
			if(pilot_id && pilot_id.access) access_card.access |= pilot_id.access
			to_chat(pilot, "<span class='notice'>Security access permissions synchronized.</span>")

/mob/living/heavy_vehicle/proc/eject(var/mob/user, var/silent)
	if(!user || !(user in src.contents))
		return
	if(hatch_closed)
		if(hatch_locked)
			if(!silent) to_chat(user, "<span class='warning'>The [body.hatch_descriptor] is locked.</span>")
			return
		hatch_closed = 0
		hud_open.update_icon()
		update_icon()
		if(!silent)
			to_chat(user, "<span class='notice'>You open the hatch and climb out of \the [src].</span>")
	else
		if(!silent)
			to_chat(user, "<span class='notice'>You climb out of \the [src].</span>")

	user.forceMove(get_turf(src))
	LAZYREMOVE(user.additional_vision_handlers, src)
	if(user.client)
		user.client.screen -= hud_elements
		user.client.eye = user
	if(user in pilots)
		a_intent = I_HURT
		LAZYREMOVE(pilots, user)
		UNSETEMPTY(pilots)
		update_pilot_overlay()
	return

/mob/living/heavy_vehicle/relaymove(var/mob/living/user, var/direction)

	if(world.time < next_move)
		return 0

	if(!user || incapacitated() || user.incapacitated() || lockdown)
		return

	if(!legs)
		to_chat(user, "<span class='warning'>\The [src] has no means of propulsion!</span>")
		next_move = world.time + 3 // Just to stop them from getting spammed with messages.
		return

	if(!legs.motivator || legs.total_damage > 45)
		to_chat(user, "<span class='warning'>Your motivators are damaged! You can't move!</span>")
		next_move = world.time + 15
		return

	next_move = world.time + legs.move_delay

	if(maintenance_protocols)
		to_chat(user, "<span class='warning'>Maintenance protocols are in effect.</span>")
		return

	var/obj/item/cell/C = get_cell()
	if(!C || !C.check_charge(legs.power_use * CELLRATE))
		to_chat(user, "<span class='warning'>The power indicator flashes briefly.</span>")
		return

	if(hallucination >= EMP_MOVE_DISRUPT && prob(30))
		direction = pick(cardinal)

	if(dir == direction)
		var/turf/target_loc = get_step(src, direction)
		if(!legs.can_move_on(loc, target_loc))
			return
		Move(target_loc, direction)
	else
		get_cell()?.use(legs.power_use * CELLRATE)
		if(legs && legs.mech_turn_sound)
			playsound(src.loc,legs.mech_turn_sound,40,1)
		next_move = world.time + legs.turn_delay
		set_dir(direction)
		update_icon()

/mob/living/heavy_vehicle/Move()
	if(..() && !istype(loc, /turf/space))
		if(legs && legs.mech_step_sound)
			playsound(src.loc,legs.mech_step_sound,40,1)
		get_cell()?.use(legs.power_use * CELLRATE)
	update_icon()

/mob/living/heavy_vehicle/attackby(var/obj/item/thing, var/mob/user)
	if(user.a_intent != I_HURT && istype(thing, /obj/item/mecha_equipment))
		if(hardpoints_locked)
			to_chat(user, "<span class='warning'>Hardpoint system access is disabled.</span>")
			return

		var/obj/item/mecha_equipment/realThing = thing
		if(realThing.owner)
			return

		var/free_hardpoints = list()
		for(var/hardpoint in hardpoints)
			if(hardpoints[hardpoint] == null)
				free_hardpoints += hardpoint
		var/to_place = input("Where would you like to install it?") as null|anything in (realThing.restricted_hardpoints & free_hardpoints)
		if(install_system(thing, to_place, user))
			return
		to_chat(user, "<span class='warning'>\The [thing] could not be installed in that hardpoint.</span>")
		return

	else
		if(user.a_intent != I_HURT)
			if(thing.ismultitool())
				if(hardpoints_locked)
					to_chat(user, "<span class='warning'>Hardpoint system access is disabled.</span>")
					return

				var/list/parts = list()
				for(var/hardpoint in hardpoints)
					if(hardpoints[hardpoint])
						parts += hardpoint

				var/to_remove = input("Which component would you like to remove") as null|anything in parts

				if(remove_system(to_remove, user))
					return
				to_chat(user, "<span class='warning'>\The [src] has no hardpoint systems to remove.</span>")
				return

			else if(thing.iswrench())
				if(!maintenance_protocols)
					to_chat(user, "<span class='warning'>The securing bolts are not visible while maintenance protocols are disabled.</span>")
					return
				to_chat(user, "<span class='notice'>You dismantle \the [src].</span>")
				dismantle()
				return
			else if(thing.iswelder())
				if(!getBruteLoss())
					return
				var/list/damaged_parts = list()
				for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
					if(MC && MC.brute_damage)
						damaged_parts += MC
				var/obj/item/mech_component/to_fix = input(user,"Which component would you like to fix?") as null|anything in damaged_parts
				if(CanInteract(user, physical_state) && !QDELETED(to_fix) && (to_fix in src) && to_fix.brute_damage)
					to_fix.repair_brute_generic(thing, user)
				return
			else if(thing.iscoil())
				if(!getFireLoss())
					return
				var/list/damaged_parts = list()
				for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
					if(MC && MC.burn_damage)
						damaged_parts += MC
				var/obj/item/mech_component/to_fix = input(user,"Which component would you like to fix?") as null|anything in damaged_parts
				if(CanInteract(user, physical_state) && !QDELETED(to_fix) && (to_fix in src) && to_fix.burn_damage)
					to_fix.repair_burn_generic(thing, user)
				return
			else if(thing.iscrowbar())
				if(!maintenance_protocols)
					to_chat(user, "<span class='warning'>The cell compartment remains locked while maintenance protocols are disabled.</span>")
					return
				if(!body || !body.cell)
					to_chat(user, "<span class='warning'>There is no cell here for you to remove!</span>")
					return
				var/delay = 10
				if(!do_after(user, delay) || !maintenance_protocols || !body || !body.cell)
					return

				user.put_in_hands(body.cell)
				to_chat(user, "<span class='notice'>You remove \the [body.cell] from \the [src].</span>")
				playsound(user.loc, 'sound/items/Crowbar.ogg', 50, 1)
				visible_message("<span class='notice'>\The [user] pries out \the [body.cell] using the \the [thing].</span>")
				body.cell = null
				return
			else if(istype(thing, /obj/item/cell))
				if(!maintenance_protocols)
					to_chat(user, "<span class='warning'>The cell compartment remains locked while maintenance protocols are disabled.</span>")
					return
				if(!body || body.cell)
					to_chat(user, "<span class='warning'>There is already a cell in there!</span>")
					return

				if(user.unEquip(thing))
					thing.forceMove(body)
					body.cell = thing
					to_chat(user, "<span class='notice'>You install \the [body.cell] into \the [src].</span>")
					playsound(user.loc, 'sound/items/Screwdriver.ogg', 50, 1)
					visible_message("<span class='notice'>\The [user] installs \the [body.cell] into \the [src].</span>")
				return

	return ..()

/mob/living/heavy_vehicle/attack_hand(var/mob/user)
	// Drag the pilot out if possible.
	if(user.a_intent == I_HURT || user.a_intent == I_GRAB)
		if(!LAZYLEN(pilots))
			to_chat(user, "<span class='warning'>There is nobody inside \the [src].</span>")
		else if(!hatch_closed)
			var/mob/pilot = pick(pilots)
			user.visible_message("<span class='danger'>\The [user] is trying to pull \the [pilot] out of \the [src]!</span>")
			if(do_after(user, 30) && user.Adjacent(src) && (pilot in pilots) && !hatch_closed)
				user.visible_message("<span class='danger'>\The [user] drags \the [pilot] out of \the [src]!</span>")
				eject(pilot, silent=1)
		return

	// Otherwise toggle the hatch.
	if(hatch_locked)
		to_chat(user, "<span class='warning'>The [body.hatch_descriptor] is locked.</span>")
		return
	hatch_closed = !hatch_closed
	to_chat(user, "<span class='notice'>You [hatch_closed ? "close" : "open"] the [body.hatch_descriptor].</span>")
	hud_open.update_icon()
	update_icon()
	return


/mob/living/heavy_vehicle/proc/attack_self(var/mob/user)
	return visible_message("\The [src] pokes itself.")

/mob/living/heavy_vehicle/get_inventory_slot(obj/item/I)
	for(var/h in hardpoints)
		if(hardpoints[h] == I)
			return h
	return 0

/var/global/datum/topic_state/default/mech_state = new()

/datum/topic_state/default/mech/can_use_topic(var/mob/living/heavy_vehicle/src_object, var/mob/user)
	if(istype(src_object))
		if(user in src_object.pilots)
			return ..()
	else return STATUS_CLOSE
	return ..()

/mob/living/heavy_vehicle/get_inventory_slot(obj/item/I)
	for(var/h in hardpoints)
		if(hardpoints[h] == I)
			return h
	return 0

/mob/living/heavy_vehicle/proc/rename(var/mob/user)
	if(user != src && !(user in pilots))
		return
	var/new_name = sanitize(input("Enter a new exosuit designation.", "Exosuit Name") as text|null, max_length = MAX_NAME_LEN)
	if(!new_name || new_name == name || (user != src && !(user in pilots)))
		return
	name = new_name
	to_chat(user, "<span class='notice'>You have redesignated this exosuit as \the [name].</span>")

/mob/living/heavy_vehicle/proc/trample(var/mob/living/H)
	if(!LAZYLEN(pilots))
		return
	if(!isliving(H))
		return

	if(legs?.trample_damage)
		if(ishuman(H))
			var/mob/living/carbon/human/D = H
			if(D.lying)
				D.attack_log += "\[[time_stamp()]\]<font color='orange'> Was trampled by [src]</font>"
				attack_log += text("\[[time_stamp()]\] <font color='red'>trampled [D.name] ([D.ckey]) with \the [src].</font>")
				msg_admin_attack("[src] trampled [key_name(D)] at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[D.x];Y=[D.y];Z=[D.z]'>JMP</a>)" )
				src.visible_message("<span class='danger'>\The [src] runs over \the [D]!</span>")
				D.apply_damage(legs.trample_damage, BRUTE)
				return TRUE

		else
			var/mob/living/L = H
			src.visible_message("<span class='danger'>\The [src] runs over \the [L]!</span>")
			if(isanimal(L))
				if(issmall(L) && (L.stat == DEAD))
					L.gib()
					return TRUE
			L.apply_damage(legs.trample_damage, BRUTE)
			return TRUE

/mob/living/heavy_vehicle/proc/ToggleLockdown()
	lockdown = !lockdown
	if(lockdown)
		src.visible_message("<span class='warning'>\The [src] beeps loudly as its servos sieze up, and it enters lockdown mode!</span>")
	else
		src.visible_message("<span class='warning'>\The [src] hums with life as it is released from its lockdown mode!</span>")
