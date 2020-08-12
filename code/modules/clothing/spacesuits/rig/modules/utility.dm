/* Contains:
 * /obj/item/rig_module/device
 * /obj/item/rig_module/device/healthscanner
 * /obj/item/rig_module/device/drill
 * /obj/item/rig_module/device/orescanner
 * /obj/item/rig_module/device/rfd_c
 * /obj/item/rig_module/device/anomaly_scanner
 * /obj/item/rig_module/maneuvering_jets
 * /obj/item/rig_module/foam_sprayer
 * /obj/item/rig_module/device/broadcaster
 * /obj/item/rig_module/chem_dispenser
 * /obj/item/rig_module/chem_dispenser/injector
 * /obj/item/rig_module/chem_dispenser/injector/paramedic
 * /obj/item/rig_module/voice
 * /obj/item/rig_module/device/paperdispenser
 * /obj/item/rig_module/device/pen
 * /obj/item/rig_module/device/stamp
 * /obj/item/rig_module/actuators
 * /obj/item/rig_module/actuators/combat
 */

/obj/item/rig_module/device
	name = "mounted device"
	desc = "Some kind of hardsuit mount."
	usable = FALSE
	selectable = 1
	toggleable = FALSE
	disruptive = FALSE

	var/device_type
	var/obj/item/device

/obj/item/rig_module/device/healthscanner
	name = "health scanner module"
	desc = "A hardsuit-mounted health scanner."
	icon_state = "scanner"
	interface_name = "health scanner"
	interface_desc = "Shows an informative health readout when used on a subject."
	construction_cost = list("$glass" = 5250, DEFAULT_WALL_MATERIAL = 2500)
	construction_time = 300

	device_type = /obj/item/device/healthanalyzer

	category = MODULE_MEDICAL

/obj/item/rig_module/device/healthscanner/vitalscanner
	name = "integrated vitals tracker"
	desc = "A hardsuit-mounted vitals tracker."
	interface_name = "vitals tracker"
	interface_desc = "Shows an informative health readout of the user."

	usable = TRUE
	selectable = 0

	category = MODULE_GENERAL


/obj/item/rig_module/device/drill
	name = "hardsuit diamond drill mount"
	desc = "A very heavy diamond-tipped drill."
	icon_state = "drill"
	interface_name = "mounted drill"
	interface_desc = "A diamond-tipped industrial drill."
	suit_overlay_active = "mounted-drill"
	suit_overlay_inactive = "mounted-drill"
	use_power_cost = 0.1
	construction_cost = list(DEFAULT_WALL_MATERIAL = 55000, MATERIAL_GLASS = 2250, MATERIAL_SILVER = 5250, MATERIAL_DIAMOND = 3750)
	construction_time = 350

	device_type = /obj/item/pickaxe/diamonddrill

	category = MODULE_UTILITY

/obj/item/rig_module/device/basicdrill
	name = "hardsuit drill mount"
	desc = "A very heavy basic drill."
	icon_state = "drill"
	interface_name = "mounted drill"
	interface_desc = "A basic industrial drill."
	suit_overlay_active = "mounted-drill"
	suit_overlay_inactive = "mounted-drill"
	use_power_cost = 0.1

	device_type = /obj/item/pickaxe/drill

	category = MODULE_UTILITY

/obj/item/rig_module/device/anomaly_scanner
	name = "hardsuit anomaly scanner"
	desc = "You think it's called an Elder Sarsparilla or something."
	icon_state = "eldersasparilla"
	interface_name = "Alden-Saraspova counter"
	interface_desc = "An exotic particle detector commonly used by xenoarchaeologists."
	engage_string = "Begin Scan"
	usable = TRUE
	selectable = 0
	device_type = /obj/item/device/ano_scanner

	category = MODULE_UTILITY

/obj/item/rig_module/device/orescanner
	name = "ore scanner module"
	desc = "A clunky old ore scanner."
	icon_state = "scanner"
	interface_name = "ore detector"
	interface_desc = "A sonar system for detecting large masses of ore."
	engage_string = "Begin Scan"
	usable = TRUE
	selectable = 0
	device_type = /obj/item/mining_scanner

	category = MODULE_UTILITY

