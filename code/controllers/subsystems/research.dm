/var/datum/controller/subsystem/research/SSresearch

/datum/controller/subsystem/research
	name = "Research"
	wait = 10 MINUTES // auto saves every 10 minutes
	init_order = SS_INIT_MISC
	var/list/concepts
	var/points = 0
	var/daysuntilreset = 30
	var/list/rdconsoles
	
/datum/controller/subsystem/research/New()
	NEW_SS_GLOBAL(SSresearch)

/datum/controller/subsystem/research/Initialize()
	. = ..()
	load_from_sql()

/datum/controller/subsystem/research/proc/load_from_sql()
	if(!establish_db_connection(dbcon))
		can_fire = FALSE
		flags |= SS_NO_FIRE
		log_debug("Unable to establish a database connection! Research done might not be saved!")
		return
	//load the points
	var/DBQuery/loadpoints = dbcon.NewQuery("SELECT points, daysuntilreset FROM ss13_research_data ORDER BY created_at DESC LIMIT 0,1")
	loadpoints.Execute()
	points = loadpoints.item[1]
	daysuntilreset = loadpoints.item[2]
	//load the concepts
	var/DBQuery/loadconcepts = dbcon.NewQuery("SELECT id, level, progress FROM ss13_research_concepts WHERE deleted_at IS NULL ORDER BY order_by")
	init_subtypes(/datum/research_concepts, concepts)
	loadconcepts.Execute()
	while(loadconcepts.NextRow())
		for(var/datum/research_concepts/A in concepts)
			if(A.id == loadconcepts.item[1])
				A.level = loadpoints.item[2]
				A.progress = loadpoints.item[3]
	
/datum/controller/subsystem/research/fire()
	var/DBQuery/update_points = dbcon.NewQuery("INSERT INTO ss13_research_data (round_id, points, daysuntilreset, created_at, updated_at) VALUES(:g:, :p:, :d:,NOW(), NOW()) ON DUPLICATE KEY UPDATE points=:p:, age=:d:, updated_at=NOW()")
	update_points.Execute(list("p" = points, "d" = daysuntilreset, "g" = game_id))
