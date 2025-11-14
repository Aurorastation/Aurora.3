//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//returns 1 if this mob has sufficient access to use this object
/obj/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(src.check_access(null))
		return 1

	var/id = M.GetIdCard()
	if(id)
		return check_access(id)
	return 0

/obj/item/proc/GetAccess()
	var/obj/item/card/id = GetID()
	return istype(id) ? id.GetAccess() : list()

/obj/proc/GetID()
	return null

/obj/proc/check_access(obj/item/I)
	return check_access_list(I ? I.GetAccess() : list())

/obj/proc/check_access_list(var/list/L)
	if(!islist(L))
		return 0
	return has_access(req_access, req_one_access, L)

/proc/has_access(var/list/req_access, var/list/req_one_access, var/list/accesses)
	for(var/req in req_access)
		if(!(req in accesses)) //doesn't have this access
			return 0
	if(LAZYLEN(req_one_access))
		for(var/req in req_one_access)
			if(req in accesses) //has an access from the single access list
				return 1
		return 0
	return 1

/proc/get_centcom_access(job)
	switch(job)
		if("SCC Agent", "SCC Executive", "SCC Bodyguard")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_CCIA, ACCESS_CENT_SPECOPS)
		if("CCIA Agent")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_CCIA, ACCESS_CENT_SPECOPS)
		if("Emergency Response Team")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING)
		if("Odin Security")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING)
		if("Medical Doctor")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_MEDICAL)
		if("Service")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING)
		if("Death Commando")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE, ACCESS_CENT_MEDICAL)
		if("BlackOps Commander")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_THUNDER, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE, ACCESS_CENT_CREED)
		if("NanoTrasen Representative") //Adminspawn roles
			return get_all_centcom_access()
		if("Supreme Commander")
			return get_all_centcom_access()

	LOG_DEBUG("Invalid job [job] passed to get_centcom_access")
	return list()

/proc/get_syndicate_access(job)
	switch(job)
		if("Syndicate Operative")
			return list(ACCESS_SYNDICATE)
		if("Syndicate Operative Leader")
			return list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
		if("Syndicate Agent")
			return list(ACCESS_SYNDICATE, ACCESS_MAINT_TUNNELS)
		if("Syndicate Commando")
			return list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	LOG_DEBUG("Invalid job [job] passed to get_syndicate_access")
	return list()

/proc/get_distress_access()
	return list(ACCESS_LEGION, ACCESS_DISTRESS, ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_SECURITY, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_MEDICAL, ACCESS_RESEARCH, ACCESS_ATMOSPHERICS, ACCESS_MEDICAL_EQUIP, ACCESS_CONSTRUCTION)

/proc/get_distress_access_lesser()
	return list(ACCESS_DISTRESS, ACCESS_EXTERNAL_AIRLOCKS)

GLOBAL_LIST_INIT_TYPED(priv_all_access_datums, /datum/access, null)
/proc/get_all_access_datums()
	if(!GLOB.priv_all_access_datums)
		GLOB.priv_all_access_datums = init_subtypes(/datum/access)
		sortTim(GLOB.priv_all_access_datums, GLOBAL_PROC_REF(cmp_access), FALSE)

	return GLOB.priv_all_access_datums

GLOBAL_LIST_INIT_TYPED(priv_all_access_datums_id, /datum/access, null)
/proc/get_all_access_datums_by_id()
	if(!GLOB.priv_all_access_datums_id)
		GLOB.priv_all_access_datums_id = list()
		for(var/datum/access/A in get_all_access_datums())
			GLOB.priv_all_access_datums_id["[A.id]"] = A

	return GLOB.priv_all_access_datums_id

GLOBAL_LIST_INIT_TYPED(priv_all_access_datums_region, /datum/access, null)
/proc/get_all_access_datums_by_region()
	if(!GLOB.priv_all_access_datums_region)
		GLOB.priv_all_access_datums_region = list()
		for(var/datum/access/A in get_all_access_datums())
			if(!GLOB.priv_all_access_datums_region[A.region])
				GLOB.priv_all_access_datums_region[A.region] = list()
			GLOB.priv_all_access_datums_region[A.region] += A

	return GLOB.priv_all_access_datums_region

/proc/get_access_ids(var/access_types = ACCESS_TYPE_ALL)
	var/list/L = new()
	for(var/datum/access/A in get_all_access_datums())
		if(A.access_type & access_types)
			L += A.id
	return L

GLOBAL_LIST(priv_all_access)
/proc/get_all_accesses()
	if(!GLOB.priv_all_access)
		GLOB.priv_all_access = get_access_ids()

	return GLOB.priv_all_access.Copy()

GLOBAL_LIST(priv_station_access)
/proc/get_all_station_access()
	if(!GLOB.priv_station_access)
		GLOB.priv_station_access = get_access_ids(ACCESS_TYPE_STATION)

	return GLOB.priv_station_access.Copy()