/obj/item/rig_module/device/rfd_c
	name = "RFD-C mount"
	desc = "A cell-powered rapid construction device for a hardsuit."
	icon_state = "rcd"
	interface_name = "mounted RFD-C"
	interface_desc = "A device for building or removing walls. Cell-powered."
	usable = TRUE
	engage_string = "Configure RFD-C"
	construction_cost = list(DEFAULT_WALL_MATERIAL = 30000, MATERIAL_PHORON = 12500, MATERIAL_SILVER = 10000, MATERIAL_GOLD = 10000)
	construction_time = 1000

	device_type = /obj/item/rfd/construction/mounted

	category = MODULE_UTILITY

/obj/item/rig_module/device/Initialize()
	. = ..()
	if(device_type)
		device = new device_type(src)

/obj/item/rig_module/device/engage(atom/target, mob/user)
	if(!..() || !device)
		return FALSE

	if(!target)
		device.attack_self(user)
		return TRUE

	var/turf/T = get_turf(target)
	if(istype(T) && !T.Adjacent(get_turf(src)))
		return FALSE

	// Stop generating infinite devices please, and thank you.
	if(istype(target, /obj/machinery/disposal))
		return FALSE

	var/resolved = target.attackby(device, user)
	if(!resolved && device && target)
		device.afterattack(target, user, TRUE)
	return TRUE

/obj/item/rig_module/chem_dispenser
	name = "mounted chemical dispenser"
	desc = "A complex web of tubing and needles suitable for hardsuit use."
	icon_state = "injector"
	usable = TRUE
	selectable = FALSE
	toggleable = FALSE
	disruptive = FALSE
	confined_use = TRUE
	construction_cost = list(DEFAULT_WALL_MATERIAL=10000, MATERIAL_GLASS =9250, MATERIAL_GOLD =2500, MATERIAL_SILVER =4250,"phoron"=5500)
	construction_time = 400

	engage_string = "Inject"

	interface_name = "integrated chemical dispenser"
	interface_desc = "Dispenses loaded chemicals directly into the wearer's bloodstream."

	charges = list(
		list("tricordrazine",	"tricordrazine",	/datum/reagent/tricordrazine,		80),
		list("mortaphenyl",		"mortaphenyl",		/datum/reagent/mortaphenyl,			80),
		list("dexalin plus",	"dexalinp",			/datum/reagent/dexalin/plus,		80),
		list("antibiotics",		"thetamycin",		/datum/reagent/thetamycin,			80),
		list("antitoxins",		"dylovene",			/datum/reagent/dylovene,			80),
		list("nutrients",		"glucose",			/datum/reagent/nutriment/glucose,	80),
		list("saline",			"saline",			/datum/reagent/saline,				80),
		list("hyronalin",		"hyronalin",		/datum/reagent/hyronalin,			80),
		list("radium",			"radium",			/datum/reagent/radium,				80)
		)

	var/max_reagent_volume = 80 //Used when refilling.

	category = MODULE_HEAVY_COMBAT

/obj/item/rig_module/chem_dispenser/ninja
	interface_desc = "Dispenses loaded chemicals directly into the wearer's bloodstream. This variant is made to be extremely light and flexible."

	//just over a syringe worth of each. Want more? Go refill. Gives the ninja another reason to have to show their face.
	charges = list(
		list("tricordrazine",	"tricordrazine",	/datum/reagent/tricordrazine,		20),
		list("mortaphenyl",		"mortaphenyl",		/datum/reagent/mortaphenyl,			20),
		list("dexalin plus",	"dexalinp",			/datum/reagent/dexalin/plus,		20),
		list("antibiotics",		"thetamycin",		/datum/reagent/thetamycin,			20),
		list("antitoxins",		"dylovene",			/datum/reagent/dylovene,			20),
		list("nutrients",		"glucose",			/datum/reagent/nutriment/glucose,	80),
		list("saline",			"saline",			/datum/reagent/saline,				80),
		list("hyronalin",		"hyronalin",		/datum/reagent/hyronalin,			20),
		list("radium",			"radium",			/datum/reagent/radium,				20)
		)

	category = MODULE_UTILITY

