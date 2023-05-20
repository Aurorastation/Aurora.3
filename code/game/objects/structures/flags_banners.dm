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
	var/flag_size = FALSE // true if big flag
	var/obj/structure/sign/flag/flag_structure

// Flag on Wall
/obj/structure/sign/flag
	name = "blank flag"
	desc = "Nothing to see here."
	icon = 'icons/obj/structure/flags.dmi'
	icon_state = "flag"
	var/obj/structure/sign/flag/linked_flag //For double flags
	var/obj/item/flag/flag_item //For returning your flag
	var/ripped = FALSE //If we've been torn down
	var/ripped_outline_state = "flag_ripped"
	var/flag_path
	var/flag_size
	var/icon/flag_icon
	var/icon/shading_icon
	var/icon/banner_icon
	var/icon/rolled_outline
	var/unmovable = FALSE

/obj/structure/sign/flag/New(loc, var/newdir, var/linked_flag_path, var/deploy, var/icon_file)
	. = ..()
	dir = newdir
	if(!deploy)
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
	if(flag_size)
		icon_state = "[flag_path]_l" // Just adding to the flag spaghetti.
		ripped_outline_state = "flag_ripped_l"
		flag_icon = new(icon, icon_state, dir)
		shading_icon = new('icons/obj/structure/flags.dmi', "flag_l", dir)
		flag_icon.Blend(shading_icon, ICON_MULTIPLY)
		var/obj/structure/sign/flag/F2 = new(loc, dir, linked_flag_path = flag_path, icon_file = icon)
		icon = flag_icon
		linked_flag = F2
		switch(F2.dir)
			if(NORTH)
				F2.pixel_x = 32
			if(SOUTH)
				F2.pixel_x = 32
			if(EAST)
				F2.pixel_y = -32
			if(WEST)
				F2.pixel_y = 32
		F2.linked_flag = src
		F2.name = name
		F2.desc = desc
		F2.desc_info = desc_info
		F2.desc_extended = desc_extended
		F2.flag_item = flag_item
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
		banner_icon = new('icons/obj/structure/flags.dmi', "banner_stand")
		flag_icon.Blend(banner_icon, ICON_UNDERLAY)
		verbs += /obj/structure/sign/flag/proc/toggle
		icon = flag_icon

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
		new flag_structure(user.loc, user.dir, deploy = TRUE)
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
	if (!(placement_dir in cardinal))
		to_chat(user, SPAN_WARNING("You must stand directly in front of the location you wish to place that on."))
		return

	user.visible_message(SPAN_NOTICE("\The [user] fastens \the [src] to \the [A]."), SPAN_NOTICE("You fasten \the [src] to \the [A]."))
	user.drop_from_inventory(src)
	new flag_structure(user.loc, placement_dir)
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
			user.examinate(src)
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
				if(!do_after(user, 5 SECONDS, act_target = src))
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
		user.put_in_hands(C)
	if(rip_linked && linked_flag)
		linked_flag.rip(user, FALSE) // Prevents an infinite ripping loop.

/obj/structure/sign/flag/attackby(obj/item/W, mob/user)
	..()
	if(W.isFlameSource())
		visible_message(SPAN_WARNING("\The [user] starts to burn \the [src] down!"))
		if(!do_after(user, 2 SECONDS, act_target = src))
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
	banner_icon = new('icons/obj/structure/flags.dmi', "banner_stand")
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

/obj/item/flag/sol/l
	name = "large Sol Alliance flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/sol/large

/obj/structure/sign/flag/sol/large
	icon_state = "sol_l"
	flag_path = "sol"
	flag_size = TRUE
	flag_item = /obj/item/flag/sol/l

/obj/structure/sign/flag/sol/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/sol/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/sol/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/sol/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/dominia/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/dominia/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/dominia/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/dominia/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/elyra/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/elyra/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/elyra/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/elyra/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/hegemony/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/hegemony/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/hegemony/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/hegemony/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/nralakk/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/nralakk/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/nralakk/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/nralakk/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/traverse/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/traverse/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/traverse/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/traverse/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/nanotrasen/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/nanotrasen/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/nanotrasen/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/nanotrasen/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/eridani/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/eridani/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/eridani/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/eridani/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/coalition/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/coalition/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/coalition/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/coalition/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/sedantis/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/sedantis/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/sedantis/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/sedantis/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/red_coalition/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/red_coalition/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/red_coalition/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/red_coalition/large/west/New()
	..(loc, WEST)

// DPRA

/obj/item/flag/dpra
	name = "\improper Democratic People's Republic of Adhomai flag"
	desc = "The black flag of the Democratic People's Republic of Adhomai."
	flag_path = "dpra"
	desc_extended = "The most pervasive and successful rebellion came from a group calling themselves the Adhomai Libeation Army, a group made up of Tajara from almost every walk of \
	life. Opposing corporate claims on Tajaran soil and citing mismatched development and governmental negligence as the fault of humanity, they aim \
	to \"free Tajara from the new shackles imposed upon them by the corporate overlords and return Adhomai to a free, prosperous planet like our ancestors dreamed of.\" They named the \
	nation they were fighting for the Democratic People's Republic of Adhomai."
	flag_structure = /obj/structure/sign/flag/dpra

