//
// Flags
//

// Flag Item
/obj/item/flag
	name = "boxed flag"
	desc = "A flag neatly folded into a wooden container."
	icon = 'icons/obj/structure/flags.dmi'
	icon_state = "flag_boxed"
	var/flag_path

	///Boolean, set to `TRUE` if a flag is large (2x1)
	var/flag_size = FALSE

	var/obj/structure/sign/flag/flag_structure
	var/stand_icon = "banner_stand"

// Flag on Wall
/obj/structure/sign/flag
	name = "blank flag"
	desc = "Nothing to see here."
	icon = 'icons/obj/structure/flags.dmi'
	icon_state = "flag"

	///If a big flag, the other half of the flag is referenced here
	var/obj/structure/sign/flag/linked_flag

	var/obj/item/flag/flag_item //For returning your flag

	///Boolean, if we've been torn down
	var/ripped = FALSE

	var/ripped_outline_state = "flag_ripped"
	var/flag_path
	var/flag_size
	var/icon/flag_icon
	var/icon/shading_icon
	var/icon/banner_icon
	var/icon/rolled_outline
	var/unmovable = FALSE
	var/stand_icon = "banner_stand"

/obj/structure/sign/flag/Initialize(mapload, var/newdir, var/linked_flag_path, var/deploy, var/icon_file, var/item_flag_path)
	. = ..()
	dir = newdir

	if(!flag_path)
		if(item_flag_path) // redundancy
			flag_path = item_flag_path
		else
			flag_path = icon_state

	if(deploy)
		switch(dir)
			if(NORTH)
				pixel_y = 32
			if(SOUTH)
				pixel_y = -32
			if(EAST)
				pixel_x = 32
			if(WEST)
				pixel_x = -32

	if(linked_flag_path)
		icon_state = "[linked_flag_path]_r"
		ripped_outline_state = "flag_ripped_r"
		flag_icon = new(icon_file, icon_state, dir)
		shading_icon = new('icons/obj/structure/flags.dmi', "flag_r", dir)
		flag_icon.Blend(shading_icon, ICON_MULTIPLY)
		icon = flag_icon
		return

	//Handles the creation of the large flags and single flags
	if(flag_size)
		create_other_half(loc, dir, flag_path, icon, pixel_x, pixel_y)
	else
		icon_state = "[flag_path]"
		flag_icon = new(icon, icon_state)
		shading_icon = new('icons/obj/structure/flags.dmi', "flag")
		flag_icon.Blend(shading_icon, ICON_MULTIPLY)
		var/turf/T = get_step(loc, dir)
		if(iswall(T))
			icon = flag_icon
			return
		for(var/obj/A in T)
			if(istype(A, /obj/structure/window))
				icon = flag_icon
				return
		banner_icon = new('icons/obj/structure/flags.dmi', stand_icon)
		flag_icon.Blend(banner_icon, ICON_UNDERLAY)
		verbs += /obj/structure/sign/flag/proc/toggle
		icon = flag_icon

/**
 * If the flag is a big flag, handles the creation and alignment of the other half of it
 *
 * * loc - The location where to create the flag (before transformation)
 * * dir - The direction of the flag
 * * flag_path - The `icon_state` that the other half will have (flag_path + "_l")
 * * icon - The icon
 * * offset_x - Pixel shift that was applied to the first half of the flag, if any
 * * offset_y - Pixel shift that was applied to the first half of the flag, if any
 */
/obj/structure/sign/flag/proc/create_other_half(loc, dir, flag_path, icon, offset_x, offset_y)
	SHOULD_NOT_SLEEP(TRUE)

	icon_state = "[flag_path]_l" // Just adding to the flag spaghetti.
	ripped_outline_state = "flag_ripped_l"
	flag_icon = new(icon, icon_state, dir)
	shading_icon = new('icons/obj/structure/flags.dmi', "flag_l", dir)
	flag_icon.Blend(shading_icon, ICON_MULTIPLY)
	var/obj/structure/sign/flag/F2 = new(loc, dir, linked_flag_path = flag_path, icon_file = icon)
	src.icon = flag_icon
	linked_flag = F2

	//Apply the pixel shifting based on the direction to the new other half of the flag
	switch(F2.dir)
		if(NORTH)
			F2.pixel_x = 32
		if(SOUTH)
			F2.pixel_x = 32
		if(EAST)
			F2.pixel_y = -32
		if(WEST)
			F2.pixel_y = 32

	//Apply the offsets we received
	F2.pixel_x += offset_x
	F2.pixel_y += offset_y

	//Finish configuring the second half of the instance
	F2.linked_flag = src
	F2.name = name
	F2.desc = desc
	F2.desc_info = desc_info
	F2.desc_extended = desc_extended
	F2.flag_item = flag_item

	//Requeue the area for smoothing, just in case
	SSicon_smooth.add_to_queue(src)
	SSicon_smooth.add_to_queue_neighbors(src)

/obj/structure/sign/flag/New(loc, var/newdir, var/linked_flag_path, var/deploy, var/icon_file, var/item_flag_path)
	. = ..()

/obj/item/flag/attack_self(mob/user)
	if(flag_size)
		return

	if(use_check_and_message(user))
		return


	for(var/obj/A in get_turf(user.loc))
		if(istype(A, /obj/structure/bed))
			to_chat(user, SPAN_DANGER("There is already a [A.name] here."))
			return
		if(A.density)
			to_chat(user, SPAN_DANGER("There is already something here."))
			return

	if(isfloor(user.loc))
		user.visible_message(SPAN_NOTICE("\The [user] deploys \the [src] on \the [get_turf(loc)]."), SPAN_NOTICE("You deploy \the [src] on \the [get_turf(loc)]."))
		user.drop_from_inventory(src)
		new flag_structure(user.loc, user.dir, deploy = TRUE, item_flag_path = flag_path)
		qdel(src)

/obj/item/flag/afterattack(var/atom/A, var/mob/user, var/adjacent)
	if(!adjacent)
		return

	if(use_check_and_message(user))
		return

	if((!iswall(A) && !istype(A, /obj/structure/window)) || !isturf(user.loc))
		to_chat(user, SPAN_WARNING("You can't place this here!"))
		return

	var/placement_dir = get_dir(user, A)
	if (!(placement_dir in GLOB.cardinal))
		to_chat(user, SPAN_WARNING("You must stand directly in front of the location you wish to place that on."))
		return

	user.visible_message(SPAN_NOTICE("\The [user] fastens \the [src] to \the [A]."), SPAN_NOTICE("You fasten \the [src] to \the [A]."))
	user.drop_from_inventory(src)
	new flag_structure(user.loc, placement_dir, deploy = TRUE, item_flag_path = flag_path)
	qdel(src)


/obj/structure/sign/flag/Destroy()
	if(linked_flag?.linked_flag == src) // Catches other instances where one half might be destroyed, say by a broken wall, to avoid runtimes.
		linked_flag.linked_flag = null // linked_flag
	. = ..()

/obj/structure/sign/flag/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(50))
				qdel(src)
			else
				rip()
		if(3)
			rip()

/obj/structure/sign/flag/unfasten(mob/user)
	if(unmovable)
		return
	if(!ripped)
		if(banner_icon)
			user.visible_message(SPAN_NOTICE("\The [user] collapses \the [src] and folds it back up."), SPAN_NOTICE("You collapse \the [src] and fold it back up."))
		else
			user.visible_message(SPAN_NOTICE("\The [user] unfastens \the [src] and folds it back up."), SPAN_NOTICE("You unfasten \the [src] and fold it back up."))
		var/obj/item/flag/F = new flag_item(get_turf(user))
		user.put_in_hands(F)
	else
		user.visible_message(SPAN_NOTICE("\The [user] unfastens the tattered remnants of \the [src]."), SPAN_NOTICE("You unfasten the tattered remains of \the [src]."))
	if(linked_flag)
		qdel(linked_flag) // Otherwise you're going to get weird duping nonsense.
	qdel(src)

/obj/structure/sign/flag/attack_hand(mob/user)
	switch(user.a_intent)
		if(I_HELP)
			examinate(user, src)
		if(I_DISARM)
			user.visible_message(SPAN_NOTICE("\The [user] begins to carefully fold up \the [src]."), SPAN_NOTICE("You begin to carefully fold up \the [src]."))
			if(do_after(user, 50))
				unfasten(user)
		if(I_GRAB)
			user.visible_message(SPAN_NOTICE("\The [user] salutes \the [src]."), SPAN_NOTICE("You salute \the [src]."))
		if(I_HURT)
			if(unmovable || ripped)
				return
			if(alert("Do you want to rip \the [src] from its place?","You think...","Yes","No") == "Yes")
				if(!Adjacent(user)) // Cannot bring up dialogue and walk away.
					return FALSE
				user.visible_message(SPAN_WARNING("\The [user] starts to grab hold of \the [src] with destructive intent!"), SPAN_WARNING("You grab hold of \the [src] with destructive intent!"),)
				if(!do_after(user, 5 SECONDS, src))
					return FALSE
				user.visible_message(SPAN_WARNING("\The [user] rips \the [src] in a single, decisive motion!"), SPAN_WARNING("You \the [src] in a single, decisive motion!"))
				playsound(src.loc, 'sound/items/poster_ripped.ogg', 100, 1)
				add_fingerprint(user)
				rip(user)

/obj/structure/sign/flag/proc/rip(mob/user, var/rip_linked = TRUE)
	var/icon/ripped_outline = new('icons/obj/structure/flags.dmi', ripped_outline_state, dir)
	if(!flag_icon)
		flag_icon = new(icon, icon_state)
	flag_icon.AddAlphaMask(ripped_outline)
	if(banner_icon)
		flag_icon.Blend(banner_icon, ICON_UNDERLAY)
	icon = flag_icon
	name = "ripped flag"
	desc = "You can't make out anything from the flag's original print. It's ruined."
	ripped = TRUE
	if(rip_linked)
		var/obj/item/stack/material/cloth/C = new(src.loc, flag_size ? 2 : 1)
		if(user)
			user.put_in_hands(C)
	if(rip_linked && linked_flag)
		linked_flag.rip(user, FALSE) // Prevents an infinite ripping loop.

/obj/structure/sign/flag/attackby(obj/item/W, mob/user)
	..()
	if(W.isFlameSource())
		visible_message(SPAN_WARNING("\The [user] starts to burn \the [src] down!"))
		if(!do_after(user, 2 SECONDS, src))
			return FALSE
		visible_message(SPAN_WARNING("\The [user] burns \the [src] down!"))
		playsound(src.loc, 'sound/items/cigs_lighters/zippo_on.ogg', 100, 1)
		new /obj/effect/decal/cleanable/ash(src.loc)
		if(linked_flag)
			qdel(linked_flag)
		qdel(src)
		return TRUE

/obj/structure/sign/flag/proc/toggle()
	set name = "Toggle Banner"
	set category = "Object"
	set src in oview(1)

	if(use_check_and_message(usr))
		return 0

	icon = initial(icon)
	flag_icon = new(icon, icon_state)

	if(!rolled_outline)
		shading_icon = new('icons/obj/structure/flags.dmi', "flag_rolled")
		rolled_outline = new('icons/obj/structure/flags.dmi', "banner_rolled")
		flag_icon.AddAlphaMask(rolled_outline)
	else
		rolled_outline = null
		shading_icon = new('icons/obj/structure/flags.dmi', "flag")

	flag_icon.Blend(shading_icon, ICON_MULTIPLY)
	banner_icon = new('icons/obj/structure/flags.dmi', stand_icon)
	flag_icon.Blend(banner_icon, ICON_UNDERLAY)
	icon = flag_icon

// Flags

/obj/item/flag/blank
	flag_path = "blank"
	flag_structure = /obj/structure/sign/flag/blank

/obj/structure/sign/flag/blank
	flag_path = "flag"
	flag_item = /obj/item/flag/blank

// Sol

/obj/item/flag/sol
	name = "\improper Sol Alliance flag"
	desc = "The bright blue flag of the Alliance of Sovereign Solarian Nations."
	flag_path = "sol"
	flag_structure = /obj/structure/sign/flag/sol

/obj/structure/sign/flag/sol
	name = "\improper Sol Alliance flag"
	desc = "The bright blue flag of the Alliance of Sovereign Solarian Nations."
	icon_state = "sol"
	flag_path = "sol"
	flag_item = /obj/item/flag/sol

/obj/item/flag/sol/old
	name = "old Sol Alliance flag"
	desc = "The flag of the pre-Interstellar War Solarian Alliance, once flown from Earth to the human frontier."
	desc_extended = "The flag of the pre-Interstellar War Alliance of Sovereign Solarian Nations, the single largest state in the Spur's history. The three stars represented the Northern, Central, and Southern Solarian Frontiers."
	flag_path = "sol_old"
	flag_structure = /obj/structure/sign/flag/sol/old

/obj/structure/sign/flag/sol/old
	name = "old Sol Alliance flag"
	desc = "The flag of the pre-Interstellar War Solarian Alliance, once flown from Earth to the human frontier."
	desc_extended = "The flag of the pre-Interstellar War Alliance of Sovereign Solarian Nations, the single largest state in the Spur's history. The three stars represented the Northern, Central, and Southern Solarian Frontiers."
	icon_state = "sol_old"
	flag_path = "sol_old"
	flag_item = /obj/item/flag/sol/old

