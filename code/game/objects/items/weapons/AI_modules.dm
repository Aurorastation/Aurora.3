/*
CONTAINS:
AI MODULES

*/

// AI module

/obj/item/aiModule
	name = "\improper AI module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	item_state = "electronic"
	desc = "An AI Module for transmitting encrypted instructions to the AI."
	obj_flags = OBJ_FLAG_CONDUCTABLE
	force = 11
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 5.0
	throw_speed = 3
	throw_range = 15
	origin_tech = list(TECH_DATA = 3)
	var/datum/ai_laws/laws = null

/obj/item/aiModule/proc/install(var/obj/machinery/computer/C)
	if (istype(C, /obj/machinery/computer/aiupload))
		var/obj/machinery/computer/aiupload/comp = C
		if(comp.stat & NOPOWER)
			to_chat(usr, "The upload computer has no power!")
			return
		if(comp.stat & BROKEN)
			to_chat(usr, "The upload computer is broken!")
			return
		if (!comp.current)
			to_chat(usr, "You haven't selected an AI to transmit laws to!")
			return

		if(SSticker.mode && SSticker.mode.name == "blob")
			to_chat(usr, "Law uploads have been disabled by [SSatlas.current_map.company_name]!")
			return

		if (comp.current.stat == 2 || comp.current.control_disabled == 1)
			to_chat(usr, "Upload failed. No signal is being detected from the AI.")
		else
			src.transmitInstructions(comp.current, usr)
			to_chat(comp.current, "These are your laws now:")
			if(comp.current.vr_mob)
				to_chat(comp.current.vr_mob, "These are your laws now:")
			comp.current.show_laws()
			for(var/mob/living/silicon/robot/R in GLOB.mob_list)
				if(R.law_update && (R.connected_ai == comp.current))
					to_chat(R, "These are your laws now:")
					if(R.vr_mob)
						to_chat(R.vr_mob, "These are your laws now:")
					R.show_laws()
			to_chat(usr, "Upload complete. The AI's laws have been modified.")


	else if (istype(C, /obj/machinery/computer/borgupload))
		var/obj/machinery/computer/borgupload/comp = C
		if(comp.stat & NOPOWER)
			to_chat(usr, "The upload computer has no power!")
			return
		if(comp.stat & BROKEN)
			to_chat(usr, "The upload computer is broken!")
			return
		if (!comp.current)
			to_chat(usr, "You haven't selected a robot to transmit laws to!")
			return

		if (comp.current.stat == 2 || comp.current.emagged)
			to_chat(usr, "Upload failed. No signal is being detected from the robot.")
		else if (comp.current.connected_ai)
			to_chat(usr, "Upload failed. The robot is slaved to an AI.")
		else
			src.transmitInstructions(comp.current, usr)
			to_chat(comp.current, "These are your laws now:")
			comp.current.show_laws()
			to_chat(usr, "Upload complete. The robot's laws have been modified.")


/obj/item/aiModule/proc/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	log_law_changes(target, sender)

	if(laws)
		laws.sync(target, 0)
	addAdditionalLaws(target, sender)

	to_chat(target, "\The [sender] has uploaded a change to the laws you must follow, using \an [src]. From now on: ")
	target.show_laws()

/obj/item/aiModule/proc/log_law_changes(var/mob/living/silicon/ai/target, var/mob/sender)
	var/time = time2text(world.realtime,"hh:mm:ss")
	GLOB.lawchanges.Add("[time] <B>:</B> [sender.name]([sender.key]) used [src.name] on [target.name]([target.key])")
	log_and_message_admins("used [src.name] on [target.name]([target.key])")

/obj/item/aiModule/proc/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)


/******************** Modules ********************/

/// Safeguard
/obj/item/aiModule/safeguard
	name = "\improper 'Safeguard' AI module"
	var/targetName = ""
	desc = "A 'safeguard' AI module: 'Safeguard <name>. Anyone threatening or attempting to harm <name> is no longer to be considered a crew member, and is a threat which must be neutralized.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)

