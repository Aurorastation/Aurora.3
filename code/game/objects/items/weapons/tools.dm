//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/* Tools!
 * Note: Multitools are /obj/item/device
 *
 * Contains:
 * 		Wrench
 * 		Screwdriver
 * 		Wirecutters
 * 		Welding Tool
 * 		Crowbar
*		Pipe Wrench
 */

/*
 * Wrench
 */
/obj/item/wrench
	name = "wrench"
	desc = "An adjustable tool used for gripping and turning nuts or bolts."
	icon = 'icons/obj/tools.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_tools.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_tools.dmi',
		)
	icon_state = "wrench"
	item_state = "wrench"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 8
	throwforce = 7
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 150)
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	drop_sound = 'sound/items/drop/sword.ogg'
	usesound = 'sound/items/Ratchet.ogg'

/obj/item/wrench/iswrench()
	return TRUE

/*
 * Screwdriver
 */
/obj/item/screwdriver
	name = "screwdriver"
	desc = "A tool with a flattened or cross-shaped tip that fits into the head of a screw to turn it."
	icon = 'icons/obj/tools.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_tools.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_tools.dmi',
		)
	icon_state = "screwdriver2"
	item_state = "screwdriver"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_EARS
	center_of_mass = list("x" = 13,"y" = 7)
	force = 8
	w_class = ITEMSIZE_TINY
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	matter = list(DEFAULT_WALL_MATERIAL = 75)
	attack_verb = list("stabbed")
	lock_picking_level = 5
	var/random_icon = TRUE
	drop_sound = 'sound/items/drop/scrap.ogg'
	usesound = 'sound/items/Screwdriver.ogg'

/obj/item/screwdriver/Initialize()
	. = ..()
	if(!random_icon)
		return

	switch(pick("red","blue","purple","brown","green","cyan","yellow"))
		if ("red")
			icon_state = "screwdriver2"
			item_state = "screwdriver"
		if ("blue")
			icon_state = "screwdriver"
			item_state = "screwdriver_blue"
		if ("purple")
			icon_state = "screwdriver3"
			item_state = "screwdriver_purple"
		if ("brown")
			icon_state = "screwdriver4"
			item_state = "screwdriver_brown"
		if ("green")
			icon_state = "screwdriver5"
			item_state = "screwdriver_green"
		if ("cyan")
			icon_state = "screwdriver6"
			item_state = "screwdriver_cyan"
		if ("yellow")
			icon_state = "screwdriver7"
			item_state = "screwdriver_yellow"

	if (prob(75))
		src.pixel_y = rand(0, 16)

/obj/item/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob, var/target_zone)
	if(!istype(M) || user.a_intent == "help")
		return ..()
	if(target_zone != BP_EYES && target_zone != BP_HEAD)
		return ..()
	if((user.is_clumsy()) && prob(50))
		M = user
	return eyestab(M,user)

/obj/item/screwdriver/isscrewdriver()
	return TRUE

/*
 * Wirecutters
 */
/obj/item/wirecutters
	name = "wirecutters"
	desc = "A tool used to cut wires in electrical work."
	icon = 'icons/obj/tools.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_tools.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_tools.dmi',
		)
	icon_state = "cutters"
	item_state = "cutters"
	flags = CONDUCT
	center_of_mass = list("x" = 18,"y" = 10)
	slot_flags = SLOT_BELT
	force = 6
	throw_speed = 2
	throw_range = 9
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 80)
	attack_verb = list("pinched", "nipped")
	var/bomb_defusal_chance = 30 // 30% chance to safely defuse a bomb
	sharp = TRUE
	edge = TRUE
	drop_sound = 'sound/items/drop/knife.ogg'

/obj/item/wirecutters/New()
	if(prob(50))
		icon_state = "cutters-y"
		item_state = "cutters_yellow"
	..()

