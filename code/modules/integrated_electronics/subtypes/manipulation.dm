/obj/item/integrated_circuit/manipulation
	category_text = "Manipulation"

/obj/item/integrated_circuit/manipulation/weapon_firing
	name = "weapon firing mechanism"
	desc = "This somewhat complicated system allows one to slot in a gun, direct it towards a position, and remotely fire it."
	extended_desc = "The firing mechanism can slot in most ranged weapons, ballistic and energy.  \
	The first and second inputs need to be numbers.  They are coordinates for the gun to fire at, relative to the machine itself.  \
	The 'fire' activator will cause the mechanism to attempt to fire the weapon at the coordinates, if possible.  Note that the \
	normal limitations to firearms, such as ammunition requirements and firing delays, still hold true if fired by the mechanism."
	complexity = 20
	w_class = WEIGHT_CLASS_NORMAL
	size = 3
	inputs = list(
		"target X rel" = IC_PINTYPE_NUMBER,
		"target Y rel" = IC_PINTYPE_NUMBER
	)
	outputs = list()
	activators = list(
		"fire" = IC_PINTYPE_PULSE_IN
	)
	var/obj/item/gun/installed_gun
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 4)
	power_draw_per_use = 50 // The targeting mechanism uses this.  The actual gun uses its own cell for firing if it's an energy weapon.

/obj/item/integrated_circuit/manipulation/weapon_firing/Destroy()
	QDEL_NULL(installed_gun)
	. = ..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/gun))
		var/obj/item/gun/gun = attacking_item
		if(installed_gun)
			to_chat(user, SPAN_WARNING("There's already a weapon installed."))
			return
		user.drop_from_inventory(gun,src)
		installed_gun = gun
		size += gun.w_class
		to_chat(user, SPAN_NOTICE("You slide \the [gun] into the firing mechanism."))
		playsound(src.loc, SFX_CROWBAR, 50, 1)
	else
		..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attack_self(var/mob/user)
	if(installed_gun)
		installed_gun.forceMove(get_turf(src))
		to_chat(user, SPAN_NOTICE("You slide \the [installed_gun] out of the firing mechanism."))
		size = initial(size)
		playsound(loc, SFX_CROWBAR, 50, 1)
		installed_gun = null
	else
		to_chat(user, SPAN_NOTICE("There's no weapon to remove from the mechanism."))

/obj/item/integrated_circuit/manipulation/weapon_firing/do_work()
	if(!installed_gun)
		return

	var/target_x = get_pin_data(IC_INPUT, 1)
	var/target_y = get_pin_data(IC_INPUT, 2)

	if (!isnum(target_x) || !isnum(target_y) || !assembly)
		return

	target_x = round(target_x)
	target_y = round(target_y)

	if(target_x == 0 && target_y == 0) // Don't shoot ourselves.
		return

	var/turf/T = get_turf(assembly)
	var/Tx = T.x + target_x
	var/Ty = T.y + target_y
	if (Tx > world.maxx || Tx < 1 || Ty > world.maxy || Ty < 1)
		return	// Off the edge of the map.

	T = locate(Tx, Ty, T.z)

	if(!T)
		return

	installed_gun.Fire_userless(T)

/obj/item/integrated_circuit/manipulation/locomotion
	name = "locomotion circuit"
	desc = "This allows a machine to move in a given direction."
	icon_state = "locomotion"
	extended_desc = "The circuit accepts a 'dir' number as a direction to move towards.<br>\
	Pulsing the 'step towards dir' activator pin will cause the machine to move a meter in that direction, assuming it is not \
	being held, or anchored in some way.  It should be noted that the ability to move is dependant on the type of assembly that this circuit inhabits."
	w_class = WEIGHT_CLASS_NORMAL
	complexity = 20
