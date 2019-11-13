/obj/item/organ/heart/left
	name = "heart"
	icon_state = "vaurca_heart_l-on"
	organ_tag = "left heart"
	parent_organ = "chest"
	dead_icon = "vaurca_heart_l-off"

/obj/item/organ/heart/right
	name = "heart"
	icon_state = "vaurca_heart_r-on"
	organ_tag = "right heart"
	parent_organ = "chest"
	dead_icon = "vaurca_heart_r-off"

/obj/item/organ/lungs/vaurca
	icon_state = "lungs_vaurca"

/obj/item/organ/kidneys/vaurca
	icon_state = "kidney_vaurca"

/obj/item/organ/eyes/vaurca
	icon_state = "eyes_vaurca"

/obj/item/organ/eyes/vaurca/flash_act()
	if(!owner)
		return

	to_chat(owner, "<span class='warning'>Your eyes burn with the intense light of the flash!</span>")
	owner.Weaken(10)
	take_damage(rand(10, 11))

	if(damage > 12)
		owner.eye_blurry += rand(3,6)

	if(damage >= min_broken_damage)
		owner.sdisabilities |= BLIND

	else if(damage >= min_bruised_damage)
		owner.eye_blind = 5
		owner.eye_blurry = 5
		owner.disabilities |= NEARSIGHTED
		addtimer(CALLBACK(owner, /mob/.proc/reset_nearsighted), 100)

/obj/item/organ/kidneys/vaurca/robo
	icon_state = "kidney_vaurca"
	organ_tag = "mechanical kidneys"
	robotic = 2
	robotic_name = null
	robotic_sprite = null

/obj/item/organ/liver/vaurca/robo
	icon_state = "liver_vaurca"
	organ_tag = "mechanical liver"
	robotic = 2
	robotic_name = null
	robotic_sprite = null
	tolerance = 20

/obj/item/organ/liver/vaurca
	icon_state = "liver_vaurca"
	tolerance = 20

/obj/item/organ/brain/vaurca
	icon_state = "brain_vaurca"

/obj/item/organ/vaurca/reservoir
	name = "phoron reservoir"
	organ_tag = "phoron reservoir"
	parent_organ = "chest"
	icon_state = "phoron_reservoir"
	robotic = 1

/obj/item/organ/vaurca/filtrationbit
	name = "filtration bit"
	organ_tag = "filtration bit"
	parent_organ = "head"
	icon_state = "filter"
	robotic = 2

/obj/item/organ/vaurca/neuralsocket
	name = "neural socket"
	organ_tag = "neural socket"
	icon_state = "neural_socket"
	parent_organ = "head"
	robotic = 2

obj/item/organ/vaurca/neuralsocket/process()
	if (is_broken())
		if (all_languages[LANGUAGE_VAURCA] in owner.languages)
			owner.remove_language(LANGUAGE_VAURCA)
			to_chat(owner, "<span class='warning'>Your mind suddenly grows dark as the unity of the Hive is torn from you.</span>")
	else
		if (!(all_languages[LANGUAGE_VAURCA] in owner.languages))
			owner.add_language(LANGUAGE_VAURCA)
			to_chat(owner, "<span class='notice'> Your mind expands, and your thoughts join the unity of the Hivenet.</span>")
	..()

/obj/item/organ/vaurca/neuralsocket/replaced(var/mob/living/carbon/human/target)
	if (!(all_languages[LANGUAGE_VAURCA] in owner.languages))
		owner.add_language(LANGUAGE_VAURCA)
		to_chat(owner, "<span class='notice'> Your mind expands, and your thoughts join the unity of the Hivenet.</span>")
	..()

/obj/item/organ/vaurca/neuralsocket/removed(var/mob/living/carbon/human/target)
	if(all_languages[LANGUAGE_VAURCA] in target.languages)
		target.remove_language(LANGUAGE_VAURCA)
		to_chat(target, "<span class='warning'>Your mind suddenly grows dark as the unity of the Hive is torn from you.</span>")
	..()

/obj/item/organ/vaurca/preserve
	name = "phoron reserve tank"
	organ_tag = "phoron reserve tank"
	parent_organ = "chest"
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

	var/mob/living/carbon/location = loc

	location.internal = src
	if (location.internals)
		location.internals.icon_state = "internal1"

	return

/obj/item/organ/vaurca/preserve/Destroy()
	if(air_contents)
		QDEL_NULL(air_contents)

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
		to_chat(user, "<span class='notice'>\The [src] feels [descriptive].</span>")

/obj/item/organ/vaurca/preserve/attackby(obj/item/W as obj, mob/user as mob)
	..()
	var/obj/icon = src

	if ((istype(W, /obj/item/device/analyzer)) && get_dist(user, src) <= 1)
		user.visible_message("<span class='warning'>[user] has used [W] on \icon[icon] [src]</span>")

		var/pressure = air_contents.return_pressure()
		manipulated_by = user.real_name			//This person is aware of the contents of the tank.
		var/total_moles = air_contents.total_moles

		to_chat(user, "<span class='notice'>Results of analysis of \icon[icon]</span>")
		if (total_moles>0)
			to_chat(user, "<span class='notice'>Pressure: [round(pressure,0.1)] kPa</span>")
			for(var/g in air_contents.gas)
				to_chat(user, "<span class='notice'>[gas_data.name[g]]: [(round(air_contents.gas[g] / total_moles) * 100)]%</span>")
			to_chat(user, "<span class='notice'>Temperature: [round(air_contents.temperature-T0C)]&deg;C</span>")
		else
			to_chat(user, "<span class='notice'>Tank is empty!</span>")
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
		else if(istype(src.loc, /obj/item/rig) && src.loc in location)	// or the rig is in the mobs possession
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
				to_chat(usr, "<span class='notice'>You close the tank release valve.</span>")
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
					to_chat(usr, "<span class='notice'>You open \the [src] valve.</span>")
					if (location.internals)
						location.internals.icon_state = "internal1"
				else
					to_chat(usr, "<span class='notice'>You need something to connect to \the [src].</span>")

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
		to_chat(owner, "<span class='warning'>There is a buzzing in your [parent_organ].</span>")

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

		if(is_broken())
			var/turf/simulated/T = get_turf(src)
			if(!T)
				return
			T.assume_air(air_contents)
			playsound(src.loc, 'sound/effects/spray.ogg', 10, 1, -3)
			qdel(src)

	else if(pressure > (5.0*ONE_ATMOSPHERE))

		if(is_bruised())
			var/turf/simulated/T = get_turf(src)
			if(!T)
				return
			var/datum/gas_mixture/leaked_gas = air_contents.remove_ratio(0.25)
			T.assume_air(leaked_gas)

/obj/item/organ/external/chest/vaurca
	cannot_break = TRUE

/obj/item/organ/external/groin/vaurca
	cannot_break = TRUE

/obj/item/organ/external/arm/vaurca
	cannot_break = TRUE

/obj/item/organ/external/arm/right/vaurca
	cannot_break = TRUE

/obj/item/organ/external/leg/vaurca
	cannot_break = TRUE

/obj/item/organ/external/leg/right/vaurca
	cannot_break = TRUE

/obj/item/organ/external/foot/vaurca
	cannot_break = TRUE

/obj/item/organ/external/foot/right/vaurca
	cannot_break = TRUE

/obj/item/organ/external/hand/vaurca
	cannot_break = TRUE

/obj/item/organ/external/hand/right/vaurca
	cannot_break = TRUE

/obj/item/organ/external/head/vaurca
	cannot_break = TRUE