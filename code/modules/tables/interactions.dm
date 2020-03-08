
/obj/structure/table/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return (check_cover(mover,target))
	if (flipped == 1)
		if (get_dir(loc, target) == dir)
			return !density
		else
			return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(locate(/obj/structure/table) in get_turf(mover))
		return 1
	return 0

//checks if projectile 'P' from turf 'from' can hit whatever is behind the table. Returns 1 if it can, 0 if bullet stops.
/obj/structure/table/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover
	if(flipped==1)
		cover = get_turf(src)
	else if(flipped==0)
		cover = get_step(loc, get_dir(from, loc))
	if(!cover)
		return 1
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1
	if (get_turf(P.original) == cover)
		var/chance = 20
		if (ismob(P.original))
			var/mob/M = P.original
			if (M.lying)
				chance += 20				//Lying down lets you catch less bullets
		if(flipped==1)
			if(get_dir(loc, from) == dir)	//Flipped tables catch mroe bullets
				chance += 20
			else
				return 1					//But only from one side
		if(prob(chance))
			health -= P.damage/2
			if (health > 0)
				visible_message("<span class='warning'>[P] hits \the [src]!</span>")
				return 0
			else
				visible_message("<span class='warning'>[src] breaks down!</span>")
				break_to_parts()
				return 1
	return 1

/obj/structure/table/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	if (flipped==1)
		if (get_dir(loc, target) == dir)
			return !density
		else
			return 1
	return 1

/obj/structure/table/Crossed(var/atom/movable/am as mob|obj)
	..()
	if(ishuman(am))
		var/mob/living/carbon/human/H = am
		if(H.a_intent != I_HELP || H.m_intent == "run")
			throw_things(H)
		else if(H.is_diona() || H.species.get_bodytype() == "Heavy Machine")
			throw_things(H)
	else if((isliving(am) && !issmall(am)) || isslime(am))
		throw_things(am)

/obj/structure/table/proc/throw_things(var/mob/living/user)
	var/list/targets = list(get_step(src,dir),get_step(src,turn(dir, 45)),get_step(src,turn(dir, -45)))
	var/turf/T = get_turf(src)
	var/anything_moved = FALSE
	for (var/obj/item/I in T)
		if (I.simulated && !I.anchored)
			INVOKE_ASYNC(I, /atom/movable/.proc/throw_at, pick(targets), 1, 1)
			anything_moved = TRUE
		CHECK_TICK

	if (user && anything_moved)
		user.visible_message(
		"<span class='notice'>[user] kicks everything off [src].</span>",
		"<span class='notice'>You kick everything off [src].</span>"
		)


/obj/structure/table/structure_shaken()
	..()
	throw_things()


/obj/structure/table/do_climb(var/mob/living/user)
	if (!can_climb(user))
		return

	user.visible_message(
	"<span class='warning'>[user] starts climbing onto \the [src]!</span>",
	"<span class='warning'>You start climbing onto \the [src]!</span>"
	)
	LAZYADD(climbers, user)

	if(!do_after(user,25))
		LAZYREMOVE(climbers, user)
		return

	if (!can_climb(user, post_climb_check=1))
		LAZYREMOVE(climbers, user)
		return

	user.forceMove(get_turf(src))

	if (get_turf(user) == get_turf(src))
		user.visible_message(
		"<span class='warning'>[user] climbs onto \the [src]!</span>",
		"<span class='warning'>You climb onto \the [src]!</span>"
		)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.a_intent != I_HELP || H.m_intent == "run")
				throw_things(H)
			else if(H.is_diona() || H.species.get_bodytype() == "Heavy Machine")
				throw_things(H)
		else if(!issmall(user) || isslime(user))
			throw_things(user)
	LAZYREMOVE(climbers, user)