/obj/item/rig_module/chem_dispenser/accepts_item(var/obj/item/input_item, var/mob/living/user)
	if(!input_item.is_open_container())
		return FALSE

	if(!input_item.reagents || !input_item.reagents.total_volume)
		to_chat(user, SPAN_WARNING("\The [input_item] is empty."))
		return FALSE

	// Magical chemical filtration system, do not question it.
	var/total_transferred = 0
	for(var/datum/reagent/R in input_item.reagents.reagent_list)
		for(var/chargetype in charges)
			var/datum/rig_charge/charge = charges[chargetype]
			if(charge.product_type == R.type)

				var/chems_to_transfer = R.volume

				if((charge.charges + chems_to_transfer) > max_reagent_volume)
					chems_to_transfer = max_reagent_volume - charge.charges

				charge.charges += chems_to_transfer
				input_item.reagents.remove_reagent(R.type, chems_to_transfer)
				total_transferred += chems_to_transfer

				break

	if(total_transferred)
		to_chat(user, SPAN_NOTICE("You transfer [total_transferred] units into the suit reservoir."))
	else
		to_chat(user, SPAN_WARNING("None of the reagents seem suitable."))
	return TRUE

/obj/item/rig_module/chem_dispenser/engage(atom/target, mob/user)
	if(!..())
		return FALSE

	var/mob/living/carbon/human/H = holder.wearer

	if(!charge_selected)
		to_chat(user, SPAN_WARNING("You have not selected a chemical type."))
		return FALSE

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return FALSE

	var/chems_to_use = 10
	if(charge.charges <= 0)
		to_chat(user, SPAN_WARNING("Insufficient chems!"))
		return FALSE
	else if(charge.charges < chems_to_use)
		chems_to_use = charge.charges

	var/mob/living/carbon/target_mob
	if(target)
		if(istype(target,/mob/living/carbon))
			target_mob = target
		else
			return FALSE
	else
		target_mob = H

	if(!H.Adjacent(target_mob))
		to_chat(user, SPAN_WARNING("You are not close enough to inject them!"))
		return FALSE

	if(target_mob != user)
		to_chat(user, SPAN_NOTICE("You inject [target_mob] with [chems_to_use] unit\s of [charge.display_name]."))

	if(!target_mob.is_physically_disabled())
		to_chat(target_mob, SPAN_NOTICE("<b>You feel a rushing in your veins as [chems_to_use] unit\s of [charge.display_name] [chems_to_use == 1 ? "is" : "are"] injected.</b>"))
	target_mob.reagents.add_reagent(charge.product_type, chems_to_use)

	charge.charges -= chems_to_use
	if(charge.charges < 0)
		charge.charges = 0

	return TRUE

/obj/item/rig_module/chem_dispenser/combat
	name = "combat chemical injector"
	desc = "A complex web of tubing and needles suitable for hardsuit use."

	charges = list(
		list("synaptizine",		"synaptizine",		/datum/reagent/synaptizine,			30),
		list("hyperzine",		"hyperzine",		/datum/reagent/hyperzine,			30),
		list("oxycomorphine",	"oxycomorphine",	/datum/reagent/oxycomorphine,		30),
		list("nutrients",		"glucose",			/datum/reagent/nutriment/glucose,	80),
		list("saline",			"saline",			/datum/reagent/saline,				80)
		)

	interface_name = "combat chem dispenser"
	interface_desc = "Dispenses loaded chemicals directly into the bloodstream."

	category = MODULE_LIGHT_COMBAT

/obj/item/rig_module/chem_dispenser/vaurca
	name = "vaurca combat chemical injector"
	desc = "A complex web of tubing and needles suitable for vaurcan hardsuit use."

	charges = list(
		list("synaptizine",		"synaptizine",		/datum/reagent/synaptizine,		30),
		list("hyperzine",		"hyperzine",		/datum/reagent/hyperzine,		30),
		list("oxycomorphine",	"oxycomorphine",	/datum/reagent/oxycomorphine,	30),
		list("phoron",			"phoron",			/datum/reagent/toxin/phoron,	60),
		list("kois",			"k'ois paste",		/datum/reagent/kois,			80),
		list("saline",			"saline",			/datum/reagent/saline,			80)
		)

	interface_name = "vaurca combat chem dispenser"
	interface_desc = "Dispenses loaded chemicals directly into the bloodstream."

	category = MODULE_VAURCA

/obj/item/rig_module/chem_dispenser/offworlder
	name = "chemical injector"
	desc = "A complex web of tubing and needles suitable for hardsuit use."

	charges = list(
		list("dexalin",			"dexalin",		/datum/reagent/dexalin,			5),
		list("inaprovaline",	"inaprovaline",	/datum/reagent/inaprovaline,	5)
		)

	interface_name = "chem dispenser"
	interface_desc = "Dispenses loaded chemicals directly into the bloodstream."

	category = MODULE_GENERAL

