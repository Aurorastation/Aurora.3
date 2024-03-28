//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

#define ABOVE_TABLE 1
#define UNDER_TABLE -1
/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/crate.dmi'
	icon_state = "crate"
	climbable = TRUE
	build_amt = 10
	slowdown = 0
	open_sound = 'sound/machines/crate_open.ogg'
	close_sound = 'sound/machines/crate_close.ogg'
	open_sound_volume = 35
	close_sound_volume = 50
	store_structure = TRUE
	dense_when_open = TRUE
	door_anim_squish = 0.30
	door_anim_time = 3
	door_anim_angle = 140
	door_hinge = 3.5
	var/tablestatus = 0

	var/azimuth_angle_2 = 180 //in this context the azimuth angle for over 90 degree
	var/radius_2 = 1.35
	var/static/list/animation_math //assoc list with pre calculated values

/obj/structure/closet/crate/can_open()
	if(tablestatus == UNDER_TABLE)//Can't be opened while under a table
		return 0
	. = ..()

/obj/structure/closet/crate/can_close()
	return 1

/obj/structure/closet/crate/animate_door(var/closing = FALSE)
	if(!door_anim_time)
		return
	if(!door_obj) door_obj = new
	if(animation_math == null) //checks if there is already a list for animation_math if not creates one to avoid runtimes
		animation_math = new/list()
	if(!door_anim_time == 0 && !animation_math["[door_anim_time]-[door_anim_angle]-[azimuth_angle_2]-[radius_2]-[door_hinge]"])
		animation_list()
	vis_contents |= door_obj
	door_obj.icon = icon
	door_obj.icon_state = "[icon_door || icon_state]_door"
	is_animating_door = TRUE
	var/num_steps = door_anim_time / world.tick_lag
	var/list/animation_math_list = animation_math["[door_anim_time]-[door_anim_angle]-[azimuth_angle_2]-[radius_2]-[door_hinge]"]
	for(var/I in 0 to num_steps)
		var/door_state = I == (closing ? num_steps : 0) ? "[icon_door || icon_state]_door" : animation_math_list[closing ? 2 * num_steps - I : num_steps + I] <= 0 ? "[icon_door_override ? icon_door : icon_state]_back" : "[icon_door || icon_state]_door"
		var/door_layer = I == (closing ? num_steps : 0) ? ABOVE_HUMAN_LAYER : animation_math_list[closing ? 2 * num_steps - I : num_steps + I] <= 0 ? FLOAT_LAYER : ABOVE_HUMAN_LAYER
		var/matrix/M = get_door_transform(I == (closing ? num_steps : 0) ? 0 : animation_math_list[closing ? num_steps - I : I], I == (closing ? num_steps : 0) ? 1 : animation_math_list[closing ?  2 * num_steps - I : num_steps + I])
		if(I == 0)
			door_obj.transform = M
			door_obj.icon_state = door_state
			door_obj.layer = door_layer
		else if(I == 1)
			animate(door_obj, transform = M, icon_state = door_state, layer = door_layer, time = world.tick_lag, flags = ANIMATION_END_NOW)
		else
			animate(transform = M, icon_state = door_state, layer = door_layer, time = world.tick_lag)
	addtimer(CALLBACK(src, PROC_REF(end_door_animation)),door_anim_time,TIMER_UNIQUE|TIMER_OVERRIDE)

/obj/structure/closet/crate/get_door_transform(crateanim_1, crateanim_2)
	var/matrix/M = matrix()
	M.Translate(0, -door_hinge)
	M.Multiply(matrix(1, crateanim_1, 0, 0, crateanim_2, 0))
	M.Translate(0, door_hinge)
	return M

