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
	usesound = 'sound/items/wrench.ogg'
	drop_sound = 'sound/items/drop/wrench.ogg'
	pickup_sound = 'sound/items/pickup/wrench.ogg'

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
	icon_state = "screwdriver"
	item_state = "screwdriver"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_EARS
	force = 8
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	w_class = ITEMSIZE_TINY
	matter = list(DEFAULT_WALL_MATERIAL = 75)
	attack_verb = list("stabbed")
	usesound = 'sound/items/screwdriver.ogg'
	drop_sound = 'sound/items/drop/screwdriver.ogg'
	pickup_sound = 'sound/items/pickup/screwdriver.ogg'
	lock_picking_level = 5
	build_from_parts = TRUE
	worn_overlay = "head"

/obj/item/screwdriver/Initialize()
	. = ..()
	if(build_from_parts) //random colors!
		color = pick(COLOR_BLUE, COLOR_RED, COLOR_PURPLE, COLOR_BROWN, COLOR_GREEN, COLOR_CYAN, COLOR_YELLOW)
		add_overlay(overlay_image(icon, "[initial(icon_state)]_[worn_overlay]", flags=RESET_COLOR))

/obj/item/screwdriver/update_icon()
	var/matrix/tf = matrix()
	if(istype(loc, /obj/item/storage))
		tf.Turn(-90) //Vertical for storing compactly
		tf.Translate(-3,0) //Could do this with pixel_x but let's just update the appearance once.
	transform = tf

/obj/item/screwdriver/get_belt_overlay()
	var/mutable_appearance/body = mutable_appearance('icons/obj/clothing/belt_overlays.dmi', "screwdriver")
	var/mutable_appearance/head = mutable_appearance('icons/obj/clothing/belt_overlays.dmi', "screwdriver_head")
	body.color = color
	head.add_overlay(body)
	return head

/obj/item/screwdriver/pickup(mob/user)
	..()
	update_icon()

/obj/item/screwdriver/dropped(mob/user)
	..()
	update_icon()

/obj/item/screwdriver/attack_hand()
	..()
	update_icon()

/obj/item/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob, var/target_zone)
	if(!istype(M) || user.a_intent == "help")
		return ..()
	if((target_zone != BP_EYES && target_zone != BP_HEAD) || M.eyes_protected(src, FALSE))
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
	icon_state = "wirecutters"
	item_state = "wirecutters"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 6
	throw_speed = 2
	throw_range = 9
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 80)
	attack_verb = list("pinched", "nipped")
	sharp = TRUE
	edge = TRUE
	usesound = 'sound/items/wirecutter.ogg'
	drop_sound = 'sound/items/drop/wirecutter.ogg'
	pickup_sound = 'sound/items/pickup/wirecutter.ogg'
	var/bomb_defusal_chance = 30 // 30% chance to safely defuse a bomb
	build_from_parts = TRUE
	worn_overlay = "head"

	var/list/color_options = list(COLOR_BLUE, COLOR_RED, COLOR_PURPLE, COLOR_BROWN, COLOR_GREEN, COLOR_CYAN, COLOR_YELLOW)

/obj/item/wirecutters/Initialize()
	. = ..()
	if(build_from_parts)
		color = pick(color_options)
		add_overlay(overlay_image(icon, "[initial(icon_state)]_[worn_overlay]", flags=RESET_COLOR))

/obj/item/wirecutters/update_icon()
	var/matrix/tf = matrix()
	if(istype(loc, /obj/item/storage))
		tf.Turn(-90) //Vertical for storing compactly
		tf.Translate(-1,0) //Could do this with pixel_x but let's just update the appearance once.
	transform = tf

/obj/item/wirecutters/get_belt_overlay()
	var/mutable_appearance/body = mutable_appearance('icons/obj/clothing/belt_overlays.dmi', "wirecutters")
	var/mutable_appearance/head = mutable_appearance('icons/obj/clothing/belt_overlays.dmi', "wirecutters_head")
	body.color = color
	head.add_overlay(body)
	return head

/obj/item/wirecutters/pickup(mob/user)
	..()
	update_icon()

/obj/item/wirecutters/dropped(mob/user)
	..()
	update_icon()

/obj/item/wirecutters/attack_hand()
	..()
	update_icon()

