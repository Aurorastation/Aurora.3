/obj/item/weapon/storage/field_ration
	name = "field ration"
	desc = "An individually packed meal, designated to be consumed on field."
	icon = 'icons/obj/storage.dmi'
	icon_state = "ration"
	var/preset_ration	//if the package comes with one in particular, not a random
	var/ration_desc
	var/list/ration_options = list("Worker's Meal", "NanoTrasen Sponsored")
	var/selected_ration

/obj/item/weapon/storage/field_ration/Initialize()
	. = ..()
	if(!preset_ration)
		selected_ration = pick(ration_options)

/obj/item/weapon/storage/field_ration/examine(mob/user)
	. = ..()
	if(ration_desc)
		to_chat(user, ration_desc)

/obj/item/weapon/storage/field_ration/fill()
	..()
	new /obj/item/weapon/material/kitchen/utensil/spoon(src)
	create_ration()
	make_exact_fit()

/obj/item/weapon/storage/field_ration/proc/create_ration()
	switch(selected_ration)

		if("Worker's Meal")
			new /obj/item/weapon/reagent_containers/food/snacks/tajaran_bread(src)
			new /obj/item/weapon/reagent_containers/food/snacks/adhomian_can(src)
			new /obj/item/weapon/reagent_containers/food/drinks/bottle/victorygin(src)
			ration_desc = "This one has the stamp of the Republican Army."

		if("NanoTrasen Sponsored")
			new /obj/item/weapon/reagent_containers/food/snacks/liquidfood(src)
			new /obj/item/weapon/reagent_containers/food/snacks/sosjerky(src)
			new /obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind(src)
			ration_desc = "This one has the NanoTrasen logo."


/obj/item/weapon/storage/field_ration/nka
	icon_state = "largebox"
	ration_options = list("Imperial Army", "Royal Navy")

/obj/item/weapon/storage/field_ration/nka/create_ration()
	switch(selected_ration)

		if("Imperial Army")
			new /obj/item/weapon/reagent_containers/food/snacks/hardbread(src)
			new /obj/item/weapon/reagent_containers/food/drinks/bottle/victorygin(src)
			ration_desc = "This one has the stamp of the Imperial Adhomian Army."

		if("Royal Navy")
			new /obj/item/weapon/reagent_containers/food/snacks/liquidfood(src)
			new /obj/item/weapon/reagent_containers/food/snacks/adhomian_can(src)
			new /obj/item/weapon/reagent_containers/food/drinks/bottle/messa_mead(src)
			ration_desc = "This one has the stamp of the Royal Navy."