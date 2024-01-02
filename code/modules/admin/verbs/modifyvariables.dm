var/list/VVlocked = list("vars", "holder", "client", "virus", "viruses", "cuffed", "last_eaten", "unlock_content", "bound_x", "bound_y", "step_x", "step_y", "force_ending")
var/list/VVicon_edit_lock = list("icon", "icon_state", "overlays", "underlays")
var/list/VVckey_edit = list("key", "ckey")

// The paranoia box. Specify a var name => bitflags required to edit it.
// Allows the securing of specific variables for, for example, GLOB.config. That alter
// how players could join! Definitely not something you want folks to touch if they
// don't have the perms.
var/list/VVdynamic_lock = list(
	"access_deny_new_players" = R_SERVER,
	"access_deny_new_accounts" = R_SERVER,
	"access_deny_vms" = R_SERVER,
	"access_warn_vms" = R_SERVER,
	"ipintel_rating_bad" = R_SERVER,
	"ipintel_rating_kick" = R_SERVER
)

/*
/client/proc/cmd_modify_object_variables(obj/O as obj|mob|turf|area in world)   // Acceptable 'in world', as VV would be incredibly hampered otherwise
	set category = "Debug"
	set name = "Edit Variables"
	set desc="(target) Edit a target item's variables"
	src.modify_variables(O)
	feedback_add_details("admin_verb","EDITV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
*/

/client/proc/mod_list_add_ass() //haha

	var/class = "text"
	if(src.holder && src.holder.marked_datum)
		class = input("What kind of variable?","Variable Type") as null|anything in list("text",
			"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default","marked datum ([holder.marked_datum.type])")
	else
		class = input("What kind of variable?","Variable Type") as null|anything in list("text",
			"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default")

	if(!class)
		return

	if(holder.marked_datum && class == "marked datum ([holder.marked_datum.type])")
		class = "marked datum"

	var/var_value = null

	switch(class)

		if("text")
			var_value = input("Enter new text:","Text") as null|text

		if("num")
			var_value = input("Enter new number:","Num") as null|num

		if("type")
			var/object = input("Enter typepath:","Typepath") as null|text
			if(!object)
				return

			var/list/types = typesof(/atom)
			var/list/matches = new()

			for(var/path in types)
				if(findtext("[path]", object))
					matches += path

			if(matches.len==0)
				return

			if(matches.len==1)
				var_value = matches[1]
			else
				var_value = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches

		if("reference")
			var_value = input("Select reference:","Reference") as null|mob|obj|turf|area in world

		if("mob reference")
			var_value = input("Select reference:","Reference") as null|mob in world

		if("file")
			var_value = input("Pick file:","File") as null|file

		if("icon")
			var_value = input("Pick icon:","Icon") as null|icon

		if("marked datum")
			var_value = holder.marked_datum

	if(!var_value) return

	return var_value


/client/proc/mod_list_add(var/list/L, atom/O, original_name, objectvar)

	var/class = "text"
	if(src.holder && src.holder.marked_datum)
		class = input("What kind of variable?","Variable Type") as null|anything in list("text",
			"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default","marked datum ([holder.marked_datum.type])")
	else
		class = input("What kind of variable?","Variable Type") as null|anything in list("text",
			"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default")

	if(!class)
		return

	if(holder.marked_datum && class == "marked datum ([holder.marked_datum.type])")
		class = "marked datum"

	var/var_value = null

	switch(class)

		if("text")
			var_value = input("Enter new text:","Text") as text

		if("num")
			var_value = input("Enter new number:","Num") as num

		if("type")
			var/object = input("Enter typepath:","Typepath") as null|text
			if(!object)
				return

			var/list/types = typesof(/atom)
			var/list/matches = new()

			for(var/path in types)
				if(findtext("[path]", object))
					matches += path

			if(matches.len==0)
				return

			if(matches.len==1)
				var_value = matches[1]
			else
				var_value = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches

		if("reference")
			var_value = input("Select reference:","Reference") as mob|obj|turf|area in world

		if("mob reference")
			var_value = input("Select reference:","Reference") as mob in world

		if("file")
			var_value = input("Pick file:","File") as file

		if("icon")
			var_value = input("Pick icon:","Icon") as icon

		if("marked datum")
			var_value = holder.marked_datum

	if(!var_value) return

	switch(alert("Would you like to associate a var with the list entry?",,"Yes","No"))
		if("Yes")
			L += var_value
			L[var_value] = mod_list_add_ass() //haha
		if("No")
			L += var_value
	world.log <<  "### ListVarEdit by [src]: [O.type] [objectvar]: ADDED=[var_value]"
	log_admin("[key_name(src)] modified [original_name]'s [objectvar]: ADDED=[var_value]",admin_key=key_name(src))
	message_admins("[key_name_admin(src)] modified [original_name]'s [objectvar]: ADDED=[var_value]")

