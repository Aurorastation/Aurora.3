// Writes lighting updates to the database.
// FOR DEBUGGING ONLY!

/proc/lprof_write(var/atom/movable/obj, var/type = "UNKNOWN")
	if (!lighting_profiling || !obj || !establish_db_connection(dbcon))
		return

	var/x = null
	var/y = null
	var/z = null

	var/name = null
	var/locname = null
	if (istype(obj))
		name = obj.name
		locname = obj.loc.name
		x = obj.loc.x
		y = obj.loc.y
		z = obj.loc.z

	var/static/DBQuery/lprof_q
	if (!lprof_q)
		lprof_q = dbcon.NewQuery({"INSERT INTO ss13dbg_lighting (time,tick_usage,type,name,loc_name,x,y,z)
		VALUES (:time:,:tick_usage:,:type:,:name:,:loc_name:,:x:,:y:,:z:);"})

	lprof_q.Execute(
		list(
			"time" = world.time,
			"tick_usage" = world.tick_usage,
			"type" = type,
			"name" = name,
			"loc_name" = locname,
			"x" = x,
			"y" = y,
			"z" = z))

	var/err = lprof_q.ErrorMsg()
	if (err)
		log_debug("lprof_write: SQL Error: [err]")
		message_admins(span("danger", "SQL Error during lighting profiling; disabling!"))
		lighting_profiling = FALSE
