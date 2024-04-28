
//TODO: Matter decompiler.
/obj/item/matter_decompiler
	name = "matter decompiler"
	desc = "Eating trash, bits of glass, or other debris will replenish your stores."
	icon = 'icons/obj/device.dmi'
	icon_state = "decompiler"
	var/is_decompiling = FALSE

	//Metal, glass, wood, plastic.
	var/datum/matter_synth/metal
	var/datum/matter_synth/glass
	var/datum/matter_synth/wood
	var/datum/matter_synth/plastic

/obj/item/matter_decompiler/attack(mob/living/M, mob/living/user)
	return

/obj/item/matter_decompiler/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, proximity, params)
	if(!proximity)
		return //Not adjacent.

	//If we're clicking on a mob, focus only on that mob
	if(ismob(target))
		attempt_decompile_creature(target, user)
		return

	//We only want to deal with using this on turfs. Specific items aren't important.
	var/turf/T = get_turf(target)
	if(!istype(T))
		return

	//Used to give the right message.
	var/grabbed_something = 0

	for(var/obj/W in T)
		//Different classes of items give different commodities.
		if(istype(W, /obj/item/trash/cigbutt))
			if(plastic)
				plastic.add_charge(500)
		else if (istype(W, /obj/item/flame/match))
			if (wood)
				wood.add_charge(100)
		else if(istype(W, /obj/effect/spider/spiderling))
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
		else if(istype(W, /obj/item/light))
			var/obj/item/light/L = W
			if(L.status >= 2) //In before someone changes the inexplicably local defines. ~ Z
				if(metal)
					metal.add_charge(250)
				if(glass)
					glass.add_charge(250)
			else
				continue
		else if(istype(W, /obj/effect/decal/remains/robot))
			if(metal)
				metal.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			if(glass)
				glass.add_charge(1000)
		else if(istype(W, /obj/item/trash))
			if(metal)
				metal.add_charge(1000)
			if(plastic)
				plastic.add_charge(3000)
		else if(istype(W, /obj/effect/decal/cleanable/blood/gibs/robot))
			if(metal)
				metal.add_charge(2000)
			if(glass)
				glass.add_charge(2000)
		else if(istype(W, /obj/item/ammo_casing))
			var/obj/item/ammo_casing/AC = W
			if(AC.BB) //My new cover band
				continue //We only decompile spent ammo
			if(metal)
				metal.add_charge(1000)
		else if(istype(W, /obj/item/material/shard/shrapnel))
			if(metal)
				metal.add_charge(1000)
		else if(istype(W, /obj/item/material/shard))
			if(glass)
				glass.add_charge(1000)
		else if(istype(W, /obj/item/reagent_containers/food/snacks/grown))
			if(wood)
				wood.add_charge(4000)
		else if(istype(W, /obj/item/pipe))
			continue // This allows drones and engiborgs to clear pipe assemblies from floors.
		else if(istype(W, /obj/item/broken_bottle))
			if(glass)
				glass.add_charge(2000)
		else if(istype(W, /obj/item/reagent_containers/food/drinks/cans))
			var/obj/item/reagent_containers/food/drinks/cans/C = W
			if(!C.reagents || !C.reagents.total_volume)
				if(metal)
					metal.add_charge(500)
			else
				to_chat(user, SPAN_WARNING("\the [W] is not empty, let the owner finish their drink first!"))
				return
		else
			continue

		qdel(W)
		grabbed_something = TRUE

	if(grabbed_something)
		to_chat(user, SPAN_NOTICE("You deploy your decompiler and clear out the contents of \the [T]."))
	else
		to_chat(user, SPAN_WARNING("Nothing on \the [T] is useful to you."))
	return