/client/proc/mod_list(var/list/L, atom/O, original_name, objectvar)
	if(!check_rights(R_VAREDIT|R_DEV))	return
	if(!istype(L,/list)) to_chat(src, "Not a List.")

	if(L.len > 1000)
		var/confirm = alert(src, "The list you're trying to edit is very long, continuing may crash the server.", "Warning", "Continue", "Abort")
		if(confirm != "Continue")
			return

	var/assoc = 0
	if(L.len > 0)
		var/a = L[1]
		if(istext(a) && L[a] != null)
			assoc = 1 //This is pretty weak test but i can't think of anything else
			to_chat(usr, "List appears to be associative.")

	var/list/names = null
	if(!assoc)
		names = sortList(L)

	var/variable
	var/assoc_key
	if(assoc)
		variable = input("Which var?","Var") as null|anything in L + "(ADD VAR)"
	else
		variable = input("Which var?","Var") as null|anything in names + "(ADD VAR)"

	if(variable == "(ADD VAR)")
		mod_list_add(L, O, original_name, objectvar)
		return

	if(assoc)
		assoc_key = variable
		variable = L[assoc_key]

	if(!assoc && !variable || assoc && !assoc_key)
		return

	var/default

	var/dir

	if(variable in VVlocked)
		if(!check_rights(R_DEBUG|R_DEV))	return
	if(variable in VVckey_edit)
		if(!check_rights(R_SPAWN|R_DEBUG|R_DEV)) return
	if(variable in VVicon_edit_lock)
		if(!check_rights(R_FUN|R_DEBUG|R_DEV)) return
	if(VVdynamic_lock[variable])
		if(!check_rights(VVdynamic_lock[variable])) return

	if(isnull(variable))
		to_chat(usr, "Unable to determine variable type.")

	else if(isnum(variable))
		to_chat(usr, "Variable appears to be <b>NUM</b>.")
		default = "num"
		dir = 1

	else if(istext(variable))
		to_chat(usr, "Variable appears to be <b>TEXT</b>.")
		default = "text"

	else if(isloc(variable))
		to_chat(usr, "Variable appears to be <b>REFERENCE</b>.")
		default = "reference"

	else if(isicon(variable))
		to_chat(usr, "Variable appears to be <b>ICON</b>.")
		variable = "[icon2html(variable, usr)]"
		default = "icon"

	else if(istype(variable,/atom) || istype(variable,/datum))
		to_chat(usr, "Variable appears to be <b>TYPE</b>.")
		default = "type"

	else if(istype(variable,/list))
		to_chat(usr, "Variable appears to be <b>LIST</b>.")
		default = "list"

	else if(istype(variable,/client))
		to_chat(usr, "Variable appears to be <b>CLIENT</b>.")
		default = "cancel"

	else
		to_chat(usr, "Variable appears to be <b>FILE</b>.")
		default = "file"

	to_chat(usr, "Variable contains: [variable]")
	if(dir)
		switch(variable)
			if(1)
				dir = "NORTH"
			if(2)
				dir = "SOUTH"
			if(4)
				dir = "EAST"
			if(8)
				dir = "WEST"
			if(5)
				dir = "NORTHEAST"
			if(6)
				dir = "SOUTHEAST"
			if(9)
				dir = "NORTHWEST"
			if(10)
				dir = "SOUTHWEST"
			else
				dir = null

		if(dir)
			to_chat(usr, "If a direction, direction is: [dir]")

	var/class = "text"
	if(src.holder && src.holder.marked_datum)
		class = input("What kind of variable?","Variable Type",default) as null|anything in list("text",
			"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default","marked datum ([holder.marked_datum.type])", "DELETE FROM LIST")
	else
		class = input("What kind of variable?","Variable Type",default) as null|anything in list("text",
			"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default", "DELETE FROM LIST")

	if(!class)
		return

	if(holder.marked_datum && class == "marked datum ([holder.marked_datum.type])")
		class = "marked datum"

	var/original_var
	if(assoc)
		original_var = L[assoc_key]
	else
		original_var = L[L.Find(variable)]

	var/new_var
	switch(class) //Spits a runtime error if you try to modify an entry in the contents list. Dunno how to fix it, yet.

		if("list")
			mod_list(variable, O, original_name, objectvar)

		if("restore to default")
			if(assoc)
				L[assoc_key] = variable
			else
				L[L.Find(variable)] = variable

		if("edit referenced object")
			modify_variables(variable)

		if("DELETE FROM LIST")
			world.log <<  "### ListVarEdit by [src]: [O.type] [objectvar]: REMOVED=[html_encode("[variable]")]"
			log_admin("[key_name(src)] modified [original_name]'s [objectvar]: REMOVED=[variable]",admin_key=key_name(src))
			message_admins("[key_name_admin(src)] modified [original_name]'s [objectvar]: REMOVED=[variable]")
			L -= variable
			return

		if("text")
			new_var = input("Enter new text:","Text") as null|text
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("num")
			new_var = input("Enter new number:","Num") as null|num
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("type")
			var/object = input("Enter typepath:","Typepath") as null|text
			if(!object)
				return

			var/list/types = typesof(/atom)
			var/list/matches = new()

			for(var/path in types)
				if(findtext("[path]", object))
					matches += path

			if(matches.len==0)
				return

			if(matches.len==1)
				new_var = matches[1]
			else
				new_var = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches

			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("reference")
			new_var = input("Select reference:","Reference") as null|mob|obj|turf|area in world
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("mob reference")
			new_var = input("Select reference:","Reference") as null|mob in world
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("file")
			new_var = input("Pick file:","File") as null|file
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("icon")
			new_var = input("Pick icon:","Icon") as null|icon
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("marked datum")
			new_var = holder.marked_datum
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

	world.log <<  "### ListVarEdit by [src]: [O.type] [objectvar]: [original_var]=[new_var]"
	log_admin("[key_name(src)] modified [original_name]'s [objectvar]: [original_var]=[new_var]",admin_key=key_name(src))
	message_admins("[key_name_admin(src)] modified [original_name]'s varlist [objectvar]: [original_var]=[new_var]")

