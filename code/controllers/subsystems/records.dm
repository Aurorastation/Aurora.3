SUBSYSTEM_DEF(records)
	name = "Records"
	flags = SS_NO_FIRE

	var/list/records
	var/list/records_locked

	var/list/warrants
	var/list/viruses
	var/list/shuttle_manifests

	var/list/excluded_fields
	var/list/localized_fields

	var/manifest_json
	var/list/list/manifest

	var/list/citizenships = list()
	var/list/religions = list()
	var/list/accents = list()

/datum/controller/subsystem/records/Initialize()
	for(var/type in localized_fields)
		localized_fields[type] = compute_localized_field(type)

	InitializeCitizenships()
	InitializeReligions()
	InitializeAccents()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/records/PreInit()
	records = list()
	records_locked = list()
	warrants = list()
	viruses = list()
	shuttle_manifests = list()
	excluded_fields = list()
	localized_fields = list()
	manifest = list()
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
		if(/datum/record/shuttle_manifest)
			shuttle_manifests += record
	onCreate(record)

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
		if(/datum/record/shuttle_manifest)
			shuttle_manifests |= record
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
		if(/datum/record/shuttle_manifest)
			shuttle_manifests -= record
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
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		generate_record(H)

/datum/controller/subsystem/records/proc/reset_manifest()
	manifest.Cut()
	update_static_data_for_all_viewers()

/datum/controller/subsystem/records/ui_state(mob/user)
	return always_state

/datum/controller/subsystem/records/ui_status(mob/user, datum/ui_state/state)
	return (isnewplayer(user) || isobserver(user) || issilicon(user)) ? UI_INTERACTIVE : UI_CLOSE

/datum/controller/subsystem/records/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "follow")
		var/mob/abstract/observer/O = usr
		if(istype(O))
			for(var/mob/living/M in GLOB.human_mob_list)
				if(istype(M) && M.real_name == params["name"])
					O.ManualFollow(M)
					break
	. = ..()

/datum/controller/subsystem/records/ui_static_data(mob/user)
	var/list/data = list()
	data["manifest"] = SSrecords.get_manifest_list()
	data["allow_follow"] = isobserver(usr)
	return data

/datum/controller/subsystem/records/proc/open_manifest_tgui(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CrewManifest", "Crew Manifest")
		ui.open()

/datum/controller/subsystem/records/proc/get_manifest_text()
	var/dat = "<h2>Crew Manifest</h2><em>as of [worlddate2text()] [worldtime2text()]</em>"
	var/manifest = get_manifest_list()
	for(var/dep in manifest)
		var/list/depI = manifest[dep]
		if(depI.len > 0)
			var/depDat
			for(var/list/item in depI)
				depDat += "<li><strong>[item["name"]]</strong> - [item["rank"]] ([item["active"]])</li>"
			dat += "<h3>[dep]</h3><ul>[depDat]</ul>"
	return dat

/datum/controller/subsystem/records/proc/get_manifest_list()
	if(manifest.len)
		return manifest
	if(!SSjobs)
		log_world("ERROR: SSjobs not available, cannot build manifest")
		return
	manifest = DEPARTMENTS_LIST_INIT
	for(var/datum/record/general/t in records)
		var/name = sanitize(t.name, encode = FALSE)
		var/rank = sanitize(t.rank, encode = FALSE)
		var/real_rank = make_list_rank(t.real_rank)

		var/datum/job/job = SSjobs.GetJob(real_rank)
		var/isactive = t.physical_status

		var/list/departments
		if(istype(job) && job.departments.len > 0 && all_in_list(job.departments, manifest))
			departments = job.departments
		else // no department set or there's something weird
			departments = list(DEPARTMENT_MISCELLANEOUS = JOBROLE_DEFAULT)

		for(var/department in departments) // add them to their departments
			var/supervisor = departments[department] & JOBROLE_SUPERVISOR
			manifest[department][++manifest[department].len] = list("name" = name, "rank" = rank, "active" = isactive, "head" = supervisor)
			if(supervisor) // they are a supervisor/head, put them on top
				manifest[department].Swap(1, manifest[department].len)

	// silicons are not in records, we need to add them manually
	var/dept = DEPARTMENT_EQUIPMENT
	for(var/mob/living/silicon/S in GLOB.player_list)
		if(istype(S, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = S
			if(R.scrambled_codes)
				continue
			var/selected_module = "Default Module"
			if(R.module)
				selected_module = capitalize_first_letters(R.module.name)
			manifest[dept][++manifest[dept].len] = list("name" = sanitize(R.name), "rank" = selected_module, "active" = "Online", "head" = FALSE)
		else if(istype(S, /mob/living/silicon/ai))
			var/mob/living/silicon/ai/A = S
			manifest[dept][++manifest[dept].len] = list("name" = sanitize(A.name), "rank" = "Station Intelligence", "active" = "Online", "head" = TRUE)
			manifest[dept].Swap(1, manifest[dept].len)

	for(var/department in manifest)
		if(!length(manifest[department]))
			manifest -= department

	manifest_json = json_encode(manifest)
	return manifest

/datum/controller/subsystem/records/proc/get_manifest_json()
	if(manifest.len)
		return manifest_json

	get_manifest_list()
	return manifest_json

/datum/controller/subsystem/records/proc/onCreate(var/datum/record/record)
	SEND_SIGNAL(src, COMSIG_RECORD_CREATED, record)

/datum/controller/subsystem/records/proc/onDelete(var/datum/record/record)
	for (var/listener in GET_LISTENERS("SSrecords"))
		var/listener/record/record_listener = listener
		if(istype(record_listener))
			record_listener.on_delete(record)

/datum/controller/subsystem/records/proc/onModify(var/datum/record/record)
	if(record in records)
		reset_manifest()
	SEND_SIGNAL(record, COMSIG_RECORD_MODIFIED)
	for (var/listener in GET_LISTENERS("SSrecords"))
		var/listener/record/record_listener = listener
		if(istype(record_listener))
			record_listener.on_modify(record)

/*
 * Helping functions for everyone
 */
/proc/GetAssignment(var/mob/living/carbon/human/H, var/include_faction_prefix)
	var/return_value = "Unassigned"
	if(H.mind?.role_alt_title)
		return_value = H.mind.role_alt_title
	else if(H.mind?.assigned_role)
		return_value = H.mind.assigned_role
	else if(H.job)
		return_value = H.job
	return "[return_value][include_faction_prefix ? " ([H.mind.selected_faction.title_suffix])" : ""]"

/proc/generate_record_id()
	return num2hex(rand(1, 65535), 4)

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

/datum/controller/subsystem/records/proc/InitializeAccents()
	for (var/type in subtypesof(/datum/accent))
		var/datum/accent/accent = new type()

		accents[accent.name] = accent

	if (!accents.len)
		crash_with("No accents located in SSrecords.")


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
