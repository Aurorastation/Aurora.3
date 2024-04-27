//Meteor groups, used for the Meteor gamemode.

/proc/spawn_meteors(var/number = 10, var/list/meteortypes, var/startSide, var/zlevel)
	for(var/i = 0; i < number; i++)
		spawn_meteor(meteortypes, startSide, zlevel)

/proc/spawn_meteor(var/list/meteortypes, var/startSide, var/zlevel)
	var/turf/pickedstart = spaceDebrisStartLoc(startSide, zlevel)
	var/turf/pickedgoal = spaceDebrisFinishLoc(startSide, zlevel)

	var/Me = pickweight(meteortypes)
	var/obj/effect/meteor/M = new Me(pickedstart)
	M.dest = pickedgoal
	spawn(0)
		walk_towards(M, M.dest, 3)
	return

/proc/spaceDebrisStartLoc(startSide, Z)
	var/starty
	var/startx
	switch(startSide)
		if(NORTH)
			starty = world.maxy-(TRANSITIONEDGE+1)
			startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
		if(EAST)
			starty = rand((TRANSITIONEDGE+1),world.maxy-(TRANSITIONEDGE+1))
			startx = world.maxx-(TRANSITIONEDGE+1)
		if(SOUTH)
			starty = (TRANSITIONEDGE+1)
			startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
		if(WEST)
			starty = rand((TRANSITIONEDGE+1), world.maxy-(TRANSITIONEDGE+1))
			startx = (TRANSITIONEDGE+1)
	var/turf/T = locate(startx, starty, Z)
	return T

/proc/spaceDebrisFinishLoc(startSide, Z)
	var/endy
	var/endx
	switch(startSide)
		if(NORTH)
			endy = TRANSITIONEDGE
			endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
		if(EAST)
			endy = rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE)
			endx = TRANSITIONEDGE
		if(SOUTH)
			endy = world.maxy-TRANSITIONEDGE
			endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
		if(WEST)
			endy = rand(TRANSITIONEDGE,world.maxy-TRANSITIONEDGE)
			endx = world.maxx-TRANSITIONEDGE
	var/turf/T = locate(endx, endy, Z)
	return T

/obj/effect/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "large"
	density = TRUE
	anchored = TRUE
	pass_flags = PASSTABLE | PASSRAILING

	var/hits = 4
	var/hitpwr = 2 //Level of ex_act to be called on hit.
	var/dest
	var/heavy = FALSE
	var/z_original

	var/meteor_loot = list(/obj/item/ore/iron) //the thing that the meteors will drop when it explodes
	var/dropamt = 3 //amount of said thing


/obj/effect/meteor/Destroy()
	walk(src,0) //this cancels the walk_towards() proc
	return ..()

/obj/effect/meteor/Collide(atom/A)
	..()
	if(istype(A, /obj/effect/energy_field))
		hitpwr *= 0.5
		A.ex_act(hitpwr)
		visible_message(SPAN_DANGER("\The [src] breaks into dust!"))
		make_debris()
		msg_admin_attack("Meteor collided with shields at (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
		qdel(src)

	if(A && !QDELETED(src))	// Prevents explosions and other effects when we were deleted by whatever we Bumped() - currently used by shields.
		ram_turf(get_turf(A))
		get_hit() //should only get hit once per move attempt

/obj/effect/meteor/proc/ram_turf(var/turf/T)
	//first bust whatever is in the turf
	for(var/atom/A in T)
		if(A != src && !A.CanPass(src, src.loc, 0.5, 0)) //only ram stuff that would actually block us
			A.ex_act(hitpwr)

	//then, ram the turf if it still exists
	if(T && !T.CanPass(src, src.loc, 0.5, 0))
		T.ex_act(hitpwr)

/obj/effect/meteor/proc/get_hit()
	hits--
	if(hits <= 0)
		make_debris()
		meteor_effect()
		qdel(src)

/obj/effect/meteor/proc/meteor_effect()
	if(heavy)
		for(var/mob/M in GLOB.player_list)
			var/turf/T = get_turf(M)
			if(!T || T.z != src.z)
				continue
			var/dist = get_dist(M.loc, src.loc)
			shake_camera(M, dist > 20 ? 3 : 5, dist > 20 ? 1 : 3)

/obj/effect/meteor/ex_act(severity)
	if (severity < 4)
		qdel(src)
	return

/obj/effect/meteor/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/pickaxe))
		qdel(src)
		return TRUE
	return ..()

/obj/effect/meteor/proc/make_debris()
	for(var/throws = dropamt, throws > 0, throws--)
		var/loot_path = pickweight(meteor_loot)
		var/obj/O = new loot_path(get_turf(src))
		if(istype(O, /obj/item/stack))
			var/obj/item/stack/S = O
			S.amount = rand(1, dropamt)
			S.update_icon()
		O.throw_at(dest, 5, 10)

/obj/effect/meteor/touch_map_edge()
	qdel(src)

/obj/effect/meteor/medium
	name = "meteor"
	dropamt = 2

/obj/effect/meteor/medium/meteor_effect()
	..()
	explosion(src.loc, 0, 1, 2, 3, 0)
	msg_admin_attack("Meteor exploded at coords (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")

/obj/effect/meteor/big
	name = "large meteor"
	icon_state = "large"
	hits = 6
	heavy = 1
	dropamt = 3

