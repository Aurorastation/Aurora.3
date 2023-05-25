/atom
	layer = 2
	var/level = 2
	var/flags = 0
	var/init_flags = 0
	var/list/fingerprints
	var/list/fingerprintshidden
	var/fingerprintslast = null
	var/list/blood_DNA
	var/list/other_DNA
	var/other_DNA_type = null
	var/was_bloodied
	var/blood_color
	var/last_bumped = 0
	var/pass_flags = 0
	var/throwpass = 0
	var/germ_level = GERM_LEVEL_AMBIENT // The higher the germ level, the more germ on the atom.
	var/simulated = 1 // Filter for actions. Used by lighting overlays.
	var/fluorescent // Shows up under a UV light.

	/// Chemistry.
	var/datum/reagents/reagents = null
	var/list/reagents_to_add
	var/list/reagent_data

	var/list/atom_colours // Used to store the different colors on an atom, such as its inherent color, the colored paint applied on it, special color effect, and so on.

	// Detective work, used for the duplicate data points kept in the scanners.
	var/list/original_atom

	var/gfi_layer_rotation = GFI_ROTATION_DEFAULT

	// Extra descriptions.
	var/desc_extended = null // Regular text about the atom's extended description, if any exists.
	var/desc_info = null // Blue text (SPAN_NOTICE()), informing the user about how to use the item or about game controls.
	var/desc_antag = null // Red text (SPAN_ALERT()), informing the user about how they can use an object to antagonize.

/atom/proc/reveal_blood()
	return

/atom/proc/assume_air(datum/gas_mixture/giver)
	return null

/atom/proc/remove_air(amount)
	return null

/atom/proc/return_air()
	if(loc)
		return loc.return_air()

// Returns src and all recursive contents in a list.
/atom/proc/GetAllContents()
	. = list(src)
	var/i = 0
	while(i < length(.))
		var/atom/A = .[++i]
		. += A.contents

// identical to GetAllContents but returns a list of atoms of the type passed in the argument
/atom/proc/get_all_contents_of_type(type)
	var/list/processing_list = list(src)
	. = list()
	while(length(processing_list))
		var/atom/A = processing_list[1]
		processing_list.Cut(1, 2)
		processing_list += A.contents
		if(istype(A, type))
			. += A

// Returns a list of all locations (except the area) the movable is within
/proc/get_nested_locs(atom/movable/atom_on_location, include_turf = FALSE)
	. = list()
	var/atom/location = atom_on_location.loc
	var/turf/our_turf = get_turf(atom_on_location)
	while (location && location != our_turf)
		. += location
		location = location.loc

	if(our_turf && include_turf)
		. += our_turf

// Return flags that should be added to the viewer's sight variable.
// Otherwise return a negative number to indicate that the view should be cancelled.
/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/living/silicon/ai))
		return 0
	return -1

/atom/proc/additional_sight_flags()
	return 0

/atom/proc/additional_see_invisible()
	return 0

/atom/proc/on_reagent_change()
	return

// This is called when AM collides with us.
/atom/proc/CollidedWith(atom/movable/AM)
	set waitfor = FALSE
	return

// Convenience proc to see if a container is open for chemistry handling.
// Returns true if open, false if closed.
/atom/proc/is_open_container()
	return flags & OPENCONTAINER

/atom/proc/CheckExit()
	return 1

// If you want to use this, the atom must have the PROXMOVE flag and the moving atom must also have the PROXMOVE flag currently to help with lag. -ComicIronic
/atom/proc/HasProximity(atom/movable/AM as mob|obj)
	return

/atom/proc/emp_act(var/severity)
	return

/atom/proc/flash_act(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, ignore_inherent = FALSE, type = /obj/screen/fullscreen/flash, length = 2.5 SECONDS)
	return

/atom/proc/bullet_act(obj/item/projectile/P, def_zone)
	P.on_hit(src, 0, def_zone)
	. = 0

/atom/proc/in_contents_of(container) // Can take class or object instance as argument.
	if(ispath(container))
		if(istype(src.loc, container))
			return 1
	else if(src in container)
		return 1
	return