/obj/structure/closet/crate/proc/animation_list() //pre calculates a list of values for the crate animation cause byond not like math
	var/num_steps_1 = door_anim_time / world.tick_lag
	var/list/new_animation_math_sublist[num_steps_1 * 2]
	for(var/I in 1 to num_steps_1) //loop to save the animation values into the lists
		var/angle_1 = door_anim_angle * (I / num_steps_1)
		var/polar_angle = abs(arcsin(cos(angle_1)))
		var/azimuth_angle = angle_1 >= 90 ? azimuth_angle_2 : 0
		var/radius_cr = angle_1 >= 90 ? radius_2 : 1
		new_animation_math_sublist[I] = -sin(polar_angle) * sin(azimuth_angle) * radius_cr
		new_animation_math_sublist[num_steps_1 + I] = cos(azimuth_angle) * sin(polar_angle) * radius_cr
	animation_math["[door_anim_time]-[door_anim_angle]-[azimuth_angle_2]-[radius_2]-[door_hinge]"] = new_animation_math_sublist

/*
==========================
	Table interactions
==========================
*/
/obj/structure/closet/crate/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover, /obj/structure/closet/crate))//Handle interaction with other crates
		var/obj/structure/closet/crate/C = mover
		if (tablestatus && tablestatus != C.tablestatus) // Crates can go under tables with crates on top of them, and vice versa
			return TRUE
		else
			return FALSE
	if (istype(mover,/obj/item/projectile))
		// Crates on a table always block shots, otherwise they only occasionally do so.
		return tablestatus == ABOVE_TABLE ? FALSE : (prob(15) ? FALSE : TRUE)
	else if(istype(mover) && mover.checkpass(PASSTABLE) && tablestatus == ABOVE_TABLE)
		return TRUE
	return ..()

/obj/structure/closet/crate/Move(var/turf/destination, dir)
	if(..())
		if (locate(/obj/structure/table) in destination)
			if(locate(/obj/structure/table/rack) in destination)
				set_tablestatus(ABOVE_TABLE)
			else if(tablestatus != ABOVE_TABLE)
				set_tablestatus(UNDER_TABLE)//Slide under the table
		else
			set_tablestatus(FALSE)

/obj/structure/closet/crate/toggle(var/mob/user)
	if(!opened && tablestatus == UNDER_TABLE)
		to_chat(user, SPAN_WARNING("You can't open \the [src] while the lid is obstructed!"))
		return FALSE
	else
		return ..()

/obj/structure/closet/crate/proc/set_tablestatus(var/target)
	if (tablestatus != target)
		tablestatus = target

	spawn(3)//Short spawn prevents things popping up where they shouldnt
		switch (target)
			if (ABOVE_TABLE)
				layer = ABOVE_TABLE_LAYER
				pixel_y = 8
			if (FALSE)
				layer = initial(layer)
				pixel_y = 0
			if (UNDER_TABLE)
				layer = BELOW_TABLE_LAYER
				pixel_y = -4

//For putting on tables
/obj/structure/closet/crate/MouseDrop(atom/over_object)
	if (istype(over_object, /obj/structure/table))
		put_on_table(over_object, usr)
		return TRUE
	else
		return ..()

/obj/structure/closet/crate/proc/put_on_table(var/obj/structure/table/table, var/mob/user)
	if (!table || !user || (tablestatus == UNDER_TABLE))
		return

	//User must be in reach of the crate
	if (!user.Adjacent(src))
		to_chat(user, SPAN_WARNING("You need to be closer to the crate!"))
		return

	//One of us has to be near the table
	if (!user.Adjacent(table) && !Adjacent(table))
		to_chat(user, SPAN_WARNING("Take the crate closer to the table!"))
		return

	for (var/obj/structure/closet/crate/C in get_turf(table))
		if (C.tablestatus != UNDER_TABLE)
			to_chat(user, SPAN_WARNING("There's already a crate on this table!"))
			return

	//Crates are heavy, hauling them onto tables is hard.
	//The more stuff thats in it, the longer it takes
	//Good place to factor in Strength in future
	var/timeneeded = 2 SECONDS

	if (tablestatus == ABOVE_TABLE && Adjacent(table))
		//Sliding along a tabletop we're already on. Instant and silent
		timeneeded = 0
		return TRUE
	else
		//Add time based on mass of contents
		for (var/obj/O in contents)
			timeneeded += 3* O.w_class
		for (var/mob/M in contents)
			timeneeded += 3* M.mob_size

	if (timeneeded > 0)
		user.visible_message("[user] starts hoisting \the [src] onto \the [table].", "You start hoisting \the [src] onto \the [table]. This will take about [timeneeded * 0.1] seconds.")
		user.face_atom(src)
		if (!do_after(user, timeneeded, src))
			return FALSE
		else
			forceMove(get_turf(table))
			set_tablestatus(ABOVE_TABLE)
			return TRUE

