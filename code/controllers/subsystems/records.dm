/var/datum/controller/subsystem/records/SSrecords

/datum/controller/subsystem/records
	name = "Records"
	flags = SS_NO_FIRE

	var/list/records
	var/list/records_locked

	var/list/warrants
	var/list/viruses

	var/list/excluded_fields
	var/list/localized_fields

	var/manifest_json
	var/list/list/manifest

	var/list/citizenships = list()
	var/list/religions = list()

/datum/controller/subsystem/records/Initialize()
	..()
	for(var/type in localized_fields)
		localized_fields[type] = compute_localized_field(type)

	InitializeCitizenships()
	InitializeReligions()

/datum/controller/subsystem/records/New()
	records = list()
	records_locked = list()
	warrants = list()
	viruses = list()
	excluded_fields = list()
	localized_fields = list()
	manifest = list()
	NEW_SS_GLOBAL(SSrecords)
	var/datum/D = new()
	for(var/v in D.vars)
		excluded_fields[v] = v
	excluded_fields["cmp_field"] = "cmp_field"
	excluded_fields["excluded_fields"] = "excluded_fields"
	excluded_fields["excluded_print_fields"] = "excluded_print_fields"
	localized_fields[/datum/record] = list(
		"id" = "Id",
		"notes" = "Notes"
	)
	localized_fields[/datum/record/general] = list(
		"_parent" = /datum/record,
		"name" = "Name",
		"rank" = "Rank",
		"age" = "Age",
		"sex" = "Sex",
		"fingerprint" = "Fingerprint",
		"physical_status" = "Physical Status",
		"mental_status" = "Mental Status",
		"species" = "Species",
		"citizenship" = "Citizenship",
		"employer" = "",
		"religion" = "Religion",
		"ccia_record" = "CCIA Notes",
		"notes" = "Employment/skills summary",
	)
	localized_fields[/datum/record/medical] = list(
		"_parent" = /datum/record,
		"blood_type" = "Blood type",
		"blood_dna" = "DNA",
		"disabilities" = "Disabilities",
		"allergies" = "Allergies",
		"diseases" = "Diseases",
		"comments" = "Comments"
	)
	localized_fields[/datum/record/security] = list(
		"_parent" = /datum/record,
		"criminal" = "Criminal Status",
		"crimes" = "Crimes",
		"incidents" = "Incidents",
		"comments" = "Comments"
	)
	localized_fields[/datum/record/virus] = list(
		"_parent" = /datum/record,
		"description" = "Description",
		"antigen" = "",
		"spread_type" = "",
	)

/datum/controller/subsystem/records/proc/generate_record(var/mob/living/carbon/human/H)
	if(H.mind && SSjobs.ShouldCreateRecords(H.mind))
		var/datum/record/general/r = new(H)
		//Locked Data
		var/datum/record/general/l = r.Copy(new /datum/record/general/locked(H))
		add_record(l)
		add_record(r)

/datum/controller/subsystem/records/proc/add_record(var/datum/record/record)
	switch(record.type)
		if(/datum/record/general/locked)
			records_locked += record
		if(/datum/record/general)
			records += record
			reset_manifest()
		if(/datum/record/warrant)
			warrants += record
		if(/datum/record/virus)
			viruses += record

/datum/controller/subsystem/records/proc/update_record(var/datum/record/record)
	switch(record.type)
		if(/datum/record/general/locked)
			records_locked |= record
		if(/datum/record/general)
			records |= record
			reset_manifest()
		if(/datum/record/warrant)
			warrants |= record
		if(/datum/record/virus)
			viruses |= record
	onModify(record)

/datum/controller/subsystem/records/proc/remove_record(var/datum/record/record)
	switch(record.type)
		if(/datum/record/general/locked)
			records_locked -= record
		if(/datum/record/general)
			records -= record
			reset_manifest()
		if(/datum/record/warrant)
			warrants -= record
		if(/datum/record/virus)
			viruses *= record
	onDelete(record)
	qdel(record)

