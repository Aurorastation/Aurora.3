/obj/item/mecha_equipment/clamp
	name = "mounted clamp"
	desc = "A large, heavy industrial cargo loading clamp."
	icon_state = "mecha_clamp"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	w_class = WEIGHT_CLASS_HUGE
	var/carrying_capacity = 5
	var/list/obj/carrying = list()
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	var/list/afterattack_types = list(/obj/structure/closet, /obj/machinery/door/airlock)
	module_hints = list(
		"<b>Attack(Harm):</b> Swing the claw at a target to deal damage.",
		"<b>Attack(Non-Harm):</b> Shove the target backwards,",
		"<b>Left Click(Door):</b> Force open any door, even bolted and/or welded airlocks.",
		"<b>Left Click(Any other nonliving object):</b> Pick up the object, storing it inside the clamp. Each clamp can hold up to 5 objects.",
		"<b>Alt Click(Clamp):</b> Drop a selected held item.",
	)

/obj/item/mecha_equipment/clamp/resolve_attackby(atom/A, mob/user, click_params)
	if(is_type_in_list(A, afterattack_types) && owner)
		return FALSE
	return ..()

/obj/item/mecha_equipment/clamp/attack_hand(mob/user)
	if(owner && LAZYISIN(owner.pilots, user))
		if(!owner.hatch_closed && length(carrying))
			var/obj/chosen_obj = tgui_input_list(user, "Choose an object to grab.", "Clamp Claw", carrying)
			if(!chosen_obj)
				return
			if(user.put_in_active_hand(chosen_obj))
				owner.visible_message(SPAN_NOTICE("\The [user] carefully grabs \the [chosen_obj] from \the [src]."))
				carrying -= chosen_obj
	. = ..()

