
// ------------------------------ automatic tag groups
var/list/tag_group_department = list(
	DEPARTMENT_COMMAND,
	DEPARTMENT_COMMAND_SUPPORT,
	DEPARTMENT_SECURITY,
	DEPARTMENT_ENGINEERING,
	DEPARTMENT_MEDICAL,
	DEPARTMENT_SCIENCE,
	DEPARTMENT_CARGO,
	DEPARTMENT_SERVICE,
)
var/list/tag_group_corp = list(
	"Stellar Corporate Conglomerate", // as anyone can take SCC items, this tag needs to be manually added
	"Hephaestus Industries",
	"Idris Incorporated",
	"NanoTrasen",
	"Orion Express",
	"Private Military Contracting Group",
	"Zavodskoi Interstellar",
	"Zeng-Hu Pharmaceuticals",
)
var/list/tag_group_slot = list() // filled below
var/list/tag_group_size = list("Tiny", "Small", "Normal", "Large", "Huge")
var/list/tag_group_species = list("Human", "Skrell", "Tajara", "Unathi", "Diona", "Vaurca", "IPC")

// ------------------------------ manual/automatic tag groups
var/list/tag_group_other = list( // (manual tags need to be manually added to the item like `tags = list("Toy")`)
	"Augment",	// manual
	"Computer",	// manual
	"Cosmetic",	// manual
	"Religion",	// manual
	"Smoking",	// manual
	"Toy",		// manual
	"Utility",	// manual
	// any other new special tags should be added here
)

// ------------------------------ all tag groups
#define TAG_GROUP_DEPT "Department restriction tags"
#define TAG_GROUP_CORP "Corporation tags"
#define TAG_GROUP_SLOT "Item slot tags"
#define TAG_GROUP_SIZE "Item size tags"
#define TAG_GROUP_SPECIES "Species restriction tags"
#define TAG_GROUP_OTHER "Other tags"
var/list/tag_groups_all = list(
	TAG_GROUP_DEPT = tag_group_department,
	TAG_GROUP_CORP = tag_group_corp,
	TAG_GROUP_SLOT = tag_group_slot,
	TAG_GROUP_SIZE = tag_group_size,
	TAG_GROUP_SPECIES = tag_group_species,
	TAG_GROUP_OTHER = tag_group_other,
)

// ------------------------------ functions

/proc/slot_to_string(var/slot)
	switch (slot)
		if(slot_wear_mask)
			return "Mask"
		if(slot_belt)
			return "Belt"
		if(slot_glasses)
			return "Glasses"
		if(slot_gloves)
			return "Gloves"
		if(slot_head)
			return "Head"
		if(slot_shoes)
			return "Shoes"
		if(slot_wear_suit)
			return "Suits/Overwear"
		if(slot_w_uniform)
			return "Uniform"
		if(slot_in_backpack)
			return "?Slot-in-backpack?"
		if(slot_r_ear)
			return "Ears"
		if(slot_tie)
			return "Accessory"
		if(slot_wrists)
			return "Wrists"
		else
			return null

/proc/w_class_to_string(var/w_class)
	switch(w_class)
		if(ITEMSIZE_TINY)
			return "Tiny"
		if(ITEMSIZE_SMALL)
			return "Small"
		if(ITEMSIZE_NORMAL)
			return "Normal"
		if(ITEMSIZE_LARGE)
			return "Large"
		if(ITEMSIZE_HUGE)
			return "Huge"
		if(ITEMSIZE_IMMENSE)
			return "Immense"
		else
			return null

/proc/fill_automatic_tags_on_item(var/datum/gear/gear)
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
				gear.tags |= department
				break
	// ---- tag_group_corp
	if(gear.faction)
		gear.tags |= gear.faction
	// ---- tag_group_slot
	if(gear.slot)
		var/s = slot_to_string(gear.slot)
		if(s)
			tag_group_slot |= s
			gear.tags |= s
	// ---- tag_group_size
	var/list/paths = gear.get_paths()
	for(var/path in paths)
		var/obj/item/item = new path
		var/size = w_class_to_string(item.w_class)
		gear.tags |= size
		tag_group_size |= size
	// ---- tag_group_species
	for(var/tag in tag_group_species)
		for(var/specie in gear.whitelisted)
			if(findtext(specie, tag))
				gear.tags |= tag
			if(findtext(specie, "Frame"))
				gear.tags |= "IPC"
	// ---- tagless tag, shouldn't happen ever, but kept as a failsafe
	if(gear.tags.len == 0)
		tag_group_other |= "tagless"
		gear.tags |= "tagless"

// ------------------------------
