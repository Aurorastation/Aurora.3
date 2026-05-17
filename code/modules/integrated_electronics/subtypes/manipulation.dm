/obj/item/integrated_circuit/manipulation
	category_text = "Manipulation"

/obj/item/integrated_circuit/manipulation/proc/get_object()
	return assembly ? assembly : src

/obj/item/integrated_circuit/manipulation/proc/check_target(atom/A, exclude_contents = FALSE)
	if(!A || !assembly)
		return FALSE

	if(exclude_contents && (A in assembly.contents))
		return FALSE

	var/turf/target_turf = get_turf(A)
	var/turf/assembly_turf = get_turf(assembly)

	if(!target_turf || !assembly_turf)
		return FALSE

	return target_turf.Adjacent(assembly_turf) || target_turf == assembly_turf


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
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 4)
	power_draw_per_use = 500

/obj/item/integrated_circuit/manipulation/weapon_firing/Destroy()
	QDEL_NULL(installed_gun)
	. = ..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/gun))
		var/obj/item/gun/gun = attacking_item
		if(installed_gun)
			to_chat(user, SPAN_WARNING("There's already a weapon installed."))
			return

		user.drop_from_inventory(gun, src)
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

	if(!isnum(target_x) || !isnum(target_y) || !assembly)
		return

	target_x = round(target_x)
	target_y = round(target_y)

	if(target_x == 0 && target_y == 0)
		return

	var/turf/T = get_turf(assembly)
	if(!T)
		return

	var/Tx = T.x + target_x
	var/Ty = T.y + target_y

	if(Tx > world.maxx || Tx < 1 || Ty > world.maxy || Ty < 1)
		return

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
	inputs = list("direction" = IC_PINTYPE_DIR)
	outputs = list()
	activators = list("step towards dir" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 1000

/obj/item/integrated_circuit/manipulation/locomotion/do_work()
	..()

	var/turf/T = get_turf(src)
	if(T && assembly)
		if(assembly.anchored || !assembly.can_move())
			return

		if(assembly.loc == T)
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
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 4)
	var/obj/item/grenade/attached_grenade
	var/pre_attached_grenade_type

/obj/item/integrated_circuit/manipulation/grenade/Initialize()
	. = ..()
	if(pre_attached_grenade_type)
		var/obj/item/grenade/G = new pre_attached_grenade_type(src)
		attach_grenade(G)

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
		else if(user.unEquip(G, force = 1))
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
	spawn_flags = null


/obj/item/integrated_circuit/manipulation/grabber
	name = "grabber"
	desc = "A circuit with its own inventory for small/medium items, used to grab and store things."
	icon_state = "grabber"
	extended_desc = "The circuit accepts a reference to thing to be grabbed. It can store up to 10 things. Modes: 1 for grab. 0 for eject the first thing. -1 for eject all."
	w_class = WEIGHT_CLASS_TINY
	size = 3
	complexity = 10
	inputs = list(
		"target" = IC_PINTYPE_REF,
		"mode" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"first" = IC_PINTYPE_REF,
		"last" = IC_PINTYPE_REF,
		"amount" = IC_PINTYPE_NUMBER
	)
	activators = list(
		"pulse in" = IC_PINTYPE_PULSE_IN,
		"pulse out" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 500

/obj/item/integrated_circuit/manipulation/grabber/do_work()
	var/turf/T = get_turf(src)
	var/atom/movable/AM = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
	var/mode = get_pin_data(IC_INPUT, 2)

	if(mode == 1)
		if(AM && AM.Adjacent(T))
			if(contents.len < 10)
				if(istype(AM, /obj/item))
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

	set_pin_data(IC_OUTPUT, 1, contents.len ? contents[1] : null)
	set_pin_data(IC_OUTPUT, 2, contents.len ? contents[contents.len] : null)
	set_pin_data(IC_OUTPUT, 3, contents.len)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/manipulation/thrower
	name = "thrower"
	desc = "A compact launcher to throw things from inside or nearby tiles."
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
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 4)
	power_draw_per_use = 500