/obj/item/mecha_equipment/clamp/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(.)
		if(istype(target, /obj/machinery/door/firedoor))
			var/obj/machinery/door/firedoor/FD = target
			if(FD.blocked)
				FD.visible_message(SPAN_WARNING("\The [owner] begins prying on \the [FD]!"))
				if(do_after(user, 10 SECONDS, owner, (DO_DEFAULT & ~DO_USER_CAN_TURN) | DO_USER_UNIQUE_ACT, extra_checks = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(atom_maintain_position), FD, FD.loc)) && FD.blocked)
					playsound(FD, 'sound/effects/meteorimpact.ogg', 100, 1)
					playsound(FD, 'sound/machines/airlock_open_force.ogg', 100, 1)
					FD.blocked = FALSE
					INVOKE_ASYNC(FD, TYPE_PROC_REF(/obj/machinery/door/firedoor, open))
					FD.visible_message(SPAN_WARNING("\The [owner] tears \the [FD] open!"))
			else
				FD.visible_message(SPAN_WARNING("\The [owner] begins forcing \the [FD]!"))
				if(do_after(user, 4 SECONDS, owner, (DO_DEFAULT & ~DO_USER_CAN_TURN) | DO_USER_UNIQUE_ACT, extra_checks = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(atom_maintain_position), FD, FD.loc)) && !FD.blocked)
					if(FD.density)
						FD.visible_message(SPAN_WARNING("\The [owner] forces \the [FD] open!"))
						playsound(FD, 'sound/machines/airlock_open_force.ogg', 100, 1)
						INVOKE_ASYNC(FD, TYPE_PROC_REF(/obj/machinery/door/firedoor, open))
					else
						FD.visible_message(SPAN_WARNING("\The [owner] forces \the [FD] closed!"))
						playsound(FD, 'sound/machines/airlock_close_force.ogg', 100, 1)
						INVOKE_ASYNC(FD, TYPE_PROC_REF(/obj/machinery/door/firedoor, close))
			return
		else if(istype(target, /obj/machinery/door/airlock))
			if(istype(target, /obj/machinery/door/airlock/centcom))
				to_chat(user, SPAN_WARNING("You can't force these airlocks!"))
				return
			var/obj/machinery/door/airlock/AD = target
			if(!AD.operating)
				playsound(src.loc, 'sound/machines/hydraulic_long.ogg', 100, 1, ignore_walls = TRUE)
				if(AD.welded || AD.locked)
					AD.visible_message(SPAN_WARNING("\The [owner] begins prying on \the [AD]!"))
					var/time_to_open = 15 SECONDS
					if(AD.welded && AD.locked)
						time_to_open = 30 SECONDS
					if(do_after(user, time_to_open, owner, (DO_DEFAULT & ~DO_USER_CAN_TURN) | DO_USER_UNIQUE_ACT, extra_checks = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(atom_maintain_position), AD, AD.loc)))
						AD.welded = FALSE
						AD.locked = FALSE
						AD.update_icon()
						playsound(AD, 'sound/machines/airlock_open_force.ogg', 100, 1)
						AD.visible_message(SPAN_WARNING("\The [owner] tears \the [AD] open!"))
						INVOKE_ASYNC(AD, TYPE_PROC_REF(/obj/machinery/door/airlock, open), TRUE)
						break_door(AD)
				else
					AD.visible_message(SPAN_WARNING("\The [owner] begins forcing \the [AD]!"))
					if(do_after(user, 5 SECONDS, owner, (DO_DEFAULT & ~DO_USER_CAN_TURN) | DO_USER_UNIQUE_ACT, extra_checks = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(atom_maintain_position), AD, AD.loc)) && !(AD.operating || AD.welded || AD.locked))
						if(AD.density)
							INVOKE_ASYNC(AD, TYPE_PROC_REF(/obj/machinery/door/airlock, open), TRUE)
							playsound(AD, 'sound/machines/airlock_open_force.ogg', 100, 1)
							AD.visible_message(SPAN_DANGER("\The [owner] forces \the [AD] open!"))
							break_door(AD)
						else
							INVOKE_ASYNC(AD, TYPE_PROC_REF(/obj/machinery/door/airlock, close), TRUE)
							playsound(AD, 'sound/machines/airlock_close_force.ogg', 100, 1)
							AD.visible_message(SPAN_DANGER("\The [owner] forces \the [AD] closed!"))
							break_door(AD)
			return

		if(length(carrying) >= carrying_capacity)
			to_chat(user, SPAN_WARNING("\The [src] is fully loaded!"))
			return
		if(istype(target, /obj))
			var/obj/O = target
			if(O.buckled)
				return
			if(locate(/mob/living) in O)
				to_chat(user, SPAN_WARNING("You can't load living things into the cargo compartment."))
				return

			if(O.anchored)
				to_chat(user, SPAN_WARNING("\The [target] is firmly secured."))
				return


			owner.visible_message(SPAN_NOTICE("\The [owner] begins loading \the [O]."), intent_message = MACHINE_SOUND)
			if(do_after(user, 2 SECONDS, owner, (DO_DEFAULT & ~DO_USER_CAN_TURN) | DO_USER_UNIQUE_ACT, extra_checks = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(atom_maintain_position), O, O.loc)))
				O.forceMove(src)
				carrying += O
				owner.visible_message(SPAN_NOTICE("\The [owner] loads \the [O] into its cargo compartment."))

				//attacking - Cannot be carrying something, cause then your clamp would be full
		else if(istype(target,/mob/living))
			var/mob/living/M = target
			if(user.a_intent == I_HURT)
				admin_attack_log(user, M, "attempted to clamp [M] with [src] ", "Was subject to a clamping attempt.", ", using \a [src], attempted to clamp")
				owner.setClickCooldown(owner.arms ? owner.arms.action_delay * 3 : 30) //This is an inefficient use of your powers
				if(prob(15))
					owner.visible_message(SPAN_DANGER("[owner] swings its [src] in a wide arc at [target] but misses completely!"))
					return
				M.attack_generic(owner, (owner.arms ? owner.arms.melee_damage / 2 : 0), "slammed") //Honestly you should not be able to do this without hands, but still
				M.throw_at(get_edge_target_turf(owner ,owner.dir),5, 2)
				to_chat(user, SPAN_WARNING("You slam [target] with [src.name]."))
				owner.visible_message(SPAN_DANGER("[owner] slams [target] with the hydraulic clamp."))
			else
				step_away(M, owner)
				to_chat(user, SPAN_NOTICE("You push [target] out of the way."))
				owner.visible_message(SPAN_NOTICE("[owner] pushes [target] out of the way."))

/obj/item/mecha_equipment/clamp/proc/break_door(var/obj/machinery/door/airlock/Airlock)
	if(Airlock.bolt_cut_state == 2)
		return

	playsound(Airlock, 'sound/effects/meteorimpact.ogg', 100, 1, ignore_walls = TRUE)
	Airlock.visible_message(SPAN_DANGER("\The [Airlock]'s bolts give off a deafening mechanical screech as they are torn apart."))
	Airlock.bolt_cut_state = 2
	Airlock.set_broken()

/obj/item/mecha_equipment/clamp/attack_self(var/mob/user)
	. = ..()
	if(.)
		drop_carrying(user, TRUE)

/obj/item/mecha_equipment/clamp/CtrlClick(mob/user)
	if(owner)
		drop_carrying(user, FALSE)
	else
		..()

