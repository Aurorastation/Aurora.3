/obj/structure/undetonated_nuke
	name = "undetonated nuclear bomb"
	desc = "This rusted bomb looks like it's been here for decades. Flaking paint on the side depicts the battle standard of the Traditionalist Coalition. Something is written in Sinta'Azaziba on the side."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "bomb"
	density = TRUE
	anchored = FALSE
	///Whether this nuke will explode if caught in an explosion.
	var/can_explode = TRUE

/obj/structure/undetonated_nuke/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(GLOB.all_languages[LANGUAGE_AZAZIBA] in user.languages)
		. += SPAN_NOTICE("The inscription reads \"WARNING: FISSILE MATERIAL. HANDLE WITH CARE.\" Underneath are a few words, scratched into the metal. They read \"IF FOUND, RETURN TO SKALAMAR AT HIGH VELOCITY\"")

/obj/structure/undetonated_nuke/ex_act(severity)
	if(!can_explode)
		return
	switch(severity)
		if(1.0)
			explode()
			return
		if(2.0)
			if(prob(50))
				explode()
				return
		if(3.0)
			return

///Sets off a large conventional explosion from the trigger and spreads radioactive material. Does not set off a nuclear explosion.
/obj/structure/undetonated_nuke/proc/explode()
	var/turf/T = get_turf(src)
	can_explode = FALSE
	visible_message(SPAN_DANGER("\The [src] explodes!"))
	explosion(T, 6, 8, 10)
	SSradiation.radiate(src, 250)
	new /obj/effect/decal/cleanable/greenglow(T)

/obj/structure/undetonated_nuke/buried
	name = "buried nuclear bomb"
	desc = "This rusted metal shell is half-buried in the sand, and seems to have been that way for decades. Flaking paint on the side depicts the battle standard of the Traditionalist Coalition. Something is written in Sinta'Azaziba on the side."
	anchored = TRUE
	icon_state = "bomb_buried"

/obj/structure/undetonated_nuke/buried/Initialize(mapload)
	. = ..()
	if(prob(50))
		can_explode = FALSE

/obj/structure/undetonated_nuke/buried/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	var/turf/current_turf = get_turf(src)
	if(istype(current_turf, /turf/simulated/floor/exoplanet))
		var/turf/simulated/floor/exoplanet/T = current_turf
		if(attacking_item.is_shovel() && T.diggable)
			visible_message(SPAN_NOTICE("\The [user] begins to excavate \the [src]."))
			if(attacking_item.use_tool(src, user, 100, volume = 50))
				visible_message(SPAN_NOTICE("\The [user] finishes digging \the [src] from \the [T]!"))
				new /obj/structure/pit(T)
				var/obj/structure/undetonated_nuke/N = new(T)
				N.can_explode = can_explode
				qdel(src)
