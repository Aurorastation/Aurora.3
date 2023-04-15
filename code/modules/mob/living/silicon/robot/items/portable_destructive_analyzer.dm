//A portable analyzer, for research borgs. This is better then giving them a gripper which can hold anything and letting them use the normal analyzer.
/obj/item/portable_destructive_analyzer
	name = "Portable Destructive Analyzer"
	desc = "Similar to the stationary version, this rather unwieldy device allows you to break down objects in the name of science."
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "portable_analyzer"

	var/min_reliability = 90 //Can't upgrade, call it laziness or a drawback

	var/datum/research/techonly/files 	//The device uses the same datum structure as the R&D computer/server.
										//This analyzer can only store tech levels, however.

	var/obj/item/loaded_item	//What is currently inside the analyzer.

/obj/item/portable_destructive_analyzer/Initialize()
	. = ..()
	files = new /datum/research/techonly(src) //Setup the research data holder.

/obj/item/portable_destructive_analyzer/examine(mob/user, distance)
	. = ..()
	if(loaded_item && Adjacent(user))
		to_chat(user, SPAN_NOTICE("It is holding \a [loaded_item]."))

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
				playsound(src.loc, 'sound/items/welder_pry.ogg', 50, 1)
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
							icon_state = initial(icon_state)
					else
						qdel(I)
						icon_state = initial(icon_state)
			else
				return
		else
			to_chat(user, SPAN_WARNING("\The [src] is empty. Put something inside it first."))
	if(response == "Sync")
		var/success = FALSE
		for(var/obj/machinery/r_n_d/server/S in SSmachinery.machinery)
			for(var/id in files.known_tech) //Uploading
				var/datum/tech/T = files.known_tech[id]
				S.files.AddTech2Known(T)
			files.known_tech = S.files.known_tech.Copy()
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
		flick("portable_analyzer_load", src)
		icon_state = "portable_analyzer_full"
