//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"
	climbable = 1
//	mouse_drag_pointer = MOUSE_ACTIVE_POINTER	//???
	var/rigged = 0
	var/tablestatus = 0
	pass_flags = PASSTABLE


/obj/structure/closet/crate/can_open()
	if (tablestatus != -1)//Can't be opened while under a table
		return 1
	return 0

/obj/structure/closet/crate/can_close()
	return 1

/obj/structure/closet/crate/open()
	if(opened)
		return 0
	if(!can_open())
		return 0

	if(rigged && locate(/obj/item/device/radio/electropack) in src)
		if(isliving(usr))
			var/mob/living/L = usr
			var/touchy_hand
			if(L.hand)
				touchy_hand = BP_R_HAND
			else
				touchy_hand = BP_L_HAND
			if(L.electrocute_act(17, src, ground_zero = touchy_hand))
				spark(src, 5, alldirs)
				if(L.stunned)
					return 2

	playsound(loc, 'sound/machines/click.ogg', 15, 1, -3)
	for(var/obj/O in src)
		O.forceMove(get_turf(src))

	if(climbable)
		structure_shaken()

	for (var/mob/M in src)
		M.forceMove(get_turf(src))
		if (M.stat == CONSCIOUS)
			M.visible_message(span("danger","\The [M.name] bursts out of the [src]!"), span("danger","You burst out of the [src]!"))
		else
			M.visible_message(span("danger","\The [M.name] tumbles out of the [src]!"))

	icon_state = icon_opened
	opened = 1
	pass_flags = 0
	return 1

/obj/structure/closet/crate/close()
	if(!opened)
		return 0
	if(!can_close())
		return 0

	playsound(loc, 'sound/machines/click.ogg', 15, 1, -3)
	var/itemcount = 0
	for(var/obj/O in get_turf(src))
		if(itemcount >= storage_capacity)
			break
		if(O.density || O.anchored || istype(O,/obj/structure/closet))
			continue
		if(istype(O, /obj/structure/bed)) //This is only necessary because of rollerbeds and swivel chairs.
			var/obj/structure/bed/B = O
			if(B.buckled_mob)
				continue
		O.forceMove(src)
		itemcount++

	icon_state = icon_closed
	opened = 0
	pass_flags = PASSTABLE//Crates can only slide under tables when closed
	return 1




/obj/structure/closet/crate/attackby(obj/item/W as obj, mob/user as mob)
	if(opened)
		return ..()
	else if(istype(W, /obj/item/stack/packageWrap))
		return
	else if(W.iscoil())
		var/obj/item/stack/cable_coil/C = W
		if(rigged)
			to_chat(user, "<span class='notice'>[src] is already rigged!</span>")
			return
		if (C.use(1))
			to_chat(user, "<span class='notice'>You rig [src].</span>")
			rigged = 1
			return
	else if(istype(W, /obj/item/device/radio/electropack))
		if(rigged)
			to_chat(user, "<span class='notice'>You attach [W] to [src].</span>")
			user.drop_from_inventory(W,src)
			return
	else if(W.iswirecutter())
		if(rigged)
			to_chat(user, "<span class='notice'>You cut away the wiring.</span>")
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
			rigged = 0
			return
	else return attack_hand(user)

/obj/structure/closet/crate/ex_act(severity)
	switch(severity)
		if(1)
			health -= rand(120, 240)
		if(2)
			health -= rand(60, 120)
		if(3)
			health -= rand(30, 60)

	if (health <= 0)
		for (var/atom/movable/A as mob|obj in src)
			A.forceMove(loc)
			if (prob(50) && severity > 1)//Higher chance of breaking contents
				A.ex_act(severity-1)
			else
				A.ex_act(severity)
		qdel(src)





