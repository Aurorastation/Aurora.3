#define FARMBOT_COLLECT 1
#define FARMBOT_WATER 2
#define FARMBOT_UPROOT 3
#define FARMBOT_NUTRIMENT 4
#define FARMBOT_PESTKILL 5

/mob/living/bot/farmbot
	name = "Farmbot"
	desc = "The botanist's best friend. Various farming equipment seems haphazardly attached to it."
	icon = 'icons/mob/npc/aibots.dmi'
	icon_state = "farmbot0"
	health = 50
	maxHealth = 50
	req_one_access = list(access_hydroponics, access_robotics, access_xenobotany)

	var/action = "" // Used to update icon
	var/waters_trays = TRUE
	var/refills_water = TRUE
	var/uproots_weeds = TRUE
	var/replaces_nutriment = FALSE
	var/collects_produce = FALSE
	var/removes_dead = FALSE
	var/eliminates_pests = FALSE

	var/obj/structure/reagent_dispensers/watertank/tank

	var/attacking = FALSE
	var/list/path = list()
	var/atom/target
	var/frustration = 0

/mob/living/bot/farmbot/Initialize()
	. = ..()
	tank = locate() in contents
	if(!tank)
		tank = new /obj/structure/reagent_dispensers/watertank(src)

/mob/living/bot/farmbot/Destroy()
	QDEL_NULL(tank)
	return ..()

/mob/living/bot/farmbot/attack_hand(var/mob/user as mob)
	. = ..()
	if(.)
		return

	if (!has_ui_access(user))
		to_chat(user, SPAN_WARNING("The unit's interface refuses to unlock!"))
		return

	var/dat = ""
	dat += "Status: <A href='?src=\ref[src];power=1'>[on ? "On" : "Off"]</A><BR>"
	dat += "Water Tank: "
	if (tank)
		dat += "[tank.reagents.total_volume]/[tank.reagents.maximum_volume]"
	else
		dat += "Error: Watertank not found"
	dat += "<br>Behaviour controls are [locked ? "locked" : "unlocked"]<hr>"
	if(!locked || issilicon(usr))
		dat += "<TT>Watering controls:<br>"
		dat += "Water plants : <A href='?src=\ref[src];water=1'>[waters_trays ? "Yes" : "No"]</A><BR>"
		dat += "Refill watertank : <A href='?src=\ref[src];refill=1'>[refills_water ? "Yes" : "No"]</A><BR>"
		dat += "<br>Preventive measures:<br>"
		dat += "Weed plants: <A href='?src=\ref[src];weed=1'>[uproots_weeds ? "Yes" : "No"]</A><BR>"
		dat += "Eradicate pests: <A href='?src=\ref[src];eradicatespests=1'>[eliminates_pests ? "Yes" : "No"]</A><BR>"
		dat += "<br>Nutriment controls:<br>"
		dat += "Replace fertilizer: <A href='?src=\ref[src];replacenutri=1'>[replaces_nutriment ? "Yes" : "No"]</A><BR>"
		dat += "<br>Plant controls:<br>"
		dat += "Collect produce: <A href='?src=\ref[src];collect=1'>[collects_produce ? "Yes" : "No"]</A><BR>"
		dat += "Remove dead plants: <A href='?src=\ref[src];removedead=1'>[removes_dead ? "Yes" : "No"]</A><BR>"
		dat += "</TT>"

	var/datum/browser/bot_win = new(user, "autofarm", "Automatic Farmbot v1.2 Controls")
	bot_win.set_content(dat)
	bot_win.open()

/mob/living/bot/farmbot/emag_act(var/remaining_charges, var/mob/user)
	. = ..()
	if(!emagged)
		if(user)
			to_chat(user, SPAN_NOTICE("You short out [src]'s plant identifier circuits."))
		spawn(rand(30, 50))
			visible_message(SPAN_WARNING("[src] buzzes oddly."))
			emagged = TRUE
		return TRUE

/mob/living/bot/farmbot/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	add_fingerprint(usr)

	if(!has_ui_access(usr))
		to_chat(usr, SPAN_WARNING("Insufficient permissions."))
		return

	if(href_list["power"])
		if(on)
			turn_off()
		else
			turn_on()

	if(locked && !issilicon(usr))
		return

	if(href_list["water"])
		waters_trays = !waters_trays
	else if(href_list["refill"])
		refills_water = !refills_water
	else if(href_list["weed"])
		uproots_weeds = !uproots_weeds
	else if(href_list["replacenutri"])
		replaces_nutriment = !replaces_nutriment
	else if(href_list["collect"])
		collects_produce = !collects_produce
	else if(href_list["removedead"])
		removes_dead = !removes_dead
	else if(href_list["eradicatespests"])
		eliminates_pests = !eliminates_pests

	attack_hand(usr)
	return

