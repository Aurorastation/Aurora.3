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
		examinate(user, A)
		return

	if(modifiers["alt"])
		var/obj/item/mecha_equipment/ME = A
		if(istype(ME))
			ME.attack_self(user)
			setClickCooldown(5)
			return

	if(modifiers["ctrl"])
		var/obj/item/mecha_equipment/ME = A
		if(istype(ME))
			ME.CtrlClick(user)
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

	if(!checked_use_cell(arms.power_use * CELLRATE))
		to_chat(user, power == MECH_POWER_ON ? SPAN_WARNING("Error: Power levels insufficient.") : SPAN_WARNING("\The [src] is powered off."))
		return

	if(user != src)
		set_intent(user.a_intent)
		if(user.zone_sel)
			zone_sel.set_selected_zone(user.zone_sel.selecting, user)
		else
			zone_sel.set_selected_zone("chest", user)

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
	else if(istype(A, /obj/structure/inflatable/door) && a_intent == I_HELP) //allow mech to open inflatables
		var/obj/structure/inflatable/door/D = A
		D.TryToSwitchState(user)
		return
	else if(adj)
		setClickCooldown(arms ? arms.action_delay : 15)
		playsound(src.loc, arms.punch_sound, 45 + 25 * (arms.melee_damage / 50), -1 )
		if(ismob(A))
			var/mob/target = A
			user.attack_log += "\[[time_stamp()]\]<span class='warning'> Attacked [target.name] ([target.ckey]) with [arms] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(arms.damagetype)])</span>"
			src.attack_log += "\[[time_stamp()]\]<span class='warning'> [user] ([user.ckey]) attacked [target.name] ([target.ckey]) with [arms] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(arms.damagetype)])</span>"
			target.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [arms] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(arms.damagetype)])</font>"
			msg_admin_attack("[key_name(user, highlight_special = 1)] attacked [key_name(target, highlight_special = 1)] with [arms] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(arms.damagetype)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target) )
		return A.attack_generic(src, arms.melee_damage, "attacked")
	return

/mob/living/heavy_vehicle/setClickCooldown(var/timeout)
	var/old_next_move = next_move
	next_move = max(world.time + timeout, next_move)
	for(var/hardpoint in hardpoint_hud_elements)
		var/obj/screen/mecha/hardpoint/H = hardpoint_hud_elements[hardpoint]
		if(H)
			H.color = "#FF0000"
	if(next_move > old_next_move) // TIMER_OVERRIDE would not work here, because the smaller delays tend to be called after the longer ones
		addtimer(CALLBACK(src, PROC_REF(reset_hardpoint_color)), timeout)

/mob/living/heavy_vehicle/proc/reset_hardpoint_color()
	for(var/hardpoint in hardpoint_hud_elements)
		var/obj/screen/mecha/hardpoint/H = hardpoint_hud_elements[hardpoint]
		if(H)
			H.color = null

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
			var/obj/screen/mecha/hardpoint/H = hardpoint_hud_elements[hardpoint]
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
		if(!do_after(user, entry_speed))
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
	RegisterSignal(user, COMSIG_MOB_FACEDIR, PROC_REF(handle_user_turn))
	playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
	if(user.client) user.client.screen |= hud_elements
	LAZYDISTINCTADD(user.additional_vision_handlers, src)
	update_icon()
	SSmove_manager.stop_looping(src) // stop it from auto moving when the pilot gets in
	return 1

/mob/living/heavy_vehicle/proc/eject(var/mob/user, var/silent)
	if(!user || !(user in src.contents))
		return
	if(hatch_closed)
		if(hatch_locked)
			if(!silent) to_chat(user, "<span class='warning'>The [body.hatch_descriptor] is locked.</span>")
			return
		hud_open.toggled(FALSE)
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
		set_intent(I_HURT)
		LAZYREMOVE(pilots, user)
		UnregisterSignal(user, COMSIG_MOB_FACEDIR)
		UNSETEMPTY(pilots)

/mob/living/heavy_vehicle/proc/handle_user_turn(var/mob/living/user, var/direction)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom, relaymove), user, direction, TRUE)