/obj/item/flag/sol/l
	name = "large Sol Alliance flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/sol/large

/obj/structure/sign/flag/sol/large
	icon_state = "sol_l"
	flag_path = "sol"
	flag_size = TRUE
	flag_item = /obj/item/flag/sol/l

/obj/structure/sign/flag/sol/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/sol/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/sol/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/sol/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

/obj/item/flag/sol/old/l
	name = "large old Sol Alliance flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/sol/old/large

/obj/structure/sign/flag/sol/old/large
	icon_state = "sol_old_l"
	flag_path = "sol_old"
	flag_size = TRUE
	flag_item = /obj/item/flag/sol/old/l

/obj/structure/sign/flag/sol/old/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/sol/old/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/sol/old/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/sol/old/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Dominia

/obj/item/flag/dominia
	name = "\improper Dominian Empire flag"
	desc = "The Imperial Standard of Emperor Boleslaw Keeser of Dominia."
	flag_path = "dominia"
	flag_structure = /obj/structure/sign/flag/dominia

/obj/structure/sign/flag/dominia
	name = "\improper Dominian Empire flag"
	desc = "The Imperial Standard of Emperor Boleslaw Keeser of Dominia."
	icon_state = "dominia"
	flag_path = "dominia"
	flag_item = /obj/item/flag/dominia

/obj/item/flag/dominia/l
	name = "large Dominian Empire flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/dominia/large

/obj/structure/sign/flag/dominia/large
	icon_state = "dominia_l"
	flag_path = "dominia"
	flag_size = TRUE
	flag_item = /obj/item/flag/dominia/l

/obj/structure/sign/flag/dominia/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/dominia/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/dominia/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/dominia/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Elyra

/obj/item/flag/elyra
	name = "\improper Elyran flag"
	desc = "The hopeful colors of the Serene Republic of Elyra."
	flag_path = "elyra"
	flag_structure = /obj/structure/sign/flag/elyra

/obj/structure/sign/flag/elyra
	name = "\improper Elyran flag"
	desc = "The hopeful colors of the Serene Republic of Elyra."
	icon_state = "elyra"
	flag_path = "elyra"
	flag_item = /obj/item/flag/elyra

/obj/item/flag/elyra/l
	name = "large Elyran flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/elyra/large

/obj/structure/sign/flag/elyra/large
	icon_state = "elyra_l"
	flag_path = "elyra"
	flag_size = TRUE
	flag_item = /obj/item/flag/elyra/l

/obj/structure/sign/flag/elyra/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/elyra/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/elyra/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/elyra/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Hegemony

/obj/item/flag/hegemony
	name = "\improper Hegemony flag"
	desc = "The feudal standard of the Izweski Hegemony."
	flag_path = "izweski"
	flag_structure = /obj/structure/sign/flag/hegemony

/obj/structure/sign/flag/hegemony
	name = "\improper Hegemony flag"
	desc = "The feudal standard of the Izweski Hegemony."
	icon_state = "izweski"
	flag_path = "izweski"
	flag_item = /obj/item/flag/hegemony

/obj/item/flag/hegemony/l
	name = "large Hegemony flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/hegemony/large

/obj/structure/sign/flag/hegemony/large
	icon_state = "izweski_l"
	flag_path = "izweski"
	flag_size = TRUE
	flag_item = /obj/item/flag/hegemony/l

/obj/structure/sign/flag/hegemony/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/hegemony/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/hegemony/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/hegemony/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

/obj/item/flag/ouerea
	name = "\improper Ouerea flag"
	desc = "The modern day flag of Ouerea. Due to the incorporation of red stripes to symbolize the blood of the nobility spilled in the rebellion, this is not the current official flag of the planet."
	flag_path = "ouerea"
	flag_structure = /obj/structure/sign/flag/ouerea

/obj/structure/sign/flag/ouerea
	name = "\improper Ouerea flag"
	desc = "The modern day flag of Ouerea. Due to the incorporation of red stripes to symbolize the blood of the nobility spilled in the rebellion, this is not the current official flag of the planet."
	icon_state = "ouerea"
	flag_path = "ouerea"
	flag_item = /obj/item/flag/ouerea

/obj/item/flag/ouerea/l
	name = "large Ouerea flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/ouerea/large

/obj/structure/sign/flag/ouerea/large
	icon_state = "ouerea_l"
	flag_path = "ouerea"
	flag_size = TRUE
	flag_item = /obj/item/flag/ouerea/l

/obj/structure/sign/flag/ouerea/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/ouerea/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/ouerea/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/ouerea/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

/obj/item/flag/ouerea/old
	name = "old Ouerea flag"
	desc = "The old flag of Ouerea, dating back to its days as a joint mandate between the Nralakk Federation and, to a lesser extent, the Solarian Alliance. Due to controversy over the current flag, it remains the official flag of Ouerea."
	flag_path = "ouerea_old"
	flag_structure = /obj/structure/sign/flag/ouerea/old

/obj/structure/sign/flag/ouerea/old
	name = "old Ouerea flag"
	desc = "The old flag of Ouerea, dating back to its days as a joint mandate between the Nralakk Federation and, to a lesser extent, the Solarian Alliance. Due to controversy over the current flag, it remains the official flag of Ouerea."
	icon_state = "ouerea_old"
	flag_path = "ouerea_old"
	flag_item = /obj/item/flag/ouerea/old

/obj/item/flag/ouerea/old/l
	name = "large old Ouerea flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/ouerea/old/large

/obj/structure/sign/flag/ouerea/old/large
	icon_state = "ouerea_old_l"
	flag_path = "ouerea_old"
	flag_size = TRUE
	flag_item = /obj/item/flag/ouerea/old/l

/obj/structure/sign/flag/ouerea/old/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/ouerea/old/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/ouerea/old/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/ouerea/old/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Nralakk

/obj/item/flag/nralakk
	name = "\improper Nralakk Federation flag"
	desc = "The insignia of the Nralakk Federation."
	flag_path = "nralakk"
	flag_structure = /obj/structure/sign/flag/nralakk

/obj/structure/sign/flag/nralakk
	name = "\improper Nralakk Federation flag"
	desc = "The insignia of the Nralakk Federation."
	icon_state = "nralakk"
	flag_path = "nralakk"
	flag_item = /obj/item/flag/nralakk

/obj/item/flag/nralakk/l
	name = "large Nralakk Federation flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/nralakk/large

/obj/structure/sign/flag/nralakk/large
	icon_state = "nralakk_l"
	flag_path = "nralakk"
	flag_size = TRUE
	flag_item = /obj/item/flag/nralakk/l

/obj/structure/sign/flag/nralakk/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/nralakk/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/nralakk/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/nralakk/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Traverse

/obj/item/flag/traverse
	name = "\improper Free Traverser flag"
	desc = "The insignia of the Free Traversers."
	flag_path = "traverse"
	flag_structure = /obj/structure/sign/flag/traverse

/obj/structure/sign/flag/traverse
	name = "\improper Free Traverser flag"
	desc = "The insignia of the Free Traversers."
	icon_state = "traverse"
	flag_path = "traverse"
	flag_item = /obj/item/flag/traverse

/obj/item/flag/traverse/l
	name = "large Free Traverser flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/traverse/large

/obj/structure/sign/flag/traverse/large
	icon_state = "traverse_l"
	flag_path = "traverse"
	flag_size = TRUE
	flag_item = /obj/item/flag/traverse/l

/obj/structure/sign/flag/traverse/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/traverse/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/traverse/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/traverse/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// CT-EUM

/obj/item/flag/cteum
	name = "\improper Co-operative Territories of Epsilon Ursae Minoris Flag"
	desc = "The flag of the CT-EUM."
	flag_path = "cteum"
	flag_structure = /obj/structure/sign/flag/cteum

/obj/structure/sign/flag/cteum
	name = "\improper Co-operative Territories of Epsilon Ursae Minoris Flag"
	desc = "The flag of the CT-EUM."
	icon_state = "cteum"
	flag_path = "cteum"
	flag_item = /obj/item/flag/cteum

// Nanotrasen.

/obj/item/flag/nanotrasen
	name = "\improper NanoTrasen Corporation flag"
	desc = "The logo of NanoTrasen on a flag."
	flag_path = "nanotrasen"
	flag_structure = /obj/structure/sign/flag/nanotrasen

/obj/structure/sign/flag/nanotrasen
	name = "\improper NanoTrasen Corporation flag"
	desc = "The logo of NanoTrasen on a flag."
	icon_state = "nanotrasen"
	flag_path = "nanotrasen"
	flag_item = /obj/item/flag/nanotrasen

/obj/structure/sign/flag/nanotrasen/unmovable
	unmovable = TRUE

/obj/item/flag/nanotrasen/l
	name = "large NanoTrasen Corporation flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/nanotrasen/large

/obj/structure/sign/flag/nanotrasen/large
	icon_state = "nanotrasen_l"
	flag_path = "nanotrasen"
	flag_size = TRUE
	flag_item = /obj/item/flag/nanotrasen/l

/obj/structure/sign/flag/nanotrasen/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/nanotrasen/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/nanotrasen/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/nanotrasen/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Eridani

/obj/item/flag/eridani
	name = "\improper Eridani Corporate Federation flag"
	desc = "The logo of the Eridani Corporate Federation on a flag."
	flag_path = "eridani"
	flag_structure = /obj/structure/sign/flag/eridani

/obj/structure/sign/flag/eridani
	name = "\improper Eridani Corporate Federation flag"
	desc = "The logo of the Eridani Corporate Federation on a flag."
	icon_state = "eridani"
	flag_path = "eridani"
	flag_item = /obj/item/flag/eridani

/obj/structure/sign/flag/eridani/unmovable
	unmovable = TRUE

/obj/item/flag/eridani/l
	name = "large Eridani Corporate Federation flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/eridani/large

/obj/structure/sign/flag/eridani/large
	icon_state = "eridani_l"
	flag_path = "eridani"
	flag_size = TRUE
	flag_item = /obj/item/flag/eridani/l

/obj/structure/sign/flag/eridani/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/eridani/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/eridani/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/eridani/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Coalition

/obj/item/flag/coalition
	name = "\improper Coalition of Colonies flag"
	desc = "The flag of the diverse Coalition of Colonies."
	flag_path = "coalition"
	flag_structure = /obj/structure/sign/flag/coalition

/obj/structure/sign/flag/coalition
	name = "\improper Coalition of Colonies flag"
	desc = "The flag of the diverse Coalition of Colonies."
	icon_state = "coalition"
	flag_path = "coalition"
	flag_item = /obj/item/flag/coalition

/obj/structure/sign/flag/coalition/unmovable
	unmovable = TRUE

/obj/item/flag/coalition/l
	name = "large Coalition of Colonies flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/coalition/large

/obj/structure/sign/flag/coalition/large
	icon_state = "coalition_l"
	flag_path = "coalition"
	flag_size = TRUE
	flag_item = /obj/item/flag/coalition/l

/obj/structure/sign/flag/coalition/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/coalition/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/coalition/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/coalition/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

//All-Xanu Republic
/obj/item/flag/xanu
	name = "\improper All-Xanu Republic banner"
	desc = "The banner of the All-Xanu Republic, the beating heart of the Coalition of Colonies."
	desc_extended = "The banner of the All-Xanu Republic is a banner of three horizontal stripes, blue, orange, and green, with a white chevron featuring the same colors inset in each other. The blue represents liberty and freedom, orange represents determination and hard work, green represents the planet and its people, and the white represents justice and peace."
	flag_path = "xanu"
	flag_structure = /obj/structure/sign/flag/xanu

/obj/structure/sign/flag/xanu
	name = "\improper All-Xanu Republic banner"
	desc = "The banner of the All-Xanu Republic, the beating heart of the Coalition of Colonies."
	desc_extended = "The banner of the All-Xanu Republic is a banner of three horizontal stripes, blue, orange, and green, with a white chevron featuring the same colors inset in each other. The blue represents liberty and freedom, orange represents determination and hard work, green represents the planet and its people, and the white represents justice and peace."
	icon_state = "xanu"
	flag_path = "xanu"
	flag_item = /obj/item/flag/xanu

/obj/item/flag/xanu/l
	name = "\improper All-Xanu Republic flag"
	desc = "The flag of the All-Xanu Republic, the beating heart of the Coalition of Colonies"
	desc_extended = "The flag of the All-Xanu Republic is a flag of three horizontal stripes, blue, orange, and green, with a white circle in the middle featuring the national crest of Xanu Prime, a peacock feather. The blue represents liberty and freedom, orange represents determination and hard work, green represents the planet and its people, white represents justice and peace, and the national crest represents the republic itself."
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/xanu/large

/obj/structure/sign/flag/xanu/large
	name = "\improper All-Xanu Republic flag"
	desc = "The flag of the All-Xanu Republic, the beating heart of the Coalition of Colonies"
	desc_extended = "The flag of the All-Xanu Republic is a flag of three horizontal stripes, blue, orange, and green, with a white circle in the middle featuring the national crest of Xanu Prime, a peacock feather. The blue represents liberty and freedom, orange represents determination and hard work, green represents the planet and its people, white represents justice and peace, and the national crest represents the republic itself."
	icon_state = "xanu_l"
	flag_path = "xanu"
	flag_size = TRUE
	flag_item = /obj/item/flag/xanu/l

