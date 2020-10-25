/obj/effect/map_effect/wingrille_spawn
	name = "window grille spawner"
	icon_state = "wingrille"
	var/win_path = /obj/structure/window/basic
	var/grill_path = /obj/structure/grille
	var/spawn_firedoor = FALSE
	var/activated

// stops ZAS expanding zones past us, the windows will block the zone anyway
/obj/effect/map_effect/wingrille_spawn/CanPass()
	return 0

/obj/effect/map_effect/wingrille_spawn/attack_hand()
	attack_generic()

/obj/effect/map_effect/wingrille_spawn/attack_ghost()
	attack_generic()

/obj/effect/map_effect/wingrille_spawn/attack_generic()
	activate()

/obj/effect/map_effect/wingrille_spawn/Initialize(mapload)
	if (!win_path)
		return INITIALIZE_HINT_QDEL

	..()

	activate()

	return INITIALIZE_HINT_LATEQDEL

/obj/effect/map_effect/wingrille_spawn/proc/activate()
	if(activated)
		return
	if(spawn_firedoor)
		new /obj/machinery/door/firedoor(loc)
	if (!locate(grill_path) in get_turf(src))
		var/obj/structure/grille/G = new grill_path(src.loc)
		handle_grille_spawn(G)
	var/list/neighbours = list()
	for (var/dir in cardinal)
		var/turf/T = get_step(src, dir)
		var/obj/effect/map_effect/wingrille_spawn/other = locate(/obj/effect/map_effect/wingrille_spawn) in T
		if(!other)
			var/found_connection
			if(locate(grill_path) in T)
				for(var/obj/structure/window/W in T)
					if(W.type == win_path && W.dir == get_dir(T,src))
						found_connection = 1
						qdel(W)
			if(!found_connection)
				var/obj/structure/window/new_win = new win_path(src.loc)
				new_win.set_dir(dir)
				handle_window_spawn(new_win)
		else
			neighbours |= other
	activated = 1

/obj/effect/map_effect/wingrille_spawn/proc/handle_window_spawn(var/obj/structure/window/W)
	return

// Currently unused, could be useful for pre-wired electrified windows.
/obj/effect/map_effect/wingrille_spawn/proc/handle_grille_spawn(var/obj/structure/grille/G)
	return

/obj/effect/map_effect/wingrille_spawn/reinforced
	name = "reinforced window grille spawner"
	icon_state = "r-wingrille"
	win_path = /obj/structure/window/reinforced

/obj/effect/map_effect/wingrille_spawn/reinforced/firedoor
	spawn_firedoor = TRUE

/obj/effect/map_effect/wingrille_spawn/reinforced/crescent
	name = "Crescent window grille spawner"
	win_path = /obj/structure/window/reinforced/crescent
	grill_path = /obj/structure/grille/crescent

/obj/effect/map_effect/wingrille_spawn/phoron
	name = "phoron window grille spawner"
	icon_state = "p-wingrille"
	win_path = /obj/structure/window/phoronbasic

/obj/effect/map_effect/wingrille_spawn/reinforced_phoron
	name = "reinforced phoron window grille spawner"
	icon_state = "pr-wingrille"
	win_path = /obj/structure/window/phoronreinforced

/obj/effect/map_effect/wingrille_spawn/reinforced_phoron/firedoor
	spawn_firedoor = TRUE

/obj/effect/map_effect/wingrille_spawn/reinforced/polarized
	name = "polarized window grille spawner"
	color = "#444444"
	win_path = /obj/structure/window/reinforced/polarized
	var/id

/obj/effect/map_effect/wingrille_spawn/reinforced/polarized/handle_window_spawn(var/obj/structure/window/reinforced/polarized/P)
	if(id)
		P.id = id