/*
==========================
	Table interactions
==========================
*/
/obj/structure/closet/crate/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover, /obj/structure/closet/crate))//Handle interaction with other crates
		var/obj/structure/closet/crate/C = mover
		if (tablestatus == 1 && C.tablestatus != 1 && !C.opened)//Allow the crate to slide under us if we're ontop of a table
			return 1
		else if (tablestatus == -1 && C.tablestatus == 1)//Allow it to slide over us if we're underneath a table
			return 1
		else//Otherwise, block it. Don't allow two crates on the same level of a tile
			return 0
	if(istype(mover,/obj/item/projectile))
		if (tablestatus == 1)//They always block shots on a table
			return 0
		else if (!tablestatus && prob(15))//Usually will not block shots when lying on the floor
			return 0
		else return 1
	else if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	return ..()

/obj/structure/closet/crate/Move(var/turf/destination, dir)
	if(..())
		if (locate(/obj/structure/table) in destination)
			if (tablestatus != 1)
				set_tablestatus(-1)//Slide under the table
		else
			set_tablestatus(0)


/obj/structure/closet/crate/toggle(var/mob/user)
	if (!opened && tablestatus == -1)
		to_chat(user, span("warning", "You can't open that while it's under the table"))
		return 0
	else
		return ..()

/obj/structure/closet/crate/proc/set_tablestatus(var/target)
	if (tablestatus != target)
		tablestatus = target

	spawn(3)//Short spawn prevents things popping up where they shouldnt
		switch (target)
			if (1)
				layer = LAYER_ABOVE_TABLE
				pixel_y = 8
			if (0)
				layer = initial(layer)
				pixel_y = 0
			if (-1)
				layer = LAYER_UNDER_TABLE
				pixel_y = -4


//For putting on tables
/obj/structure/closet/crate/MouseDrop(atom/over_object)
	if (istype(over_object, /obj/structure/table))
		put_on_table(over_object, usr)
		return 1
	else
		return ..()



/obj/structure/closet/crate/proc/put_on_table(var/obj/structure/table/table, var/mob/user)
	if (!table || !user || (tablestatus == -1))
		return

	//User must be in reach of the crate
	if (!user.Adjacent(src))
		to_chat(user, span("warning", "You need to be closer to the crate!"))
		return

	//One of us has to be near the table
	if (!user.Adjacent(table) && !Adjacent(table))
		to_chat(user, span("warning", "Take the crate closer to the table!"))
		return


	for (var/obj/structure/closet/crate/C in get_turf(table))
		if (C.tablestatus != -1)
			to_chat(user, span("warning", "There's already a crate on this table!"))
			return

	//Crates are heavy, hauling them onto tables is hard.
	//The more stuff thats in it, the longer it takes
	//Good place to factor in Strength in future
	var/timeneeded = 20
	var/success = 0



	if (tablestatus == 1 && Adjacent(table))
		//Sliding along a tabletop we're already on. Instant and silent
		timeneeded = 0
		success = 1
	else
		//Add time based on mass of contents
		for (var/obj/O in contents)
			timeneeded += 3* O.w_class
		for (var/mob/M in contents)
			timeneeded += 3* M.mob_size

	if (timeneeded > 0)
		user.visible_message("[user] starts hoisting [src] onto the [table]", "You start hoisting [src] onto the [table]. This will take about [timeneeded*0.1] seconds")
		user.face_atom(src)
		if (do_after(user, timeneeded, needhand = 1))
			success = 1


	if (success == 1)
		forceMove(get_turf(table))
		set_tablestatus(1)


/*
=====================
	Secure Crates
=====================
*/


/obj/structure/closet/crate/secure
	desc = "A secure crate."
	name = "Secure crate"
	icon_state = "securecrate"
	icon_opened = "securecrateopen"
	icon_closed = "securecrate"
	var/redlight = "securecrater"
	var/greenlight = "securecrateg"
	var/sparks = "securecratesparks"
	var/emag = "securecrateemag"
	var/broken = 0
	var/locked = 1
	health = 200