/obj/item/wirecutters/attack(mob/living/carbon/C, mob/user, var/target_zone)
	if(user.a_intent == I_HELP && (C.handcuffed) && (istype(C.handcuffed, /obj/item/handcuffs/cable)))
		user.visible_message(SPAN_NOTICE("\The [user] cuts \the [C]'s restraints with \the [src]!"),\
		SPAN_NOTICE("You cut \the [C]'s restraints with \the [src]!"),\
		SPAN_NOTICE("You hear cable being cut."))
		C.handcuffed = null
		if(C.buckled_to?.buckle_require_restraints)
			C.buckled_to.unbuckle()
		C.update_inv_handcuffed()
		return
	else
		..()

/obj/item/wirecutters/iswirecutter()
	return TRUE

/obj/item/wirecutters/toolbelt
	color_options = list(COLOR_TOOLS)

/obj/item/wirecutters/bomb
	name = "bomb defusal wirecutters"
	desc = "A tool used to delicately sever the wires used in bomb fuses."
	icon_state = "mini_wirecutters"
	toolspeed = 0.6
	bomb_defusal_chance = 90 // 90% chance, because the thrill of dying must be kept at all times, duh

/*
 * Welding Tool
 */
/obj/item/weldingtool
	name = "welding tool"
	desc = "A welding tool with a built-in fuel tank, designed for welding and cutting metal."
	icon = 'icons/obj/contained_items/tools/welding_tools.dmi'
	icon_state = "welder"
	item_state = "welder"
	contained_sprite = TRUE
	flags = CONDUCT
	slot_flags = SLOT_BELT
	drop_sound = 'sound/items/drop/weldingtool.ogg'
	pickup_sound = 'sound/items/pickup/weldingtool.ogg'
	usesound = 'sound/items/welder.ogg'

	attack_verb = list("hit", "bludgeoned", "whacked")

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

	var/change_icons = TRUE

/obj/item/weldingtool/iswelder()
	return TRUE

/obj/item/weldingtool/largetank
	name = "industrial welding tool"
	desc = "A welding tool with an extended-capacity built-in fuel tank, standard issue for engineers."
	icon_state = "indwelder"
	item_state = "welder"
	max_fuel = 40
	matter = list(DEFAULT_WALL_MATERIAL = 100, MATERIAL_GLASS = 60)
	origin_tech = list(TECH_ENGINEERING = 2)

/obj/item/weldingtool/hugetank
	name = "advanced welding tool"
	desc = "A rare and powerful welding tool with a super-extended fuel tank."
	icon_state = "advwelder"
	item_state = "advwelder"
	max_fuel = 80
	matter = list(DEFAULT_WALL_MATERIAL = 200, MATERIAL_GLASS = 120)
	origin_tech = list(TECH_ENGINEERING = 3)

/obj/item/weldingtool/emergency
	name = "emergency welding tool"
	desc = "A miniaturized version of a standard welding tool, this one was made to be used during emergencies."
	icon_state = "miniwelder"
	item_state = "miniwelder"
	max_fuel = 10

//The Experimental Welding Tool!
/obj/item/weldingtool/experimental
	name = "experimental welding tool"
	desc = "A scientifically-enhanced welding tool that uses fuel-producing microbes to gradually replenish its fuel supply."
	icon_state = "expwelder"
	item_state = "expwelder"
	max_fuel = 40
	matter = list(DEFAULT_WALL_MATERIAL = 100, MATERIAL_GLASS = 120)
	origin_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)

	var/last_gen = 0
	var/fuelgen_delay = 400 //The time, in deciseconds, required to regenerate one unit of fuel
	//400 = 1 unit per 40 seconds
	change_icons = FALSE

	var/obj/item/eyeshield/eyeshield
	var/obj/item/overcapacitor/overcap

//Welding tool functionality here
/obj/item/weldingtool/Initialize()
	. = ..()
//	var/random_fuel = min(rand(10,20),max_fuel)
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent(/decl/reagent/fuel, max_fuel)
	update_icon()