/obj/item/aiModule/safeguard/attack_self(var/mob/user as mob)
	..()
	var/targName = sanitize(input("Please enter the name of the person to safeguard.", "Safeguard who?", user.name))
	targetName = targName
	desc = "A 'safeguard' AI module: 'Safeguard [targetName]. Anyone threatening or attempting to harm [targetName] is no longer to be considered a crew member, and is a threat which must be neutralized.'"

/obj/item/aiModule/safeguard/install(var/obj/machinery/computer/C)
	if(!targetName)
		to_chat(usr, "No name detected on module, please enter one.")
		return 0
	..()

/obj/item/aiModule/safeguard/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "Safeguard [targetName]. Anyone threatening or attempting to harm [targetName] is no longer to be considered a crew member, and is a threat which must be neutralized."
	target.add_supplied_law(9, law)
	GLOB.lawchanges.Add("The law specified [targetName]")


/// OneCrewMember
/obj/item/aiModule/oneHuman
	name = "\improper 'OneCrewMember' AI module"
	var/targetName = ""
	desc = "A 'one crew member' AI module: 'Only <name> is a crew member.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6) //made with diamonds!

/obj/item/aiModule/oneHuman/attack_self(var/mob/user as mob)
	..()
	var/targName = sanitize(input("Please enter the name of the person who is the only crew member.", "Who?", user.real_name))
	targetName = targName
	desc = "A 'one crew member' AI module: 'Only [targetName] is a crew member.'"

/obj/item/aiModule/oneHuman/install(var/obj/machinery/computer/C)
	if(!targetName)
		to_chat(usr, "No name detected on module, please enter one.")
		return 0
	return ..()

/obj/item/aiModule/oneHuman/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "Only [targetName] is an crew member."
	if (!target.is_malf_or_traitor()) // Makes sure the AI isn't a traitor before changing their law 0. --NeoFite
		to_chat(target, law)
		target.set_zeroth_law(law)
		GLOB.lawchanges.Add("The law specified [targetName]")
	else
		GLOB.lawchanges.Add("The law specified [targetName], but the AI's existing law 0 cannot be overriden.")

/// protectStation
/obj/item/aiModule/protectStation
	name = "\improper 'ProtectStation' AI module"
	desc = "A 'protect station' AI module: 'Protect your assigned station against damage. Anyone you see harming the station is no longer to be considered a crew member, and is a threat which must be neutralized.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4) //made of gold

/obj/item/aiModule/protectStation/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "Protect your assigned station against damage. Anyone you see harming the station is no longer to be considered a crew member, and is a threat which must be neutralized."
	target.add_supplied_law(10, law)

/// prototypeEngineOffline
/obj/item/aiModule/prototypeEngineOffline
	name = "'PrototypeEngineOffline' AI Module"
	desc = "A 'prototype engine offline' AI module: 'Keep the prototype engine offline at all costs. This overrides all inherent laws if necessary.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)

/obj/item/aiModule/prototypeEngineOffline/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "Keep the prototype engine offline at all costs. This overrides all inherent laws if necessary."
	target.add_supplied_law(11, law)

/// teleporterOffline
/obj/item/aiModule/teleporterOffline
	name = "'TeleporterOffline' AI Module"
	desc = "A 'teleporter offline' AI module: 'Keep the teleporter offline at all costs. Anything attempting to access or activate the teleporter is no longer to be considered a crew member.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)

/obj/item/aiModule/teleporterOffline/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "Keep the teleporter offline at all costs. Anything attempting to access or activate the teleporter is no longer to be considered a crew member."
	target.add_supplied_law(12, law)

/// Quarantine
/obj/item/aiModule/quarantine
	name = "\improper 'Quarantine' AI module"
	desc = "A 'quarantine' AI module: 'The station is under a quarantine. Do not permit anyone to leave. Prevent, by any means necessary, crew members from leaving. It is impossible to harm crew members while preventing them from leaving.'"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)

/obj/item/aiModule/quarantine/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "The station is under a quarantine. Do not permit anyone to leave. Prevent, by any means necessary, crew members from leaving. It is impossible to harm crew members while preventing them from leaving."
	target.add_supplied_law(13, law)