/obj/item/matter_decompiler/proc/attempt_decompile_creature(mob/living/M, mob/living/user)
	if(is_decompiling)
		return //we're busy

	//First, let's see if we're cannibalizing an inert drone as a drone
	if(isDrone(M) && !M.client)
		var/mob/living/silicon/robot/D = src.loc
		if(!istype(D))
			return //If we're not also a drone, begone

		to_chat(D, SPAN_NOTICE("You begin decompiling [M]."))
		is_decompiling = TRUE

		if(!do_after(D,50))
			to_chat(D, SPAN_WARNING("You need to remain still while decompiling such a large object."))
			is_decompiling = FALSE
			return

		is_decompiling = FALSE
		if(!M || !D)
			return

		to_chat(D, SPAN_NOTICE("You carefully and thoroughly decompile \the [M], storing as much of its resources as you can within yourself."))
		qdel(M)
		new /obj/effect/decal/cleanable/blood/oil(get_turf(src))

		if(metal)
			metal.add_charge(15000)
		if(glass)
			glass.add_charge(15000)
		if(wood)
			wood.add_charge(2000)
		if(plastic)
			plastic.add_charge(1000)
		return

	//If we're not cannibalizing, check if we're removing a small pest.
	//Only small, organic pests, like rats, lizards, tindalos, etc.
	if(!isanimal(M) || M.isSynthetic() || M.mob_size > 3)
		return

	var/mob/living/simple_animal/victim = M

	//Do not let drones suck up antag borers. They can clean the bodies tho.
	if(istype(victim, /mob/living/simple_animal/borer) && M.stat != DEAD)
		to_chat(user, SPAN_WARNING("You can't seem to get \the [victim] into your [name]!"))
		return

	//We're good to crunch them up
	var/turf/T = get_turf(src)
	T.visible_message(SPAN_DANGER("\The [user] sucks \the [victim] into its decompiler. There's a horrible crunching noise."),
		SPAN_NOTICE("It's a bit of a struggle, but you manage to suck \the [victim] into your decompiler. It makes a series of visceral crunching noises."))
	new /obj/effect/decal/cleanable/blood/splatter(get_turf(src))
	playsound(get_turf(user), 'sound/effects/squelch1.ogg', 60)
	if(wood)
		wood.add_charge(1000)
	qdel(victim)
	return

//PRETTIER TOOL LIST. // bullshit
/mob/living/silicon/robot/drone/installed_modules()
	if(weapon_lock)
		to_chat(src, SPAN_WARNING("Weapon lock active, unable to use modules! Count:[weapon_lock_time]"))
		return

	if(!module)
		module = new /obj/item/robot_module/drone(src)

	var/dat = "<HEAD><TITLE>Drone modules</TITLE></HEAD><BODY>\n"
	dat += {"
	<B>Activated Modules</B>
	<BR>
	Module 1: [module_state_1 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_1]>[module_state_1]<A>" : "No Module"]<BR>
	Module 2: [module_state_2 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_2]>[module_state_2]<A>" : "No Module"]<BR>
	Module 3: [module_state_3 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_3]>[module_state_3]<A>" : "No Module"]<BR>
	<BR>
	<B>Installed Modules</B><BR><BR>"}


	var/tools = "<B>Tools and devices</B><BR>"
	var/resources = "<BR><B>Resources</B><BR>"

	for(var/O in module.modules)
		var/module_string = ""
		if(!O)
			module_string += text("<B>Resource depleted</B><BR>")
		else if(activated(O))
			module_string += text("[O]: <B>Activated</B><BR>")
		else
			module_string += text("[O]: <A HREF=?src=\ref[src];act=\ref[O]>Activate</A><BR>")

		var/obj/item/I = O
		if((istype(I, /obj/item) || istype(I, /obj/item/device)) && !(I.iscoil()))
			tools += module_string
		else
			resources += module_string

	dat += tools

	if(emagged)
		if(!module.emag)
			dat += text("<B>Resource depleted</B><BR>")
		else if(activated(module.emag))
			dat += text("[module.emag]: <B>Activated</B><BR>")
		else
			dat += text("[module.emag]: <A HREF=?src=\ref[src];act=\ref[module.emag]>Activate</A><BR>")

	dat += resources

	src << browse(dat, "window=robotmod")
