/obj/structure/pit
	name = "pit"
	desc = "Watch your step, partner."
	icon = 'icons/obj/pit.dmi'
	icon_state = "pit1"
	blend_mode = BLEND_MULTIPLY
	density = FALSE
	anchored = TRUE
	var/open = 1

/obj/structure/pit/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/shovel))
		visible_message(SPAN_NOTICE("\The [user] starts [open ? "filling" : "digging open"] \the [src]"))
		if(attacking_item.use_tool(src, user, 50, volume = 50))
			visible_message(SPAN_NOTICE("\The [user] [open ? "fills" : "digs open"] \the [src]!"))
			if(open)
				close(user)
			else
				open()
		else
			to_chat(user, SPAN_NOTICE("You stop shoveling."))
		return
	if (!open && istype(attacking_item, /obj/item/stack/material/wood))
		if(locate(/obj/structure/gravemarker) in src.loc)
			to_chat(user, SPAN_NOTICE("There's already a grave marker here."))
		else
			visible_message(SPAN_NOTICE("\The [user] starts making a grave marker on top of \the [src]"))
			if( do_after(user, 50) )
				visible_message(SPAN_NOTICE("\The [user] finishes the grave marker"))
				var/obj/item/stack/material/wood/plank = attacking_item
				plank.use(1)
				new/obj/structure/gravemarker(src.loc)
			else
				to_chat(user, SPAN_NOTICE("You stop making a grave marker."))
		return
	..()

/obj/structure/pit/update_icon()
	icon_state = "pit[open]"
	if(istype(loc,/turf/simulated/floor/exoplanet))
		var/turf/simulated/floor/exoplanet/E = loc
		if(E.dirt_color)
			color = E.dirt_color

/obj/structure/pit/proc/open()
	name = "pit"
	desc = "Watch your step, partner."
	open = 1
	for(var/atom/movable/A in src)
		A.forceMove(src.loc)
	update_icon()

/obj/structure/pit/proc/close(var/user)
	name = "mound"
	desc = "Some things are better left buried."
	open = 0
	for(var/atom/movable/A in src.loc)
		if(!A.anchored && A != user)
			A.forceMove(src)
	update_icon()

/obj/structure/pit/return_air()
	if(open && loc)
		return loc.return_air()

/obj/structure/pit/proc/digout(mob/escapee)
	var/breakout_time = 1 //2 minutes by default

	if(open)
		return

	if(escapee.stat || escapee.restrained())
		return

	escapee.setClickCooldown(100)
	to_chat(escapee, SPAN_WARNING("You start digging your way out of \the [src] (this will take about [breakout_time] minute\s)"))
	visible_message(SPAN_DANGER("Something is scratching its way out of \the [src]!"))

	for(var/i in 1 to (6*breakout_time * 2)) //minutes * 6 * 5seconds * 2
		playsound(src.loc, 'sound/weapons/bite.ogg', 100, 1)

		if(!do_after(escapee, 50))
			to_chat(escapee, SPAN_WARNING("You have stopped digging."))
			return
		if(open)
			return

		if(i == 6*breakout_time)
			to_chat(escapee, SPAN_WARNING("Halfway there..."))

	to_chat(escapee, SPAN_WARNING("You successfuly dig yourself out!"))
	visible_message(SPAN_DANGER("\the [escapee] emerges from \the [src]!"))
	playsound(src.loc, 'sound/effects/squelch1.ogg', 100, 1)
	open()

/obj/structure/pit/Crossed(AM as mob|obj)
	for(var/obj/item/landmine/I in contents)
		I.Crossed(AM, TRUE)
	..()

/obj/structure/pit/closed
	name = "mound"
	desc = "Some things are better left buried."
	open = FALSE

/obj/structure/pit/closed/Initialize()
	. = ..()
	close()

//invisible until unearthed first
/obj/structure/pit/closed/hidden
	invisibility = INVISIBILITY_OBSERVER

/obj/structure/pit/closed/hidden/open()
	..()
	set_invisibility(INVISIBILITY_LEVEL_ONE)


//buried land mines

/obj/structure/pit/landmine
	name = "mound"
	desc = "Some things are better left buried."
	open = FALSE
	var/landmine_prob = 25

/obj/structure/pit/landmine/Initialize()
	. = ..()
	if(prob(landmine_prob))
		new /obj/item/landmine(src)
	close()

/obj/structure/pit/landmine/hidden
	invisibility = INVISIBILITY_OBSERVER

/obj/structure/pit/landmine/hidden/open()
	..()
	set_invisibility(INVISIBILITY_LEVEL_ONE)

//spoooky
/obj/structure/pit/closed/grave
	name = "grave"
	icon_state = "pit0"
	///Will this grave generate a marker?
	var/marker = TRUE
	///What species should this grave's marker be for?
	var/species = SPECIES_HUMAN

/obj/structure/pit/closed/grave/Initialize()
	var/obj/structure/closet/crate/coffin/C = new(src.loc)
	var/obj/effect/decal/remains/human/bones = new(C)
	bones.layer = LYING_MOB_LAYER
	if(marker)
		var/obj/structure/gravemarker/random/R = new(src.loc)
		R.generate(species)
	. = ..()

/obj/structure/gravemarker
	name = "grave marker"
	desc = "You're not the first."
	icon = 'icons/obj/gravestone.dmi'
	icon_state = "wood"
	pixel_x = 15
	pixel_y = 8
	anchored = TRUE
	var/message = "Unknown."

/obj/structure/gravemarker/cross
	icon_state = "cross"

/obj/structure/gravemarker/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += "It says: '[message]'."

/obj/structure/gravemarker/random/Initialize()
	generate()
	. = ..()

/obj/structure/gravemarker/random/proc/generate(var/species)
	icon_state = pick("wood","cross")
	var/nam = random_name(pick(MALE,FEMALE), species)
	message = "Here lies [nam]."

/obj/structure/gravemarker/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/material/hatchet))
		visible_message("<span class = 'warning'>\The [user] starts hacking away at \the [src] with \the [attacking_item].</span>")
		if(!do_after(user, 30))
			visible_message("<span class = 'warning'>\The [user] hacks \the [src] apart.</span>")
			new /obj/item/stack/material/wood(src)
			qdel(src)
	if(istype(attacking_item, /obj/item/pen))
		var/msg = sanitize(input(user, "What should it say?", "Grave marker", message) as text|null)
		if(msg)
			message = msg
