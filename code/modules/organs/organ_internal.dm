#define PROCESS_ACCURACY 10

/****************************************************
				INTERNAL ORGANS DEFINES
****************************************************/


// Brain is defined in brain_item.dm.
/obj/item/organ/heart
	name = "heart"
	icon_state = "heart-on"
	organ_tag = "heart"
	parent_organ = "chest"
	dead_icon = "heart-off"

/obj/item/organ/lungs
	name = "lungs"
	icon_state = "lungs"
	gender = PLURAL
	organ_tag = "lungs"
	parent_organ = "chest"

/obj/item/organ/lungs/process()
	..()

	if(!owner)
		return

	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(5))
			owner.emote("cough")		//respitory tract infection

	if(is_bruised())
		if(prob(2))
			spawn owner.emote("me", 1, "coughs up blood!")
			owner.drip(10)
		if(prob(4))
			spawn owner.emote("me", 1, "gasps for air!")
			owner.losebreath += 15

/obj/item/organ/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	gender = PLURAL
	organ_tag = "kidneys"
	parent_organ = "groin"

/obj/item/organ/kidneys/process()

	..()

	if(!owner)
		return

	// Coffee is really bad for you with busted kidneys.
	// This should probably be expanded in some way, but fucked if I know
	// what else kidneys can process in our reagent list.
	var/datum/reagent/coffee = locate(/datum/reagent/drink/coffee) in owner.reagents.reagent_list
	if(coffee)
		if(is_bruised())
			owner.adjustToxLoss(0.1 * PROCESS_ACCURACY)
		else if(is_broken())
			owner.adjustToxLoss(0.3 * PROCESS_ACCURACY)

/obj/item/organ/eyes
	name = "eyeballs"
	icon_state = "eyes"
	gender = PLURAL
	organ_tag = "eyes"
	parent_organ = "head"
	var/list/eye_colour = list(0,0,0)
	var/singular_name = "eye"

/obj/item/organ/eyes/proc/update_colour()
	if(!owner)
		return
	eye_colour = list(
		owner.r_eyes ? owner.r_eyes : 0,
		owner.g_eyes ? owner.g_eyes : 0,
		owner.b_eyes ? owner.b_eyes : 0
		)

/obj/item/organ/eyes/take_damage(amount, var/silent=0)
	var/oldbroken = is_broken()
	..()
	if(is_broken() && !oldbroken && owner && !owner.stat)
		owner << "<span class='danger'>You go blind!</span>"

/obj/item/organ/eyes/process() //Eye damage replaces the old eye_stat var.
	..()
	if(!owner)
		return
	if(is_bruised())
		owner.eye_blurry = 20
	if(is_broken())
		owner.eye_blind = 20

/obj/item/organ/liver
	name = "liver"
	icon_state = "liver"
	organ_tag = "liver"
	parent_organ = "groin"

/obj/item/organ/liver/process()

	..()

	if(!owner)
		return

	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(1))
			owner << "<span class='warning'>Your skin itches.</span>"
	if (germ_level > INFECTION_LEVEL_TWO)
		if(prob(1))
			spawn owner.delayed_vomit()

	if(owner.life_tick % PROCESS_ACCURACY == 0)

		//High toxins levels are dangerous
		if(owner.getToxLoss() >= 60 && !owner.reagents.has_reagent("anti_toxin"))
			//Healthy liver suffers on its own
			if (src.damage < min_broken_damage)
				src.damage += 0.2 * PROCESS_ACCURACY
			//Damaged one shares the fun
			else
				var/obj/item/organ/O = pick(owner.internal_organs)
				if(O)
					O.damage += 0.2  * PROCESS_ACCURACY

		//Detox can heal small amounts of damage
		if (src.damage && src.damage < src.min_bruised_damage && owner.reagents.has_reagent("anti_toxin"))
			src.damage -= 0.2 * PROCESS_ACCURACY

		if(src.damage < 0)
			src.damage = 0

		// Get the effectiveness of the liver.
		var/filter_effect = 3
		if(is_bruised())
			filter_effect -= 1
		if(is_broken())
			filter_effect -= 2

		if (owner.intoxication > 0)
			//ALCOHOL_FILTRATION_RATE is defined in intoxication.dm
			owner.intoxication -= ALCOHOL_FILTRATION_RATE*filter_effect*PROCESS_ACCURACY//A weakened liver filters out alcohol more slowly
			owner.intoxication = max(owner.intoxication, 0)
			if (!owner.intoxication)
				//If intoxication has just been reduced to zero, this will handle removing any effects
				owner.handle_intoxication()

		// Do some reagent processing.
		if(owner.chem_effects[CE_ALCOHOL_TOXIC])
			if(filter_effect < 3)
				owner.adjustToxLoss(owner.chem_effects[CE_ALCOHOL_TOXIC] * 0.1 * PROCESS_ACCURACY)
			else
				take_damage(owner.chem_effects[CE_ALCOHOL_TOXIC] * 0.1 * PROCESS_ACCURACY, prob(1)) // Chance to warn them

