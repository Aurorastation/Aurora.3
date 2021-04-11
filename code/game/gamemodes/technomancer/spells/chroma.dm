/datum/technomancer/spell/chroma
	name = "Chroma"
	desc = "Creates light around you, or in a location of your choosing.  You can choose what color the light is.  This could be \
	useful to trick someone into believing you're casting a different spell, or perhaps just for fun."
	cost = 25
	obj_path = /obj/item/spell/chroma
	category = UTILITY_SPELLS

/obj/item/spell/chroma
	name = "chroma"
	desc = "The colors are dazzling."
	icon_state = "darkness"
	cast_methods = CAST_RANGED | CAST_USE
	aspect = ASPECT_LIGHT
	var/color_to_use = "#FFFFFF"

/obj/item/spell/chroma/Initialize()
	. = ..()
	set_light(6, 5, l_color = color_to_use)

/obj/effect/temporary_effect/chroma
	name = "chroma"
	desc = "How are you examining what which cannot be seen?"
	invisibility = 101
	time_to_die = 2 MINUTES //Despawn after this time, if set.

/obj/effect/temporary_effect/chroma/Initialize(var/mapload, var/new_color = "#FFFFFF")
	. = ..()
	set_light(6, 5, l_color = new_color)

/obj/item/spell/chroma/on_ranged_cast(atom/hit_atom, mob/user)
	var/turf/T = get_turf(hit_atom)
	if(T)
		new /obj/effect/temporary_effect/chroma(T, color_to_use)
		to_chat(user, "<span class='notice'>You shift the light onto \the [T].</span>")
		qdel(src)

/obj/item/spell/chroma/on_use_cast(mob/user)
	var/new_color = input(user, "Choose the color you want your light to be.", "Color selection") as null|color
	if(new_color)
		color_to_use = new_color
		set_light(6, 5, l_color = new_color)
