/////////////VISION CONE///////////////
// Vision cone code by Honkertron (for Otuska), Matt and Myazaki.
// This vision cone code allows for mobs and/or items to be blocked out from a player's field of vision.
// This code makes use of the "cone of effect" proc created by Lummox, contributed by Jtgibson.
//
// More info on that here:
// http://www.byond.com/forum/?post=195138
///////////////////////////////////////

/client
	var/list/hidden_atoms = list()
	var/list/hidden_mobs = list()

/proc/cone(turf/center, dir, list/list)
	. = list()
	for(var/turf/T in list)
		if(T.InCone(center, dir))
			for(var/mob/M in T.contents)
				. += M.InCone(center, dir)

// Should return atoms that are in the cone
/atom/proc/InCone(turf/center, dir)
	return

/turf/InCone(turf/center, dir)
	if(get_dist(center, src) == 0 || src == center) return 0
	var/d = get_dir(center, src)

	if(!d || d == dir) return 1
	if(dir & (dir-1))
		return (d & ~dir) ? 0 : 1
	if(!(d & dir)) return 0
	var/dx = abs(x - center.x)
	var/dy = abs(y - center.y)
	if(dx == dy) return 1
	if(dy > dx)
		return (dir & (NORTH|SOUTH)) ? 1 : 0
	return (dir & (EAST|WEST)) ? 1 : 0

/mob/dead/InCone(turf/center, dir)
	return src

/mob/InCone(turf/center, dir)
	return src

/mob/living/InCone(turf/center, dir)
	. = ..()
	. += src
	if(pulling)
		. += pulling

/mob/proc/update_vision_cone()
	return

/mob/living/update_vision_cone()
	if(!can_have_vision_cone)
		if(vision_cone_overlay)
			remove_cone()
		return

	for(var/obj/item/item in src)
		if(item.zoom)
			remove_cone()
			return

	var/delay = 1 SECONDS
	if(client)
		var/image/I = null
		for(I in client.hidden_atoms)
			I.override = FALSE
			QDEL_IN(I, delay)
			delay += 1 SECONDS

		check_fov()
		client.hidden_atoms.Cut()
		client.hidden_mobs.Cut()


		if(resting || lying)
			hide_cone()
			return

		vision_cone_overlay.dir = dir
		if(vision_cone_overlay.alpha)
			var/turf/T = get_turf(src)
			for(var/cone_atom in cone(T, reverse_direction(dir), get_rectangle_in_dir(T, client.view, reverse_direction(dir)) & oview(client.view, T)))
				add_to_mobs_hidden_atoms(cone_atom)

/mob/living/proc/add_to_mobs_hidden_atoms(atom/A)
	var/image/I
	I = image("split", A)
	I.override = TRUE
	client.images += I
	client.hidden_atoms += I
	if(ismob(A))
		var/mob/hidden_mob = A
		client.hidden_mobs += hidden_mob
		if(pulling && (pulling == hidden_mob || pulling == hidden_mob.buckled))//If we're pulling them we don't want them to be invisible, too hard to play like that.
			I.override = FALSE
			return
		for(var/obj/item/grab/G in src)
			if(A == G.affecting)
				I.override = FALSE
				return
		for(var/obj/item/grab/G in A)
			if(src == G.affecting)
				I.override = FALSE
				return

/mob/living/proc/SetFov(var/n)
	if(!can_have_vision_cone)
		return

	if(!n)
		hide_cone()
	else
		show_cone()

/mob/living/proc/check_fov()
	if(!can_have_vision_cone)
		return

	if(isnull(vision_cone_overlay))
		vision_cone_overlay = new /obj/screen/fov()
		client.screen |= vision_cone_overlay

	if(resting || lying || client.eye != client.mob)
		vision_cone_overlay.alpha = 0
		return

	else if(vision_cone_overlay)
		show_cone()
	else
		hide_cone()

//Making these generic procs so you can call them anywhere.
/mob/living/proc/show_cone()
	if(!can_have_vision_cone)
		return

	if(vision_cone_overlay)
		vision_cone_overlay.alpha = client.prefs.fov_cone_alpha

/mob/living/proc/hide_cone()
	if(vision_cone_overlay)
		vision_cone_overlay.alpha = 0

/mob/living/proc/remove_cone()
	if(vision_cone_overlay)
		client.screen -= vision_cone_overlay

/mob/living/set_dir()
	. = ..()
	if(.)
		update_vision_cone()

// Rotates a rectangle around a center turf
/proc/get_rectangle_in_dir(var/turf/T, var/length, var/dir)
	var/matrix/M = new
	var/matrix/N = new
	M.Turn(dir2angle(dir))
	N.Turn((dir2angle(dir)+180) % 360)
	. = block(\
		locate(T.x + (M.a+M.b) * length - 0.5*abs((M.a + M.b)-1), T.y + (M.d+M.e) * length - 0.5*abs((M.d + M.e)-1), T.z),\
		locate(T.x + N.a * length - 0.5*abs((M.a + M.b)-1), T.y + N.d * length - 0.5*abs((M.d + M.e)-1), T.z)\
		)