/obj/item/rig_module/chem_dispenser/injector
	name = "mounted chemical injector"
	desc = "A complex web of tubing and a large needle suitable for hardsuit use."
	usable = FALSE
	selectable = 1
	disruptive = 1
	construction_cost = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_GLASS = 9250, MATERIAL_GOLD = 2500, MATERIAL_SILVER = 4250, MATERIAL_PHORON = 5500)
	construction_time = 400

	interface_name = "mounted chem injector"
	interface_desc = "Dispenses loaded chemicals via an arm-mounted injector."

	category = MODULE_MEDICAL

/obj/item/rig_module/chem_dispenser/injector/paramedic //downgraded version
	charges = list(
		list("tricordrazine",	"tricordrazine",	/datum/reagent/tricordrazine,	40),
		list("mortaphenyl",		"mortaphenyl",		/datum/reagent/mortaphenyl,		40),
		list("dexalin",			"dexalin",			/datum/reagent/dexalin,			40),
		list("inaprovaline",	"inaprovaline",		/datum/reagent/inaprovaline,	40)
		)

/obj/item/rig_module/voice
	name = "hardsuit voice synthesiser"
	desc = "A speaker box and sound processor."
	icon_state = "megaphone"
	usable = TRUE
	selectable = 0
	toggleable = FALSE
	disruptive = FALSE
	confined_use = TRUE

	engage_string = "Configure Synthesiser"

	interface_name = "voice synthesiser"
	interface_desc = "A flexible and powerful voice modulator system."

	var/obj/item/voice_changer/voice_holder

	category = MODULE_SPECIAL

/obj/item/rig_module/voice/New()
	..()
	voice_holder = new(src)
	voice_holder.active = 0

/obj/item/rig_module/voice/installed()
	..()
	holder.speech = src

/obj/item/rig_module/voice/engage(atom/target, mob/user)
	if(!..())
		return FALSE

	var/choice= input("Would you like to toggle the synthesiser, set the name or set an accent?") as null|anything in list("Enable","Disable","Set Name", "Set Accent")

	if(!choice)
		return FALSE

	switch(choice)
		if("Enable")
			active = TRUE
			voice_holder.active = TRUE
			message_user(user, SPAN_NOTICE("You enable the speech synthesiser."), SPAN_NOTICE("\The [user] enables the speech synthesiser."))
		if("Disable")
			active = FALSE
			voice_holder.active = FALSE
			message_user(user, SPAN_NOTICE("You disable the speech synthesiser."), SPAN_NOTICE("\The [user] disables the speech synthesiser."))
		if("Set Name")
			var/raw_choice = sanitize(input(user, "Please enter a new name.") as text|null, MAX_NAME_LEN)
			if(!raw_choice)
				return FALSE
			voice_holder.voice = raw_choice
			message_user(user, SPAN_NOTICE("You set the synthesizer to mimic <b>[voice_holder.voice]</b>."), SPAN_NOTICE("\The [user] set the speech synthesizer to mimic <b>[voice_holder.voice]</b>."))
		if("Set Accent")
			var/raw_choice = input(user, "Please choose an accent to mimick.") as null|anything in SSrecords.accents
			if(!raw_choice)
				return FALSE
			voice_holder.current_accent = raw_choice
			message_user(user, SPAN_NOTICE("You set the synthesizer to mimic the [raw_choice] accent."), SPAN_NOTICE("\The [user] set the speech synthesizer the [raw_choice] accent."))
	return TRUE

/obj/item/rig_module/maneuvering_jets
	name = "hardsuit maneuvering jets"
	desc = "A compact gas thruster system for a hardsuit."
	icon_state = "thrusters"
	usable = TRUE
	toggleable = TRUE
	selectable = 0
	disruptive = FALSE
	construction_cost = list(DEFAULT_WALL_MATERIAL = 15000, MATERIAL_GLASS = 4250, MATERIAL_SILVER = 4250, MATERIAL_URANIUM = 5250)
	construction_time = 300

	suit_overlay_active = "maneuvering_active"
	suit_overlay_inactive = null //"maneuvering_inactive"

	engage_string = "Toggle Stabilizers"
	activate_string = "Activate Thrusters"
	deactivate_string = "Deactivate Thrusters"

	interface_name = "maneuvering jets"
	interface_desc = "An inbuilt EVA maneuvering system that runs off the hardsuit air supply."

	var/obj/item/tank/jetpack/rig/jets

	category = MODULE_GENERAL