/obj/effect/meteor/big/meteor_effect()
	..()
	explosion(src.loc, 1, 2, 3, 4, 0)
	msg_admin_attack("Meteor exploded at coords (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")

/obj/effect/meteor/dust
	name = "space dust"
	icon_state = "dust"
	pass_flags = PASSTABLE | PASSGRILLE | PASSRAILING
	meteor_loot = list(/obj/item/ore/glass)
	dropamt = 1

	hits = 1
	hitpwr = 3

/obj/effect/meteor/flaming
	name = "flaming meteor"
	icon_state = "flaming"
	hits = 3
	meteor_loot = list(/obj/item/ore/phoron)

/obj/effect/meteor/flaming/meteor_effect()
	..()
	explosion(src.loc, 1, 2, 3, 4, 0, 0, 5)
	msg_admin_attack("Meteor exploded at coords (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")

/obj/effect/meteor/irradiated
	name = "glowing meteor"
	icon_state = "glowing"
	meteor_loot = list(/obj/item/ore/uranium)

/obj/effect/meteor/irradiated/meteor_effect()
	explosion(src.loc, 0, 0, 4, 3, 0)
	new /obj/effect/decal/cleanable/greenglow(get_turf(src))
	SSradiation.radiate(src, 50)

/obj/effect/meteor/golden
	name = "golden meteor"
	icon_state = "sharp"
	meteor_loot = list(/obj/item/ore/gold)

/obj/effect/meteor/silver
	name = "silver meteor"
	icon_state = "glowing_blue"
	meteor_loot = list(/obj/item/ore/silver)

/obj/effect/meteor/diamond
	name = "diamond meteor"
	icon_state = "glowing_blue"
	meteor_loot = list(/obj/item/ore/diamond)

/obj/effect/meteor/emp
	name = "conducting meteor"
	icon_state = "glowing_blue"
	meteor_loot = list(/obj/item/ore/osmium)
	dropamt = 2

/obj/effect/meteor/emp/meteor_effect()
	empulse(src, rand(2, 4), rand(4, 10))

/obj/effect/meteor/artifact
	icon_state = "sharp"
	meteor_loot = list(/obj/item/archaeological_find)
	dropamt = 1

/obj/effect/meteor/supermatter
	name = "supermatter shard"
	icon = 'icons/obj/supermatter.dmi'
	icon_state = "darkmatter_meteor"

/obj/effect/meteor/supermatter/New()
	..()
	if(prob(5))
		meteor_loot = list(/obj/machinery/power/supermatter/shard)
		dropamt = 1

/obj/effect/meteor/supermatter/meteor_effect()
	explosion(src.loc, 1, 2, 3, 4, 0)
	for(var/obj/machinery/power/apc/A in range(rand(12, 20), src))
		A.energy_fail(round(10 * rand(8, 12)))
	msg_admin_attack("Meteor exploded at coords (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")

/obj/effect/meteor/meaty
	name = "meaty ore"
	icon_state = "meateor"
	meteor_loot = list(/obj/item/reagent_containers/food/snacks/meat/monkey)
	dropamt = 10

/obj/effect/meteor/meaty/meteor_effect()
	gibs(loc)

/obj/effect/meteor/ship_debris
	name = "ship debris"
	icon_state = "dust"
	meteor_loot = list(
		/obj/item/stack/material/plasteel = 19,
		/obj/item/stack/material/steel = 19,
		/obj/item/material/shard = 20,
		/obj/item/material/shard/shrapnel = 20,
		/obj/item/stack/rods = 20,
		/obj/structure/closet/crate/loot = 2
		)
	dropamt = 10

/obj/effect/meteor/ship_debris/meteor_effect()
	for(var/eligible_turf in RANGE_TURFS(2, src))
		if(prob(15))
			new /obj/effect/gibspawner/robot(eligible_turf)
		if(prob(10))
			var/turf/T = eligible_turf
			T.ChangeTurf(/turf/simulated/floor/airless)
		if(prob(10))
			new /obj/structure/lattice(eligible_turf)
		if(prob(5))
			if(turf_clear(eligible_turf))
				new /obj/structure/grille/broken(eligible_turf)
		if(prob(5))
			if(turf_clear(eligible_turf))
				new /obj/structure/girder/displaced(eligible_turf)
		if(prob(0.25))
			new /obj/effect/gibspawner/human(eligible_turf)
			new /obj/random/voidsuit/no_nanotrasen(eligible_turf)

//This function takes a turf to prevent race conditions, as the object calling it will probably be deleted in the same frame
/proc/meteor_shield_impact_sound(var/turf/T, var/range)
	//The supplied volume is reduced by an amount = distance - viewrange * 2, viewrange is 7 i think

	//Calculate the supplied volume so it will be heard with slightly > 0 volume at the maximum range.
	//The +1 gives it that tiny amount
	range = ((range - world.view) * 2)+1


	for(var/A in GLOB.player_list)
		var/mob/M = A
		var/turf/mobloc = get_turf(M)
		if(mobloc && mobloc.z == T.z)
			if(!isdeaf(M))
				M.playsound_local(T, 'sound/effects/meteorimpact.ogg', range, vary = TRUE, pressure_affected = FALSE)
