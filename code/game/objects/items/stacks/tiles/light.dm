/obj/item/stack/tile/light
	name = "light tile"
	singular_name = "light floor tile"
	desc = "A floor tile, made out of glass. It produces light."
	icon_state = "tile_e"
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "smashed")
	var/state = 0

/obj/item/stack/tile/light/Initialize(mapload, new_amount, merge = TRUE)
	. = ..()
	if(prob(5))
		state = 3 //broken
	else if(prob(5))
		state = 2 //breaking
	else if(prob(10))
		state = 1 //flickering occasionally
	else
		state = 0 //fine

/obj/item/stack/tile/light/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iscrowbar())
		amount--
		to_chat(user, "<span class='notice'>You pry off the steel sheet from the [name].</span>")
		attacking_item.play_tool_sound(get_turf(src), 100)
		new /obj/item/stack/material/glass/wired(user.loc)
		new /obj/item/stack/material/steel(user.loc)
		if(amount <= 0)
			qdel(src)
	else
		return ..()

/obj/item/stack/tile/light/attack_self(mob/user)
	amount--
	playsound(src.loc, 'sound/items/Deconstruct.ogg', 80, 1)
	new /obj/machinery/floor_light(user.loc)
	if(amount <= 0)
		qdel(src)
