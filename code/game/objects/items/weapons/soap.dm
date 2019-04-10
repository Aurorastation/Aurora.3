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
	desc = "Smells wet."
	icon_state = "water_soap"

/obj/item/weapon/soap/fire_soap
	name = "Soap"
	desc = "Smells warm."
	icon_state = "fire_soap"

/obj/item/weapon/soap/rainbow_soap
	name = "Soap"
	desc = "Smells like unicorns and magic."
	icon_state = "rainbow_soap"

/obj/item/weapon/soap/diamond_soap
	name = "Soap"
	desc = "Smells of expenses."
	icon_state = "diamond_soap"

/obj/item/weapon/soap/uranium_soap
	name = "Soap"
	desc = "Smells like explosions."
	icon_state = "uranium_soap"

/obj/item/weapon/soap/silver_soap
	name = "Soap"
	desc = "Smells like surfing."
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
	desc = "Smells like rain."
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
	desc = "What smells like blue?..."
	icon_state = "blue_soap"

/obj/item/weapon/soap/cyan_soap
	name = "Soap"
	desc = "Smells like bluebells."
	icon_state = "cyan_soap"

/obj/item/weapon/soap/green_soap
	name = "Soap"
	desc = "Smells like radioactive waste."
	icon_state = "green_soap"

/obj/item/weapon/soap/yellow_soap
	name = "Soap"
	desc = "Smells like sun flowers."
	icon_state = "yellow_soap"

/obj/item/weapon/soap/orange_soap
	name = "Soap"
	desc = "Smells like oranges."
	icon_state = "orange_soap"

/obj/item/weapon/soap/red_soap
	name = "Soap"
	desc = "Smells like my last victim..."
	icon_state = "red_soap"

/obj/item/weapon/soap/golden_soap
	name = "Soap"
	desc = "Smells like glory."
	icon_state = "golden_soap"

/obj/item/weapon/soap/irish_soap
	name = "Soap"
	desc = "Smells like hops."
	icon_state = "irish_soap"

/obj/item/weapon/soap/swedish_soap
	name = "Soap"
	desc = "Smells like free college and high taxes."
	icon_state = "swedish_soap"

/obj/item/weapon/soap/american_soap
	name = "Soap"
	desc = "Smells like freedom."
	icon_state = "american_soap"

/obj/item/weapon/soap/british_soap
	name = "Soap"
	desc = "Smells like tea."
	icon_state = "british_soap"

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
