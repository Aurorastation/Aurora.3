// Writes a lighting update to the database.
// FOR DEBUGGING ONLY.

var/DBQuery/lprof_q

/proc/lprof_init()
	lprof_q = dbcon.NewQuery({"INSERT INTO ss13dbg_lighting (time, type, name, loc_name, x, y, z)
	VALUES (:time, :name, :loc_name, :x, :y, :z, :type);"})

/proc/lprof_write(var/obj, var/type = "UNKNOWN")
	if (!obj)
		return
	
	lprof_q.Execute(
		list(
			":time" = world.time,
			":type" = type,
			":name" = obj.name. 
			":loc_name" = obj.loc.name, 
			":x" = obj.loc.x,
			":y" = obj.loc.y,
			":z" = obj.loc.z))
