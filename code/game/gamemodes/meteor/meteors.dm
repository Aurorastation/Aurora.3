/var/const/meteor_wave_delay = 625 //minimum wait between waves in tenths of seconds
//set to at least 100 unless you want evarr ruining every round

/var/const/meteors_in_wave = 50
/var/const/meteors_in_small_wave = 10


/proc/spawn_meteors(var/number = meteors_in_small_wave)
	for(var/i = 0; i < number; i++)
		spawn(0)
			spawn_meteor()

/proc/spawn_meteor()

	var/startx
	var/starty
	var/endx
	var/endy
	var/turf/pickedstart
	var/turf/pickedgoal
	var/max_i = 10//number of tries to spawn meteor.

	switch(pick(1,2,3,4))
		if(1) //NORTH
			starty = world.maxy-(TRANSITIONEDGE+2)
			startx = rand((TRANSITIONEDGE+2), world.maxx-(TRANSITIONEDGE+2))
			endy = TRANSITIONEDGE
			endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
		if(2) //EAST
			starty = rand((TRANSITIONEDGE+2),world.maxy-(TRANSITIONEDGE+1))
			startx = world.maxx-(TRANSITIONEDGE+2)
			endy = rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE)
			endx = TRANSITIONEDGE
		if(3) //SOUTH
			starty = (TRANSITIONEDGE+2)
			startx = rand((TRANSITIONEDGE+2), world.maxx-(TRANSITIONEDGE+2))
			endy = world.maxy-TRANSITIONEDGE
			endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
		if(4) //WEST
			starty = rand((TRANSITIONEDGE+2), world.maxy-(TRANSITIONEDGE+2))
			startx = (TRANSITIONEDGE+2)
			endy = rand(TRANSITIONEDGE,world.maxy-TRANSITIONEDGE)
			endx = world.maxx-TRANSITIONEDGE

	pickedstart = locate(startx, starty, 6)
	pickedgoal = locate(endx, endy, 6)
	max_i--
	if(max_i<=0) return

	var/obj/effect/meteor/M
	switch(rand(1, 100))

		if(1 to 10)
			M = new /obj/effect/meteor/big( pickedstart )
		if(11 to 50)
			M = new /obj/effect/meteor( pickedstart )
		if(51 to 55)
			M = new /obj/effect/meteor/flaming( pickedstart )
		if(56 to 59)
			M = new /obj/effect/meteor/irradiated( pickedstart )
		if(60 to 64)
			M = new /obj/effect/meteor/golden( pickedstart )
		if(65 to 69)
			M = new /obj/effect/meteor/silver( pickedstart )
		if(70 to 73)
			M = new /obj/effect/meteor/emp( pickedstart )
		if(74 to 76)
			M = new /obj/effect/meteor/diamond( pickedstart )
		if(77 to 78)
			M = new /obj/effect/meteor/artifact( pickedstart )
		if(79 to 80)
			M = new /obj/effect/meteor/supermatter( pickedstart )
		if(81 to 82)
			M = new /obj/effect/meteor/meaty( pickedstart )
		if(83 to 100)
			M = new /obj/effect/meteor/small( pickedstart )

	M.dest = pickedgoal
	spawn(1)
		walk_towards(M, M.dest, 2)

	return

/obj/effect/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "large"
	density = 1
	anchored = 1.0
	var/hits = 3
	var/detonation_chance = 50
	var/power = 2
	var/power_step = 0.75
	var/dest
	var/shieldsoundrange = 260 // The maximum number of tiles away the sound can be heard, falls off over distance, so it will be quiet near the limit
	pass_flags = PASSTABLE
	var/done = 0//This is set to 1 when the meteor is done colliding, and is used to ignore additional bumps while waiting for deletion
	var/meteordrop = /obj/item/ore/iron //the thing that the meteors will drop when it explodes
	var/dropamt = 3 //amount of said thing

