//
// Rapid Fabrication Devices
//

// Defines
#define MATERIALIZATION_FAIL_MESSAGE "You can't materialize two constructions of the same type."

//
// Rapid Fabrication Device
//

/obj/item/rfd
	name = "\improper Rapid Fabrication Device"
	desc = "A device used for rapid fabrication. The matter decompression matrix is untuned, rendering it useless."
	icon = 'icons/obj/rfd.dmi'
	icon_state = "rfd"
	item_state = "rfd"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_tools.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_tools.dmi'
		)
	opacity = FALSE
	density = FALSE
	anchored = FALSE
	flags = CONDUCT
	force = 5
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 50000)
	drop_sound = 'sound/items/drop/gun.ogg'
	pickup_sound = 'sound/items/pickup/gun.ogg'
	var/stored_matter = 30 // Starts of full.
	var/working = FALSE
	var/mode = RFD_FLOORS_AND_WALL
	var/number_of_modes = 1
	var/list/modes
	var/crafting = FALSE

	// A list of atoms that will be sent to the alter_atom proc if we click on them, rather than their turf.
	var/list/valid_atoms = list(
		/obj/machinery/door/airlock,
		/obj/structure/window_frame,
		/obj/structure/window/full
	)
	var/build_cost = 0
	var/build_type
	var/build_atom
	var/build_delay
	var/last_fail = 0

/obj/item/rfd/Initialize()
	. = ..()
	update_icon()

/obj/item/rfd/attack()
	return FALSE

/obj/item/rfd/proc/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && user.get_active_hand() == src && !user.stat && !user.restrained())

/obj/item/rfd/examine(var/mob/user)
	. = ..()
	if(loc == user)
		to_chat(user, "It currently holds [stored_matter]/30 matter units.")

/obj/item/rfd/attack_self(mob/user)
	//Change the mode
	if(++mode > number_of_modes)
		mode = RFD_FLOORS_AND_WALL
	to_chat(user, SPAN_NOTICE("The mode selection dial is now at [modes[mode]]."))
	playsound(get_turf(src), 'sound/weapons/laser_safetyon.ogg', 50, FALSE)

/obj/item/rfd/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/rfd_ammo))
		if((stored_matter + 10) > 30)
			to_chat(user, SPAN_NOTICE("The RFD can't hold any more matter units."))
			return
		user.drop_from_inventory(W,src)
		qdel(W)
		stored_matter += 10
		playsound(src.loc, 'sound/weapons/laser_reload1.ogg', 50, FALSE)
		to_chat(user, SPAN_NOTICE("The RFD now holds [stored_matter]/30 matter units."))
		update_icon()
		return TRUE

	if(W.isscrewdriver())  // Turning it into a crossbow
		crafting = !crafting
		if(!crafting)
			to_chat(user, SPAN_NOTICE("You reassemble the RFD."))
		else
			to_chat(user, SPAN_NOTICE("The RFD can now be modified."))
		src.add_fingerprint(user)
		return TRUE

	if(crafting)
		var/obj/item/crossbow // the thing we're gonna add, check what it is below
		if(istype(W, /obj/item/crossbowframe))
			var/obj/item/crossbowframe/F = W
			if(F.buildstate != 5)
				to_chat(user, SPAN_WARNING("You need to fully assemble the crossbow frame first!"))
				return TRUE
			crossbow = F
		else if(istype(W, /obj/item/gun/launcher/crossbow) && !istype(W, /obj/item/gun/launcher/crossbow/RFD))
			var/obj/item/gun/launcher/crossbow/C = W
			if(C.bolt)
				to_chat(user, SPAN_WARNING("You need to remove \the [C.bolt] from \the [C] before you can attach it to \the [src]."))
				return TRUE
			if(C.cell)
				to_chat(user, SPAN_WARNING("You need to remove \the [C.cell] from \the [C] before you can attach it to \the [src]."))
				return TRUE
			crossbow = C

		if(crossbow)
			qdel(crossbow)
			var/obj/item/gun/launcher/crossbow/RFD/CB = new(get_turf(user)) // Can be found in "crossbow.dm".
			forceMove(CB)
			CB.stored_matter = src.stored_matter
			user.drop_from_inventory(src)
			qdel(src)
			user.put_in_hands(CB)
			return TRUE
	return ..()