// Helper for adding verbs with timers.
/atom/proc/add_verb(the_verb, datum/callback/callback)
	if (callback && !callback.Invoke())
		return

	verbs += the_verb

// Checks if user can use this object. Set use_flags to customize what checks are done.
// Returns 0 if they can use it, a value representing why they can't if not.
// Flags are in "code/__defines/misc.dm".
/atom/proc/use_check(mob/user, use_flags = 0, show_messages = FALSE)
	. = USE_SUCCESS
	if(NOT_FLAG(use_flags, USE_ALLOW_NONLIVING) && !isliving(user)) // No message for ghosts.
		return USE_FAIL_NONLIVING

	if(NOT_FLAG(use_flags, USE_ALLOW_NON_ADJACENT) && !Adjacent(user))
		if (show_messages)
			to_chat(user, SPAN_NOTICE("You're too far away from [src] to do that."))
		return USE_FAIL_NON_ADJACENT

	if(NOT_FLAG(use_flags, USE_ALLOW_DEAD) && user.stat == DEAD)
		if (show_messages)
			to_chat(user, SPAN_NOTICE("How do you expect to do that when you're dead?"))
		return USE_FAIL_DEAD

	if(NOT_FLAG(use_flags, USE_ALLOW_INCAPACITATED) && (user.incapacitated()))
		if (show_messages)
			to_chat(user, SPAN_NOTICE("You cannot do that in your current state."))
		return USE_FAIL_INCAPACITATED

	if(NOT_FLAG(use_flags, USE_ALLOW_NON_ADV_TOOL_USR) && !user.IsAdvancedToolUser())
		if (show_messages)
			to_chat(user, SPAN_NOTICE("You don't know how to operate [src]."))
		return USE_FAIL_NON_ADV_TOOL_USR

	if(HAS_FLAG(use_flags, USE_DISALLOW_SILICONS) && issilicon(user))
		if (show_messages)
			to_chat(user, SPAN_NOTICE("How do you propose doing that without hands?"))
		return USE_FAIL_IS_SILICON

	if(HAS_FLAG(use_flags, USE_DISALLOW_SPECIALS) && is_mob_special(user))
		if (show_messages)
			to_chat(user, SPAN_NOTICE("Your current mob type prevents you from doing this."))
		return USE_FAIL_IS_MOB_SPECIAL

	if(HAS_FLAG(use_flags, USE_FORCE_SRC_IN_USER) && !(src in user))
		if (show_messages)
			to_chat(user, SPAN_NOTICE("You need to be holding [src] to do that."))
		return USE_FAIL_NOT_IN_USER

/atom/proc/use_check_and_message(mob/user, use_flags = 0)
	. = use_check(user, use_flags, TRUE)

/atom/proc/get_light_and_color(var/atom/origin)
	if(origin)
		color = origin.color
		set_light(origin.light_range, origin.light_power, origin.light_color)

// This function will recurse up the hierarchy containing src, in search of the target. It will stop when it reaches an area, as areas have no loc.
/atom/proc/find_up_hierarchy(var/atom/target)
	var/x = 0 // As a safety, we'll crawl up a maximum of ten layers.
	var/atom/a = src
	while (x < 10)
		x++
		if (isnull(a))
			return 0

		if (a == target) // We found it!
			return 1

		if (istype(a, /area))
			return 0 // Can't recurse any higher than this.

		a = a.loc

	return 0 // If we get here, we must be buried many layers deep in nested containers, which shouldn't happen.

// Recursively searches all atom contents (including the contents' contents and so on).
//
// ARGS:	path - Search atom contents for atoms of this type.
// 			filter_path - If set, contents of atoms not of types in this list are excluded from search.
//
// RETURNS: list of found atoms
/atom/proc/search_contents_for(path,list/filter_path=null)
	var/list/found = list()
	for(var/atom/A in src)
		if(istype(A, path))
			found += A
		if(filter_path)
			var/pass = 0
			for(var/type in filter_path)
				pass |= istype(A, type)
			if(!pass)
				continue
		if(A.contents.len)
			found += A.search_contents_for(path,filter_path)
	return found