/obj/item/wirecutters/attack(mob/living/carbon/C, mob/user, var/target_zone)
	if(user.a_intent == I_HELP && (C.handcuffed) && (istype(C.handcuffed, /obj/item/handcuffs/cable)))
		user.visible_message(SPAN_NOTICE("\The [user] cuts \the [C]'s restraints with \the [src]!"),\
		SPAN_NOTICE("You cut \the [C]'s restraints with \the [src]!"),\
		SPAN_NOTICE("You hear cable being cut."))
		C.handcuffed = null
		if(C.buckled?.buckle_require_restraints)
			C.buckled.unbuckle_mob()
		C.update_inv_handcuffed()
		return
	else
		..()

/obj/item/wirecutters/iswirecutter()
	return TRUE

/obj/item/wirecutters/bomb
	name = "bomb defusal wirecutters"
	desc = "A tool used to delicately sever the wires used in bomb fuses."
	icon_state = "mini_wirecutter"
	toolspeed = 0.6
	bomb_defusal_chance = 90 // 90% chance, because the thrill of dying must be kept at all times, duh

/obj/item/wirecutters/bomb/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "[initial(icon_state)]-yellow"
		item_state = "[initial(icon_state)]_yellow"

/*
 * Welding Tool
 */
/obj/item/weldingtool
	name = "welding tool"
	desc = "A welding tool with a built-in fuel tank, designed for welding and cutting metal."
	icon = 'icons/obj/tools.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_tools.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_tools.dmi',
		)
	icon_state = "welder_off"
	item_state = "welder_off"
	var/base_iconstate = "welder"//These are given an _on/_off suffix before being used
	var/base_itemstate = "welder"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	drop_sound = 'sound/items/drop/scrap.ogg'

	//Amount of OUCH when it's thrown
	force = 3
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL

	//Cost to make in the autolathe
	matter = list(DEFAULT_WALL_MATERIAL = 70, MATERIAL_GLASS = 30)

	//R&D tech level
	origin_tech = list(TECH_ENGINEERING = 1)

	//Welding tool specific stuff
	var/welding = 0 	//Whether or not the welding tool is off(0), on(1) or currently welding(2)
	var/status = 1 		//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/max_fuel = 20 	//The max amount of fuel the welder can hold

/obj/item/weldingtool/iswelder()
	return TRUE

/obj/item/weldingtool/largetank
	name = "industrial welding tool"
	desc = "A welding tool with an extended-capacity built-in fuel tank, standard issue for engineers."
	base_iconstate = "ind_welder"
	base_itemstate = "ind_welder"
	max_fuel = 40
	matter = list(DEFAULT_WALL_MATERIAL = 100, MATERIAL_GLASS = 60)
	origin_tech = list(TECH_ENGINEERING = 2)

/obj/item/weldingtool/hugetank
	name = "advanced welding tool"
	desc = "A rare and powerful welding tool with a super-extended fuel tank."
	base_iconstate = "adv_welder"
	base_itemstate = "adv_welder"
	max_fuel = 80
	matter = list(DEFAULT_WALL_MATERIAL = 200, MATERIAL_GLASS = 120)
	origin_tech = list(TECH_ENGINEERING = 3)

//The Experimental Welding Tool!
/obj/item/weldingtool/experimental
	name = "experimental welding tool"
	desc = "A scientifically-enhanced welding tool that uses fuel-producing microbes to gradually replenish its fuel supply."
	base_iconstate = "exp_welder"
	base_itemstate = "exp_welder"
	max_fuel = 40
	matter = list(DEFAULT_WALL_MATERIAL = 100, MATERIAL_GLASS = 120)
	origin_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)
	

	var/last_gen = 0
	var/fuelgen_delay = 400 //The time, in deciseconds, required to regenerate one unit of fuel
	//400 = 1 unit per 40 seconds

//Welding tool functionality here
/obj/item/weldingtool/Initialize()
	. = ..()
//	var/random_fuel = min(rand(10,20),max_fuel)
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	update_icon()

