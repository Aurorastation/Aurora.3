/var/datum/controller/subsystem/research/SSresearch

/datum/controller/subsystem/research
	name = "Research"
	wait = 10 MINUTES // auto saves every 10 minutes
	init_order = SS_INIT_MISC
	var/list/concepts
	var/points = 1
	var/daysuntilreset = 30
	var/list/rdconsoles
	var/list/techitems
	var/list/unlockeditems
	var/list/lockeditems
	var/obj/machinery/computer/masterconsole/masterconsole

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
	load_conceptsanditems()
	//load the points
	var/DBQuery/loadpoints = dbcon.NewQuery("SELECT points, daysuntilreset FROM ss13_research_data ORDER BY created_at DESC LIMIT 0,1")
	loadpoints.Execute()
	loadpoints.NextRow()
	points = text2num(loadpoints.item[1])
	daysuntilreset = text2num(loadpoints.item[2])
	//load the concepts
	var/DBQuery/loadconcepts = dbcon.NewQuery("SELECT cid, level, progress FROM ss13_research_concepts WHERE deleted_at IS NULL ORDER BY order_by")
	loadconcepts.Execute()
	while(loadconcepts.NextRow())
		for(var/datum/research_concepts/A in concepts)
			if(A.id == loadconcepts.item[1])
				A.level = text2num(loadconcepts.item[2])
				A.progress = text2num(loadconcepts.item[3])
	//load unlocked items
	var/DBQuery/loaditems = dbcon.NewQuery("SELECT cid, unlocked FROM ss13_research_items WHERE deleted_at IS NULL ORDER BY order_by")
	loaditems.Execute()
	while(loaditems.NextRow())
		for(var/datum/research_items/A in techitems)
			if(A.id == loaditems.item[1])
				A.unlocked = text2num(loaditems.item[2])
	sortitems()

/datum/controller/subsystem/research/fire()
	var/DBQuery/update_points = dbcon.NewQuery("INSERT INTO ss13_research_data (round_id, points, daysuntilreset, created_at, updated_at) VALUES(:g:, :p:, :d:,NOW(), NOW()) ON DUPLICATE KEY UPDATE points=:p:, updated_at=NOW()")
	update_points.Execute(list("p" = points, "d" = daysuntilreset, "g" = game_id))
	for(var/datum/research_concepts/A in concepts)
		var/DBQuery/update_concepts = dbcon.NewQuery("INSERT INTO ss13_research_concepts (cid, level, progress, created_at, updated_at) VALUES(:g:, :p:, :d:,NOW(), NOW()) ON DUPLICATE KEY UPDATE level=:p:, progress=:d:, updated_at=NOW()")
		update_concepts.Execute(list("p" = A.level, "d" = A.progress, "g" = A.id))
	for(var/datum/research_items/A in techitems)
		var/DBQuery/update_items = dbcon.NewQuery("INSERT INTO ss13_research_items (cid, unlocked, created_at, updated_at) VALUES(:g:, :p:,NOW(), NOW()) ON DUPLICATE KEY UPDATE unlocked=:p:, updated_at=NOW()")
		update_items.Execute(list("p" = A.unlocked, "g" = A.id))

/datum/controller/subsystem/research/proc/sortitems()
	for(var/datum/research_items/A in techitems)
		if(A.unlocked == 1)
			unlockeditems += A
			//call unlock proc here
		else
			lockeditems += A

/datum/controller/subsystem/research/proc/load_conceptsanditems()
	var/list/T = list()
	init_subtypes(/datum/research_concepts, T)
	concepts = T
	T = list()
	init_subtypes(/datum/research_items, T)
	techitems = T
	