/obj/item/mecha_equipment/clamp/proc/drop_carrying(var/mob/user, var/choose_object)
	if(!length(carrying))
		to_chat(user, SPAN_WARNING("You are not carrying anything in \the [src]."))
		return
	var/obj/chosen_obj = carrying[1]
	if(choose_object)
		chosen_obj = tgui_input_list(user, "Choose an object to set down.", "Clamp Claw", carrying)
	if(!chosen_obj)
		return
	owner.visible_message(SPAN_NOTICE("\The [owner] unloads \the [chosen_obj]."))
	chosen_obj.forceMove(get_turf(src))
	carrying -= chosen_obj

/obj/item/mecha_equipment/clamp/get_hardpoint_status_value()
	if(length(carrying))
		return length(carrying)/carrying_capacity
	return null

/obj/item/mecha_equipment/clamp/get_hardpoint_maptext()
	if(length(carrying) == 1)
		return capitalize_first_letters(carrying[1].name)
	else if(length(carrying) > 1)
		return "Multiple Objects"
	. = ..()

/obj/item/mecha_equipment/clamp/uninstalled()
	if(length(carrying))
		for(var/obj/load in carrying)
			load.dropInto(get_turf(src))
			carrying -= load
	. = ..()

/obj/item/weldingtool/get_hardpoint_status_value()
	return (get_fuel()/max_fuel)

/obj/item/weldingtool/get_hardpoint_maptext()
	return "[get_fuel()]/[max_fuel]"

/obj/item/mecha_equipment/clamp/Destroy()
	QDEL_NULL_LIST(carrying)
	return ..()

/obj/item/mecha_equipment/mounted_system/plasmacutter
	name = "mounted plasma cutter"
	desc = "An industrial plasma cutter mounted onto the chassis of the mech. "
	icon_state = "mecha_plasmacutter"
	holding_type = /obj/item/gun/energy/plasmacutter/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	origin_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 4, TECH_ENGINEERING = 6, TECH_COMBAT = 3)
	module_hints = list(
		"<b>Left Click(Target):</b> Fire a plasma cutting beam in the target direction.",
		"In addition to dealing damage, the plasma cutter can also mine through rocks at a time.",
		"It also pierces through the target, striking an additional object behind the first one.",
	)

/obj/item/gun/energy/plasmacutter/mounted/mech
	use_external_power = TRUE

// A lot of this is copied from flashlights.
/obj/item/mecha_equipment/light
	name = "floodlight"
	desc = "An exosuit-mounted light."
	icon_state = "mech_floodlight"
	restricted_hardpoints = list(HARDPOINT_HEAD)
	mech_layer = MECH_GEAR_LAYER

	var/on = 0
	var/brightness_on = 12		//can't remember what the maxed out value is
	light_color = LIGHT_COLOR_TUNGSTEN
	light_wedge = LIGHT_WIDE
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	module_hints = list(
		"<b>Alt Click(Icon):</b> Light up a large area in front of the mech.",
	)

/obj/item/mecha_equipment/light/attack_self(var/mob/user)
	. = ..()
	if(.)
		toggle()
		to_chat(user, "You switch \the [src] [on ? "on" : "off"].")

/obj/item/mecha_equipment/light/proc/toggle()
	on = !on
	update_icon()
	owner.update_icon()
	active = on
	passive_power_use = on ? 0.1 KILO WATTS : 0

/obj/item/mecha_equipment/light/deactivate()
	if(on)
		toggle()
	..()

/obj/item/mecha_equipment/light/update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		set_light(brightness_on, 1)
	else
		icon_state = "[initial(icon_state)]"
		set_light(0)

/obj/item/mecha_equipment/light/uninstalled()
	on = FALSE
	update_icon()
	. = ..()

#define CATAPULT_SINGLE 1
#define CATAPULT_AREA   2

/obj/item/mecha_equipment/catapult
	name = "gravitational catapult"
	desc = "An exosuit-mounted gravitational catapult."
	icon_state = "mecha_teleport"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	var/mode = CATAPULT_SINGLE
	var/atom/movable/locked
	equipment_delay = 30 //Stunlocks are not ideal
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_MAGNET = 4)
	require_adjacent = FALSE

	///For when targetting a single object, will create a warp beam
	var/datum/beam = null
	var/max_dist = 6
	var/obj/effect/effect/warp/small/warpeffect = null

/obj/effect/ebeam/warp
	plane = WARP_EFFECT_PLANE
	appearance_flags = DEFAULT_APPEARANCE_FLAGS | TILE_BOUND | NO_CLIENT_COLOR
	z_flags = ZMM_IGNORE