/obj/effect/meteor/small
	name = "small meteor"
	icon_state = "small"
	pass_flags = PASSTABLE | PASSGRILLE
	power = 1
	power_step = 0.5
	hits = 2
	detonation_chance = 30
	shieldsoundrange = 160
	dropamt = 1

/obj/effect/meteor/Destroy()
	walk(src,0) //this cancels the walk_towards() proc
	return ..()

/obj/effect/meteor/Collide(atom/A)
	if (!done)
		spawn(0)

			if (A)
				A.ex_act(2)
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)
				make_debris()
				meteor_effect()

			if (istype(A, /obj/effect/energy_field))//If a normal/small meteor impacts an energy field, then it makes a widely audible impact sound and qdels
				done = 1
				hits = 0
				power *= 0.5
				power_step *= 0.5
				var/turf/T = src.loc
				if (!T)
					T = A.loc

				if (T)//We have a double safety check on T to prevent runtime errors
					meteor_shield_impact_sound(T, shieldsoundrange)
				msg_admin_attack("Meteor impacted energy field at coords (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
				spawn()//Delaying the Qdel a frame provides a little more safety
					qdel(src)

			if (--src.hits == 0 && !done)
				//Prevent meteors from blowing up the singularity's containment.
				//Changing emitter and generator ex_act would result in them being bomb and C4 proof.
				done = 1
				if(!istype(A,/obj/machinery/power/emitter) && \
					!istype(A,/obj/machinery/field_generator) && \
					prob(detonation_chance))
					explosion(loc, power, power + power_step, power + power_step * 2, power + power_step * 3, 0)
					msg_admin_attack("Meteor exploded at coords (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
				else
					msg_admin_attack("Meteor dissipated without exploding at coords (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
				spawn()
					qdel(src)

/obj/effect/meteor/ex_act(severity)

	if (severity < 4)
		qdel(src)
	return

/obj/effect/meteor/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/pickaxe))
		qdel(src)
		return
	..()

/obj/effect/meteor/proc/make_debris()
	for(var/throws = dropamt, throws > 0, throws--)
		var/obj/O = new meteordrop(get_turf(src))
		O.throw_at(dest, 5, 10)

/obj/effect/meteor/proc/meteor_effect()
	return

/obj/effect/meteor/big
	name = "big meteor"
	hits = 5
	power = 4
	power_step = 1
	detonation_chance = 60
	shieldsoundrange = 310//This can be set larger than the dimensions of the map, to allow it to remain louder at extreme distance
	dropamt = 5

	ex_act(severity)
		return

	Collide(atom/A)
		if (!done)
			spawn(0)
				//Prevent meteors from blowing up the singularity's containment.
				//Changing emitter and generator ex_act would result in them being bomb and C4 proof
				if(!istype(A,/obj/machinery/power/emitter) && \
					!istype(A,/obj/machinery/field_generator))
					if(--src.hits <= 0)
						qdel(src) //Dont blow up singularity containment if we get stuck there.

				if (istype(A, /obj/effect/energy_field))//If a big meteor impacts an energy field, then it detonates immediately with reduced power
					done = 1
					hits = 0
					power *= 0.5
					power_step *= 0.5
					for(var/mob/M in player_list)
						var/turf/T = get_turf(M)
						if(!T || T.z != src.z)
							continue
						shake_camera(M, 3, get_dist(M.loc, src.loc) > 20 ? 1 : 3)
					var/turf/T = src.loc
					if (!T)
						T = A.loc

					if (T)
						meteor_shield_impact_sound(T, shieldsoundrange)
					explosion(loc, power, power + power_step, power + power_step * 2, power + power_step * 3, 0)
					msg_admin_attack("Large Meteor impacted energy field and then exploded at coords (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
					spawn()//Have to delay the qdel a little, or the playsound will throw a runtime
						qdel(src)

				else if (A)
					for(var/mob/M in player_list)
						var/turf/T = get_turf(M)
						if(!T || T.z != src.z)
							continue
						shake_camera(M, 3, get_dist(M.loc, src.loc) > 20 ? 1 : 3)
						playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)
					explosion(src.loc, 0, 1, 2, 3, 0)
					make_debris()
					meteor_effect()

				if (--src.hits == 0 && !done)
					done = 1
					if(prob(detonation_chance) && !istype(A, /obj/structure/grille))
						explosion(loc, power, power + power_step, power + power_step * 2, power + power_step * 3, 0)
						msg_admin_attack("Large Meteor exploded at coords (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
					else
						msg_admin_attack("Large Meteor dissipated without a final explosion at coords (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
					spawn()
						qdel(src)

/obj/effect/meteor/dust
	name = "space dust"
	icon_state = "dust"
	pass_flags = PASSTABLE | PASSGRILLE
	hits = 1
	meteordrop = /obj/item/ore/glass
	dropamt = 1

/obj/effect/meteor/flaming
	name = "flaming meteor"
	icon_state = "flaming"
	hits = 3
	meteordrop = /obj/item/ore/phoron

/obj/effect/meteor/irradiated
	name = "glowing meteor"
	icon_state = "glowing"
	meteordrop = /obj/item/ore/uranium

/obj/effect/meteor/irradiated/meteor_effect()
	new /obj/effect/decal/cleanable/greenglow(get_turf(src))
	for(var/mob/living/L in view(5, src))
		L.apply_effect(40, IRRADIATE, blocked = L.getarmor(null, "rad"))

/obj/effect/meteor/golden
	name = "golden meteor"
	icon_state = "sharp"
	meteordrop = /obj/item/ore/gold

/obj/effect/meteor/silver
	name = "silver meteor"
	icon_state = "glowing_blue"
	meteordrop = /obj/item/ore/silver

/obj/effect/meteor/diamond
	name = "diamond meteor"
	icon_state = "glowing_blue"
	meteordrop = /obj/item/ore/diamond

/obj/effect/meteor/emp
	name = "conducting meteor"
	icon_state = "glowing_blue"
	meteordrop = /obj/item/ore/osmium
	dropamt = 2

/obj/effect/meteor/emp/meteor_effect()
	empulse(src, rand(2, 4), rand(4, 10))

/obj/effect/meteor/artifact
	icon_state = "sharp"
	meteordrop = /obj/item/archaeological_find
	dropamt = 1

/obj/effect/meteor/supermatter
	name = "supermatter shard"
	icon = 'icons/obj/engine.dmi'
	icon_state = "darkmatter"

/obj/effect/meteor/supermatter/New()
	..()
	if(prob(5))
		meteordrop = /obj/machinery/power/supermatter/shard
		dropamt = 1

/obj/effect/meteor/supermatter/meteor_effect()
	explosion(src.loc, 1, 2, 3, 4, 0)
	for(var/obj/machinery/power/apc/A in range(rand(12, 20), src))
		A.energy_fail(round(10 * rand(8, 12)))

/obj/effect/meteor/meaty
	name = "meaty ore"
	icon_state = "meateor"
	meteordrop = /obj/item/reagent_containers/food/snacks/meat/monkey
	dropamt = 10

/obj/effect/meteor/meaty/meteor_effect()
	gibs(loc)


//This function takes a turf to prevent race conditions, as the object calling it will probably be deleted in the same frame
/proc/meteor_shield_impact_sound(var/turf/T, var/range)
	//The supplied volume is reduced by an amount = distance - viewrange * 2, viewrange is 7 i think

	//Calculate the supplied volume so it will be heard with slightly > 0 volume at the maximum range.
	//The +1 gives it that tiny amount
	range = ((range - world.view) * 2)+1


	for(var/A in player_list)
		var/mob/M = A
		var/turf/mobloc = get_turf(M)
		if(mobloc && mobloc.z == T.z)
			if(M.ear_deaf <= 0 || !M.ear_deaf)
				M.playsound_simple(T, 'sound/effects/meteorimpact.ogg', range, use_random_freq = TRUE, use_pressure = FALSE)

