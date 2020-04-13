/obj/structure/closet/wizard/armor
	name = "mastercrafted armor set"
	desc = "An artefact suit of armor that allows you to cast spells while providing more protection against attacks and the void of space."

/obj/structure/closet/wizard/armor/fill()
	..()
	new /obj/item/clothing/suit/space/void/wizard(src)
	new /obj/item/clothing/head/helmet/space/void/wizard(src)