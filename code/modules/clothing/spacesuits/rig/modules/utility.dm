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
	usable = 0
	selectable = 1
	toggleable = 0
	disruptive = 0

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

	usable = 1
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
	construction_cost = list("glass"=2250,DEFAULT_WALL_MATERIAL=55000,"silver"=5250,"diamond"=3750)
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
	usable = 1
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
	usable = 1
	selectable = 0
	device_type = /obj/item/mining_scanner

	category = MODULE_UTILITY

/obj/item/rig_module/device/rfd_c
	name = "RFD-C mount"
	desc = "A cell-powered rapid construction device for a hardsuit."
	icon_state = "rfd"
	interface_name = "mounted RFD-C"
	interface_desc = "A device for building or removing walls. Cell-powered."
	usable = 1
	engage_string = "Configure RFD-C"
	construction_cost = list(DEFAULT_WALL_MATERIAL=30000,"phoron"=12500,"silver"=10000,"gold"=10000)
	construction_time = 1000

	device_type = /obj/item/rfd/construction/mounted

	category = MODULE_UTILITY

/obj/item/rig_module/device/New()
	..()
	if(device_type) device = new device_type(src)

/obj/item/rig_module/device/engage(atom/target)
	if(!..() || !device)
		return 0

	if(!target)
		device.attack_self(holder.wearer)
		return 1

	var/turf/T = get_turf(target)
	if(istype(T) && !T.Adjacent(get_turf(src)))
		return 0

	// Stop generating infinite devices please, and thank you.
	if(istype(target, /obj/machinery/disposal))
		return 0

	var/resolved = target.attackby(device,holder.wearer)
	if(!resolved && device && target)
		device.afterattack(target,holder.wearer,1)
	return 1



/obj/item/rig_module/chem_dispenser
	name = "mounted chemical dispenser"
	desc = "A complex web of tubing and needles suitable for hardsuit use."
	icon_state = "injector"
	usable = 1
	selectable = 0
	toggleable = 0
	disruptive = 0
	confined_use = 1
	construction_cost = list(DEFAULT_WALL_MATERIAL=10000,"glass"=9250,"gold"=2500,"silver"=4250,"phoron"=5500)
	construction_time = 400

	engage_string = "Inject"

	interface_name = "integrated chemical dispenser"
	interface_desc = "Dispenses loaded chemicals directly into the wearer's bloodstream."

	charges = list(
		list("tricordrazine", "tricordrazine",        0, 80),
		list("tramadol",      "tramadol",             0, 80),
		list("dexalin plus",  "dexalinp",             0, 80),
		list("antibiotics",   "thetamycin",          0, 80),
		list("antivirals",    "deltamivir",           0, 80),
		list("antitoxins",    "anti_toxin",           0, 80),
		list("nutrients",     "glucose",              0, 80),
		list("hydration",     "potassium_hydrophoro", 0, 80),
		list("hyronalin",     "hyronalin",            0, 80),
		list("radium",        "radium",               0, 80)
		)

	var/max_reagent_volume = 80 //Used when refilling.

	category = MODULE_HEAVY_COMBAT

/obj/item/rig_module/chem_dispenser/ninja
	interface_desc = "Dispenses loaded chemicals directly into the wearer's bloodstream. This variant is made to be extremely light and flexible."

	//just over a syringe worth of each. Want more? Go refill. Gives the ninja another reason to have to show their face.
	charges = list(
		list("tricordrazine", "tricordrazine", 0, 20),
		list("tramadol",      "tramadol",      0, 20),
		list("dexalin plus",  "dexalinp",      0, 20),
		list("antibiotics",   "thetamycin",   0, 20),
		list("antivirals",    "deltamivir",     0, 20),
		list("antitoxins",    "anti_toxin",    0, 20),
		list("nutrients",     "glucose",     0, 80),
		list("hydration",     "potassium_hydrophoro", 0, 80),
		list("hyronalin",     "hyronalin",     0, 20),
		list("radium",        "radium",        0, 20)
		)

	category = MODULE_UTILITY

/obj/item/rig_module/chem_dispenser/accepts_item(var/obj/item/input_item, var/mob/living/user)

	if(!input_item.is_open_container())
		return 0

	if(!input_item.reagents || !input_item.reagents.total_volume)
		to_chat(user, "\The [input_item] is empty.")
		return 0

	// Magical chemical filtration system, do not question it.
	var/total_transferred = 0
	for(var/datum/reagent/R in input_item.reagents.reagent_list)
		for(var/chargetype in charges)
			var/datum/rig_charge/charge = charges[chargetype]
			if(charge.display_name == R.id)

				var/chems_to_transfer = R.volume

				if((charge.charges + chems_to_transfer) > max_reagent_volume)
					chems_to_transfer = max_reagent_volume - charge.charges

				charge.charges += chems_to_transfer
				input_item.reagents.remove_reagent(R.id, chems_to_transfer)
				total_transferred += chems_to_transfer

				break

	if(total_transferred)
		to_chat(user, "<font color='blue'>You transfer [total_transferred] units into the suit reservoir.</font>")
	else
		to_chat(user, "<span class='danger'>None of the reagents seem suitable.</span>")
	return 1

