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
/obj/item/weapon/wrench
	name = "wrench"
	desc = "A wrench with many common uses. Can be usually found in your hand."
	icon = 'icons/obj/items.dmi'
	icon_state = "wrench"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 150)
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")


/*
 * Screwdriver
 */
/obj/item/weapon/screwdriver
	name = "screwdriver"
	desc = "You can be totally screwwy with this."
	icon = 'icons/obj/items.dmi'
	icon_state = "screwdriver"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_EARS
	force = 5.0
	w_class = 1.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	matter = list(DEFAULT_WALL_MATERIAL = 75)
	attack_verb = list("stabbed")
	var/random_icon = TRUE

/obj/item/weapon/screwdriver/Initialize()
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

/obj/item/weapon/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob, var/target_zone)
	if(!istype(M) || user.a_intent == "help")
		return ..()
	if(target_zone != "eyes" && target_zone != "head")
		return ..()
	if((CLUMSY in user.mutations) && prob(50))
		M = user
	return eyestab(M,user)

/*
 * Wirecutters
 */
/obj/item/weapon/wirecutters
	name = "wirecutters"
	desc = "This cuts wires."
	icon = 'icons/obj/items.dmi'
	icon_state = "cutters"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 6.0
	throw_speed = 2
	throw_range = 9
	w_class = 2.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 80)
	attack_verb = list("pinched", "nipped")
	sharp = 1
	edge = 1

/obj/item/weapon/wirecutters/New()
	if(prob(50))
		icon_state = "cutters-y"
		item_state = "cutters_yellow"
	..()

/obj/item/weapon/wirecutters/attack(mob/living/carbon/C as mob, mob/user as mob, var/target_zone)
	if(user.a_intent == I_HELP && (C.handcuffed) && (istype(C.handcuffed, /obj/item/weapon/handcuffs/cable)))
		usr.visible_message("\The [usr] cuts \the [C]'s restraints with \the [src]!",\
		"You cut \the [C]'s restraints with \the [src]!",\
		"You hear cable being cut.")
		C.handcuffed = null
		if(C.buckled && C.buckled.buckle_require_restraints)
			C.buckled.unbuckle_mob()
		C.update_inv_handcuffed()
		return
	else
		..()

/*
 * Welding Tool
 */
/obj/item/weapon/weldingtool
	name = "welding tool"
	desc = "A welding tool with a built-in fuel tank, designed for welding and cutting metal."
	icon = 'icons/obj/tools/welding.dmi'
	icon_state = "welder_off"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	var/base_iconstate = "welder"//These are given an _on/_off suffix before being used
	var/base_itemstate = "welder"
	contained_sprite = 1

	//Amount of OUCH when it's thrown
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0

	//Cost to make in the autolathe
	matter = list(DEFAULT_WALL_MATERIAL = 70, "glass" = 30)

	//R&D tech level
	origin_tech = list(TECH_ENGINEERING = 1)

	//Welding tool specific stuff
	var/welding = 0 	//Whether or not the welding tool is off(0), on(1) or currently welding(2)
	var/status = 1 		//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/max_fuel = 20 	//The max amount of fuel the welder can hold


/obj/item/weapon/weldingtool/largetank
	name = "industrial welding tool"
	desc = "A welding tool with an extended-capacity built-in fuel tank, standard issue for engineers."
	max_fuel = 40
	matter = list(DEFAULT_WALL_MATERIAL = 100, "glass" = 60)
	base_iconstate = "ind_welder"
	origin_tech = list(TECH_ENGINEERING = 2)


/obj/item/weapon/weldingtool/hugetank
	name = "advanced welding tool"
	desc = "A rare and powerful welding tool with a super-extended fuel tank."
	max_fuel = 80
	w_class = 2.0
	matter = list(DEFAULT_WALL_MATERIAL = 200, "glass" = 120)
	base_iconstate = "adv_welder"
	origin_tech = list(TECH_ENGINEERING = 3)

//The Experimental Welding Tool!
/obj/item/weapon/weldingtool/experimental
	name = "experimental welding tool"
	desc = "A scientifically-enhanced welding tool that uses fuel-producing microbes to gradually replenish its fuel supply"
	max_fuel = 40
	w_class = 2.0
	matter = list(DEFAULT_WALL_MATERIAL = 100, "glass" = 120)
	base_iconstate = "exp_welder"
	origin_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)
	base_itemstate = "exp_welder"

	var/last_gen = 0
	var/fuelgen_delay = 800//The time, in deciseconds, required to regenerate one unit of fuel
	//800 = 1 unit per 1 minute and 20 seconds,
	//This is roughly half the rate that fuel is lost if the welder is left idle, so it you carelessly leave it on it will still run out

//Welding tool functionality here
/obj/item/weapon/weldingtool/Initialize()
	. = ..()
//	var/random_fuel = min(rand(10,20),max_fuel)
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	update_icon()

/obj/item/weapon/weldingtool/update_icon()
	..()
	var/add = welding ? "_on" : "_off"
	icon_state = base_iconstate + add //These are given an _on/_off suffix before being used
	item_state = base_itemstate + add
	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

