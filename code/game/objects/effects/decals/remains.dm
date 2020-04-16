/obj/effect/decal/remains
	name = "remains"
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	anchored = 0

/obj/effect/decal/remains/human
	desc = "They look like human remains. They have a strange aura about them."

/obj/effect/decal/remains/xeno
	desc = "They look like the remains of something... alien. They have a strange aura about them."
	icon_state = "remainsxeno"

/obj/effect/decal/remains/robot
	desc = "They look like the remains of something mechanical. They have a strange aura about them."
	icon = 'icons/mob/robots.dmi'
	icon_state = "remainsrobot"

/obj/effect/decal/remains/rat
	name = "rat skeleton"
	desc = "Looks like the remains of a small rodent. It doesn't squeak anymore."
	icon = 'icons/mob/npc/rat.dmi'
	icon_state = "skeleton"

/obj/effect/decal/remains/lizard
	desc = "They look like the remains of a small reptile."
	icon_state = "lizard"

//Target turns to ash.
/obj/effect/decal/remains/proc/crumble()
	var/turf/simulated/floor/F = get_turf(src)
	visible_message(SPAN_NOTICE("\The [src] sink together into a pile of ash."))
	if (istype(F))
		new /obj/effect/decal/cleanable/ash(F)
	qdel(src)

//Target turns to oil.
/obj/effect/decal/remains/robot/crumble()
	var/turf/simulated/floor/F = get_turf(src)
	visible_message(SPAN_NOTICE("\The [src] degrade into a pool of oil."))
	if (istype(F))
		new /obj/effect/decal/cleanable/blood/oil(F)
	qdel(src)

/obj/effect/decal/remains/Move()
	if(pulledby)
		crumble()

/obj/effect/decal/remains/attack_hand(mob/user)
	crumble()

/obj/effect/decal/remains/attack_ai(mob/user)
	if(isrobot(user) && Adjacent(user)) // Remains crumble when robots touch, but not the AI.
		crumble()
