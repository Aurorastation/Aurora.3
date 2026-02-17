/singleton/grab/simple/control
	name = "controlling grab"
	shift = 0
	adjust_plane = FALSE
	adjust_layer = FALSE

	action_cooldown = 4 SECONDS

/singleton/grab/simple/control/on_hit_help(obj/item/grab/G, atom/A, proximity)
	if(A == G.grabber)
		A = G.grabbed
	if(isliving(G.grabbed))
		var/mob/living/living_mob = G.grabbed
		return living_mob.handle_rider_help_order(G.grabber, A, proximity)
	return FALSE

/singleton/grab/simple/control/on_hit_disarm(obj/item/grab/G, atom/A, proximity)
	if(A == G.grabber)
		A = G.grabbed
	if(isliving(G.grabbed))
		var/mob/living/living_mob = G.grabbed
		return living_mob.handle_rider_disarm_order(G.grabber, A, proximity)
	return FALSE

/singleton/grab/simple/control/on_hit_grab(obj/item/grab/G, atom/A, proximity)
	if(A == G.grabber)
		A = G.grabbed
	if(isliving(G.grabbed))
		var/mob/living/living_mob = G.grabbed
		return living_mob.handle_rider_grab_order(G.grabber, A, proximity)
	return FALSE

/singleton/grab/simple/control/on_hit_harm(obj/item/grab/G, atom/A, proximity)
	if(A == G.grabber)
		A = G.grabbed
	if(isliving(G.grabbed))
		var/mob/living/living_mob = G.grabbed
		return living_mob.handle_rider_harm_order(G.grabber, A, proximity)
	return FALSE

// Override these for mobs that will respond to instructions from a rider.
/mob/living/proc/handle_rider_harm_order(mob/user, atom/target, proximity)
	return FALSE

/mob/living/proc/handle_rider_grab_order(mob/user, atom/target, proximity)
	return FALSE

/mob/living/proc/handle_rider_disarm_order(mob/user, atom/target, proximity)
	return FALSE

/mob/living/proc/handle_rider_help_order(mob/user, atom/target, proximity)
	return FALSE