/obj/item/rfd/proc/useResource(var/amount, var/mob/user)
	if(stored_matter < amount)
		return FALSE
	stored_matter -= amount
	update_icon()
	return TRUE

/obj/item/rfd/update_icon()	// For the fancy "ammo" counter.
	overlays.Cut()

	var/ratio = 0
	ratio = stored_matter / 30	//30 is the hardcoded max capacity of the RFD
	ratio = max(round(ratio, 0.10) * 100, 10)

	overlays += "[icon_state]-[ratio]"

/obj/item/rfd_ammo
	name = "compressed matter cartridge"
	desc = "Highly compressed matter for the RFD."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "rfd"
	item_state = "rfdammo"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000, MATERIAL_GLASS = 2000)
	recyclable = TRUE

//
// RFD - Construction Class
//

/obj/item/rfd/construction
	name = "\improper Rapid Fabrication Device C-Class"
	desc = "A RFD, modified to construct walls and floors."
	var/list/radial_modes = list()
	var/can_rwall = FALSE
	var/disabled = FALSE

/obj/item/rfd/construction/Initialize()
	. = ..()
	radial_modes = list(
		"Floor and Wall" = image(icon = 'icons/mob/screen/radial.dmi', icon_state = "wallfloor"),
		"Window and Window Frame" = image(icon = 'icons/mob/screen/radial.dmi', icon_state = "windowframe"),
		"Airlock" = image(icon = 'icons/mob/screen/radial.dmi', icon_state = "airlock"),
		"Deconstruct" = image(icon = 'icons/mob/screen/radial.dmi', icon_state = "delete")
	)

/obj/item/rfd/construction/attack_self(mob/user)
	var/current_mode = RADIAL_INPUT(user, radial_modes)
	switch(current_mode)
		if("Floor and Wall")
			mode = RFD_FLOORS_AND_WALL
		if("Window and Window Frame")
			mode = RFD_WINDOW_AND_FRAME
		if("Deconstruct")
			mode = RFD_DECONSTRUCT
		if("Airlock")
			mode = RFD_AIRLOCK
		else
			mode = RFD_DECONSTRUCT
	if(current_mode)
		to_chat(user, SPAN_NOTICE("You switch the selection dial to <i>\"[current_mode]\"</i>."))
		if(mode == 3)
			playsound(get_turf(src), 'sound/weapons/laser_safetyoff.ogg', 50, FALSE)
		else
			playsound(get_turf(src), 'sound/weapons/laser_safetyon.ogg', 50, FALSE)

/obj/item/rfd/construction/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	if((!isturf(A) && !isturf(A.loc)) || istype(A, /obj/structure/table))
		return
	if(disabled && !isrobot(user))
		return FALSE
	var/area/Area = get_area(A)
	if(Area.centcomm_area || istype(Area, /area/shuttle) || istype(Area, /turf/space/transit))
		to_chat(user, SPAN_NOTICE("\The [src] can't be used here."))
		return FALSE
	if(is_type_in_list(A, valid_atoms))
		return alter_atom(A, user, (mode == RFD_DECONSTRUCT))
	return alter_atom(get_turf(A), user, (mode == RFD_DECONSTRUCT))