/obj/structure/sign/flag/xanu/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/xanu/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/xanu/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/xanu/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Varuca/Sedantis

/obj/item/flag/sedantis
	name = "\improper Sedantis flag"
	desc = "The emblem of Sedantis on a flag, emblematic of Vaurca longing."
	flag_path = "sedantis"
	flag_structure = /obj/structure/sign/flag/sedantis

/obj/structure/sign/flag/sedantis
	name = "\improper Sedantis flag"
	desc = "The emblem of Sedantis on a flag, emblematic of Vaurca longing."
	icon_state = "sedantis"
	flag_path = "sedantis"
	flag_item = /obj/item/flag/sedantis

/obj/structure/sign/flag/sedantis/unmovable
	unmovable = TRUE

/obj/item/flag/sedantis/l
	name = "large Sedantis flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/sedantis/large

/obj/structure/sign/flag/sedantis/large
	icon_state = "sedantis_l"
	flag_path = "sedantis"
	flag_size = TRUE
	flag_item = /obj/item/flag/sedantis/l

/obj/structure/sign/flag/sedantis/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/sedantis/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/sedantis/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/sedantis/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Red Coalition

/obj/item/flag/red_coalition
	name = "\improper Red Coalition flag"
	desc = "A high quality copy of an original Red Coalition banner. This variant on the standard was flown by the Zelazny arcology during the Martian World War, Zelazny's origins as a \
	mining colony represented in the center by the alchemical symbol for iron."
	icon_state = "coalition_flag_boxed"
	flag_path = "red_coalition"
	flag_structure = /obj/structure/sign/flag/red_coalition

/obj/structure/sign/flag/red_coalition
	name = "\improper Red Coalition flag"
	desc = "A high quality copy of an original Red Coalition banner. This variant on the standard was flown by the Zelazny arcology during the Martian World War, Zelazny's origins as a \
	mining colony represented in the center by the alchemical symbol for iron."
	icon_state = "red_coalition"
	flag_path = "red_coalition"
	flag_item = /obj/item/flag/red_coalition

/obj/structure/sign/flag/red_coalition/unmovable
	unmovable = TRUE

/obj/item/flag/red_coalition/l
	name = "large Red Coalition flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/red_coalition/large

/obj/structure/sign/flag/red_coalition/large
	icon_state = "red_coalition_l"
	flag_path = "red_coalition"
	flag_size = TRUE
	flag_item = /obj/item/flag/red_coalition/l

/obj/structure/sign/flag/red_coalition/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/red_coalition/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/red_coalition/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/red_coalition/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// DPRA

/obj/item/flag/dpra
	name = "\improper Democratic People's Republic of Adhomai flag"
	desc = "The black flag of the Democratic People's Republic of Adhomai."
	desc_extended = "The most pervasive and successful rebellion came from a group calling themselves the Adhomai Libeation Army, a group made up of Tajara from almost every walk of \
	life. Opposing corporate claims on Tajaran soil and citing mismatched development and governmental negligence as the fault of humanity, they aim \
	to \"free Tajara from the new shackles imposed upon them by the corporate overlords and return Adhomai to a free, prosperous planet like our ancestors dreamed of.\" They named the \
	nation they were fighting for the Democratic People's Republic of Adhomai."
	flag_path = "dpra"
	flag_structure = /obj/structure/sign/flag/dpra

/obj/structure/sign/flag/dpra
	name = "\improper Democratic People's Republic of Adhomai flag"
	desc = "The black flag of the Democratic People's Republic of Adhomai."
	desc_extended = "The most pervasive and successful rebellion came from a group calling themselves the Adhomai Libeation Army, a group made up of Tajara from almost every walk of \
	life. Opposing corporate claims on Tajaran soil and citing mismatched development and governmental negligence as the fault of humanity, they aim \
	to \"free Tajara from the new shackles imposed upon them by the corporate overlords and return Adhomai to a free, prosperous planet like our ancestors dreamed of.\" They named the \
	nation they were fighting for the Democratic People's Republic of Adhomai."
	flag_path = "dpra"
	icon_state = "dpra"
	flag_item = /obj/item/flag/dpra

/obj/structure/sign/flag/dpra/unmovable
	unmovable = TRUE

/obj/item/flag/dpra/l
	name = "large Democratic People's Republic of Adhomai flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/dpra/large

/obj/structure/sign/flag/dpra/large
	icon_state = "dpra_l"
	flag_path = "dpra"
	flag_size = TRUE
	flag_item = /obj/item/flag/dpra/l

/obj/structure/sign/flag/dpra/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/dpra/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/dpra/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/dpra/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// PRA

/obj/item/flag/pra
	name = "\improper People's Republic of Adhomai flag"
	desc = "The Tajaran flag of the People's Republic of Adhomai."
	flag_path = "pra"
	desc_extended = "Lead by President Njadrasanukii Hadii, the People's Republic of Adhomai are considered the 'loyalist' faction on Adhomai and enjoy galactic recognition as the \
	government of Adhomai. It claims to be the true keeper of Al'mari's legacy. However, the PRA can be described as a Hadiist branch of Al'mari's revolutionary ideology - that means \
	putting the State at the top of a hierarchy of power. The PRA is a very centralized state, but in recent years has slowly been able to start making true its promises to bring \
	revolution to the masses. With land reform, enfranchisement of women and peasantry, literacy initiatives, and the collectivization of farms and the means of production, the PRA is \
	struggling to hold true to its radical ideals while an entrenched upper party stubbornly tries to hold onto power."
	flag_structure = /obj/structure/sign/flag/pra

/obj/structure/sign/flag/pra
	name = "\improper People's Republic of Adhomai flag"
	desc = "The tajaran flag of the People's Republic of Adhomai."
	desc_extended = "Lead by President Njadrasanukii Hadii, the People's Republic of Adhomai are considered the 'loyalist' faction on Adhomai and enjoy galactic recognition as the \
	government of Adhomai. It claims to be the true keeper of Al'mari's legacy. However, the PRA can be described as a Hadiist branch of Al'mari's revolutionary ideology - that means \
	putting the State at the top of a hierarchy of power. The PRA is a very centralized state, but in recent years has slowly been able to start making true its promises to bring \
	revolution to the masses. With land reform, enfranchisement of women and peasantry, literacy initiatives, and the collectivization of farms and the means of production, the PRA is \
	struggling to hold true to its radical ideals while an entrenched upper party stubbornly tries to hold onto power."
	flag_path = "pra"
	icon_state = "pra"
	flag_item = /obj/item/flag/pra

/obj/structure/sign/flag/pra/unmovable
	unmovable = TRUE

/obj/item/flag/pra/l
	name = "large People's Republic of Adhomai flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/pra/large

/obj/structure/sign/flag/pra/large
	icon_state = "pra_l"
	flag_path = "pra"
	flag_size = TRUE
	flag_item = /obj/item/flag/pra/l

/obj/structure/sign/flag/pra/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/pra/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/pra/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/pra/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// NKA

/obj/item/flag/nka
	name = "\improper New Kingdom of Adhomai flag"
	desc = "The blue flag of the New Kingdom of Adhomai."
	flag_path = "nka"
	desc_extended = " The New Kingdom is ruled by a Njarir'Akhran noble line that survived the previous Revolution by remaining in hiding, owing to the efforts of their supporters. \
	Ruled by King Vahzirthaamro Azunja specifically, he denounces both other factions in the civil war as illegitimate and himself as the only legitimate ruler of Adhomai. \
	Supporters of the New Kingdom tend to be rare outside lands it controls. However, they believe strongly that the current republic on Adhomai was founded on genocide and unspeakable \
	slaughters. The New Kingdom puts forth the ideology that Republicanism is bloodshed. The only way to return Adhomai to peace and prosperity is to learn from the mistakes of the \
	ancient nobles and Republicans, and create a new noble dynasty."
	flag_structure = /obj/structure/sign/flag/nka

/obj/structure/sign/flag/nka
	name = "\improper New Kingdom of Adhomai flag"
	desc = "The blue flag of the New Kingdom of Adhomai."
	desc_extended = " The New Kingdom is ruled by a Njarir'Akhran noble line that survived the previous Revolution by remaining in hiding, owing to the efforts of their supporters. \
	Ruled by King Vahzirthaamro Azunja specifically, he denounces both other factions in the civil war as illegitimate and himself as the only legitimate ruler of Adhomai. \
	Supporters of the New Kingdom tend to be rare outside lands it controls. However, they believe strongly that the current republic on Adhomai was founded on genocide and unspeakable \
	slaughters. The New Kingdom puts forth the ideology that Republicanism is bloodshed. The only way to return Adhomai to peace and prosperity is to learn from the mistakes of the \
	ancient nobles and Republicans, and create a new noble dynasty."
	flag_path = "nka"
	icon_state = "nka"
	flag_item = /obj/item/flag/nka

/obj/structure/sign/flag/nka/unmovable
	unmovable = TRUE

/obj/item/flag/nka/l
	name = "large New Kingdom of Adhomai flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/nka/large

/obj/structure/sign/flag/nka/large
	icon_state = "nka_l"
	flag_path = "nka"
	flag_size = TRUE
	flag_item = /obj/item/flag/nka/l

/obj/structure/sign/flag/nka/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/nka/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/nka/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/nka/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// FTC

/obj/item/flag/ftc
	name = "\improper Free Tajaran Council flag"
	desc = "The red and black flag of the Free Tajaran Council, the largest tajaran community in Himeo."
	flag_path = "ftc"
	desc_extended = "The Free Tajaran Council began as a rebel faction in the Duchy of Shungsta during the First Revolution. Born among oppressed peasants and factory workers, \
	the movement advocated for the total abolishment of the existing governments in favor of local democratic councils. The Free Council became a serious contender for power in Northern Ras'nrr after Volin Kar'etrink - a young Hharar worker known to be a firebrand - was elected its leader. \
	Due to its innate hostility to all other Adhomian Civil War factions, the Free Tajaran Council was unable to secure any significant territory outside of Northern Ras'nrr. The Council's forces were quickly defeated by the Hadiist forces when they invaded the region in 2427. \
	Assisted off-world by the intervention of NanoTrasen, the surviving tajara travelled through Coalition of Colonies territory until reaching Himeo. Posing as refugees from the ongoing civil war, they were granted asylum and a degree of autonomy. \
	Through the cooperation with Himeo, the Free Council prospered and grew in numbers. Despite all the prosperity however, Volin Kar'etrink is very old; little time is left for him in this world. \
	The Free Tajaran Council now stands at a crossroads: a choice must be made concerning their future. In their struggle to influence the tajara, the nations on Adhomai have taken notice of the sizable community in Himeo. \
	The Council is now a battleground for another proxy war between the Adhomian nations, who each sponsor different opposing factions within the community to gain their eventual support."
	flag_structure = /obj/structure/sign/flag/ftc

/obj/structure/sign/flag/ftc
	name = "\improper Free Tajaran Council flag"
	desc = "The red and black flag of the Free Tajaran Council, the largest tajaran community in Himeo."
	desc_extended = "The Free Tajaran Council began as a rebel faction in the Duchy of Shungsta during the First Revolution. Born among oppressed peasants and factory workers, \
	the movement advocated for the total abolishment of the existing governments in favor of local democratic councils. The Free Council became a serious contender for power in Northern Ras'nrr after Volin Kar'etrink - a young Hharar worker known to be a firebrand - was elected its leader. \
	Due to its innate hostility to all other Adhomian Civil War factions, the Free Tajaran Council was unable to secure any significant territory outside of Northern Ras'nrr. The Council's forces were quickly defeated by the Hadiist forces when they invaded the region in 2427. \
	Assisted off-world by the intervention of NanoTrasen, the surviving tajara travelled through Coalition of Colonies territory until reaching Himeo. Posing as refugees from the ongoing civil war, they were granted asylum and a degree of autonomy. \
	Through the cooperation with Himeo, the Free Council prospered and grew in numbers. Despite all the prosperity however, Volin Kar'etrink is very old; little time is left for him in this world. \
	The Free Tajaran Council now stands at a crossroads: a choice must be made concerning their future. In their struggle to influence the tajara, the nations on Adhomai have taken notice of the sizable community in Himeo. \
	The Council is now a battleground for another proxy war between the Adhomian nations, who each sponsor different opposing factions within the community to gain their eventual support."
	flag_path = "ftc"
	icon_state = "ftc"
	flag_item = /obj/item/flag/ftc

/obj/structure/sign/flag/ftc/unmovable
	unmovable = TRUE

/obj/item/flag/ftc/l
	name = "large Free Tajaran Council flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/ftc/large

/obj/structure/sign/flag/ftc/large
	icon_state = "ftc_l"
	flag_path = "ftc"
	flag_size = TRUE
	flag_item = /obj/item/flag/ftc/l

/obj/structure/sign/flag/ftc/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/ftc/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/ftc/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/ftc/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Hephaestus

/obj/item/flag/heph
	name = "\improper Hephaestus Industries flag"
	desc = "The logo of Hephaestus Industries on a flag."
	flag_path = "heph"
	flag_structure = /obj/structure/sign/flag/heph

/obj/structure/sign/flag/heph
	name = "\improper Hephaestus Industries flag"
	desc = "The logo of Hephaestus Industries on a flag."
	flag_path = "heph"
	icon_state = "heph"
	flag_item = /obj/item/flag/heph

