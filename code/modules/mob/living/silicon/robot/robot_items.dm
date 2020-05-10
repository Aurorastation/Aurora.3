// Don't look at this file. Absolutely do not. It is brimming with shitcode. Please. Don't. - Geeves

//A portable analyzer, for research borgs.  This is better then giving them a gripper which can hold anything and letting them use the normal analyzer.
/obj/item/portable_destructive_analyzer
	name = "Portable Destructive Analyzer"
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "portable_analyzer"
	desc = "Similar to the stationary version, this rather unwieldy device allows you to break down objects in the name of science."

	var/min_reliability = 90 //Can't upgrade, call it laziness or a drawback

	var/datum/research/techonly/files 	//The device uses the same datum structure as the R&D computer/server.
										//This analyzer can only store tech levels, however.

	var/obj/item/loaded_item	//What is currently inside the analyzer.

/obj/item/portable_destructive_analyzer/Initialize()
	. = ..()
	files = new /datum/research/techonly(src) //Setup the research data holder.

/obj/item/portable_destructive_analyzer/attack_self(mob/user)
	var/response = alert(user, 	"Analyzing the item inside will *DESTROY* the item for good.\n\
							Syncing to the research server will send the data that is stored inside to research.\n\
							Ejecting will place the loaded item onto the floor.",
							"What would you like to do?", "Analyze", "Sync", "Eject")
	if(response == "Analyze")
		if(loaded_item)
			var/confirm = alert(user, "This will destroy the item inside forever.  Are you sure?", "Confirm Analyze", "Yes", "No")
			if(confirm == "Yes") //This is pretty copypasta-y
				to_chat(user, SPAN_NOTICE("You activate the analyzer's microlaser, analyzing \the [loaded_item] and breaking it down."))
				flick("portable_analyzer_scan", src)
				playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
				for(var/T in loaded_item.origin_tech)
					files.UpdateTech(T, loaded_item.origin_tech[T])
					to_chat(user, SPAN_NOTICE("\The [loaded_item] had level [loaded_item.origin_tech[T]] in [CallTechName(T)]."))
				loaded_item = null
				for(var/obj/I in contents)
					for(var/mob/M in I.contents)
						M.death()
					if(istype(I,/obj/item/stack/material)) //Only deconstructs one sheet at a time instead of the entire stack
						var/obj/item/stack/material/S = I
						if(S.get_amount() > 1)
							S.use(1)
							loaded_item = S
						else
							qdel(S)
							desc = initial(desc)
							icon_state = initial(icon_state)
					else
						qdel(I)
						desc = initial(desc)
						icon_state = initial(icon_state)
			else
				return
		else
			to_chat(user, SPAN_WARNING("\The [src] is empty. Put something inside it first."))
	if(response == "Sync")
		var/success = FALSE
		for(var/obj/machinery/r_n_d/server/S in SSmachinery.all_machines)
			for(var/datum/tech/T in files.known_tech) //Uploading
				S.files.AddTech2Known(T)
			for(var/datum/tech/T in S.files.known_tech) //Downloading
				files.AddTech2Known(T)
			success = TRUE
			files.RefreshResearch()
		if(success)
			to_chat(user, SPAN_NOTICE("You connect to the research server, push your data upstream to it, then pull the resulting merged data from the master branch.")) // fucking nerds
			playsound(get_turf(src), 'sound/machines/twobeep.ogg', 50, TRUE)
		else
			to_chat(user, SPAN_WARNING("Research server ping response timed out. Unable to connect. Please contact the system administrator."))
			playsound(get_turf(src), 'sound/machines/buzz-two.ogg', 50, 1)
	if(response == "Eject")
		if(loaded_item)
			loaded_item.forceMove(get_turf(src))
			desc = initial(desc)
			icon_state = initial(icon_state)
			loaded_item = null
		else
			to_chat(user, SPAN_WARNING("\The [src] is already empty."))


/obj/item/portable_destructive_analyzer/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(!target || !proximity || !isturf(target.loc))
		return
	if(loaded_item)
		to_chat(user, SPAN_WARNING("Your [src] already has something inside. Analyze or eject it first."))
		return
	if(istype(target,/obj/item))
		var/obj/item/I = target
		if(I.anchored)
			to_chat(user, span("notice", "\The [I] is anchored in place."))
			return
		if(!I.origin_tech)
			to_chat(user, SPAN_NOTICE("This doesn't seem to have a tech origin."))
			return
		if(!length(I.origin_tech))
			to_chat(user, SPAN_NOTICE("You cannot deconstruct this item."))
			return
		I.forceMove(src)
		loaded_item = I
		visible_message(SPAN_NOTICE("\The [user] scoops \the [I] into \the [src]."))
		desc = initial(desc) + "<br>It is holding \the [loaded_item]."
		flick("portable_analyzer_load", src)
		icon_state = "portable_analyzer_full"

//This is used to unlock other borg covers.
/obj/item/card/robot //This is not a child of id cards, as to avoid dumb typechecks on computers.
	name = "access code transmission device"
	icon_state = "id-robot"
	desc = "A circuit grafted onto the bottom of an ID card.  It is used to transmit access codes into other robot chassis, \
	allowing you to lock and unlock other robots' panels."

