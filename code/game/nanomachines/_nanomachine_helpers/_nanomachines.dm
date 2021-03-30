// Nanomachines, inspired by the /tg/station verson, Nanites.

#define ACCENT_NANOMACHINE "Nanomachine" // have to put it here because it's higher in the .dme than the other accents

/mob/living/carbon/human
	var/datum/nanomachine/nanomachines
	var/obj/screen/nanomachines/nanomachine_hud

/mob/living/carbon/human/proc/add_nanomachines(var/list/programs)
	var/message = "Programs loaded:"
	var/list/new_programs = list()
	if(nanomachines)
		message = "Additional programs loaded:"
		for(var/program in programs)
			if(length(nanomachines.loaded_programs) > nanomachines.max_programs)
				break
			if(program in nanomachines.loaded_programs)
				continue
			nanomachines.loaded_programs += program
			new_programs += program
	else
		nanomachines = new /datum/nanomachine(src)
		if(programs)
			nanomachines.loaded_programs = programs.Copy()
			new_programs = nanomachines.loaded_programs
	if(length(new_programs))
		var/list/program_names = list()
		for(var/program in programs)
			var/decl/nanomachine_effect/NE = decls_repository.get_decl(program)
			program_names += NE.name
		nanomachines.speak_to_owner("[message] [english_list(program_names)].")
	nanomachine_hud.icon_state = "base"

/mob/living/carbon/human/proc/remove_nanomachines()
	nanomachines.owner = null
	QDEL_NULL(nanomachines)
	nanomachine_hud.icon_state = null

/datum/nanomachine
	var/mob/living/carbon/human/owner
	var/list/loaded_programs = list()
	var/max_programs = 3
	var/last_process = 0

	var/machine_volume = 100  // amount of nanomachines in the system, used as fuel for nanomachine programs
	var/max_machines = 500    // maximum amount of nanomachines in the system
	var/regen_rate = 0.5      // nanomachines generated per second
	var/safety_threshold = 50 // how low nanomachines will get before they stop processing/triggering

/datum/nanomachine/New(var/mob/living/carbon/human/set_owner)
	owner = set_owner
	owner.nanomachines = src
	last_process = world.time

/datum/nanomachine/proc/handle_nanomachines()
	for(var/program in loaded_programs)
		var/decl/nanomachine_effect/NE = decls_repository.get_decl(program)
		if(NE.check_nanomachine_effect(src, owner))
			NE.do_nanomachine_effect(src, owner)
	if(machine_volume <= 0)
		owner.remove_nanomachines()
	else
		var/regen_amount = regen_rate * ((world.time - last_process) / 10)
		machine_volume = clamp(machine_volume + regen_amount, 0, max_machines)
		owner.nanomachine_hud.maptext = SMALL_FONTS(7, round(machine_volume))
		last_process = world.time

/datum/nanomachine/proc/speak_to_owner(var/message)
	var/datum/asset/spritesheet/S = get_asset_datum(/datum/asset/spritesheet/goonchat)
	to_chat(owner, "[S.icon_tag("nanomachine")] <span class='nanomachine'><b>Inside your head</b>, \"[message]\"</span>")