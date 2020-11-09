/decl/psionic_faculty
	var/id
	var/name
	var/associated_intent
	var/list/armor_types = list()
	var/list/powers = list()

/decl/psionic_faculty/New()
	..()
	for(var/atype in armor_types)
		SSpsi.armor_faculty_by_type[atype] = id
