/var/global/datum/controller/subsystem/law/SSlaw

/datum/controller/subsystem/law
	name = "Law"
	flags = SS_NO_FIRE

	var/list/laws = list() // All laws
	var/list/low_severity = list()
	var/list/med_severity = list()
	var/list/high_severity = list()

/datum/controller/subsystem/law/New()
	NEW_SS_GLOBAL(SSlaw)

/datum/controller/subsystem/law/Initialize(timeofday)
	if(config.sql_enabled)
		load_from_sql()
	else
		load_from_code()

	laws = low_severity + med_severity + high_severity

/datum/controller/subsystem/law/proc/load_from_code()
	for (var/L in subtypesof(/datum/law/low_severity))
		low_severity += new L

	for (var/L in subtypesof(/datum/law/med_severity))
		med_severity += new L

	for (var/L in subtypesof(/datum/law/high_severity))
		high_severity += new L

/datum/controller/subsystem/law/proc/load_from_sql()
	if(!establish_db_connection(dbcon))
		log_debug("SSlaw: SQL ERROR - Failed to connect.")
		return load_from_code()
	
	var/DBQuery/law_query = dbcon.NewQuery("SELECT law_id, name, description, min_fine, max_fine, min_brig_time, max_brig_time, severity, felony FROM ss13_law WHERE deleted_at IS NULL ORDER BY law_id ASC")
	law_query.Execute()
	while(law_query.NextRow())
		CHECK_TICK
		try
			var/datum/law/L = new
			L.id = law_query.item[1]
			L.name = law_query.item[2]
			L.description = law_query.item[3]
			L.min_fine = text2num(law_query.item[4])
			L.max_fine = text2num(law_query.item[5])
			L.min_brig_time = text2num(law_query.item[6])
			L.max_brig_time = text2num(law_query.item[7])
			L.severity = text2num(law_query.item[8])
			L.felony = text2num(law_query.item[9])
		catch(var/exception/el)
			log_debug("SSlaw: Error when loading law: [el]")