/atom/movable/screen/movable/ability_master
	name = "Abilities"
	icon = 'icons/mob/screen_spells.dmi'
	icon_state = "grey_spell_ready"
	var/list/atom/movable/screen/ability/ability_objects = list()
	var/showing = FALSE // If we're 'open' or not.

	var/open_state = "master_open"		// What the button looks like when it's 'open', showing the other buttons.
	var/closed_state = "master_closed"	// Button when it's 'closed', hiding everything else.

	screen_loc = ui_spell_master // TODO: Rename

	var/mob/my_mob // The mob that possesses this hud object.

/atom/movable/screen/movable/ability_master/Initialize(mapload, owner)
	. = ..()
	if(owner)
		my_mob = owner
		update_abilities(0, owner)

/atom/movable/screen/movable/ability_master/Destroy()
	//Get rid of the ability objects.
	remove_all_abilities()
	ability_objects.Cut()

	// After that, remove ourselves from the mob seeing us, so we can qdel cleanly.
	if(my_mob)
		my_mob.ability_master = null
		if(my_mob.client && my_mob.client.screen)
			my_mob.client.screen -= src
		my_mob = null

	. = ..()

/atom/movable/screen/movable/ability_master/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(showing)
		return

	return ..()

/atom/movable/screen/movable/ability_master/Click()
	if(!ability_objects.len) // If we're empty for some reason.
		return

	toggle_open()

/atom/movable/screen/movable/ability_master/proc/toggle_open(var/forced_state = 0, var/mob/user = usr)
	if(showing && (forced_state != 2)) // We are closing the ability master, hide the abilities.
		for(var/atom/movable/screen/ability/O in ability_objects)
			if(my_mob && my_mob.client)
				my_mob.client.screen -= O
		showing = FALSE
		overlays.len = 0
		overlays.Add(closed_state)
	else if(forced_state != 1) // We're opening it, show the icons.
		open_ability_master(user)
		update_abilities(1)
		showing = TRUE
		overlays.len = 0
		overlays.Add(open_state)
	update_icon()

/atom/movable/screen/movable/ability_master/proc/open_ability_master(var/mob/user = usr)
	var/list/screen_loc_xy = splittext(screen_loc,",")

	//Create list of X offsets
	var/list/screen_loc_X = splittext(screen_loc_xy[1],":")
	var/x_position = decode_screen_X(screen_loc_X[1], user)
	var/x_pix = screen_loc_X[2]

	//Create list of Y offsets
	var/list/screen_loc_Y = splittext(screen_loc_xy[2],":")
	var/y_position = decode_screen_Y(screen_loc_Y[1], user)
	var/y_pix = screen_loc_Y[2]

	for(var/i = 1; i <= ability_objects.len; i++)
		var/atom/movable/screen/ability/A = ability_objects[i]
		var/xpos = x_position + (x_position < 8 ? 1 : -1)*(i%7)
		var/ypos = y_position + (y_position < 8 ? round(i/7) : -round(i/7))
		A.screen_loc = "[encode_screen_X(xpos, user)]:[x_pix],[encode_screen_Y(ypos, user)]:[y_pix]"
		if(my_mob && my_mob.client)
			my_mob.client.screen += A

/atom/movable/screen/movable/ability_master/proc/update_abilities(forced = 0, mob/user)
	update_icon()
	if(user && user.client)
		if(!(src in user.client.screen))
			user.client.screen += src
	var/i = 1
	for(var/atom/movable/screen/ability/ability in ability_objects)
		ability.update_icon(forced)
		ability.index = i
		ability.maptext = "[ability.index]" // Slot number
		i++

/atom/movable/screen/movable/ability_master/update_icon()
	if(ability_objects.len)
		set_invisibility(0)
	else
		set_invisibility(101)

/atom/movable/screen/movable/ability_master/proc/add_ability(var/name_given)
	if(!name)
		return

	var/atom/movable/screen/ability/new_button = new /atom/movable/screen/ability
	new_button.ability_master = src
	new_button.name = name_given
	new_button.ability_icon_state = name_given
	new_button.update_icon(1)
	ability_objects.Add(new_button)
	if(my_mob.client)
		toggle_open(2) //forces the icons to refresh on screen