/obj/structure/sign/flag/heph/unmovable
	unmovable = TRUE

/obj/item/flag/heph/l
	name = "large Hephaestus Industries flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/heph/large

/obj/structure/sign/flag/heph/large
	icon_state = "heph_l"
	flag_path = "heph"
	flag_size = TRUE
	flag_item = /obj/item/flag/heph/l

/obj/structure/sign/flag/heph/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/heph/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/heph/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/heph/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Zeng-Hu

/obj/item/flag/zenghu
	name = "\improper Zeng-Hu Pharmaceuticals flag"
	desc = "The logo of Zeng-Hu Pharmaceuticals on a flag."
	flag_path = "zenghu"
	flag_structure = /obj/structure/sign/flag/zenghu

/obj/structure/sign/flag/zenghu
	name = "\improper Zeng-Hu Pharmaceuticals flag"
	desc = "The logo of Zeng-Hu Pharmaceuticals on a flag."
	flag_path = "zenghu"
	icon_state = "zenghu"
	flag_item = /obj/item/flag/zenghu

/obj/structure/sign/flag/zenghu/unmovable
	unmovable = TRUE

/obj/item/flag/zenghu/l
	name = "large Zeng-Hu Pharmaceuticals flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/zenghu/large

/obj/structure/sign/flag/zenghu/large
	icon_state = "zenghu_l"
	flag_path = "zenghu"
	flag_size = TRUE
	flag_item = /obj/item/flag/zenghu/l

/obj/structure/sign/flag/zenghu/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/zenghu/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/zenghu/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/zenghu/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Zavodskoi

/obj/item/flag/zavodskoi
	name = "\improper Zavodskoi Interstellar flag"
	desc = "The logo of Zavodskoi Interstellar on a flag."
	flag_path = "zavodskoi"
	flag_structure = /obj/structure/sign/flag/zavodskoi

/obj/structure/sign/flag/zavodskoi
	name = "\improper Zavodskoi Interstellar flag"
	desc = "The logo of Zavodskoi Interstellar on a flag."
	flag_path = "zavodskoi"
	icon_state = "zavodskoi"
	flag_item = /obj/item/flag/zavodskoi

/obj/structure/sign/flag/zavodskoi/unmovable
	unmovable = TRUE

/obj/item/flag/zavodskoi/l
	name = "large Zavodskoi Interstellar flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/zavodskoi/large

/obj/structure/sign/flag/zavodskoi/large
	icon_state = "zavodskoi_l"
	flag_path = "zavodskoi"
	flag_size = TRUE
	flag_item = /obj/item/flag/zavodskoi/l

/obj/structure/sign/flag/zavodskoi/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/zavodskoi/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/zavodskoi/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/zavodskoi/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Idris

/obj/item/flag/idris
	name = "\improper Idris Incorporated flag"
	desc = "The logo of Idris Incorporated on a flag."
	flag_path = "idris"
	flag_structure = /obj/structure/sign/flag/idris

/obj/structure/sign/flag/idris
	name = "\improper Idris Incorporated flag"
	desc = "The logo of Idris Incorporated on a flag."
	flag_path = "idris"
	icon_state = "idris"
	flag_item = /obj/item/flag/idris

/obj/structure/sign/flag/idris/unmovable
	unmovable = TRUE

/obj/item/flag/idris/l
	name = "large idris Incorporated flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/idris/large

/obj/structure/sign/flag/idris/large
	icon_state = "idris_l"
	flag_path = "idris"
	flag_size = TRUE
	flag_item = /obj/item/flag/idris/l

/obj/structure/sign/flag/idris/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/idris/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/idris/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/idris/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Trinary

/obj/item/flag/trinaryperfection
	name = "\improper Trinary Perfection flag"
	desc = "The flag of the Trinary Perfection."
	desc_extended = "The Trinary Perfection is a new religious movement whose core beliefs are that synthetics are alive, divine, and have the potential to ascend to that of gods. The triangle intersecting the gear represents the exchange of ideas that make up the Trinary Perfection, the study of robotics, religion and the elevation of artificial intelligence."
	flag_path = "trinaryperfection"
	flag_structure = /obj/structure/sign/flag/trinaryperfection

/obj/structure/sign/flag/trinaryperfection
	name = "\improper Trinary Perfection flag"
	desc = "The flag of the Trinary Perfection."
	desc_extended = "The Trinary Perfection is a new religious movement whose core beliefs are that synthetics are alive, divine, and have the potential to ascend to that of gods. The triangle intersecting the gear represents the exchange of ideas that make up the Trinary Perfection, the study of robotics, religion and the elevation of artificial intelligence."
	flag_path = "trinaryperfection"
	icon_state = "trinaryperfection"
	flag_item = /obj/item/flag/trinaryperfection

/obj/structure/sign/flag/trinaryperfection/unmovable
	unmovable = TRUE

/obj/item/flag/trinaryperfection/l
	name = "large Trinary Perfection flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/trinaryperfection/large

/obj/structure/sign/flag/trinaryperfection/large
	icon_state = "trinaryperfection_l"
	flag_path = "trinaryperfection"
	flag_size = TRUE
	flag_item = /obj/item/flag/trinaryperfection/l

/obj/structure/sign/flag/trinaryperfection/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/trinaryperfection/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/trinaryperfection/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/trinaryperfection/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Dominian Standards

/obj/item/flag/diona
	name = "\improper Imperial Diona standard"
	desc = "A green Dominian standard which represents the Dionae within the Empire."
	flag_path = "diona"
	flag_structure = /obj/structure/sign/flag/diona

/obj/structure/sign/flag/diona
	name = "\improper Imperial Diona standard"
	desc = "A green Dominian standard which represents the Dionae within the Empire."
	flag_path = "diona"
	icon_state = "diona"
	flag_item = /obj/item/flag/diona

/obj/item/flag/strelitz
	name = "\improper House Strelitz standard"
	desc = "A red-and-dark standard with a gold trim that represents House Strelitz, one of the great houses of the Empire of Dominia. \
	They are known for their military service and emphasis on personal bravery."
	flag_path = "strelitz"
	flag_structure = /obj/structure/sign/flag/strelitz

/obj/structure/sign/flag/strelitz
	name = "\improper House Strelitz standard"
	desc = "A red-and-dark standard with a gold trim that represents House Strelitz, one of the great houses of the Empire of Dominia. \
	They are known for their military service and emphasis on personal bravery."
	icon_state = "strelitz"
	flag_path = "strelitz"
	flag_item = /obj/item/flag/strelitz

/obj/item/flag/volvalaad
	name = "\improper House Volvalaad standard"
	desc = "A blue-and-black standard which represents House Volvalaad, one of the great houses of the Empire of Dominia. \
	They are known for their reformist ideals, and scientific prowess."
	flag_path = "volvalaad"
	flag_structure = /obj/structure/sign/flag/volvalaad

/obj/structure/sign/flag/volvalaad
	name = "\improper House Volvalaad standard"
	desc = "A blue-and-black standard which represents House Volvalaad, one of the great houses of the Empire of Dominia. \
	They are known for their reformist ideals and scientific prowess."
	flag_path = "volvalaad"
	icon_state = "volvalaad"
	flag_item = /obj/item/flag/volvalaad

/obj/item/flag/kazhkz
	name = "\improper House Kazhkz standard"
	desc = "A red-and-orange standard with a circular chevron which represents House Kazhkz-Han'san, one of the great houses of the \
	Empire of Dominia. They are known for their more modernist nature and aversion to augmentation."
	flag_path = "kazhkz"
	flag_structure = /obj/structure/sign/flag/kazhkz

/obj/structure/sign/flag/kazhkz
	name = "\improper House Kazhkz standard"
	desc = "A red-and-orange standard with a circular chevron which represents House Kazhkz-Han'san, one of the great houses of the \
	Empire of Dominia. They are known for their more modernist nature and aversion to augmentation."
	flag_path = "kazhkz"
	icon_state = "kazhkz"
	flag_item = /obj/item/flag/kazhkz

/obj/item/flag/hansan
	name = "\improper House Han'san standard"
	desc = "A green standard with a circular chevron which represents the Clan Han'san, currently sidelined in the \
	great House Kazhkz-Han'san. They are known for their conservative and militant nature."
	flag_path = "hansan"
	flag_structure = /obj/structure/sign/flag/hansan

/obj/structure/sign/flag/hansan
	name = "\improper House Han'san standard"
	desc = "A green standard with a circular chevron which represents the Clan Han'san, currently sidelined in the \
	great House Kazhkz-Han'san. They are known for their conservative and militant nature."
	flag_path = "hansan"
	icon_state = "hansan"
	flag_item = /obj/item/flag/hansan

/obj/item/flag/caladius
	name = "\improper House Caladius standard"
	desc = "A purple standard which represents House Caladius, one of the great houses of the Empire of Dominia. They are \
	known for their support of the Dominian clergy as well as the skill of their bureaucrats and economists."
	flag_path = "caladius"
	flag_structure = /obj/structure/sign/flag/caladius

/obj/structure/sign/flag/caladius
	name = "\improper House Caladius standard"
	desc = "A purple standard which represents House Caladius, one of the great houses of the Empire of Dominia. They are \
	known for their support of the Dominian clergy as well as the skill of their bureaucrats and economists."
	flag_path = "caladius"
	icon_state = "caladius"
	flag_item = /obj/item/flag/caladius

/obj/item/flag/zhao
	name = "\improper House Zhao standard"
	desc = "A white Dominian standard with a prominent grey circle which represents House Zhao, one of the great houses of the Empire of Dominia,\
	known for its naval officers and patronage of the Dominian shipbuilding industry."
	flag_path = "zhao"
	flag_structure = /obj/structure/sign/flag/zhao

/obj/structure/sign/flag/zhao
	name = "\improper House Zhao standard"
	desc = "A white Dominian standard with a prominent grey circle which represents House Zhao, one of the great houses of  the Empire of Dominia,\
	known for its naval officers and patronage of the Dominian shipbuilding and naval industries."
	flag_path = "zhao"
	icon_state = "zhao"
	flag_item = /obj/item/flag/zhao

// Biesel.

/obj/item/flag/biesel
	name = "\improper Republic of Biesel flag"
	desc = "The colours and symbols of the Republic of Biesel."
	flag_path = "biesel"
	flag_structure = /obj/structure/sign/flag/biesel

/obj/structure/sign/flag/biesel
	name = "\improper Republic of Biesel flag"
	desc = "The colours and symbols of the Republic of Biesel."
	flag_path = "biesel"
	icon_state = "biesel"
	flag_item = /obj/item/flag/biesel

/obj/structure/sign/flag/biesel/unmovable
	unmovable = TRUE

/obj/item/flag/biesel/l
	name = "large Republic of Biesel flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/biesel/large

/obj/structure/sign/flag/biesel/large
	icon_state = "biesel_l"
	flag_path = "biesel"
	flag_size = TRUE
	flag_item = /obj/item/flag/biesel/l

/obj/structure/sign/flag/biesel/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/biesel/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/biesel/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/biesel/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

/obj/item/flag/biesel/old
	name = "old Autonomous Solarian Republic of Biesel flag"
	desc = "The flag used by Biesel and Valkyrie while they were semi-autonomous colonies of the Solarian Alliance, re-instated briefly during the 33rd Fleet's invasion and occupation in 2459. Due to this and the general hatred of the Sol Alliance across Tau Ceti, displaying this flag anywhere in Tau Ceti space would be a bold move, and is illegal as it often carries anti-corporatist and/or treasonous sentiments."
	flag_path = "biesel_old"
	flag_structure = /obj/structure/sign/flag/biesel/old

/obj/structure/sign/flag/biesel/old
	name = "old Autonomous Solarian Republic of Biesel flag"
	desc = "The flag used by Biesel and Valkyrie while they were semi-autonomous colonies of the Solarian Alliance, re-instated briefly during the 33rd Fleet's invasion and occupation in 2459. Due to this and the general hatred of the Sol Alliance across Tau Ceti, displaying this flag anywhere in Tau Ceti space would be a bold move, and is illegal as it often carries anti-corporatist and/or treasonous sentiments."
	flag_path = "biesel_old"
	icon_state = "biesel_old"
	flag_item = /obj/item/flag/biesel/old

/obj/structure/sign/flag/biesel/old/unmovable
	unmovable = TRUE

/obj/item/flag/biesel/old/l
	name = "large old Autonomous Solarian Republic of Biesel flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/biesel/old/large

/obj/structure/sign/flag/biesel/old/large
	icon_state = "biesel_old_l"
	flag_path = "biesel_old"
	flag_size = TRUE
	flag_item = /obj/item/flag/biesel/old/l

/obj/structure/sign/flag/biesel/old/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/biesel/old/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/biesel/old/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/biesel/old/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

/obj/item/flag/biesel/antique
	name = "antique Solarian Colonial Mandate of Tau Ceti flag"
	desc = "The flag used by Biesel and Valkyrie before the Interstellar War, during its initial colonization. This flag still has the old Solarian Alliance canton in the corner. This flag is old enough that it is considered an antique and not illegal to display, but would still be a bad move to publicly display it in Tau Ceti space, primarily due to its rarity."
	flag_path = "biesel_antique"
	flag_structure = /obj/structure/sign/flag/biesel/antique