/mob/living/bot/farmbot/update_icon()
	if(on && action)
		icon_state = "farmbot_[action]"
	else
		icon_state = "farmbot[on]"

/mob/living/bot/farmbot/Life()
	..()
	if(emagged && prob(1))
		flick("farmbot_broke", src)

/mob/living/bot/farmbot/think()
	..()
	if(!on)
		return

	if(target)
		if(Adjacent(target))
			INVOKE_ASYNC(src, .proc/UnarmedAttack, target)
			path = list()
			target = null
		else
			if(length(path) && frustration < 5)
				if(path[1] == loc)
					path -= path[1]

				if(length(path))
					var/t = step_towards(src, path[1])
					if(t)
						path -= path[1]
					else
						++frustration
			else
				path = list()
				target = null
	else
		if(emagged)
			for(var/mob/living/carbon/human/H in view(7, src))
				target = H
				break
		else
			for(var/obj/machinery/portable_atmospherics/hydroponics/tray in view(7, src))
				if(process_tray(tray))
					target = tray
					frustration = 0
					break
			if(target) //We found a tray we can do something to. Set path to there.
				pathfind(target)
				return
			if(check_tank())
				for(var/obj/structure/sink/source in view(7, src))
					if(pathfind(source)) //If we can find a valid path to this sink, it's our target
						target = source
						frustration = 0
						break


/mob/living/bot/farmbot/proc/pathfind(var/atom/A)
	var/t = get_dir(A, src) // Turf with the tray is impassable, so a* can't navigate directly to it
	path = AStar(loc, get_step(A, t), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30, id = botcard)
	if(!path)
		path = list()
		return FALSE
	return path

