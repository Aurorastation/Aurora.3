///jar

/obj/item/reagent_containers/glass/beaker/jar
	name = "glass jar"
	desc = "A glass jar. You can put the lid back on and use it for other things."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "jar"
	filling_states = "-10;10;25;50;75;80;100"
	matter = list(MATERIAL_GLASS = 5000)
	center_of_mass = list("x"=15, "y"=8)
	w_class = ITEMSIZE_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 120
	unacidable = 1

/obj/item/reagent_containers/glass/beaker/jar/attack_self(var/mob/user)
	if(reagents.total_volume > 0)
		to_chat(user, SPAN_WARNING("You need to empty \the [src] first!"))
		return
	else
		to_chat(user, SPAN_NOTICE("You put the lid on \the [src]."))
		user.drop_from_inventory(src)
		user.put_in_hands(new /obj/item/glass_jar) //found in glassjar.dm
		qdel(src)
	return