GLOBAL_LIST(priv_centcom_access)
/proc/get_all_centcom_access()
	if(!GLOB.priv_centcom_access)
		GLOB.priv_centcom_access = get_access_ids(ACCESS_TYPE_CENTCOM)

	return GLOB.priv_centcom_access.Copy()

GLOBAL_LIST(priv_syndicate_access)
/proc/get_all_syndicate_access()
	if(!GLOB.priv_syndicate_access)
		GLOB.priv_syndicate_access = get_access_ids(ACCESS_TYPE_SYNDICATE)

	return GLOB.priv_syndicate_access.Copy()

GLOBAL_LIST(priv_region_access)
/proc/get_region_accesses(var/code)
	if(code == ACCESS_REGION_ALL)
		return get_all_station_access()

	if(!GLOB.priv_region_access)
		GLOB.priv_region_access = list()
		for(var/datum/access/A in get_all_access_datums())
			if(!GLOB.priv_region_access["[A.region]"])
				GLOB.priv_region_access["[A.region]"] = list()
			GLOB.priv_region_access["[A.region]"] += A.id

	return GLOB.priv_region_access["[code]"]

/proc/get_region_accesses_name(var/code)
	switch(code)
		if(ACCESS_REGION_ALL)
			return "All"
		if(ACCESS_REGION_SECURITY) //security
			return "Security"
		if(ACCESS_REGION_MEDBAY) //medbay
			return "Medbay"
		if(ACCESS_REGION_RESEARCH) //research
			return "Research"
		if(ACCESS_REGION_ENGINEERING) //engineering and maintenance
			return "Engineering"
		if(ACCESS_REGION_COMMAND) //command
			return "Command"
		if(ACCESS_REGION_GENERAL) //station general
			return "Station General"
		if(ACCESS_REGION_SUPPLY) //supply
			return "Operations"

/proc/get_access_desc(id)
	var/list/AS = get_all_access_datums_by_id()
	var/datum/access/A = AS["[id]"]

	return A ? A.desc : ""

/proc/get_centcom_access_desc(A)
	return get_access_desc(A)

/proc/get_all_jobs()
	var/list/all_jobs = list()
	var/list/all_datums = typesof(/datum/job)
	all_datums -= GLOB.exclude_jobs
	var/datum/job/jobdatum
	for(var/jobtype in all_datums)
		jobdatum = new jobtype
		all_jobs.Add(jobdatum.title)
	return all_jobs

/proc/get_all_centcom_jobs()
	return list("NanoTrasen Representative",
		"NanoTrasen Navy Officer",
		"NanoTrasen Navy Captain",
		"ERT Protection Detail",
		"ERT Commander",
		"Bluespace Technician",
		"CCIA Agent",
		"CCIA Escort",
		"Odin Checkpoint Security",
		"Odin Security",
		"Aurora Prepatory Wing Security",
		"Odin Medical Doctor",
		"Odin Pharmacist",
		"Odin Chef",
		"Odin Bartender",
		"Sanitation Specialist",
		"Emergency Response Team",
		"Emergency Response Team Leader",
		"Emergency Responder",
		"Death Commando")

/mob/proc/GetIdCard()
	return null

GLOBAL_LIST_INIT_TYPED(ghost_all_access, /obj/item/card/id/all_access, list())
/mob/abstract/ghost/observer/GetIdCard()
	if(!is_admin(src))
		return

	if(!GLOB.ghost_all_access)
		GLOB.ghost_all_access = new()
	return GLOB.ghost_all_access

/mob/living/bot/GetIdCard()
	return botcard

/mob/living/simple_animal/spiderbot/GetIdCard()
	return internal_id

/mob/living/carbon/human/GetIdCard(var/ignore_hand = FALSE)
	var/obj/item/I = get_active_hand()
	if(I && !ignore_hand)
		var/id = I.GetID()
		if(id)
			return id
	if(wear_id)
		var/id = wear_id.GetID()
		if(id)
			return id
	if(wrists)
		var/id = wrists.GetID()
		if(id)
			return id

/mob/living/silicon/GetIdCard()
	return id_card

/proc/FindNameFromID(var/mob/M, var/missing_id_name = "Unknown")
	var/obj/item/card/id/C = M.GetIdCard()
	if(C)
		return C.registered_name
	return missing_id_name

/proc/get_all_job_icons() //For all existing HUD icons
	return GLOB.joblist + list("Prisoner")

/obj/proc/GetJobName() //Used in secHUD icon generation
	var/obj/item/card/id/I = GetID()

	if(I)
		var/job_icons = get_all_job_icons()
		if(I.assignment	in job_icons) //Check if the job has a hud icon
			return I.assignment
		if(I.rank in job_icons)
			return I.rank

		var/centcom = get_all_centcom_jobs()
		if(I.assignment	in centcom) //Return with the NT logo if it is a Centcom job
			return "Centcom"
		if(I.rank in centcom)
			return "Centcom"
	else
		return

	return "Unknown" //Return unknown if none of the above apply