/obj/structure/closet/crate/secure/Initialize()
	. = ..()
	if(locked)
		cut_overlays()
		add_overlay(redlight)
	else
		cut_overlays()
		add_overlay(greenlight)

/obj/structure/closet/crate/secure/can_open()
	if (..())
		return !locked

/obj/structure/closet/crate/secure/proc/togglelock(mob/user as mob)
	if(opened)
		to_chat(user, "<span class='notice'>Close the crate first.</span>")
		return
	if(broken)
		to_chat(user, "<span class='warning'>The crate appears to be broken.</span>")
		return
	if(allowed(user))
		set_locked(!locked, user)
		return 1
	else
		to_chat(user, "<span class='notice'>Access Denied</span>")

/obj/structure/closet/crate/secure/proc/set_locked(var/newlocked, mob/user = null)
	if(locked == newlocked) return

	locked = newlocked
	if(user)
		for(var/mob/O in viewers(user, 3))
			O.show_message( "<span class='notice'>The crate has been [locked ? null : "un"]locked by [user].</span>", 1)
	cut_overlays()
	add_overlay(locked ? redlight : greenlight)

/obj/structure/closet/crate/secure/verb/verb_togglelock()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return

	if(ishuman(usr) || isrobot(usr))
		add_fingerprint(usr)
		togglelock(usr)
	else
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")

/obj/structure/closet/crate/secure/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(locked)
		return togglelock(user)
	else
		return toggle(user)

/obj/structure/closet/crate/secure/attackby(obj/item/W as obj, mob/user as mob)
	if(is_type_in_list(W, list(/obj/item/stack/packageWrap, /obj/item/stack/cable_coil, /obj/item/device/radio/electropack, /obj/item/wirecutters)))
		return ..()
	if(istype(W, /obj/item/melee/energy/blade))
		emag_act(INFINITY, user)
	if(!opened)
		togglelock(user)
		return
	return ..()

/obj/structure/closet/crate/secure/emag_act(var/remaining_charges, var/mob/user)
	if(!broken)
		cut_overlays()
		add_overlay(emag)
		add_overlay(sparks)
		CUT_OVERLAY_IN(sparks, 6)
		playsound(loc, "sparks", 60, 1)
		locked = 0
		broken = 1
		to_chat(user, "<span class='notice'>You unlock \the [src].</span>")
		return 1

/obj/structure/closet/crate/secure/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken && !opened  && prob(50/severity))
		if(!locked)
			locked = 1
			cut_overlays()
			add_overlay(redlight)
		else
			cut_overlays()
			add_overlay(emag)
			add_overlay(sparks)
			CUT_OVERLAY_IN(sparks, 6)
			playsound(loc, 'sound/effects/sparks4.ogg', 75, 1)
			locked = 0
	if(!opened && prob(20/severity))
		if(!locked)
			open()
		else
			req_access = list()
			req_access += pick(get_all_station_access())
	..()

/obj/structure/closet/crate/plastic
	name = "plastic crate"
	desc = "A rectangular plastic crate."
	icon_state = "plasticcrate"
	icon_opened = "plasticcrateopen"
	icon_closed = "plasticcrate"

/obj/structure/closet/crate/internals
	name = "internals crate"
	desc = "A internals crate."
	icon_state = "o2crate"
	icon_opened = "o2crateopen"
	icon_closed = "o2crate"

/obj/structure/closet/crate/trashcart
	name = "trash cart"
	desc = "A heavy, metal trashcart with wheels."
	icon_state = "trashcart"
	icon_opened = "trashcartopen"
	icon_closed = "trashcart"

/*these aren't needed anymore
/obj/structure/closet/crate/hat
	desc = "A crate filled with Valuable Collector's Hats!."
	name = "Hat Crate"
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"

/obj/structure/closet/crate/contraband
	name = "Poster crate"
	desc = "A random assortment of posters manufactured by providers NOT listed under Nanotrasen's whitelist."
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"
*/

