/obj/machinery/atmospherics/var/image/pipe_image

/obj/machinery/atmospherics/Destroy()
	for(var/mob/living/M in src) //ventcrawling is serious business
		M.remove_ventcrawl()
		M.forceMove(get_turf(src))
	if(pipe_image)
		for(var/mob/living/M in GLOB.player_list)
			if(M.client)
				M.client.images -= pipe_image
				M.pipes_shown -= pipe_image
		pipe_image = null
	. = ..()

/obj/machinery/atmospherics/ex_act(severity)
	for(var/atom/movable/A in src) //ventcrawling is serious business
		A.ex_act(severity)
	. = ..()

/obj/machinery/atmospherics/Entered(atom/movable/Obj)
	if(istype(Obj, /mob/living))
		var/mob/living/L = Obj
		L.ventcrawl_layer = layer
	. = ..()

/obj/machinery/atmospherics/relaymove(mob/living/user, direction)
	. = ..()

	if(user.loc != src || !(direction & initialize_directions)) //can't go in a way we aren't connecting to
		return
	ventcrawl_to(user,findConnecting(direction, user.ventcrawl_layer),direction)

/obj/machinery/atmospherics/proc/ventcrawl_to(var/mob/living/user, var/obj/machinery/atmospherics/target_move, var/direction)
	if(target_move)
		if(is_type_in_list(target_move, GLOB.ventcrawl_machinery) && target_move.can_crawl_through())
			var/obj/machinery/atmospherics/unary/UA = target_move
			if(UA.is_welded())
				user.visible_message(SPAN_WARNING("You hear something banging on \the [target_move.name]!"), SPAN_NOTICE("You can't escape from a welded vent."))
			else
				user.remove_ventcrawl()
				user.forceMove(UA.loc) //handles entering and so on
				user.sight &= ~(SEE_TURFS|BLIND)
				user.visible_message(SPAN_WARNING("You hear something squeezing through the ducts."), "You climb out the ventilation system.")
				user.vent_trap_check("arriving", UA)

		else if(target_move.can_crawl_through())
			if(target_move.return_network(target_move) != return_network(src))
				user.remove_ventcrawl()
				user.add_ventcrawl(target_move)
			user.forceMove(target_move)
			if(!user || !user.client)
				return
			user.client.eye = target_move //if we don't do this, Byond only updates the eye every tick - required for smooth movement
			if(world.time > user.next_play_vent)
				user.next_play_vent = world.time+30
				playsound(src, 'sound/machines/ventcrawl.ogg', 50, 1, -3)
	else
		if((direction & initialize_directions) || is_type_in_list(src, GLOB.ventcrawl_machinery) && src.can_crawl_through()) //if we move in a way the pipe can connect, but doesn't - or we're in a vent
			user.remove_ventcrawl()
			user.forceMove(check_neighbor_density(get_turf(src.loc), direction) ? src.loc : get_step(src, direction))
			user.sight &= ~(SEE_TURFS|BLIND)
			user.visible_message(SPAN_WARNING("You hear something squeezing through the pipes."), "You climb out the ventilation system.")
			user.vent_trap_check("arriving", user.loc)
	user.canmove = 0
	spawn(1)
		user.canmove = 1

/obj/machinery/atmospherics/proc/can_crawl_through()
	return 1

/obj/machinery/atmospherics/proc/findConnecting(direction)
	for(var/obj/machinery/atmospherics/target in get_step(src,direction))
		if(target.initialize_directions & get_dir(target,src))
			if(isConnectable(target) && target.isConnectable(src))
				return target

/obj/machinery/atmospherics/proc/isConnectable(obj/machinery/atmospherics/target)
	return LAZYISIN(nodes_to_networks, target)

/obj/machinery/atmospherics/proc/can_z_crawl(mob/living/L, direction)
	return FALSE

/obj/machinery/atmospherics/pipe/zpipe/can_z_crawl(mob/living/L, direction)
	if(L.is_ventcrawling && L.loc == src)
		var/node = nodes_to_networks[1]
		if(node && check_connect_types(node,src))
			if(direction == travel_direction)
				return TRUE

/obj/machinery/atmospherics/proc/handle_z_crawl(mob/living/L, direction)
	return

/obj/machinery/atmospherics/pipe/zpipe/handle_z_crawl(var/mob/living/L, var/direction)
	to_chat(L, SPAN_NOTICE("You start climbing [travel_direction_name] the pipe. This will take a while..."))
	playsound(loc, 'sound/machines/ventcrawl.ogg', 100, 1, 3)
	if(!do_after(L, 10 SECONDS, get_turf(src), do_flags = DO_DEFAULT & ~DO_USER_SAME_HAND) || !can_z_crawl(L, direction))
		to_chat(L, SPAN_DANGER("You gave up on climbing [travel_direction_name] the pipe."))
		return FALSE
	var/node = nodes_to_networks[1]
	return ventcrawl_to(L, node, null)