/*
=====================
	Secure Crates
=====================
*/

/obj/structure/closet/crate/secure
	name = "secure crate"
	desc = "A secure crate."
	icon_state = "secure_crate"
	locked = TRUE
	secure = TRUE
	secure_lights = TRUE
	health = 200

/obj/structure/closet/crate/plastic
	name = "plastic crate"
	desc = "A rectangular plastic crate."
	icon_state = "plastic_crate"

/obj/structure/closet/crate/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon_state = "coffin"
	build_amt = 5
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
	door_anim_angle = 140
	azimuth_angle_2 = 180
	door_anim_time = 5
	door_hinge = 5

/obj/structure/closet/crate/internals
	name = "internals crate"
	desc = "A internals crate."
	icon_state = "o2_crate"

/obj/structure/closet/crate/trashcart
	name = "trash cart"
	desc = "A heavy, metal trashcart with wheels."
	icon_state = "trashcart"
	door_hinge = 2.5

/obj/structure/closet/crate/miningcart
	desc = "A mining cart. This one doesn't work on rails, but has to be dragged."
	name = "mining cart"
	icon_state = "miningcart"
	door_hinge = 2.5

/obj/structure/closet/crate/miningcart/ore/fill()
	var/i_max = rand(3, 6)
	for(var/i in 1 to i_max)
		var/o = pickweight(
			list(
				/obj/item/ore = 2,
				/obj/item/ore/coal = 3,
				/obj/item/ore/diamond = 1,
				/obj/item/ore/glass = 3,
				/obj/item/ore/aluminium = 3,
				/obj/item/ore/gold = 2,
				/obj/item/ore/iron = 3,
				/obj/item/ore/osmium = 1,
				/obj/item/ore/lead = 2,
				/obj/item/ore/silver = 2,
				/obj/item/ore/slag = 1,
				/obj/item/ore/uranium = 1
			)
		)
		var/j_max = rand(4, 10)
		for(var/j in 1 to j_max)
			new o(src)

/*these aren't needed anymore
/obj/structure/closet/crate/hat
	desc = "A crate filled with Valuable Collector's Hats!."
	name = "Hat Crate"
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"

/obj/structure/closet/crate/contraband
	name = "Poster crate"
	desc = "A random assortment of posters manufactured by providers NOT listed under NanoTrasen's whitelist."
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"
*/

/obj/structure/closet/crate/medical
	name = "medical crate"
	desc = "A medical crate."
	icon_state = "medical_crate"

/obj/structure/closet/crate/rfd
	name = "\improper RFD C-Class crate"
	desc = "A crate with a Rapid-Fabrication-Device C-Class."
	icon_state = "eng_tool"
	icon_door_override = TRUE
	icon_door = "eng"

/obj/structure/closet/crate/rfd/fill()
	new /obj/item/rfd_ammo(src)
	new /obj/item/rfd_ammo(src)
	new /obj/item/rfd_ammo(src)
	new /obj/item/rfd/construction(src)

/obj/structure/closet/crate/solar
	name = "solar pack crate"
	icon_state = "eng_elec"
	icon_door_override = TRUE
	icon_door = "eng"

