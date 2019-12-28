var/global/list/psychic_ranks_to_strings = list("Latent", "Operant", "Masterclass", "Grandmasterclass", "Paramount")
/var/datum/controller/subsystem/processing/psi/SSpsi

/datum/controller/subsystem/processing/psi
	name = "Psychics"
	priority = SS_PRIORITY_PSYCHICS
	flags = SS_POST_FIRE_TIMING | SS_BACKGROUND

	var/list/faculties_by_id =        list()
	var/list/faculties_by_name =      list()
	var/list/all_aura_images =        list()
	var/list/all_psi_complexes =      list()
	var/list/psi_dampeners =          list()
	var/list/psi_monitors =           list()
	var/list/armour_faculty_by_type = list()
	var/list/faculties_by_intent  = list()

/datum/controller/subsystem/processing/psi/New()
	NEW_SS_GLOBAL(SSpsi)

/datum/controller/subsystem/processing/psi/proc/get_faculty(var/faculty)
	return faculties_by_name[faculty] || faculties_by_id[faculty]

/datum/controller/subsystem/processing/psi/Initialize()
	. = ..()

	var/list/faculties = subtypesof(/datum/psionic_faculty)
	for(var/ftype in faculties)
		var/datum/psionic_faculty/faculty = new ftype
		faculties_by_id[faculty.id] = faculty
		faculties_by_name[faculty.name] = faculty
		faculties_by_intent[faculty.associated_intent] = faculty.id

	var/list/powers = subtypesof(/datum/psionic_power)
	for(var/ptype in powers)
		var/datum/psionic_power/power = new ptype
		if(power.faculty)
			var/datum/psionic_faculty/faculty = get_faculty(power.faculty)
			if(faculty)
				faculty.powers |= power