/obj/effect/effect/warp/small
	plane = WARP_EFFECT_PLANE
	appearance_flags = PIXEL_SCALE | NO_CLIENT_COLOR
	icon = 'icons/effects/96x96.dmi'
	icon_state = "singularity_s3"
	pixel_x = -32
	pixel_y = -32
	z_flags = ZMM_IGNORE

/obj/item/mecha_equipment/catapult/proc/beamdestroyed()
	if(beam)
		UnregisterSignal(beam, COMSIG_QDELETING)
		beam = null
	if(locked)
		if(owner)
			for(var/pilot in owner.pilots)
				to_chat(pilot, SPAN_NOTICE("Lock on \the [locked] disengaged."))
		endanimation()
		locked = null
	//It's possible beam self destroyed, match active
	if(active)
		deactivate()

/obj/item/mecha_equipment/catapult/proc/endanimation()
	if(locked)
		animate(locked,pixel_y= initial(locked.pixel_y), time = 0)

/obj/item/mecha_equipment/catapult/get_hardpoint_maptext()
	var/string
	if(locked)
		string = locked.name + " - "
	if(mode == 1)
		string += "Pull"
	else string += "Push"
	return string

/obj/item/mecha_equipment/catapult/deactivate()
	. = ..()
	if(beam)
		QDEL_NULL(beam)

/obj/item/mecha_equipment/catapult/attack_self(var/mob/user)
	. = ..()
	if(.)
		mode = mode == CATAPULT_SINGLE ? CATAPULT_AREA : CATAPULT_SINGLE
		to_chat(user, SPAN_NOTICE("You set \the [src] to [mode == CATAPULT_SINGLE ? "single" : "multi"]-target mode."))
		update_icon()

/obj/item/mecha_equipment/catapult/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(.)
		equipment_delay = initial(equipment_delay)
		switch(mode)
			if(CATAPULT_SINGLE)
				if(!locked)
					equipment_delay = 5
					var/atom/movable/AM = target
					if(!istype(AM) || AM.anchored || !AM.simulated)
						to_chat(user, SPAN_NOTICE("Unable to lock on [target]."))
						return
					locked = AM
					beam = owner.Beam(BeamTarget = target, icon_state = "r_beam", maxdistance = max_dist, beam_type = /obj/effect/ebeam/warp)
					RegisterSignal(beam, COMSIG_QDELETING, PROC_REF(beamdestroyed))

					animate(target,pixel_y= initial(target.pixel_y) - 2,time=1 SECOND, easing = SINE_EASING, flags = ANIMATION_PARALLEL, loop = -1)
					animate(pixel_y= initial(target.pixel_y) + 2,time=1 SECOND)

					active=TRUE
					to_chat(user, SPAN_NOTICE("Locked onto \the [AM]."))
					return
				else if(target != locked)
					if(locked in view(owner))
						INVOKE_ASYNC(locked, TYPE_PROC_REF(/atom/movable, throw_at), target, 14, 1.5, owner)
						log_and_message_admins("used [src] to throw [locked] at [target].", user, owner.loc)
						endanimation()
						locked = null
						deactivate()
						owner.use_cell_power(active_power_use * CELLRATE)
					else
						locked = null
						to_chat(user, SPAN_NOTICE("Lock on \the [locked] disengaged."))
						deactivate()
			if(CATAPULT_AREA)
				if(!warpeffect)
					warpeffect = new
				warpeffect.forceMove(get_turf(target))
				var/matrix/start = matrix()
				start.Scale(0)
				var/matrix/end= matrix()
				end.Scale(1)
				warpeffect.alpha = 255
				warpeffect.transform = start
				animate(warpeffect,transform = end, alpha = 0, time= 1.25 SECONDS)
				addtimer(CALLBACK(warpeffect, /atom/movable/proc/forceMove, null), 1.25 SECONDS)

				var/list/atoms = list()
				if(isturf(target))
					atoms = range(target,3)
				else
					atoms = orange(target,3)
				for(var/atom/movable/A in atoms)
					if(A.anchored || !A.simulated)
						continue
					var/dist = 5 - get_dist(A, target)
					INVOKE_ASYNC(A, TYPE_PROC_REF(/atom/movable, throw_at), get_edge_target_turf(A,get_dir(target, A)), dist, 0.7, owner)

				log_and_message_admins("used [src]'s area throw on [target].", user, owner.loc)

				owner.use_cell_power(active_power_use * CELLRATE * 2) //bit more expensive to throw all