/obj/structure/closet/crate/solar/fill()
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/circuitboard/solar_control(src)
	new /obj/item/tracker_electronics(src)
	new /obj/item/paper/solar(src)

/obj/structure/closet/crate/freezer
	name = "freezer"
	desc = "A freezer."
	icon_state = "freezer"
	door_hinge = 4.5
	var/target_temp = T0C - 40
	var/cooling_power = 40

/obj/structure/closet/crate/freezer/return_air()
	var/datum/gas_mixture/gas = (..())
	if(!gas)	return null
	var/datum/gas_mixture/newgas = new/datum/gas_mixture()
	newgas.copy_from(gas)
	if(newgas.temperature <= target_temp)	return

	if((newgas.temperature - cooling_power) > target_temp)
		newgas.temperature -= cooling_power
	else
		newgas.temperature = target_temp
	return newgas

/obj/structure/closet/crate/freezer/rations
	name = "emergency rations"
	desc = "A crate of emergency rations and bottles of water."

/obj/structure/closet/crate/freezer/rations/fill()
	for(var/i=1,i<=6,i++)
		new /obj/random/mre(src)
		new /obj/item/reagent_containers/food/drinks/waterbottle(src)

/obj/structure/closet/crate/freezer/kois
	name = "freezer"
	desc = "A freezer, painted in a sickly yellow, with a biohazard sign on the side."
	icon_state = "freezer_kois"

/obj/structure/closet/crate/freezer/kois/rations
	name = "emergency k'ois rations"
	desc = "A crate of emergency k'ois rations and bottles of water. Painted in a sickly yellow, with a biohazard sign on the side."

/obj/structure/closet/crate/freezer/kois/rations/fill()
	for(var/i=1,i<=6,i++)
		new /obj/item/storage/box/fancy/mre/menu12(src)
		new /obj/item/reagent_containers/food/drinks/waterbottle(src)

/obj/structure/closet/crate/bin
	name = "large bin"
	desc = "A large bin."
	icon_state = "largebin"

/obj/structure/closet/crate/bin/filled/fill()
	for(var/i=1,i<=6,i++)
		new /obj/random/junk(src)

/obj/structure/closet/crate/drop
	name = "drop crate"
	desc = "A large, sturdy crate meant for airdrops."
	icon_state = "drop_crate"
	door_hinge = 0.5

/obj/structure/closet/crate/drop/grey
	name = "drop crate"
	desc = "A large, sturdy crate meant for airdrops."
	icon_state = "drop_crate-grey"
	door_hinge = 0.5

/obj/structure/closet/crate/tool
	name = "tool crate"
	desc = "It's a crate for storing tools."
	icon_state = "eng_tool"
	icon_door_override = TRUE
	icon_door = "eng"

/obj/structure/closet/crate/rad
	name = "radioactive gear crate"
	desc = "A crate with a radiation sign on it."
	icon_state = "eng_rad"
	icon_door_override = TRUE
	icon_door = "eng"

/obj/structure/closet/crate/rad/gear/fill()
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)

/obj/structure/closet/crate/elec
	name = "electrical supplies crate"
	desc = "It's a crate for storing electrical equipment."
	icon_state = "eng_elec"
	icon_door_override = TRUE
	icon_door = "eng"

/obj/structure/closet/crate/weld
	name = "welding supplies crate"
	desc = "It's a crate for storing welding tools."
	icon_state = "eng_weld"
	icon_door_override = TRUE
	icon_door = "eng"

/obj/structure/closet/crate/secure/aimodules
	name = "AI modules crate"
	desc = "A secure crate full of AI modules."
	icon_state = "science_crate"
	req_access = list(ACCESS_CENT_SPECOPS)

/obj/structure/closet/crate/secure/aimodules/fill()
	for(var/moduletype in subtypesof(/obj/item/aiModule))
		new moduletype(src)