//	size = 5
	inputs = list("direction" = IC_PINTYPE_DIR)
	outputs = list()
	activators = list("step towards dir" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 100

/obj/item/integrated_circuit/manipulation/locomotion/do_work()
	..()
	var/turf/T = get_turf(src)
	if(T && assembly)
		if(assembly.anchored || !assembly.can_move())
			return
		if(assembly.loc == T) // Check if we're held by someone.  If the loc is the floor, we're not held.
			var/datum/integrated_io/wanted_dir = inputs[1]
			if(isnum(wanted_dir.data))
				step(assembly, wanted_dir.data)


/obj/item/integrated_circuit/manipulation/grenade
	name = "grenade primer"
	desc = "This circuit comes with the ability to attach most types of grenades and prime them at will."
	extended_desc = "Time between priming and detonation is limited to between 1 to 12 seconds but is optional. \
					If unset, not a number, or a number less than 1 then the grenade's built-in timing will be used. \
					Beware: Once primed, there is no aborting the process!"
	icon_state = "grenade"
	complexity = 30
	size = 2
	inputs = list("detonation time" = IC_PINTYPE_NUMBER)
	outputs = list()
	activators = list("prime grenade" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 4)
	var/obj/item/grenade/attached_grenade
	var/pre_attached_grenade_type

/obj/item/integrated_circuit/manipulation/grenade/Initialize()
	. = ..()
	if(pre_attached_grenade_type)
		var/grenade = new pre_attached_grenade_type(src)
		attach_grenade(grenade)

/obj/item/integrated_circuit/manipulation/grenade/Destroy()
	if(attached_grenade && !attached_grenade.active)
		attached_grenade.dropInto(loc)
	detach_grenade()
	. = ..()

/obj/item/integrated_circuit/manipulation/grenade/attackby(obj/item/attacking_item, mob/user)
	var/obj/item/grenade/G = attacking_item
	if(istype(G))
		if(attached_grenade)
			to_chat(user, SPAN_WARNING("There is already a grenade attached!"))
		else if(user.unEquip(G, force=1))
			user.visible_message(SPAN_WARNING("\The [user] attaches \a [G] to \the [src]!"), SPAN_NOTICE("You attach \the [G] to \the [src]."))
			attach_grenade(G)
			G.forceMove(src)
	else
		..()

/obj/item/integrated_circuit/manipulation/grenade/attack_self(var/mob/user)
	if(attached_grenade)
		user.visible_message(SPAN_WARNING("\The [user] removes \an [attached_grenade] from \the [src]!"), SPAN_NOTICE("You remove \the [attached_grenade] from \the [src]."))
		user.put_in_any_hand_if_possible(attached_grenade) || attached_grenade.dropInto(loc)
		detach_grenade()
	else
		..()

/obj/item/integrated_circuit/manipulation/grenade/do_work()
	if(attached_grenade && !attached_grenade.active)
		var/datum/integrated_io/detonation_time = inputs[1]
		if(isnum(detonation_time.data) && detonation_time.data > 0)
			attached_grenade.det_time = between(1, detonation_time.data, 12) SECONDS
		attached_grenade.activate()
		var/atom/holder = loc
		log_and_message_admins("activated a grenade assembly. Last touches: Assembly: [holder.fingerprintslast] Circuit: [fingerprintslast] Grenade: [attached_grenade.fingerprintslast]")

// These procs do not relocate the grenade, that's the callers responsibility
/obj/item/integrated_circuit/manipulation/grenade/proc/attach_grenade(var/obj/item/grenade/G)
	attached_grenade = G
	RegisterSignal(attached_grenade, COMSIG_QDELETING, PROC_REF(detach_grenade))
	size += G.w_class
	desc += " \An [attached_grenade] is attached to it!"

/obj/item/integrated_circuit/manipulation/grenade/proc/detach_grenade()
	if(!attached_grenade)
		return
	UnregisterSignal(attached_grenade, COMSIG_QDELETING)
	attached_grenade = null
	size = initial(size)
	desc = initial(desc)

/obj/item/integrated_circuit/manipulation/grenade/frag
	pre_attached_grenade_type = /obj/item/grenade/frag
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 10)
	spawn_flags = null			// Used for world initializing, see the #defines above.