/obj/structure/closet/crate/medical
	name = "medical crate"
	desc = "A medical crate."
	icon_state = "medicalcrate"
	icon_opened = "medicalcrateopen"
	icon_closed = "medicalcrate"

/obj/structure/closet/crate/rfd
	name = "\improper RFD C-Class crate"
	desc = "A crate with a Rapid-Fabrication-Device C-Class."
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"

/obj/structure/closet/crate/rfd/fill()
	new /obj/item/rfd_ammo(src)
	new /obj/item/rfd_ammo(src)
	new /obj/item/rfd_ammo(src)
	new /obj/item/rfd/construction(src)

/obj/structure/closet/crate/solar
	name = "solar pack crate"

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
	icon_opened = "freezeropen"
	icon_closed = "freezer"
	var/target_temp = T0C - 40
	var/cooling_power = 40

	return_air()
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

/obj/structure/closet/crate/freezer/rations //For use in the escape shuttle
	name = "emergency rations"
	desc = "A crate of emergency rations containing liquid food and some bottles of water."

/obj/structure/closet/crate/freezer/rations/fill()
	for(var/i=1,i<=6,i++)
		new /obj/item/reagent_containers/food/snacks/liquidfood(src)
		new /obj/item/reagent_containers/food/drinks/cans/waterbottle(src)

/obj/structure/closet/crate/bin
	name = "large bin"
	desc = "A large bin."
	icon_state = "largebin"
	icon_opened = "largebinopen"
	icon_closed = "largebin"

/obj/structure/closet/crate/drop
	name = "drop crate"
	desc = "A large, sturdy crate meant for airdrops."
	icon_state = "dropcrate"
	icon_opened = "dropcrate-open"
	icon_closed = "dropcrate"

/obj/structure/closet/crate/drop/grey
	name = "drop crate"
	desc = "A large, sturdy crate meant for airdrops."
	icon_state = "dropcrate-grey"
	icon_opened = "dropcrate-grey-open"
	icon_closed = "dropcrate-grey"

/obj/structure/closet/crate/radiation
	name = "radioactive gear crate"
	desc = "A crate with a radiation sign on it."
	icon_state = "radiation"
	icon_opened = "radiationopen"
	icon_closed = "radiation"

/obj/structure/closet/crate/radiation/fill()
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)

/obj/structure/closet/crate/secure/weapon
	name = "weapons crate"
	desc = "A secure weapons crate."
	icon_state = "weaponcrate"
	icon_opened = "weaponcrateopen"
	icon_closed = "weaponcrate"

/obj/structure/closet/crate/secure/legion
	name = "foreign legion supply crate"
	desc = "A secure supply crate, It carries the insignia of the Tau Ceti Foreign Legion. It appears quite scuffed."
	icon_state = "tcflcrate"
	icon_opened = "tcflcrateopen"
	icon_closed = "tcflcrate"
	req_access = list(access_legion)

/obj/structure/closet/crate/secure/phoron
	name = "phoron crate"
	desc = "A secure phoron crate."
	icon_state = "phoroncrate"
	icon_opened = "phoroncrateopen"
	icon_closed = "phoroncrate"

/obj/structure/closet/crate/secure/gear
	name = "gear crate"
	desc = "A secure gear crate."
	icon_state = "secgearcrate"
	icon_opened = "secgearcrateopen"
	icon_closed = "secgearcrate"

/obj/structure/closet/crate/secure/hydrosec
	name = "secure hydroponics crate"
	desc = "A crate with a lock on it, painted in the scheme of the station's botanists."
	icon_state = "hydrosecurecrate"
	icon_opened = "hydrosecurecrateopen"
	icon_closed = "hydrosecurecrate"