/client/proc/modify_variables(var/atom/O, var/param_var_name = null, var/autodetect_class = 0)
	if(!check_rights(R_VAREDIT|R_DEV))	return

	if(istype(O, /client) && (param_var_name == "ckey" || param_var_name == "key"))
		to_chat(usr, "<span class='danger'>You cannot edit ckeys on client objects.</span>")
		return

	if(!O.can_vv_get(param_var_name))
		to_chat(src, SPAN_WARNING("You cannot edit this variable."))
		return

	var/class
	var/variable
	var/var_value

	if(param_var_name)
		if(!(param_var_name in O.vars))
			to_chat(src, "A variable with this name ([param_var_name]) doesn't exist in this atom ([O])")
			return

		if(param_var_name in VVlocked)
			if(!check_rights(R_DEBUG|R_DEV))	return
		if(param_var_name in VVckey_edit)
			if(!check_rights(R_SPAWN|R_DEBUG|R_DEV)) return
		if(param_var_name in VVicon_edit_lock)
			if(!check_rights(R_FUN|R_DEBUG|R_DEV)) return
		if(VVdynamic_lock[variable])
			if(!check_rights(VVdynamic_lock[variable])) return

		variable = param_var_name

		var_value = O.vars[variable]

		if(autodetect_class)
			if(isnull(var_value))
				to_chat(usr, "Unable to determine variable type.")
				class = null
				autodetect_class = null
			else if(isnum(var_value))
				to_chat(usr, "Variable appears to be <b>NUM</b>.")
				class = "num"
				dir = 1

			else if(istext(var_value))
				to_chat(usr, "Variable appears to be <b>TEXT</b>.")
				class = "text"

			else if(isloc(var_value))
				to_chat(usr, "Variable appears to be <b>REFERENCE</b>.")
				class = "reference"

			else if(isicon(var_value))
				to_chat(usr, "Variable appears to be <b>ICON</b>.")
				var_value = "[icon2html(var_value, usr)]"
				class = "icon"

			else if(istype(var_value,/atom) || istype(var_value,/datum))
				to_chat(usr, "Variable appears to be <b>TYPE</b>.")
				class = "type"

			else if(istype(var_value,/list))
				to_chat(usr, "Variable appears to be <b>LIST</b>.")
				class = "list"

			else if(istype(var_value,/client))
				to_chat(usr, "Variable appears to be <b>CLIENT</b>.")
				class = "cancel"

			else
				to_chat(usr, "Variable appears to be <b>FILE</b>.")
				class = "file"

	else

		var/list/names = list()
		for (var/V in O.vars)
			names += V

		names = sortList(names)

		variable = input("Which var?","Var") as null|anything in names
		if(!variable)
			return
		var_value = O.vars[variable]

		if(variable in VVlocked)
			if(!check_rights(R_DEBUG|R_DEV)) return
		if(variable in VVckey_edit)
			if(!check_rights(R_SPAWN|R_DEBUG|R_DEV)) return
		if(variable in VVicon_edit_lock)
			if(!check_rights(R_FUN|R_DEBUG|R_DEV)) return
		if(VVdynamic_lock[variable])
			if(!check_rights(VVdynamic_lock[variable])) return

	if(!autodetect_class)

		var/dir
		var/default
		if(isnull(var_value))
			to_chat(usr, "Unable to determine variable type.")

		else if(isnum(var_value))
			to_chat(usr, "Variable appears to be <b>NUM</b>.")
			default = "num"
			dir = 1

		else if(istext(var_value))
			to_chat(usr, "Variable appears to be <b>TEXT</b>.")
			default = "text"

		else if(isloc(var_value))
			to_chat(usr, "Variable appears to be <b>REFERENCE</b>.")
			default = "reference"

		else if(isicon(var_value))
			to_chat(usr, "Variable appears to be <b>ICON</b>.")
			var_value = "[icon2html(var_value, usr)]"
			default = "icon"

		else if(istype(var_value,/atom) || istype(var_value,/datum))
			to_chat(usr, "Variable appears to be <b>TYPE</b>.")
			default = "type"

		else if(istype(var_value,/list))
			to_chat(usr, "Variable appears to be <b>LIST</b>.")
			default = "list"

		else if(istype(var_value,/client))
			to_chat(usr, "Variable appears to be <b>CLIENT</b>.")
			default = "cancel"

		else
			to_chat(usr, "Variable appears to be <b>FILE</b>.")
			default = "file"

		to_chat(usr, "Variable contains: [var_value]")
		if(dir)
			switch(var_value)
				if(1)
					dir = "NORTH"
				if(2)
					dir = "SOUTH"
				if(4)
					dir = "EAST"
				if(8)
					dir = "WEST"
				if(5)
					dir = "NORTHEAST"
				if(6)
					dir = "SOUTHEAST"
				if(9)
					dir = "NORTHWEST"
				if(10)
					dir = "SOUTHWEST"
				else
					dir = null
			if(dir)
				to_chat(usr, "If a direction, direction is: [dir]")

		if(src.holder && src.holder.marked_datum)
			class = input("What kind of variable?","Variable Type",default) as null|anything in list("text",
				"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default","marked datum ([holder.marked_datum.type])")
		else
			class = input("What kind of variable?","Variable Type",default) as null|anything in list("text",
				"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default")

		if(!class)
			return

	var/original_name

	if (!istype(O, /atom))
		original_name = "\ref[O] ([O])"
	else
		original_name = O:name

	if(holder.marked_datum && class == "marked datum ([holder.marked_datum.type])")
		class = "marked datum"

	switch(class)

		if("list")
			mod_list(O.vars[variable], O, original_name, variable)
			return

		if("restore to default")
			O.vars[variable] = initial(O.vars[variable])

		if("edit referenced object")
			return .(O.vars[variable])

		if("text")
			var/var_new = input("Enter new text:","Text",O.vars[variable]) as null|text
			if(var_new==null)
				return

			if(!O.vv_edit_var(variable, var_new))
				to_chat(usr, SPAN_WARNING("You cannot edit this variable."))
				return

		if("num")
			if(variable=="light_range")
				var/var_new = input("Enter new number:","Num",O.vars[variable]) as null|num
				if(var_new == null)
					return

				if(!O.can_vv_get(variable))
					to_chat(usr, SPAN_WARNING("You cannot edit this variable."))
					return

				O.set_light(var_new)
			else if(variable=="stat")
				var/var_new = input("Enter new number:","Num",O.vars[variable]) as null|num
				if(var_new == null)
					return

				if(!O.vv_edit_var(variable, var_new))
					to_chat(usr, SPAN_WARNING("You cannot edit this variable."))
					return

				if((O.vars[variable] == DEAD) && (var_new < DEAD))//Bringing the dead back to life
					GLOB.dead_mob_list -= O
					GLOB.living_mob_list += O
				if((O.vars[variable] < DEAD) && (var_new == DEAD))//Kill he
					GLOB.living_mob_list -= O
					GLOB.dead_mob_list += O
			else
				var/var_new =  input("Enter new number:","Num",O.vars[variable]) as null|num
				if(var_new==null)
					return

				if(!O.vv_edit_var(variable, var_new))
					to_chat(usr, SPAN_WARNING("You cannot edit this variable."))
					return

		if("type")
			var/object = input("Enter typepath:","Type",O.vars[variable]) as null|text
			if(!object)
				return

			var/list/types = typesof(/atom)
			var/list/matches = new()

			for(var/path in types)
				if(findtext("[path]", object))
					matches += path

			if(matches.len==0)
				return

			var/var_new = null

			if(matches.len==1)
				var_new = matches[1]
			else
				var_new = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches

			if(var_new==null)
				return

			if(!O.vv_edit_var(variable, var_new))
				to_chat(usr, SPAN_WARNING("You cannot edit this variable."))
				return

		if("reference")
			var/var_new = input("Select reference:","Reference",O.vars[variable]) as null|mob|obj|turf|area in world
			if(var_new==null)
				return

			if(!O.vv_edit_var(variable, var_new))
				to_chat(usr, SPAN_WARNING("You cannot edit this variable."))
				return

		if("mob reference")
			var/var_new = input("Select reference:","Reference",O.vars[variable]) as null|mob in world
			if(var_new==null) return

			if(!O.vv_edit_var(variable, var_new))
				to_chat(usr, SPAN_WARNING("You cannot edit this variable."))
				return

		if("file")
			var/var_new = input("Pick file:","File",O.vars[variable]) as null|file
			if(var_new==null)
				return

			if(!O.vv_edit_var(variable, var_new))
				to_chat(usr, SPAN_WARNING("You cannot edit this variable."))
				return

		if("icon")
			var/var_new = input("Pick icon:","Icon",O.vars[variable]) as null|icon
			if(var_new==null)
				return

			if(!O.vv_edit_var(variable, var_new))
				to_chat(usr, SPAN_WARNING("You cannot edit this variable."))
				return

		if("marked datum")
			if(!O.can_vv_get(variable))
				to_chat(usr, SPAN_WARNING("You cannot edit this variable."))
				return

			O.vars[variable] = holder.marked_datum

	world.log <<  "### VarEdit by [src]: [O.type] [variable]=[html_encode("[O.vars[variable]]")]"
	log_admin("[key_name(src)] modified [original_name]'s [variable] to [O.vars[variable]]",admin_key=key_name(src))
	message_admins("[key_name_admin(src)] modified [original_name]'s [variable] to [O.vars[variable]]")
