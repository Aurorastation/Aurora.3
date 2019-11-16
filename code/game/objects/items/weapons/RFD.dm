//Contains the rapid construction device.
/obj/item/rfd
	name = "\improper Rapid-Fabrication-Device"
	desc = "A device used for rapid fabrication. The matter decompression matrix is untuned, rendering it useless."
	icon = 'icons/obj/tools.dmi'
	icon_state = "rfd"
	opacity = 0
	density = 0
	anchored = 0.0
	flags = CONDUCT
	force = 10.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 50000)
	drop_sound = 'sound/items/drop/gun.ogg'
	var/datum/effect_system/sparks/spark_system
	var/stored_matter = 30 // Starts off full.
	var/working = 0
	var/mode = 1
	var/number_of_modes = 1
	var/modes = null
	var/crafting = FALSE

/obj/item/rfd/Initialize()
	. = ..()
	src.spark_system = bind_spark(src, 5)
	update_icon()

/obj/item/rfd/Destroy()
	qdel(spark_system)
	spark_system = null
	return ..()

/obj/item/rfd/attack()
	return 0

/obj/item/rfd/proc/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && user.get_active_hand() == src && !user.stat && !user.restrained())

/obj/item/rfd/examine(var/mob/user)
	..()
	if(loc == user)
		to_chat(usr, "It currently holds [stored_matter]/30 matter-units.")

/obj/item/rfd/attack_self(mob/user)
	//Change the mode
	if(++mode > number_of_modes) mode = 1
	to_chat(user, "<span class='notice'>Changed mode to '[modes[mode]]'</span>")
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
	if(prob(20)) src.spark_system.queue()

/obj/item/rfd/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/rfd_ammo))
		if((stored_matter + 10) > 30)
			to_chat(user, "<span class='notice'>The RFD can't hold any more matter-units.</span>")
			return
		//TODO: Possible better animation
		user.drop_from_inventory(W,src)
		qdel(W)
		stored_matter += 10
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, "<span class='notice'>The RFD now holds [stored_matter]/30 matter-units.</span>")
		update_icon()
		return

	if(W.isscrewdriver())  // Turning it into a crossbow
		crafting = !crafting
		if(!crafting)
			to_chat(user, "<span class='notice'>You reassemble the RFD</span>")
		else
			to_chat(user, "<span class='notice'>The RFD can now be modified.</span>")
		src.add_fingerprint(user)
		return

	if((crafting) && (istype(W,/obj/item/crossbowframe)))
		var/obj/item/crossbowframe/F = W
		if(F.buildstate == 5)
			if(!user.unEquip(src))
				return
			qdel(F)
			var/obj/item/gun/launcher/crossbow/RFD/CB = new(get_turf(user)) // can be found in crossbow.dm
			forceMove(CB)
			CB.stored_matter = src.stored_matter
			add_fingerprint(user)
			return
		else
			to_chat(user, "<span class='notice'>You need to fully assemble the crossbow frame first!</span>")
			return
	..()


/obj/item/rfd/proc/useResource(var/amount, var/mob/user)
	if(stored_matter < amount)
		return 0
	stored_matter -= amount
	update_icon()
	return 1

/obj/item/rfd/update_icon()	//For the fancy "ammo" counter
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
	w_class = 2
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 30000,"glass" = 15000)

/*
RFD Construction-Class
*/

/obj/item/rfd/construction
	name = "\improper Rapid-Fabrication-Device C-Class"
	desc = "A RFD, modified to construct walls and floors."
	modes = list("Floor & Walls","Airlock","Deconstruct")
	number_of_modes = 3
	var/canRwall = 0
	var/disabled = 0

/obj/item/rfd/construction/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	if(disabled && !isrobot(user))
		return 0
	if(istype(get_area(A),/area/shuttle)||istype(get_area(A),/turf/space/transit))
		return 0
	var/turf/t = get_turf(A)
	if (isNotStationLevel(t.z))
		return 0
	return alter_turf(A,user,(mode == 3))

