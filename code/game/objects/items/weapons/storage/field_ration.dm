/obj/item/weapon/storage/field_ration
	name = "field ration"
	desc = "An individually packed meal, designated to be consumed on field."
	icon = 'icons/obj/storage.dmi'
	icon_state = "ration"
	description_fluff = "The republican army is the best equipped among the warring factions of Adhomai, being supplied by NanoTrasen and other outworld supporters. Canned goods and \
	modern rations are issued to all branches of the Republic’s military. Native field meals are composed of salt-cured Fatshouters’s meat, bread and Victory Gin, while imported ones \
	are commonly found in the form of LiquidFood rations, a less than popular alternative manufactured by NanoTrasen."
	var/preset_ration	//if the package comes with one in particular, not a random

/obj/item/weapon/storage/field_ration/fill()
	..()
	new /obj/item/weapon/material/kitchen/utensil/spoon(src)
	create_ration()
	make_exact_fit()

/obj/item/weapon/storage/field_ration/proc/create_ration()
	var/selected_ration = preset_ration
	if(!selected_ration)
		selected_ration = pick("Worker's Meal", "NanoTrasen Sponsored")

	switch(selected_ration)

		if("Worker's Meal")
			new /obj/item/weapon/reagent_containers/food/snacks/tajaran_bread(src)
			new /obj/item/weapon/reagent_containers/food/snacks/adhomian_can(src)
			new /obj/item/weapon/reagent_containers/food/drinks/bottle/victorygin(src)
			desc += " This one has the stamp of the Republican Army."

		if("NanoTrasen Sponsored")
			new /obj/item/weapon/reagent_containers/food/snacks/liquidfood(src)
			new /obj/item/weapon/reagent_containers/food/snacks/liquidfood(src)
			new /obj/item/weapon/reagent_containers/food/drinks/cans/sodawater(src)
			desc += " This one has the NanoTrasen logo."

/obj/item/weapon/storage/field_ration/army
	preset_ration = "Worker's Meal"

/obj/item/weapon/storage/field_ration/nanotrasen
	preset_ration = "NanoTrasen Sponsored"

/obj/item/weapon/storage/field_ration/nka
	icon_state = "bigbox"
	description_fluff = "The early Alam'ardii forces relied on the landed nobility to provide them food, with the resources being taken from the private properties of their contractors. \
	Their rations were composed mainly of salt-cured Snow Strider's meat, Blizzard Ears's flour and Fatshouters's milk. The defection of many officers from the Republican navy to the \
	imperial side introduced the concept of canned goods, a luxury at the time, being used as rations. Large shipments of supplements, included food, were smuggled by the officers and \
	their crew during the formation of the Royal Navy."

/obj/item/weapon/storage/field_ration/nka/create_ration()
	var/selected_ration = preset_ration
	if(!selected_ration)
		selected_ration = pick("Imperial Army", "Royal Navy")

	switch(selected_ration)

		if("Imperial Army")
			new /obj/item/weapon/reagent_containers/food/snacks/hardbread(src)
			new /obj/item/weapon/reagent_containers/food/drinks/cans/adhomai_milk(src)
			desc += " This one has the stamp of the Imperial Adhomian Army."

		if("Royal Navy")
			new /obj/item/weapon/reagent_containers/food/snacks/hardbread(src)
			new /obj/item/weapon/reagent_containers/food/snacks/adhomian_can(src)
			new /obj/item/weapon/reagent_containers/food/drinks/bottle/messa_mead(src)
			desc += " This one has the stamp of the Royal Navy."

/obj/item/weapon/storage/field_ration/nka/army
	preset_ration = "Imperial Army"

/obj/item/weapon/storage/field_ration/nka/navy
	preset_ration = "Royal Navy"