/obj/item/organ/appendix
	name = "appendix"
	icon_state = "appendix"
	parent_organ = "groin"
	organ_tag = "appendix"

/obj/item/organ/appendix/removed()
	if(owner)
		var/inflamed = 0
		for(var/datum/disease/appendicitis/appendicitis in owner.viruses)
			inflamed = 1
			appendicitis.cure()
			owner.resistances += appendicitis
		if(inflamed)
			icon_state = "appendixinflamed"
			name = "inflamed appendix"
	..()

//VAURCA ORGANS
/obj/item/organ/heart/left
	name = "heart"
	icon_state = "heart-on"
	organ_tag = "left heart"
	parent_organ = "chest"
	dead_icon = "heart-off"

/obj/item/organ/heart/right
	name = "heart"
	icon_state = "heart-on"
	organ_tag = "right heart"
	parent_organ = "chest"
	dead_icon = "heart-off"

/obj/item/organ/vaurca/neuralsocket
	name = "neural socket"
	organ_tag = "neural socket"
	icon = 'icons/mob/alien.dmi'
	icon_state = "neural_socket"
	parent_organ = "head"
	robotic = 2

obj/item/organ/vaurca/neuralsocket/process()
	if (is_broken())
		if (all_languages[LANGUAGE_VAURCA] in owner.languages)
			owner.remove_language(LANGUAGE_VAURCA)
			owner << "<span class='warning'>Your mind suddenly grows dark as the unity of the Hive is torn from you.</span>"
	else
		if (!(all_languages[LANGUAGE_VAURCA] in owner.languages))
			owner.add_language(LANGUAGE_VAURCA)
			owner << "<span class='notice'> Your mind expands, and your thoughts join the unity of the Hivenet.</span>"
	..()

/obj/item/organ/vaurca/neuralsocket/replaced(var/mob/living/carbon/human/target)
	if (!(all_languages[LANGUAGE_VAURCA] in owner.languages))
		owner.add_language(LANGUAGE_VAURCA)
		owner << "<span class='notice'> Your mind expands, and your thoughts join the unity of the Hivenet.</span>"
	..()

/obj/item/organ/vaurca/neuralsocket/removed(var/mob/living/carbon/human/target)
	if(all_languages[LANGUAGE_VAURCA] in target.languages)
		target.remove_language(LANGUAGE_VAURCA)
		target << "<span class='warning'>Your mind suddenly grows dark as the unity of the Hive is torn from you.</span>"
	..()

/obj/item/organ/vaurca/filtrationbit
	name = "filtration bit"
	organ_tag = "filtration bit"
	parent_organ = "head"
	icon = 'icons/mob/alien.dmi'
	icon_state = "filter"
	robotic = 2

/obj/item/organ/vaurca/preserve
	name = "phoron reserve tank"
	organ_tag = "phoron reserve tank"
	parent_organ = "chest"
	icon = 'icons/mob/alien.dmi'
	icon_state = "breathing_app"
	robotic = 1
	var/datum/gas_mixture/air_contents = null
	var/distribute_pressure = ((2*ONE_ATMOSPHERE)*O2STANDARD)
	var/volume = 50
	var/manipulated_by = null

