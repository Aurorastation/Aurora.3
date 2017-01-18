// Writes lighting updates to the database.
// FOR DEBUGGING ONLY!

var/DBQuery/lprof_q

/proc/lprof_init()
	lprof_q = dbcon.NewQuery({"INSERT INTO ss13dbg_lighting (time,type,name,loc_name,x,y,z) 
		VALUES (:time,:type,:name,:loc_name,:x,:y,:z);"})

/proc/lprof_write(var/atom/movable/obj, var/type = "UNKNOWN")
	if (!obj || !dbcon.IsConnected())
		return

	lprof_q.Execute(
		list(
			":time" = world.time,
			":type" = type,
			":name" = obj.name,
			":loc_name" = obj.loc.name, 
			":x" = obj.loc.x,
			":y" = obj.loc.y,
			":z" = obj.loc.z))
	
	var/err = lprof_q.ErrorMsg()
	if (err)
		log_debug("lprof_write: SQL Error: [err]")
		message_admins(span("danger", "SQL Error during lighting profiling; disabling!"))
		lighting_profiling = FALSE