/obj/item/integrated_circuit/manipulation/grabber
	name = "grabber"
	desc = "A circuit with its own inventory for small/medium items, used to grab and store things."
	icon_state = "grabber"
	extended_desc = "The circuit accepts a reference to thing to be grabbed. It can store up to 10 things. Modes: 1 for grab. 0 for eject the first thing. -1 for eject all."
	w_class = WEIGHT_CLASS_TINY
	size = 3

	complexity = 10
	inputs = list("target" = IC_PINTYPE_REF,"mode" = IC_PINTYPE_NUMBER)
	outputs = list("first" = IC_PINTYPE_REF, "last" = IC_PINTYPE_REF, "amount" = IC_PINTYPE_NUMBER)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 50

/obj/item/integrated_circuit/manipulation/grabber/do_work()
	var/turf/T = get_turf(src)
	var/atom/movable/AM = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
	var/mode = get_pin_data(IC_INPUT, 2)
	if(mode == 1)
		if(AM.Adjacent(T))
			if(contents.len < 10)
				if(istype(AM,/obj/item))
					var/obj/item/A = AM
					if(A.w_class < WEIGHT_CLASS_NORMAL)
						AM.forceMove(src)
	if(mode == 0)
		if(contents.len)
			var/obj/item/U = contents[1]
			U.forceMove(T)
	if(mode == -1)
		if(contents.len)
			var/obj/item/U
			for(U in contents)
				U.forceMove(T)
	set_pin_data(IC_OUTPUT, 1, contents[1])
	set_pin_data(IC_OUTPUT, 2, contents[contents.len])
	set_pin_data(IC_OUTPUT, 3, src.contents.len)
	push_data()
	activate_pin(2)



/obj/item/integrated_circuit/manipulation/thrower
	name = "thrower"
	desc = "A compact launcher to throw things from inside or nearby tiles"
	extended_desc = "The first and second inputs need to be numbers.  They are coordinates to throw thing at, relative to the machine itself.  \
	The 'fire' activator will cause the mechanism to attempt to throw thing at the coordinates, if possible.  Note that the \
	projectile need to be inside the machine, or to be on an adjacent tile, and to be up to medium size."
	complexity = 15
	w_class = WEIGHT_CLASS_TINY
	size = 2
	inputs = list(
		"target X rel" = IC_PINTYPE_NUMBER,
		"target Y rel" = IC_PINTYPE_NUMBER,
		"projectile" = IC_PINTYPE_REF
		)
	outputs = list()
	activators = list(
		"fire" = IC_PINTYPE_PULSE_IN
	)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 4)
	power_draw_per_use = 50

/obj/item/integrated_circuit/manipulation/thrower/do_work()

	var/datum/integrated_io/target_x = inputs[1]
	var/datum/integrated_io/target_y = inputs[2]
	var/datum/integrated_io/projectile = inputs[3]
	if(!isweakref(projectile.data))
		return
	var/obj/item/A = projectile.data.resolve()
	if(A.anchored)
		return
	if(A.w_class>WEIGHT_CLASS_NORMAL)
		return
	var/turf/T = get_turf(src.assembly)
	var/turf/TP = get_turf(A)
	if(!(TP.Adjacent(T)))
		return
	if(src.assembly)
		if(isnum(target_x.data))
			target_x.data = round(target_x.data)
		if(isnum(target_y.data))
			target_y.data = round(target_y.data)

		if(target_x.data == 0 && target_y.data == 0)
			return

		// We need to do this in order to enable relative coordinates, as locate() only works for absolute coordinates.
		var/i
		if(target_x.data > 0)
			i = abs(target_x.data)
			while(i > 0)
				T = get_step(T, EAST)
				i--
		else
			i = abs(target_x.data)
			while(i > 0)
				T = get_step(T, WEST)
				i--

		i = 0
		if(target_y.data > 0)
			i = abs(target_y.data)
			while(i > 0)
				T = get_step(T, NORTH)
				i--
		else if(target_y.data < 0)
			i = abs(target_y.data)
			while(i > 0)
				T = get_step(T, SOUTH)
				i--

		if(!T)
			return

		A.forceMove(get_turf(src))
		A.throw_at(T, round(clamp(sqrt(target_x.data*target_x.data+target_y.data*target_y.data),0,8),1), 3, assembly)

