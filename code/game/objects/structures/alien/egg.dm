#define BURST 0
#define BURSTING 1
#define GROWING 2
#define GROWN 3

#define MAX_PROGRESS 100


/obj/structure/alien/egg
	desc = "It looks like a weird egg."
	name = "egg"
	icon_state = "egg_growing"
	density = 0
	anchored = 1
	var/status = GROWING //can be GROWING, GROWN or BURST; all mutually exclusive
	var/progress = 0

/obj/structure/alien/egg/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/structure/alien/egg/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/alien/egg/process()
	progress++
	if(progress >= MAX_PROGRESS)
		Grow()
		STOP_PROCESSING(SSprocessing, src)
		update_icon()

/obj/structure/alien/egg/attack_hand(user as mob)
	var/mob/living/carbon/M = user
	if(!istype(M) || !(locate(/obj/item/organ/xenos/hivenode) in M.internal_organs))
		return

	switch(status)
		if(BURST)
			user << "<span class='warning'>You clear the hatched egg.</span>"
			qdel(src)
			return
		if(GROWING)
			user << "<span class='warning'>The child is not developed yet.</span>"
			return
		if(GROWN)
			user << "<span class='warning'>You retrieve the child.</span>"
			Burst(0)
			return

/obj/structure/alien/egg/proc/GetFacehugger()
	return locate(/obj/item/clothing/mask/facehugger) in contents

/obj/structure/alien/egg/proc/Grow()
	icon_state = "egg"
	status = GROWN
	new /obj/item/clothing/mask/facehugger(src)
	return

/obj/structure/alien/egg/proc/Burst(var/kill = 1) //drops and kills the hugger if any is remaining
	if(status == GROWN || status == GROWING)
		icon_state = "egg_hatched"
		flick("egg_opening", src)
		status = BURSTING
		addtimer(CALLBACK(src, .proc/givefacehugger, kill), 15)

/obj/structure/alien/egg/proc/givefacehugger(var/kill = 1)
	var/obj/item/clothing/mask/facehugger/child = GetFacehugger()
	status = BURST
	child.forceMove(get_turf(src))

	if(kill && istype(child))
		child.Die()
	else
		for(var/mob/M in range(1,src))
			if(CanHug(M))
				child.Attach(M)
				break

/obj/structure/alien/egg/HasProximity(atom/movable/AM as mob|obj)
	if(status == GROWN)
		if(!CanHug(AM))
			return

		var/mob/living/carbon/C = AM
		if(C.stat == CONSCIOUS && C.status_flags & XENO_HOST)
			return

		Burst(0)

#undef BURST
#undef BURSTING
#undef GROWING
#undef GROWN

#undef MAX_PROGRESS