/mob/living/heavy_vehicle/relaymove(var/mob/living/user, var/direction, var/turn_only = FALSE)
	if(!can_move(user))
		return

	if(hallucination >= EMP_MOVE_DISRUPT && prob(30))
		direction = pick(GLOB.cardinal)

	var/do_strafe = !isnull(user.facing_dir) && (legs.turn_delay <= legs.move_delay)
	if(!do_strafe && dir != direction)
		use_cell_power(legs.power_use * CELLRATE)
		if(legs && legs.mech_turn_sound)
			playsound(src.loc,legs.mech_turn_sound,40,1)
		if(world.time + legs.turn_delay > next_mecha_move)
			next_mecha_move = world.time + legs.turn_delay
		set_dir(direction)
		for(var/mob/pilot in pilots)
			pilot.set_dir(direction)
		if(istype(hardpoints[HARDPOINT_BACK], /obj/item/mecha_equipment/shield))
			var/obj/item/mecha_equipment/shield/S = hardpoints[HARDPOINT_BACK]
			if(S.aura)
				S.aura.dir = direction
				if(S.aura.dir == NORTH)
					S.aura.layer = MECH_UNDER_LAYER
				else
					S.aura.layer = ABOVE_MOB_LAYER
		update_icon()

	if(!turn_only)
		var/turf/target_loc = get_step(src, direction)
		if(!legs.can_move_on(loc, target_loc))
			return
		if(incorporeal_move)
			if(legs && legs.mech_step_sound)
				playsound(src.loc,legs.mech_step_sound,40,1)
			use_cell_power(legs.power_use * CELLRATE)
			user.client.Process_Incorpmove(direction, src)
		else
			var/new_direction = do_strafe ? user.facing_dir || direction : direction
			Move(target_loc, new_direction)

/mob/living/heavy_vehicle/Move()
	if(..() && !istype(loc, /turf/space))
		if(legs && legs.mech_step_sound)
			playsound(src.loc,legs.mech_step_sound,40,1)
		use_cell_power(legs.power_use * CELLRATE)
	update_icon()

/mob/living/heavy_vehicle/Post_Incorpmove()
	if(istype(hardpoints[HARDPOINT_BACK], /obj/item/mecha_equipment/phazon))
		var/obj/item/mecha_equipment/phazon/PZ = hardpoints[HARDPOINT_BACK]
		use_cell_power(PZ.active_power_use * CELLRATE)
	return ..()

