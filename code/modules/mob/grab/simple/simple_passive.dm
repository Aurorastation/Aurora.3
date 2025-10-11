/singleton/grab/simple
	name = "simple grab"
	shift = 8
	point_blank_mult = 1
	break_chance_table = list(15, 60, 100)

/singleton/grab/simple/upgrade(obj/item/grab/G)
	return

/singleton/grab/simple/on_hit_disarm(obj/item/grab/G, atom/A, proximity)
	return FALSE

/singleton/grab/simple/on_hit_grab(obj/item/grab/G, atom/A, proximity)
	return FALSE

/singleton/grab/simple/on_hit_harm(obj/item/grab/G, atom/A, proximity)
	return FALSE

/singleton/grab/simple/resolve_openhand_attack(obj/item/grab/G)
	return FALSE