/obj/item/integrated_circuit/manipulation/shocker
	name = "shocker circuit"
	desc = "Used to shock adjacent creatures with electricity."
	icon_state = "shocker"
	extended_desc = "The circuit accepts a reference to creature to shock. It can shock a target on adjacent tiles. \
	Severity determines the power draw and usage of each shock. It accepts values between 0 and 20. It has a 5 second cooldown."
	w_class = WEIGHT_CLASS_TINY
	complexity = 24
	inputs = list("target" = IC_PINTYPE_REF,"severity" = IC_PINTYPE_NUMBER)
	outputs = list()
	activators = list("shock" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 0
	var/shocktime

/obj/item/integrated_circuit/manipulation/shocker/on_data_written()
	var/s = get_pin_data(IC_INPUT, 2)
	power_draw_per_use = clamp(s,0,20)*20 // big power draw to shock large creatures

/obj/item/integrated_circuit/manipulation/shocker/do_work()
	..()
	var/turf/T = get_turf(src)
	var/mob/living/M = get_pin_data_as_type(IC_INPUT, 1, /mob/living)
	if(!istype(M)) //Invalid input
		return
	if(!T.Adjacent(M))
		return //Can't reach
	if(shocktime + (5 SECONDS) > world.time)
		to_chat(M, SPAN_DANGER("You feel a light tingle from [src]. Luckily it was charging!"))
		return
	else
		msg_admin_attack("An integrated circuit with a shocker circuit was used to shock [M.name] ([M.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
		to_chat(M, SPAN_DANGER("You feel a sharp shock from the [src]!"))
		spark(get_turf(M), 3, 1)
		M.stun_effect_act(0, clamp(get_pin_data(IC_INPUT, 2),0,20), null)
		shocktime = world.time
		return

/obj/item/integrated_circuit/manipulation/flasher
	name = "flasher circuit"
	desc = "Used to flash adjacent creatures."
	icon_state = "video_camera"
	extended_desc = "The circuit accepts a reference to creature to flash. It can shock a target on adjacent tiles. \
	Severity determines the power draw and duration of each flash. It accepts values between 1 and 4. It has a 5 second cooldown."
	w_class = WEIGHT_CLASS_TINY
	complexity = 24
	inputs = list("target" = IC_PINTYPE_REF,"severity" = IC_PINTYPE_NUMBER)
	outputs = list()
	activators = list("flash" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 0
	var/flashtime

/obj/item/integrated_circuit/manipulation/flasher/on_data_written()
	var/s = get_pin_data(IC_INPUT, 2)
	power_draw_per_use = clamp(s,1,4)*200 // big power draw to achieve a blinding flash

/obj/item/integrated_circuit/manipulation/flasher/do_work()
	..()
	var/turf/T = get_turf(src)
	var/mob/living/scanned_mob = get_pin_data_as_type(IC_INPUT, 1, /mob/living)
	if(!istype(scanned_mob)) //Invalid input
		return
	if(!T.Adjacent(scanned_mob))
		return //Can't reach
	if((flashtime + (5 SECONDS)) > world.time) // Cooldown
		visible_message(SPAN_WARNING("You see a weak flash from the [src]."))
	else
		var/flash_duration = clamp(get_pin_data(IC_INPUT, 2),1,4)

		scanned_mob.flash_act(length = flash_duration SECONDS)

		flashtime = world.time
		msg_admin_attack("An integrated circuit with a flasher was used to flash [scanned_mob.name] ([scanned_mob.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
		playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
		return

/obj/item/integrated_circuit/manipulation/portal_opener // basically a mini telescience setup, but consumes bluespace crystals, is one-way, only along cardinals and ordinals, cannot cross z-levels, and more imprecise (higher chance of getting beamed into a wall/table).
	name = "bluespace portal circuit"
	desc = "A miniaturised circuit that uses bluespace crystals to open a one-way bluespace portal. Costlier to use than a standard telescience set up, but portable."
	extended_desc = "The circuit can store 3 bluespace crystals; each crystal is 1 use. Power determines number of tiles jumped (max 50m). Lifespan determines how long the portal is there (3-15 sec). Imprecise with a high variance <b>(DANGER IN CLOSED SPACES!)</b>. It has a cooldown of 30 seconds."
	icon_state = "shocker"
	w_class = WEIGHT_CLASS_TINY
	size = 20
	complexity = 30 // needs a big assembly if you want to use this in any non-simplistic way
	inputs = list("direction" = IC_PINTYPE_DIR, "power" = IC_PINTYPE_NUMBER, "lifespan" = IC_PINTYPE_NUMBER)
	outputs = list("bluespace crystals stored" = IC_PINTYPE_NUMBER)
	activators = list("open portal" = IC_PINTYPE_PULSE_IN, "portal opened" = IC_PINTYPE_PULSE_OUT, "cannot open portal" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 100 // multiplied by up to 50 during on_data_written(). should slurp up power in smaller assemblies or those without power generation
	cooldown_per_use = 30 SECONDS // big cooldown
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 5)

	/// Lazylist of stored bluespace crystals stored in the device for amount checks/deletions.
	var/list/obj/item/bluespace_crystal/crystals

	/// Maximum number of crystals the circuit can store.
	var/max_crystals = 3

/obj/item/integrated_circuit/manipulation/portal_opener/Destroy()
	for(var/obj/item/bluespace_crystal/crystal in crystals)
		crystal.dropInto(get_turf(assembly))
	LAZYNULL(crystals)
	return ..()

/obj/item/integrated_circuit/manipulation/portal_opener/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/bluespace_crystal))
		if(LAZYLEN(crystals) >= max_crystals)
			to_chat(user, SPAN_WARNING("There are not enough crystal slots."))
			return

		user.visible_message("[user] inserts [attacking_item] into \the [src]'s crystal slot.", SPAN_NOTICE("You insert [attacking_item] into \the [src]'s crystal slot."))
		user.drop_item(src)
		LAZYADD(crystals, attacking_item)
		attacking_item.forceMove(null)
	else
		..()

/obj/item/integrated_circuit/manipulation/portal_opener/on_data_written()
	power_draw_per_use = round(between(100, 100*(get_pin_data(IC_INPUT, 2)), 5000), 50) // potentially big power draw for a maximum jump range
	..()

/obj/item/integrated_circuit/manipulation/portal_opener/do_work()
	if(!LAZYLEN(crystals) >= 1) // no crystals, no portal
		activate_pin(3)
		return

	var/turf/assembly_turf = get_turf(assembly)
	if(assembly_turf)
		// maffs
		var/proj_power = round(between(1, get_pin_data(IC_INPUT, 2), 50), 1) // max range of 50 metres
		var/proj_rotation = dir2angle(get_pin_data(IC_INPUT, 1)) // in degrees please
		var/proj_angle = 60

		var/datum/projectile_data/proj_data = projectile_trajectory(assembly_turf.x, assembly_turf.y, proj_rotation, proj_angle, proj_power)

		var/destination_x = clamp(round(proj_data.dest_x, 1), 1, world.maxx) // dont want to exit map
		var/destination_y = clamp(round(proj_data.dest_y, 1), 1, world.maxy)

		var/turf/portal_destination = locate(destination_x, destination_y, assembly_turf.z)

		// effects
		playsound(assembly.loc, 'sound/weapons/flash.ogg', 25, 1)
		spark(assembly, 5, GLOB.alldirs)

		// portal creation
		var/lifespan = between(30, SecondsToTicks(get_pin_data(IC_INPUT, 2)), 150)
		var/obj/effect/portal/our_portal = new /obj/effect/portal(assembly_turf, null, null, lifespan, 0)
		our_portal.set_target(portal_destination)
		our_portal.precision = 2 // very imprecise, 5x5 turf variance. best used in very open spaces
		our_portal.has_failed = FALSE

		// consume a bluespace crystal
		var/obj/item/bluespace_crystal/consumed_bsc = LAZYACCESS(crystals, 1)
		LAZYREMOVE(crystals, consumed_bsc)
		qdel(consumed_bsc)

		activate_pin(2)
	else
		activate_pin(3)

	set_pin_data(IC_OUTPUT, 1, LAZYLEN(crystals)) // set the bluespace crystals counter
	push_data()
	..()

/obj/item/integrated_circuit/manipulation/bubble_shield
	name = "bubble shield circuit"
	desc = "A large bubble shield generator circuit, like those found in atmospheric emergency shields... sans all the automated features."
	extended_desc = "Receives relative coordinates to project a shield upon (must be within 3 tiles). Strength determines shield hitpoints (range: 10-50). Lifespan given in seconds (range: 2-60 secs). Can only sustain 3 shields."
	icon_state = "power_transmitter"
	w_class = WEIGHT_CLASS_TINY
	size = 30 // needs a medium-sized assembly minimum
	complexity = 20
	inputs = list("relative X" = IC_PINTYPE_NUMBER, "relative Y" = IC_PINTYPE_NUMBER, "strength" = IC_PINTYPE_NUMBER, "lifespan" = IC_PINTYPE_NUMBER)
	outputs = list("shields projected" = IC_PINTYPE_NUMBER)
	activators = list("create shield" = IC_PINTYPE_PULSE_IN, "shield created" = IC_PINTYPE_PULSE_OUT, "shield capacity reached" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 100
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MAGNET = 5)

	/// A list of shields deployed by this circuit for amount checks/shield deletions.
	var/list/obj/machinery/shield/deployed_shields

/obj/item/integrated_circuit/manipulation/bubble_shield/Destroy()
	QDEL_LAZYLIST(deployed_shields)
	return ..()

/obj/item/integrated_circuit/manipulation/bubble_shield/proc/kill_shield(var/obj/machinery/shield/shield)
	LAZYREMOVE(deployed_shields, shield)
	qdel(shield)
	set_pin_data(IC_OUTPUT, 1, LAZYLEN(deployed_shields))

/obj/item/integrated_circuit/manipulation/bubble_shield/do_work()
	if(!assembly)
		return

	var/strength = between(10, get_pin_data(IC_INPUT, 3), 50)
	var/lifespan = between(2, get_pin_data(IC_INPUT, 4), 60)

	// find target turf based on relative coordinates
	var/target_relative_x = round(get_pin_data(IC_INPUT, 1))
	var/target_relative_y = round(get_pin_data(IC_INPUT, 2))

	var/turf/our_turf = get_turf(assembly)
	var/target_x = our_turf.x + target_relative_x
	var/target_y = our_turf.y + target_relative_y
	if (target_x > world.maxx || target_x < 1 || target_y > world.maxy || target_y < 1)
		return	// Off the edge of the map.

	var/target_turf = locate(target_x, target_y, our_turf.z)

	// create the shield
	if(target_turf && (target_turf in view(3, our_turf))) // must be in view and within 3 tiles
		if(locate(/obj/machinery/shield) in target_turf) // already got a shield
			return

		if(LAZYLEN(deployed_shields) >= 3) // do not generate more than 3 shields
			activate_pin(2)
			return
		//actually creating the shield
		var/obj/machinery/shield/shield = new /obj/machinery/shield(target_turf)
		shield.name = "bubble shield"
		shield.health = strength
		LAZYADD(deployed_shields, shield)
		addtimer(CALLBACK(src, PROC_REF(kill_shield), shield), lifespan SECONDS, TIMER_DELETE_ME) // clean up after ourselves later
		set_pin_data(IC_OUTPUT, 1, LAZYLEN(deployed_shields))
		activate_pin(1)

	// power stuff
	if(deployed_shields)
		power_draw_per_use = initial(power_draw_per_use)*(strength/10)*LAZYLEN(deployed_shields)
	else
		power_draw_per_use = initial(power_draw_per_use)

	..()

/obj/item/integrated_circuit/manipulation/bubble_shield/power_fail()
	for(var/obj/machinery/shield/shield in deployed_shields)
		kill_shield(shield)
