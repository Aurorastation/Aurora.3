GLOBAL_LIST_INIT_TYPED(bump_teleporters, /obj/effect/bump_teleporter, list())

/obj/effect/bump_teleporter
	name = "bump-teleporter"
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x2"
	var/id = null			//id of this bump_teleporter.
	var/id_target = null	//id of bump_teleporter which this moves you to.
	invisibility = 101 		//nope, can't see this
	anchored = 1
	density = 1
	opacity = 0

/obj/effect/bump_teleporter/New()
	..()
	GLOB.bump_teleporters += src

/obj/effect/bump_teleporter/Destroy()
	GLOB.bump_teleporters -= src
	return ..()

/obj/effect/bump_teleporter/CollidedWith(atom/bumped_atom)
	. = ..()

	if(!ismob(bumped_atom))
		//user.forceMove(src.loc)	//Stop at teleporter location
		return

	if(!id_target)
		//user.forceMove(src.loc)	//Stop at teleporter location, there is nowhere to teleport to.
		return

	for(var/obj/effect/bump_teleporter/BT in GLOB.bump_teleporters)
		if(BT.id == src.id_target)
			usr.forceMove(BT.loc)	//Teleport to location with correct id.
			return