/obj/item/weapon/weldingtool/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/weapon/weldingtool/examine(mob/user)
	if(..(user, 0))
		user << text("\icon[] [] contains []/[] units of fuel!", src, src.name, get_fuel(),src.max_fuel )

/obj/item/weapon/weldingtool/attackby(obj/item/W as obj, mob/user as mob)
	if(isscrewdriver(W))
		if (isrobot(loc))
			user << span("alert", "You cannot modify your own welder!")
			return
		if(welding)
			user << span("danger", "Stop welding first!")
			return
		status = !status
		if(status)
			user << span("notice", "You secure the welder.")
		else
			user << span("notice", "The welder can now be attached and modified.")
		src.add_fingerprint(user)
		return

	if((!status) && (istype(W,/obj/item/stack/rods)))
		var/obj/item/stack/rods/R = W
		R.use(1)
		var/obj/item/weapon/flamethrower/F = new/obj/item/weapon/flamethrower(user.loc)
		src.forceMove(F)
		F.weldtool = src
		if (user.client)
			user.client.screen -= src
		if (user.r_hand == src)
			user.remove_from_mob(src)
		else
			user.remove_from_mob(src)
		src.master = F
		src.layer = initial(src.layer)
		user.remove_from_mob(src)
		if (user.client)
			user.client.screen -= src
		src.forceMove(F)
		src.add_fingerprint(user)
		return

	..()
	return

/obj/item/weapon/weldingtool/process()
	if(welding)
		if(prob(5))
			remove_fuel(1)

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

/obj/item/weapon/weldingtool/attack(mob/living/M as mob, mob/user as mob, var/target_zone)

	if(hasorgans(M))

		var/obj/item/organ/external/S = M:organs_by_name[target_zone]

		if (!S) return
		if(!(S.status & ORGAN_ROBOT) || user.a_intent != I_HELP)
			return ..()

		if(M.isSynthetic() && M == user && !(M.get_species() == "Hunter-Killer"))
			user << "<span class='warning'>You can't repair damage to your own body - it's against OH&S.</span>"
			return
		if(S.brute_dam == 0)
			// Organ undamaged
			user << "Nothing to fix here!"
			return
		if (!src.welding)
			// Welder is switched off!
			user << "<span class='warning'>You need to light the welding tool, first!</span>"
			return
		if(S.brute_dam > ROBOLIMB_SELF_REPAIR_CAP)
			user << "<span class='warning'>The damage is far too severe to patch over externally.</span>"
			return
		if (src.remove_fuel(0))
			// Use a bit of fuel and repair
			S.heal_damage(15,0,0,1)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			user.visible_message("<span class='warning'>\The [user] patches some dents on \the [M]'s [S.name] with \the [src].</span>")
		else
			// Welding tool is out of fuel
			user << "Need more welding fuel!"
		return

	else
		return ..()

/obj/item/weapon/weldingtool/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && !src.welding)
		O.reagents.trans_to_obj(src, max_fuel)
		user << "<span class='notice'>Welder refueled</span>"
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	else if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && src.welding)
		var/obj/structure/reagent_dispensers/fueltank/tank = O
		if(tank.armed)
			user << "You are already heating the [O]"
			return
		tank.armed = 1
		user.visible_message("[user] begins heating the [O].", "You start to heat the [O].")
		message_admins("[key_name_admin(user)] is attempting a welder bomb at ([loc.x],[loc.y],[loc.z]) - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[O.x];Y=[O.y];Z=[O.z]'>JMP</a>")
		if(do_after(user,100))
			if(tank.defuse)
				user.visible_message("[user] melts some of the framework on the [O].", "You melt some of the framework.")
				tank.defuse = 0
				tank.armed = 0
				return
			message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
			log_game("[key_name(user)] triggered a fueltank explosion with a welding tool.",ckey=key_name(user))
			user << span("alert", "That was stupid of you.")
			tank.ex_act(3.0)
			return
		else
			tank.armed = 0
			user << "You thought better of yourself."
			return
		return
	if (src.welding)
		remove_fuel(1)
		var/turf/location = get_turf(user)
		if(isliving(O))
			var/mob/living/L = O
			L.IgniteMob()
		if (istype(location, /turf))
			location.hotspot_expose(700, 50, 1)
	return

/obj/item/weapon/weldingtool/attack_self(mob/user as mob)
	setWelding(!welding, usr)
	return

//Returns the amount of fuel in the welder
/obj/item/weapon/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

//Removes fuel from the welding tool. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/weapon/weldingtool/proc/remove_fuel(var/amount = 1, var/mob/M = null)
	if(!welding)
		return 0
	if(get_fuel() >= amount)
		reagents.remove_reagent("fuel", amount)
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			M << span("notice", "You need more welding fuel to complete this task.")
		return 0

//Returns whether or not the welding tool is currently on.
/obj/item/weapon/weldingtool/proc/isOn()
	return src.welding