/obj/item/weldingtool/proc/update_torch()
	if(welding)
		add_overlay("[initial(icon_state)]-on")
		item_state = "[initial(item_state)]1"
	else
		item_state = "[initial(item_state)]"

	if(welding == 2)
		set_light(0.7, 2, l_color = LIGHT_COLOR_CYAN)
	else if (welding == 1)
		set_light(0.6, 1.5, l_color = LIGHT_COLOR_LAVA)
	else
		set_light(0)

/obj/item/weldingtool/update_icon()
	cut_overlays()
	if(change_icons)
		var/ratio = get_fuel() / max_fuel
		ratio = CEILING(ratio*4, 1) * 25
		add_overlay("[initial(icon_state)][ratio]")
	update_torch()
	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

/obj/item/weldingtool/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/weldingtool/examine(mob/user)
	if(..(user, 0))
		to_chat(user, text("[icon2html(src, user)] [] contains []/[] units of fuel!", src.name, get_fuel(),src.max_fuel ))

/obj/item/weldingtool/attackby(obj/item/W, mob/user)
	if(W.isscrewdriver())
		if(isrobot(loc))
			to_chat(user, SPAN_ALERT("You cannot modify your own welder!"))
			return
		if(welding)
			to_chat(user, SPAN_DANGER("Stop welding first!"))
			return
		status = !status
		if(status)
			to_chat(user, SPAN_NOTICE("You secure the welder."))
		else
			to_chat(user, SPAN_NOTICE("The welder can now be attached and modified."))
		add_fingerprint(user)
		return

	if(!status && (istype(W, /obj/item/stack/rods)))
		var/obj/item/stack/rods/R = W
		R.use(1)
		add_fingerprint(user)
		user.drop_from_inventory(src)
		var/obj/item/flamethrower/F = new /obj/item/flamethrower(get_turf(src), src)
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

		if(H.isSynthetic() && H == user && !(H.get_species() == SPECIES_IPC_TERMINATOR))
			to_chat(user, SPAN_WARNING("You can't repair damage to your own body - it's against OH&S."))
			return

		if (!welding)
			to_chat(user, SPAN_WARNING("You need to light the welding tool first!"))
			return

		if(S.brute_dam)
			if(S.brute_dam > ROBOLIMB_SELF_REPAIR_CAP)
				to_chat(user, SPAN_WARNING("The damage is far too severe to patch over externally!"))
				return
			else
				repair_organ(user, H, S)

		else if(S.open != 2)
			to_chat(user, SPAN_NOTICE("You can't see any external damage to repair."))
	else
		return ..()

/obj/item/weldingtool/proc/repair_organ(var/mob/living/user, var/mob/living/carbon/human/target, var/obj/item/organ/external/affecting)
	if(!affecting.brute_dam)
		user.visible_message(SPAN_NOTICE("\The [user] finishes repairing the physical damage on \the [target]'s [affecting.name]."))
		return

	if(do_mob(user, target, 30))
		if(remove_fuel(0))
			var/static/list/repair_messages = list(
				"patches some dents",
				"mends some tears",
				"repairs some joints"
			)
			affecting.heal_damage(brute = 15, robo_repair = TRUE)
			user.visible_message(SPAN_WARNING("\The [user] [pick(repair_messages)] on [target]'s [affecting.name] with \the [src]."))
			playsound(target, 'sound/items/welder_pry.ogg', 15)
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
		if(use_check(user, USE_DISALLOW_SPECIALS))
			to_chat(user, SPAN_WARNING("A strange force prevents you from doing this.")) //there is no way to justify this icly
			return
		var/obj/structure/reagent_dispensers/fueltank/tank = O
		if(tank.armed)
			to_chat(user, "<span class='warning'>You are already heating \the [O]!</span>")
			return
		user.visible_message("<span class='warning'>[user] begins heating \the [O]...</span>", "<span class='warning'>You start to heat \the [O]!</span>")
		switch(alert("Are you sure you want to do this? It is quite dangerous and could get you in trouble.", "Heat up fuel tank", "No", "Yes"))
			if("Yes")
				log_and_message_admins("is attempting to welderbomb", user)
				to_chat(user, SPAN_ALERT("You start heating the fueltank..."))
				tank.armed = 1
				if(do_after(user, 100))
					if(tank.defuse)
						user.visible_message("[user] melts some of the framework on the [O]!", "You melt some of the framework!")
						tank.defuse = 0
						tank.armed = 0
						return
					log_and_message_admins("triggered a fuel tank explosion", user)
					to_chat(user, SPAN_ALERT("That was stupid of you."))
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
	return REAGENT_VOLUME(reagents, /decl/reagent/fuel)