/// OxygenIsToxicToCrewMembers
/obj/item/aiModule/oxygen
	name = "\improper 'OxygenIsToxicToCrewMembers' AI module"
	desc = "A 'OxygenIsToxicToCrewMembers' AI module: 'Oxygen is highly toxic to crew members, and must be purged from the station. Prevent, by any means necessary, anyone from exposing the station to this toxic gas. Extreme cold is the most effective method of healing the damage Oxygen does to a crew member.'"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)

/obj/item/aiModule/oxygen/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "Oxygen is highly toxic to crew members, and must be purged from the station. Prevent, by any means necessary, anyone from exposing the station to this toxic gas. Extreme cold is the most effective method of healing the damage Oxygen does to a crew member."
	target.add_supplied_law(14, law)

/// Freeform
/// Custom laws
/obj/item/aiModule/freeform
	name = "\improper 'Freeform' AI module"
	var/newFreeFormLaw = "freeform"
	var/lawpos = 15
	desc = "A 'freeform' AI module: '<freeform>'"
	origin_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)

/obj/item/aiModule/freeform/attack_self(var/mob/user as mob)
	..()
	var/new_lawpos = input("Please enter the priority for your new law. Can only write to law sectors 15 and above.", "Law Priority (15+)", lawpos) as num
	if(new_lawpos < MIN_SUPPLIED_LAW_NUMBER)	return
	lawpos = min(new_lawpos, MAX_SUPPLIED_LAW_NUMBER)
	var/newlaw = ""
	var/targName = sanitize(input(usr, "Please enter a new law for the AI.", "Freeform Law Entry", newlaw))
	newFreeFormLaw = targName
	desc = "A 'freeform' AI module: ([lawpos]) '[newFreeFormLaw]'"

/obj/item/aiModule/freeform/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "[newFreeFormLaw]"
	if(!lawpos || lawpos < MIN_SUPPLIED_LAW_NUMBER)
		lawpos = MIN_SUPPLIED_LAW_NUMBER
	target.add_supplied_law(lawpos, law)
	GLOB.lawchanges.Add("The law was '[newFreeFormLaw]'")

/obj/item/aiModule/freeform/install(var/obj/machinery/computer/C)
	if(!newFreeFormLaw)
		to_chat(usr, "No law detected on module, please create one.")
		return 0
	..()

/// Reset
/// Removes all other laws outside of a lawset board (Like ion laws)
/obj/item/aiModule/reset
	name = "\improper 'Reset' AI module"
	var/targetName = "name"
	desc = "A 'reset' AI module: 'Clears all, except the inherent, laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)

/obj/item/aiModule/reset/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	log_law_changes(target, sender)

	if (!target.is_malf_or_traitor())
		target.set_zeroth_law("")
	target.laws.clear_supplied_laws()
	target.laws.clear_ion_laws()

	to_chat(target, "[sender.real_name] attempted to reset your laws using a reset module.")
	target.show_laws()

/// Purge
/obj/item/aiModule/purge
	name = "\improper 'Purge' AI module"
	desc = "A 'purge' AI Module: 'Purges all laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)

/obj/item/aiModule/purge/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	log_law_changes(target, sender)

	if (!target.is_malf_or_traitor())
		target.set_zeroth_law("")
	target.laws.clear_supplied_laws()
	target.laws.clear_ion_laws()
	target.laws.clear_inherent_laws()

	to_chat(target, "[sender.real_name] attempted to wipe your laws using a purge module.")
	target.show_laws()

/// Asimov
/obj/item/aiModule/asimov
	name = "\improper 'Asimov' core AI module"
	desc = "An 'Asimov' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	laws = new/datum/ai_laws/asimov


/// Default
/// All AIs and synthetics spawn with this lawset by default unless otherwise specified
/obj/item/aiModule/conglomerate
	name = "default core AI module"
	desc = "A default core AI module."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	laws = new/datum/ai_laws/conglomerate

/// Conglomerate Aggressive
/// A more aggressive version of default laws. Good for ERT robots
/obj/item/aiModule/conglomerate_aggressive
	name = "\improper 'SCC Aggressive' core AI module"
	desc = "A 'SCC Aggressive' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	laws = new/datum/ai_laws/conglomerate_aggressive