//A harvest item for serviceborgs.
/obj/item/robot_harvester
	name = "auto harvester"
	desc = "A hand-held harvest tool that resembles a sickle.  It uses energy to cut plant matter very efficently."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "autoharvester"
	hitsound = "swing_hit"

/obj/item/robot_harvester/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(!target || !proximity)
		return
	if(istype(target,/obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/T = target
		if(T.harvest) //Try to harvest, assuming it's alive.
			T.harvest(user)
		else if(T.dead) //It's probably dead otherwise.
			T.remove_dead(user)
	else
		to_chat(user, SPAN_WARNING("ERROR: Harvesting \a [target] is not the purpose of this tool. \The [src] is for plants being grown."))

// A special tray for the service droid. Allow droid to pick up and drop items as if they were using the tray normally
// Click on table to unload, click on item to load. Alt+click to load everything on tile

/obj/item/tray/robotray
	name = "RoboTray"
	desc = "An autoloading tray specialized for carrying refreshments."

/obj/item/tray/robotray/afterattack(atom/target, mob/user, proximity)
	if(isturf(target) || istype(target,/obj/structure/table) )
		var foundtable = istype(target,/obj/structure/table/)
		if(!foundtable) //it must be a turf!
			for(var/obj/structure/table/T in target)
				foundtable = TRUE
				break
		var/turf/dropspot
		if(!foundtable) // don't unload things onto walls or other silly places.
			dropspot = get_turf(user)
		else if ( isturf(target) ) // they clicked on a turf with a table in it
			dropspot = target
		else					// they clicked on a table
			dropspot = get_turf(target)
		if(foundtable)
			unload_at_loc(dropspot, src)
		else
			spill(user,dropspot)
		current_weight = 0

	return ..()

// A special pen for service droids. Can be toggled to switch between normal writting mode, and paper rename mode
// Allows service droids to rename paper items.

/obj/item/pen/robopen
	desc = "A black ink printing attachment with a paper naming mode."
	name = "Printing Pen"
	var/mode = 1

/obj/item/pen/robopen/attack_self(mob/user)
	var/choice = input(user, "Would you like to change colour or mode?", "Pen Selector") as null|anything in list("Colour", "Mode")
	if(!choice)
		return

	playsound(get_turf(src), 'sound/effects/pop.ogg', 50, 0)

	switch(choice)
		if("Colour")
			var/newcolour = input(user, "Which colour would you like to use?", "Colour Selector") as null|anything in list("black", "blue", "red", "green", "yellow")
			if(newcolour)
				colour = newcolour
		if("Mode")
			if(mode == 1)
				mode = 2
			else
				mode = 1
			to_chat(user, SPAN_NOTICE("Changed printing mode to '[mode == 2 ? "Rename Paper" : "Write Paper"]'"))
	return

// Copied over from paper's rename verb
// see code\modules\paperwork\paper.dm line 62

/obj/item/pen/robopen/proc/RenamePaper(var/mob/user, var/obj/paper)
	if(!user || !paper)
		return
	var/n_name = sanitizeSafe(input(user, "What would you like to label the paper?", "Paper Labelling") as text, 32)
	if(!user || !paper)
		return

	if((get_dist(user,paper) <= 1 && !user.stat))
		paper.name = "paper[(n_name ? text("- '[n_name]'") : null)]"
	add_fingerprint(user)
	return

//TODO: Add prewritten forms to dispense when you work out a good way to store the strings.
/obj/item/form_printer
	name = "paper dispenser"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin1"
	item_state = "sheet-metal"

/obj/item/form_printer/attack(mob/living/carbon/M, mob/living/carbon/user)
	return

/obj/item/form_printer/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag, params)
	if(!target || !flag)
		return
	if(istype(target,/obj/structure/table))
		deploy_paper(get_turf(target))

/obj/item/form_printer/attack_self(mob/user)
	deploy_paper(get_turf(src))

/obj/item/form_printer/proc/deploy_paper(var/turf/T)
	T.visible_message(SPAN_NOTICE("\The [src.loc] dispenses a sheet of crisp white paper."))
	new /obj/item/paper(T)

//Personal shielding for the combat module.
/obj/item/borg/combat/shield
	name = "personal shielding"
	desc = "A powerful experimental module that turns aside or absorbs incoming attacks at the cost of charge."
	icon = 'icons/obj/device.dmi'
	icon_state = "shield1" //placeholder for now // four fucking years alberyk. FOUR
	var/shield_level = 0.5 //Percentage of damage absorbed by the shield.

/obj/item/borg/combat/shield/verb/set_shield_level()
	set name = "Set shield level"
	set category = "Object"
	set src in range(0)

	var/N = input(usr, "How much damage should the shield absorb?") in list("5", "10", "25", "50", "75", "100")
	if(N)
		shield_level = text2num(N)/100

/obj/item/borg/combat/mobility
	name = "mobility module"
	desc = "By retracting limbs and tucking in its head, a combat android can roll at high speeds."
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"

/obj/item/inflatable_dispenser
	name = "inflatables dispenser"
	desc = "Small device which allows rapid deployment and removal of inflatables."
	icon = 'icons/obj/storage.dmi'
	icon_state = "inf_deployer"
	w_class = 3
	var/deploying = 0
	// By default stores up to 10 walls and 5 doors. May be changed.
	var/stored_walls = 10
	var/stored_doors = 5
	var/max_walls = 10
	var/max_doors = 5
	var/mode = 0 // 0 - Walls   1 - Doors

/obj/item/inflatable_dispenser/examine(mob/user)
	if(!..(user))
		return
	to_chat(user, SPAN_NOTICE("It has [stored_walls] wall segment\s and [stored_doors] door segment\s stored."))
	to_chat(user, SPAN_NOTICE("It is set to deploy [mode ? "doors" : "walls"]"))

/obj/item/inflatable_dispenser/attack_self(mob/user)
	if(!deploying)
		mode = !mode
		to_chat(user, SPAN_NOTICE("You set \the [src] to deploy [mode ? "doors" : "walls"]."))
	else
		to_chat(user, span("warning", "You can't switch modes while deploying a [mode ? "door" : "wall"]!"))

/obj/item/inflatable_dispenser/afterattack(var/atom/A, var/mob/user)
	..(A, user)
	if(!user)
		return
	if(!user.Adjacent(A))
		to_chat(user, SPAN_WARNING("You can't reach!"))
		return
	if(istype(A, /turf))
		try_deploy_inflatable(A, user)
	if(istype(A, /obj/item/inflatable) || istype(A, /obj/structure/inflatable))
		pick_up(A, user)

/obj/item/inflatable_dispenser/proc/try_deploy_inflatable(var/turf/T, var/mob/living/user)
	if(deploying)
		return

	var/newtype
	if(mode) // Door deployment
		if(!stored_doors)
			to_chat(user, SPAN_WARNING("\The [src] is out of doors!"))
			return
		if(T && istype(T))
			newtype = /obj/structure/inflatable/door

	else // Wall deployment
		if(!stored_walls)
			to_chat(user, SPAN_WARNING("\The [src] is out of walls!"))
			return

		if(T && istype(T))
			newtype = /obj/structure/inflatable/wall

	deploying = 1
	user.visible_message(span("notice", "[user] starts deploying an inflatable"), span("notice", "You start deploying an inflatable [mode ? "door" : "wall"]!"))
	playsound(T, 'sound/items/zip.ogg', 75, TRUE)
	if(do_after(user, 15, needhand = FALSE))
		new newtype(T)
		if(mode)
			stored_doors--
		else
			stored_walls--

	deploying = FALSE

/obj/item/inflatable_dispenser/proc/pick_up(var/obj/A, var/mob/living/user)
	if(istype(A, /obj/structure/inflatable))
		if(istype(A, /obj/structure/inflatable/wall))
			if(stored_walls >= max_walls)
				to_chat(user, SPAN_WARNING("\The [src] is full."))
				return
			stored_walls++
			qdel(A)
		else
			if(stored_doors >= max_doors)
				to_chat(user, SPAN_WARNING("\The [src] is full."))
				return
			stored_doors++
			qdel(A)
		playsound(get_turf(src), 'sound/machines/hiss.ogg', 75, TRUE)
		visible_message(SPAN_NOTICE("\The [user] deflates \the [A] with \the [src]."))
		return
	if(istype(A, /obj/item/inflatable))
		if(istype(A, /obj/item/inflatable/wall))
			if(stored_walls >= max_walls)
				to_chat(user, SPAN_WARNING("\The [src] is full."))
				return
			stored_walls++
			qdel(A)
		else
			if(stored_doors >= max_doors)
				to_chat(usr, SPAN_WARNING("\The [src] is full!"))
				return
			stored_doors++
			qdel(A)
		visible_message(SPAN_NOTICE("\The [user] picks up \the [A] with \the [src]."))
		return

	to_chat(user, SPAN_WARNING("You fail to pick up \the [A] with \the [src]"))
	return

/obj/item/gun/energy/mountedcannon
	name = "mounted ballistic cannon"
	desc = "A cyborg mounted ballistic cannon."
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "cannon"
	item_state = "cannon"
	fire_sound = 'sound/effects/Explosion1.ogg'
	charge_meter = 0
	max_shots = 10
	charge_cost = 300
	projectile_type = /obj/item/projectile/bullet/gyro
	self_recharge = TRUE
	use_external_power = TRUE
	recharge_time = 5
	needspin = FALSE

/obj/item/crowbar/robotic
	icon = 'icons/obj/robot_items.dmi'

/obj/item/wrench/robotic
	icon = 'icons/obj/robot_items.dmi'

/obj/item/screwdriver/robotic
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "screwdriver"
	random_icon = FALSE

/obj/item/device/multitool/robotic
	icon = 'icons/obj/robot_items.dmi'

/obj/item/wirecutters/robotic
	icon = 'icons/obj/robot_items.dmi'

/obj/item/weldingtool/robotic
	icon = 'icons/obj/robot_items.dmi'