/obj/item/material/drill_head
	var/durability = 0
	name = "drill head"
	desc = "A replaceable drill head usually used in exosuit drills."
	icon_state = "drill_head"

/obj/item/material/drill_head/condition_hints(mob/user, distance, is_adjacent)
	. += ..()
	var/percentage = get_durability_percentage()
	var/descriptor = SPAN_DANGER("It looks close to breaking")
	if(percentage > 10)
		descriptor = SPAN_ALERT("It is very worn")
	if(percentage > 50)
		descriptor = SPAN_ALERT("It is fairly worn")
	if(percentage > 75)
		descriptor = SPAN_ALERT("It shows some signs of wear")
	if(percentage > 95)
		descriptor = SPAN_NOTICE("It shows no wear")

	. += descriptor

/obj/item/material/drill_head/Initialize(newloc, material_key)
	. = ..()
	durability = 2 * material.integrity

/obj/item/material/drill_head/proc/get_durability_percentage()
	return (durability * 100) / (2 * material.integrity)

/obj/item/mecha_equipment/drill
	name = "drill"
	desc = "This is the drill that'll pierce the heavens!"
	icon_state = "mecha_drill"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	equipment_delay = 10

	//Drill can have a head
	var/obj/item/material/drill_head/drill_head
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

	module_hints = list(
		"<b>Left Click(Target):</b> Attack the target with a drill.",
		"The drill is capable of destroying almost any structure, and can also destroy floors.",
		"Using the drill consumes some of its durability. When it runs out, a new drill head will have to be placed in the module.",
	)

/obj/item/mecha_equipment/drill/Initialize()
	. = ..()
	drill_head = new /obj/item/material/drill_head(src, DEFAULT_WALL_MATERIAL)//You start with a basic steel head

/obj/item/mecha_equipment/drill/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(drill_head)
			owner.visible_message(SPAN_WARNING("[owner] revs the [drill_head], menacingly."))
			playsound(get_turf(src), 'sound/mecha/mechdrill.ogg', 50, 1)

/obj/item/mecha_equipment/drill/get_hardpoint_maptext()
	if(drill_head)
		return "Integrity: [round(drill_head.get_durability_percentage())]%"
	return

/obj/item/mecha_equipment/drill/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(.)
		if(isobj(target))
			var/obj/target_obj = target
			if(target_obj.unacidable)
				return
		if(istype(target,/obj/item/material/drill_head))
			var/obj/item/material/drill_head/DH = target
			if(drill_head)
				owner.visible_message(SPAN_NOTICE("\The [owner] detaches the [drill_head] mounted on the [src]."))
				drill_head.forceMove(owner.loc)
			DH.forceMove(src)
			drill_head = DH
			owner.visible_message(SPAN_NOTICE("\The [owner] mounts the [drill_head] on the [src]."))
			return

		if(drill_head == null)
			to_chat(user, SPAN_WARNING("Your drill doesn't have a head!"))
			return

		owner.use_cell_power(active_power_use * CELLRATE)
		owner.visible_message(SPAN_DANGER("\The [owner] starts to drill \the [target]"), SPAN_WARNING("You hear a large drill."))

		var/T = target.loc

		//Better materials = faster drill!
		var/delay = max(5, 20 - drill_head.material.protectiveness)
		owner.setClickCooldown(delay) //Don't spamclick!
		if(do_after(user, delay, owner, (DO_DEFAULT & ~DO_USER_CAN_TURN) | DO_USER_UNIQUE_ACT, extra_checks = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(atom_maintain_position), target, target.loc)) && drill_head)
			if(src == owner.selected_system)
				if(drill_head.durability <= 0)
					drill_head.shatter()
					drill_head = null
					return
				if(istype(target, /turf/simulated/wall))
					var/turf/simulated/wall/W = target
					if(max(W.material.hardness, W.reinf_material ? W.reinf_material.hardness : 0) > drill_head.material.hardness)
						to_chat(user, SPAN_WARNING("\The [target] is too hard to drill through with this drill head."))
					target.ex_act(2)
					drill_head.durability -= 1
					log_and_message_admins("used [src] on the wall [W].", user, owner.loc)
				else if(istype(target, /turf/simulated/mineral))
					for(var/turf/simulated/mineral/M in range(owner,1))
						if(get_dir(owner,M)&owner.dir)
							M.GetDrilled()
							drill_head.durability -= 1
					if(owner.hardpoints.len)
						for(var/hardpoint in owner.hardpoints)
							var/obj/item/mecha_equipment/clamp/I = owner.hardpoints[hardpoint]
							if(!istype(I))
								continue
							var/obj/structure/ore_box/ore_box
							for(var/obj/structure/ore_box/box in I)
								ore_box = box
								break
							if(ore_box)
								for(var/obj/item/ore/ore in range(owner,1))
									if(get_dir(owner,ore)&owner.dir)
										ore.Move(ore_box)
				else if(istype(target, /turf/simulated/floor/exoplanet/asteroid))
					for(var/turf/simulated/floor/exoplanet/asteroid/M in range(owner,1))
						if(get_dir(owner,M)&owner.dir)
							M.gets_dug()
							drill_head.durability -= 1
					if(owner.hardpoints.len)
						for(var/hardpoint in owner.hardpoints)
							var/obj/item/mecha_equipment/clamp/I = owner.hardpoints[hardpoint]
							if(!istype(I))
								continue
							var/obj/structure/ore_box/ore_box
							for(var/obj/structure/ore_box/box in I)
								ore_box = box
								break
							if(ore_box)
								for(var/obj/item/ore/ore in range(owner,1))
									if(get_dir(owner,ore)&owner.dir)
										ore.Move(ore_box)
				else if(target.loc == T)
					target.ex_act(2)
					drill_head.durability -= 1
					log_and_message_admins("[src] used to drill [target].", user, owner.loc)

				playsound(get_turf(src), 'sound/mecha/mechdrill.ogg', 50, 1)

		else
			to_chat(user, SPAN_WARNING("You must stay still while the drill is engaged!"))
		return 1

