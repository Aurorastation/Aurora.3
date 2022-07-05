//
// Window Spawner
//
/obj/effect/map_effect/window_spawner
	name = "window spawner"
	icon = 'icons/effects/map_effects.dmi'
	var/window_path = /obj/structure/window/basic
	var/frame_path = /obj/structure/window_frame
	var/grille_path = /obj/structure/grille
	var/firedoor_path = /obj/machinery/door/firedoor
	var/single_window = FALSE // For full window panes and full windows.
	var/spawn_frame = FALSE // For full windows.
	var/spawn_grille = FALSE // For electrified windows.
	var/spawn_firedoor = FALSE
	var/activated

/obj/effect/map_effect/window_spawner/CanPass() // Stops ZAS expanding zones past us, the windows will block the zone anyway.
	return FALSE

/obj/effect/map_effect/window_spawner/attack_hand()
	attack_generic()

/obj/effect/map_effect/window_spawner/attack_ghost()
	attack_generic()

/obj/effect/map_effect/window_spawner/attack_generic()
	activate()

/obj/effect/map_effect/window_spawner/Initialize(mapload)
	if (!window_path)
		return INITIALIZE_HINT_QDEL

	..()

	activate()

	return INITIALIZE_HINT_LATEQDEL

/obj/effect/map_effect/window_spawner/proc/activate()
	if(activated)
		return
	if(spawn_frame)
		new frame_path(loc)
	if(spawn_grille)
		new grille_path(loc)
	if(spawn_firedoor)
		new firedoor_path(loc)
	if(!single_window)
		var/list/neighbours = list()
		for (var/dir in cardinal)
			var/turf/T = get_step(src, dir)
			var/obj/effect/map_effect/window_spawner/other = locate(/obj/effect/map_effect/window_spawner) in T
			if(!other)
				var/found_connection
				if(locate(grille_path) in T)
					for(var/obj/structure/window/W in T)
						if(W.type == window_path && W.dir == get_dir(T,src))
							found_connection = TRUE
							qdel(W)
				if(!found_connection)
					var/obj/structure/window/new_win = new window_path(src.loc)
					new_win.set_dir(dir)
					handle_window_spawn(new_win)
			else
				neighbours |= other
	else
		var/obj/structure/window/W = new window_path(loc)
		handle_full_window_spawn(W)
	activated = TRUE

/obj/effect/map_effect/window_spawner/proc/handle_window_spawn(var/obj/structure/window/W)
	return

/obj/effect/map_effect/window_spawner/proc/handle_full_window_spawn(var/obj/structure/window/full/W)
	return

/obj/effect/map_effect/window_spawner/proc/handle_grille_spawn(var/obj/structure/grille/G)
	return

/********** Quarter Windows **********/
/obj/effect/map_effect/window_spawner/basic
	name = "window grille spawner"
	icon_state = "window-g"
	window_path = /obj/structure/window/basic
	spawn_grille = TRUE

/obj/effect/map_effect/window_spawner/reinforced
	name = "reinforced window grille spawner"
	icon_state = "rwindow-g"
	window_path = /obj/structure/window/reinforced
	spawn_grille = TRUE

/obj/effect/map_effect/window_spawner/reinforced/firedoor
	name = "reinforced window grille spawner with firedoor"
	icon_state = "rwindow-gf"
	spawn_firedoor = TRUE

/obj/effect/map_effect/window_spawner/reinforced/crescent
	name = "crescent window grille spawner"
	window_path = /obj/structure/window/reinforced/crescent
	grille_path = /obj/structure/grille/crescent

/obj/effect/map_effect/window_spawner/borosilicate
	name = "borosilicate window grille spawner"
	icon_state = "pwindow-g"
	window_path = /obj/structure/window/borosilicate
	spawn_grille = TRUE

/obj/effect/map_effect/window_spawner/borosilicate/reinforced
	name = "reinforced borosilicate window grille spawner"
	icon_state = "prwindow-g"
	window_path = /obj/structure/window/borosilicate/reinforced
	spawn_grille = TRUE