/mob/living/bot/farmbot/UnarmedAttack(var/atom/A, var/proximity)
	. = ..()
	if(!.)
		return
	if(attacking)
		return

	if(istype(A, /obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/T = A
		var/t = process_tray(T)
		switch(t)
			if(0)
				return
			if(FARMBOT_COLLECT)
				action = "collect"
				update_icon()
				visible_message(SPAN_NOTICE("[src] starts [T.dead? "removing the plant from" : "harvesting"] \the [A]."))
				attacking = TRUE
				if(do_after(src, 30))
					visible_message(SPAN_NOTICE("[src] [T.dead? "removes the plant from" : "harvests"] \the [A]."))
					T.attack_hand(src)
			if(FARMBOT_WATER)
				action = "water"
				update_icon()
				visible_message(SPAN_NOTICE("[src] starts watering \the [A]."))
				attacking = TRUE
				if(do_after(src, 30))
					playsound(get_turf(src), 'sound/effects/slosh.ogg', 25, TRUE)
					visible_message(SPAN_NOTICE("[src] waters \the [A]."))
					tank.reagents.trans_to(T, 100 - T.waterlevel)
			if(FARMBOT_UPROOT)
				action = "hoe"
				update_icon()
				visible_message(SPAN_NOTICE("[src] starts uprooting the weeds in \the [A]."))
				attacking = TRUE
				if(do_after(src, 30))
					visible_message(SPAN_NOTICE("[src] uproots the weeds in \the [A]."))
					T.weedlevel = 0
					T.update_icon()
			if(FARMBOT_PESTKILL)
				action = "hoe"
				update_icon()
				visible_message(SPAN_NOTICE("[src] starts eliminating the pests in \the [A]."))
				attacking = TRUE
				if(do_after(src, 30))
					visible_message(SPAN_NOTICE("[src] eliminates the pests in \the [A]."))
					T.pestlevel = 0
					T.reagents.add_reagent(/singleton/reagent/nutriment, 0.5)
					T.update_icon()
			if(FARMBOT_NUTRIMENT)
				action = "fertile"
				update_icon()
				visible_message(SPAN_NOTICE("[src] starts fertilizing \the [A]."))
				attacking = TRUE
				if(do_after(src, 30))
					visible_message(SPAN_NOTICE("[src] waters \the [A]."))
					T.reagents.add_reagent(/singleton/reagent/ammonia, 10)
		attacking = FALSE
		action = ""
		update_icon()
		T.update_icon()
	else if(istype(A, /obj/structure/sink))
		if(!tank || tank.reagents.total_volume >= tank.reagents.maximum_volume)
			return
		action = "water"
		update_icon()
		visible_message(SPAN_NOTICE("[src] starts refilling its tank from \the [A]."))
		attacking = TRUE
		while(do_after(src, 10) && tank.reagents.total_volume < tank.reagents.maximum_volume)
			tank.reagents.add_reagent(/singleton/reagent/water, 10)
			if(prob(5))
				playsound(get_turf(src), 'sound/effects/slosh.ogg', 25, TRUE)
		attacking = FALSE
		action = ""
		update_icon()
		visible_message(SPAN_NOTICE("[src] finishes refilling its tank."))
	else if(emagged && ishuman(A))
		var/action = pick("weed", "water")
		attacking = TRUE
		spawn(50) // Some delay
			attacking = FALSE
		switch(action)
			if("weed")
				flick("farmbot_hoe", src)
				do_attack_animation(A)
				if(prob(50))
					visible_message(SPAN_DANGER("[src] swings wildly at [A] with a minihoe, missing completely!"))
					return
				var/t = pick("slashed", "sliced", "cut", "clawed")
				A.attack_generic(src, 5, t)
			if("water")
				flick("farmbot_water", src)
				visible_message(SPAN_DANGER("[src] splashes [A] with water!")) // That's it. RP effect.

/mob/living/bot/farmbot/explode()
	visible_message(SPAN_DANGER("[src] blows apart!"))
	var/turf/T = get_turf(src)

	new /obj/item/material/minihoe(T)
	new /obj/item/reagent_containers/glass/bucket(T)
	new /obj/item/device/assembly/prox_sensor(T)
	new /obj/item/device/analyzer/plant_analyzer(T)
	if(tank)
		tank.forceMove(T)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(T)

	spark(src, 3, alldirs)
	qdel(src)
	return

/mob/living/bot/farmbot/proc/process_tray(var/obj/machinery/portable_atmospherics/hydroponics/tray)
	if(!tray || !istype(tray))
		return FALSE
	if(tray.closed_system || !tray.seed)
		return FALSE
	if(tray.dead && removes_dead || tray.harvest && collects_produce)
		return FARMBOT_COLLECT
	else if(waters_trays && tray.waterlevel < 10 && !tray.reagents.has_reagent(/singleton/reagent/water))
		return FARMBOT_WATER
	else if(uproots_weeds && tray.weedlevel >= 5)
		return FARMBOT_UPROOT
	else if(eliminates_pests && tray.pestlevel >= 3)
		return FARMBOT_PESTKILL
	else if(replaces_nutriment && tray.nutrilevel < 2 && tray.reagents.total_volume < 1)
		return FARMBOT_NUTRIMENT
	return FALSE

// Assembly

/mob/living/bot/farmbot/proc/check_tank()
	if(!tank)
		return FALSE
	return ((!target && refills_water && tank.reagents.total_volume < tank.reagents.maximum_volume) || ((tank.reagents.total_volume ) / tank.reagents.maximum_volume) <= 0.3)

/obj/item/farmbot_arm_assembly
	name = "water tank/robot arm assembly"
	desc = "A water tank with a robot arm permanently grafted to it."
	icon = 'icons/mob/npc/aibots.dmi'
	icon_state = "water_arm"
	var/build_step = 0
	var/created_name = "Farmbot"

/obj/structure/reagent_dispensers/watertank/attackby(obj/item/robot_parts/S, mob/user)
	if ((!istype(S, /obj/item/robot_parts/l_arm)) && (!istype(S, /obj/item/robot_parts/r_arm)))
		..()
		return

	var/obj/item/farmbot_arm_assembly/A = new /obj/item/farmbot_arm_assembly(loc)

	to_chat(user, SPAN_NOTICE("You add \the [S] to \the [src]."))
	loc = A //Place the water tank into the assembly, it will be needed for the finished bot
	qdel(S)

/obj/item/farmbot_arm_assembly/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/device/analyzer/plant_analyzer) && build_step == 0)
		build_step++
		to_chat(user, SPAN_NOTICE("You add the plant analyzer to [src]."))
		name = "farmbot assembly"
		qdel(W)
		return TRUE
	else if(istype(W, /obj/item/reagent_containers/glass/bucket) && build_step == 1)
		build_step++
		to_chat(user, SPAN_NOTICE("You add a bucket to [src]."))
		name = "farmbot assembly with bucket"
		qdel(W)
		return TRUE //Prevents the object's afterattack from executing and causing runtime errors
	else if(istype(W, /obj/item/material/minihoe) && build_step == 2)
		build_step++
		to_chat(user, SPAN_NOTICE("You add a minihoe to [src]."))
		name = "farmbot assembly with bucket and minihoe"
		user.remove_from_mob(W)
		qdel(W)
		return TRUE
	else if(isprox(W) && build_step == 3)
		build_step++
		to_chat(user, SPAN_NOTICE("You complete the Farmbot! Beep boop."))
		var/mob/living/bot/farmbot/S = new /mob/living/bot/farmbot(get_turf(src))
		for(var/obj/structure/reagent_dispensers/watertank/wTank in contents)
			qdel(S.tank)
			wTank.forceMove(S)
			S.tank = wTank
		S.name = created_name
		user.remove_from_mob(W)
		qdel(W)
		qdel(src)
		return TRUE
	else if(W.ispen())
		var/t = input(user, "Enter new robot name", name, created_name) as text
		t = sanitize(t, MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t

/obj/item/farmbot_arm_assembly/attack_hand(mob/user)
	return //it's a converted watertank, no you cannot pick it up and put it in your backpack