/obj/structure/table/MouseDrop_T(obj/O as obj, mob/user as mob)

	if ((!( istype(O, /obj/item) ) || user.get_active_hand() != O))
		return ..()
	if(isrobot(user))
		return
	user.drop_item()
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/structure/table/attackby(obj/item/W as obj, mob/user as mob, var/click_parameters)
	if (!W) return

	// Handle harm intent grabbing/tabling.
	if(istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if(istype(G.affecting, /mob/living))
			var/mob/living/M = G.affecting
			var/obj/occupied = turf_is_crowded()
			if(occupied)
				to_chat(user, "<span class='danger'>There's \a [occupied] in the way.</span>")
				return
			if(!user.Adjacent(M))
				return
			if(G.state > GRAB_AGGRESSIVE && world.time >= G.last_action + UPGRADE_COOLDOWN)
				if(user.a_intent == I_HURT)
					var/blocked = M.run_armor_check(BP_HEAD, "melee")
					if (prob(30 * BLOCKED_MULT(blocked)))
						M.Weaken(5)
					M.apply_damage(8, BRUTE, BP_HEAD, blocked)
					visible_message("<span class='danger'>[G.assailant] slams [G.affecting]'s face against \the [src]!</span>")
					if(material)
						playsound(loc, material.tableslam_noise, 50, 1)
					else
						playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)
					// Shards. Extra damage, plus potentially the fact YOU LITERALLY HAVE A PIECE OF GLASS/METAL/WHATEVER IN YOUR FACE
					var/sanity_counter = 0
					for(var/obj/item/material/shard/S in get_turf(src))
						if(prob(50))
							M.visible_message("<span class='danger'>\The [S] slices [M]'s face messily!</span>",
												"<span class='danger'>\The [S] slices your face messily!</span>")
							M.apply_damage(10, BRUTE, BP_HEAD, blocked)
							sanity_counter++
						if(sanity_counter >= 3)
							break
					G.last_action = world.time
				else
					G.affecting.forceMove(src.loc)
					G.affecting.Weaken(rand(2,4))
					visible_message("<span class='danger'>[G.assailant] puts [G.affecting] on \the [src].</span>")
					qdel(W)
				return
			else
				to_chat(user, "<span class='warning'>You need a better grip to do that!</span>")
				return
			qdel(W)
			return

	if(!dropsafety(W))
		return

	if(istype(W, /obj/item/melee/energy/blade))
		var/obj/item/melee/energy/blade/blade = W
		blade.spark_system.queue()
		playsound(src.loc, 'sound/weapons/blade.ogg', 50, 1)
		playsound(src.loc, "sparks", 50, 1)
		user.visible_message("<span class='danger'>\The [src] was sliced apart by [user]!</span>")
		break_to_parts()
		return

	if(can_plate && !material)
		to_chat(user, "<span class='warning'>There's nothing to put \the [W] on! Try adding plating to \the [src] first.</span>")
		return

	// Placing stuff on tables
	if(user.unEquip(W, 0, src.loc))
		user.make_item_drop_sound(W)
		auto_align(W, click_parameters)
		return 1

#define CELLS 8								//Amount of cells per row/column in grid
#define CELLSIZE (world.icon_size/CELLS)	//Size of a cell in pixels
/*
Automatic alignment of items to an invisible grid, defined by CELLS and CELLSIZE.
Since the grid will be shifted to own a cell that is perfectly centered on the turf, we end up with two 'cell halves'
on edges of each row/column.
Each item defines a center_of_mass, which is the pixel of a sprite where its projected center of mass toward a turf
surface can be assumed. For a piece of paper, this will be in its center. For a bottle, it will be (near) the bottom
of the sprite.
auto_align() will then place the sprite so the defined center_of_mass is at the bottom left corner of the grid cell
closest to where the cursor has clicked on.
Note: This proc can be overwritten to allow for different types of auto-alignment.
*/
/obj/item/var/list/center_of_mass = list("x" = 16,"y" = 16)
/obj/structure/table/proc/auto_align(obj/item/W, click_parameters)
	if(!W.center_of_mass)
		W.randpixel_xy()
		return

	if(!click_parameters)
		return

	var/list/mouse_control = mouse_safe_xy(click_parameters)
	var/mouse_x = mouse_control["icon-x"]
	var/mouse_y = mouse_control["icon-y"]

	if(isnum(mouse_x) && isnum(mouse_y))
		var/cell_x = max(0, min(CELLS-1, round(mouse_x/CELLSIZE)))
		var/cell_y = max(0, min(CELLS-1, round(mouse_y/CELLSIZE)))

		W.pixel_x = (CELLSIZE * (0.5 + cell_x)) - W.center_of_mass["x"]
		W.pixel_y = (CELLSIZE * (0.5 + cell_y)) - W.center_of_mass["y"]

#undef CELLS
#undef CELLSIZE

/obj/structure/table/do_simple_ranged_interaction(var/mob/user)
	return