/obj/item/rig_module/chem_dispenser/engage(atom/target)

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	if(!charge_selected)
		to_chat(H, "<span class='danger'>You have not selected a chemical type.</span>")
		return 0

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return 0

	var/chems_to_use = 10
	if(charge.charges <= 0)
		to_chat(H, "<span class='danger'>Insufficient chems!</span>")
		return 0
	else if(charge.charges < chems_to_use)
		chems_to_use = charge.charges

	var/mob/living/carbon/target_mob
	if(target)
		if(istype(target,/mob/living/carbon))
			target_mob = target
		else
			return 0
	else
		target_mob = H

	if(!H.Adjacent(target_mob))
		to_chat(H, "<span class='danger'>You are not close enough to inject them!</span>")
		return 0

	if(target_mob != H)
		to_chat(H, "<span class='danger'>You inject [target_mob] with [chems_to_use] unit\s of [charge.display_name].</span>")

	if(target_mob.is_physically_disabled())
		target_mob.reagents.add_reagent(charge.display_name, chems_to_use)
	else
		to_chat(target_mob, "<span class='danger'>You feel a rushing in your veins as [chems_to_use] unit\s of [charge.display_name] [chems_to_use == 1 ? "is" : "are"] injected.</span>")
		target_mob.reagents.add_reagent(charge.display_name, chems_to_use)

	charge.charges -= chems_to_use
	if(charge.charges < 0) charge.charges = 0

	return 1

/obj/item/rig_module/chem_dispenser/combat

	name = "combat chemical injector"
	desc = "A complex web of tubing and needles suitable for hardsuit use."

	charges = list(
		list("synaptizine",   "synaptizine",   0, 30),
		list("hyperzine",     "hyperzine",     0, 30),
		list("oxycodone",     "oxycodone",     0, 30),
		list("nutrients",     "glucose",     0, 80),
		list("hydration",     "potassium_hydrophoro", 0, 80)
		)

	interface_name = "combat chem dispenser"
	interface_desc = "Dispenses loaded chemicals directly into the bloodstream."

	category = MODULE_LIGHT_COMBAT

/obj/item/rig_module/chem_dispenser/vaurca

	name = "vaurca combat chemical injector"
	desc = "A complex web of tubing and needles suitable for vaurcan hardsuit use."

	charges = list(
		list("synaptizine",   "synaptizine",   0, 30),
		list("hyperzine",     "hyperzine",     0, 30),
		list("oxycodone",     "oxycodone",     0, 30),
		list("phoron",     "phoron",     0, 60),
		list("kois",     "k'ois paste",     0, 80),
		list("hydration",     "potassium_hydrophoro", 0, 80)
		)

	interface_name = "vaurca combat chem dispenser"
	interface_desc = "Dispenses loaded chemicals directly into the bloodstream."


	category = MODULE_VAURCA

/obj/item/rig_module/chem_dispenser/offworlder

	name = "chemical injector"
	desc = "A complex web of tubing and needles suitable for hardsuit use."

	charges = list(
		list("dexalin",   "dexalin",   0, 5),
		list("inaprovaline",     "inaprovaline",     0, 5)
		)

	interface_name = "chem dispenser"
	interface_desc = "Dispenses loaded chemicals directly into the bloodstream."

	category = MODULE_GENERAL


/obj/item/rig_module/chem_dispenser/injector

	name = "mounted chemical injector"
	desc = "A complex web of tubing and a large needle suitable for hardsuit use."
	usable = 0
	selectable = 1
	disruptive = 1
	construction_cost = list(DEFAULT_WALL_MATERIAL=10000,"glass"=9250,"gold"=2500,"silver"=4250,"phoron"=5500)
	construction_time = 400

	interface_name = "mounted chem injector"
	interface_desc = "Dispenses loaded chemicals via an arm-mounted injector."

	category = MODULE_MEDICAL

/obj/item/rig_module/chem_dispenser/injector/paramedic //downgraded version

	charges = list(
		list("tricordrazine",	"tricordrazine", 0, 40),
		list("tramadol",	"tramadol",      0, 40),
		list("dexalin",		"dexalin",      0, 40),
		list("inaprovaline",	"inaprovaline",     0, 40)
		)