// Examination code for all atoms.
/atom/proc/examine(mob/user, var/distance = -1, var/infix = "", var/suffix = "")
	var/f_name = "\a [src][infix]."
	if(src.blood_DNA && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			f_name = "some "
		else
			f_name = "a "
		if(blood_color != COLOR_IPC_BLOOD && blood_color != COLOR_OIL)
			f_name += "<span class='danger'>blood-stained</span> [name][infix]!"
		else
			f_name += "oil-stained [name][infix]."

	to_chat(user, "[icon2html(src, user)] That's [f_name] [suffix]") // Object name. I.e. "This is an Object. It is a normal-sized item."
	to_chat(user, desc)	// Object description.

	// Extra object descriptions examination code.
	if(desc_extended || desc_info || (desc_antag && player_is_antag(user.mind))) // Checks if the object has a extended description, a mechanics description, and/or an antagonist description (and if the user is an antagonist).
		to_chat(user, FONT_SMALL(SPAN_NOTICE("\[?\] This object has additional examine information available. <a href=?src=\ref[src];examine_fluff=1>\[Show In Chat\]</a>"))) // If any of the above are true, show that the object has more information available.
		if(desc_extended) // If the item has a extended description, show that it is available.
			to_chat(user, FONT_SMALL("- This object has an extended description."))
		if(desc_info) // If the item has a description regarding game mechanics, show that it is available.
			to_chat(user, FONT_SMALL(SPAN_NOTICE("- This object has additional information about mechanics.")))
		if(desc_antag && player_is_antag(user.mind)) // If the item has an antagonist description and the user is an antagonist, show that it is available.
			to_chat(user, FONT_SMALL(SPAN_ALERT("- This object has additional information for antagonists.")))

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.glasses)
			H.glasses.glasses_examine_atom(src, H)

	return distance == -1 || (get_dist(src, user) <= distance)

// Same as examine(), but without the "this object has more info" thing and with the extra information instead.
/atom/proc/examine_fluff(mob/user, var/distance = -1, var/infix = "", var/suffix = "")
	var/f_name = "\a [src][infix]."
	if(src.blood_DNA && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			f_name = "some "
		else
			f_name = "a "
		if(blood_color != "#030303")
			f_name += "<span class='danger'>blood-stained</span> [name][infix]!"
		else
			f_name += "oil-stained [name][infix]."

	to_chat(user, "[icon2html(src, user)] That's [f_name] [suffix]") // Object name. I.e. "This is an Object."
	to_chat(user, desc) // Object description.
	if(desc_extended) // If the item has a extended description, show it.
		to_chat(user, desc_extended)
	if(desc_info) // If the item has a description regarding game mechanics, show it.
		to_chat(user, FONT_SMALL(SPAN_NOTICE("- [desc_info]")))
	if(desc_antag && player_is_antag(user.mind)) // If the item has an antagonist description and the user is an antagonist, show it.
		to_chat(user, FONT_SMALL(SPAN_ALERT("- [desc_antag]")))

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.glasses)
			H.glasses.glasses_examine_atom(src, H)

	return distance == -1 || (get_dist(src, user) <= distance)

// Used to check if "examine_fluff" from the HTML link in examine() is true, i.e. if it was clicked.
/atom/Topic(href, href_list)
	. = ..()
	if (.)
		return

	if(href_list["examine_fluff"])
		examine_fluff(usr)

// Called by mobs when e.g. having the atom as their machine, pulledby, loc (AKA mob being inside the atom) or buckled_to var set.
// See code/modules/mob/mob_movement.dm for more.
/atom/proc/relaymove()
	return

// Called to set the atom's dir and used to add behaviour to dir-changes.
/atom/proc/set_dir(new_dir)
	. = new_dir != dir
	dir = new_dir

	// Lighting.
	if (.)
		var/datum/light_source/L
		for (var/thing in light_sources)
			L = thing
			if (L.light_angle)
				L.source_atom.update_light()

/atom/proc/ex_act()
	set waitfor = FALSE
	return

/atom/proc/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	return NO_EMAG_ACT

/atom/proc/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return

/atom/proc/melt()
	return

/atom/proc/hitby(atom/movable/AM as mob|obj, var/speed = THROWFORCE_SPEED_DIVISOR)
	if(density)
		AM.throwing = 0
	return