/atom/movable/screen/movable/ability_master/proc/remove_ability(var/atom/movable/screen/ability/ability)
	if(!ability)
		return
	ability_objects.Remove(ability)
	qdel(ability)


	if(ability_objects.len)
		toggle_open(showing + 1)
	update_icon()

/atom/movable/screen/movable/ability_master/proc/remove_all_abilities()
	for(var/atom/movable/screen/ability/A in ability_objects)
		remove_ability(A)

/atom/movable/screen/movable/ability_master/proc/remove_all_psionic_abilities()
	for(var/atom/movable/screen/ability/obj_based/psionic/A in ability_objects)
		remove_ability(A)

/atom/movable/screen/movable/ability_master/proc/get_ability_by_name(name_to_search)
	for(var/atom/movable/screen/ability/A in ability_objects)
		if(A.name == name_to_search)
			return A
	return

/atom/movable/screen/movable/ability_master/proc/get_ability_by_proc_ref(proc_ref)
	for(var/atom/movable/screen/ability/verb_based/V in ability_objects)
		if(V.verb_to_call == proc_ref)
			return V
	return

/atom/movable/screen/movable/ability_master/proc/get_ability_by_instance(var/obj/instance/)
	for(var/atom/movable/screen/ability/obj_based/O in ability_objects)
		if(O.object == instance)
			return O
	return

///////////ACTUAL ABILITIES////////////
//This is what you click to do things//
///////////////////////////////////////
/atom/movable/screen/ability
	icon = 'icons/mob/screen_spells.dmi'
	icon_state = "grey_spell_base"
	maptext_x = 3
	var/background_base_state = "grey"
	var/ability_icon_state = null
	var/index = 0

	var/atom/movable/screen/movable/ability_master/ability_master

/atom/movable/screen/ability/Destroy()
	if(ability_master)
		ability_master.ability_objects -= src
		if(ability_master.my_mob && ability_master.my_mob.client)
			ability_master.my_mob.client.screen -= src
	if(ability_master && !ability_master.ability_objects.len)
		ability_master.update_icon()
	ability_master = null
	. = ..()

/atom/movable/screen/ability/update_icon()
	overlays.Cut()
	icon_state = "[background_base_state]_spell_base"

	overlays += ability_icon_state

/atom/movable/screen/ability/Click(var/location, var/control, var/params)
	if(!usr)
		return

	var/list/click_params = params2list(params)
	if(click_params["shift"])
		examine(usr)
		return

	activate()

/atom/movable/screen/ability/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(!over || over == src)
		return
	if(istype(over, /atom/movable/screen/ability))
		var/atom/movable/screen/ability/ability = over
		if(ability.ability_master && ability.ability_master == src.ability_master)
			ability_master.ability_objects.Swap(src.index, ability.index)
			ability_master.toggle_open(2) // To update the UI.


// Makes the ability be triggered.  The subclasses of this are responsible for carrying it out in whatever way it needs to.
/atom/movable/screen/ability/proc/activate()
	LOG_DEBUG("[src] had activate() called.")

// This checks if the ability can be used.
/atom/movable/screen/ability/proc/can_activate()
	return TRUE

/client/verb/activate_ability(var/slot as num)
	set name = ".activate_ability"
	if(!mob)
		return // Paranoid.
	if(isnull(slot) || !isnum(slot))
		to_chat(src, SPAN_WARNING(".activate_ability requires a number as input, corrisponding to the slot you wish to use."))
		return // Bad input.
	if(!mob.ability_master)
		return // No abilities.
	if(slot > mob.ability_master.ability_objects.len || slot <= 0)
		return // Out of bounds.
	var/atom/movable/screen/ability/A = mob.ability_master.ability_objects[slot]
	A.activate()

//////////Verb Abilities//////////
//Buttons to trigger verbs/procs//
//////////////////////////////////

/atom/movable/screen/ability/verb_based
	var/verb_to_call = null
	var/object_used = null
	var/arguments_to_use = list()

/atom/movable/screen/ability/verb_based/activate()
	if(object_used && verb_to_call)
		call(object_used,verb_to_call)(arguments_to_use)

