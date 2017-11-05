/obj/structure/alien/node
	name = "alien weed node"
	desc = "Some kind of strange, pulsating structure."
	icon_state = "weednode"
	health = 100
	layer = 3.1

/obj/structure/alien/node/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/structure/alien/node/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/alien/node/process()
	if(locate(/obj/effect/plant) in loc)
		return
	new /obj/effect/plant(get_turf(src), SSplants.seeds["xenomorph"])
