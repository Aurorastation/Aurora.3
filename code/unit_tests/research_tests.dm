// SSresearch related unit tests
/datum/unit_test/research
	name = "RESEARCH template"
	async = 0

/datum/unit_test/research/check_origin_tech_valid
	name = "RESEARCH: All origin techs shall be valid"

/datum/unit_test/research/check_origin_tech_valid/start_test()
	var/list/obj/objects = subtypesof(/obj)
	var/failed_count = 0

	for(var/object in objects)
		var/obj/O = new object
		if(isnull(O.origin_tech))
			continue
		if(!islist(O.origin_tech))
			testing("[O] has a non-list origin-tech [O.origin_tech]")
			log_unit_test("[ascii_red]--------------- [O] has a non-list origin-tech [O.origin_tech].")
			failed_count++
			continue
		for(var/tech in O.origin_tech)
			if(!(tech in ALL_ORIGIN_TECHS))
				log_unit_test("[ascii_red]--------------- [O] has invalid origin_tech - [tech].")
				failed_count++
			if(!isnum(O.origin_tech[tech]))
				log_unit_test("[ascii_red]--------------- [O] has invalid origin_tech value - [tech] = [O.origin_tech[tech]].")
				failed_count++

	testing("Checked [length(objects)] objects and found [failed_count] problems")
	if(failed_count)
		fail("[failed_count] invalid origin_tech\s found.")
	else
		pass("All objs have valid origin_tech.")

	return TRUE