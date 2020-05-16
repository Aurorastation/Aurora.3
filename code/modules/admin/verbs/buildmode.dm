/proc/togglebuildmode(mob/M as mob in player_list)
	set name = "Toggle Build Mode"
	set category = "Special Verbs"
	if(M.client)
		if(M.client.buildmode)
			log_admin("[key_name(usr)] has left build mode.",admin_key=key_name(usr))
			M.client.buildmode = 0
			M.client.show_popup_menus = 1
			M.verbs -= /verb/load_template_verb
			for(var/obj/effect/bmode/buildholder/H)
				if(H.cl == M.client)
					qdel(H)
		else
			log_admin("[key_name(usr)] has entered build mode.",admin_key=key_name(usr))
			M.client.buildmode = 1
			M.client.show_popup_menus = 0
			M.verbs += /verb/load_template_verb
			var/obj/effect/bmode/buildholder/H = new/obj/effect/bmode/buildholder()
			var/obj/effect/bmode/builddir/A = new/obj/effect/bmode/builddir(H)
			A.master = H
			var/obj/effect/bmode/buildhelp/B = new/obj/effect/bmode/buildhelp(H)
			B.master = H
			var/obj/effect/bmode/buildmode/C = new/obj/effect/bmode/buildmode(H)
			C.master = H
			var/obj/effect/bmode/buildquit/D = new/obj/effect/bmode/buildquit(H)
			D.master = H
			var/obj/effect/bmode/template/E = new/obj/effect/bmode/template(H)
			E.master = H

			H.builddir = A
			H.buildhelp = B
			H.buildmode = C
			H.buildquit = D
			H.load_template = E
			M.client.screen += A
			M.client.screen += B
			M.client.screen += C
			M.client.screen += D
			M.client.screen += E
			H.cl = M.client

/obj/effect/bmode//Cleaning up the tree a bit
	density = 1
	anchored = 1
	layer = SCREEN_LAYER
	dir = NORTH
	icon = 'icons/misc/buildmode.dmi'
	var/obj/effect/bmode/buildholder/master = null

/obj/effect/bmode/Destroy()
	if(master && master.cl)
		master.cl.screen -= src
	master = null
	return ..()

/obj/effect/bmode/builddir
	icon_state = "build"
	screen_loc = "NORTH,WEST"

/obj/effect/bmode/builddir/Click()
	switch(dir)
		if(NORTH)
			set_dir(EAST)
		if(EAST)
			set_dir(SOUTH)
		if(SOUTH)
			set_dir(WEST)
		if(WEST)
			set_dir(NORTHWEST)
		if(NORTHWEST)
			set_dir(NORTH)
	return 1

/obj/effect/bmode/buildhelp
	icon = 'icons/misc/buildmode.dmi'
	icon_state = "buildhelp"
	screen_loc = "NORTH,WEST+1"

/obj/effect/bmode/buildhelp/Click()
	switch(master.cl.buildmode)
		if(1)
			to_chat(usr, "<span class='notice'>***********************************************************</span>")
			to_chat(usr, "<span class='notice'>Left Mouse Button        = Construct / Upgrade</span>")
			to_chat(usr, "<span class='notice'>Right Mouse Button       = Deconstruct / Delete / Downgrade</span>")
			to_chat(usr, "<span class='notice'>Left Mouse Button + ctrl = R-Window</span>")
			to_chat(usr, "<span class='notice'>Left Mouse Button + alt  = Airlock</span>")
			to_chat(usr, "")
			to_chat(usr, "<span class='notice'>Use the button in the upper left corner to</span>")
			to_chat(usr, "<span class='notice'>change the direction of built objects.</span>")
			to_chat(usr, "<span class='notice'>***********************************************************</span>")
		if(2)
			to_chat(usr, "<span class='notice'>***********************************************************</span>")
			to_chat(usr, "<span class='notice'>Right Mouse Button on buildmode button = Set object type</span>")
			to_chat(usr, "<span class='notice'>Middle Mouse Button on buildmode button= On/Off object type saying</span>")
			to_chat(usr, "<span class='notice'>Middle Mouse Button on turf/obj        = Capture object type</span>")
			to_chat(usr, "<span class='notice'>Left Mouse Button on turf/obj          = Place objects</span>")
			to_chat(usr, "<span class='notice'>Right Mouse Button                     = Delete objects</span>")
			to_chat(usr, "")
			to_chat(usr, "<span class='notice'>Use the button in the upper left corner to</span>")
			to_chat(usr, "<span class='notice'>change the direction of built objects.</span>")
			to_chat(usr, "<span class='notice'>***********************************************************</span>")
		if(3)
			to_chat(usr, "<span class='notice'>***********************************************************</span>")
			to_chat(usr, "<span class='notice'>Right Mouse Button on buildmode button = Select var(type) & value</span>")
			to_chat(usr, "<span class='notice'>Left Mouse Button on turf/obj/mob      = Set var(type) & value</span>")
			to_chat(usr, "<span class='notice'>Right Mouse Button on turf/obj/mob     = Reset var's value</span>")
			to_chat(usr, "<span class='notice'>***********************************************************</span>")
		if(4)
			to_chat(usr, "<span class='notice'>***********************************************************</span>")
			to_chat(usr, "<span class='notice'>Left Mouse Button on turf/obj/mob      = Select</span>")
			to_chat(usr, "<span class='notice'>Right Mouse Button on turf/obj/mob     = Throw</span>")
			to_chat(usr, "<span class='notice'>***********************************************************</span>")
	return 1

