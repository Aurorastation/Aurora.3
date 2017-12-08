
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// fossils

	name = "Fossil"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "bone"
	desc = "It's a fossil."
	var/animal = 1

	var/t = pickweight(l)
	var/turf/T = get_turf(src)
	if(istype(T, /turf/simulated/mineral))
		T:last_find = W
	qdel(src)

	name = "Fossilised bone"
	icon_state = "bone"
	desc = "It's a fossilised bone."

	name = "Fossilised skull"
	icon_state = "skull"
	desc = "It's a fossilised skull."

	icon_state = "hskull"
	desc = "It's a fossilised, horned skull."

		var/obj/o = new /obj/skeleton(get_turf(src))
		var/b = new src.type
		o.contents.Add(a)
		o.contents.Add(b)
		qdel(W)
		qdel(src)

/obj/skeleton
	name = "Incomplete skeleton"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "uskel"
	desc = "Incomplete skeleton."
	var/bnum = 1
	var/breq
	var/bstate = 0
	var/plaque_contents = "Unnamed alien creature"

/obj/skeleton/New()
	src.breq = rand(6)+3
	src.desc = "An incomplete skeleton, looks like it could use [src.breq-src.bnum] more bones."

		if(!bstate)
			bnum++
			qdel(W)
			if(bnum==breq)
				usr = user
				icon_state = "skel"
				src.bstate = 1
				src.density = 1
				src.name = "alien skeleton display"
					src.desc = "A creature made of [src.contents.len-1] assorted bones and a horned skull. The plaque reads \'[plaque_contents]\'."
				else
					src.desc = "A creature made of [src.contents.len-1] assorted bones and a skull. The plaque reads \'[plaque_contents]\'."
			else
				src.desc = "Incomplete skeleton, looks like it could use [src.breq-src.bnum] more bones."
				user << "Looks like it could use [src.breq-src.bnum] more bones."
		else
			..()
		plaque_contents = sanitize(input("What would you like to write on the plaque:","Skeleton plaque",""))
		user.visible_message("[user] writes something on the base of [src].","You relabel the plaque on the base of \icon[src] [src].")
			src.desc = "A creature made of [src.contents.len-1] assorted bones and a horned skull. The plaque reads \'[plaque_contents]\'."
		else
			src.desc = "A creature made of [src.contents.len-1] assorted bones and a skull. The plaque reads \'[plaque_contents]\'."
	else
		..()

//shells and plants do not make skeletons
	name = "Fossilised shell"
	icon_state = "shell"
	desc = "It's a fossilised shell."

	name = "Fossilised plant"
	icon_state = "plant1"
	desc = "It's fossilised plant remains."
	animal = 0

	icon_state = "plant[rand(1,4)]"