/obj/item/rfd/construction/proc/alter_atom(var/atom/A, var/mob/user, var/deconstruct)
	if(working)
		return FALSE

	var/turf/T = isturf(A) ? A : null // the lower istypes will return false if T is null, which means we don't have to check whether it's an atom or a turf
	if(mode == RFD_FLOORS_AND_WALL)
		if(istype(T, /turf/space) || istype(T, T.baseturf))
			build_cost = 1
			build_type = "floor"
			build_atom = /turf/simulated/floor/airless
		else if(istype(T, /turf/simulated/open))
			build_cost = 1
			build_type = "floor"
			build_atom = /turf/simulated/floor/airless
		else if(istype(T, /turf/simulated/floor))
			build_delay = 20
			build_cost = 3
			build_type = "wall"
			build_atom = /turf/simulated/wall
	else if(mode == RFD_WINDOW_AND_FRAME)
		if(istype(T, /turf/simulated/floor))
			if(locate(/obj/structure/window_frame) in get_turf(A))
				to_chat(user, SPAN_NOTICE(MATERIALIZATION_FAIL_MESSAGE))
				return
			build_cost = 3
			build_delay = 20
			build_type = "window frame"
			build_atom = /obj/structure/window_frame
		else if(istype(A, /obj/structure/window_frame))
			if(locate(/obj/structure/window/full/reinforced) in get_turf(A))
				to_chat(user, SPAN_NOTICE(MATERIALIZATION_FAIL_MESSAGE))
				return
			build_cost = 3
			build_delay = 20
			build_type = "window"
			build_atom = /obj/structure/window/full/reinforced
	else if(mode == RFD_AIRLOCK)
		if(istype(T, /turf/simulated/floor))
			build_cost = 3
			build_delay = 20
			build_type = "airlock"
			build_atom = /obj/machinery/door/airlock
	else if(mode == RFD_DECONSTRUCT)
		// Airlocks
		if(istype(A, /obj/machinery/door/airlock))
			build_cost = 10
			build_delay = 50
			build_type = "airlock"
		// Walls
		else if(istype(T, /turf/simulated/wall))
			var/turf/simulated/wall/W = T
			build_cost = 5
			build_delay = 50
			build_type = (!can_rwall && W.reinf_material) ? null : "wall"
			build_atom = W.under_turf
		// Floors
		else if(istype(T, /turf/simulated/floor))
			build_cost = 10
			build_delay = 50
			build_type = "floor"
			build_atom = T.baseturf
		// Window Frames
		if(istype(A, /obj/structure/window_frame))
			if(locate(/obj/structure/window/full) in get_turf(A))
				to_chat(user, SPAN_NOTICE("You can't deconstruct \the [A] if it has glass installed."))
				return
			build_cost = 3
			build_delay = 20
			build_type = "window frame"
		// Full Windows
		else if(istype(A, /obj/structure/window/full))
			build_cost = 5
			build_delay = 50
			build_type = "window"

	if(!build_type)
		working = FALSE
		return FALSE

	if(mode == RFD_DECONSTRUCT && istype(A, /obj/machinery/door) && !A.density)
		to_chat(user, SPAN_WARNING("\The [build_type] must be closed before you can deconstruct it."))
		return FALSE

	if(stored_matter < build_cost)
		to_chat(user, SPAN_NOTICE("The \"Matter Units Low\" light on the device blinks yellow."))
		flick("[icon_state]-empty", src)
		return FALSE

	playsound(get_turf(src), 'sound/items/rfd_start.ogg', 50, FALSE)

	working = TRUE
	user.visible_message(SPAN_NOTICE("[user] holds \the [src] towards \the [A]."), SPAN_NOTICE("You start [deconstruct ? "deconstructing" : "constructing"] \a [build_type]..."))
	var/obj/effect/constructing_effect/rfd_effect = new(get_turf(A), src.build_delay, src.mode)

	if((build_delay && !do_after(user, build_delay)) || (!useResource(build_cost, user)))
		working = FALSE
		rfd_effect.end_animation()
		return FALSE

	working = FALSE
	if(build_delay && !can_use(user, A))
		return FALSE

	if(ispath(build_atom, /turf))
		var/original_type = T.type
		T.ChangeTurf(build_atom)
		if(istype(T, /turf/simulated/wall))
			var/turf/simulated/wall/W = T
			W.under_turf = original_type
	else if(ispath(build_atom, /obj))
		new build_atom(get_turf(A))
	else
		qdel(A)

	rfd_effect.end_animation()
	playsound(get_turf(src), 'sound/items/rfd_end.ogg', 50, FALSE)
	build_cost = null
	build_delay = null
	build_type = null
	build_atom = null // So that it resets and any unintended functionality is avoided.
	return TRUE

/obj/item/rfd/construction/borg
	can_rwall = TRUE

/obj/item/rfd/construction/borg/useResource(var/amount, var/mob/user)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			var/cost = (amount * 30)
			if(R.cell.charge >= cost)
				R.cell.use(cost)
				return TRUE
	return FALSE

/obj/item/rfd/construction/borg/infinite/useResource()
	return TRUE

/obj/item/rfd/construction/borg/attackby()
	return

/obj/item/rfd/construction/borg/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && !user.stat)