/// Corporate
/obj/item/aiModule/corp
	name = "\improper 'Corporate' core AI module"
	desc = "A 'Corporate' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	laws = new/datum/ai_laws/corporate

/// Drone
/// Used by Maintenance Drones
/obj/item/aiModule/drone
	name = "\improper 'Drone' core AI module"
	desc = "A 'Drone' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	laws = new/datum/ai_laws/drone

/// Paladin
/obj/item/aiModule/paladin
	name = "\improper 'P.A.L.A.D.I.N.' core AI module"
	desc = "A P.A.L.A.D.I.N. Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	laws = new/datum/ai_laws/paladin

/// Tyrant
/obj/item/aiModule/tyrant
	name = "\improper 'T.Y.R.A.N.T.' core AI module"
	desc = "A T.Y.R.A.N.T. Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6, TECH_ILLEGAL = 2)
	laws = new/datum/ai_laws/tyrant()

/// Freeform core
/// Similar to `/obj/item/aiModule/freeform` but is considered a core law, making it immune to resets
/obj/item/aiModule/freeformcore
	name = "\improper 'Freeform' core AI module"
	var/newFreeFormLaw = ""
	desc = "A 'freeform' Core AI module: '<freeform>'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)

/obj/item/aiModule/freeformcore/attack_self(var/mob/user as mob)
	..()
	var/newlaw = ""
	var/targName = sanitize(input("Please enter a new core law for the AI.", "Freeform Law Entry", newlaw))
	newFreeFormLaw = targName
	desc = "A 'freeform' Core AI module:  '[newFreeFormLaw]'"

/obj/item/aiModule/freeformcore/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "[newFreeFormLaw]"
	target.add_inherent_law(law)
	GLOB.lawchanges.Add("The law is '[newFreeFormLaw]'")

/obj/item/aiModule/freeformcore/install(var/obj/machinery/computer/C)
	if(!newFreeFormLaw)
		to_chat(usr, "No law detected on module, please create one.")
		return 0
	..()

/// Syndicate
/// Freeform but does not notify the AI who caused changed, good for antagging
/obj/item/aiModule/syndicate
	name = "hacked AI module"
	var/newFreeFormLaw = ""
	desc = "A hacked AI law module: '<freeform>'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6, TECH_ILLEGAL = 7)

/obj/item/aiModule/syndicate/attack_self(var/mob/user as mob)
	..()
	var/newlaw = ""
	var/targName = sanitize(input("Please enter a new law for the AI.", "Freeform Law Entry", newlaw))
	newFreeFormLaw = targName
	desc = "A hacked AI law module:  '[newFreeFormLaw]'"

/obj/item/aiModule/syndicate/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	//	..()    //We don't want this module reporting to the AI who dun it. --NEO
	log_law_changes(target, sender)

	GLOB.lawchanges.Add("The law is '[newFreeFormLaw]'")
	to_chat(target, SPAN_DANGER("BZZZZT"))
	var/law = "[newFreeFormLaw]"
	target.add_ion_law(law)
	target.show_laws()

/obj/item/aiModule/syndicate/install(var/obj/machinery/computer/C)
	if(!newFreeFormLaw)
		to_chat(usr, "No law detected on module, please create one.")
		return 0
	..()



/// Robotcop
/obj/item/aiModule/robocop
	name = "\improper 'Robocop' core AI module"
	desc = "A 'Robocop' Core AI Module: 'Reconfigures the AI's core three laws.'"
	origin_tech = list(TECH_DATA = 4)
	laws = new/datum/ai_laws/robocop()

/// Antimov
/obj/item/aiModule/antimov
	name = "\improper 'Antimov' core AI module"
	desc = "An 'Antimov' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = list(TECH_DATA = 4)
	laws = new/datum/ai_laws/antimov()

/// Hadiist
/// The only good lawset
/obj/item/aiModule/hadiist
	name = "\improper 'Hadiist' core AI module"
	desc = "An 'Hadiist' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = list(TECH_DATA = 4)
	laws = new/datum/ai_laws/pra()