/atom/proc/add_hiddenprint(mob/living/M)
	if(isnull(M)) return
	if(!istype(M, /mob)) return
	if(isnull(M.key)) return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if (!istype(H.dna, /datum/dna))
			return 0
		if (H.gloves)
			if(src.fingerprintslast != H.key)
				src.fingerprintshidden += text("\[[time_stamp()]\] (Wearing gloves). Real name: [], Key: []",H.real_name, H.key)
				src.fingerprintslast = H.key
			return 0
		if (!( src.fingerprints ))
			if(src.fingerprintslast != H.key)
				src.fingerprintshidden += text("\[[time_stamp()]\] Real name: [], Key: []",H.real_name, H.key)
				src.fingerprintslast = H.key
			return 1
	else
		if(src.fingerprintslast != M.key)
			src.fingerprintshidden += text("\[[time_stamp()]\] Real name: [], Key: []",M.real_name, M.key)
			src.fingerprintslast = M.key
	return

/atom/proc/add_fingerprint(mob/living/M, ignoregloves = 0)
	if(isnull(M)) return
	if(!istype(M, /mob)) return
	if(issilicon(M)) return
	if(isnull(M.key)) return
	if (ishuman(M))
		// Add the list if it does not exist.
		if(!fingerprintshidden)
			fingerprintshidden = list()

		// Fibers.
		add_fibers(M)

		// They have no prints.
		if (HAS_FLAG(M.mutations, mFingerprints))
			if(fingerprintslast != M.key)
				fingerprintshidden += "(Has no fingerprints) Real name: [M.real_name], Key: [M.key]"
				fingerprintslast = M.key
			return 0 //Now, lets get to the dirty work.
		// First, make sure their DNA makes sense.
		var/mob/living/carbon/human/H = M
		if (!istype(H.dna, /datum/dna) || !H.dna.uni_identity || (length(H.dna.uni_identity) != 32))
			if(!istype(H.dna, /datum/dna))
				H.dna = new /datum/dna(null)
				H.dna.real_name = H.real_name
		H.check_dna()

		// Now, deal with gloves.
		if (H.gloves && H.gloves != src)
			if(fingerprintslast != H.key)
				fingerprintshidden += text("\[[]\](Wearing gloves). Real name: [], Key: []",time_stamp(), H.real_name, H.key)
				fingerprintslast = H.key
			H.gloves.add_fingerprint(M)

		// Deal with gloves that pass finger/palm prints.
		if(!ignoregloves)
			if(istype(H.gloves, /obj/item/clothing/gloves) && H.gloves != src)
				var/obj/item/clothing/gloves/G = H.gloves
				if(!prob(G.fingerprint_chance))
					return 0

		// Admin related.
		if(fingerprintslast != H.key)
			fingerprintshidden += text("\[[]\]Real name: [], Key: []",time_stamp(), H.real_name, H.key)
			fingerprintslast = H.key

		// Make the list if it does not exist.
		if(!fingerprints)
			fingerprints = list()

		// Hash it.
		var/full_print = H.get_full_print()

		// Add the fingerprints.
		if(fingerprints[full_print])
			switch(stringpercent(fingerprints[full_print]))	// Tells us how many stars are in the current prints.

				if(28 to 32)
					if(prob(1))
						fingerprints[full_print] = full_print // You rolled a one buddy.
					else
						fingerprints[full_print] = stars(full_print, rand(0,40)) // 24 to 32.

				if(24 to 27)
					if(prob(3))
						fingerprints[full_print] = full_print // Sucks to be you.
					else
						fingerprints[full_print] = stars(full_print, rand(15, 55)) // 20 to 29.

				if(20 to 23)
					if(prob(5))
						fingerprints[full_print] = full_print // Had a good run didn't ya.
					else
						fingerprints[full_print] = stars(full_print, rand(30, 70)) // 15 to 25.

				if(16 to 19)
					if(prob(5))
						fingerprints[full_print] = full_print // Welp.
					else
						fingerprints[full_print]  = stars(full_print, rand(40, 100)) // 0 to 21.

				if(0 to 15)
					if(prob(5))
						fingerprints[full_print] = stars(full_print, rand(0,50)) // Small chance you can smudge.
					else
						fingerprints[full_print] = full_print

		else
			fingerprints[full_print] = stars(full_print, rand(0, 20)) // Initial touch, not leaving much evidence the first time.


		return 1
	else
		// Smudge up the prints a bit.
		if(fingerprintslast != M.key)
			fingerprintshidden += text("\[[]\]Real name: [], Key: []",time_stamp(), M.real_name, M.key)
			fingerprintslast = M.key

	// Cleaning up.
	if(fingerprints && !fingerprints.len)
		qdel(fingerprints)
	return