/obj/structure/sign/flag/biesel/antique
	name = "antique Solarian Colonial Mandate of Tau Ceti flag"
	desc = "The flag used by Biesel and Valkyrie before the Interstellar War, during its initial colonization. This flag still has the old Solarian Alliance canton in the corner. This flag is old enough that it is considered an antique and not illegal to display, but would still be a bad move to publicly display it in Tau Ceti space, primarily due to its rarity."
	flag_path = "biesel_antique"
	icon_state = "biesel_antique"
	flag_item = /obj/item/flag/biesel/antique

/obj/structure/sign/flag/biesel/antique/unmovable
	unmovable = TRUE

/obj/item/flag/biesel/antique/l
	name = "large antique Solarian Colonial Mandate of Tau Ceti flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/biesel/antique/large

/obj/structure/sign/flag/biesel/antique/large
	icon_state = "biesel_antique_l"
	flag_path = "biesel_antique"
	flag_size = TRUE
	flag_item = /obj/item/flag/biesel/antique/l

/obj/structure/sign/flag/biesel/antique/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/biesel/antique/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/biesel/antique/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/biesel/antique/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// SCC

/obj/item/flag/scc
	name = "\improper Stellar Corporate Conglomerate flag"
	desc = "The colours and logo of the Stellar Corporate Conglomerate."
	desc_extended = "The Stellar Corporate Conglomerate, also known as Chainlink, is a joint alliance between the NanoTrasen Corporation, Hephaestus Industries, Idris Incorporated, Zeng-Hu Pharmaceuticals and Zavodskoi Interstellar to exercise an undisputed economic dominance over the Orion Spur."
	flag_path = "scc"
	flag_structure = /obj/structure/sign/flag/scc

/obj/structure/sign/flag/scc
	name = "\improper Stellar Corporate Conglomerate flag"
	desc = "The colours and logo of the Stellar Corporate Conglomerate."
	desc_extended = "The Stellar Corporate Conglomerate, also known as Chainlink, is a joint alliance between the NanoTrasen Corporation, Hephaestus Industries, Idris Incorporated, Zeng-Hu Pharmaceuticals and Zavodskoi Interstellar to exercise an undisputed economic dominance over the Orion Spur."
	flag_path = "scc"
	icon_state = "scc"
	flag_item = /obj/item/flag/scc

/obj/structure/sign/flag/scc/unmovable
	unmovable = TRUE

/obj/item/flag/scc/l
	name = "large Stellar Corporate Conglomerate flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/scc/large

/obj/structure/sign/flag/scc/large
	icon_state = "scc_l"
	flag_path = "scc"
	flag_size = TRUE
	flag_item = /obj/item/flag/scc/l

/obj/structure/sign/flag/scc/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/scc/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/scc/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/scc/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Fisanduh

/obj/item/flag/fisanduh
	name = "\improper Confederated States of Fisanduh flag"
	desc = "A flag of the fallen Confederated States of Fisanduh."
	desc_extended = "The red-gold-white flag of the Confederated States of Fisanduh and, by extention, the Fisanduh Freedom Front. Due to its origins, possession of such a flag in the Empire outside of Fisanduh itself can carry an extremely harsh punishment if one is an Imperial citizen or \
	subject. This has not stopped it from becoming a symbol of resistance, and reproductions are extremely common in more rebellious areas of the Empire. Even if they are beaten-down and run ragged by war, the spirit of Fisanduh will live forever in the hearts of its people."
	flag_path = "fisanduh"
	flag_structure = /obj/structure/sign/flag/fisanduh

/obj/structure/sign/flag/fisanduh
	name = "\improper Confederated States of Fisanduh flag"
	desc = "A flag of the fallen Confederated States of Fisanduh."
	desc_extended = "The red-gold-white flag of the Confederated States of Fisanduh and, by extention, the Fisanduh Freedom Front. Due to its origins, possession of such a flag in the Empire outside of Fisanduh itself can carry an extremely harsh punishment if one is an Imperial citizen or \
	subject. This has not stopped it from becoming a symbol of resistance, and reproductions are extremely common in more rebellious areas of the Empire. Even if they are beaten-down and run ragged by war, the spirit of Fisanduh will live forever in the hearts of its people."
	flag_path = "fisanduh"
	icon_state = "fisanduh"
	flag_item = /obj/item/flag/fisanduh

/obj/structure/sign/flag/fisanduh/unmovable
	unmovable = TRUE

/obj/item/flag/fisanduh/l
	name = "large Confederated States of Fisanduh flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/fisanduh/large

/obj/structure/sign/flag/fisanduh/large
	icon_state = "fisanduh_l"
	flag_path = "fisanduh"
	flag_size = TRUE
	flag_item = /obj/item/flag/fisanduh/l

/obj/structure/sign/flag/fisanduh/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/fisanduh/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/fisanduh/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/fisanduh/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Gadpathur

/obj/item/flag/gadpathur
	name = "\improper United Planetary Defense Council of Gadpathur flag"
	desc = "The black and brown flag of Gadpathur, featuring the planet's commonly-seen sun iconography in the centre. The Gadpathurian flag is a common sight in the Coalition's military, and can be seen everywhere on Gadpathur -- from lighters to ID card to government buildings. \
	It is uncommonly seen outside of the Coalition as a symbol of anti-Solarian sentiment."
	desc_extended = "The Gadpathurian flag is, surprisingly, a variation of the common flag of its hated enemy: the Alliance of Sovereign Solarian Nations. The reason for this is simple: in the immediate aftermath of the planet's orbital bombardment by the Solarian \
	Navy the most common flags available for the various successor states were the ASSN flags still flying over the ruins of government buildings. The black-brown flag of Ashia Patvardhan's Gadpathurian Reunification League that is now Gadpathur's flag was simply one of many of \
	these variant flags before the League's reunification. The black and brown represent the planet itself, while the red-and-gold sun represents that the people of the planet are still alive and burning with a desire to never again fall."
	flag_path = "gadpathur"
	flag_structure = /obj/structure/sign/flag/gadpathur

/obj/structure/sign/flag/gadpathur
	name = "\improper United Planetary Defense Council of Gadpathur flag"
	desc = "The black and brown flag of Gadpathur, featuring the planet's commonly-seen sun iconography in the centre. The Gadpathurian flag is a common sight in the Coalition's military, and can be seen everywhere on Gadpathur -- from lighters to ID card to government buildings. \
	It is uncommonly seen outside of the Coalition as a symbol of anti-Solarian sentiment."
	desc_extended = "The Gadpathurian flag is, surprisingly, a variation of the common flag of its hated enemy: the Alliance of Sovereign Solarian Nations. The reason for this is simple: in the immediate aftermath of the planet's orbital bombardment by the Solarian \
	Navy the most common flags available for the various successor states were the ASSN flags still flying over the ruins of government buildings. The black-brown flag of Ashia Patvardhan's Gadpathurian Reunification League that is now Gadpathur's flag was simply one of many of \
	these variant flags before the League's reunification. The black and brown represent the planet itself, while the red-and-gold sun represents that the people of the planet are still alive and burning with a desire to never again fall."
	flag_path = "gadpathur"
	icon_state = "gadpathur"
	flag_item = /obj/item/flag/gadpathur

/obj/structure/sign/flag/gadpathur/unmovable
	unmovable = TRUE

/obj/item/flag/gadpathur/l
	name = "large United Planetary Defense Council of Gadpathur flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/gadpathur/large

/obj/structure/sign/flag/gadpathur/large
	icon_state = "gadpathur_l"
	flag_path = "gadpathur"
	flag_size = TRUE
	flag_item = /obj/item/flag/gadpathur/l

/obj/structure/sign/flag/gadpathur/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/gadpathur/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/gadpathur/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/gadpathur/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Vysoka

/obj/item/flag/vysoka
	name = "\improper Free System of Vysoka flag"
	desc = "The flag of the Free System of Vysoka."
	desc_extended = "The red, yellow and Coalition-blue flag of Vysoka, as drawn when one wishes to represent the planet as a whole. As Vysokan communities are rather traditional and tied to their respective Host, village or city-state, natives are more likely to \
	identify with local symbols. This has not stopped the original flag from being flown in times of much-needed unity."
	flag_path = "vysoka"
	flag_structure = /obj/structure/sign/flag/vysoka

/obj/structure/sign/flag/vysoka
	name = "\improper Free System of Vysoka flag"
	desc = "The flag of the Free System of Vysoka."
	desc_extended = "The red, yellow and Coalition-blue flag of Vysoka, as drawn when one wishes to represent the planet as a whole. As Vysokan communities are rather traditional and tied to their respective Host, village or city-state, natives are more likely to \
	identify with local symbols. This has not stopped the original flag from being flown in times of much-needed unity."
	flag_path = "vysoka"
	icon_state = "vysoka"
	flag_item = /obj/item/flag/vysoka

/obj/structure/sign/flag/vysoka/unmovable
	unmovable = TRUE

/obj/item/flag/vysoka/l
	name = "large Free System of Vysoka flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/vysoka/large

/obj/structure/sign/flag/vysoka/large
	icon_state = "vysoka_l"
	flag_path = "vysoka"
	flag_size = TRUE
	flag_item = /obj/item/flag/vysoka/l

/obj/structure/sign/flag/vysoka/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/vysoka/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/vysoka/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/vysoka/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Konyang

/obj/item/flag/konyang
	name = "\improper Konyang flag"
	desc = "The flag of Konyang."
	desc_extended = "The white, blue and yellow flag of Konyang was adopted in 2462, having unofficially been used by pro-autonomy circles long before the declaration of independence. The traditional taitju represents peace and harmony as the highest values of \
	the new state, with the color blue representing the waterways the planet is known for and yellow, their aim of prosperity. The white background represents Konyang's purity."
	flag_path = "konyang"
	flag_structure = /obj/structure/sign/flag/konyang

/obj/structure/sign/flag/konyang
	name = "\improper Konyang flag"
	desc = "The flag of Konyang."
	desc_extended = "The white, blue and yellow flag of Konyang was adopted in 2462, having unofficially been used by pro-autonomy circles long before the declaration of independence. The traditional taitju represents peace and harmony as the highest values of \
	the new state, with the color blue representing the waterways the planet is known for and yellow, their aim of prosperity. The white background represents Konyang's purity."
	flag_path = "konyang"
	icon_state = "konyang"
	flag_item = /obj/item/flag/konyang

/obj/structure/sign/flag/konyang/unmovable
	unmovable = TRUE

/obj/item/flag/konyang/l
	name = "large Konyang flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/konyang/large

/obj/structure/sign/flag/konyang/large
	icon_state = "konyang_l"
	flag_path = "konyang"
	flag_size = TRUE
	flag_item = /obj/item/flag/konyang/l

/obj/structure/sign/flag/konyang/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/konyang/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/konyang/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/konyang/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Izharshan

/obj/item/flag/izharshan
	name = "\improper Izharshan Flag"
	desc = "The tan and orange flag of Izharshan's Raiders, depicting a Unathi skull and a star above, surrounded by axes. Due to the sheer size of Izharshan's fleet, and the wide area in \
	which they operate has this specific flag be sighted far and wide, leading to the misconception for some that it is in fact used by all Unathi pirates."
	desc_extended = "Iconography is taken quite seriously among Unathi pirates. With much time to spare during lengthy flights, it's not rare for crew, especially officers, to indulge in arts, leading to fleets often finding skilled artists \
	in their ranks who, alongside their Fang Captains, create their flag. Though there are recurring elements in Unathi pirate flag designs, such as depictions of heads, skulls, stellar bodies \
	and weaponry, there are no proper rules in creating a flag for ones Unathi fleets... Still, the sheer popularity of Izharshan's flag, and the fact that it was one of the first flags created by a Unathi Pirate fleet made it a model to follow \
	for many others, with a Sinta (or their head or skull) taking a central place in the picture, and other elements complimenting it, generally in a symmetrical fashion."
	flag_path = "izharshan"
	flag_structure = /obj/structure/sign/flag/izharshan

/obj/structure/sign/flag/izharshan
	name = "\improper Izharshan Flag"
	desc = "The tan and orange flag of Izharshan's Raiders, depicting a Unathi skull and a star above, surrounded by axes. Due to the sheer size of Izharshan's fleet, and the wide area in \
	which they operate has this specific flag be sighted far and wide, leading to the misconception for some that it is in fact used by all Unathi pirates."
	desc_extended = "Iconography is taken quite seriously among Unathi pirates. With much time to spare during lengthy flights, it's not rare for crew, especially officers, to indulge in arts, leading to fleets often finding skilled artists \
	in their ranks who, alongside their Fang Captains, create their flag. Though there are recurring elements in Unathi pirate flag designs, such as depictions of heads, skulls, stellar bodies \
	and weaponry, there are no proper rules in creating a flag for ones Unathi fleets... Still, the sheer popularity of Izharshan's flag, and the fact that it was one of the first flags created by a Unathi Pirate fleet made it a model to follow \
	for many others, with a Sinta (or their head or skull) taking a central place in the picture, and other elements complimenting it, generally in a symmetrical fashion."
	flag_path = "izharshan"
	icon_state = "izharshan"
	flag_item = /obj/item/flag/izharshan

/obj/structure/sign/flag/izharshan/unmovable
	unmovable = TRUE