/obj/effect/bmode/buildquit
	icon_state = "buildquit"
	screen_loc = "NORTH,WEST+4"

/obj/effect/bmode/buildquit/Click()
	togglebuildmode(master.cl.mob)
	return 1

/obj/effect/bmode/buildholder
	density = 0
	anchored = 1
	var/client/cl = null
	var/obj/effect/bmode/builddir/builddir = null
	var/obj/effect/bmode/buildhelp/buildhelp = null
	var/obj/effect/bmode/buildmode/buildmode = null
	var/obj/effect/bmode/buildquit/buildquit = null
	var/obj/effect/bmode/template/load_template = null
	var/atom/movable/throw_atom = null

/obj/effect/bmode/buildholder/Destroy()
	qdel(builddir)
	builddir = null
	qdel(buildhelp)
	buildhelp = null
	qdel(buildmode)
	buildmode = null
	qdel(buildquit)
	buildquit = null
	throw_atom = null
	cl = null
	return ..()

/obj/effect/bmode/template
	icon_state = "load_template"
	screen_loc = "NORTH,WEST+2"

/obj/effect/bmode/template/Click()
	load_template(usr)
	return 1

/obj/effect/bmode/buildmode
	icon_state = "buildmode1"
	screen_loc = "NORTH,WEST+3"
	var/varholder = "name"
	var/valueholder = "derp"
	var/objholder = /obj/structure/closet
	var/objsay = 1

/obj/effect/bmode/buildmode/Click(location, control, params)
	var/list/pa = params2list(params)

	if(pa.Find("middle"))
		switch(master.cl.buildmode)
			if(2)
				objsay=!objsay


	if(pa.Find("left"))
		switch(master.cl.buildmode)
			if(1)
				master.cl.buildmode = 2
				src.icon_state = "buildmode2"
			if(2)
				master.cl.buildmode = 3
				src.icon_state = "buildmode3"
			if(3)
				master.cl.buildmode = 4
				src.icon_state = "buildmode4"
			if(4)
				master.cl.buildmode = 1
				src.icon_state = "buildmode1"

	else if(pa.Find("right"))
		switch(master.cl.buildmode)
			if(1)
				return 1
			if(2)
				objholder = text2path(input(usr,"Enter typepath:" ,"Typepath","/obj/structure/closet"))
				if(!ispath(objholder))
					objholder = /obj/structure/closet
					alert("That path is not allowed.")
				else
					if(ispath(objholder,/mob) && !check_rights(R_DEBUG,0))
						objholder = /obj/structure/closet
			if(3)
				var/list/locked = list("vars", "key", "ckey", "client", "firemut", "ishulk", "xray", "virus", "viruses", "cuffed", "ka", "last_eaten", "urine")

				master.buildmode.varholder = input(usr,"Enter variable name:" ,"Name", "name")
				if(master.buildmode.varholder in locked && !check_rights(R_DEBUG,0))
					return 1
				var/thetype = input(usr,"Select variable type:" ,"Type") in list("text","number","mob-reference","obj-reference","turf-reference")
				if(!thetype) return 1
				switch(thetype)
					if("text")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value", "value") as text
					if("number")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value", 123) as num
					if("mob-reference")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value") as mob in mob_list
					if("obj-reference")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value") as obj in world
					if("turf-reference")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value") as turf in world
	return 1