/obj/effect/map_effect/window_spawner/borosilicate/reinforced/firedoor
	name = "reinforced borosilicate window grille spawner with firedoor"
	icon_state = "prwindow-gf"
	spawn_firedoor = TRUE

/obj/effect/map_effect/window_spawner/reinforced/polarized
	name = "polarized reinforced window grille spawner"
	color = "#222222"
	window_path = /obj/structure/window/reinforced/polarized
	var/id

/obj/effect/map_effect/window_spawner/reinforced/polarized/handle_window_spawn(var/obj/structure/window/reinforced/polarized/W)
	if(id)
		W.id = id

/********** Full Windows **********/
// Window
/obj/effect/map_effect/window_spawner/full // Unused.
	name = "unused"
	icon_state = null
	single_window = TRUE
	spawn_frame = TRUE

// Reinforced Window
/obj/effect/map_effect/window_spawner/full/reinforced
	name = "full reinforced window spawner"
	icon_state = "full_rwindow"
	window_path = /obj/structure/window/full/reinforced

/obj/effect/map_effect/window_spawner/full/reinforced/grille
	name = "full reinforced window spawner with grille"
	icon_state = "full_rwindow-g"
	spawn_grille = TRUE

/obj/effect/map_effect/window_spawner/full/reinforced/firedoor
	name = "full reinforced window spawner with firedoor"
	icon_state = "full_rwindow-f"
	spawn_firedoor = TRUE

/obj/effect/map_effect/window_spawner/full/reinforced/grille/firedoor
	name = "full reinforced window spawner with grille and firedoor"
	icon_state = "full_rwindow-gf"
	spawn_firedoor = TRUE

/obj/effect/map_effect/window_spawner/full/reinforced/indestructible
	name = "indestructible reinforced window spawner"
	icon_state = "full_i_rwindow"
	window_path = /obj/structure/window/full/reinforced/indestructible

// Reinforced Polarized Window
/obj/effect/map_effect/window_spawner/full/reinforced/polarized
	name = "full reinforced polarized window spawner"
	icon_state = "full_p_rwindow"
	window_path = /obj/structure/window/full/reinforced/polarized
	var/id

/obj/effect/map_effect/window_spawner/full/reinforced/polarized/handle_full_window_spawn(var/obj/structure/window/full/reinforced/polarized/W)
	if(id)
		W.id = id

/obj/effect/map_effect/window_spawner/full/reinforced/polarized/grille
	name = "full reinforced polarized window spawner with grille"
	icon_state = "full_p_rwindow-g"
	spawn_grille = TRUE

/obj/effect/map_effect/window_spawner/full/reinforced/polarized/firedoor
	name = "full reinforced polarized window spawner with firedoor"
	icon_state = "full_p_rwindow-f"
	spawn_firedoor = TRUE

/obj/effect/map_effect/window_spawner/full/reinforced/polarized/grille/firedoor
	name = "full reinforced polarized window spawner with grille and firedoor"
	icon_state = "full_p_rwindow-gf"
	spawn_firedoor = TRUE

/obj/effect/map_effect/window_spawner/full/reinforced/polarized/indestructible
	name = "indestructible reinforced polarized window spawner"
	icon_state = "full_ip_rwindow"
	window_path = /obj/structure/window/full/reinforced/polarized/indestructible

// Borosilicate Window
/obj/effect/map_effect/window_spawner/full/borosilicate // Unused.
	name = "unused"
	icon_state = null

// Reinforced Borosilicate Window
/obj/effect/map_effect/window_spawner/full/borosilicate/reinforced
	name = "full reinforced borosilicate window spawner"
	icon_state = "full_brwindow"
	window_path = /obj/structure/window/full/phoron/reinforced

/obj/effect/map_effect/window_spawner/full/borosilicate/reinforced/firedoor
	name = "full reinforced borosilicate window spawner with firedoor"
	icon_state = "full_brwindow-f"
	spawn_firedoor = TRUE