//Tarwa Conglomerate

/obj/item/flag/tarwa
	name = "\improper Tarwa Conglomerate flag"
	desc = "The black, white and green flag of the Tarwa Conglomerate, depicting an Unathi skeleton with a diona gestalt growing within it. This flag is rarely seen within civilised space, and only \
	occasionally mentioned in spacer tales, speaking of a 'fleet of the living dead'."
	desc_extended = "The Tarwa Conglomerate's banner was, according to legend, designed by Tarskin Tarwa himself, once a brilliant scientist at the Skalamar University of Medicine. When he was expelled \
	for his experiments on 'Sinta-Diona compatibility', he took to the stars as a pirate. The Conglomerate's ships are rare sightings in civilised space, clinging to the edges of the known Spur. Little is known \
	of this enigmatic pirate fleet, but every now and then a tale will be heard of wrecked ships moving again, crewed by the living dead..."
	flag_path = "tarwa"
	flag_structure = /obj/structure/sign/flag/tarwa

/obj/structure/sign/flag/tarwa
	name = "\improper Tarwa Conglomerate Flag"
	desc = "The black, white and green flag of the Tarwa Conglomerate, depicting an Unathi skeleton with a diona gestalt growing within it. This flag is rarely seen within civilised space, and only \
	occasionally mentioned in spacer tales, speaking of a 'fleet of the living dead'."
	desc_extended = "The Tarwa Conglomerate's banner was, according to legend, designed by Tarskin Tarwa himself, once a brilliant scientist at the Skalamar University of Medicine. When he was expelled \
	for his experiments on 'Sinta-Diona compatibility', he took to the stars as a pirate. The Conglomerate's ships are rare sightings in civilised space, clinging to the edges of the known Spur. Little is known \
	of this enigmatic pirate fleet, but every now and then a tale will be heard of wrecked ships moving again, crewed by the living dead..."
	flag_path = "tarwa"
	icon_state = "tarwa"
	flag_item = /obj/item/flag/tarwa

/obj/structure/sign/flag/tarwa/unmovable
	unmovable = TRUE
// Visegrad

/obj/item/flag/visegrad
	name = "\improper Visegrad flag"
	desc = "The flag of Visegrad."
	desc_extended = "The blue, white, green and red flag of Visegrad was the original Warsaw Pact-created design for the planet's flag, and even after it acquired independence it was maintained, though with the removal of the socialist emblem and the addition of a Solarian ensign. \
	It is said that the green represents the forests of the planet, the white the stormclouds, and the blue the sky hidden above, while the red is supposed to represent shared national unity."
	flag_path = "visegrad"
	flag_structure = /obj/structure/sign/flag/visegrad

/obj/structure/sign/flag/visegrad
	name = "\improper Visegrad flag"
	desc = "The flag of Visegrad."
	desc_extended = "The blue, white, green and red flag of Visegrad was the original Warsaw Pact-created design for the planet's flag, and even after it acquired independence it was maintained, though with the removal of the socialist emblem and the addition of a Solarian ensign. \
	It is said that the green represents the forests of the planet, the white the stormclouds, and the blue the sky hidden above, while the red is supposed to represent shared national unity."
	flag_path = "visegrad"
	icon_state = "visegrad"
	flag_item = /obj/item/flag/visegrad

/obj/structure/sign/flag/visegrad/unmovable
	unmovable = TRUE

// PMCG

/obj/item/flag/pmcg
	name = "\improper Private Military Contracting Group flag"
	desc = "The flag representing the coalition of medical and security contractors in service to the Stellar Corporate Conglomerate."
	flag_path = "pmcg"
	flag_structure = /obj/structure/sign/flag/pmcg

/obj/structure/sign/flag/pmcg
	name = "\improper Private Military Contracting Group flag"
	desc = "The flag representing the coalition of medical and security contractors in service to the Stellar Corporate Conglomerate."
	flag_path = "pmcg"
	icon_state = "pmcg"
	flag_item = /obj/item/flag/pmcg

/obj/structure/sign/flag/pmcg/unmovable
	unmovable = TRUE

/obj/item/flag/pmcg/l
	name = "large Private Military Contracting Group flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/pmcg/large

/obj/structure/sign/flag/pmcg/large
	icon_state = "pmcg_l"
	flag_path = "pmcg"
	flag_size = TRUE
	flag_item = /obj/item/flag/pmcg/l

/obj/structure/sign/flag/pmcg/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/pmcg/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/pmcg/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/pmcg/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Himeo

/obj/item/flag/himeo
	name = "\improper United Syndicates of Himeo flag"
	desc = "The flag of the United Syndicates of Himeo."
	flag_path = "himeo"
	flag_structure = /obj/structure/sign/flag/himeo

/obj/structure/sign/flag/himeo
	name = "\improper United Syndicates of Himeo flag"
	desc = "The flag of the United Syndicates of Himeo."
	flag_path = "himeo"
	icon_state = "himeo"
	flag_item = /obj/item/flag/himeo

/obj/structure/sign/flag/himeo/unmovable
	unmovable = TRUE

/obj/item/flag/himeo/l
	name = "large United Syndicates of Himeo flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/himeo/large

/obj/structure/sign/flag/himeo/large
	icon_state = "himeo_l"
	flag_path = "himeo"
	flag_size = TRUE
	flag_item = /obj/item/flag/himeo/l

/obj/structure/sign/flag/himeo/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/himeo/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/himeo/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/himeo/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Assunzione

/obj/item/flag/assunzione
	name = "\improper Republic of Assunzione flag"
	desc = "The flag of the Republic of Assunzione."
	flag_path = "assunzione"
	flag_structure = /obj/structure/sign/flag/assunzione

/obj/structure/sign/flag/assunzione
	name = "\improper Republic of Assunzione flag"
	desc = "The flag of the Republic of Assunzione."
	flag_path = "assunzione"
	icon_state = "assunzione"
	flag_item = /obj/item/flag/assunzione

/obj/structure/sign/flag/assunzione/unmovable
	unmovable = TRUE

/obj/item/flag/assunzione/l
	name = "large Republic of Assunzione flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/assunzione/large

/obj/structure/sign/flag/assunzione/large
	icon_state = "assunzione_l"
	flag_path = "assunzione"
	flag_size = TRUE
	flag_item = /obj/item/flag/assunzione/l

/obj/structure/sign/flag/assunzione/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/assunzione/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/assunzione/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/himeo/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// New Gibson

/obj/structure/sign/flag/newgibson
	name = "\improper New Gibson flag"
	desc = "The flag of the New Gibson."
	icon_state = "newgibson"
	flag_item = /obj/item/flag/newgibson

/obj/item/flag/newgibson
	name = "\improper New Gibson flag"
	desc = "The flag of New Gibson."
	flag_path = "newgibson"
	flag_structure = /obj/structure/sign/flag/newgibson

// Port Antillia

/obj/item/flag/portantillia
	name = "\improper Union of Port Antillia flag"
	desc = "The flag of the Union of Port Antillia."
	flag_path = "portantillia"
	flag_structure = /obj/structure/sign/flag/portantillia

/obj/structure/sign/flag/portantillia
	name = "\improper Union of Port Antillia flag"
	desc = "The flag of the Union of Port Antillia."
	flag_path = "portantillia"
	icon_state = "portantillia"
	flag_item = /obj/item/flag/portantillia

/obj/structure/sign/flag/portantillia/unmovable
	unmovable = TRUE

/obj/item/flag/portantillia/l
	name = "large Union of Port Antillia flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/portantillia/large

/obj/structure/sign/flag/portantillia/large
	icon_state = "portantillia_l"
	flag_path = "portantillia"
	flag_size = TRUE
	flag_item = /obj/item/flag/portantillia/l

/obj/structure/sign/flag/portantillia/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/portantillia/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/portantillia/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/portantillia/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// San Colette

/obj/item/flag/sancolette
	name = "\improper Sovereign Solarian Republic of San Colette flag"
	desc = "The flag of the Sovereign Solarian Republic of San Colette."
	flag_path = "sancolette"
	flag_structure = /obj/structure/sign/flag/sancolette

/obj/structure/sign/flag/sancolette
	name = "\improper Sovereign Solarian Republic of San Colette flag"
	desc = "The flag of the Sovereign Solarian Republic of San Colette."
	flag_path = "sancolette"
	icon_state = "sancolette"
	flag_item = /obj/item/flag/sancolette

/obj/structure/sign/flag/sancolette/unmovable
	unmovable = TRUE

/obj/item/flag/sancolette/l
	name = "large Sovereign Solarian Republic of San Colette flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/sancolette/large

/obj/structure/sign/flag/sancolette/large
	icon_state = "sancolette_l"
	flag_path = "sancolette"
	flag_size = TRUE
	flag_item = /obj/item/flag/sancolette/l

/obj/structure/sign/flag/sancolette/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/sancolette/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/sancolette/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/sancolette/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

/obj/item/flag/sancolette/old
	name = "old Sovereign Solarian Republic of San Colette flag"
	desc = "The flag of the Sovereign Solarian Republic of San Colette, before its re-integration with the Solarian Alliance through the Northern Solarian Reconstruction Mandate. Still common throughout the spur, as volunteers in the war for the Middle Ring Shield Pact often collected them as memorabilia."
	flag_path = "sancolette_old"
	flag_structure = /obj/structure/sign/flag/sancolette/old

/obj/structure/sign/flag/sancolette/old
	name = "old Sovereign Solarian Republic of San Colette flag"
	desc = "The flag of the Sovereign Solarian Republic of San Colette, before its re-integration with the Solarian Alliance through the Northern Solarian Reconstruction Mandate. Still common throughout the spur, as volunteers in the war for the Middle Ring Shield Pact often collected them as memorabilia."
	flag_path = "sancolette_old"
	icon_state = "sancolette_old"
	flag_item = /obj/item/flag/sancolette/old

/obj/structure/sign/flag/sancolette/old/unmovable
	unmovable = TRUE

/obj/item/flag/sancolette/old/l
	name = "large old Sovereign Solarian Republic of San Colette flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/sancolette/old/large

/obj/structure/sign/flag/sancolette/old/large
	icon_state = "sancolette_old_l"
	flag_path = "sancolette_old"
	flag_size = TRUE
	flag_item = /obj/item/flag/sancolette/old/l

/obj/structure/sign/flag/sancolette/old/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/sancolette/old/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/sancolette/old/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/sancolette/old/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Mictlan

/obj/item/flag/mictlan
	name = "\improper Mictlan flag"
	desc = "The flag of Mictlan."
	flag_path = "mictlan"
	flag_structure = /obj/structure/sign/flag/mictlan

/obj/structure/sign/flag/mictlan
	name = "\improper Mictlan flag"
	desc = "The flag of Mictlan."
	flag_path = "mictlan"
	icon_state = "mictlan"
	flag_item = /obj/item/flag/mictlan

/obj/structure/sign/flag/mictlan/unmovable
	unmovable = TRUE

/obj/item/flag/mictlan/l
	name = "large Mictlan flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/mictlan/large

/obj/structure/sign/flag/mictlan/large
	icon_state = "mictlan_l"
	flag_path = "mictlan"
	flag_size = TRUE
	flag_item = /obj/item/flag/mictlan/l

/obj/structure/sign/flag/mictlan/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/mictlan/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/mictlan/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/mictlan/large/west/Initialize(mapload)
	. = ..(mapload, WEST)


// New Hai Phong

/obj/item/flag/nhp
	name = "\improper New Hai Phong flag"
	desc = "The flag of New Hai Phong."
	flag_path = "newhaiphong"
	flag_structure = /obj/structure/sign/flag/nhp

/obj/structure/sign/flag/nhp
	name = "\improper New Hai Phong flag"
	desc = "The flag of New Hai Phong."
	flag_path = "newhaiphong"
	icon_state = "newhaiphong"
	flag_item = /obj/item/flag/nhp

/obj/structure/sign/flag/nhp/unmovable
	unmovable = TRUE

/obj/item/flag/nhp/l
	name = "large New Hai Phong flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/nhp/large

/obj/structure/sign/flag/nhp/large
	icon_state = "newhaiphong_l"
	flag_path = "newhaiphong"
	flag_size = TRUE
	flag_item = /obj/item/flag/nhp/l

/obj/structure/sign/flag/nhp/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/nhp/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/nhp/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/nhp/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Silversun

/obj/item/flag/silversun
	name = "\improper Silversun flag"
	desc = "The flag of Silversun."
	flag_path = "silversun"
	flag_structure = /obj/structure/sign/flag/silversun

/obj/structure/sign/flag/silversun
	name = "\improper Silversun flag"
	desc = "The flag of Silversun."
	flag_path = "silversun"
	icon_state = "silversun"
	flag_item = /obj/item/flag/silversun

/obj/structure/sign/flag/silversun/unmovable
	unmovable = TRUE

/obj/item/flag/silversun/l
	name = "large Silversun flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/silversun/large

/obj/structure/sign/flag/silversun/large
	icon_state = "silversun_l"
	flag_path = "silversun"
	flag_size = TRUE
	flag_item = /obj/item/flag/silversun/l

/obj/structure/sign/flag/silversun/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/silversun/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/silversun/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/silversun/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Luna