/obj/item/organ/vaurca/preserve/Initialize()
	. = ..()

	air_contents = new /datum/gas_mixture()
	air_contents.adjust_gas("phoron", (ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
	air_contents.volume = volume //liters
	air_contents.temperature = T20C
	distribute_pressure = ((pick(2.4,2.8,3.2,3.6)*ONE_ATMOSPHERE)*O2STANDARD)

	START_PROCESSING(SSprocessing, src)
	var/mob/living/carbon/location = loc

	location.internal = src
	usr << "<span class='notice'>You open \the [src] valve.</span>"
	if (location.internals)
		location.internals.icon_state = "internal1"

	return

/obj/item/organ/vaurca/preserve/Destroy()
	if(air_contents)
		qdel(air_contents)

	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/organ/vaurca/preserve/examine(mob/user)
	. = ..(user, 0)
	if(.)
		var/celsius_temperature = air_contents.temperature - T0C
		var/descriptive
		switch(celsius_temperature)
			if(300 to INFINITY)
				descriptive = "furiously hot"
			if(100 to 300)
				descriptive = "hot"
			if(80 to 100)
				descriptive = "warm"
			if(40 to 80)
				descriptive = "lukewarm"
			if(20 to 40)
				descriptive = "room temperature"
			else
				descriptive = "cold"
		user << "<span class='notice'>\The [src] feels [descriptive].</span>"

/obj/item/organ/vaurca/preserve/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	var/obj/icon = src

	if ((istype(W, /obj/item/device/analyzer)) && get_dist(user, src) <= 1)
		for (var/mob/O in viewers(user, null))
			O << "<span class='warning'>[user] has used [W] on \icon[icon] [src]</span>"

		var/pressure = air_contents.return_pressure()
		manipulated_by = user.real_name			//This person is aware of the contents of the tank.
		var/total_moles = air_contents.total_moles

		user << "<span class='notice'>Results of analysis of \icon[icon]</span>"
		if (total_moles>0)
			user << "<span class='notice'>Pressure: [round(pressure,0.1)] kPa</span>"
			for(var/g in air_contents.gas)
				user << "<span class='notice'>[gas_data.name[g]]: [(round(air_contents.gas[g] / total_moles) * 100)]%</span>"
			user << "<span class='notice'>Temperature: [round(air_contents.temperature-T0C)]&deg;C</span>"
		else
			user << "<span class='notice'>Tank is empty!</span>"
		src.add_fingerprint(user)
	else if (istype(W,/obj/item/latexballon))
		var/obj/item/latexballon/LB = W
		LB.blow(src)
		src.add_fingerprint(user)

/obj/item/organ/vaurca/preserve/attack_self(mob/user as mob)
	if (!(src.air_contents))
		return

	ui_interact(user)

/obj/item/organ/vaurca/preserve/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/mob/living/carbon/location = null

	var/using_internal
	if(istype(location))
		if(location.internal==src)
			using_internal = 1

	// this is the data which will be sent to the ui
	var/data[0]
	data["tankPressure"] = round(air_contents.return_pressure() ? air_contents.return_pressure() : 0)
	data["releasePressure"] = round(distribute_pressure ? distribute_pressure : 0)
	data["defaultReleasePressure"] = round(TANK_DEFAULT_RELEASE_PRESSURE)
	data["maxReleasePressure"] = round(TANK_MAX_RELEASE_PRESSURE)
	data["valveOpen"] = using_internal ? 1 : 0

	data["maskConnected"] = 0

	if(istype(location))
		var/mask_check = 0

		if(location.internal == src)	// if tank is current internal
			mask_check = 1
		else if(src in location)		// or if tank is in the mobs possession
			if(!location.internal)		// and they do not have any active internals
				mask_check = 1
		else if(istype(src.loc, /obj/item/weapon/rig) && src.loc in location)	// or the rig is in the mobs possession
			if(!location.internal)		// and they do not have any active internals
				mask_check = 1

		if(mask_check)
			if(location.wear_mask && (location.wear_mask.flags & AIRTIGHT))
				data["maskConnected"] = 1
			else if(istype(location, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = location
				if(H.head && (H.head.flags & AIRTIGHT))
					data["maskConnected"] = 1

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "tanks.tmpl", "Tank", 500, 300)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/item/organ/vaurca/preserve/Topic(href, href_list)
	..()
	if (usr.stat|| usr.restrained())
		return 0
	if (src.loc != usr)
		return 0

	if (href_list["dist_p"])
		if (href_list["dist_p"] == "reset")
			src.distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
		else if (href_list["dist_p"] == "max")
			src.distribute_pressure = TANK_MAX_RELEASE_PRESSURE
		else
			var/cp = text2num(href_list["dist_p"])
			src.distribute_pressure += cp
		src.distribute_pressure = min(max(round(src.distribute_pressure), 0), TANK_MAX_RELEASE_PRESSURE)
	if (href_list["stat"])
		if(istype(loc,/mob/living/carbon))
			var/mob/living/carbon/location = loc
			if(location.internal == src)
				location.internal = null
				location.internals.icon_state = "internal0"
				usr << "<span class='notice'>You close the tank release valve.</span>"
				if (location.internals)
					location.internals.icon_state = "internal0"
			else

				var/can_open_valve
				if(location.wear_mask && (location.wear_mask.flags & AIRTIGHT))
					can_open_valve = 1
				else if(istype(location,/mob/living/carbon/human))
					var/mob/living/carbon/human/H = location
					if(H.head && (H.head.flags & AIRTIGHT))
						can_open_valve = 1

				if(can_open_valve)
					location.internal = src
					usr << "<span class='notice'>You open \the [src] valve.</span>"
					if (location.internals)
						location.internals.icon_state = "internal1"
				else
					usr << "<span class='notice'>You need something to connect to \the [src].</span>"

	src.add_fingerprint(usr)
	return 1


/obj/item/organ/vaurca/preserve/remove_air(amount)
	return air_contents.remove(amount)

/obj/item/organ/vaurca/preserve/return_air()
	return air_contents

/obj/item/organ/vaurca/preserve/assume_air(datum/gas_mixture/giver)
	air_contents.merge(giver)

	check_status()
	return 1

/obj/item/organ/vaurca/preserve/proc/remove_air_volume(volume_to_return)
	if(!air_contents)
		return null

	var/tank_pressure = air_contents.return_pressure()
	if((tank_pressure < distribute_pressure) && prob(5))
		owner << "<span class='warning'>There is a buzzing in your [parent_organ].</span>"

	var/moles_needed = distribute_pressure*volume_to_return/(R_IDEAL_GAS_EQUATION*air_contents.temperature)

	return remove_air(moles_needed)

/obj/item/organ/vaurca/preserve/process()
	//Allow for reactions
	air_contents.react() //cooking up air tanks - add phoron and oxygen, then heat above PHORON_MINIMUM_BURN_TEMPERATURE
	check_status()
	..()


/obj/item/organ/vaurca/preserve/proc/check_status()
	//Handle exploding, leaking, and rupturing of the tank

	if(!air_contents)
		return 0

	var/pressure = air_contents.return_pressure()
	if(pressure > TANK_FRAGMENT_PRESSURE)
		if(!istype(src.loc,/obj/item/device/transfer_valve))
			message_admins("Explosive tank rupture! last key to touch the tank was [src.fingerprintslast].")
			log_game("Explosive tank rupture! last key to touch the tank was [src.fingerprintslast].")

		//Give the gas a chance to build up more pressure through reacting
		air_contents.react()
		air_contents.react()
		air_contents.react()

		pressure = air_contents.return_pressure()
		var/range = (pressure-TANK_FRAGMENT_PRESSURE)/TANK_FRAGMENT_SCALE

		explosion(
			get_turf(loc),
			round(min(BOMBCAP_DVSTN_RADIUS, range*0.25)),
			round(min(BOMBCAP_HEAVY_RADIUS, range*0.50)),
			round(min(BOMBCAP_LIGHT_RADIUS, range*1.00)),
			round(min(BOMBCAP_FLASH_RADIUS, range*1.50))
			)
		qdel(src)

	else if(pressure > (8.0*ONE_ATMOSPHERE))

		if(damage >= 60)
			var/turf/simulated/T = get_turf(src)
			if(!T)
				return
			T.assume_air(air_contents)
			playsound(src.loc, 'sound/effects/spray.ogg', 10, 1, -3)
			qdel(src)

	else if(pressure > (5.0*ONE_ATMOSPHERE))

		if(damage >= 45)
			var/turf/simulated/T = get_turf(src)
			if(!T)
				return
			var/datum/gas_mixture/leaked_gas = air_contents.remove_ratio(0.25)
			T.assume_air(leaked_gas)