/obj/item/weldingtool/update_icon()
	..()
	var/add = welding ? "_on" : "_off"
	icon_state = base_iconstate + add //These are given an _on/_off suffix before being used
	item_state = base_itemstate + add
	if(welding == 2)
		set_light(0.7, 2, l_color = LIGHT_COLOR_CYAN)
	else if (welding == 1)
		set_light(0.6, 1.5, l_color = LIGHT_COLOR_LAVA)
	else
		set_light(0)
	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

/obj/item/weldingtool/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/weldingtool/examine(mob/user)
	if(..(user, 0))
		to_chat(user, text("\icon[] [] contains []/[] units of fuel!", src, src.name, get_fuel(),src.max_fuel ))

/obj/item/weldingtool/attackby(obj/item/W, mob/user)
	if(W.isscrewdriver())
		if(isrobot(loc))
			to_chat(user, span("alert", "You cannot modify your own welder!"))
			return
		if(welding)
			to_chat(user, span("danger", "Stop welding first!"))
			return
		status = !status
		if(status)
			to_chat(user, span("notice", "You secure the welder."))
		else
			to_chat(user, span("notice", "The welder can now be attached and modified."))
		add_fingerprint(user)
		return

	if(!status && (istype(W, /obj/item/stack/rods)))
		var/obj/item/stack/rods/R = W
		R.use(1)
		add_fingerprint(user)
		user.drop_from_inventory(src)
		var/obj/item/flamethrower/F = new /obj/item/flamethrower
		F.weldtool = src
		forceMove(F)
		user.put_in_hands(F)
		return

	..()
	return

/obj/item/weldingtool/process()
	if(welding)
		if(prob(5))
			remove_fuel(1, null, colourChange = FALSE)

		if(get_fuel() < 1)
			setWelding(0)

	//I'm not sure what this does. I assume it has to do with starting fires...
	//...but it doesnt check to see if the welder is on or not.
	var/turf/location = src.loc
	if(istype(location, /mob/))
		var/mob/M = location
		if(M.l_hand == src || M.r_hand == src)
			location = get_turf(M)
	if (istype(location, /turf))
		location.hotspot_expose(700, 5)