/datum/controller/subsystem/records/proc/remove_record_by_field(var/field, var/value, var/record_type = RECORD_GENERAL)
	. = find_record(field, value, record_type)
	if(.)
		remove_record(.)

/datum/controller/subsystem/records/proc/find_record(var/field, var/value, var/record_type = RECORD_GENERAL)
	if(excluded_fields[field])
		return
	var/searchedList = records
	if(record_type & RECORD_LOCKED)
		searchedList = records_locked
	if(record_type & RECORD_WARRANT)
		for(var/datum/record/warrant/r in warrants)
			if(r.excluded_fields[field])
				continue
			if(r.vars[field] == value)
				return r
		return
	if(record_type & RECORD_VIRUS)
		for(var/datum/record/virus/r in viruses)
			if(r.excluded_fields[field])
				continue
			if(r.vars[field] == value)
				return r
		return
	for(var/datum/record/general/r in searchedList)
		if(r.excluded_fields[field])
			continue
		if(record_type & RECORD_GENERAL)
			if(r.vars[field] == value)
				return r
		if(record_type & RECORD_MEDICAL)
			if(r.medical.vars[field] == value)
				return r
		if(record_type & RECORD_SECURITY)
			if(r.security.vars[field] == value)
				return r

/datum/controller/subsystem/records/proc/build_records()
	for(var/mob/living/carbon/human/H in player_list)
		generate_record(H)

/datum/controller/subsystem/records/proc/reset_manifest()
	manifest.Cut()

