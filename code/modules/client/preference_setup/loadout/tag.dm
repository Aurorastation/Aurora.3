



// ------------------------------ automatic tag groups

var/list/tag_group_department = list(DEPARTMENT_COMMAND, DEPARTMENT_COMMAND_SUPPORT, DEPARTMENT_SECURITY, DEPARTMENT_ENGINEERING, DEPARTMENT_MEDICAL, DEPARTMENT_SCIENCE, DEPARTMENT_CARGO, DEPARTMENT_SERVICE)
var/list/tag_group_slot = list()

// ------------------------------ manual tag groups



// ------------------------------ add automatic tags to item

proc/fill_automatic_tags_on_item(var/datum/gear/gear)
	// ---- tag_group_department
	var/list/departments_and_jobs = list(
		DEPARTMENT_COMMAND = command_positions,
		DEPARTMENT_COMMAND_SUPPORT = command_support_positions,
		DEPARTMENT_SECURITY = security_positions,
		DEPARTMENT_ENGINEERING = engineering_positions,
		DEPARTMENT_MEDICAL = medical_positions,
		DEPARTMENT_SCIENCE = science_positions,
		DEPARTMENT_CARGO = cargo_positions,
		DEPARTMENT_SERVICE = service_positions
	)
	for(var/department in departments_and_jobs)
		for(var/position in departments_and_jobs[department])
			if(position in gear.allowed_roles)
				gear.tags += department
				break
	// ----
	// ----
	// ----
	// ---- tagless tag
	if(gear.tags.len == 0)
		gear.tags += "tagless"
