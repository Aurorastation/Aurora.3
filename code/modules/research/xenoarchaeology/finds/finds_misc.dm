
// Phoron shards have been moved to code/game/objects/items/weapons/shards.dm

//legacy crystal
/obj/structure/machinery/crystal
	name = "Crystal"
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal"

/obj/structure/machinery/crystal/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "crystal2"