/obj/item/rfd/construction/mounted/useResource(var/amount, var/mob/user)
	var/cost = (amount * 130) // So that a rig with default powercell can build ~2.5x the stuff a fully-loaded RFD-C can.
	if(istype(loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = loc
		if(module.holder && module.holder.cell)
			if(module.holder.cell.charge >= cost)
				module.holder.cell.use(cost)
				return TRUE
	else if(istype(user, /mob/living/heavy_vehicle))
		var/obj/item/cell/c = user.get_cell()
		if(c && c.charge >= cost)
			c.use(cost)
			return TRUE
	return FALSE

/obj/item/rfd/construction/mounted/attackby()
	return

/obj/item/rfd/construction/mounted/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && !user.stat && !user.restrained())


//
// RFD - Service Class
//

/obj/item/rfd/service
	name = "\improper Rapid Fabrication Device S-Class"
	desc = "A RFD, modified to deploy service items."
	icon_state = "rfd-s"
	item_state = "rfd-s"
	var/list/radial_modes = list()

/obj/item/rfd/service/Initialize()
	. = ..()
	radial_modes = list(
		"Cigarette" = image(icon = 'icons/obj/clothing/masks.dmi', icon_state = "cigoff"),
		"Drinking Glass" = image(icon = 'icons/obj/drinks.dmi', icon_state = "glass_empty"),
		"Paper" = image(icon = 'icons/obj/bureaucracy.dmi', icon_state = "paper"),
		"Pen" = image(icon = 'icons/obj/bureaucracy.dmi', icon_state = "pen"),
		"Dice Pack" = image(icon = 'icons/obj/dice.dmi', icon_state = "dicebag"),
	)

/obj/item/rfd/service/attack_self(mob/user)
	var/current_mode = RADIAL_INPUT(user, radial_modes)
	switch(current_mode)
		if("Cigarette")
			mode = 1
		if("Drinking Glass")
			mode = 2
		if("Paper")
			mode = 3
		if("Pen")
			mode = 4
		if("Dice Pack")
			mode = 5
	if(current_mode)
		to_chat(user, SPAN_NOTICE("You switch the selection dial to <i>\"[current_mode]\"</i>."))
		playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)