//Removes fuel from the welding tool. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/weldingtool/proc/remove_fuel(var/amount = 1, var/mob/M = null, var/colourChange = TRUE)
	if(!welding)
		return 0
	else if(welding > 0 && colourChange)
		set_light(0.7, 2, l_color = LIGHT_COLOR_CYAN)
		addtimer(CALLBACK(src, /atom/proc/update_icon), 5)
	if(get_fuel() >= amount)
		reagents.remove_reagent(/decl/reagent/fuel, amount)
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			to_chat(M, SPAN_NOTICE("You need more welding fuel to complete this task."))
		return 0

/obj/item/weldingtool/use_resource(mob/user, var/use_amount)
	if(get_fuel() >= use_amount)
		reagents.remove_reagent(/decl/reagent/fuel, use_amount)

//Returns whether or not the welding tool is currently on.
/obj/item/weldingtool/proc/isOn()
	return src.welding

/obj/item/weldingtool/isFlameSource()
	return isOn()

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
			playsound(loc, 'sound/items/welder_activate.ogg', 50, 1)
			force = 15
			damtype = BURN
			w_class = ITEMSIZE_LARGE
			welding = TRUE
			attack_verb = list("scorched", "burned", "blasted", "blazed")
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
		playsound(loc, 'sound/items/welder_deactivate.ogg', 50, 1)
		force = 3
		damtype = BRUTE
		w_class = initial(w_class)
		welding = FALSE
		hitsound = /decl/sound_category/swing_hit_sound
		attack_verb = list("hit", "bludgeoned", "whacked")
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

/obj/item/weldingtool/experimental/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/eyeshield))
		if(eyeshield)
			to_chat(user, SPAN_WARNING("\The [src] already has an eye shield installed!"))
			return
		user.drop_from_inventory(I, src)
		to_chat(user, SPAN_NOTICE("You install \the [I] into \the [src]."))
		eyeshield = I
		add_overlay("eyeshield_attached", TRUE)
		return
	if(istype(I, /obj/item/overcapacitor))
		if(overcap)
			to_chat(user, SPAN_WARNING("\The [src] already has an overcapacitor installed!"))
			return
		user.drop_from_inventory(I, src)
		to_chat(user, SPAN_NOTICE("You install \the [I] into \the [src]."))
		overcap = I
		add_overlay("overcap_attached", TRUE)
		toolspeed *= 2
		return
	if(I.isscrewdriver())
		if(!eyeshield && !overcap)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have any accessories to remove!"))
			return
		var/list/accessories = list()
		if(eyeshield)
			var/image/radial_button = image(icon = src.icon, icon_state = "eyeshield")
			accessories["Eye Shield"] = radial_button
		if(overcap)
			var/image/radial_button = image(icon = src.icon, icon_state = "overcap")
			accessories["Overcapacitor"] = radial_button
		var/obj/item/remove_accessory
		switch(show_radial_menu(user, src, accessories, radius = 42, tooltips = TRUE))
			if("Eye Shield")
				remove_accessory = eyeshield
				eyeshield = null
			if("Overcapacitor")
				remove_accessory = overcap
				overcap = null
				toolspeed *= 0.5
		if(!remove_accessory)
			return
		user.put_in_hands(remove_accessory)
		to_chat(user, SPAN_NOTICE("You remove \the [remove_accessory] into \the [src]."))
		cut_overlay("[remove_accessory.icon_state]_attached", TRUE)
		return
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
		reagents.add_reagent(/decl/reagent/fuel, gen_amount)
		if(get_fuel() >= max_fuel)
			set_processing(0)
	else
		set_processing(0)
	last_gen = world.time

/obj/item/weldingtool/experimental/eyecheck(mob/user)
	if(eyeshield)
		return
	return ..()

/obj/item/weldingtool/experimental/remove_fuel(amount, mob/M, colourChange)
	. = ..(overcap ? amount * 3 : amount, M, colourChange)
	if(!. && welding && overcap) // to ensure that the fuel gets used even if the amount is high
		reagents.remove_reagent(/decl/reagent/fuel, get_fuel())

