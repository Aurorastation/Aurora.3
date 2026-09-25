//
//Robotic Component Analyzer, basically a health analyzer for robots
//
/obj/item/robotanalyzer
	name = "cyborg analyzer"
	icon = 'icons/obj/item/scanner.dmi'
	icon_state = "robotanalyzer"
	// Reuses the basic health analyzer inhands.
	item_state = "healthanalyzer"
	contained_sprite = TRUE
	desc = "A hand-held scanner able to diagnose robots, prosthetics, and heavy vehicles."
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 5
	throw_range = 10
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 1, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 500, MATERIAL_GLASS = 200)
	var/analyzer_component_type = /datum/component/robotics_analyzer

/obj/item/robotanalyzer/Initialize(mapload, ...)
	. = ..()
	LoadComponent(analyzer_component_type)

/obj/item/robotanalyzer/attack(mob/living/target_mob, mob/living/user, target_zone)
	var/datum/component/robotics_analyzer/analyzer = GetComponent(analyzer_component_type)
	if(analyzer)
		analyzer.attack(target_mob, user)

/obj/item/robotanalyzer/attack_self(mob/user)
	var/datum/component/robotics_analyzer/analyzer = GetComponent(analyzer_component_type)
	if(analyzer)
		analyzer.attack_self(user)

/datum/component/robotics_analyzer
	var/name = "cyborg analyzer"
	var/scan_title
	var/list/status_results = list()
	var/list/external_results = list()
	var/list/internal_results = list()
	var/list/tesla_results = list()
	var/obj/owner

/datum/component/robotics_analyzer/tesla
	name = "Tesla diagnostic panel"