/proc/build_click(var/mob/user, buildmode, params, var/obj/object)
	var/obj/effect/bmode/buildholder/holder = null
	for(var/obj/effect/bmode/buildholder/H)
		if(H.cl == user.client)
			holder = H
			break
	if(!holder) return
	var/list/pa = params2list(params)

	switch(buildmode)
		if(1)
			if(istype(object,/turf) && pa.Find("left") && !pa.Find("alt") && !pa.Find("ctrl") )
				if(istype(object,/turf/space))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/floor)
					return
				else if(istype(object,/turf/simulated/floor))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/wall)
					return
				else if(istype(object,/turf/simulated/wall))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/wall/r_wall)
					return
			else if(pa.Find("right"))
				if(istype(object,/turf/simulated/wall))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/floor)
					return
				else if(istype(object,/turf/simulated/floor))
					var/turf/T = object
					T.ChangeTurf(/turf/space)
					return
				else if(istype(object,/turf/simulated/wall/r_wall))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/wall)
					return
				else if(istype(object,/obj))
					qdel(object)
					return
			else if(istype(object,/turf) && pa.Find("alt") && pa.Find("left"))
				new/obj/machinery/door/airlock(get_turf(object))
			else if(istype(object,/turf) && pa.Find("ctrl") && pa.Find("left"))
				switch(holder.builddir.dir)
					if(NORTH)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.set_dir(NORTH)
					if(SOUTH)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.set_dir(SOUTH)
					if(EAST)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.set_dir(EAST)
					if(WEST)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.set_dir(WEST)
					if(NORTHWEST)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.set_dir(NORTHWEST)
		if(2)
			if(pa.Find("left"))
				if(ispath(holder.buildmode.objholder,/turf))
					var/turf/T = get_turf(object)
					T.ChangeTurf(holder.buildmode.objholder)
				else
					var/obj/A = new holder.buildmode.objholder (get_turf(object))
					A.set_dir(holder.builddir.dir)
			else if(pa.Find("right"))
				if(isobj(object)) qdel(object)
			if(pa.Find("middle"))
				holder.buildmode.objholder = text2path("[object.type]")
				if(holder.buildmode.objsay)	to_chat(usr, "[object.type]")


		if(3)
			if(pa.Find("left")) //I cant believe this shit actually compiles.
				if(object.vars.Find(holder.buildmode.varholder))
					log_admin("[key_name(usr)] modified [object.name]'s [holder.buildmode.varholder] to [holder.buildmode.valueholder]",admin_key=key_name(usr))
					object.vars[holder.buildmode.varholder] = holder.buildmode.valueholder
				else
					to_chat(usr, "<span class='warning'>[initial(object.name)] does not have a var called '[holder.buildmode.varholder]'</span>")
			if(pa.Find("right"))
				if(object.vars.Find(holder.buildmode.varholder))
					log_admin("[key_name(usr)] modified [object.name]'s [holder.buildmode.varholder] to [holder.buildmode.valueholder]",admin_key=key_name(usr))
					object.vars[holder.buildmode.varholder] = initial(object.vars[holder.buildmode.varholder])
				else
					to_chat(usr, "<span class='warning'>[initial(object.name)] does not have a var called '[holder.buildmode.varholder]'</span>")

		if(4)
			if(pa.Find("left"))
				if(istype(object, /atom/movable))
					holder.throw_atom = object
			if(pa.Find("right"))
				if(holder.throw_atom)
					holder.throw_atom.throw_at(object, 10, 1)
					log_admin("[key_name(usr)] threw [holder.throw_atom] at [object]",admin_key=key_name(usr))

/verb/load_template_verb()
	set name = "Load Template"
	set category = "Special Verbs"
	if(!usr)
		return
	load_template(usr)

/proc/load_template(var/mob/user)
	if(!user)
		return

	if(!check_rights(R_SPAWN))
		return

	var/list/templates
	try
		templates = json_decode(return_file_text("config/templates_list.json"))
	catch(var/exception/ej)
		log_debug("Warning: Could not load the templates config as templates_list.json is missing - [ej]")
		return

	if(!templates || !templates["templates_list"] || templates["templates_folder"] == "")
		return

	var/turf/T = get_turf(user)
	var/name = input(user, "Which template would you like to load?", "Load Template", null) as null|anything in templates["templates_list"]
	
	if (!name || !T)
		return

	var/datum/map_template/maploader = new (templates["templates_folder"] + name, name)
	if (!maploader)
		log_debug("Error, unable to load maploader in proc load_template!")
		return

	var/centered = input(user, "Do you want template to load as center or Edge?", "Load Template", null) as null|anything in list("Center", "Edge")
	maploader.load(T, centered == "Center" ? TRUE : FALSE)
	log_and_message_admins("[key_name_admin(user)] has loaded template [name].", user, T)
