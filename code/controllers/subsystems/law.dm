SUBSYSTEM_DEF(law)
	name = "Law"
	flags = SS_NO_FIRE

	var/list/laws = list() // All laws
	var/list/low_severity = list()
	var/list/med_severity = list()
	var/list/high_severity = list()

/datum/controller/subsystem/law/Initialize(timeofday)
	if(GLOB.config.sql_enabled)
		load_from_sql()
	else
		load_from_code()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/law/proc/load_from_code()
	for (var/L in subtypesof(/datum/law/low_severity))
		low_severity += new L

	for (var/L in subtypesof(/datum/law/med_severity))
		med_severity += new L

	for (var/L in subtypesof(/datum/law/high_severity))
		high_severity += new L

	laws = low_severity + med_severity + high_severity

/datum/controller/subsystem/law/proc/load_from_sql()
	if(!establish_db_connection(GLOB.dbcon))
		log_subsystem_law("SQL ERROR - Failed to connect.")
		return load_from_code()

	var/DBQuery/law_query = GLOB.dbcon.NewQuery("SELECT law_id, name, description, min_fine, max_fine, min_brig_time, max_brig_time, severity, felony FROM ss13_law WHERE deleted_at IS NULL ORDER BY law_id ASC")
	law_query.Execute()
	while(law_query.NextRow())
		CHECK_TICK
		try
			var/datum/law/L = new
			L.id = law_query.item[1]
			L.name = law_query.item[2]
			L.desc = law_query.item[3]
			L.min_fine = text2num(law_query.item[4])
			L.max_fine = text2num(law_query.item[5])
			L.min_brig_time = text2num(law_query.item[6])
			L.max_brig_time = text2num(law_query.item[7])
			L.severity = text2num(law_query.item[8])
			L.felony = text2num(law_query.item[9])

			if(L.severity == 1)
				low_severity += L
			else if(L.severity == 2)
				med_severity += L
			else if(L.severity == 3)
				high_severity += L
			else
				throw("Law with id: [L.id] deleted due to invalid severity: [L.severity]")
				qdel(L)
		catch(var/exception/el)
			log_subsystem_law("Error when loading law: [el]")

	laws = low_severity + med_severity + high_severity
	if(!laws.len)
		log_subsystem_law("No laws loaded. Loading from code and migrating to SQL")
		load_from_code()
		migrate_to_sql()

/datum/controller/subsystem/law/proc/migrate_to_sql()
	for(var/datum/law/L in laws)
		log_subsystem_law("Migrating law [L.id] to SQL")
		var/DBQuery/law_update_query = GLOB.dbcon.NewQuery({"
		INSERT IGNORE INTO ss13_law
			(law_id, name, description, min_fine, max_fine, min_brig_time, max_brig_time, severity, felony)
		VALUES
			(:law_id:, :name:, :desc:, :min_fine:, :max_fine:, :min_brig_time:, :max_brig_time:, :severity:, :felony:)
		"})
		law_update_query.Execute(list(
			"law_id"=L.id,
			"name"=L.name,
			"desc"=L.desc,
			"min_fine"=L.min_fine,
			"max_fine"=L.max_fine,
			"min_brig_time"=L.min_brig_time,
			"max_brig_time"=L.max_brig_time,
			"severity"=L.severity,
			"felony"=L.felony
			))
	return