/obj/item/rfd/construction/proc/alter_turf(var/turf/T,var/mob/user,var/deconstruct)

	var/build_cost = 0
	var/build_type
	var/build_turf
	var/build_delay
	var/build_other

	if(working == 1)
		return 0

	if(mode == 3 && istype(T,/obj/machinery/door/airlock))
		build_cost =  10
		build_delay = 50
		build_type = "airlock"
	else if(mode == 2 && !deconstruct && istype(T,/turf/simulated/floor))
		build_cost =  10
		build_delay = 50
		build_type = "airlock"
		build_other = /obj/machinery/door/airlock
	else if(!deconstruct && (istype(T,/turf/space) || istype(T,T.baseturf)))
		build_cost =  1
		build_type =  "floor"
		build_turf =  /turf/simulated/floor/airless
	else if(deconstruct && istype(T,/turf/simulated/wall))
		var/turf/simulated/wall/W = T
		build_delay = deconstruct ? 50 : 40
		build_cost =  5
		build_type =  (!canRwall && W.reinf_material) ? null : "wall"
		build_turf =  /turf/simulated/floor
	else if(istype(T,/turf/simulated/floor))
		build_delay = deconstruct ? 50 : 20
		build_cost =  deconstruct ? 10 : 3
		build_type =  deconstruct ? "floor" : "wall"
		build_turf =  deconstruct ? T.baseturf : /turf/simulated/wall
	else
		return 0

	if(!build_type)
		working = 0
		return 0

	if(!useResource(build_cost, user))
		user << "The \'Low Ammo\' light on the device blinks yellow."
		flick("[icon_state]-empty", src)
		return 0

	playsound(src.loc, 'sound/machines/click.ogg', 50, 1)

	working = 1
	to_chat(user, "[(deconstruct ? "Deconstructing" : "Building")] [build_type]...")

	if(build_delay && !do_after(user, build_delay))
		working = 0
		return 0

	working = 0
	if(build_delay && !can_use(user,T))
		return 0

	if(build_turf)
		T.ChangeTurf(build_turf)
	else if(build_other)
		new build_other(T)
	else
		qdel(T)

	playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	return 1

/obj/item/rfd/construction/borg
	canRwall = 1

/obj/item/rfd/construction/borg/useResource(var/amount, var/mob/user)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			var/cost = amount*30
			if(R.cell.charge >= cost)
				R.cell.use(cost)
				return 1
	return 0

/obj/item/rfd/construction/borg/infinite/useResource()
	return 1

/obj/item/rfd/construction/borg/attackby()
	return

/obj/item/rfd/construction/borg/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && !user.stat)


/obj/item/rfd/construction/mounted/useResource(var/amount, var/mob/user)
	var/cost = amount*130 //so that a rig with default powercell can build ~2.5x the stuff a fully-loaded RFD-C can.
	if(istype(loc,/obj/item/rig_module))
		var/obj/item/rig_module/module = loc
		if(module.holder && module.holder.cell)
			if(module.holder.cell.charge >= cost)
				module.holder.cell.use(cost)
				return 1
	return 0

/obj/item/rfd/construction/mounted/attackby()
	return

/obj/item/rfd/construction/mounted/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && !user.stat && !user.restrained())

/*
RFD Service-Class
*/

/obj/item/rfd/service
	name = "\improper Rapid-Fabrication-Device S-Class"
	desc = "A RFD, modified to deploy service items."
	modes = list("Cigarette", "Drinking Glass","Paper","Pen","Dice Pack")
	number_of_modes = 5

/obj/item/rfd/service/resolve_attackby(atom/A, mob/user as mob, var/click_parameters)
	if(istype(user,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = user
		if(R.stat || !R.cell || R.cell.charge <= 0)
			return
	else
		if(stored_matter <= 0)
			user << "The \'Low Ammo\' light on the device blinks yellow."
			flick("[icon_state]-empty", src)
			return

	if(!istype(A, /obj/structure/table) && !istype(A, /turf/simulated/floor))
		return

	playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
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

/*
RFD Mining-Class
*/

/obj/item/rfd/mining
	name = "\improper Rapid-Fabrication-Device M-Class"
	desc = "A RFD, modified to deploy mine tracks."

/obj/item/rfd/mining/afterattack(atom/A, mob/user as mob, proximity)

	if(!proximity) return

	if(istype(user,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = user
		if(R.stat || !R.cell || R.cell.charge <= 0)
			return
	else
		if(stored_matter <= 0)
			user << "The \'Low Ammo\' light on the device blinks yellow."
			flick("[icon_state]-empty", src)
			return

	if(!istype(A, /turf/simulated/floor) && !istype(A, /turf/unsimulated/floor))
		return

	if(locate(/obj/structure/track) in A)
		return

	playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
	var/used_energy = 0

	used_energy = 10

	new /obj/structure/track(get_turf(A))

	to_chat(user, "Dispensing track...")
	update_icon()

	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			R.cell.use(used_energy)

	else
		stored_matter--
		to_chat(user, "The RFD now holds [stored_matter]/30 fabrication-units.")


// Malf AI RFD Transformer.

/obj/item/rfd/transformer
	name = "\improper Rapid-Fabrication-Device T-Class"
	desc = "A device used for rapid fabrication, modified to deploy a transformer. It can only be used once and there can not be more than one made."
	stored_matter = 30
	var/malftransformermade = 0

/obj/item/rfd/transformer/attack_self(mob/user)
	return

/obj/item/rfd/transformer/examine(var/mob/user)
	..()
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
		to_chat(user, "There is already a transformer machine made!")
		flick("[icon_state]-empty", src)
		return

	playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
	var/used_energy = 100
	to_chat(user, "Fabricating machine...")
	if(do_after(user, 30 SECONDS, act_target = src))
		var/obj/product = new /obj/machinery/transformer
		malftransformermade = 1
		product.forceMove(get_turf(A))
		stored_matter = 0
		update_icon()

	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			R.cell.use(used_energy)