/obj/item/integrated_circuit/manipulation/thrower/do_work()
	var/datum/integrated_io/target_x = inputs[1]
	var/datum/integrated_io/target_y = inputs[2]
	var/datum/integrated_io/projectile = inputs[3]

	if(!isweakref(projectile.data))
		return

	var/obj/item/A = projectile.data.resolve()
	if(!A)
		return

	if(A.anchored)
		return

	if(A.w_class > WEIGHT_CLASS_NORMAL)
		return

	var/turf/T = get_turf(src.assembly)
	var/turf/TP = get_turf(A)

	if(!T || !TP)
		return

	if(!(TP.Adjacent(T)))
		return

	if(!src.assembly)
		return

	if(isnum(target_x.data))
		target_x.data = round(target_x.data)

	if(isnum(target_y.data))
		target_y.data = round(target_y.data)

	if(target_x.data == 0 && target_y.data == 0)
		return

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
	A.throw_at(T, round(clamp(sqrt(target_x.data * target_x.data + target_y.data * target_y.data), 0, 8), 1), 3, assembly)


/obj/item/integrated_circuit/manipulation/shocker
	name = "shocker circuit"
	desc = "Used to shock adjacent creatures with electricity."
	icon_state = "shocker"
	extended_desc = "The circuit accepts a reference to creature to shock. It can shock a target on adjacent tiles. \
	Severity determines the power draw and usage of each shock. It accepts values between 0 and 20. It has a 5 second cooldown."
	w_class = WEIGHT_CLASS_TINY
	complexity = 24
	inputs = list(
		"target" = IC_PINTYPE_REF,
		"severity" = IC_PINTYPE_NUMBER
	)
	outputs = list()
	activators = list(
		"shock" = IC_PINTYPE_PULSE_IN
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 0
	var/shocktime

/obj/item/integrated_circuit/manipulation/shocker/on_data_written()
	var/s = get_pin_data(IC_INPUT, 2)
	power_draw_per_use = clamp(s, 0, 20) * 200

/obj/item/integrated_circuit/manipulation/shocker/do_work()
	..()

	var/turf/T = get_turf(src)
	var/mob/living/M = get_pin_data_as_type(IC_INPUT, 1, /mob/living)

	if(!istype(M))
		return

	if(!T || !T.Adjacent(M))
		return

	if(shocktime + (5 SECONDS) > world.time)
		to_chat(M, SPAN_DANGER("You feel a light tingle from [src]. Luckily it was charging!"))
		return

	msg_admin_attack("An integrated circuit with a shocker circuit was used to shock [M.name] ([M.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
	to_chat(M, SPAN_DANGER("You feel a sharp shock from the [src]!"))
	spark(get_turf(M), 3, 1)
	M.stun_effect_act(0, clamp(get_pin_data(IC_INPUT, 2), 0, 20), null)
	shocktime = world.time


/obj/item/integrated_circuit/manipulation/flasher
	name = "flasher circuit"
	desc = "Used to flash adjacent creatures."
	icon_state = "video_camera"
	extended_desc = "The circuit accepts a reference to creature to flash. It can flash a target on adjacent tiles. \
	Severity determines the power draw and duration of each flash. It accepts values between 1 and 4. It has a 5 second cooldown."
	w_class = WEIGHT_CLASS_TINY
	complexity = 24
	inputs = list(
		"target" = IC_PINTYPE_REF,
		"severity" = IC_PINTYPE_NUMBER
	)
	outputs = list()
	activators = list(
		"flash" = IC_PINTYPE_PULSE_IN
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 0
	var/flashtime

/obj/item/integrated_circuit/manipulation/flasher/on_data_written()
	var/s = get_pin_data(IC_INPUT, 2)
	power_draw_per_use = clamp(s, 1, 4) * 2000

/obj/item/integrated_circuit/manipulation/flasher/do_work()
	..()

	var/turf/T = get_turf(src)
	var/mob/living/scanned_mob = get_pin_data_as_type(IC_INPUT, 1, /mob/living)

	if(!istype(scanned_mob))
		return

	if(!T || !T.Adjacent(scanned_mob))
		return

	if((flashtime + (5 SECONDS)) > world.time)
		visible_message(SPAN_WARNING("You see a weak flash from the [src]."))
		return

	var/flash_duration = clamp(get_pin_data(IC_INPUT, 2), 1, 4)

	scanned_mob.flash_act(length = flash_duration SECONDS)

	flashtime = world.time
	msg_admin_attack("An integrated circuit with a flasher was used to flash [scanned_mob.name] ([scanned_mob.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)


/obj/item/integrated_circuit/manipulation/portal_opener
	name = "bluespace portal circuit"
	desc = "A miniaturised circuit that uses bluespace crystals to open a one-way bluespace portal. Costlier to use than a standard telescience set up, but portable."
	extended_desc = "The circuit can store 3 bluespace crystals; each crystal is 1 use. Power determines number of tiles jumped, up to 50m. Lifespan determines how long the portal is there, from 3 to 15 seconds. Imprecise with a high variance <b>(DANGER IN CLOSED SPACES!)</b>. It has a cooldown of 30 seconds."
	icon_state = "shocker"
	w_class = WEIGHT_CLASS_TINY
	size = 20
	complexity = 30
	inputs = list(
		"direction" = IC_PINTYPE_DIR,
		"power" = IC_PINTYPE_NUMBER,
		"lifespan" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"bluespace crystals stored" = IC_PINTYPE_NUMBER
	)
	activators = list(
		"open portal" = IC_PINTYPE_PULSE_IN,
		"portal opened" = IC_PINTYPE_PULSE_OUT,
		"cannot open portal" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 1000
	cooldown_per_use = 30 SECONDS
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 5)
	var/list/obj/item/bluespace_crystal/crystals
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
	power_draw_per_use = round(between(100, 100 * get_pin_data(IC_INPUT, 2), 5000), 50)
	..()

/obj/item/integrated_circuit/manipulation/portal_opener/do_work()
	if(LAZYLEN(crystals) < 1)
		activate_pin(3)
		return

	var/turf/assembly_turf = get_turf(assembly)
	if(!assembly_turf)
		activate_pin(3)
		return

	var/proj_power = round(between(1, get_pin_data(IC_INPUT, 2), 50), 1)
	var/proj_rotation = dir2angle(get_pin_data(IC_INPUT, 1))
	var/proj_angle = 60

	var/datum/projectile_data/proj_data = projectile_trajectory(assembly_turf.x, assembly_turf.y, proj_rotation, proj_angle, proj_power)

	var/destination_x = clamp(round(proj_data.dest_x, 1), 1, world.maxx)
	var/destination_y = clamp(round(proj_data.dest_y, 1), 1, world.maxy)

	var/turf/portal_destination = locate(destination_x, destination_y, assembly_turf.z)
	if(!portal_destination)
		activate_pin(3)
		return

	playsound(assembly.loc, 'sound/weapons/flash.ogg', 25, 1)
	spark(assembly, 5, GLOB.alldirs)

	var/lifespan = between(30, SecondsToTicks(get_pin_data(IC_INPUT, 3)), 150)
	var/obj/effect/portal/our_portal = new /obj/effect/portal(assembly_turf, null, null, lifespan, 0)
	our_portal.set_target(portal_destination)
	our_portal.precision = 2
	our_portal.has_failed = FALSE

	var/obj/item/bluespace_crystal/consumed_bsc = LAZYACCESS(crystals, 1)
	LAZYREMOVE(crystals, consumed_bsc)
	qdel(consumed_bsc)

	activate_pin(2)

	set_pin_data(IC_OUTPUT, 1, LAZYLEN(crystals))
	push_data()
	..()


/obj/item/integrated_circuit/manipulation/bubble_shield
	name = "bubble shield circuit"
	desc = "A large bubble shield generator circuit, like those found in atmospheric emergency shields... sans all the automated features."
	extended_desc = "Receives relative coordinates to project a shield upon, within 3 tiles. Strength determines shield hitpoints, range 10-50. Lifespan given in seconds, range 2-60. Can only sustain 3 shields."
	icon_state = "power_transmitter"
	w_class = WEIGHT_CLASS_TINY
	size = 30
	complexity = 20
	inputs = list(
		"relative X" = IC_PINTYPE_NUMBER,
		"relative Y" = IC_PINTYPE_NUMBER,
		"strength" = IC_PINTYPE_NUMBER,
		"lifespan" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"shields projected" = IC_PINTYPE_NUMBER
	)
	activators = list(
		"create shield" = IC_PINTYPE_PULSE_IN,
		"shield created" = IC_PINTYPE_PULSE_OUT,
		"shield capacity reached" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 1000
	power_draw_idle = 0
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MAGNET = 5)
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

	var/target_relative_x = round(get_pin_data(IC_INPUT, 1))
	var/target_relative_y = round(get_pin_data(IC_INPUT, 2))

	var/turf/our_turf = get_turf(assembly)
	if(!our_turf)
		return

	var/target_x = our_turf.x + target_relative_x
	var/target_y = our_turf.y + target_relative_y

	if(target_x > world.maxx || target_x < 1 || target_y > world.maxy || target_y < 1)
		return

	var/turf/target_turf = locate(target_x, target_y, our_turf.z)

	if(target_turf && (target_turf in view(3, our_turf)))
		if(locate(/obj/machinery/shield) in target_turf)
			return

		if(LAZYLEN(deployed_shields) >= 3)
			activate_pin(3)
			return

		var/obj/machinery/shield/shield = new /obj/machinery/shield(target_turf)
		shield.name = "bubble shield"
		shield.health = strength
		LAZYADD(deployed_shields, shield)

		addtimer(CALLBACK(src, PROC_REF(kill_shield), shield), lifespan SECONDS, TIMER_DELETE_ME)

		set_pin_data(IC_OUTPUT, 1, LAZYLEN(deployed_shields))
		activate_pin(2)

	if(deployed_shields)
		power_draw_idle = power_draw_per_use * (strength / 10) * LAZYLEN(deployed_shields)
	else
		power_draw_idle = 0

	..()

/obj/item/integrated_circuit/manipulation/bubble_shield/power_fail()
	for(var/obj/machinery/shield/shield in deployed_shields)
		kill_shield(shield)


// -----------------------------------------------------------------------------
// Baystation manipulation circuit additions.
// -----------------------------------------------------------------------------

/obj/item/integrated_circuit/manipulation/plant_module
	name = "plant manipulation module"
	desc = "Used to uproot weeds and harvest or plant trays."
	icon_state = "plant_m"
	extended_desc = "The circuit accepts a reference to a hydroponic tray or an item on an adjacent tile. Mode input: 0 harvest, 1 uproot weeds, 2 uproot plant, 3 plant seed. Harvesting outputs a list of harvested plants."
	w_class = WEIGHT_CLASS_TINY
	complexity = 10
	inputs = list(
		"tray" = IC_PINTYPE_REF,
		"mode" = IC_PINTYPE_NUMBER,
		"item" = IC_PINTYPE_REF
	)
	outputs = list(
		"result" = IC_PINTYPE_LIST
	)
	activators = list(
		"pulse in" = IC_PINTYPE_PULSE_IN,
		"pulse out" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 50

/obj/item/integrated_circuit/manipulation/plant_module/do_work()
	..()

	var/obj/acting_object = get_object()
	var/obj/OM = get_pin_data_as_type(IC_INPUT, 1, /obj)
	var/obj/O = get_pin_data_as_type(IC_INPUT, 3, /obj/item)
	var/mode = get_pin_data(IC_INPUT, 2)

	if(!check_target(OM))
		push_data()
		activate_pin(2)
		return

	if(mode == 2 && istype(OM, /obj/machinery/portable_atmospherics/hydroponics))
		qdel(OM)
		push_data()
		activate_pin(2)
		return

	var/obj/machinery/portable_atmospherics/hydroponics/TR = OM
	if(!istype(TR))
		push_data()
		activate_pin(2)
		return

	switch(mode)
		if(0)
			var/list/harvest_output = TR.harvest()
			if(length(harvest_output))
				set_pin_data(IC_OUTPUT, 1, harvest_output)
			push_data()

		if(1)
			TR.weedlevel = 0
			TR.update_icon()

		if(2)
			if(TR.seed)
				TR.age = 0
				TR.health = 0
				if(TR.harvest)
					TR.harvest = FALSE
				qdel(TR.seed)
				TR.seed = null

			TR.weedlevel = 0
			TR.dead = 0
			TR.update_icon()

		if(3)
			if(!check_target(O))
				activate_pin(2)
				return FALSE

			if(istype(O, /obj/item/seeds) && !istype(O, /obj/item/seeds/cutting))
				if(!TR.seed)
					var/obj/item/seeds/S = O
					acting_object.visible_message(SPAN_NOTICE("[acting_object] plants [O]."))
					TR.seed = S.seed
					TR.lastproduce = 0
					TR.dead = 0
					TR.age = 1
					TR.health = 100
					TR.lastcycle = world.time
					qdel(O)
					TR.update_icon()
					TR.check_health()

	activate_pin(2)


/obj/item/integrated_circuit/manipulation/seed_extractor
	name = "seed extractor module"
	desc = "Used to extract seeds from grown produce."
	icon_state = "plant_m"
	extended_desc = "The circuit accepts a reference to a plant item and extracts seeds from it, outputting the results to a list."
	complexity = 8
	inputs = list(
		"target" = IC_PINTYPE_REF
	)
	outputs = list(
		"result" = IC_PINTYPE_LIST
	)
	activators = list(
		"pulse in" = IC_PINTYPE_PULSE_IN,
		"pulse out" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 50

/obj/item/integrated_circuit/manipulation/seed_extractor/do_work()
	..()

	var/obj/item/reagent_containers/food/snacks/grown/O = get_pin_data_as_type(IC_INPUT, 1, /obj/item/reagent_containers/food/snacks/grown)
	if(!check_target(O))
		push_data()
		activate_pin(2)
		return

	var/list/seed_output = list()

	for(var/i in 1 to rand(1, 4))
		var/obj/item/seeds/seeds = new(get_turf(O))
		seeds.seed = SSplants.seeds[O.plantname]
		seeds.seed_type = SSplants.seeds[O.seed.name]
		seeds.update_seed()
		seed_output += seeds

	qdel(O)

	if(length(seed_output))
		set_pin_data(IC_OUTPUT, 1, seed_output)

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/manipulation/claw
	name = "pulling claw"
	desc = "A claw and tether system."
	icon_state = "pull_claw"
	extended_desc = "This circuit accepts a reference to a thing to be pulled."
	w_class = WEIGHT_CLASS_NORMAL
	size = 3
	complexity = 10
	inputs = list(
		"target" = IC_PINTYPE_REF,
		"dir" = IC_PINTYPE_DIR
	)
	outputs = list(
		"is pulling" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"pulse in" = IC_PINTYPE_PULSE_IN,
		"pulse out" = IC_PINTYPE_PULSE_OUT,
		"release" = IC_PINTYPE_PULSE_IN,
		"pull to dir" = IC_PINTYPE_PULSE_IN
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 50
	var/obj/item/pulling

/obj/item/integrated_circuit/manipulation/claw/Destroy()
	stop_pulling()
	. = ..()

/obj/item/integrated_circuit/manipulation/claw/do_work(ord)
	var/obj/acting_object = get_object()
	var/obj/item/to_pull = get_pin_data_as_type(IC_INPUT, 1, /obj/item)

	switch(ord)
		if(1)
			if(can_pull(to_pull) && check_target(to_pull, exclude_contents = TRUE))
				set_pin_data(IC_OUTPUT, 1, TRUE)
				pulling = to_pull
				acting_object.visible_message("\The [acting_object] starts pulling \the [to_pull] around.")
				push_data()
				activate_pin(2)

		if(3)
			if(pulling)
				stop_pulling()

		if(4)
			if(pulling)
				var/dir = get_pin_data(IC_INPUT, 2)
				var/turf/G = get_step(get_turf(acting_object), dir)
				var/turf/Pl = get_turf(pulling)
				var/turf/F = get_step_towards(Pl, G)

				if(F && acting_object.Adjacent(F))
					if(!step_towards(pulling, F))
						F = get_step_towards2(Pl, G)
						if(F && acting_object.Adjacent(F))
							step_towards(pulling, F)

				activate_pin(2)

/obj/item/integrated_circuit/manipulation/claw/proc/can_pull(obj/item/I)
	return assembly && I && I.w_class <= assembly.w_class && !I.anchored

/obj/item/integrated_circuit/manipulation/claw/proc/pull()
	var/obj/acting_object = get_object()
	if(isturf(acting_object.loc))
		step_towards(pulling, src)
	else
		stop_pulling()

/obj/item/integrated_circuit/manipulation/claw/proc/check_pull()
	if(get_dist(pulling, src) > 1)
		stop_pulling()

/obj/item/integrated_circuit/manipulation/claw/proc/stop_pulling()
	if(!pulling)
		return

	var/atom/movable/AM = get_object()
	if(AM)
		AM.visible_message("\The [AM] stops pulling \the [pulling].")

	pulling = null
	set_pin_data(IC_OUTPUT, 1, FALSE)
	activate_pin(3)
	push_data()


/obj/item/integrated_circuit/manipulation/bluespace_rift
	name = "bluespace rift generator"
	desc = "This powerful circuit can open rifts to another realspace location through bluespace."
	extended_desc = "Opens a short-range unstable bluespace rift. Rift direction determines where the rift opens relative to the assembly."
	icon_state = "bluespace"
	complexity = 100
	size = 3
	cooldown_per_use = 10 SECONDS
	power_draw_per_use = 300
	inputs = list(
		"rift direction" = IC_PINTYPE_DIR
	)
	outputs = list()
	activators = list(
		"open rift" = IC_PINTYPE_PULSE_IN
	)
	origin_tech = list(TECH_MAGNET = 1, TECH_BLUESPACE = 3)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/manipulation/bluespace_rift/do_work()
	var/turf/depart = get_turf(assembly)
	if(!depart)
		playsound(src, 'sound/effects/sparks2.ogg', 50, 1)
		return

	var/turf/arrive = get_random_turf_in_range(src, 10)
	if(!arrive)
		playsound(src, 'sound/effects/sparks2.ogg', 50, 1)
		return

	var/step_dir = get_pin_data(IC_INPUT, 1)
	if(!isnum(step_dir) || !(step_dir in GLOB.cardinals))
		step_dir = assembly ? assembly.dir : SOUTH

	depart = get_step(depart, step_dir) || depart

	var/obj/effect/portal/P = new /obj/effect/portal(depart, null, null, 30 SECONDS, 0)
	P.set_target(arrive)
	P.precision = 0
	P.has_failed = FALSE

	playsound(src, 'sound/effects/sparks2.ogg', 50, 1)


/obj/item/integrated_circuit/manipulation/ai
	name = "integrated intelligence control circuit"
	desc = "Similar in structure to an intellicard, this circuit allows an AI to pulse four different activators for control of a circuit."
	extended_desc = "Load an AI by inserting the container into the device slot. Unload by using the circuit in-hand."
	icon_state = "ai"
	complexity = 15
	cooldown_per_use = 1 SECOND
	power_draw_per_use = 20
	activators = list(
		"Upwards" = IC_PINTYPE_PULSE_OUT,
		"Downwards" = IC_PINTYPE_PULSE_OUT,
		"Left" = IC_PINTYPE_PULSE_OUT,
		"Right" = IC_PINTYPE_PULSE_OUT
	)
	origin_tech = list(TECH_DATA = 4)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/mob/controlling
	var/obj/item/aicard

/obj/item/integrated_circuit/manipulation/ai/verb/open_menu()
	set name = "Control Inputs"
	set desc = "With this you can press buttons on the assembly you are attached to."
	set category = "Object"
	set src = usr.loc

	if(assembly)
		assembly.attack_self(usr)

/obj/item/integrated_circuit/manipulation/ai/relaymove(mob/user, direction)
	. = ..()

	switch(direction)
		if(1)
			activate_pin(1)
		if(2)
			activate_pin(2)
		if(4)
			activate_pin(3)
		if(8)
			activate_pin(4)

/obj/item/integrated_circuit/manipulation/ai/proc/load_ai(mob/user, obj/item/card)
	if(controlling)
		to_chat(user, SPAN_WARNING("There is already a card in there!"))
		return

	var/mob/living/L = locate(/mob/living) in card.contents
	if(L && L.key && user.unEquip(card, force = 1))
		L.forceMove(src)
		controlling = L
		card.forceMove(src)
		aicard = card
		user.visible_message("\The [user] loads \the [card] into \the [src]'s device slot.")
		to_chat(L, SPAN_NOTICE("### IICC FIRMWARE LOADED ###"))

/obj/item/integrated_circuit/manipulation/ai/proc/unload_ai()
	if(!controlling || !aicard)
		return

	controlling.forceMove(aicard)
	to_chat(controlling, SPAN_NOTICE("### IICC FIRMWARE DELETED. HAVE A NICE DAY ###"))
	src.visible_message("\The [aicard] pops out of \the [src]!")
	aicard.dropInto(loc)
	aicard = null
	controlling = null

/obj/item/integrated_circuit/manipulation/ai/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/aicard))
		load_ai(user, attacking_item)
		return

	..()

/obj/item/integrated_circuit/manipulation/ai/attack_self(mob/user)
	unload_ai()

/obj/item/integrated_circuit/manipulation/ai/Destroy()
	unload_ai()
	. = ..()


/obj/item/integrated_circuit/manipulation/anchoring
	name = "anchoring bolts"
	desc = "Pop-out anchoring bolts which can secure an assembly to the floor."
	outputs = list(
		"enabled" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"toggle" = IC_PINTYPE_PULSE_IN,
		"on toggle" = IC_PINTYPE_PULSE_OUT
	)
	complexity = 8
	cooldown_per_use = 2 SECONDS
	power_draw_per_use = 50
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2)

/obj/item/integrated_circuit/manipulation/anchoring/do_work(ord)
	if(!isturf(assembly?.loc))
		return

	if(ord == 1)
		assembly.anchored = !assembly.anchored
		visible_message(assembly.anchored ? SPAN_NOTICE("\The [get_object()] deploys a set of anchoring bolts!") : SPAN_NOTICE("\The [get_object()] retracts its anchoring bolts."))
		set_pin_data(IC_OUTPUT, 1, assembly.anchored)
		push_data()
		activate_pin(2)


/obj/item/integrated_circuit/manipulation/hatchlock
	name = "maintenance hatch lock"
	desc = "An electronically controlled lock for the assembly's maintenance hatch."
	extended_desc = "WARNING: If you lock the hatch with no circuitry to reopen it, there is no way to open the hatch again!"
	icon_state = "hatch_lock"
	outputs = list(
		"enabled" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"toggle" = IC_PINTYPE_PULSE_IN,
		"on toggle" = IC_PINTYPE_PULSE_OUT
	)
	complexity = 4
	cooldown_per_use = 2 SECONDS
	power_draw_per_use = 50
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2)
	var/lock_enabled = FALSE

/obj/item/integrated_circuit/manipulation/hatchlock/do_work(ord)
	if(ord == 1)
		lock_enabled = !lock_enabled
		visible_message(SPAN_NOTICE("\The [get_object()] whirrs. The screws are now [lock_enabled ? "covered" : "exposed"]."))
