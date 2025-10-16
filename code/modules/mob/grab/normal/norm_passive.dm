/singleton/grab/normal/passive
	name = "passive hold"
	upgrade = /singleton/grab/normal/struggle
	shift = 8
	point_blank_mult = 1.1
	grab_icon_state = "reinforce"
	break_chance_table = list(15, 60, 100)

/singleton/grab/normal/passive/on_hit_disarm(var/obj/item/grab/G, var/atom/A, var/proximity)
	if(proximity)
		to_chat(G.grabber, SPAN_WARNING("Your grip isn't strong enough to pin."))
	return FALSE

/singleton/grab/normal/passive/on_hit_grab(var/obj/item/grab/G, var/atom/A, var/proximity)
	if(proximity)
		to_chat(G.grabber, SPAN_WARNING("Your grip isn't strong enough to jointlock."))
	return FALSE

/singleton/grab/normal/passive/on_hit_harm(var/obj/item/grab/G, var/atom/A, var/proximity)
	if(proximity)
		to_chat(G.grabber, SPAN_WARNING("Your grip isn't strong enough to dislocate."))
	return FALSE

/singleton/grab/normal/passive/resolve_openhand_attack(var/obj/item/grab/G)
	return FALSE