/obj/item/rig_module/maneuvering_jets/engage(atom/target, mob/user)
	if(!..())
		return FALSE
	var/list/extra_mobs = list()
	if(user != holder.wearer)
		extra_mobs += holder.wearer
	jets.toggle_rockets_stabilization(user, extra_mobs)
	return TRUE

/obj/item/rig_module/maneuvering_jets/activate(mob/user)
	if(active)
		return FALSE

	active = TRUE

	spawn(1)
		if(suit_overlay_active)
			suit_overlay = suit_overlay_active
		else
			suit_overlay = null
		holder.update_icon()

	if(!jets.on)
		var/list/extra_mobs = list()
		if(user != holder.wearer)
			extra_mobs += holder.wearer
		jets.toggle_jetpack(user, extra_mobs)
	return TRUE

/obj/item/rig_module/maneuvering_jets/deactivate(mob/user)
	if(!..())
		return FALSE
	if(jets.on)
		var/list/extra_mobs = list()
		if(user != holder.wearer)
			extra_mobs += holder.wearer
		jets.toggle_jetpack(user, extra_mobs)
	return TRUE

/obj/item/rig_module/maneuvering_jets/New()
	..()
	jets = new(src)

/obj/item/rig_module/maneuvering_jets/installed()
	..()
	jets.holder = holder
	jets.ion_trail.bind(holder)

/obj/item/rig_module/maneuvering_jets/removed()
	..()
	jets.holder = null
	jets.ion_trail.bind(jets)

/obj/item/rig_module/foam_sprayer

/obj/item/rig_module/device/paperdispenser
	name = "hardsuit paper dispenser"
	desc = "Crisp sheets."
	icon_state = "paper"
	interface_name = "paper dispenser"
	interface_desc = "Dispenses warm, clean, and crisp sheets of paper."
	engage_string = "Dispense"
	usable = TRUE
	selectable = 0
	device_type = /obj/item/paper_bin

	category = MODULE_GENERAL

/obj/item/rig_module/device/paperdispenser/engage(atom/target, mob/user)
	if(!..() || !device)
		return FALSE

	if(!target)
		device.attack_hand(user)
		return TRUE

/obj/item/rig_module/device/pen
	name = "mounted pen"
	desc = "For mecha John Hancocks."
	icon_state = "pen"
	interface_name = "mounted pen"
	interface_desc = "Signatures with style(tm)."
	engage_string = "Change color"
	usable = TRUE
	device_type = /obj/item/pen/multi

	category = MODULE_GENERAL

/obj/item/rig_module/device/stamp
	name = "mounted internal affairs stamp"
	desc = "DENIED."
	icon_state = "stamp"
	interface_name = "mounted stamp"
	interface_desc = "Leave your mark."
	engage_string = "Toggle stamp type"
	usable = TRUE
	var/iastamp
	var/deniedstamp

	category = MODULE_GENERAL

/obj/item/rig_module/device/stamp/New()
	..()
	iastamp = new /obj/item/stamp/internalaffairs(src)
	deniedstamp = new /obj/item/stamp/denied(src)
	device = iastamp

/obj/item/rig_module/device/stamp/engage(atom/target, mob/user)
	if(!..() || !device)
		return FALSE

	if(!target)
		if(device == iastamp)
			device = deniedstamp
			message_user(user, SPAN_NOTICE("You set \the [src] to the denied stamp."), SPAN_NOTICE("\The [user] set \the [src] to the denied stamp."))
		else if(device == deniedstamp)
			device = iastamp
			message_user(user, SPAN_NOTICE("You set \the [src] to the internal affairs stamp."), SPAN_NOTICE("\The [user] set \the [src] to the internal affairs stamp."))
		return TRUE

/obj/item/rig_module/device/decompiler
	name = "mounted matter decompiler"
	desc = "A drone matter decompiler reconfigured for hardsuit use."
	icon_state = "ewar"
	interface_name = "mounted matter decompiler"
	interface_desc = "Eats trash like no one's business."

	device_type = /obj/item/matter_decompiler

	category = MODULE_GENERAL