/obj/item/mecha_equipment/mounted_system/flarelauncher
	name = "flare launcher"
	desc = "The SGL-6 Special grenade launcher has been retooled to fire lit flares for emergency illumination."
	icon_state = "mech_flaregun"
	holding_type = /obj/item/gun/launcher/mech/flarelauncher
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	module_hints = list(
		"<b>Left Click(Target):</b> Fire an illuminating signal flare at the target location.",
		"This weapon passively regenerates its ammunition using the mech's power supply.",
	)

/obj/item/gun/launcher/mech/flarelauncher
	name = "mounted flare launcher"
	desc = "The SGL-6 Special grenade launcher has been retooled to fire lit flares for emergency illumination."
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "smg"
	item_state = "smg"
	fire_sound = 'sound/items/flare.ogg'

	release_force = 5
	throw_distance = 7
	proj = 3
	max_proj = 3
	proj_gen_time = 400


/obj/item/gun/launcher/mech/flarelauncher/consume_next_projectile()
	if(proj < 1) return null
	var/obj/item/device/flashlight/flare/mech/g = new (src)
	proj--
	addtimer(CALLBACK(src, PROC_REF(regen_proj)), proj_gen_time, TIMER_UNIQUE)
	return g

/obj/item/device/flashlight/flare/mech/Initialize()
	fuel = rand(800, 1000) // Sorry for changing this so much but I keep under-estimating how long X number of ticks last in seconds.
	on = 1
	src.force = on_damage
	src.damtype = "fire"
	update_icon()
	START_PROCESSING(SSprocessing, src)
	. = ..()

// Kinda hacky, but hey, avoids some severe shitcode later on - geeves
/obj/item/mecha_equipment/sleeper/passenger_compartment
	name = "\improper mounted passenger compartment"
	desc = "An exosuit-mounted passenger compartment that can comfortably hold a single humanoid."
	icon_state = "mecha_passenger_open"
	mech_layer = MECH_GEAR_LAYER
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = null
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	passive_power_use = 15
	module_hints = list(
		"<b>Left Click(Living Target):</b> Load the target into the mech's onboard passenger compartment.",
		"<b>Alt Click(Icon):</b> Eject the contents of the compartment.",
	)

/obj/item/mecha_equipment/sleeper/passenger_compartment/uninstalled()
	. = ..()
	icon_state = "mecha_passenger_open"
	update_icon()
	owner.update_icon()

/obj/item/mecha_equipment/sleeper/passenger_compartment/attack_self(var/mob/user)
	if(!sleeper.occupant)
		to_chat(user, SPAN_WARNING("There's no one to eject!"))
	else
		visible_message(SPAN_NOTICE("\The [src] ejects [sleeper.occupant.name]."))
		sleeper.go_out()
		icon_state = "mecha_passenger_open"
		update_icon()
		owner.update_icon()
	return

/obj/item/mecha_equipment/sleeper/passenger_compartment/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(.)
		icon_state = "mecha_passenger"
		update_icon()
		owner.update_icon()

