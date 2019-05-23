

///jar

/obj/item/weapon/reagent_containers/food/drinks/jar
	name = "empty jar"
	desc = "A glass jar. You can put the lid back on and use it as a tip jar."
	icon_state = "jar"
	item_state = "beaker"
	center_of_mass = list("x"=15, "y"=8)
	unacidable = 1

/obj/item/weapon/reagent_containers/food/drinks/jar/on_reagent_change()
	if (reagents.reagent_list.len > 0)
		icon_state ="jar_what"
		name = "jar of something"
		desc = "You can't really tell what this is." //todo : make this an overlay that changes color ala beaker. nonetheless, it works for now. -wezzy.
	else
		icon_state = "jar"
		name = "empty jar"
		desc = "A glass jar. You can put the lid back on and use it as a tip jar."
		return

/obj/item/weapon/reagent_containers/food/drinks/jar/attack_self(var/mob/user)
	to_chat(user, "<span class='notice'>You put the lid on \the [src].</span>")
	user.put_in_hands(new /obj/item/glass_jar)
	qdel(src)
	return