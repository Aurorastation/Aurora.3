
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
	"Idris Incorporated",
	"Zavodskoi Interstellar",
	"Private Military Contracting Group",
	"Zeng-Hu Pharmaceuticals",
	"Hephaestus Industries",
	"NanoTrasen",
	"Orion Express",
	"Stellar Corporate Conglomerate", // as anyone can take SCC items, this tag needs to be manually added
)
var/list/tag_group_slot = list() // filled below
var/list/tag_group_size = list("Tiny", "Small", "Normal", "Large", "Huge") // filled below
var/list/tag_group_species = list("Human", "IPC", "Skrell", "Unathi", "Tajara", "Diona", "Vaurca")

// ------------------------------ manual/automatic tag groups
var/list/tag_group_other = list( // (manual tags need to be manually added to the item like `tags = list("Toy")`)
	"Toy",		// manual
	"Smoking",	// manual
	"Religion",	// manual
	"Augment",	// manual
	"Computer",	// manual
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
/proc/grab_manual_tags_from_item(var/datum/gear/gear)
	// this grabs any tags from an item
	// that are not already present in the tag groups
	// and adds them to tag_group_other
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

/proc/slot_to_string(var/slot)
	switch (slot)
		if(slot_wear_mask)
			return "Mask"
		if(slot_belt)
			return "Belt"
		if(slot_glasses)
			return "Glasses"
		if(slot_gloves)
			return "Glove"
		if(slot_head)
			return "Head"
		if(slot_shoes)
			return "Shoe"
		if(slot_wear_suit)
			return "Suit/overwear"
		if(slot_w_uniform)
			return "Uniform"
		if(slot_in_backpack)
			return "Slot-in-backpack"
		if(slot_r_ear)
			return "Ear"
		if(slot_tie)
			return "Accessory"
		if(slot_wrists)
			return "Wrist"
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
	// ---- dedup
	// ---- tagless tag, shouldn't happen ever, but kept as a failsafe
	if(gear.tags.len == 0)
		tag_group_other |= "tagless"
		gear.tags |= "tagless"

// ------------------------------