/obj/structure/closet/crate/secure/bin
	name = "secure bin"
	desc = "A secure bin."
	icon_state = "largebins"
	icon_opened = "largebinsopen"
	icon_closed = "largebins"
	redlight = "largebinr"
	greenlight = "largebing"
	sparks = "largebinsparks"
	emag = "largebinemag"

/obj/structure/closet/crate/large
	name = "large crate"
	desc = "A hefty metal crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largemetal"
	icon_opened = "largemetalopen"
	icon_closed = "largemetal"
	health = 200

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
	icon = 'icons/obj/storage.dmi'
	icon_state = "largemetal"
	icon_opened = "largemetalopen"
	icon_closed = "largemetal"
	redlight = "largemetalr"
	greenlight = "largemetalg"
	health = 400

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

//fluff variant
/obj/structure/closet/crate/secure/large/reinforced
	desc = "A hefty, reinforced metal crate with an electronic locking system."
	icon_state = "largermetal"
	icon_opened = "largermetalopen"
	icon_closed = "largermetal"

/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon_state = "hydrocrate"
	icon_opened = "hydrocrateopen"
	icon_closed = "hydrocrate"

/obj/structure/closet/crate/hydroponics/prespawned
	//This exists so the prespawned hydro crates spawn with their contents.

	fill()
		new /obj/item/reagent_containers/spray/plantbgone(src)
		new /obj/item/reagent_containers/spray/plantbgone(src)
		new /obj/item/material/minihoe(src)
//		new /obj/item/weedspray(src)
//		new /obj/item/weedspray(src)
//		new /obj/item/pestspray(src)
//		new /obj/item/pestspray(src)
//		new /obj/item/pestspray(src)



//A crate that populates itself with randomly selected loot from randomstock.dm
//Can be passed in a rarity value, which is used as a multiplier on the rare/uncommon chance
//Quantity of spawns is number of discrete selections from the loot lists, default 10

/obj/structure/closet/crate/loot
	name = "unusual container"
	desc = "A mysterious container of unknown origins. What mysteries lie within?"
	var/rarity = 1
	var/quantity = 10
	var/list/spawntypes

//The crate chooses its icon randomly from a number of noticeable options.
//None of these are the standard grey crate sprite, and a few are currently unused ingame
//This ensures that people stumbling across a lootbox will notice it's different and investigate
	var/list/iconchoices = list(
		"radiation" = "radiationopen",
		"o2crate" = "o2crateopen",
		"freezer" = "freezeropen",
		"weaponcrate" = "weaponcrateopen",
		"largebins" = "largebinsopen",
		"phoroncrate" = "phoroncrateopen",
		"trashcart" = "trashcartopen",
		"critter" = "critteropen",
		"largemetal" = "largemetalopen",
		"medicalcrate" = "medicalcrateopen",
		"tcflcrate" = "tcflcrateopen"
	)


/obj/structure/closet/crate/loot/Initialize(mapload)
	. = ..()

	spawntypes = list(
		"1" = STOCK_RARE_PROB * rarity,
		"2" = STOCK_UNCOMMON_PROB * rarity,
		"3" = (100 - ((STOCK_RARE_PROB * rarity) + (STOCK_UNCOMMON_PROB * rarity)))
	)

	icon_closed = pick(iconchoices)
	icon_opened = iconchoices[icon_closed]
	update_icon()
	for (var/i in 1 to quantity)
		var/newtype = get_spawntype()
		call(newtype)(src)

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

/obj/structure/closet/crate/extinguisher_cartridges/fill()
	for(var/a = 1 to 12)
		new /obj/item/reagent_containers/extinguisher_refill(src)

/obj/structure/closet/crate/autakh
	name = "aut'akh crate"
	desc = "Contains a number of limbs and augmentations created by the Aut'akh Commune."
	icon = 'icons/obj/storage.dmi'
	icon_state = "autakh_crate"
	icon_opened = "autakh_crateopen"
	icon_closed = "autakh_crate"

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