/obj/item/rig_module/actuators
	name = "leg actuators"
	desc = "A set of electromechanical actuators, for safe traversal of multilevelled areas."
	icon_state = "actuators"
	interface_name = "leg actuators"
	interface_desc = "Allows you to fall from heights and to jump up onto ledges."

	construction_cost = list(DEFAULT_WALL_MATERIAL=15000, MATERIAL_GLASS = 1250, MATERIAL_SILVER =5250)
	construction_time = 300

	disruptive = FALSE

	use_power_cost = 5
	module_cooldown = 25

	/*
	 * TOGGLE - dampens fall, on or off.
	 * SELECTABLE - Jump forward or up!
	 */
	toggleable = TRUE
	selectable = TRUE
	usable = FALSE

	engage_string = "Toggle Leg Actuators"
	activate_string = "Enable Leg Actuators"
	deactivate_string = "Disable Leg Actuators"

	var/combatType = 0		// Determines whether or not the actuators can do special combat oriented tasks.
							// Such as leaping faster, or grappling targets.
	var/leapDistance = 4	// Determines how far the actuators allow you to leap (radius, inclusive).

	category = MODULE_GENERAL

/obj/item/rig_module/actuators/combat
	name = "military grade leg actuators"
	desc = "A set of high-powered hydraulic actuators, for improved traversal of multilevelled areas."
	interface_name = "combat leg actuators"

	combatType = 1
	leapDistance = 7

	use_power_cost = 10

	category = MODULE_LIGHT_COMBAT

/obj/item/rig_module/actuators/proc/is_valid_turf(var/turf/T)
	if(!T || istype(T, /turf/space) || T.density || T.contains_dense_objects())
		return null
	if(isopenturf(T))
		var/obj/structure/lattice/L = locate() in T
		if(L)
			return L.name
		var/turf/leapBelow = GetBelow(T)
		if(leapBelow.density)
			return leapBelow.name
		else if(T.contains_dense_objects())
			return "structure"
		else
			return null
	return T.name

/obj/item/rig_module/actuators/engage(atom/target, mob/user)
	if (!..())
		return FALSE

	// This is for when you toggle it on or off. Why do they both run the same
	// proc chain ...? :l
	if (!target)
		return TRUE

	var/mob/living/carbon/human/H = holder.wearer

	if (!isturf(H.loc))
		to_chat(user, SPAN_WARNING("You cannot leap out of your current location!"))
		return FALSE

	var/turf/T = get_turf(target)

	if (!T || T.density)
		to_chat(user, SPAN_WARNING("You cannot leap at solid walls!"))
		return FALSE

	// Saved, we need it more than 1 place.
	var/dist = max(get_dist(T, get_turf(H)), 0)

	if (dist)
		for (var/A in T)
			var/atom/aa = A
			if (combatType && ismob(aa))
				continue

			if (aa.density)
				to_chat(user, SPAN_WARNING("You cannot leap at a location with solid objects on it!"))
				return FALSE

	if (T.z != H.z || dist > leapDistance)
		to_chat(user, SPAN_WARNING("You cannot leap at such a distant object!"))
		return FALSE

	// Handle leaping at targets with a combat capable version here.
	if (combatType && dist && (ismob(target) || (locate(/mob/living) in T)))
		H.do_leap(target, leapDistance, FALSE)
		return TRUE

	// If dist -> horizontal leap. Otherwise, the user clicked the turf that they're
	// currently on. Which means they want to do a vertical leap upwards!
	if (dist)
		H.visible_message(SPAN_WARNING("\The [H] leaps horizontally at \the [T]!"),
			SPAN_WARNING("You leap horizontally at \the [T]!"),
			SPAN_WARNING("You hear an electric <i>whirr</i> followed by a weighty thump!"))
		H.face_atom(T)
		H.throw_at(T, leapDistance, 1, src, do_throw_animation = FALSE)
		return TRUE
	else
		var/turf/simulated/open/TA = GetAbove(src)
		if (!istype(TA))
			to_chat(user, SPAN_WARNING("There is a ceiling above you that stop you from leaping upwards!"))
			return FALSE

		for (var/atom/A in TA)
			if (!A.CanPass(src, TA, 1.5, 0))
				to_chat(user, SPAN_WARNING("\The [A] blocks you!"))
				return FALSE

		var/turf/leapEnd = get_step(TA, H.dir)
		var/valid_climbable = is_valid_turf(leapEnd)
		if(!valid_climbable)
			to_chat(user, SPAN_WARNING("There is no valid ledge to scale ahead of you!"))
			return

		H.visible_message(SPAN_NOTICE("\The [H] leaps up, out of view!"), SPAN_NOTICE("You leap up!"))

		// This setting is necessary even for combat type, to stop you from moving onto
		// the turf, falling back down, and then getting forcemoved to the final destination.
		TA.add_climber(H, CLIMBER_NO_EXIT)

		H.forceMove(TA)

		// Combat type actuators are better, they allow you to jump instantly onto
		// a ledge. Regular actuators make you have to climb the rest of the way.
		if (!combatType)
			H.visible_message(SPAN_NOTICE("\The [H] starts pulling \himself up onto the [valid_climbable]."), SPAN_NOTICE("You start pulling yourself up onto \the [valid_climbable]."))
			if (!do_after(H, 4 SECONDS, use_user_turf = TRUE))
				H.visible_message(SPAN_WARNING("\The [H] is interrupted and falls!"), SPAN_DANGER("You are interrupted and fall back down!"))

				// Climbers will auto-fall if they exit the turf. This is for in case
				// something else interrupts them.
				if (H.loc == TA)
					TA.remove_climber(H)
					ADD_FALLING_ATOM(H)

				return TRUE

			H.visible_message(SPAN_NOTICE("\The [H] finishes climbing onto \the [valid_climbable]."), SPAN_NOTICE("You finish climbing onto \the [valid_climbable]."))
		else
			H.visible_message(SPAN_WARNING("\The [H] lands on \the [valid_climbable] with a heavy slam!"), SPAN_WARNING("You land on \the [valid_climbable] with a heavy thud!"))

		// open/Exited() removes from climbers.
		H.forceMove(leapEnd)
		return TRUE


