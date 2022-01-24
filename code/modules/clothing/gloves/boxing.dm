/obj/item/clothing/gloves/boxing
	name = "boxing gloves"
	desc = "Because you really needed another excuse to punch your crewmates."
	icon_state = "boxing"
	item_state = "boxing"
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_VAURCA_BULWARK)

/obj/item/clothing/gloves/boxing/attackby(obj/item/W, mob/user)
	if(W.iswirecutter() || istype(W, /obj/item/surgery/scalpel))
		to_chat(user, "<span class='notice'>That won't work.</span>")	//Nope)
		return
	..()

/obj/item/clothing/gloves/boxing/green
	icon_state = "boxinggreen"
	item_state = "boxinggreen"

/obj/item/clothing/gloves/boxing/blue
	icon_state = "boxingblue"
	item_state = "boxingblue"

/obj/item/clothing/gloves/boxing/yellow
	icon_state = "boxingyellow"
	item_state = "boxingyellow"