/atom/movable/screen/movable/ability_master/proc/add_verb_ability(var/object_given, var/verb_given, var/name_given, var/ability_icon_given, var/arguments)
	if(!object_given)
		message_admins("ERROR: add_verb_ability() was not given an object in its arguments.")
	if(!verb_given)
		message_admins("ERROR: add_verb_ability() was not given a verb/proc in its arguments.")
	if(get_ability_by_proc_ref(verb_given))
		return // Duplicate
	var/atom/movable/screen/ability/verb_based/A = new /atom/movable/screen/ability/verb_based()
	A.ability_master = src
	A.object_used = object_given
	A.verb_to_call = verb_given
	A.ability_icon_state = ability_icon_given
	A.name = name_given
	if(arguments)
		A.arguments_to_use = arguments
	ability_objects.Add(A)
	if(my_mob.client)
		toggle_open(2) //forces the icons to refresh on screen

//Changeling Abilities
/atom/movable/screen/ability/verb_based/changeling
	icon_state = "ling_spell_base"
	background_base_state = "ling"

/atom/movable/screen/movable/ability_master/proc/add_ling_ability(var/object_given, var/verb_given, var/name_given, var/ability_icon_given, var/arguments)
	if(!object_given)
		message_admins("ERROR: add_ling_ability() was not given an object in its arguments.")
	if(!verb_given)
		message_admins("ERROR: add_ling_ability() was not given a verb/proc in its arguments.")
	if(get_ability_by_proc_ref(verb_given))
		return // Duplicate
	var/atom/movable/screen/ability/verb_based/changeling/A = new /atom/movable/screen/ability/verb_based/changeling()
	A.ability_master = src
	A.object_used = object_given
	A.verb_to_call = verb_given
	A.ability_icon_state = ability_icon_given
	A.name = name_given
	if(arguments)
		A.arguments_to_use = arguments
	ability_objects.Add(A)
	if(my_mob.client)
		toggle_open(2) //forces the icons to refresh on screen


/////////Obj Abilities////////
//Buttons to trigger objects//
//////////////////////////////

/atom/movable/screen/ability/obj_based
	var/obj/object

/atom/movable/screen/ability/obj_based/activate()
	if(object)
		object.Click()

/// Psionics.
/atom/movable/screen/ability/obj_based/psionic
	icon_state = "nano_spell_base"
	background_base_state = "nano"
	var/singleton/psionic_power/connected_power

/atom/movable/screen/ability/obj_based/psionic/Destroy()
	connected_power = null
	return ..()

/atom/movable/screen/movable/ability_master/proc/add_psionic_ability(var/obj/object_given, var/ability_icon_given, var/singleton/psionic_power/P, var/mob/user)
	if(!object_given)
		message_admins("ERROR: add_psionic_ability() was not given an object in its arguments.")
	if(!P)
		message_admins("Psionic ability added without connected psionic power singleton!")
	if(get_ability_by_instance(object_given))
		return // Duplicate
	var/atom/movable/screen/ability/obj_based/psionic/A = new /atom/movable/screen/ability/obj_based/psionic()
	A.ability_master = src
	A.object = object_given
	A.ability_icon_state = ability_icon_given
	A.name = object_given.name
	A.connected_power = P
	ability_objects.Add(A)
	if(my_mob.client)
		toggle_open(2, user) //forces the icons to refresh on screen

/atom/movable/screen/ability/obj_based/psionic/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("<font size=4>This ability is <b>[connected_power.name]</b>.</font>")
	. += SPAN_NOTICE("[connected_power.desc]")

/// Technomancer.
/atom/movable/screen/ability/obj_based/technomancer
	icon_state = "wiz_spell_base"
	background_base_state = "wiz"

/atom/movable/screen/ability/obj_based/technomancer/activate()
	if(ability_master.my_mob.incapacitated())
		return
	. = ..()

/atom/movable/screen/movable/ability_master/proc/add_technomancer_ability(var/obj/object_given, var/ability_icon_given)
	if(!object_given)
		message_admins("ERROR: add_technomancer_ability() was not given an object in its arguments.")
	if(get_ability_by_instance(object_given))
		return // Duplicate
	var/atom/movable/screen/ability/obj_based/technomancer/A = new /atom/movable/screen/ability/obj_based/technomancer()
	A.ability_master = src
	A.object = object_given
	A.ability_icon_state = ability_icon_given
	A.name = object_given.name
	ability_objects.Add(A)
	if(my_mob.client)
		toggle_open(2) //forces the icons to refresh on screen