/obj/item/mecha_equipment/autolathe
	name = "mounted autolathe"
	desc = "A large, heavy industrial autolathe. Most of the exterior and interior is stripped, relying primarily on the structure of the exosuit."
	icon_state = "mecha_autolathe"
	on_mech_icon_state = "mecha_autolathe"
	restricted_hardpoints = list(HARDPOINT_BACK)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	var/obj/machinery/autolathe/mounted/lathe
	module_hints = list(
		"<b>Left Click (Target Materials):</b> Load materials into the autolathe.",
		"<b>Alt Click (Icon):</b> Open the autolathe's UI.",
	)

/obj/item/mecha_equipment/autolathe/get_hardpoint_maptext()
	if(lathe?.currently_printing)
		return lathe.currently_printing.recipe.name
	. = ..()

/obj/item/mecha_equipment/autolathe/Initialize()
	. = ..()
	lathe = new /obj/machinery/autolathe/mounted(src)

/obj/item/mecha_equipment/autolathe/installed()
	..()
	lathe.print_loc = owner

/obj/item/mecha_equipment/autolathe/uninstalled()
	lathe.print_loc = null
	..()

/obj/item/mecha_equipment/autolathe/Destroy()
	QDEL_NULL(lathe)
	return ..()

/obj/item/mecha_equipment/autolathe/attack_self(mob/user)
	. = ..()
	if(.)
		lathe.attack_hand(user)

/obj/item/mecha_equipment/autolathe/afterattack(atom/target, mob/living/user, inrange, params)
	. = ..()
	if(is_type_in_list(target, list(/obj/item/stack/material/steel, /obj/item/stack/material/glass, /obj/item/stack/material/aluminium, /obj/item/stack/material/lead, /obj/item/stack/material/plastic)))
		owner.visible_message(SPAN_NOTICE("\The [owner] loads \the [target] into \the [src]."))
		lathe.attackby(target, owner)

/obj/item/mecha_equipment/autolathe/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver() || attacking_item.ismultitool() || attacking_item.iswirecutter() || istype(attacking_item, /obj/item/storage/part_replacer))
		lathe.attackby(attacking_item, user)
		update_icon()
		return TRUE
	return ..()

/obj/item/mecha_equipment/autolathe/update_icon()
	if(lathe.panel_open)
		icon_state = "mecha_autolathe-open"
	else
		icon_state = initial(icon_state)

/obj/item/mecha_equipment/toolset
	name = "mounted toolset"
	desc = "A vast toolset that's built into an exosuit arm mount. When a power drill just isn't enough."
	icon_state = "mecha_toolset-screwdriverbit"
	on_mech_icon_state = "mecha_toolset"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	equipment_delay = 8

	//Drill can have a head
	var/obj/item/powerdrill/mech/mounted_tool
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

	module_hints = list(
		"<b>Alt Click (Icon):</b> Open a radial menu for selecting any desired tool.",
		"<b>Left Click (Target):</b> Use the currently selected tool on the target.",
	)

/obj/item/mecha_equipment/toolset/Initialize()
	. = ..()
	mounted_tool = new/obj/item/powerdrill/mech(src)

/obj/item/mecha_equipment/toolset/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(mounted_tool)
			var/list/options = list()
			for(var/tool_name in mounted_tool.tools)
				var/tool_sprite_name = replacetext(tool_name, "bit", "")
				var/image/radial_button = image('icons/obj/tools.dmi', tool_sprite_name)
				options[tool_name] = radial_button
			var/selected_tool = show_radial_menu(user, owner, options, radius = 42, tooltips = TRUE)
			if(!selected_tool)
				return
			mounted_tool.current_tool = 1
			for(var/tool in mounted_tool.tools)
				if(mounted_tool.tools[mounted_tool.current_tool] == selected_tool)
					break
				else
					mounted_tool.current_tool++
			update_icon()

/obj/item/mecha_equipment/toolset/update_icon()
	icon_state = "mecha_toolset-[mounted_tool.tools[mounted_tool.current_tool]]"

// to-do fix this thing being out of bounds
/obj/item/mecha_equipment/toolset/get_hardpoint_maptext()
	if(mounted_tool)
		var/tool_name = capitalize(replacetext(mounted_tool.tools[mounted_tool.current_tool], "bit", ""))
		return "Tool: [tool_name]"

/obj/item/mecha_equipment/toolset/isscrewdriver()
	return mounted_tool.tools[mounted_tool.current_tool] == "screwdriverbit"

/obj/item/mecha_equipment/toolset/iswrench()
	return mounted_tool.tools[mounted_tool.current_tool] == "wrenchbit"

/obj/item/mecha_equipment/toolset/iscrowbar()
	return mounted_tool.tools[mounted_tool.current_tool] == "crowbarbit"