/obj/structure/sign/flag/dpra
	name = "\improper Democratic People's Republic of Adhomai flag"
	desc = "The black flag of the Democratic People's Republic of Adhomai."
	flag_path = "dpra"
	desc_extended = "The most pervasive and successful rebellion came from a group calling themselves the Adhomai Libeation Army, a group made up of Tajara from almost every walk of \
	life. Opposing corporate claims on Tajaran soil and citing mismatched development and governmental negligence as the fault of humanity, they aim \
	to \"free Tajara from the new shackles imposed upon them by the corporate overlords and return Adhomai to a free, prosperous planet like our ancestors dreamed of.\" They named the \
	nation they were fighting for the Democratic People's Republic of Adhomai."
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

/obj/structure/sign/flag/dpra/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/dpra/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/dpra/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/dpra/large/west/New()
	..(loc, WEST)

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
	flag_path = "pra"
	desc_extended = "Lead by President Njadrasanukii Hadii, the People's Republic of Adhomai are considered the 'loyalist' faction on Adhomai and enjoy galactic recognition as the \
	government of Adhomai. It claims to be the true keeper of Al'mari's legacy. However, the PRA can be described as a Hadiist branch of Al'mari's revolutionary ideology - that means \
	putting the State at the top of a hierarchy of power. The PRA is a very centralized state, but in recent years has slowly been able to start making true its promises to bring \
	revolution to the masses. With land reform, enfranchisement of women and peasantry, literacy initiatives, and the collectivization of farms and the means of production, the PRA is \
	struggling to hold true to its radical ideals while an entrenched upper party stubbornly tries to hold onto power."
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

/obj/structure/sign/flag/pra/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/pra/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/pra/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/pra/large/west/New()
	..(loc, WEST)

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
	flag_path = "nka"
	desc_extended = " The New Kingdom is ruled by a Njarir'Akhran noble line that survived the previous Revolution by remaining in hiding, owing to the efforts of their supporters. \
	Ruled by King Vahzirthaamro Azunja specifically, he denounces both other factions in the civil war as illegitimate and himself as the only legitimate ruler of Adhomai. \
	Supporters of the New Kingdom tend to be rare outside lands it controls. However, they believe strongly that the current republic on Adhomai was founded on genocide and unspeakable \
	slaughters. The New Kingdom puts forth the ideology that Republicanism is bloodshed. The only way to return Adhomai to peace and prosperity is to learn from the mistakes of the \
	ancient nobles and Republicans, and create a new noble dynasty."
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

/obj/structure/sign/flag/nka/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/nka/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/nka/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/nka/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/heph/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/heph/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/heph/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/heph/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/zenghu/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/zenghu/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/zenghu/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/zenghu/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/zavodskoi/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/zavodskoi/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/zavodskoi/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/zavodskoi/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/idris/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/idris/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/idris/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/idris/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/trinaryperfection/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/trinaryperfection/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/trinaryperfection/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/trinaryperfection/large/west/New()
	..(loc, WEST)

// Dominian Standards

/obj/item/flag/diona
	name = "\improper Imperial Diona standard"
	desc = "A green Dominian standard which represents the Dionae within the Empire."
	flag_path = "diona"
	flag_structure = /obj/structure/sign/flag/diona

/obj/structure/sign/flag/diona
	name = "\improper Imperial Diona standard"
	desc = "A green Dominian standard which represents the Dionae within the Empire."
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
	icon_state = "volvalaad"
	flag_item = /obj/item/flag/volvalaad

/obj/item/flag/kazhkz
	name = "\improper House Kazhkz standard"
	desc = "A red-and-orange standard with a circular chevron which represents House Kazhkz, one of the great houses of the \
	Empire of Dominia. They are known for their conservative nature and aversion to augmentation."
	flag_path = "kazhkz"
	flag_structure = /obj/structure/sign/flag/kazhkz

/obj/structure/sign/flag/kazhkz
	name = "\improper House Kazhkz standard"
	desc = "A red-and-orange standard with a circular chevron which represents House Kazhkz, one of the great houses of the \
	Empire of Dominia. They are known for their conservative nature and aversion to augmentation."
	icon_state = "kazkhz"
	flag_item = /obj/item/flag/kazhkz

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

/obj/structure/sign/flag/biesel/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/biesel/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/biesel/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/biesel/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/scc/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/scc/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/scc/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/scc/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/fisanduh/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/fisanduh/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/fisanduh/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/fisanduh/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/gadpathur/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/gadpathur/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/gadpathur/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/gadpathur/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/vysoka/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/vysoka/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/vysoka/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/vysoka/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/konyang/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/konyang/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/konyang/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/konyang/large/west/New()
	..(loc, WEST)

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

/obj/structure/sign/flag/pmcg/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/pmcg/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/pmcg/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/pmcg/large/west/New()
	..(loc, WEST)

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
	name = "large Private Military Contracting Group flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/himeo/large

/obj/structure/sign/flag/himeo/large
	icon_state = "himeo_l"
	flag_path = "himeo"
	flag_size = TRUE
	flag_item = /obj/item/flag/himeo/l

/obj/structure/sign/flag/himeo/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/himeo/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/himeo/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/himeo/large/west/New()
	..(loc, WEST)

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
	name = "large Private Military Contracting Group flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/assunzione/large

/obj/structure/sign/flag/assunzione/large
	icon_state = "assunzione_l"
	flag_path = "assunzione"
	flag_size = TRUE
	flag_item = /obj/item/flag/assunzione/l

/obj/structure/sign/flag/assunzione/large/north/New()
	..(loc, NORTH)

/obj/structure/sign/flag/assunzione/large/south/New()
	..(loc, SOUTH)

/obj/structure/sign/flag/assunzione/large/east/New()
	..(loc, EAST)

/obj/structure/sign/flag/himeo/large/west/New()
	..(loc, WEST)

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