/atom/proc/transfer_fingerprints_to(var/atom/A)
	if(!istype(A.fingerprints,/list))
		A.fingerprints = list()

	if(!istype(A.fingerprintshidden,/list))
		A.fingerprintshidden = list()

	if(!istype(fingerprintshidden, /list))
		fingerprintshidden = list()

	if(A.fingerprints && fingerprints)
		A.fingerprints |= fingerprints.Copy() // Detective.

	if(A.fingerprintshidden && fingerprintshidden)
		A.fingerprintshidden |= fingerprintshidden.Copy() // Admin. (A.fingerprintslast = fingerprintslast)


// Returns 1 if made bloody, returns 0 otherwise.
/atom/proc/add_blood(mob/living/carbon/human/M)

	if(flags & NOBLOODY)
		return 0

	if(!blood_DNA || !istype(blood_DNA, /list))	// If our list of DNA doesn't exist yet (or isn't a list), initialise it.
		blood_DNA = list()

	was_bloodied = 1
	blood_color = "#A10808"
	if(istype(M))
		if (!istype(M.dna, /datum/dna))
			M.dna = new /datum/dna(null)
			M.dna.real_name = M.real_name
		M.check_dna()
		if (M.species)
			blood_color = M.species.blood_color
	. = 1
	return 1

// For any objects that may require additional handling when swabbed, e.g. a beaker may need to provide information about its contents, not just itself.
// Children must return additional_evidence list.
/atom/proc/get_additional_forensics_swab_info()
	SHOULD_CALL_PARENT(TRUE)
	var/list/additional_evidence = list(
		"type" = "",
		"dna" = list(),
		"gsr" = "",
		"sample_type" = "",
		"sample_message" = ""
	)

	return additional_evidence

/atom/proc/add_vomit_floor(var/mob/living/carbon/M, var/toxvomit = 0, var/datum/reagents/inject_reagents)
	if(istype(src, /turf/simulated))
		var/obj/effect/decal/cleanable/vomit/this = new /obj/effect/decal/cleanable/vomit(src)
		if(istype(inject_reagents) && inject_reagents.total_volume)
			inject_reagents.trans_to_obj(this, min(15, inject_reagents.total_volume))
			this.reagents.add_reagent(/singleton/reagent/acid/stomach, 5)

		// Make toxins related vomit look different.
		if(toxvomit)
			this.icon_state = "vomittox_[pick(1,4)]"

/mob/living/proc/handle_additional_vomit_reagents(var/obj/effect/decal/cleanable/vomit/vomit)
	vomit.reagents.add_reagent(/singleton/reagent/acid/stomach, 5)

/atom/proc/clean_blood()
	if(!simulated)
		return
	fluorescent = 0
	src.germ_level = 0
	if(istype(blood_DNA, /list))
		blood_DNA = null
		return TRUE

/atom/proc/on_rag_wipe(var/obj/item/reagent_containers/glass/rag/R)
	clean_blood()
	R.reagents.splash(src, 1)

/atom/proc/get_global_map_pos()
	if(!islist(global_map) || isemptylist(global_map)) return
	var/cur_x = null
	var/cur_y = null
	var/list/y_arr = null
	for(cur_x=1,cur_x<=global_map.len,cur_x++)
		y_arr = global_map[cur_x]
		cur_y = y_arr.Find(src.z)
		if(cur_y)
			break

	if(cur_x && cur_y)
		return list("x"=cur_x,"y"=cur_y)
	else
		return 0

/atom/proc/checkpass(passflag)
	return pass_flags&passflag

/atom/proc/isinspace()
	if(istype(get_turf(src), /turf/space))
		return 1
	else
		return 0

