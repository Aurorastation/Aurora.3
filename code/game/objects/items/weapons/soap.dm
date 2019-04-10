//Various Soaps

/obj/item/weapon/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/soap.dmi'
	icon_state = "soap"
	w_class = 2.0
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	flags = OPENCONTAINER
	var/key_data

/obj/item/weapon/soap/nanotrasen
	desc = "A NanoTrasen-brand bar of soap. Smells of phoron."
	icon_state = "soapnt"

/obj/item/weapon/soap/plant
	desc = "A green bar of soap. Smells like dirt and plants."

/obj/item/weapon/soap/deluxe
	icon_state = "soapdeluxe"

/obj/item/weapon/soap/deluxe/New()
	..()
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of [pick("lavender", "vanilla", "strawberry", "chocolate" ,"space")]."

/obj/item/weapon/soap/syndie
	desc = "An untrustworthy bar of soap. Smells of fear."
	icon_state = "soapsyndie"

/obj/item/weapon/soap/space_soap
	name = "Soap"
	desc = "Smells like burnt meat."
	icon_state = "space_soap"

/obj/item/weapon/soap/water_soap
	name = "Soap"
	desc = "Smells of chlorine."
	icon_state = "water_soap"

/obj/item/weapon/soap/fire_soap
	name = "Soap"
	desc = "Smells like burnt charcoal."
	icon_state = "fire_soap"

/obj/item/weapon/soap/rainbow_soap
	name = "Soap"
	desc = "Smells sweet."
	icon_state = "rainbow_soap"

/obj/item/weapon/soap/diamond_soap
	name = "Soap"
	desc = "Smells of saffron."
	icon_state = "diamond_soap"

/obj/item/weapon/soap/uranium_soap
	name = "Soap"
	desc = "Doesn't smell... it's glowing though."
	icon_state = "uranium_soap"

/obj/item/weapon/soap/silver_soap
	name = "Soap"
	desc = "Smells bitter."
	icon_state = "silver_soap"

/obj/item/weapon/soap/brown_soap
	name = "Soap"
	desc = "Smells like chocolate."
	icon_state = "brown_soap"

/obj/item/weapon/soap/white_soap
	name = "Soap"
	desc = "Smells like chicken."
	icon_state = "white_soap"

/obj/item/weapon/soap/grey_soap
	name = "Soap"
	desc = "Smells like acid."
	icon_state = "grey_soap"

/obj/item/weapon/soap/pink_soap
	name = "Soap"
	desc = "Smells like bubble gum"
	icon_state = "pink_soap"

/obj/item/weapon/soap/purple_soap
	name = "Soap"
	desc = "Smells like lavender."
	icon_state = "purple_soap"

/obj/item/weapon/soap/blue_soap
	name = "Soap"
	desc = "Smells like lilies."
	icon_state = "blue_soap"

/obj/item/weapon/soap/cyan_soap
	name = "Soap"
	desc = "Smells like bluebells."
	icon_state = "cyan_soap"

/obj/item/weapon/soap/green_soap
	name = "Soap"
	desc = "Smells like a freshly mowed lawn."
	icon_state = "green_soap"

/obj/item/weapon/soap/yellow_soap
	name = "Soap"
	desc = "Smells like sunflowers."
	icon_state = "yellow_soap"

/obj/item/weapon/soap/orange_soap
	name = "Soap"
	desc = "Smells like oranges."
	icon_state = "orange_soap"

/obj/item/weapon/soap/red_soap
	name = "Soap"
	desc = "Smells like blood."
	icon_state = "red_soap"

/obj/item/weapon/soap/golden_soap
	name = "Soap"
	desc = "Smells like butter."
	icon_state = "golden_soap"

/obj/random/soap/
	name = "Random Soap"
	desc = "This is a random soap."
	icon = 'icons/obj/soap.dmi'
	icon_state = "soap"
	item_to_spawn()
		return pick(prob(1);/obj/item/weapon/soap, \
					prob(1);/obj/item/weapon/soap/nanotrasen, \
					prob(1);/obj/item/weapon/soap/deluxe,\
					prob(1);/obj/item/weapon/soap/space_soap,\
					prob(1);/obj/item/weapon/soap/space_soap,\
					prob(1);/obj/item/weapon/soap/water_soap,\
					prob(1);/obj/item/weapon/soap/fire_soap,\
					prob(1);/obj/item/weapon/soap/rainbow_soap,\
					prob(1);/obj/item/weapon/soap/diamond_soap,\
					prob(1);/obj/item/weapon/soap/uranium_soap,\
					prob(1);/obj/item/weapon/soap/silver_soap,\
					prob(1);/obj/item/weapon/soap/brown_soap,\
					prob(1);/obj/item/weapon/soap/white_soap,\
					prob(1);/obj/item/weapon/soap/grey_soap,\
					prob(1);/obj/item/weapon/soap/pink_soap,\
					prob(1);/obj/item/weapon/soap/purple_soap,\
					prob(1);/obj/item/weapon/soap/blue_soap,\
					prob(1);/obj/item/weapon/soap/cyan_soap,\
					prob(1);/obj/item/weapon/soap/green_soap,\
					prob(1);/obj/item/weapon/soap/yellow_soap,\
					prob(1);/obj/item/weapon/soap/orange_soap,\
					prob(1);/obj/item/weapon/soap/red_soap,\
					prob(1);/obj/item/weapon/soap/golden_soap

)