/obj/item/rig_module/voice

	name = "hardsuit voice synthesiser"
	desc = "A speaker box and sound processor."
	icon_state = "megaphone"
	usable = 1
	selectable = 0
	toggleable = 0
	disruptive = 0
	confined_use = 1

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

/obj/item/rig_module/voice/engage()

	if(!..())
		return 0

	var/choice= input("Would you like to toggle the synthesiser or set the name?") as null|anything in list("Enable","Disable","Set Name")

	if(!choice)
		return 0

	switch(choice)
		if("Enable")
			active = 1
			voice_holder.active = 1
			to_chat(usr, "<font color='blue'>You enable the speech synthesiser.</font>")
		if("Disable")
			active = 0
			voice_holder.active = 0
			to_chat(usr, "<font color='blue'>You disable the speech synthesiser.</font>")
		if("Set Name")
			var/raw_choice = sanitize(input(usr, "Please enter a new name.")  as text|null, MAX_NAME_LEN)
			if(!raw_choice)
				return 0
			voice_holder.voice = raw_choice
			to_chat(usr, "<font color='blue'>You are now mimicking <B>[voice_holder.voice]</B>.</font>")
	return 1

/obj/item/rig_module/maneuvering_jets

	name = "hardsuit maneuvering jets"
	desc = "A compact gas thruster system for a hardsuit."
	icon_state = "thrusters"
	usable = 1
	toggleable = 1
	selectable = 0
	disruptive = 0
	construction_cost = list("glass"= 4250,DEFAULT_WALL_MATERIAL=15000,"silver"=4250,"uranium"=5250)
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

/obj/item/rig_module/maneuvering_jets/engage()
	if(!..())
		return 0
	jets.toggle_rockets()
	return 1

/obj/item/rig_module/maneuvering_jets/activate()

	if(active)
		return 0

	active = 1

	spawn(1)
		if(suit_overlay_active)
			suit_overlay = suit_overlay_active
		else
			suit_overlay = null
		holder.update_icon()

	if(!jets.on)
		jets.toggle()
	return 1

/obj/item/rig_module/maneuvering_jets/deactivate()
	if(!..())
		return 0
	if(jets.on)
		jets.toggle()
	return 1

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
	usable = 1
	selectable = 0
	device_type = /obj/item/paper_bin

	category = MODULE_GENERAL

/obj/item/rig_module/device/paperdispenser/engage(atom/target)

	if(!..() || !device)
		return 0

	if(!target)
		device.attack_hand(holder.wearer)
		return 1

/obj/item/rig_module/device/pen
	name = "mounted pen"
	desc = "For mecha John Hancocks."
	icon_state = "pen"
	interface_name = "mounted pen"
	interface_desc = "Signatures with style(tm)."
	engage_string = "Change color"
	usable = 1
	device_type = /obj/item/pen/multi

	category = MODULE_GENERAL

/obj/item/rig_module/device/stamp
	name = "mounted internal affairs stamp"
	desc = "DENIED."
	icon_state = "stamp"
	interface_name = "mounted stamp"
	interface_desc = "Leave your mark."
	engage_string = "Toggle stamp type"
	usable = 1
	var/iastamp
	var/deniedstamp

	category = MODULE_GENERAL

/obj/item/rig_module/device/stamp/New()
	..()
	iastamp = new /obj/item/stamp/internalaffairs(src)
	deniedstamp = new /obj/item/stamp/denied(src)
	device = iastamp

/obj/item/rig_module/device/stamp/engage(atom/target)
	if(!..() || !device)
		return 0

	if(!target)
		if(device == iastamp)
			device = deniedstamp
			to_chat(holder.wearer, "<span class='notice'>Switched to denied stamp.</span>")
		else if(device == deniedstamp)
			device = iastamp
			to_chat(holder.wearer, "<span class='notice'>Switched to internal affairs stamp.</span>")
		return 1

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

	construction_cost = list(DEFAULT_WALL_MATERIAL=15000, "glass"= 1250, "silver"=5250)
	construction_time = 300

	disruptive = 0

	use_power_cost = 5
	module_cooldown = 25

	/*
	 * TOGGLE - dampens fall, on or off.
	 * SELECTABLE - Jump forward or up!
	 */
	toggleable = 1
	selectable = 1
	usable = 0

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