/datum/component/robotics_analyzer/Initialize(...)
	. = ..()
	if(!isobj(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent

/datum/component/robotics_analyzer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RoboticsAnalyzer", name, 520, 620)
		ui.open()

/datum/component/robotics_analyzer/ui_data(mob/user)
	return list(
		"scan_title" = scan_title,
		"status_results" = status_results,
		"external_results" = external_results,
		"internal_results" = internal_results,
		"tesla_results" = tesla_results
	)

/datum/component/robotics_analyzer/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	if(action == "clear_list")
		clear_scan()
		return TRUE

/datum/component/robotics_analyzer/proc/clear_scan()
	scan_title = null
	status_results = list()
	external_results = list()
	internal_results = list()
	tesla_results = list()

/datum/component/robotics_analyzer/proc/attack(mob/living/target_mob, mob/living/user)
	robotics_scan_mob(target_mob, user)
	ui_interact(user)
	owner.add_fingerprint(user)

/datum/component/robotics_analyzer/proc/attack_self(mob/living/user)
	if(!scan_title)
		robotics_scan_mob(user, user)
	ui_interact(user)
	owner.add_fingerprint(user)

/datum/component/robotics_analyzer/proc/attack_mech(mob/living/heavy_vehicle/mech, mob/living/user)
	clear_scan()
	user.visible_message(SPAN_NOTICE("\The [user] has analyzed \the [mech]'s components."), SPAN_NOTICE("You have analyzed \the [mech]'s components."))
	scan_title = "Diagnostic report for [mech]"
	var/component_count = 0
	for(var/obj/item/mech_component/component in list(mech.head, mech.body, mech.arms, mech.legs))
		if(!component)
			continue
		component_count++
		var/list/details = list("Integrity: <b>[round(((component.max_damage - component.total_damage) / component.max_damage) * 100, 0.1)]%</b>")
		if(istype(component, /obj/item/mech_component/manipulators))
			var/obj/item/mech_component/manipulators/manipulators = component
			details += manipulators.motivator ? "Actuator integrity: <b>[round(((manipulators.motivator.max_dam - manipulators.motivator.total_dam) / manipulators.motivator.max_dam) * 100, 0.1)]%</b>" : SPAN_WARNING("Actuator missing or non-functional.")
		else if(istype(component, /obj/item/mech_component/propulsion))
			var/obj/item/mech_component/propulsion/propulsion = component
			details += propulsion.motivator ? "Actuator integrity: <b>[round(((propulsion.motivator.max_dam - propulsion.motivator.total_dam) / propulsion.motivator.max_dam) * 100, 0.1)]%</b>" : SPAN_WARNING("Actuator missing or non-functional.")
		else if(istype(component, /obj/item/mech_component/chassis))
			var/obj/item/mech_component/chassis/chassis = component
			details += chassis.diagnostics ? "Diagnostics unit integrity: <b>[round(((chassis.diagnostics.max_dam - chassis.diagnostics.total_dam) / chassis.diagnostics.max_dam) * 100, 0.1)]%</b>" : SPAN_WARNING("Diagnostics unit missing or non-functional.")
			details += chassis.mech_armor ? "Armor integrity: <b>[round(((chassis.mech_armor.max_dam - chassis.mech_armor.total_dam) / chassis.mech_armor.max_dam) * 100, 0.1)]%</b>" : SPAN_WARNING("Armor missing or non-functional.")
		else if(istype(component, /obj/item/mech_component/sensors))
			var/obj/item/mech_component/sensors/sensors = component
			if(sensors.software)
				details += "Installed software: [english_list(sensors.software.installed_software)]"
			else
				details += SPAN_WARNING("Control module missing or non-functional.")
			details += sensors.radio ? "Radio integrity: <b>[round(((sensors.radio.max_dam - sensors.radio.total_dam) / sensors.radio.max_dam) * 100, 0.1)]%</b>" : SPAN_WARNING("Radio missing or non-functional.")
		external_results += list(list("label" = capitalize_first_letters(component.name), "value" = details.Join("<br>")))
	status_results += "Component assemblies detected: [component_count]/4"
	ui_interact(user)
	owner.add_fingerprint(user)

/datum/component/robotics_analyzer/proc/robotics_scan_mob(mob/living/target_mob, mob/living/user, just_scan = FALSE)
	clear_scan()
	if(!just_scan)
		user.visible_message(SPAN_NOTICE("\The [user] has analyzed \the [target_mob]'s components."), SPAN_NOTICE("You have analyzed \the [target_mob]'s components."))

	if(isrobot(target_mob))
		robot_scan(target_mob)
	else if(ishuman(target_mob))
		prosthetics_scan(target_mob)
	else
		scan_title = "Analysis failed"
		status_results += SPAN_WARNING("This scanner can only analyze robots and humanoid prosthetics.")

/datum/component/robotics_analyzer/proc/robot_scan(mob/living/silicon/robot/robot)
	scan_title = "Analysis results for [robot]"
	status_results += "Overall status: [robot.stat > 1 ? SPAN_DANGER("fully disabled") : "[robot.health - robot.getHalLoss()]% functional"]"
	status_results += "Damage: <b>Physical damage:</b> <span class='warning'>[get_robot_severity(robot.getBruteLoss())]</span>; <b>Burn damage:</b> <font color='#FFA500'>[get_robot_severity(robot.getFireLoss())]</font>"
	if(robot.tod && robot.stat == DEAD)
		status_results += "Time of disable: [robot.tod]"
	status_results += "Operating temperature: [round(robot.bodytemperature - T0C, 0.1)]&deg;C ([round(robot.bodytemperature * 1.8 - 459.67, 0.1)]&deg;F)"
	if(robot.emagged && prob(5))
		status_results += SPAN_DANGER("ERROR: INTERNAL SYSTEMS COMPROMISED")

	var/list/damaged = robot.get_damaged_components(1, 1, 1)
	if(length(damaged))
		for(var/datum/robot_component/component in damaged)
			var/component_state = component.installed == -1 ? SPAN_DANGER("<b>DESTROYED</b>") : "[component.toggled ? "Toggled ON" : SPAN_WARNING("Toggled OFF")]; [component.powered ? "Power ON" : SPAN_WARNING("Power OFF")]"
			var/damage = "<b>Physical damage:</b> <span class='warning'>[component.brute_damage]</span>; <b>Burn damage:</b> <font color='#FFA500'>[component.electronics_damage]</font>; [component_state]"
			external_results += list(list("label" = capitalize(component.name), "value" = damage))
	else
		external_results += list(list("label" = "Components", "value" = SPAN_GOOD("No localized damage detected.")))

/datum/component/robotics_analyzer/proc/prosthetics_scan(mob/living/carbon/human/human)
	scan_title = "Analysis results for [human]"
	if(human.stat == DEAD)
		status_results += SPAN_DANGER("No neural coherence detected.")
	var/obj/item/organ/internal/machine/power_core/cell = human.internal_organs_by_name[BP_CELL]
	status_results += (cell ? "Cell charge: [cell.percent()]%" : "Cell charge: ERROR - Cell not present")

	for(var/obj/item/organ/external/external_organ in human.organs)
		if(!(external_organ.status & (ORGAN_ROBOT | ORGAN_ASSISTED)))
			continue
		var/damage = "<b>Physical damage:</b> <span class='warning'>[get_robot_severity(LIMB_GET_BRUTE_DAMAGE(external_organ))]</span>; <b>Burn damage:</b> <font color='#FFA500'>[get_robot_severity(LIMB_GET_BURN_DAMAGE(external_organ))]</font>"
		external_results += list(list("label" = capitalize(external_organ.name), "value" = damage))
	if(!length(external_results))
		external_results += list(list("label" = "External prosthetics", "value" = "None detected."))

	var/obj/item/organ/external/head = human.get_organ(BP_HEAD)
	var/show_tag = head?.open == 3
	for(var/obj/item/organ/internal_organ in human.internal_organs)
		if(!(internal_organ.status & (ORGAN_ROBOT | ORGAN_ASSISTED)))
			continue
		if(!show_tag && istype(internal_organ, /obj/item/organ/internal/machine/ipc_tag))
			continue
		var/integrity = SPAN_GOOD("No damage detected.")
		if(istype(internal_organ, /obj/item/organ/internal/machine))
			var/obj/item/organ/internal/machine/machine_organ = internal_organ
			if(machine_organ.get_integrity() < 100)
				integrity = "<font color='#FFA500'>Integrity damage detected.</font>"
		else if(internal_organ.get_damage())
			integrity = SPAN_WARNING("Core damage detected.")
		internal_results += list(list("label" = capitalize(internal_organ.name), "value" = integrity))
	if(!length(internal_results))
		internal_results += list(list("label" = "Internal prosthetics", "value" = "None detected."))

/datum/component/robotics_analyzer/tesla/prosthetics_scan(mob/living/carbon/human/human)
	..()
	var/obj/item/organ/internal/augment/tesla/spine = get_tesla_spine(human)
	if(!spine)
		tesla_results += list(list("label" = "Tesla spine", "value" = "Not detected."))
		return

	var/spine_status = spine.is_broken() ? SPAN_DANGER("Nonfunctional") : (spine.is_bruised() ? SPAN_WARNING("Damaged") : SPAN_GOOD("Operational"))
	tesla_results += list(list("label" = "Tesla spine", "value" = spine_status))
	tesla_results += list(list("label" = "Absorbed charge", "value" = "[spine.actual_charges]/[spine.max_charges]"))
	for(var/obj/item/organ/internal/augment/augment in human.internal_organs)
		if(augment == spine || !hascall(augment, "tesla_power_changed"))
			continue
		var/augment_status = augment.is_broken() ? SPAN_DANGER("Nonfunctional") : (augment.is_bruised() ? SPAN_WARNING("Damaged") : SPAN_GOOD("Operational"))
		tesla_results += list(list("label" = capitalize(augment.name), "value" = augment_status))

/proc/robotic_analyze_mob(var/mob/living/M, var/mob/living/user, var/just_scan = FALSE)
	if(!just_scan)
		user.visible_message(SPAN_NOTICE("\The [user] has analyzed \the [M]'s components."), SPAN_NOTICE("You have analyzed \the [M]'s components."))

	var/scan_type
	if(isrobot(M))
		scan_type = "robot"
	else if(ishuman(M))
		scan_type = "prosthetics"
	else
		to_chat(user, SPAN_WARNING("You can't analyze non-robotic things!"))
		return

	switch(scan_type)
		if("robot")
			robot_scan(user, M)
		if("prosthetics")
			prosthetics_scan(user, M)

/proc/robot_scan(mob/user, mob/living/silicon/robot/M)
	var/BU = M.getFireLoss() > 50 	? 	"<b>[get_robot_severity(M.getFireLoss())]</b>" : get_robot_severity(M.getFireLoss())
	var/BR = M.getBruteLoss() > 50 	? 	"<b>[get_robot_severity(M.getBruteLoss())]</b>" : get_robot_severity(M.getBruteLoss())

	to_chat(user, SPAN_NOTICE("Analyzing Results for [M]:"))
	to_chat(user, SPAN_NOTICE("Overall Status: [M.stat > 1 ? "fully disabled" : "[M.health - M.getHalLoss()]% functional"]"))
	to_chat(user, "Key: <span class='warning'>Physical Damage</span>/<font color='#FFA500'>Burn Damage</font>")
	to_chat(user, "Damage Specifics: <span class='warning'>[BR]</span> - <font color='#FFA500'>[BU]</font>")
	if(M.tod && M.stat == DEAD)
		to_chat(user, SPAN_NOTICE("Time of Disable: [M.tod]"))
	var/mob/living/silicon/robot/H = M
	var/list/damaged = H.get_damaged_components(1, 1, 1)
	to_chat(user, SPAN_NOTICE("Localized Damage:"))
	if(length(damaged) > 0)
		for(var/datum/robot_component/org in damaged)
			user.show_message(SPAN_NOTICE("\t [capitalize(org.name)]: [(org.installed == -1)	?	SPAN_WARNING("<b>DESTROYED</b>") :""]\
			Physical Damage: [(org.brute_damage > 0)	?	SPAN_WARNING("[org.brute_damage]") :0] - Burn Damage: [(org.electronics_damage > 0)	?	"<font color='#FFA500'>[org.electronics_damage]</font>"	: 0] - \
			[(org.toggled) ?	"Toggled ON" : SPAN_WARNING("Toggled OFF")] - \
			[(org.powered) ? "Power ON" : SPAN_WARNING("Power OFF")]"),1)

	else
		to_chat(user, SPAN_NOTICE("Components are OK."))
	if(H.emagged && prob(5))
		to_chat(user, SPAN_WARNING("ERROR: INTERNAL SYSTEMS COMPROMISED"))
	to_chat(user, SPAN_NOTICE("Operating Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)"))

/proc/prosthetics_scan(mob/user, mob/living/carbon/human/H)
	to_chat(user, SPAN_NOTICE("Analyzing Results for \the [H]:"))
	if(H.stat == DEAD)
		to_chat(user, SPAN_DANGER("No neural coherence detected."))
	to_chat(user, "Key: <span class='warning'>Physical Damage</span>/<font color='#FFA500'>Burn Damage</font>")
	var/obj/item/organ/internal/machine/power_core/IC = H.internal_organs_by_name[BP_CELL]
	if(IC)
		to_chat(user, SPAN_NOTICE("Cell charge: [IC.percent()] %"))
	else
		to_chat(user, SPAN_NOTICE("Cell charge: ERROR - Cell not present"))
	to_chat(user, SPAN_NOTICE("External prosthetics:"))
	var/organ_found
	if(length(H.internal_organs))
		for(var/obj/item/organ/external/E in H.organs)
			if(!(E.status & (ORGAN_ROBOT || ORGAN_ASSISTED)))
				continue
			organ_found = TRUE
			to_chat(user, "[E.name]: <b>Physical damage:</b> <span class='warning'>[get_robot_severity(LIMB_GET_BRUTE_DAMAGE(E))]</span>; <b>Burn damage:</b> <font color='#FFA500'>[get_robot_severity(LIMB_GET_BURN_DAMAGE(E))]</font>")
	if(!organ_found)
		to_chat(user, SPAN_NOTICE("No prosthetics located."))
	to_chat(user, "<hr>")
	to_chat(user, SPAN_NOTICE("Internal prosthetics:"))
	organ_found = FALSE
	if(length(H.internal_organs))
		var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
		var/show_tag = FALSE
		if(head?.open == 3) // Hatch open
			show_tag = TRUE
		for(var/obj/item/organ/O in H.internal_organs)
			if(!(O.status & (ORGAN_ROBOT || ORGAN_ASSISTED)))
				continue
			if(!show_tag && istype(O, /obj/item/organ/internal/machine/ipc_tag))
				continue
			organ_found = TRUE
			var/found_damage = FALSE
			if(istype(O, /obj/item/organ/internal/machine))
				var/obj/item/organ/internal/machine/machine_organ = O
				if(machine_organ.get_integrity() < 100)
					to_chat(user, "<font color='#FFA500'><b>[machine_organ.name]:</b> Integrity damage detected.</font>")
					found_damage = TRUE
			else if(O.get_damage())
				to_chat(user, SPAN_WARNING("<b>[O.name]:</b> Core damage detected."))
				found_damage = TRUE
			if(!found_damage)
				to_chat(user, SPAN_GOOD("<b>[O.name]:</b> No damage detected."))

	if(!organ_found)
		to_chat(user, SPAN_NOTICE("No prosthetics located."))

/proc/get_robot_severity(amount, var/uppercase = FALSE)
	. = "undamaged"
	if(!amount)
		. = "undamaged"
	else if(amount > 100)
		. = "destroyed"
	else if(amount > 75)
		. = "falling apart"
	else if(amount > 50)
		. = "heavily compromised"
	else if(amount > 25)
		. = "problematic"
	else if(amount > 10)
		. = "fine"
	else
		. = "minor"

/obj/item/robotanalyzer/augment
	name = "retractable cyborg analyzer"
	desc = "A scanner implanted directly into the hand and deployed through a finger. It can diagnose robotic injuries and prosthetic damage."
	slot_flags = null
	w_class = WEIGHT_CLASS_HUGE

/obj/item/robotanalyzer/augment/throw_at(atom/target, range, speed, mob/user)
	user.drop_from_inventory(src)

/obj/item/robotanalyzer/augment/dropped()
	. = ..()
	loc = null
	qdel(src)
