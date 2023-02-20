



// ------------------------------ automatic tag groups
var/list/tag_group_department = list(DEPARTMENT_COMMAND, DEPARTMENT_COMMAND_SUPPORT, DEPARTMENT_SECURITY, DEPARTMENT_ENGINEERING, DEPARTMENT_MEDICAL, DEPARTMENT_SCIENCE, DEPARTMENT_CARGO, DEPARTMENT_SERVICE)
var/list/tag_group_corp = list("Idris Incorporated", "Zavodskoi Interstellar", "Private Military Contracting Group", "Zeng-Hu Pharmaceuticals", "Hephaestus Industries", "NanoTrasen", "Orion Express")
var/list/tag_group_slot = list()

// ------------------------------ manual tag groups
var/list/tag_group_other = list("Toys", "tagless")

// ------------------------------ all tag groups
var/list/tag_groups_all = list(
	"Department tags" = tag_group_department,
	"Corp tags" = tag_group_corp,
	"Slot tags" = tag_group_slot,
	"Other tags" = tag_group_other,
)

// ------------------------------
proc/grab_manual_tags_from_item(var/datum/gear/gear)
	// for(var/tag in gear.tags)
		// var/found = FALSE
		// for(var/group_name in tag_groups_all)
		// 	var/list/group_list = tag_groups_all[group_name]
		// 	for(var/tag_in_group in group_list)
		// 		if(tag in tag_in_group)
		// 			found = TRUE
		// 			break
		// if(!found)
			// tag_group_other |= tag

// ------------------------------
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
	// ---- tag_group_corp
	if(gear.faction)
		gear.tags += gear.faction
	// ---- tag_group_slot
	// ----
	// ---- dedup
	// ---- tagless tag
	if(gear.tags.len == 0)
		gear.tags += "tagless"

// ------------------------------
