/// Turf type that appears to be a world border, completely impassable and non-interactable to all physical (alive) entities.
/turf/cordon
	name = "cordon"
	icon = 'icons/turf/walls.dmi'
	icon_state = "cordon"
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	explosion_resistance = 3
	opacity = TRUE
	density = TRUE
	blocks_air = TRUE
	turf_flags = TURF_FLAG_BACKGROUND
	permit_ao = FALSE
	dynamic_lighting = 0

/turf/cordon/singularity_act()
	return FALSE

/turf/cordon/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	SHOULD_CALL_PARENT(FALSE) // Fuck you
	return BULLET_ACT_BLOCK

/turf/cordon/Adjacent(atom/neighbor, atom/target, atom/movable/mover)
	return FALSE

/// Area used in conjunction with the cordon turf to create a fully functioning world border.
/area/misc/cordon
	name = "CORDON"
	icon_state = "cordon"
	dynamic_lighting = FALSE
	area_flags = AREA_FLAG_NO_GHOST_TELEPORT_ACCESS | AREA_FLAG_UNIQUE | AREA_FLAG_HIDE_FROM_HOLOMAP
	requires_power = FALSE

/area/misc/cordon/Entered(atom/movable/arrived, area/old_area)
	. = ..()
	for(var/mob/living/enterer as anything in arrived.get_all_contents_type(/mob/living))
		to_chat(enterer, SPAN_DANGER("This was a bad idea..."))
		enterer.dust(TRUE, FALSE, TRUE)

/// This type of cordon will block ghosts from passing through it. Useful for stuff like Away Missions, where you feasibly want to block ghosts from entering to keep a certain map section a secret.
/turf/cordon/secret
	name = "secret cordon (ghost blocking)"

/turf/cordon/secret/attack_ghost(mob/abstract/ghost/user)
	return FALSE