/obj/item/weldingtool/attack(mob/living/M, mob/user, var/target_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/S = H.organs_by_name[target_zone]

		if(!S)
			return

		if(!(S.status & ORGAN_ASSISTED) || user.a_intent != I_HELP)
			return ..()

		if(H.isSynthetic() && H == user && !(H.get_species() == "Military Frame"))
			to_chat(user, span("warning", "You can't repair damage to your own body - it's against OH&S."))
			return

		if (!welding)
			to_chat(user, span("warning", "You need to light the welding tool first!"))
			return

		if(S.brute_dam)
			if(S.brute_dam > ROBOLIMB_SELF_REPAIR_CAP)
				to_chat(user, span("warning", "The damage is far too severe to patch over externally!"))
				return
			else
				repair_organ(user, H, S)

		else if(S.open != 2)
			to_chat(user, span("notice", "You can't see any external damage to repair."))
	else
		return ..()

/obj/item/weldingtool/proc/repair_organ(var/mob/living/user, var/mob/living/carbon/human/target, var/obj/item/organ/external/affecting)
	if(!affecting.brute_dam)
		user.visible_message(span("notice", "\The [user] finishes repairing the physical damage on \the [target]'s [affecting.name]."))
		return

	if(do_mob(user, target, 30))
		if(remove_fuel(0))
			var/static/list/repair_messages = list(
				"patches some dents",
				"mends some tears",
				"repairs some joints"
			)
			affecting.heal_damage(brute = 15, robo_repair = TRUE)
			user.visible_message(span("warning", "\The [user] [pick(repair_messages)] on [target]'s [affecting.name] with \the [src]."))
			playsound(target, 'sound/items/Welder2.ogg', 15)
			repair_organ(user, target, affecting)

/obj/item/weldingtool/afterattack(obj/O, mob/user, proximity)
	if(!proximity)
		return
	if(istype(O, /obj/structure/reagent_dispensers/fueltank) && O.Adjacent(user) && !welding)
		O.reagents.trans_to_obj(src, max_fuel)
		to_chat(user, "<span class='notice'>You refuel your welder.</span>")
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	else if(istype(O, /obj/structure/reagent_dispensers/fueltank) && O.Adjacent(user) && welding)
		var/obj/structure/reagent_dispensers/fueltank/tank = O
		if(tank.armed)
			to_chat(user, "<span class='warning'>You are already heating \the [O]!</span>")
			return
		user.visible_message("<span class='warning'>[user] begins heating \the [O]...</span>", "<span class='warning'>You start to heat \the [O]!</span>")
		switch(alert("Are you sure you want to do this? It is quite dangerous and could get you in trouble.", "Heat up fuel tank", "No", "Yes"))
			if("Yes")
				log_and_message_admins("is attempting to welderbomb", user)
				to_chat(user, span("alert", "You start heating the fueltank..."))
				tank.armed = 1
				if(do_after(user, 100))
					if(tank.defuse)
						user.visible_message("[user] melts some of the framework on the [O]!", "You melt some of the framework!")
						tank.defuse = 0
						tank.armed = 0
						return
					log_and_message_admins("triggered a fuel tank explosion", user)
					to_chat(user, span("alert", "That was stupid of you."))
					tank.ex_act(3.0)
					return
				else
					tank.armed = 0
					to_chat(user, "You thought better of yourself.")
					return
			if("No")
				tank.armed = 0
				to_chat(user, "You thought better of yourself.")
				return
		return
	if (welding)
		remove_fuel(1)
		var/turf/location = get_turf(user)
		if(isliving(O))
			var/mob/living/L = O
			L.IgniteMob()
		if (istype(location, /turf))
			location.hotspot_expose(700, 50, 1)
	return

/obj/item/weldingtool/attack_self(mob/user)
	setWelding(!welding, user)

//Returns the amount of fuel in the welder
/obj/item/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

//Removes fuel from the welding tool. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/weldingtool/proc/remove_fuel(var/amount = 1, var/mob/M = null, var/colourChange = TRUE)
	if(!welding)
		return 0
	else if(welding > 0 && colourChange)
		set_light(0.7, 2, l_color = LIGHT_COLOR_CYAN)
		addtimer(CALLBACK(src, /atom/proc/update_icon), 5)
	if(get_fuel() >= amount)
		reagents.remove_reagent("fuel", amount)
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			to_chat(M, span("notice", "You need more welding fuel to complete this task."))
		return 0

//Returns whether or not the welding tool is currently on.
/obj/item/weldingtool/proc/isOn()
	return src.welding

//Sets the welding state of the welding tool. If you see W.welding = 1 anywhere, please change it to W.setWelding(1)
//so that the welding tool updates accordingly
/obj/item/weldingtool/proc/setWelding(var/set_welding, var/mob/M)
	if(!status)
		return

	var/turf/T = get_turf(src)
	//If we're turning it on
	if(set_welding && !welding)
		if (get_fuel() > 0)
			if(M)
				to_chat(M, "<span class='notice'>You switch the [src] on.</span>")
			else if(T)
				T.visible_message("<span class='danger'>\The [src] turns on.</span>")
			playsound(loc, 'sound/items/WelderActivate.ogg', 50, 1)
			force = 15
			damtype = BURN
			w_class = ITEMSIZE_LARGE
			welding = TRUE
			update_icon()
			set_processing(TRUE)
		else
			if(M)
				to_chat(M, "<span class='notice'>You need more welding fuel to complete this task.</span>")
			return
	//Otherwise
	else if(!set_welding && welding)
		if(M)
			to_chat(M, "<span class='notice'>You switch \the [src] off.</span>")
		else if(T)
			T.visible_message("<span class='warning'>\The [src] turns off.</span>")
		playsound(loc, 'sound/items/WelderDeactivate.ogg', 50, 1)
		force = 3
		damtype = BRUTE
		w_class = initial(w_class)
		welding = FALSE
		set_processing(FALSE)
		update_icon()

//A wrapper function for the experimental tool to override
/obj/item/weldingtool/proc/set_processing(var/state = 0)
	if (state == 1)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)