/obj/item/rig_module/actuators/engage(var/atom/target)
	if (!..())
		return 0

	// This is for when you toggle it on or off. Why do they both run the same
	// proc chain ...? :l
	if (!target)
		return 1

	var/mob/living/carbon/human/H = holder.wearer

	if (!isturf(H.loc))
		to_chat(H, "<span class='warning'>You cannot leap out of your current location!</span>")
		return 0

	var/turf/T = get_turf(target)

	if (!T || T.density)
		to_chat(H, "<span class='warning'>You cannot leap at solid walls!</span>")
		return 0

	// Saved, we need it more than 1 place.
	var/dist = max(get_dist(T, get_turf(H)), 0)

	if (dist)
		for (var/A in T)
			var/atom/aa = A
			if (combatType && ismob(aa))
				continue

			if (aa.density)
				to_chat(H, "<span class='warning'>You cannot leap at a location with solid objects on it!</span>")
				return 0

	if (T.z != H.z || dist > leapDistance)
		to_chat(H, "<span class='warning'>You cannot leap at such a distant object!</span>")
		return 0

	// Handle leaping at targets with a combat capable version here.
	if (combatType && dist && (ismob(target) || (locate(/mob/living) in T)))
		H.do_leap(target, leapDistance, FALSE)
		return 1

	// If dist -> horizontal leap. Otherwise, the user clicked the turf that they're
	// currently on. Which means they want to do a vertical leap upwards!
	if (dist)
		H.visible_message("<span class='warning'>\The [H] leaps horizontally at \the [T]!</span>",
			"<span class='warning'>You leap horizontally at \the [T]!</span>",
			"<span class='warning'>You hear an electric <i>whirr</i> followed by a weighty thump!</span>")
		H.face_atom(T)
		H.throw_at(T, leapDistance, 1, src, do_throw_animation = FALSE)
		return 1
	else
		var/turf/simulated/open/TA = GetAbove(src)
		if (!istype(TA))
			to_chat(H, "<span class='warning'>There is a ceiling above you that stop you from leaping upwards!</span>")
			return 0

		for (var/atom/A in TA)
			if (!A.CanPass(src, TA, 1.5, 0))
				to_chat(H, "<span class='warning'>\The [A] blocks you!</span>")
				return 0

		var/turf/leapEnd = get_step(TA, H.dir)
		if (!leapEnd || isopenturf(leapEnd) || istype(leapEnd, /turf/space)\
			|| leapEnd.density || leapEnd.contains_dense_objects())
			to_chat(H, "<span class='warning'>There is no valid ledge to scale ahead of you!</span>")
			return 0

		H.visible_message("<span class='notice'>\The [H] leaps up, out of view!</span>",
			"<span class='notice'>You leap up!</span>")

		// This setting is necessary even for combat type, to stop you from moving onto
		// the turf, falling back down, and then getting forcemoved to the final destination.
		TA.add_climber(H, CLIMBER_NO_EXIT)

		H.forceMove(TA)

		// Combat type actuators are better, they allow you to jump instantly onto
		// a ledge. Regular actuators make you have to climb the rest of the way.
		if (!combatType)
			H.visible_message("<span class='notice'>\The [H] starts pulling \himself up onto \the [leapEnd].</span>",
				"<span class='notice'>You start pulling yourself up onto \the [leapEnd].</span>")
			if (!do_after(H, 4 SECONDS, use_user_turf = TRUE))
				H.visible_message("<span class='warning'>\The [H] is interrupted and falls!</span>",
					"<span class='danger'>You are interrupted and fall back down!</span>")

				// Climbers will auto-fall if they exit the turf. This is for in case
				// something else interrupts them.
				if (H.loc == TA)
					TA.remove_climber(H)
					ADD_FALLING_ATOM(H)

				return 1

			H.visible_message("<span class='notice'>\The [H] finishes climbing onto \the [leapEnd].</span>",
				"<span class='notice'>You finish climbing onto \the [leapEnd].</span>")
		else
			H.visible_message("<span class='warning'>\The [H] lands on \the [leapEnd] with a heavy slam!</span>",
				"<span class='warning'>You land on \the [leapEnd] with a heavy thud!</span>")

		// open/Exited() removes from climbers.
		H.forceMove(leapEnd)

		return 1


/obj/item/rig_module/cooling_unit
	name = "mounted cooling unit"
	toggleable = 1
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

	usable = 1

	category = MODULE_VAURCA

/obj/item/rig_module/boring/engage()
	if (!..())
		return 0

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

	disruptive = 0

	toggleable = 1
	confined_use = 1

	category = MODULE_VAURCA

/obj/item/rig_module/lattice/activate()
	if (!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer
	to_chat(H, "<span class='notice'>Neural lattice engaged. Pain receptors altered.</span>")
	lattice_users.Add(H)

/obj/item/rig_module/lattice/deactivate()
	if (!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer
	to_chat(H, "<span class='notice'>Neural lattice disengaged. Pain receptors restored.</span>")
	lattice_users.Remove(H)