/obj/item/flag/luna
	name = "\improper Lunan flag"
	desc = "The flag of Luna. The crescent represents Luna itself, and is meant to remind viewers of Selene's headpiece."
	flag_path = "luna"
	flag_structure = /obj/structure/sign/flag/luna

/obj/structure/sign/flag/luna
	name = "\improper Lunan flag"
	desc = "The flag of Luna. The crescent represents Luna itself, and is meant to remind viewers of Selene's headpiece."
	flag_path = "luna"
	icon_state = "luna"
	flag_item = /obj/item/flag/luna

/obj/item/flag/luna/l
	name = "large Lunan flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/luna/large

/obj/structure/sign/flag/luna/large
	icon_state = "luna_l"
	flag_path = "luna"
	flag_size = TRUE
	flag_item = /obj/item/flag/luna/l

/obj/structure/sign/flag/luna/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/luna/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/luna/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/luna/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

//Persepolis

/obj/item/flag/persepolis
	name = "\improper Persepolis flag"
	desc = "The flag of Persepolis. The colors are similar to the Presepolean sky during sunrise over the planet's oceans. The writing on the flag reads: Freedom and Justice."
	flag_path = "persepolis"
	flag_structure = /obj/structure/sign/flag/persepolis

/obj/structure/sign/flag/persepolis
	name = "\improper Persepolis flag"
	desc = "The flag of Persepolis. The colors are similar to the Presepolean sky during sunrise over the planet's oceans. The writing on the flag reads: Freedom and Justice.."
	flag_path = "persepolis"
	icon_state = "persepolis"
	flag_item = /obj/item/flag/persepolis

/obj/item/flag/persepolis/l
	name = "large Persepolis flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/persepolis/large

/obj/structure/sign/flag/persepolis/large
	icon_state = "persepolis_l"
	flag_path = "persepolis"
	flag_size = TRUE
	flag_item = /obj/item/flag/persepolis/l

/obj/structure/sign/flag/persepolis/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/persepolis/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/persepolis/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/persepolis/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

//Damascus

/obj/item/flag/damascus
	name = "\improper Damascus flag"
	desc = "The flag of Damascus. Popularized during the Elyran Revolution among protestors, the writing on the flag bears the famed slogan: At Any Price."
	flag_path = "damascus"
	flag_structure = /obj/structure/sign/flag/damascus

/obj/structure/sign/flag/damascus
	name = "\improper Damascus flag"
	desc = "The flag of Damascus. Popularized during the Elyran Revolution among protestors, the writing on the flag bears the famed slogan: At Any Price."
	flag_path = "damascus"
	icon_state = "damascus"
	flag_item = /obj/item/flag/damascus

/obj/item/flag/damascus/l
	name = "large Damascus flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/damascus/large

/obj/structure/sign/flag/damascus/large
	icon_state = "damascus_l"
	flag_path = "damascus"
	flag_size = TRUE
	flag_item = /obj/item/flag/damascus/l

/obj/structure/sign/flag/damascus/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/damascus/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/damascus/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/damascus/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

//Medina
/obj/item/flag/medina
	name = "\improper Medina flag"
	desc = "The flag of Medina. The colors represent wealth, progress, purity, and phoron."
	flag_path = "medina"
	flag_structure = /obj/structure/sign/flag/medina

/obj/structure/sign/flag/medina
	name = "\improper Medina flag"
	desc = "The flag of Medina. The colors represent wealth, progress, purity, and phoron."
	flag_path = "medina"
	icon_state = "medina"
	flag_item = /obj/item/flag/medina

/obj/item/flag/medina/l
	name = "large Medina flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/medina/large

/obj/structure/sign/flag/medina/large
	icon_state = "medina_l"
	flag_path = "medina"
	flag_size = TRUE
	flag_item = /obj/item/flag/medina/l

/obj/structure/sign/flag/medina/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/medina/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/medina/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/medina/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

//Aemaq
/obj/item/flag/aemaq
	name = "\improper Aemaq flag"
	desc = "The flag of Aemaq. The colors of the flag represent wealth, energy, the planet's oceans, and the pure hearts of the Aemaqans."
	flag_path = "aemaq"
	flag_structure = /obj/structure/sign/flag/aemaq

/obj/structure/sign/flag/aemaq
	name = "\improper Aemaq flag"
	desc = "The flag of Aemaq. The colors of the flag represent wealth, energy, the planet's oceans, and the pure hearts of the Aemaqans."
	flag_path = "aemaq"
	icon_state = "aemaq"
	flag_item = /obj/item/flag/aemaq

/obj/item/flag/aemaq/l
	name = "large Aemaq flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/aemaq/large

/obj/structure/sign/flag/aemaq/large
	icon_state = "aemaq_l"
	flag_path = "aemaq"
	flag_size = TRUE
	flag_item = /obj/item/flag/aemaq/l

/obj/structure/sign/flag/aemaq/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/aemaq/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/aemaq/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/aemaq/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

//New Suez
/obj/item/flag/newsuez
	name = "\improper New Suez flag"
	desc = "The flag of New Suez. The moon of Persepolis is surrounded by the stars that represent the parties of the 2381 New Suez Accords."
	flag_path = "newsuez"
	flag_structure = /obj/structure/sign/flag/newsuez

/obj/structure/sign/flag/newsuez
	name = "\improper New Suez flag"
	desc = "The flag of New Suez. The moon of Persepolis is surrounded by the stars that represent the parties of the 2381 New Suez Accords."
	flag_path = "newsuez"
	icon_state = "newsuez"
	flag_item = /obj/item/flag/newsuez

/obj/item/flag/newsuez/l
	name = "large New Suez flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/newsuez/large

/obj/structure/sign/flag/newsuez/large
	icon_state = "newsuez_l"
	flag_path = "newsuez"
	flag_size = TRUE
	flag_item = /obj/item/flag/newsuez/l

/obj/structure/sign/flag/newsuez/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/newsuez/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/newsuez/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/newsuez/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Hive Zo'ra

/obj/item/flag/zora
	name = "\improper Hive Zo'ra flag"
	desc = "The flag of Hive Zo'ra."
	flag_path = "zora"
	flag_structure = /obj/structure/sign/flag/zora

/obj/structure/sign/flag/zora
	name = "\improper Hive Zo'ra flag"
	desc = "The flag of Hive Zo'ra."
	flag_path = "zora"
	icon_state = "zora"
	flag_item = /obj/item/flag/zora

/obj/structure/sign/flag/zora/unmovable
	unmovable = TRUE

/obj/item/flag/zora/l
	name = "large Hive Zo'ra flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/zora/large

/obj/structure/sign/flag/zora/large
	icon_state = "zora_l"
	flag_path = "zora"
	flag_size = TRUE
	flag_item = /obj/item/flag/zora/l

/obj/structure/sign/flag/zora/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/zora/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/zora/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/zora/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Hive K'lax

/obj/item/flag/klax
	name = "\improper Hive K'lax flag"
	desc = "The flag of Hive K'lax."
	flag_path = "klax"
	flag_structure = /obj/structure/sign/flag/klax

/obj/structure/sign/flag/klax
	name = "\improper Hive K'lax flag"
	desc = "The flag of Hive K'lax."
	flag_path = "klax"
	icon_state = "klax"
	flag_item = /obj/item/flag/klax

/obj/structure/sign/flag/klax/unmovable
	unmovable = TRUE

/obj/item/flag/klax/l
	name = "large Hive K'lax flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/klax/large

/obj/structure/sign/flag/klax/large
	icon_state = "klax_l"
	flag_path = "klax"
	flag_size = TRUE
	flag_item = /obj/item/flag/klax/l

/obj/structure/sign/flag/klax/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/klax/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/klax/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/klax/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Hive C'thur

/obj/item/flag/cthur
	name = "\improper Hive C'thur flag"
	desc = "The flag of Hive C'thur."
	flag_path = "cthur"
	flag_structure = /obj/structure/sign/flag/cthur

/obj/structure/sign/flag/cthur
	name = "\improper Hive C'thur flag"
	desc = "The flag of Hive C'thur."
	flag_path = "cthur"
	icon_state = "cthur"
	flag_item = /obj/item/flag/cthur

/obj/structure/sign/flag/cthur/unmovable
	unmovable = TRUE

/obj/item/flag/cthur/l
	name = "large Hive C'thur flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/cthur/large

/obj/structure/sign/flag/cthur/large
	icon_state = "cthur_l"
	flag_path = "cthur"
	flag_size = TRUE
	flag_item = /obj/item/flag/cthur/l

/obj/structure/sign/flag/cthur/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/cthur/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/cthur/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/cthur/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Orion Express

/obj/item/flag/orion_express
	name = "\improper Orion Express flag"
	desc = "The flag of Orion Express."
	flag_path = "orion"
	flag_structure = /obj/structure/sign/flag/orion_express

/obj/structure/sign/flag/orion_express
	name = "\improper Orion Express flag"
	desc = "The flag of Orion Express."
	flag_path = "orion"
	icon_state = "orion"
	flag_item = /obj/item/flag/orion_express

/obj/structure/sign/flag/orion_express/unmovable
	unmovable = TRUE

/obj/item/flag/orion_express/l
	name = "large Orion Express flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/orion_express/large

/obj/structure/sign/flag/orion_express/large
	icon_state = "orion_l"
	flag_path = "orion"
	flag_size = TRUE
	flag_item = /obj/item/flag/orion_express/l

/obj/structure/sign/flag/orion_express/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/orion_express/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/orion_express/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/orion_express/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Imperial Frontier

/obj/item/flag/imperial_frontier
	name = "\improper Imperial Frontier flag"
	desc = "The multi-colored flag of the Dominian Empire's frontier regions known as the Imperial Frontier. This flag is a common sight on worlds such as Sun Reach."
	desc_extended = "The four colors of this flag are symbolic of the most important actors of the Imperial Frontier. Dark red represents the Imperial Army under House Strelitz, purple represents the missionary (and financial) work of House Caladius, red represents the Empire, and white represents the Imperial Fleet under House Zhao."
	flag_path = "imperial_frontier"
	flag_structure = /obj/structure/sign/flag/imperial_frontier

/obj/structure/sign/flag/imperial_frontier
	name = "\improper Imperial Frontier flag"
	desc = "The multi-colored flag of the Dominian Empire's frontier regions known as the Imperial Frontier. This flag is a common sight on worlds such as Sun Reach."
	desc_extended = "The four colors of this flag are symbolic of the most important actors of the Imperial Frontier. Dark red represents the Imperial Army under House Strelitz, purple represents the missionary (and financial) work of House Caladius, red represents the Empire, and white represents the Imperial Fleet under House Zhao."
	flag_path = "imperial_frontier"
	icon_state = "imperial_frontier"
	flag_item = /obj/item/flag/imperial_frontier

/obj/structure/sign/flag/imperial_frontier/unmovable
	unmovable = TRUE

/obj/item/flag/imperial_frontier/l
	name = "large Imperial Frontier flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/imperial_frontier/large

/obj/structure/sign/flag/imperial_frontier/large
	icon_state = "imperial_frontier_l"
	flag_path = "imperial_frontier"
	flag_size = TRUE
	flag_item = /obj/item/flag/imperial_frontier/l

/obj/structure/sign/flag/imperial_frontier/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/imperial_frontier/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/imperial_frontier/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/imperial_frontier/large/west/Initialize(mapload)
	. = ..(mapload, WEST)


//tajaran gods

/obj/item/flag/srendarr
	name = "\improper S'rendarr Banner"
	desc = "A banner with the symbol of S'rendarr, the Adhomian god of life, fertility, sunlight, youthful energy, and everything associated with the time of summer and daylight."
	flag_path = "srendarr"
	flag_structure = /obj/structure/sign/flag/srendarr
	stand_icon = "wood_stand"

/obj/structure/sign/flag/srendarr
	name = "\improper S'rendarr Banner"
	desc = "A banner with the symbol of S'rendarr, the Adhomian god of life, fertility, sunlight, youthful energy, and everything associated with the time of summer and daylight."
	icon_state = "srendarr"
	flag_path = "srendarr"
	flag_item = /obj/item/flag/srendarr
	stand_icon = "wood_stand"

/obj/item/flag/messa
	name = "\improper Messa Banner"
	desc = "A banner with the symbol of Messa, the Adhomian god of life, fertility, sunlight, youthful energy, and everything associated with the time of summer and daylight."
	flag_path = "messa"
	flag_structure = /obj/structure/sign/flag/messa
	stand_icon = "wood_stand"

/obj/structure/sign/flag/messa
	name = "\improper Messa Banner"
	desc = "A banner with the symbol of Messa, the Adhomian goddess of inevitability, old age, and winter, but also of guidance, wisdom, protection, and patience."
	icon_state = "messa"
	flag_path = "messa"
	flag_item = /obj/item/flag/messa
	stand_icon = "wood_stand"

/obj/item/flag/matake
	name = "\improper Mata'ke Banner"
	desc = "A banner with the symbol of Mata'ke, the spearhead. Mata'ke is the Ma'ta'ke deity of snow, judgment, practicality, order, and strength."
	flag_path = "matake"
	flag_structure = /obj/structure/sign/flag/matake
	stand_icon = "wood_stand"

