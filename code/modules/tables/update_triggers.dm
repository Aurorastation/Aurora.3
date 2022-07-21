/obj/structure/window/New(loc, start_dir = null, constructed = 0)
	..(loc, start_dir, constructed)
	for(var/obj/structure/table/T in view(src, 1))
		T.update_connections()
		T.update_icon()

/obj/structure/window/Destroy()
	var/oldloc = loc
	loc=null
	for(var/obj/structure/table/T in view(oldloc, 1))
		T.update_connections()
		T.update_icon()
	loc=oldloc
	return ..()

/obj/structure/window/Move()
	var/oldloc = loc
	. = ..()
	if(loc != oldloc)
		for(var/obj/structure/table/T in view(oldloc, 1) | view(loc, 1))
			T.update_connections()
			T.update_icon()