/mob/living/heavy_vehicle/attackby(obj/item/attacking_item, mob/user)
	if(user.a_intent != I_HURT && istype(attacking_item, /obj/item/mecha_equipment))
		if(hardpoints_locked)
			to_chat(user, "<span class='warning'>Hardpoint system access is disabled.</span>")
			return

		var/obj/item/mecha_equipment/realThing = attacking_item
		if(realThing.owner)
			return

		var/free_hardpoints = list()
		for(var/hardpoint in hardpoints)
			if(hardpoints[hardpoint] == null)
				free_hardpoints += hardpoint
		var/to_place = tgui_input_list(user, "Where would you like to install it?", "Install Hardpoint", (realThing.restricted_hardpoints & free_hardpoints))
		if(install_system(attacking_item, to_place, user))
			return
		to_chat(user, "<span class='warning'>\The [attacking_item] could not be installed in that hardpoint.</span>")
		return

	else
		if(user.a_intent != I_HURT)
			if(istype(attacking_item, /obj/item/remote_mecha))
				if(length(pilots))
					to_chat(user, SPAN_WARNING("You can't apply this upgrade while \the [src] has occupants!"))
					return
				if(!maintenance_protocols)
					to_chat(user, SPAN_WARNING("You are unable to apply this upgrade while \the [src]'s maintenance protocols are not active."))
					return
				user.visible_message(SPAN_NOTICE("\The [user] begins installing \the [attacking_item] into \the [src]..."), SPAN_NOTICE("You begin installing the [attacking_item] into \the [src]..."))
				if(do_after(user, 30, src))
					if(length(pilots))
						to_chat(user, SPAN_WARNING("You can't apply this upgrade while \the [src] has occupants!"))
						return
					if(!maintenance_protocols)
						to_chat(user, SPAN_WARNING("You are unable to apply this upgrade while \the [src]'s maintenance protocols are not active."))
						return
					var/obj/item/remote_mecha/RM = attacking_item
					user.visible_message(SPAN_NOTICE("\The [user] installs \the [attacking_item] into \the [src]."), SPAN_NOTICE("You install the [attacking_item] into \the [src]."))
					remote_network = RM.mech_remote_network
					does_hardpoint_lock = RM.hardpoint_lock
					dummy_type = RM.dummy_path
					remote_type = RM.type
					become_remote()
					qdel(attacking_item)
			else if(attacking_item.ismultitool())
				if(hardpoints_locked)
					to_chat(user, "<span class='warning'>Hardpoint system access is disabled.</span>")
					return

				var/list/parts = list()
				for(var/hardpoint in hardpoints)
					if(hardpoints[hardpoint])
						parts += hardpoint

				var/to_remove = tgui_input_list(user, "Which component would you like to remove?", "Remove Component", parts)

				if(remove_system_interact(to_remove, user))
					return
				to_chat(user, "<span class='warning'>\The [src] has no hardpoint systems to remove.</span>")
				return

			else if(attacking_item.iswrench())
				if(!remote && length(pilots))
					to_chat(user, SPAN_WARNING("You can't disassemble \the [src] while it has a pilot!"))
					return
				if(!maintenance_protocols)
					to_chat(user, SPAN_WARNING("The securing bolts are not visible while maintenance protocols are disabled."))
					return
				user.visible_message(SPAN_NOTICE("\The [user] starts dismantling \the [src]..."), SPAN_NOTICE("You start disassembling \the [src]..."))
				if(do_after(user, 30, src))
					if(!remote && length(pilots))
						to_chat(user, SPAN_WARNING("You can't disassemble \the [src] while it has a pilot!"))
						return
					if(!maintenance_protocols)
						to_chat(user, SPAN_WARNING("The securing bolts are not visible while maintenance protocols are disabled."))
						return
					user.visible_message(SPAN_NOTICE("\The [user] dismantles \the [src]."), SPAN_NOTICE("You disassemble \the [src]."))
					if(remote)
						for(var/mob/pilot in pilots)
							if(pilot.client)
								pilot.body_return()
							hatch_locked = FALSE
							eject(pilot, TRUE)
							qdel(pilot)
							new remote_type(get_turf(src))
					dismantle()
					return
			else if(attacking_item.iswelder())
				if(!getBruteLoss())
					return
				var/list/damaged_parts = list()
				for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
					if(MC && MC.brute_damage)
						damaged_parts += MC
				var/obj/item/mech_component/to_fix = tgui_input_list(user, "Which component would you like to fix?", "Fix Component", damaged_parts)
				if(CanInteract(user, GLOB.physical_state) && !QDELETED(to_fix) && (to_fix in src) && to_fix.brute_damage)
					to_fix.repair_brute_generic(attacking_item, user)
				return
			else if(attacking_item.iscoil())
				if(!getFireLoss())
					return
				var/list/damaged_parts = list()
				for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
					if(MC && MC.burn_damage)
						damaged_parts += MC
				var/obj/item/mech_component/to_fix = tgui_input_list(user, "Which component would you like to fix?", "Fix Component", damaged_parts)
				if(CanInteract(user, GLOB.physical_state) && !QDELETED(to_fix) && (to_fix in src) && to_fix.burn_damage)
					to_fix.repair_burn_generic(attacking_item, user)
				return
			else if(attacking_item.iscrowbar())
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
				attacking_item.play_tool_sound(get_turf(src), 50)
				visible_message("<span class='notice'>\The [user] pries out \the [body.cell] using the \the [attacking_item].</span>")
				power = MECH_POWER_OFF
				hud_power_control.update_icon()
				body.cell = null
				return
			else if(istype(attacking_item, /obj/item/cell))
				if(!maintenance_protocols)
					to_chat(user, "<span class='warning'>The cell compartment remains locked while maintenance protocols are disabled.</span>")
					return
				if(!body || body.cell)
					to_chat(user, "<span class='warning'>There is already a cell in there!</span>")
					return

				if(user.unEquip(attacking_item))
					attacking_item.forceMove(body)
					body.cell = attacking_item
					to_chat(user, "<span class='notice'>You install \the [body.cell] into \the [src].</span>")
					playsound(user.loc, 'sound/items/Screwdriver.ogg', 50, 1)
					visible_message("<span class='notice'>\The [user] installs \the [body.cell] into \the [src].</span>")
				return
			else if(istype(attacking_item, /obj/item/device/robotanalyzer))
				to_chat(user, SPAN_NOTICE("Diagnostic Report for \the [src]:"))
				for(var/obj/item/mech_component/limb in list (head, body, arms, legs))
					if(limb)
						limb.return_diagnostics(user)
				return

	return ..()

