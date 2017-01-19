// Writes lighting updates to the database.
// FOR DEBUGGING ONLY!

var/DBQuery/lprof_q

/proc/lprof_init()
	lprof_q = dbcon.NewQuery({"INSERT INTO ss13dbg_lighting (time,type,name,loc_name,x,y,z) 
		VALUES (:time,:type,:name,:loc_name,:x,:y,:z);"})

/proc/lprof_write(var/atom/movable/obj, var/type = "UNKNOWN")
	if (!lighting_profiling || !obj || !dbcon.IsConnected())
		return

	var/x = null
	var/y = null
	var/z = null

	var/name = null
	var/locname = null
	if (istype(obj, /obj))
		name = obj.name
		locname = obj.loc.name
		x = obj.loc.x
		y = obj.loc.y
		z = obj.loc.z

	lprof_q.Execute(
		list(
			":time" = world.time,
			":type" = type,
			":name" = name,
			":loc_name" = locname, 
			":x" = x,
			":y" = y,
			":z" = z))
	
	var/err = lprof_q.ErrorMsg()
	if (err)
		log_debug("lprof_write: SQL Error: [err]")
		message_admins(span("danger", "SQL Error during lighting profiling; disabling!"))
		lighting_profiling = FALSE
