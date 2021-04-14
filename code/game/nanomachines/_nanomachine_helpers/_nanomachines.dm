// Nanomachines, inspired by the /tg/station version, Nanites.

#define ACCENT_NANOMACHINE "Nanomachine" // have to put it here because it's higher in the .dme than the other accents

/mob/living/carbon/human
	var/datum/nanomachine/nanomachines

/mob/living/carbon/human/proc/add_nanomachines(var/datum/nanomachine/NM)
	NM.set_owner(src)
	var/list/program_names = list()
	for(var/program in nanomachines.loaded_programs)
		var/decl/nanomachine_effect/NE = decls_repository.get_decl(program)
		program_names += NE.name
	nanomachines.speak_to_owner("Programs loaded: [english_list(program_names)].")
	nanomachines.speak_to_owner("Note: Post-Infusement sickness will take effect for up to three minutes. You may experience: Muscle weakness, mild discomfort, and coordination impairment.")

/mob/living/carbon/human/proc/remove_nanomachines()
	nanomachines.owner = null
	QDEL_NULL(nanomachines)

/datum/nanomachine
	var/mob/living/carbon/human/owner
	var/list/loaded_programs = list()
	var/max_programs = 2

	var/load_time = null // when the nanomachines first entered the host
	var/last_process = 0

	var/machine_volume = 50   // amount of nanomachines in the system, used as fuel for nanomachine programs
	var/max_machines = 100    // maximum amount of nanomachines in the system
	var/deterioration = 0     // how many nanomachines we're losing this process
	var/regen_rate = 0.5      // nanomachines generated per second
	var/safety_threshold = 50 // how low nanomachines will get before they stop processing/triggering

	var/list/program_last_trigger // keeps time for processes, some want to fire every 2 minutes, for example

	// bio-computing
	var/tech_points_researched = 0

/datum/nanomachine/New(var/atom/new_owner)
	..()
	if(ishuman(new_owner))
		set_owner(new_owner)

/datum/nanomachine/proc/set_owner(var/mob/living/carbon/human/H)
	owner = H
	owner.nanomachines = src
	last_process = world.time
	load_time = world.time

/datum/nanomachine/proc/handle_nanomachines()
	for(var/program in loaded_programs)
		var/decl/nanomachine_effect/NE = decls_repository.get_decl(program)
		if(NE.has_process_effect && NE.check_nanomachine_effect(src, owner))
			NE.do_nanomachine_effect(src, owner)
	handle_regen_and_deterioration() // this deterioration runs last

/datum/nanomachine/proc/handle_nanomachines_chem_effect()
	if(load_time) // infusion sickness
		if(load_time + 2 MINUTES > world.time)
			owner.add_chemical_effect(CE_CLUMSY)
		if(load_time + 3 MINUTES > world.time)
			owner.add_chemical_effect(CE_SLOWDOWN)
			owner.add_chemical_effect(CE_UNDEXTROUS)
	deterioration = 0 // this deterioration runs first
	for(var/program in loaded_programs)
		var/decl/nanomachine_effect/NE = decls_repository.get_decl(program)
		if(NE.has_chem_effect && NE.check_nanomachine_effect(src, owner))
			NE.do_nanomachine_effect(src, owner)

/datum/nanomachine/proc/handle_regen_and_deterioration()
	if(load_time && world.time - load_time > 2 HOURS)
		regen_rate = -0.2 // nanomachines are old and will work themselves out of the body now
		safety_threshold = 0
		load_time = null
	var/regen_amount = (regen_rate - deterioration) TIMES_SECONDS_PASSED(last_process)
	machine_volume = min(machine_volume + regen_amount, max_machines)
	last_process = world.time
	if(machine_volume <= 0)
		owner.remove_nanomachines()
		return

/datum/nanomachine/proc/speak_to_owner(var/message)
	to_chat(owner, "[get_accent("nanomachine")] <span class='nanomachine'><b>Inside your head</b>, \"[message]\"</span>")

/datum/nanomachine/proc/get_loaded_programs()
	var/list/ui_loaded_programs = list()
	for(var/program in loaded_programs)
		var/decl/nanomachine_effect/NE = decls_repository.get_decl(program)
		ui_loaded_programs += NE.name
	return ui_loaded_programs

/datum/nanomachine/proc/add_program(var/program)
	loaded_programs += program
	var/decl/nanomachine_effect/NE = decls_repository.get_decl(program)
	NE.add_effect(src)

/datum/nanomachine/proc/remove_program(var/program)
	var/decl/nanomachine_effect/NE = decls_repository.get_decl(program)
	NE.remove_effect(src)
	loaded_programs -= program
	if(check_program_capacity_usage() > max_programs) // we removed a storage increasing program while having a program occupying its added slot
		remove_program(loaded_programs[length(loaded_programs)]) // remove programs at the back first

/datum/nanomachine/proc/check_program_capacity_usage()
	var/program_usage = 0
	for(var/program in loaded_programs)
		var/decl/nanomachine_effect/NE = decls_repository.get_decl(program)
		program_usage += NE.program_capacity_usage
	return program_usage

/datum/nanomachine/proc/check_program_deterioration_rate()
	var/deterioration_rate = 0
	for(var/program in loaded_programs)
		var/decl/nanomachine_effect/NE = decls_repository.get_decl(program)
		if(!NE.has_chem_effect && !NE.has_process_effect)
			continue
		deterioration_rate += NE.nanomachines_per_use
	return deterioration_rate