/obj/structure/closet/crate/weapon
	name = "weapons crate"
	desc = "A weapons crate."
	icon_state = "syndi_crate" //haha this pun was totally worth it.

/obj/structure/closet/crate/weapon/alt
	icon_state = "syndi_crate1"

/obj/structure/closet/crate/secure/weapon
	name = "weapons crate"
	desc = "A secure weapons crate."
	icon_state = "syndi_secure_crate"
	icon_door_override = TRUE
	icon_door = "syndi_crate"

/obj/structure/closet/crate/secure/weapon/alt
	icon_state = "syndi_secure_crate1"
	icon_door = "syndi_crate1"

/obj/structure/closet/crate/secure/legion
	name = "foreign legion supply crate"
	desc = "A secure supply crate, It carries the insignia of the Tau Ceti Foreign Legion. It appears quite scuffed."
	icon_state = "tcfl_crate"
	req_access = list(ACCESS_LEGION)

/obj/structure/closet/crate/secure/phoron
	name = "phoron crate"
	desc = "A secure phoron crate."
	icon_state = "phoron_crate"
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'

/obj/structure/closet/crate/secure/gear
	name = "gear crate"
	desc = "A secure gear crate."
	icon_state = "secgear_crate"

/obj/structure/closet/crate/secure/hydrosec
	name = "secure hydroponics crate"
	desc = "A crate with a lock on it, painted in the scheme of the station's botanists."
	icon_state = "hydro_secure_crate"
	req_one_access = list(ACCESS_HYDROPONICS, ACCESS_XENOBOTANY)

/obj/structure/closet/crate/secure/bin
	name = "secure bin"
	desc = "A secure bin."
	icon_state = "largebins"
	icon_door_overlay = "largebin"
	icon_door_override = TRUE
	icon_door = "largebin"

/obj/structure/closet/crate/large
	name = "large crate"
	desc = "A hefty metal crate."
	icon_state = "largemetal"
	health = 200
	door_anim_time = 0

/obj/structure/closet/crate/large/close()
	. = ..()
	if (.)//we can hold up to one large item
		var/found = 0
		for(var/obj/structure/S in loc)
			if(S == src)
				continue
			if(!S.anchored)
				found = 1
				S.forceMove(src)
				break
		if(!found)
			for(var/obj/machinery/M in loc)
				if(!M.anchored)
					M.forceMove(src)
					break
	return

/obj/structure/closet/crate/secure/large
	name = "large crate"
	desc = "A hefty metal crate with an electronic locking system."
	icon_state = "largemetal"
	icon_door_overlay = "largemetal"
	health = 400
	secure_lights = FALSE
	door_anim_time = 0

/obj/structure/closet/crate/secure/large/close()
	. = ..()
	if (.)//we can hold up to one large item
		var/found = 0
		for(var/obj/structure/S in loc)
			if(S == src)
				continue
			if(!S.anchored)
				found = 1
				S.forceMove(src)
				break
		if(!found)
			for(var/obj/machinery/M in loc)
				if(!M.anchored)
					M.forceMove(src)
					break
	return

/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon_state = "hydro_crate"

/obj/structure/closet/crate/hydroponics/prespawned

//This exists so the prespawned hydro crates spawn with their contents.
/obj/structure/closet/crate/hydroponics/prespawned/fill()
	new /obj/item/reagent_containers/spray/plantbgone(src)
	new /obj/item/reagent_containers/spray/plantbgone(src)
	new /obj/item/material/minihoe(src)
//	new /obj/item/weedspray(src)
//	new /obj/item/weedspray(src)
//	new /obj/item/pestspray(src)
//	new /obj/item/pestspray(src)
//	new /obj/item/pestspray(src)



//A crate that populates itself with randomly selected loot from randomstock.dm
//Can be passed in a rarity value, which is used as a multiplier on the rare/uncommon chance
//Quantity of spawns is number of discrete selections from the loot lists, default 10