/mob/living/heavy_vehicle/attack_hand(var/mob/user)
	// Drag the pilot out if possible.
	if(user.a_intent == I_GRAB)
		if(!LAZYLEN(pilots))
			to_chat(user, "<span class='warning'>There is nobody inside \the [src].</span>")
		else if(!hatch_closed)
			var/mob/pilot = pick(pilots)
			user.visible_message("<span class='danger'>\The [user] is trying to pull \the [pilot] out of \the [src]!</span>")
			if(do_after(user, 30) && user.Adjacent(src) && (pilot in pilots) && !hatch_closed)
				user.visible_message("<span class='danger'>\The [user] drags \the [pilot] out of \the [src]!</span>")
				eject(pilot, silent=1)

		return

	if(user.a_intent == I_HURT)
		attack_generic(user)
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

/mob/living/heavy_vehicle/attack_generic(var/mob/user, var/damage, var/attack_message, var/armor_penetration, var/attack_flags, var/damage_type = DAMAGE_BRUTE)
	if(!(user in pilots))
		. = ..()

		var/mob/living/carbon/human/H = user

		if(!istype(H))
			return

		var/datum/martial_art/attacker_style = H.primary_martial_art
		if(attacker_style && attacker_style.harm_act(H, src))
			return TRUE



/mob/living/heavy_vehicle/proc/attack_self(var/mob/user)
	return visible_message("\The [src] pokes itself.")

/mob/living/heavy_vehicle/get_inventory_slot(obj/item/I)
	for(var/h in hardpoints)
		if(hardpoints[h] == I)
			return h
	return 0

/var/global/datum/ui_state/default/mech_state = new()

/datum/ui_state/default/mech/can_use_topic(var/mob/living/heavy_vehicle/src_object, var/mob/user)
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
				attack_log += text("\[[time_stamp()]\] <span class='warning'>trampled [D.name] ([D.ckey]) with \the [src].</span>")
				msg_admin_attack("[src] trampled [key_name(D)] at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[D.x];Y=[D.y];Z=[D.z]'>JMP</a>)" )
				src.visible_message("<span class='danger'>\The [src] runs over \the [D]!</span>")
				D.apply_damage(legs.trample_damage, DAMAGE_BRUTE)
				return TRUE

		else
			var/mob/living/L = H
			src.visible_message("<span class='danger'>\The [src] runs over \the [L]!</span>")
			if(isanimal(L))
				if(issmall(L) && (L.stat == DEAD))
					L.gib()
					return TRUE
			L.apply_damage(legs.trample_damage, DAMAGE_BRUTE)
			return TRUE

/mob/living/heavy_vehicle/proc/ToggleLockdown()
	lockdown = !lockdown
	if(lockdown)
		src.visible_message("<span class='warning'>\The [src] beeps loudly as its servos sieze up, and it enters lockdown mode!</span>")
	else
		src.visible_message("<span class='warning'>\The [src] hums with life as it is released from its lockdown mode!</span>")

/mob/living/heavy_vehicle/get_floating_chat_x_offset()
	return -offset_x // reverse the offset

/mob/living/heavy_vehicle/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(can_listen())
		addtimer(CALLBACK(src, PROC_REF(handle_hear_say), speaker, message), 0.5 SECONDS)
	return ..()

