/obj/structure/undetonated_nuke
	name = "undetonated nuclear bomb"
	desc = "This rusted bomb looks like it's been here for decades. Flaking paint on the side depicts the battle standard of the Traditionalist Coalition. Something is written in Sinta'Azaziba on the side."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "bomb"
	density = TRUE
	anchored = FALSE
	var/can_explode = TRUE

/obj/structure/undetonated_nuke/get_examine_text(mob/user, distance)
	. = ..()
	if(GLOB.all_languages[LANGUAGE_AZAZIBA] in user.languages)
		. += SPAN_NOTICE("The inscription reads \"WARNING: FISSILE MATERIAL. HANDLE WITH CARE.\" Underneath are a few words, scratched into the metal. They read \"IF FOUND, RETURN TO SKALAMAR AT HIGH VELOCITY\"")

/obj/structure/undetonated_nuke/ex_act(severity)
	if(!can_explode)
		return
	switch(severity)
		if(1.0)
			visible_message(SPAN_DANGER("A hissing noise emerges from \the [src]'s casing..."))
			addtimer((CALLBACK(src, PROC_REF(explode)), rand(20, 60)))
			return
		if(2.0)
			if(prob(50))
				visible_message(SPAN_DANGER("A hissing noise emerges from \the [src]'s casing..."))
				addtimer((CALLBACK(src, PROC_REF(explode)), rand(20, 60)))
				return
		if(3.0)
			return

/obj/structure/undetonated_nuke/proc/explode() //Sets off a big conventional explosion from the trigger and scatters radioactive material, but doesn't do a full-on nuclear explosion because nukes are not video game explosive barrels.
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
	var/turf/T = get_turf(src)
	if(attacking_item.is_shovel() && T.diggable)
		visible_message(SPAN_NOTICE("\The [user] begins to excavate \the [src]."))
		if(attacking_item.use_tool(src, user, 100, volume = 50))
			visible_message(SPAN_NOTICE("\The [user] finishes digging \the [src] from \the [T]!"))
			new /obj/structure/pit(T)
			var/obj/structure/undetonated_nuke/N = (T)
			N.can_explode = can_explode
			qdel(src)