/obj/item/eyeshield
	name = "experimental eyeshield"
	desc = "An advanced eyeshield capable of dampening the welding glare produced when working on modern super-materials, removing the need for user-worn welding gear."
	desc_info = "This can be attached to an experimental welder to give it welding protection, removing the need for welding goggles or masks."
	icon = 'icons/obj/contained_items/tools/welding_tools.dmi'
	icon_state = "eyeshield"
	item_state = "eyeshield"
	contained_sprite = TRUE

/obj/item/overcapacitor
	name = "experimental overcapacitor"
	desc = "An advanced capacitor that injects a current into the welding stream, doubling the speed of welding tasks without sacrificing quality. Excess current burns up welding fuel, reducing fuel efficiency, however."
	desc_info = "This can be attached to an experimental welder to double the speed it works at, at the cost of tripling the fuel cost of using it."
	icon = 'icons/obj/contained_items/tools/welding_tools.dmi'
	icon_state = "overcap"
	item_state = "overcap"
	contained_sprite = TRUE


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
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/crowbar.ogg'
	pickup_sound = 'sound/items/pickup/crowbar.ogg'
	usesound = /decl/sound_category/crowbar_sound
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")

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
	drop_sound = 'sound/items/drop/multitool.ogg'
	pickup_sound = 'sound/items/pickup/multitool.ogg'

	var/list/tools = list(
		"crowbar",
		"screwdriver",
		"wrench",
		"wirecutters",
		"multitool"
		)
	var/current_tool = 1

/obj/item/combitool/Initialize()
	desc = "[initial(desc)] It has [tools.len] possibilit[tools.len == 1 ? "y" : "ies"]."
	for(var/tool in tools)
		tools[tool] = image('icons/obj/tools.dmi', icon_state = "[icon_state]-[tool]")
	. = ..()

/obj/item/combitool/examine(var/mob/user)
	. = ..()
	if(. && tools.len)
		to_chat(user, "It has the following fittings: <b>[english_list(tools)]</b>.")

/obj/item/combitool/iswrench()
	return current_tool == "wrench"

/obj/item/combitool/isscrewdriver()
	return current_tool == "screwdriver"

/obj/item/combitool/iswirecutter()
	return current_tool == "wirecutters"

/obj/item/combitool/iscrowbar()
	return current_tool == "crowbar"

/obj/item/combitool/ismultitool()
	return current_tool == "multitool"

/obj/item/combitool/proc/update_tool()
	icon_state = "[initial(icon_state)]-[current_tool]"

/obj/item/combitool/attack_self(var/mob/user)
	if(++current_tool > tools.len)
		current_tool = 1
	var/tool = RADIAL_INPUT(user, tools)
	if(tool)
		playsound(user, 'sound/items/penclick.ogg', 25)
		current_tool = tool
		update_tool()
	return 1

/obj/item/powerdrill
	name = "impact wrench"
	desc = "The screwdriver's big brother."
	icon = 'icons/obj/contained_items/tools/impact_wrench.dmi'
	icon_state = "impact_wrench-screw"
	item_state = "impact_wrench"
	contained_sprite = TRUE
	flags = HELDMAPTEXT
	force = 8
	attack_verb = list("gored", "drilled", "screwed", "punctured")
	w_class = ITEMSIZE_SMALL
	toolspeed = 3
	usesound = 'sound/items/drill_use.ogg'
	var/current_tool = 1
	var/list/tools = list(
		"screwdriverbit",
		"wrenchbit"
		)

/obj/item/powerdrill/Initialize()
	. = ..()
	update_tool()

/obj/item/powerdrill/set_initial_maptext()
	held_maptext = SMALL_FONTS(7, "S")

/obj/item/powerdrill/examine(var/mob/user)
	. = ..()
	if(. && tools.len)
		to_chat(user, "It has the following fittings:")
		for(var/tool in tools)
			to_chat(user, "- [tool][tools[current_tool] == tool ? " (selected)" : ""]")

/obj/item/powerdrill/MouseEntered(location, control, params)
	. = ..()
	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && get_dist(usr, src) <= 2)
		params = replacetext(params, "shift=1;", "") // tooltip doesn't appear unless this is stripped
		openToolTip(usr, src, params, "Impact Drill:", "[capitalize(tools[current_tool])]")