/obj/item/powerdrill/mech
	name = "mounted toolset"
	tools = list(
		"screwdriverbit",
		"wrenchbit",
		"crowbarbit"
		)

/obj/item/mecha_equipment/quick_enter
	name = "rapid-entry system"
	desc = "A large back-mounted device with installed hydraulics, capable of quickly lifting the user into their piloting seat."
	icon_state = "mecha_quickie"
	restricted_hardpoints = list(HARDPOINT_BACK)
	w_class = WEIGHT_CLASS_HUGE
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	var/entry_speed_divisor = 6
	module_hints = list(
		"Allows a user to enter the mech 6 times faster.",
	)

/obj/item/mecha_equipment/quick_enter/installed()
	..()
	owner.entry_speed /= entry_speed_divisor

/obj/item/mecha_equipment/quick_enter/uninstalled()
	owner.entry_speed = initial(owner.entry_speed)
	..()

/obj/item/mecha_equipment/quick_enter/afterattack()
	return

/obj/item/mecha_equipment/quick_enter/attack_self()
	return

/obj/item/mecha_equipment/phazon
	name = "phazon bluespace transmission system"
	desc = "A large back-mounted device that grants the exosuit it's mounted to the ability to semi-shift into bluespace, allowing it to pass through dense objects."
	icon_state = "mecha_phazon"
	restricted_hardpoints = list(HARDPOINT_BACK)
	w_class = WEIGHT_CLASS_HUGE
	origin_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 6, TECH_BLUESPACE = 6)
	active_power_use = 88 KILO WATTS

	var/obj/item/anomaly_core/AC
	var/image/anomaly_overlay

	module_hints = list(
		"<b>Alt Click (Icon):</b> Become incorporeal, gaining the ability to move through walls unimpeded.",
		"This system consumes 88 kilowatts of power while active.",
	)

/obj/item/mecha_equipment/phazon/assembly_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(!AC)
		. += "It needs an anomaly core to function. You can install one by using a core on it."

/obj/item/mecha_equipment/phazon/disassembly_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(AC)
		. += "The anomaly core could be extracted if the securing <b>bolts</b> are undone."

/obj/item/mecha_equipment/phazon/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/anomaly_core))
		if(AC)
			to_chat(user, SPAN_WARNING("\The [src] already has an anomaly core installed!"))
			return TRUE
		user.drop_from_inventory(attacking_item, src)
		AC = attacking_item
		to_chat(user, SPAN_NOTICE("You insert \the [AC] into \the [src]."))
		anomaly_overlay = image(AC.icon, null, AC.icon_state)
		anomaly_overlay.pixel_y = 3
		AddOverlays(anomaly_overlay)
		return TRUE
	if(attacking_item.iswrench())
		if(!AC)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have an anomaly core installed!"))
			return TRUE
		to_chat(user, SPAN_NOTICE("You remove \the [AC] from \the [src]."))
		attacking_item.play_tool_sound(get_turf(src), 50)
		user.put_in_hands(AC)
		CutOverlays(anomaly_overlay)
		qdel(anomaly_overlay)
		AC = null
		if(owner)
			deactivate()
		return TRUE
	return ..()

/obj/item/mecha_equipment/phazon/attack_self(mob/user)
	. = ..()
	if(!.)
		return

	if(!AC)
		to_chat(user, SPAN_WARNING("\The [src] needs an anomaly core to function!"))
		return

	if(!owner.incorporeal_move)
		to_chat(user, SPAN_NOTICE("You fire up \the [src], semi-shifting into another plane of existence!"))
		owner.set_mech_incorporeal(INCORPOREAL_MECH)
	else
		to_chat(user, SPAN_NOTICE("You disable \the [src], shifting back into your normal reality."))
		owner.set_mech_incorporeal(INCORPOREAL_DISABLE)

/obj/item/mecha_equipment/phazon/deactivate()
	owner.set_mech_incorporeal(INCORPOREAL_DISABLE)
	..()

/obj/item/mecha_equipment/phazon/uninstalled()
	owner.set_mech_incorporeal(INCORPOREAL_DISABLE)
	..()

/obj/item/mecha_equipment/mounted_system/grenadecleaner
	name = "cleaner grenade launcher"
	desc = "The SGL-6CL grenade launcher is designed to launch primed cleaner grenades."
	icon_state = "mech_gl"
	holding_type = /obj/item/gun/launcher/mech/mountedgl/cl
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	module_hints = list(
		"<b>Left Click(Target):</b> Fire an cleaning grenade at the target location.",
		"This weapon passively regenerates its ammunition using the mech's power supply.",
	)
