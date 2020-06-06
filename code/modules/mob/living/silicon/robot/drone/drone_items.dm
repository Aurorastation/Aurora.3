
//TODO: Matter decompiler.
/obj/item/matter_decompiler
	name = "matter decompiler"
	desc = "Eating trash, bits of glass, or other debris will replenish your stores."
	icon = 'icons/obj/device.dmi'
	icon_state = "decompiler"

	//Metal, glass, wood, plastic.
	var/datum/matter_synth/metal
	var/datum/matter_synth/glass
	var/datum/matter_synth/wood
	var/datum/matter_synth/plastic

/obj/item/matter_decompiler/attack(mob/living/carbon/M, mob/living/carbon/user)
	return

/obj/item/matter_decompiler/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, proximity, params)
	if(!proximity)
		return //Not adjacent.

	//We only want to deal with using this on turfs. Specific items aren't important.
	var/turf/T = get_turf(target)
	if(!istype(T))
		return

	//Used to give the right message.
	var/grabbed_something = 0

	for(var/mob/M in T)
		if(istype(M,/mob/living/silicon/robot/drone) && !M.client)
			var/mob/living/silicon/robot/D = src.loc
			if(!istype(D))
				return

			to_chat(D, SPAN_NOTICE("You begin decompiling [M]."))

			if(!do_after(D,50))
				to_chat(D, SPAN_WARNING("You need to remain still while decompiling such a large object."))
				return

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

		else if(istype(M,/mob/living/simple_animal) && M.mob_size <= 3 && !istype(M, /mob/living/simple_animal/cat)) //includes things like rats, lizards, tindalos while excluding bigger things and station pets.
			src.loc.visible_message(SPAN_DANGER("\The [src.loc] sucks \the [M] into its decompiler. There's a horrible crunching noise."), SPAN_NOTICE("It's a bit of a struggle, but you manage to suck \the [M] into your decompiler. It makes a series of visceral crunching noises."))
			new /obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			playsound(src.loc, 'sound/effects/squelch1.ogg')
			qdel(M)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			return
		else
			continue

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
			// This allows drones and engiborgs to clear pipe assemblies from floors.
		else if(istype(W, /obj/item/broken_bottle))
			if(glass)
				glass.add_charge(2000)
		else
			continue

		qdel(W)
		grabbed_something = TRUE

	if(grabbed_something)
		to_chat(user, SPAN_NOTICE("You deploy your decompiler and clear out the contents of \the [T]."))
	else
		to_chat(user, SPAN_WARNING("Nothing on \the [T] is useful to you."))
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