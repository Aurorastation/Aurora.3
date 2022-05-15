//
// Windows Spawner
//
/obj/effect/map_effect/window_spawner
	name = "window spawner"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "win"
	var/window_path = /obj/structure/window/basic
	var/grille_path = /obj/structure/grille
	var/firedoor_path = /obj/machinery/door/firedoor
	var/single_window = FALSE
	var/spawn_grille = FALSE
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
		new window_path(loc)
	activated = TRUE

/obj/effect/map_effect/window_spawner/proc/handle_window_spawn(var/obj/structure/window/W)
	return

/obj/effect/map_effect/window_spawner/proc/handle_grille_spawn(var/obj/structure/grille/G)
	return

/********** Quarter Windows **********/
/obj/effect/map_effect/window_spawner/reinforced
	name = "reinforced window grille spawner"
	icon_state = "r-wingrille"
	window_path = /obj/structure/window/reinforced
	spawn_grille = TRUE

/obj/effect/map_effect/window_spawner/reinforced/firedoor
	name = "reinforced window grille spawner with firedoor"
	icon_state = "r-wingrille_firedoor"
	spawn_firedoor = TRUE

/obj/effect/map_effect/window_spawner/reinforced/crescent
	name = "crescent window grille spawner"
	window_path = /obj/structure/window/reinforced/crescent
	grille_path = /obj/structure/grille/crescent

/obj/effect/map_effect/window_spawner/phoron
	name = "borosilicate window grille spawner"
	icon_state = "p-wingrille"
	window_path = /obj/structure/window/phoronbasic
	spawn_grille = TRUE

/obj/effect/map_effect/window_spawner/reinforced_phoron
	name = "reinforced borosilicate window grille spawner"
	icon_state = "pr-wingrille"
	window_path = /obj/structure/window/phoronreinforced
	spawn_grille = TRUE

/obj/effect/map_effect/window_spawner/reinforced_phoron/firedoor
	name = "reinforced borosilicate window grille spawner with firedoor"
	icon_state = "pr-wingrille_firedoor"
	spawn_firedoor = TRUE

/obj/effect/map_effect/window_spawner/reinforced/polarized
	name = "polarized reinforced window grille spawner"
	color = "#444444"
	window_path = /obj/structure/window/reinforced/polarized
	var/id

/obj/effect/map_effect/window_spawner/reinforced/polarized/handle_window_spawn(var/obj/structure/window/reinforced/polarized/W)
	if(id)
		W.id = id

/********** Full Windows **********/
/obj/effect/map_effect/window_spawner/full // Unused.
	name = "unused"
	icon_state = null
	grille_path = null
	single_window = TRUE

/obj/effect/map_effect/window_spawner/full/reinforced
	name = "full reinforced window spawner"
	icon_state = "full_rwindow"
	window_path = /obj/structure/window/full/reinforced

/obj/effect/map_effect/window_spawner/full/reinforced/firedoor
	name = "full reinforced window spawner with firedoor"
	icon_state = "full_rwindow_firedoor"
	spawn_firedoor = TRUE

/obj/effect/map_effect/window_spawner/full/reinforced/indestructible
	name = "indestructible reinforced window spawner"
	icon_state = "full_indestructible_rwindow"
	window_path = /obj/structure/window/full/reinforced/indestructible

/obj/effect/map_effect/window_spawner/full/reinforced/polarized
	name = "full reinforced polarized window spawner"
	icon_state = "full_polarized_rwindow"
	window_path = /obj/structure/window/full/reinforced/polarized
	var/id

/obj/effect/map_effect/window_spawner/full/reinforced/polarized/handle_window_spawn(var/obj/structure/window/full/reinforced/polarized/W)
	if(id)
		W.id = id

/obj/effect/map_effect/window_spawner/full/reinforced/polarized/firedoor
	name = "full reinforced polarized window spawner with firedoor"
	icon_state = "full_polarized_rwindow_firedoor"
	spawn_firedoor = TRUE

/obj/effect/map_effect/window_spawner/full/reinforced/polarized/indestructible
	name = "indestructible reinforced polarized window spawner"
	icon_state = "full_indestructible_rwindow"
	window_path = /obj/structure/window/full/reinforced/polarized/indestructible

/obj/effect/map_effect/window_spawner/full/borosilicate // Unused.
	name = "unused"
	icon_state = null

/obj/effect/map_effect/window_spawner/full/borosilicate/reinforced
	name = "full reinforced borosilicate window spawner"
	icon_state = "full_boro_rwindow"
	window_path = /obj/structure/window/full/phoron/reinforced

/obj/effect/map_effect/window_spawner/full/borosilicate/reinforced/firedoor
	name = "full reinforced borosilicate window spawner with firedoor"
	icon_state = "full_boro_rwindow_firedoor"
	spawn_firedoor = TRUE