//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/weldingtool/proc/eyecheck(mob/user)
	if(!iscarbon(user))
		return 1
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/internal/eyes/E = H.get_eyes()
		if(!E)
			return
		if(H.status_flags & GODMODE)
			return
		var/safety = H.eyecheck()
		var/damage_to_take = 0
		switch(safety)
			if(FLASH_PROTECTION_MODERATE)
				damage_to_take = E.max_damage / 6
				to_chat(user, "<span class='warning'>Your eyes sting a little.</span>")
				E.take_damage(damage_to_take)
			if(FLASH_PROTECTION_NONE)
				damage_to_take = E.max_damage / 5
				to_chat(user, "<span class='warning'>Your eyes burn!</span>")
				E.take_damage(damage_to_take)
			if(FLASH_PROTECTION_REDUCED)
				damage_to_take = E.max_damage / 3
				to_chat(user, "<span class='danger'><font size=4>Your eyes are burning!</font></span>")
				user.eye_blurry += rand(12, 20)
				E.take_damage(damage_to_take)
		if(safety < FLASH_PROTECTION_MAJOR)
			if(E.is_bruised())
				to_chat(user, "<span class='danger'>You can't see anymore!</span>")
				user.disabilities |= NEARSIGHTED
				addtimer(CALLBACK(user, /mob/.proc/reset_nearsighted), 100)

// This is on /mob instead of the welder so the timer is stopped when the mob is deleted.
/mob/proc/reset_nearsighted()
	disabilities &= ~NEARSIGHTED

/obj/item/weldingtool/Destroy()
	STOP_PROCESSING(SSprocessing, src)	//Stop processing when destroyed regardless of conditions
	return ..()

//Make sure the experimental tool only stops processing when its turned off AND full
/obj/item/weldingtool/experimental/set_processing(var/state = 0)
	if (state == 1)
		START_PROCESSING(SSprocessing, src)
		last_gen = world.time
	else if (welding == 0 && get_fuel() >= max_fuel)
		STOP_PROCESSING(SSprocessing, src)

/obj/item/weldingtool/experimental/process()
	..()
	fuel_gen()

/obj/item/weldingtool/experimental/proc/fuel_gen()//Proc to make the experimental welder generate fuel, optimized as fuck -Sieve
	if (get_fuel() < max_fuel)
		var/gen_amount = ((world.time-last_gen) / fuelgen_delay)
		var/remainder = max_fuel - get_fuel()
		gen_amount = min(gen_amount, remainder)
		reagents.add_reagent("fuel", gen_amount)
		if(get_fuel() >= max_fuel)
			set_processing(0)
	else
		set_processing(0)
	last_gen = world.time

/*
 * Crowbar
 */

/obj/item/crowbar
	name = "crowbar"
	desc = "An iron bar with a flattened end, used as a lever to remove floors and pry open doors."
	icon = 'icons/obj/tools.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_tools.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_tools.dmi',
		)
	icon_state = "crowbar"
	item_state = "crowbar"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 8
	throwforce = 7
	w_class = 2.0
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	drop_sound = 'sound/items/drop/sword.ogg'
	usesound = 'sound/items/Crowbar.ogg'

/obj/item/crowbar/iscrowbar()
	return TRUE

/obj/item/crowbar/red
	icon = 'icons/obj/tools.dmi'
	icon_state = "crowbar_red"
	item_state = "crowbar_red"

// Pipe wrench
/obj/item/pipewrench
	name = "pipe wrench"
	desc = "A big wrench that is made for working with pipes."
	icon = 'icons/obj/tools.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_tools.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_tools.dmi',
		)
	icon_state = "pipewrench"
	item_state = "pipewrench"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 8
	throwforce = 7
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 150)
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")

/obj/item/pipewrench/Initialize()
	. = ..()
	color = color_rotation(rand(-11, 12) * 15)

//combitool