//Sets the welding state of the welding tool. If you see W.welding = 1 anywhere, please change it to W.setWelding(1)
//so that the welding tool updates accordingly
/obj/item/weapon/weldingtool/proc/setWelding(var/set_welding, var/mob/M)
	if(!status)	return

	var/turf/T = get_turf(src)
	//If we're turning it on
	if(set_welding && !welding)
		if (get_fuel() > 0)
			if(M)
				M << "<span class='notice'>You switch the [src] on.</span>"
			else if(T)
				T.visible_message("<span class='danger'>\The [src] turns on.</span>")
			playsound(loc, 'sound/items/WelderActivate.ogg', 50, 1)
			src.force = 15
			src.damtype = "fire"
			src.w_class = 4
			welding = 1
			update_icon()
			set_processing(1)
		else
			if(M)
				M << "<span class='notice'>You need more welding fuel to complete this task.</span>"
			return
	//Otherwise
	else if(!set_welding && welding)
		if(M)
			M << "<span class='notice'>You switch \the [src] off.</span>"
		else if(T)
			T.visible_message("<span class='warning'>\The [src] turns off.</span>")
		playsound(loc, 'sound/items/WelderDeactivate.ogg', 50, 1)
		src.force = 3
		src.damtype = "brute"
		src.w_class = initial(src.w_class)
		src.welding = 0
		set_processing(0)
		update_icon()

//A wrapper function for the experimental tool to override
/obj/item/weapon/weldingtool/proc/set_processing(var/state = 0)
	if (state == 1)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)

//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/weapon/weldingtool/proc/eyecheck(mob/user as mob)
	if(!iscarbon(user))	return 1
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/eyes/E = H.get_eyes()
		if(!E)
			return
		var/safety = H.eyecheck()
		if(H.status_flags & GODMODE)
			return
		switch(safety)
			if(FLASH_PROTECTION_MODERATE)
				usr << "<span class='warning'>Your eyes sting a little.</span>"
				E.damage += rand(1, 2)
				if(E.damage > 12)
					user.eye_blurry += rand(3,6)
			if(FLASH_PROTECTION_NONE)
				usr << "<span class='warning'>Your eyes burn.</span>"
				E.damage += rand(2, 4)
				if(E.damage > 10)
					E.damage += rand(4,10)
			if(FLASH_PROTECTION_REDUCED)
				usr << "<span class='danger'>Your equipment intensify the welder's glow. Your eyes itch and burn severely.</span>"
				user.eye_blurry += rand(12,20)
				E.damage += rand(12, 16)
		if(safety<FLASH_PROTECTION_MAJOR)
			if(E.damage > 10)
				user << "<span class='warning'>Your eyes are really starting to hurt. This can't be good for you!</span>"

			if (E.damage >= E.min_broken_damage)
				user << "<span class='danger'>You go blind!</span>"
				user.sdisabilities |= BLIND
			else if (E.damage >= E.min_bruised_damage)
				user << "<span class='danger'>You go blind!</span>"
				user.eye_blind = 5
				user.eye_blurry = 5
				user.disabilities |= NEARSIGHTED
				addtimer(CALLBACK(user, /mob/.proc/reset_nearsighted), 100)

// This is on /mob instead of the welder so the timer is stopped when the mob is deleted.
/mob/proc/reset_nearsighted()
	disabilities &= ~NEARSIGHTED

/obj/item/weapon/weldingtool/Destroy()
	STOP_PROCESSING(SSprocessing, src)	//Stop processing when destroyed regardless of conditions
	return ..()

//Make sure the experimental tool only stops processing when its turned off AND full
/obj/item/weapon/weldingtool/experimental/set_processing(var/state = 0)
	if (state == 1)
		START_PROCESSING(SSprocessing, src)
		last_gen = world.time
	else if (welding == 0 && get_fuel() >= max_fuel)
		STOP_PROCESSING(SSprocessing, src)

/obj/item/weapon/weldingtool/experimental/process()
	..()
	fuel_gen()

/obj/item/weapon/weldingtool/experimental/proc/fuel_gen()//Proc to make the experimental welder generate fuel, optimized as fuck -Sieve

	if (get_fuel() < max_fuel)
		var/gen_amount = ((world.time-last_gen)/fuelgen_delay)
		var/remainder = max_fuel - get_fuel()
		gen_amount = min(gen_amount, remainder)
		reagents.add_reagent("fuel", gen_amount)
		//reagents += (gen_amount)

		if(get_fuel() >= max_fuel)
			//reagents = max_fuel
			set_processing(0)
	else
		set_processing(0)
	last_gen = world.time

/*
 * Crowbar
 */

/obj/item/weapon/crowbar
	name = "crowbar"
	desc = "Used to remove floors and to pry open doors."
	icon = 'icons/obj/items.dmi'
	icon_state = "crowbar"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 5.0
	throwforce = 7.0
	item_state = "crowbar"
	w_class = 2.0
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")

/obj/item/weapon/crowbar/red
	icon = 'icons/obj/items.dmi'
	icon_state = "red_crowbar"
	item_state = "crowbar_red"

// Pipe wrench
/obj/item/weapon/pipewrench
	name = "pipe wrench"
	desc = "A big wrench that is made for working with pipes."
	icon = 'icons/obj/items.dmi'
	icon_state = "pipewrench"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 150)
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