/obj/structure/closet/crate/loot
	icon = 'icons/obj/random.dmi'
	icon_state = "loot_crate"
	var/rarity = 1
	var/quantity = 10
	var/list/spawntypes

/obj/structure/closet/crate/loot/Initialize(mapload, no_fill)
	. = ..()

	spawntypes = list(
		"1" = STOCK_RARE_PROB * rarity,
		"2" = STOCK_UNCOMMON_PROB * rarity,
		"3" = (100 - ((STOCK_RARE_PROB * rarity) + (STOCK_UNCOMMON_PROB * rarity)))
	)

	var/list/crates_to_use = typesof(/obj/structure/closet/crate) - typesof(/obj/structure/closet/crate/secure/gear_loadout)
	crates_to_use -= /obj/structure/closet/crate/loot
	var/icontype = pick(crates_to_use)
	var/obj/structure/closet/crate/C = new icontype(get_turf(src), TRUE) //TRUE as we do not want the crate to fill(), we will fill it ourselves.

	C.name = "unusual container"
	C.desc = "A mysterious container of unknown origins. What mysteries lie within?"

	for(var/i in 1 to quantity)
		var/newtype = get_spawntype()
		call(newtype)(C)

	if(C.secure || C.locked) //These should always be accessible
		C.secure = FALSE
		C.locked = FALSE
		C.secure_lights = FALSE
		C.req_access = null

	C.anchored = FALSE

	C.update_icon()

	qdel(src)

/obj/structure/closet/crate/loot/proc/get_spawntype()
	var/stocktype = pickweight(spawntypes)
	switch (stocktype)
		if ("1")
			return pickweight(random_stock_rare)
		if ("2")
			return pickweight(random_stock_uncommon)
		if ("3")
			return pickweight(random_stock_common)

/obj/structure/closet/crate/extinguisher_cartridges
	name = "crate of extinguisher cartridges"
	desc = "Contains a dozen empty extinguisher cartridges."
	icon_state = "fire"

/obj/structure/closet/crate/extinguisher_cartridges/fill()
	for(var/a = 1 to 12)
		new /obj/item/reagent_containers/extinguisher_refill(src)

/obj/structure/closet/crate/autakh
	name = "aut'akh crate"
	desc = "Contains a number of limbs and augmentations created by the Aut'akh Commune."
	icon_state = "autakh_crate"

/obj/structure/closet/crate/autakh/fill()
	new /obj/item/organ/external/arm/right/autakh(src)
	new /obj/item/organ/external/arm/right/autakh(src)
	new /obj/item/organ/external/arm/autakh(src)
	new /obj/item/organ/external/arm/autakh(src)
	new /obj/item/organ/external/hand/autakh(src)
	new /obj/item/organ/external/hand/autakh(src)
	new /obj/item/organ/external/hand/right/autakh(src)
	new /obj/item/organ/external/hand/right/autakh(src)
	new /obj/item/organ/external/leg/autakh(src)
	new /obj/item/organ/external/leg/autakh(src)
	new /obj/item/organ/external/leg/right/autakh(src)
	new /obj/item/organ/external/leg/right/autakh(src)
	new /obj/item/organ/external/foot/autakh(src)
	new /obj/item/organ/external/foot/autakh(src)
	new /obj/item/organ/external/foot/right/autakh(src)
	new /obj/item/organ/external/foot/right/autakh(src)
	new /obj/item/organ/external/hand/right/autakh/tool(src)
	new /obj/item/organ/external/hand/right/autakh/tool/mining(src)
	new /obj/item/organ/external/hand/right/autakh/medical(src)
	new /obj/item/organ/external/hand/right/autakh/security(src)

/obj/structure/closet/crate/security
	name = "security crate"
	desc = "A secure security crate. Secure."
	icon_state = "security_crate"
	secure = TRUE