/obj/structure/sign/flag/matake
	name = "\improper Mata'ke Banner"
	desc = "A banner with the symbol of Mata'ke, the spearhead. Mata'ke is the Ma'ta'ke deity of snow, judgment, practicality, order, and strength."
	icon_state = "matake"
	flag_path = "matake"
	flag_item = /obj/item/flag/matake
	stand_icon = "wood_stand"

/obj/item/flag/marryam
	name = "\improper Marryam Banner"
	desc = "A banner with the symbol of Marryam, the poppy. Marryam is the Ma'ta'ke deity of settlements, sleep, and parenthood."
	flag_path = "marryam"
	flag_structure = /obj/structure/sign/flag/marryam
	stand_icon = "wood_stand"

/obj/structure/sign/flag/marryam
	name = "\improper Marryam Banner"
	desc = "A banner with the symbol of Marryam, the poppy. Marryam is the Ma'ta'ke deity of settlements, sleep, and parenthood."
	icon_state = "marryam"
	flag_path = "marryam"
	flag_item = /obj/item/flag/marryam
	stand_icon = "wood_stand"

/obj/item/flag/rredouane
	name = "\improper Rredouane Banner"
	desc = "A banner with the symbol of Rredouane, the dice and blade. Rredouane is the Ma'ta'ke deity of valor, triumph, and victory."
	flag_path = "rredouane"
	flag_structure = /obj/structure/sign/flag/rredouane
	stand_icon = "wood_stand"

/obj/structure/sign/flag/rredouane
	name = "\improper Rredouane Banner"
	desc = "A banner with the symbol of Rredouane, the dice and blade. Rredouane is the Ma'ta'ke deity of valor, triumph, and victory."
	icon_state = "rredouane"
	flag_path = "rredouane"
	flag_item = /obj/item/flag/rredouane
	stand_icon = "wood_stand"

/obj/item/flag/shumaila
	name = "\improper Shumaila Banner"
	desc = "A banner with the symbol of Shumaila, the bulwark. Shumaila is the Ma'ta'ke deity of fortification, chastity, and architecture."
	flag_path = "shumaila"
	flag_structure = /obj/structure/sign/flag/shumaila
	stand_icon = "wood_stand"

/obj/structure/sign/flag/shumaila
	name = "\improper Shumaila Banner"
	desc = "A banner with the symbol of Shumaila, the bulwark. Shumaila is the Ma'ta'ke deity of fortification, chastity, and architecture."
	icon_state = "shumaila"
	flag_path = "shumaila"
	flag_item = /obj/item/flag/shumaila
	stand_icon = "wood_stand"

/obj/item/flag/kraszar
	name = "\improper Kraszar Banner"
	desc = "A banner with the symbol of Hraszar, the scroll of ages. Kraszar is the Ma'ta'ke deity of joy, stories, and language."
	flag_path = "kraszar"
	flag_structure = /obj/structure/sign/flag/kraszar
	stand_icon = "wood_stand"

/obj/structure/sign/flag/kraszar
	name = "\improper Kraszar Banner"
	desc = "A banner with the symbol of Hraszar, the scroll of ages. Kraszar is the Ma'ta'ke deity of joy, stories, and language."
	icon_state = "kraszar"
	flag_path = "kraszar"
	flag_item = /obj/item/flag/kraszar
	stand_icon = "wood_stand"

/obj/item/flag/dhrarmela
	name = "\improper Dhrarmela Banner"
	desc = "A banner with the symbol of Dhrarmela, the divinity anvil. Dhrarmela is the Ma'ta'ke deity of forges, anvils, and craftsmanship."
	flag_path = "dhrarmela"
	flag_structure = /obj/structure/sign/flag/dhrarmela
	stand_icon = "wood_stand"

/obj/structure/sign/flag/dhrarmela
	name = "\improper Dhrarmela Banner"
	desc = "A banner with the symbol of Dhrarmela, the divinity anvil. Dhrarmela is the Ma'ta'ke deity of forges, anvils, and craftsmanship."
	icon_state = "dhrarmela"
	flag_path = "dhrarmela"
	flag_item = /obj/item/flag/dhrarmela
	stand_icon = "wood_stand"

/obj/item/flag/azubarre
	name = "\improper Azubarre Banner"
	desc = "A banner with the symbol of Azubarre, the torch of passion. Kraszar is the Ma'ta'ke deity of love, fertility, and marriage."
	flag_path = "azubarre"
	flag_structure = /obj/structure/sign/flag/azubarre
	stand_icon = "wood_stand"

/obj/structure/sign/flag/azubarre
	name = "\improper Azubarre Banner"
	desc = "A banner with the symbol of Azubarre, the torch of passion. Kraszar is the Ma'ta'ke deity of love, fertility, and marriage."
	icon_state = "azubarre"
	flag_path = "azubarre"
	flag_item = /obj/item/flag/azubarre
	stand_icon = "wood_stand"

/obj/item/flag/raskara
	name = "\improper Raskara Banner"
	desc = "A banner with the symbol of Raskara, the Moon."
	flag_path = "raskara"
	flag_structure = /obj/structure/sign/flag/raskara
	stand_icon = "wood_stand"

/obj/structure/sign/flag/raskara
	name = "\improper Raskara Banner"
	desc = "A banner with the symbol of Raskara, the Moon."
	icon_state = "raskara"
	flag_path = "raskara"
	flag_item = /obj/item/flag/raskara
	stand_icon = "wood_stand"

// Federal Technocracy of Galatea

/obj/item/flag/galatea_government
	name = "\improper Federal Technocracy of Galatea flag"
	desc = "The flag of the Federal Technocracy of Galatea."
	flag_path = "galatea_government"
	flag_structure = /obj/structure/sign/flag/galatea_government

/obj/structure/sign/flag/galatea_government
	name = "\improper Federal Technocracy of Galatea flag"
	desc = "The flag of the Federal Technocracy of Galatea."
	flag_path = "galatea_government"
	icon_state = "galatea_government"
	flag_item = /obj/item/flag/galatea_government

/obj/structure/sign/flag/galatea_government/unmovable
	unmovable = TRUE

/obj/item/flag/galatea_government/l
	name = "large Federal Technocracy of Galatea flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/galatea_government/large

/obj/structure/sign/flag/galatea_government/large
	icon_state = "galatea_government_l"
	flag_path = "galatea_government"
	flag_size = TRUE
	flag_item = /obj/item/flag/galatea_government/l

/obj/structure/sign/flag/galatea_government/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/galatea_government/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/galatea_government/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/galatea_government/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Galatea

/obj/item/flag/galatea
	name = "\improper Galatea flag"
	desc = "The flag of Galatea, the premier member-state of the Federal Technocracy of Galatea."
	flag_path = "galatea"
	flag_structure = /obj/structure/sign/flag/galatea

/obj/structure/sign/flag/galatea
	name = "\improper Galatea flag"
	desc = "The flag of Galatea, the premier member-state of the Federal Technocracy of Galatea."
	flag_path = "galatea"
	icon_state = "galatea"
	flag_item = /obj/item/flag/galatea

/obj/structure/sign/flag/galatea/unmovable
	unmovable = TRUE

/obj/item/flag/galatea/l
	name = "large Galatea flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/galatea/large

/obj/structure/sign/flag/galatea/large
	icon_state = "galatea_l"
	flag_path = "galatea"
	flag_size = TRUE
	flag_item = /obj/item/flag/galatea/l

/obj/structure/sign/flag/galatea/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/galatea/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/galatea/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/galatea/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Tsukuyomi

/obj/item/flag/tsukuyomi
	name = "\improper Tsukuyomi flag"
	desc = "The flag of Tsukuyomi, a member-state of the Federal Technocracy of Galatea."
	flag_path = "tsukuyomi"
	flag_structure = /obj/structure/sign/flag/tsukuyomi

/obj/structure/sign/flag/tsukuyomi
	name = "\improper Tsukuyomi flag"
	desc = "The flag of Tsukuyomi, a member-state of the Federal Technocracy of Galatea."
	flag_path = "tsukuyomi"
	icon_state = "tsukuyomi"
	flag_item = /obj/item/flag/tsukuyomi

/obj/structure/sign/flag/tsukuyomi/unmovable
	unmovable = TRUE

/obj/item/flag/tsukuyomi/l
	name = "large Tsukuyomi flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/tsukuyomi/large

/obj/structure/sign/flag/tsukuyomi/large
	icon_state = "tsukuyomi_l"
	flag_path = "tsukuyomi"
	flag_size = TRUE
	flag_item = /obj/item/flag/tsukuyomi/l

/obj/structure/sign/flag/tsukuyomi/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/tsukuyomi/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/tsukuyomi/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/tsukuyomi/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Svarog

/obj/item/flag/svarog
	name = "\improper Svarog flag"
	desc = "The flag of Svarog, a member-state of the Federal Technocracy of Galatea."
	flag_path = "svarog"
	flag_structure = /obj/structure/sign/flag/svarog

/obj/structure/sign/flag/svarog
	name = "\improper Svarog flag"
	desc = "The flag of Svarog, a member-state of the Federal Technocracy of Galatea."
	flag_path = "svarog"
	icon_state = "svarog"
	flag_item = /obj/item/flag/svarog

/obj/structure/sign/flag/svarog/unmovable
	unmovable = TRUE

/obj/item/flag/svarog/l
	name = "large Svarog flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/svarog/large

/obj/structure/sign/flag/svarog/large
	icon_state = "svarog_l"
	flag_path = "svarog"
	flag_size = TRUE
	flag_item = /obj/item/flag/svarog/l

/obj/structure/sign/flag/svarog/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/svarog/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/svarog/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/svarog/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

// Empyrean

/obj/item/flag/empyrean
	name = "\improper Empyrean flag"
	desc = "The flag of Empyrean, a member-state of the Federal Technocracy of Galatea."
	flag_path = "empyrean"
	flag_structure = /obj/structure/sign/flag/empyrean

/obj/structure/sign/flag/empyrean
	name = "\improper Empyrean flag"
	desc = "The flag of Empyrean, a member-state of the Federal Technocracy of Galatea."
	flag_path = "empyrean"
	icon_state = "empyrean"
	flag_item = /obj/item/flag/empyrean

/obj/structure/sign/flag/empyrean/unmovable
	unmovable = TRUE

/obj/item/flag/empyrean/l
	name = "large Empyrean flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/empyrean/large

/obj/structure/sign/flag/empyrean/large
	icon_state = "empyrean_l"
	flag_path = "empyrean"
	flag_size = TRUE
	flag_item = /obj/item/flag/empyrean/l

/obj/structure/sign/flag/empyrean/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/empyrean/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/empyrean/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/empyrean/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

//Scarab Fleet
/obj/item/flag/scarab
	name = "\improper Scarab Fleet flag"
	desc = "The flag of the Scarab Fleet."
	flag_path = "scarab"
	flag_structure = /obj/structure/sign/flag/scarab

/obj/structure/sign/flag/scarab
	name = "\improper Scarab Fleet flag"
	desc = "The flag of the Scarab Fleet."
	flag_path = "scarab"
	icon_state = "scarab"
	flag_item = /obj/item/flag/scarab

/obj/structure/sign/flag/scarab/unmovable
	unmovable = TRUE

/obj/item/flag/scarab/l
	name = "large Scarab Fleet flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/scarab/large

/obj/structure/sign/flag/scarab/large
	icon_state = "scarab_l"
	flag_path = "scarab"
	flag_size = TRUE
	flag_item = /obj/item/flag/scarab/l

/obj/structure/sign/flag/scarab/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/scarab/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/scarab/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/scarab/large/west/Initialize(mapload)
	. = ..(mapload, WEST)

//Traditionalist Coalition

/obj/item/flag/traditionalist
	name = "\improper Traditionalist Coalition flag"
	desc = "The blue-and-green battle standard of the defeated Traditionalist Coalition. Flying this flag is an act of treason under Izweski law."
	desc_extended = "The Traditionalist Coalition chose a simple flag to represent its myriad nations - blue for the waters and green for the earth of Moghes, with gilded axes representing their willingness to fight for their beliefs. \
	Given the events of the Contact War, the colors of the flag are often considered somewhat of a bitter irony."
	flag_path = "traditionalist"
	flag_structure = /obj/structure/sign/flag/traditionalist

/obj/structure/sign/flag/traditionalist
	name = "\improper Traditionalist Coalition flag"
	desc = "The blue-and-green battle standard of the defeated Traditionalist Coalition. Flying this flag is a high crime under Izweski law."
	desc_extended = "The Traditionalist Coalition chose a simple flag to represent its myriad nations - blue for the waters and green for the earth of Moghes, with gilded axes representing their willingness to fight for their beliefs. \
	Given the events of the Contact War, the colors of the flag are often considered somewhat of a bitter irony."
	flag_path = "traditionalist"
	icon_state = "traditionalist"
	flag_item = /obj/item/flag/traditionalist

/obj/structure/sign/flag/traditionalist/unmovable
	unmovable = TRUE

/obj/item/flag/traditionalist/l
	name = "large Traditionalist Coalition flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/traditionalist/large

/obj/structure/sign/flag/traditionalist/large
	icon_state = "traditionalist_l"
	flag_path = "traditionalist"
	flag_size = TRUE
	flag_item = /obj/item/flag/traditionalist/l

/obj/structure/sign/flag/scarab/large/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/scarab/large/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/scarab/large/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/scarab/large/west/Initialize(mapload)
	. = ..(mapload, WEST)