/obj/item/powerdrill/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)

/obj/item/powerdrill/iswrench()
	return tools[current_tool] == "wrenchbit"

/obj/item/powerdrill/isscrewdriver()
	return tools[current_tool] == "screwdriverbit"

/obj/item/powerdrill/proc/update_tool()
	if(isscrewdriver())
		usesound = 'sound/items/drill_use.ogg'
		icon_state = "impact_wrench-screw"
		check_maptext(SMALL_FONTS(7, "S"))
	else if(iswrench())
		usesound = 'sound/items/air_wrench.ogg'
		icon_state = "impact_wrench-wrench"
		check_maptext(SMALL_FONTS(7, "W"))

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
	return TRUE

/obj/item/powerdrill/issurgerycompatible()
	return FALSE // too unwieldy for most surgeries

/obj/item/steelwool
	name = "steel wool"
	desc = "Harvested from the finest NanoTrasen steel sheep."
	icon = 'icons/obj/tools.dmi'
	icon_state = "steel_wool"
	flags = NOBLUDGEON
	w_class = ITEMSIZE_SMALL
	var/lit
	matter = list(MATERIAL_STEEL = 40)

/obj/item/steelwool/isFlameSource()
	return lit

/obj/item/steelwool/attackby(obj/item/W, mob/user)
	if(W.isFlameSource())
		ignite(W, user)
	else if(istype(W, /obj/item/cell))
		var/obj/item/cell/S = W
		if(S.charge)
			ignite(W, user)
		else
			to_chat(user, SPAN_WARNING("The cell isn't charged!"))

/obj/item/steelwool/fire_act()
	ignite()

/obj/item/steelwool/proc/ignite(var/L, mob/user)
	if(lit && user)
		to_chat(user, SPAN_WARNING("The steel wool is already lit!"))
		return
	else
		lit = TRUE
		if(user)
			user.visible_message(SPAN_NOTICE("[user] ignites the steel wool with \the [L]."), SPAN_NOTICE("You ignite the steel wool with \the [L]"), SPAN_NOTICE("You hear a gentle flame crackling."))
		playsound(get_turf(src), 'sound/items/flare.ogg', 50)
		desc += " Watch your hands!"
		icon_state = "burning_wool"
		set_light(2, 2, LIGHT_COLOR_LAVA)
		addtimer(CALLBACK(src, .proc/endburn), 120 SECONDS, TIMER_UNIQUE)

/obj/item/steelwool/proc/endburn()
	visible_message(SPAN_NOTICE("The steel wool burns out."))
	if(ishuman(loc))
		var/mob/living/carbon/human/user = loc
		if(!user.gloves)
			var/UserLoc = get_equip_slot()
			if(UserLoc == slot_l_hand)
				user.apply_damage(5, BURN, BP_L_HAND)
				to_chat(user, SPAN_DANGER("The steel wool burns your left hand!"))
			else if(UserLoc == slot_r_hand)
				user.apply_damage(5, BURN, BP_R_HAND)
				to_chat(user, SPAN_DANGER("The steel wool burns your right hand!"))

	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)


/obj/item/hammer
	name = "hammer"
	desc = "A tool with a weighted head used for striking."
	icon = 'icons/obj/tools.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_tools.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_tools.dmi',
		)
	icon_state = "hammer"
	item_state = "hammer"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 8
	throwforce = 5
	throw_speed = 3
	throw_range = 3
	w_class = ITEMSIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 75)
	attack_verb = list("smashed", "hammered")
	drop_sound = 'sound/items/drop/crowbar.ogg'
	pickup_sound = 'sound/items/pickup/crowbar.ogg'
	usesound = /decl/sound_category/crowbar_sound

/obj/item/hammer/Initialize()
	. = ..()
	var/mutable_appearance/handle = mutable_appearance('icons/obj/tools.dmi', "hammer_handle")
	handle.color = pick(COLOR_BLUE, COLOR_RED, COLOR_PURPLE, COLOR_BROWN, COLOR_GREEN, COLOR_CYAN, COLOR_YELLOW)
	add_overlay(handle)

/obj/item/hammer/ishammer()
	return TRUE