/datum/controller/subsystem/records/proc/get_manifest(var/monochrome = 0, var/OOC = 0)
	if(!manifest.len)
		get_manifest_json()
	var/dat = {"
	<head><style>
		.manifest {border-collapse:collapse;}
		.manifest td, th {border:1px solid [monochrome?"black":"#DEF; background-color:white; color:black"]; padding:.25em}
		.manifest th {height: 2em; [monochrome?"border-top-width: 3px":"background-color: #48C; color:white"]}
		.manifest tr.head th { [monochrome?"border-top-width: 1px":"background-color: #488;"] }
		.manifest td:first-child {text-align:right}
		.manifest tr.alt td {[monochrome?"border-top-width: 2px":"background-color: #DEF"]}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Rank</th><th>Activity</th></tr>
	"}
	var/even = 0
	var/list/isactive = new()
	for(var/mob/M in player_list)
		if (OOC)
			if(M.client && M.client.inactivity <= 10 * 60 * 10)
				isactive[M.real_name] = "Active"
			else
				isactive[M.real_name] = "Inactive"
		else
			isactive[M.real_name] = 0

	var/nameMap = list("heads" = "Heads", "sec" = "Security", "eng" = "Engineering", "med" = "Medical", "sci" = "Science", "car" = "Cargo", "civ" = "Civilian", "misc" = "Miscellaneous", "bot" = "Equipment")
	for(var/dep in manifest)
		var/list/depI = manifest[dep]
		if(depI.len > 0)
			dat += "<tr><th colspan=3>[nameMap[dep]]</th></tr>"
			for(var/list/item in depI)
				dat += "<tr[even ? " class='alt'" : ""]><td>[item["name"]]</td><td>[item["rank"]]</td><td>[isactive[item["name"]] ? isactive[item["name"]] : item["active"]]</td></tr>"
				even = !even
	dat += "</table>"
	dat = replacetext(dat, "\n", "") // so it can be placed on paper correctly
	dat = replacetext(dat, "\t", "")
	return dat

/datum/controller/subsystem/records/proc/get_manifest_json()
	if(manifest.len)
		return manifest_json
	manifest = list(
		"heads" = list(),
		"sec" = list(),
		"eng" = list(),
		"med" = list(),
		"sci" = list(),
		"car" = list(),
		"civ" = list(),
		"bot" = list(),
		"misc" = list()
	)
	var/positions = list(
		"heads" = command_positions,
		"sec" = security_positions,
		"eng" = engineering_positions,
		"med" = medical_positions,
		"sci" = science_positions,
		"car" = cargo_positions,
		"civ" = civilian_positions,
		"bot" = nonhuman_positions
	)
	for(var/datum/record/general/t in records)
		var/name = sanitize(t.name)
		var/rank = sanitize(t.rank)
		var/real_rank = make_list_rank(t.real_rank)

		var/isactive = t.physical_status
		var/department = 0
		var/depthead = 0            // Department Heads will be placed at the top of their lists.

		for(var/positionType in positions)
			var/typesPositions = positions[positionType]
			if(real_rank in typesPositions)
				manifest[positionType][++manifest[positionType].len] = list("name" = name, "rank" = rank, "active" = isactive)
				department = 1
				if ((depthead || rank == "Captain") && manifest[positionType].len != 1)
					manifest[positionType].Swap(1, manifest[positionType].len)
				if(positionType == "head")
					depthead = 1

		if(!department && !(name in manifest["heads"]))
			manifest["misc"][++manifest["misc"].len] = list("name" = name, "rank" = rank, "active" = isactive)

	for(var/mob/living/silicon/S in player_list)
		if(istype(S, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = S
			if(R.scrambled_codes)
				continue
			var/selected_module = "Default Module"
			if(R.module)
				selected_module = capitalize_first_letters(R.module.name)
			manifest["bot"][++manifest["bot"].len] = list("name" = sanitize(R.name), "rank" = selected_module, "active" = "Online")
		if(istype(S, /mob/living/silicon/ai))
			var/mob/living/silicon/ai/A = S
			manifest["bot"][++manifest["bot"].len] = list("name" = sanitize(A.name), "rank" = "Station Intelligence", "active" = "Online")
			if(manifest["bot"].len != 1)
				manifest["bot"].Swap(1, manifest["bot"].len)

	manifest_json = json_encode(manifest)
	return manifest_json

/datum/controller/subsystem/records/proc/onDelete(var/datum/record/r)
	for (var/listener in GET_LISTENERS("SSrecords"))
		var/listener/record/rl = listener
		if(istype(rl))
			rl.on_delete(r)

/datum/controller/subsystem/records/proc/onModify(var/datum/record/r)
	if(r in records)
		reset_manifest()
	for (var/listener in GET_LISTENERS("SSrecords"))
		var/listener/record/rl = listener
		if(istype(rl))
			rl.on_modify(r)

/*
 * Helping functions for everyone
 */
/proc/GetAssignment(var/mob/living/carbon/human/H)
	if(H.mind?.role_alt_title)
		return H.mind.role_alt_title
	else if(H.mind?.assigned_role)
		return H.mind.assigned_role
	else if(H.job)
		return H.job
	else
		return "Unassigned"

/proc/generate_record_id()
	return add_zero(num2hex(rand(1, 65535)), 4)


/datum/controller/subsystem/records/proc/InitializeCitizenships()
	for (var/type in subtypesof(/datum/citizenship))
		var/datum/citizenship/citizenship = new type()

		citizenships[citizenship.name] = citizenship

	if (!citizenships.len)
		crash_with("No citizenships located in SSrecords.")

/datum/controller/subsystem/records/proc/InitializeReligions()
	for (var/type in subtypesof(/datum/religion))
		var/datum/religion/religion = new type()

		religions[religion.name] = religion

	if (!religions.len)
		crash_with("No citizenships located in SSrecords.")

/datum/controller/subsystem/records/proc/get_religion_record_name(var/target_religion)
	var/datum/religion/religion = SSrecords.religions[target_religion]
	if(religion)
		return religion.get_records_name()

/datum/controller/subsystem/records/proc/compute_localized_field(var/type)
	if(!localized_fields[type])
		return
	if(localized_fields[type]["_parent"])
		. = compute_localized_field(localized_fields[type]["_parent"])
	else
		. = list()

	for(var/field in localized_fields[type])
		if(field == "_parent")
			continue
		var/value = localized_fields[type][field]
		//if(istype(value))
		//	.[field] = compute_localized_field(value)
		//	continue
		.[field] = value
