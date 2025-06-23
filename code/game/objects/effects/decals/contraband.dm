
//########################## CONTRABAND ;3333333333333333333 -Agouri ###################################################

/obj/item/contraband
	name = "contraband item"
	desc = "You probably shouldn't be holding this."
	icon = 'icons/obj/contraband.dmi'
	force = 0


/obj/item/contraband/poster
	name = "rolled-up poster"
	desc = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface."
	icon_state = "rolled_poster"
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'
	/// Set this variable to a /singleton/poster_design specify a desired poster.
	/// If unset, is randomly set on `Initialize()`
	var/singleton/poster_design/poster_type

/obj/item/contraband/poster/Initialize(mapload, given_type)
	. = ..()
	if(!poster_type)
		if(!given_type)
			poster_type = pick(GET_SINGLETON_SUBTYPE_LIST(/singleton/poster_design))
		else
			poster_type = given_type
	else
		poster_type = GET_SINGLETON(poster_type)
	name += " - [poster_type.name]"

//Places the poster on a wall
/obj/item/contraband/poster/afterattack(var/atom/A, var/mob/user, var/adjacent, var/clickparams)
	if (!adjacent)
		return

	//must place on a wall and user must not be inside a closet/mecha/whatever
	var/turf/W = A
	if (!iswall(W) || !isturf(user.loc))
		to_chat(user, SPAN_WARNING("You can't place this here!"))
		return

	var/placement_dir = get_dir(user, W)
	if (!(placement_dir in GLOB.cardinals))
		to_chat(user, SPAN_WARNING("You must stand directly in front of the wall you wish to place that on."))
		return

	//just check if there is a poster on or adjacent to the wall
	var/stuff_on_wall = 0
	if (locate(/obj/structure/sign/poster) in W)
		stuff_on_wall = 1

	//crude, but will cover most cases. We could do stuff like check pixel_x/y but it's not really worth it.
	for (var/dir in GLOB.cardinals)
		var/turf/T = get_step(W, dir)
		if (locate(/obj/structure/sign/poster) in T)
			stuff_on_wall = 1
			break

	if (stuff_on_wall)
		to_chat(user, SPAN_NOTICE("There is already a poster there!"))
		return

	to_chat(user, SPAN_NOTICE("You start placing the poster on the wall...")) //Looks like it's uncluttered enough. Place the poster.)

	var/obj/structure/sign/poster/P = new(user.loc, get_dir(user, W), poster_type)

	flick("poster_being_set", P)
	playsound(W, 'sound/items/package_wrap.ogg', 100, 1)

	addtimer(CALLBACK(src, PROC_REF(place_on_wall), P, user, W), 28, TIMER_CLIENT_TIME)

/obj/item/contraband/poster/proc/place_on_wall(obj/structure/sign/poster/P, mob/user, turf/W)
	if (QDELETED(P))
		return

	if (iswall(W) && !QDELETED(user) && P.loc == user.loc)
		to_chat(user, SPAN_NOTICE("You place the poster!"))
	else
		P.roll_and_drop(P.loc)

	qdel(src)

//############################## THE ACTUAL DECALS ###########################

/obj/structure/sign/poster
	name = "poster"
	desc = "A large piece of space-resistant printed paper. "
	icon = 'icons/obj/contraband.dmi'
	icon_state = "poster_map"
	anchored = 1
	/// Set this variable to a /singleton/poster_design to specify a desired poster.
	/// If unset, is randomly set on `Initialize()`
	var/singleton/poster_design/poster_type
	var/ruined = FALSE

/obj/structure/sign/poster/Initialize(mapload, placement_dir = null, type = null)
	. = ..()

	if (poster_type)
		poster_type = GET_SINGLETON(poster_type)
	else if(type)
		poster_type = type
	else
		poster_type = pick(GET_SINGLETON_SUBTYPE_LIST(/singleton/poster_design))

	set_poster(poster_type)

	switch (placement_dir)
		if (NORTH)
			pixel_x = 0
			pixel_y = 32
		if (SOUTH)
			pixel_x = 0
			pixel_y = -32
		if (EAST)
			pixel_x = 32
			pixel_y = 0
		if (WEST)
			pixel_x = -32
			pixel_y = 0


/obj/structure/sign/poster/proc/set_poster(var/singleton/poster_design/design)
	name = "[initial(name)] - [design.name]"
	desc = "[initial(desc)] [design.desc]"
	icon_state = design.icon_state

/obj/structure/sign/poster/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswirecutter())
		playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
		if(ruined)
			to_chat(user, SPAN_NOTICE("You remove the remnants of the poster."))
			qdel(src)
		else
			to_chat(user, SPAN_NOTICE("You carefully remove the poster from the wall."))
			roll_and_drop(user.loc)
		return TRUE


/obj/structure/sign/poster/attack_hand(mob/user as mob)
	if(ruined)
		return
	if(user.a_intent == I_HELP)
		examinate(user, src)
		return
	if(alert("Do I want to rip the poster from the wall?","You think...","Yes","No") == "Yes")
		if(ruined || !user.Adjacent(src))
			return
		visible_message(SPAN_WARNING("\The [user] rips \the [src] in a single, decisive motion!") )
		playsound(src.loc, 'sound/items/poster_ripped.ogg', 100, 1)
		ruined = TRUE
		icon_state = "poster_ripped"
		name = "ripped poster"
		desc = "You can't make out anything from the poster's original print. It's ruined."
		add_fingerprint(user)

/obj/structure/sign/poster/proc/roll_and_drop(turf/newloc)
	var/obj/item/contraband/poster/P = new(src, poster_type)
	P.forceMove(newloc)
	src.forceMove(P)
	qdel(src)

/singleton/poster_design
	/// Name suffix. Poster - [name]
	var/name = ""
	/// Description suffix
	var/desc = ""
	/// The actual design
	var/icon_state = ""