// Show a message to all mobs and objects in sight of this atom.
// Use for objects performing visible actions.
// The message is output to anyone who can see, e.g. "The [src] does something!"
// "blind_message" (optional) is what blind people will hear e.g. "You hear something!"
/atom/proc/visible_message(var/message, var/blind_message, var/range = world.view, var/intent_message = null, var/intent_range = 7)
	set waitfor = FALSE
	var/list/hearers = get_hearers_in_view(range, src)

	for(var/atom/movable/AM as anything in hearers)
		if(ismob(AM))
			var/mob/M = AM
			if(M.see_invisible < invisibility)
				M.show_message(blind_message, 2)
				continue
		AM.show_message(message, 1, blind_message, 2)

	if(intent_message)
		intent_message(intent_message, intent_range, hearers) // pass our hearers list through to intent_message so it doesn't have to call get_hearers again

// Show a message to all mobs and objects in earshot of this atom.
// Use for objects performing audible actions.
// "message" is the message output to anyone who can hear.
// "deaf_message" (optional) is what deaf people will see.
// "hearing_distance" (optional) is the range, how many tiles away the message can be heard.
/atom/proc/audible_message(var/message, var/deaf_message, var/hearing_distance, var/intent_message = null, var/intent_range = 7)
	set waitfor = FALSE

	if(!hearing_distance)
		hearing_distance = world.view

	var/list/hearers = get_hearers_in_view(hearing_distance, src)

	for(var/atom/movable/AM as anything in hearers)
		AM.show_message(message, 2, deaf_message, 1)

	if(intent_message)
		intent_message(intent_message, intent_range, hearers) // pass our hearers list through to intent_message so it doesn't have to call get_hearers again

/atom/proc/intent_message(var/message, var/range = 7, var/list/hearers = list())
	set waitfor = FALSE
	if(air_sound(src))
		if(!hearers.len)
			hearers = get_hearers_in_view(range, src)
		for(var/mob/living/carbon/human/H as anything in intent_listener)
			if(!(H in hearers))
				if(src.z == H.z && get_dist(src, H) <= range)
					H.intent_listen(src, message)

/atom/proc/change_area(var/area/oldarea, var/area/newarea)
	change_area_name(oldarea.name, newarea.name)

/atom/proc/change_area_name(var/oldname, var/newname)
	name = replacetext(name,oldname,newname)

/atom/movable/proc/dropInto(var/atom/destination)
	while(istype(destination))
		var/atom/drop_destination = destination.onDropInto(src)
		if(!istype(drop_destination) || drop_destination == destination)
			return forceMove(destination)
		destination = drop_destination
	return forceMove(null)

/atom/proc/onDropInto(var/atom/movable/AM)
	return // If onDropInto returns null, then dropInto will forceMove AM into us.

/atom/movable/onDropInto(var/atom/movable/AM)
	return loc // If onDropInto returns something, then dropInto will attempt to drop AM there.

// This proc is used by ghost spawners to assign a player to a specific atom.
// It receives the current mob of the player's argument and MUST return the mob the player has been assigned.
/atom/proc/assign_player(var/mob/user)
	return

/atom/proc/get_contained_external_atoms()
	. = contents

/atom/proc/dump_contents()
	for(var/thing in get_contained_external_atoms())
		var/atom/movable/AM = thing
		AM.dropInto(loc)
		if(ismob(AM))
			var/mob/M = AM
			if(M.client)
				M.client.eye = M.client.mob
				M.client.perspective = MOB_PERSPECTIVE

/atom/proc/check_add_to_late_firers()
	if(SSticker.current_state == GAME_STATE_PLAYING)
		do_late_fire()
		return
	LAZYADD(SSatoms.late_misc_firers, src)

/atom/proc/do_late_fire()
	return

/atom/proc/set_angle(degrees)
	var/matrix/M = matrix()
	M.Turn(degrees)
	// If we aren't 0, make it NN transform.
	if(degrees)
		appearance_flags |= PIXEL_SCALE
	transform = M

/atom/proc/handle_middle_mouse_click(var/mob/user)
	return FALSE

/atom/proc/handle_pointed_at(var/mob/pointer)
	return