// heavily commented so it doesn't look like one fat chunk of code, which it still does - Geeves
/mob/living/heavy_vehicle/proc/handle_hear_say(var/mob/speaker, var/text)
	var/found_text = findtext(text, name)
	if(!found_text && nickname)
		found_text = findtext(text, nickname)
	if(found_text)
		text = copytext(text, found_text) // I'm trimming the text each time so only information stated after eachother is valid

		// a quick way to figure out the remote control status of the mech
		if(findtext(text, "report diagnostics"))
			var/has_leader = FALSE
			if(leader)
				var/mob/resolved_leader = leader.resolve()
				if(!resolved_leader)
					say("Error, leader not found. Unassigning...")
					unassign_leader()
					return
				has_leader = TRUE
			say("Currently [has_leader ? "paired with [leader_name]" : "unpaired"].")
			if(following)
				var/mob/resolved_following = following.resolve()
				if(!resolved_following)
					say("Error, follow target not found. Unassigning...")
					unassign_following()
				else
					say("Currently following [resolved_following.name].")
			if(nickname)
				say("Nickname set to [nickname].")
			say("Maintenance protocols, [maintenance_protocols ? "active" : "disabled"].")
			return

		// Checking whether we have a leader or not
		if(!leader)
			if(!maintenance_protocols) // don't select a leader unless we have maintenance protocols set
				say("Maintenance protocols must be enabled to link.")
				return
			// If we have no leader, we listen to the keywords 'listen to'
			if(findtext(text, "listen to"))
				text = copytext(text, found_text)
				found_text = findtext(text, "me") // if they say listen to me, we listen to them
				if(found_text)
					assign_leader(speaker)
					say("New paired leader, [leader_name], confirmed and added to temporary biometric database.")
					return
				// check for humans and their IDs
				for(var/mob/living/carbon/human/H in view(world.view, src))
					var/obj/item/card/id/ID = H.GetIdCard(TRUE)
					if(ID?.registered_name) // we ID people based on their... ID
						if(findtext(text, ID.registered_name))
							assign_leader(H)
							say("New paired leader, [ID.registered_name], confirmed and added to temporary biometric database.")
							break
				return
		else
			var/mob/resolved_leader = leader.resolve()
			if(!resolved_leader)
				say("Error, leader not found. Unassigning...")
				unassign_leader()
				return
			if(speaker != resolved_leader && !(speaker in pilots))
				return

			found_text = findtext(text, "set nickname to")
			if(found_text)
				text = copytext(text, found_text + 15)
				text = prepare_nickname(text)
				if(lowertext(text) == "null")
					nickname = null
					say("Nickname removed.")
				else
					nickname = text
					say("Nickname set to [text].")
				return

			// simply toggle maintenance protocols
			if(findtext(text, "toggle maintenance protocols"))
				if(toggle_maintenance_protocols())
					say("Maintenance protocols toggled [maintenance_protocols ? "on" : "off"].")
				return

			// simply open or close the hatch
			if(findtext(text, "toggle hatch"))
				if(hatch_locked || force_locked)
					say("Hatch locked, cannot toggle status.")
					return
				if(toggle_hatch())
					say("Hatch [hatch_closed ? "closed" : "opened"].")
				return

			// simply toggle the lock status
			if(findtext(text, "toggle lock"))
				if(!hatch_closed)
					say("Hatch lock cannot be toggled while the hatch is open.")
					return
				if(force_locked)
					say("Hatch lock forced on, cannot override.")
					return
				if(toggle_lock())
					say("Hatch [hatch_locked ? "locked" : "unlocked"].")
				return

			// unlink the leader to get a new one
			if(findtext(text, "unlink"))
				if(!maintenance_protocols) // Can't lock yourself out
					say("Maintenance protocols must be enabled to unlink.")
					return

				unassign_leader()
				say("Leader dropped, awaiting new leader.")
				return

			// stop following who you were assigned to follow
			if(findtext(text, "stop"))
				unassign_following()
				SSmove_manager.stop_looping(src)
				say("Holding position.")
				return

			// set a follow range for the mecha, one to three, at which point it stops approaching
			found_text = findtext(text, "follow range")
			if(found_text)
				text = copytext(text, found_text)
				var/list/follow_range = list("one", "two", "three")
				for(var/i = 1 to length(follow_range))
					if(findtext(text, follow_range[i]))
						say("Follow range set to [follow_range[i]] units.")
						follow_distance = i
						break
				return

			// set who it has to follow, broken into two steps to make it more versatile
			found_text = findtext(text, "follow")
			if(found_text)
				text = copytext(text, found_text)
				found_text = findtext(text, "me")
				if(found_text)
					assign_following(speaker)
					say("Following [speaker.name].")
					return
				for(var/mob/living/carbon/human/H in view(world.view, src))
					var/obj/item/card/id/ID = H.GetIdCard(TRUE)
					if(ID?.registered_name) // we ID people based on their... ID
						if(findtext(text, ID.registered_name))
							assign_following(H)
							say("Following [ID.registered_name].")
							break
				return