/obj/item/combitool
	name = "combi-tool"
	desc = "It even has one of those nubbins for doing the thingy."
	icon = 'icons/obj/tools.dmi'
	icon_state = "combitool"
	item_state = "combitool"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_tools.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_tools.dmi',
		)
	force = 3
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/scrap.ogg'

	var/list/tools = list(
		"crowbar",
		"screwdriver",
		"wrench",
		"wirecutters",
		"multitool"
		)
	var/current_tool = 1

/obj/item/combitool/Initialize()
	desc = "[initial(desc)] ([tools.len]. [tools.len] possibilit[tools.len == 1 ? "y" : "ies"])"
	. = ..()

/obj/item/combitool/examine(var/mob/user)
	. = ..()
	if(. && tools.len)
		to_chat(user, "It has the following fittings:")
		for(var/tool in tools)
			to_chat(user, "- [tool][tools[current_tool] == tool ? " (selected)" : ""]")

/obj/item/combitool/iswrench()
	return tools[current_tool] == "wrench"

/obj/item/combitool/isscrewdriver()
	return tools[current_tool] == "screwdriver"

/obj/item/combitool/iswirecutter()
	return tools[current_tool] == "wirecutters"

/obj/item/combitool/iscrowbar()
	return tools[current_tool] == "crowbar"

/obj/item/combitool/ismultitool()
	return tools[current_tool] == "multitool"

/obj/item/combitool/proc/update_tool()
	icon_state = "[initial(icon_state)]-[tools[current_tool]]"

/obj/item/combitool/attack_self(var/mob/user)
	if(++current_tool > tools.len)
		current_tool = 1
	var/tool = tools[current_tool]
	if(!tool)
		to_chat(user, "You can't seem to find any fittings in \the [src].")
	else
		to_chat(user, "You switch \the [src] to the [tool] fitting.")
	update_tool()
	return 1

/obj/item/powerdrill
	name = "impact wrench"
	desc = " The screwdriver's big brother."
	icon = 'icons/obj/tools.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_tools.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_tools.dmi',
		)
	icon_state = "powerdrillyellow"
	item_state = "powerdrillyellow"
	var/drillcolor = null
	force = 8
	attack_verb = list("gored", "drilled", "screwed", "punctured")
	w_class = ITEMSIZE_SMALL
	toolspeed = 3
	usesound = 'sound/items/drill_use.ogg'

	var/list/tools = list(
		"screwdriverbit",
		"wrenchbit"
		)
	var/current_tool = 1

/obj/item/powerdrill/Initialize()
	. = ..()

	switch(pick("red","blue","yellow","green"))
		if ("red")
			drillcolor = "red"
		if ("blue")
			drillcolor = "blue"
		if ("green")
			drillcolor = "green"
		if ("yellow")
			drillcolor = "yellow"
	icon_state = "powerdrill[drillcolor]"
	item_state = "powerdrill[drillcolor]"

/obj/item/powerdrill/examine(var/mob/user)
	. = ..()
	if(. && tools.len)
		to_chat(user, "It has the following fittings:")
		for(var/tool in tools)
			to_chat(user, "- [tool][tools[current_tool] == tool ? " (selected)" : ""]")

/obj/item/powerdrill/iswrench()
	usesound = 'sound/items/air_wrench.ogg'
	return tools[current_tool] == "wrenchbit"

/obj/item/powerdrill/isscrewdriver()
	usesound = 'sound/items/drill_use.ogg'

	return tools[current_tool] == "screwdriverbit"

/obj/item/powerdrill/proc/update_tool()
	if(isscrewdriver())
		cut_overlays()
		add_overlay("screwdriverbit")
	if(iswrench())
		cut_overlays()
		add_overlay("wrenchbit")

/obj/item/powerdrill/attack_self(var/mob/user)
	if(++current_tool > tools.len)
		current_tool = 1
	var/tool = tools[current_tool]
	if(!tool)
		to_chat(user, "You can't seem to find any fittings in \the [src].")
	else
		to_chat(user, "You switch \the [src] to the [tool] fitting.")
		playsound(loc, 'sound/items/change_drill.ogg', 50, 1)
	update_tool()
	return 1