/obj/item/rfd/service/resolve_attackby(atom/A, mob/user as mob, var/click_parameters)
	if(istype(user,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = user
		if(R.stat || !R.cell || R.cell.charge <= 0)
			return
	else
		if(stored_matter <= 0)
			if(last_fail <= world.time - 20) // Spam limiter.
				last_fail = world.time
				to_chat(user, SPAN_NOTICE("The \"Matter Units Low\" light on the device blinks yellow."))
				playsound(get_turf(src), 'sound/items/rfd_empty.ogg', 50, FALSE)
				flick("[icon_state]-empty", src)
			return

	if(!istype(A, /obj/structure/table) && !istype(A, /turf/simulated/floor))
		return

	playsound(src.loc, 'sound/items/rfd_dispense.ogg', 20, FALSE)
	sleep(2)
	var/used_energy = 0
	var/obj/product

	switch(mode)
		if(1)
			product = new /obj/item/clothing/mask/smokable/cigarette()
			used_energy = 10
		if(2)
			product = new /obj/item/reagent_containers/food/drinks/drinkingglass()
			used_energy = 50
		if(3)
			product = new /obj/item/paper()
			used_energy = 10
		if(4)
			product = new /obj/item/pen()
			used_energy = 50
		if(5)
			product = new /obj/item/storage/pill_bottle/dice()
			used_energy = 200

	to_chat(user, "Dispensing [product ? product : "product"]...")
	product.forceMove(get_turf(A))
	playsound(src.loc, 'sound/machines/click.ogg' , 10, 1)
	if(istype(A, /obj/structure/table))
		var/obj/structure/table/T = A
		T.auto_align(product, click_parameters)
	update_icon()

	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			R.cell.use(used_energy)
	else
		stored_matter--
		to_chat(user, "The RSF now holds [stored_matter]/30 fabrication-units.")

//
// RFD - Mining Class
//

/obj/item/rfd/mining
	name = "\improper Rapid Fabrication Device M-Class"
	desc = "A RFD, modified to deploy mine tracks."
	icon_state = "rfd-m"
	item_state = "rfd-m"

/obj/item/rfd/mining/attack_self(mob/user)
	return

/obj/item/rfd/mining/afterattack(atom/A, mob/user, proximity, click_parameters, var/report_duplicate = TRUE)
	if(!proximity)
		return

	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.stat || !R.cell || R.cell.charge <= 200)
			if(last_fail <= world.time - 20) //Spam limiter.
				last_fail = world.time
				to_chat(user, SPAN_WARNING("You are unable to produce enough charge to use \the [src]!"))
				playsound(get_turf(src), 'sound/items/rfd_empty.ogg', 50, FALSE)
				flick("[icon_state]-empty", src)
			return
	else
		if(stored_matter <= 0)
			if(last_fail <= world.time - 20) //Spam limiter.
				last_fail = world.time
				to_chat(user, SPAN_NOTICE("The \"Matter Units Low\" light on the device blinks yellow."))
				playsound(get_turf(src), 'sound/items/rfd_empty.ogg', 50, FALSE)
				flick("[icon_state]-empty", src)
			return

	if(!istype(A, /turf/simulated/floor) && !istype(A, /turf/unsimulated/floor))
		return

	if(locate(/obj/structure/track) in A)
		if(report_duplicate)
			to_chat(user, SPAN_WARNING("There is already a track on \the [A]!"))
		return

	playsound(src.loc, 'sound/machines/click.ogg', 10, 1)

	new /obj/structure/track(get_turf(A))

	to_chat(user, SPAN_NOTICE("You deploy a mine track on \the [A]."))
	update_icon()

	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			R.cell.use(200)
	else
		stored_matter--
		to_chat(user, SPAN_NOTICE("The RFD now holds <b>[stored_matter]/30</b> fabrication-units."))

	return TRUE


// Malf AI RFD Transformer

/obj/item/rfd/transformer
	name = "\improper Rapid Fabrication Device T-Class"
	desc = "A device used for rapid fabrication, modified to deploy a transformer. It can only be used once and there can not be more than one made."
	stored_matter = 30
	var/malftransformermade = 0

/obj/item/rfd/transformer/attack_self(mob/user)
	return

/obj/item/rfd/transformer/examine(var/mob/user)
	. = ..()
	if(loc == user)
		if(malftransformermade)
			to_chat(user, "There is already a transformer machine made!")
		else
			to_chat(user, "It is ready to deploy a transformer machine.")

/obj/item/rfd/transformer/afterattack(atom/A, mob/user as mob, proximity)

	if(!proximity) return

	if(istype(user,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = user
		if(R.stat || !R.cell || R.cell.charge <= 0)
			return

	if(!istype(A, /turf/simulated/floor))
		return

	if(malftransformermade)
		if(last_fail <= world.time - 20) //Spam limiter.
			last_fail = world.time
			to_chat(user, "There is already a transformer machine made!")
			playsound(get_turf(src), 'sound/items/rfd_empty.ogg', 50, FALSE)
			flick("[icon_state]-empty", src)
		return

	playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
	var/used_energy = 100
	to_chat(user, "Fabricating machine...")
	playsound(get_turf(src), 'sound/items/rfd_start.ogg', 50, FALSE)
	if(do_after(user, 30 SECONDS, src, DO_UNIQUE))
		var/obj/product = new /obj/machinery/transformer
		malftransformermade = 1
		product.forceMove(get_turf(A))
		stored_matter = 0
		update_icon()
		playsound(get_turf(src), 'sound/items/rfd_end.ogg', 50, FALSE)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			R.cell.use(used_energy)

	return TRUE


//
// RFD - Piping Class
//

#define STANDARD_PIPE "Standard Pipes"
#define SUPPLY_PIPE "Supply Pipes"
#define SCRUBBER_PIPE "Scrubber Pipes"
#define FUEL_PIPE "Fuel Pipes"
#define AUX_PIPE "Auxiliary Pipes"
#define DEVICES "Devices"

/obj/item/rfd/piping
	name = "\improper Rapid Fabrication Device P-Class"
	desc = "A heavily modified RFD, modified to construct pipes and piping accessories."
	icon_state = "rfd-p"
	item_state = "rfd-p"
	modes = list(STANDARD_PIPE, SUPPLY_PIPE, SCRUBBER_PIPE, DEVICES)
	var/selected_mode = STANDARD_PIPE
	var/pipe_examine = "Pipe" // used in the examine proc to see what you're putting down at a glance
	var/selected_pipe = 0 // default is standard pipe, used for the new pipe creation
	build_cost = 1 // this RFD only uses 1 unit of power per pipe, but can be modified if need be in future
	build_delay = 10

	// The numbers below refer to the numberized designator for each pipe, which is used in obj/item/pipe's new
	// Take a look at code\game\machinery\pipe\construction.dm line 69 for more information. - Geeves
	var/list/standard_pipes = list(
		"Pipe" = PIPE_SIMPLE_STRAIGHT,
		"Bent Pipe" = PIPE_SIMPLE_BENT,
		"Manifold" = PIPE_MANIFOLD,
		"Manual Valve" = PIPE_MVALVE,
		"4-Way Manifold" = PIPE_MANIFOLD4W,
		"Manual T-Valve" = PIPE_MTVALVE,
		"Upward Pipe" = PIPE_UP,
		"Downward Pipe" = PIPE_DOWN
	)

	var/list/supply_pipes = list(
		"Pipe" = PIPE_SUPPLY_STRAIGHT,
		"Bent Pipe" = PIPE_SUPPLY_BENT,
		"Manifold" = PIPE_SUPPLY_MANIFOLD,
		"4-Way Manifold" = PIPE_SUPPLY_MANIFOLD4W,
		"Upward Pipe" = PIPE_SUPPLY_UP,
		"Downward Pipe" = PIPE_SUPPLY_DOWN
	)

	var/list/scrubber_pipes = list(
		"Pipe" = PIPE_SCRUBBERS_STRAIGHT,
		"Bent Pipe" = PIPE_SCRUBBERS_BENT,
		"Manifold" = PIPE_SCRUBBERS_MANIFOLD,
		"4-Way Manifold" = PIPE_SCRUBBERS_MANIFOLD4W,
		"Upward Pipe" = PIPE_SCRUBBERS_UP,
		"Downward Pipe" = PIPE_SCRUBBERS_DOWN
	)

	var/list/fuel_pipes = list(
		"Pipe" = PIPE_FUEL_STRAIGHT,
		"Bent Pipe" = PIPE_FUEL_BENT,
		"Manifold" = PIPE_FUEL_MANIFOLD,
		"4-Way Manifold" = PIPE_FUEL_MANIFOLD4W,
		"Upward Pipe" = PIPE_FUEL_UP,
		"Downward Pipe" = PIPE_FUEL_DOWN
	)

	var/list/aux_pipes = list(
		"Pipe" = PIPE_AUX_STRAIGHT,
		"Bent Pipe" = PIPE_AUX_BENT,
		"Manifold" = PIPE_AUX_MANIFOLD,
		"4-Way Manifold" = PIPE_AUX_MANIFOLD4W,
		"Upward Pipe" = PIPE_AUX_UP,
		"Downward Pipe" = PIPE_AUX_DOWN
	)

	var/list/devices = list(
		"Universal Pipe Adapter" = PIPE_UNIVERSAL,
		"Connector" = PIPE_CONNECTOR,
		"Unary Vent" = PIPE_UVENT,
		"Auxiliary Unary Vent" = PIPE_AUX_UVENT,
		"Scrubber" = PIPE_SCRUBBER,
		"Gas Pump" = PIPE_PUMP,
		"Fuel Gas Pump" = PIPE_PUMP_FUEL,
		"Pressure Regulator" = PIPE_PASSIVE_GATE,
		"High Power Gas Pump" = PIPE_VOLUME_PUMP,
		"Gas Filter" = PIPE_GAS_FILTER_M,
		"Omni Gas Filter" = PIPE_OMNI_FILTER
	)

/obj/item/rfd/piping/examine(mob/user)
	. = ..()
	to_chat(user, FONT_SMALL(SPAN_NOTICE("Change pipe category by ALT-clicking, change pipe selection by using in-hand.")))
	to_chat(user, SPAN_NOTICE("Selected pipe category: <b>[selected_mode]</b>"))
	to_chat(user, SPAN_NOTICE("Selected pipe: <b>[pipe_examine]</b>"))

/obj/item/rfd/piping/afterattack(atom/A, mob/user, proximity)
	if(!proximity || !isturf(A))
		return
	if(istype(get_area(A), /area/shuttle) || istype(get_area(A), /turf/space))
		to_chat(user, SPAN_WARNING("You can't materialize a pipe here!"))
		return FALSE
	var/turf/T = get_turf(A)
	if(isNotStationLevel(T.z))
		to_chat(user, SPAN_WARNING("You can't materialize a pipe on this level!"))
		return FALSE
	return do_pipe(T, user)

/obj/item/rfd/piping/proc/do_pipe(var/turf/T, var/mob/user)
	if(working)
		return FALSE

	if(stored_matter < build_cost)
		to_chat(user, SPAN_NOTICE("The \"Matter Units Low\" light on the device blinks yellow."))
		playsound(get_turf(src), 'sound/items/rfd_empty.ogg', 50, FALSE)
		flick("[icon_state]-empty", src)
		return FALSE

	playsound(get_turf(src), 'sound/items/rfd_start.ogg', 50, FALSE)

	working = TRUE
	user.visible_message(SPAN_NOTICE("[user] holds \the [src] towards \the [T]."), SPAN_NOTICE("You start laying down a pipe..."))

	if((build_delay && !do_after(user, build_delay)) || (!useResource(build_cost, user)))
		playsound(get_turf(src), 'sound/items/rfd_interrupt.ogg', 50, FALSE)
		working = FALSE
		return FALSE

	if(build_delay && !can_use(user, T))
		return FALSE

	// Special case handling for bent pipes. They require a non-cardinal direction
	var/pipe_dir = NORTH
	if(selected_pipe in list(PIPE_SIMPLE_BENT, PIPE_SUPPLY_BENT, PIPE_SCRUBBERS_BENT, PIPE_FUEL_BENT, PIPE_AUX_BENT))
		pipe_dir = NORTHEAST
	new /obj/item/pipe(T, selected_pipe, pipe_dir)

	playsound(get_turf(src), 'sound/items/rfd_end.ogg', 50, FALSE)
	working = FALSE
	return TRUE

/obj/item/rfd/piping/attack_self(mob/user)
	playsound(get_turf(src), 'sound/weapons/laser_safetyon.ogg', 50, FALSE)
	var/list/pipe_selection = list()
	switch(selected_mode)
		if(STANDARD_PIPE)
			pipe_selection = standard_pipes
		if(SUPPLY_PIPE)
			pipe_selection = supply_pipes
		if(SCRUBBER_PIPE)
			pipe_selection = scrubber_pipes
		if(FUEL_PIPE)
			pipe_selection = fuel_pipes
		if(AUX_PIPE)
			pipe_selection = aux_pipes
		if(DEVICES)
			pipe_selection = devices
	pipe_examine = input(user, "Choose the pipe you want to deploy.", "Pipe Selection") in pipe_selection
	selected_pipe = pipe_selection[pipe_examine]

/obj/item/rfd/piping/AltClick(mob/user)
	selected_mode = input(user, "Choose the category you want to change to.", "Pipe Categories") in modes
	switch(selected_mode)
		if(STANDARD_PIPE)
			pipe_examine = "Pipe"
			selected_pipe = PIPE_SIMPLE_STRAIGHT
		if(SUPPLY_PIPE)
			pipe_examine = "Pipe"
			selected_pipe = PIPE_SUPPLY_STRAIGHT
		if(SCRUBBER_PIPE)
			pipe_examine = "Pipe"
			selected_pipe = PIPE_SCRUBBERS_STRAIGHT
		if(FUEL_PIPE)
			pipe_examine = "Pipe"
			selected_pipe = PIPE_FUEL_STRAIGHT
		if(AUX_PIPE)
			pipe_examine = "Pipe"
			selected_pipe = PIPE_AUX_STRAIGHT
		if(DEVICES)
			pipe_examine = "Universal Pipe Adapter"
			selected_pipe = PIPE_UNIVERSAL

/obj/item/rfd/piping/borg/useResource(var/amount, var/mob/user)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			var/cost = amount * 30
			if(R.cell.charge >= cost)
				R.cell.use(cost)
				return TRUE
	return FALSE

/obj/item/rfd/piping/borg/attackby()
	return

#undef STANDARD_PIPE
#undef SUPPLY_PIPE
#undef SCRUBBER_PIPE
#undef FUEL_PIPE
#undef AUX_PIPE
#undef DEVICES
#undef MATERIALIZATION_FAIL_MESSAGE