/obj/item/rig_module/cooling_unit
	name = "mounted cooling unit"
	toggleable = TRUE
	origin_tech = list(TECH_MAGNET = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	interface_name = "mounted cooling unit"
	interface_desc = "A heat sink with liquid cooled radiator."
	icon_state = "suitcooler"
	var/charge_consumption = 1
	var/max_cooling = 12
	var/thermostat = T20C

	category = MODULE_GENERAL

/obj/item/rig_module/cooling_unit/process()
	if(!active)
		return passive_power_cost

	var/mob/living/carbon/human/H = holder.wearer

	var/temp_adj = min(H.bodytemperature - thermostat, max_cooling)

	if (temp_adj < 0.5)
		return passive_power_cost

	H.bodytemperature -= temp_adj
	active_power_cost = round((temp_adj/max_cooling)*charge_consumption)
	return active_power_cost

/obj/item/rig_module/boring
	name = "burrowing lasers"
	desc = "A set of precise boring lasers designed to carve a hole beneath the user."
	icon_state = "actuators"
	interface_name = "boring laser"
	interface_desc = "Allows you to burrow to the z-level below."

	disruptive = 1

	use_power_cost = 5
	module_cooldown = 25

	usable = TRUE

	category = MODULE_VAURCA

/obj/item/rig_module/boring/engage(atom/target, mob/user)
	if (!..())
		return FALSE

	playsound(src,'sound/magic/lightningbolt.ogg',60,1)
	var/turf/T = get_turf(holder.wearer)
	if(istype(T, /turf/simulated))
		if(istype(T, /turf/simulated/mineral) || istype(T, /turf/simulated/wall))
			T.ChangeTurf(T.baseturf)
		else
			T.ChangeTurf(/turf/space)

var/global/list/lattice_users = list()

/obj/item/rig_module/lattice
	name = "neural lattice"
	desc = "A probing mind collar that synchronizes the subject's pain receptors with all other neural lattices on the local grid."
	icon_state = "actuators"
	interface_name = "neural lattice"
	interface_desc = "Synchronize neural lattice to reduce pain."

	disruptive = FALSE

	toggleable = TRUE
	confined_use = TRUE

	category = MODULE_VAURCA

/obj/item/rig_module/lattice/activate()
	if (!..())
		return FALSE

	var/mob/living/carbon/human/H = holder.wearer
	to_chat(H, SPAN_NOTICE("Neural lattice engaged. Pain receptors altered."))
	lattice_users.Add(H)

/obj/item/rig_module/lattice/deactivate()
	if (!..())
		return FALSE

	var/mob/living/carbon/human/H = holder.wearer
	to_chat(H, SPAN_NOTICE("Neural lattice disengaged. Pain receptors restored."))
	lattice_users.Remove(H)