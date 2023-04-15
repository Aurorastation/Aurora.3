/obj/item/clothing/under/uniform/gadpathur
	name = "gadpathurian fatigues"
	desc = "A simple black cloth shirt and brown NBC-treated pants commonly worn by Gadpathurians."
	desc_extended = "Gadpathur is, perhaps, the only planet with a government-mandated planetary costume. These uniforms can be \
	found throughout the planet and are one of the most common markers of Gadpathurians abroad, due to the distinctive black \
	shirt of the uniform. While some personalization is common on these uniforms, they mostly remain the same regardless of \
	which cadre one belongs to."
	icon = 'icons/clothing/under/uniforms/gadpathur_uniform.dmi'
	icon_state = "gadpathur_uniform"
	item_state = "gadpathur_uniform"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/gadpathur
	name = "gadpathurian overcoat"
	desc = "A simple canvas overcoat typically worn by Gadpathurians. The dull colors of it make manufacturing easier."
	desc_extended = "Due to the extremely hostile surface conditions of Gadpathur, overcoats such as this one are a common sight \
	in order to protect against hazards. They are typically chemically treated to better resist chemicals and radiation, \
	and are often the difference between life and death on the planet's surface."
	icon = 'icons/clothing/suits/coats/gadpathur_coat.dmi'
	icon_state = "gadpathur_coat"
	item_state = "gadpathur_coat"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/trench/gadpathur
	name = "gadpathurian trenchcoat"
	desc = "A heavier Gadpathurian overcoat with some piping on the shoulders. Likely meant for the colder regions of the planet."
	desc_extended = "Due to the extremely hostile surface conditions of Gadpathur, overcoats such as this one are a common sight \
	in order to protect against hazards. They are typically chemically treated to better resist chemicals and radiation, \
	and are often the difference between life and death on the planet's surface."
	icon = 'icons/clothing/suits/coats/gadpathur_coat.dmi'
	icon_state = "gadpathurtrench"
	item_state = "gadpathurtrench"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/trench/gadpathur/leather
	name = "gadpathurian leather coat"
	desc = "A Gadpathurian overcoat made of leather rather than the typical canvas. Typically issued to exceptional Gadpathurians before they are sent abroad."
	icon_state = "gadpathurleather"
	item_state = "gadpathurleather"

/obj/item/clothing/suit/storage/toggle/leather_jacket/gadpathur
	name = "thermal coat"
	desc = "A thermally insulated coat commonly worn by Gadpathurians during the planet's bitterly cold nights."
	desc_extended = "Due to the extremely hostile surface conditions of Gadpathur, overcoats such as this one are a common sight \
	in order to protect against hazards. They are typically chemically treated to better resist chemicals and radiation, \
	and are often the difference between life and death on the planet's surface."
	icon = 'icons/clothing/suits/coats/gadpathur_coat.dmi'
	icon_state = "gadpathurthermal"
	item_state = "gadpathurthermal"
	contained_sprite = TRUE

/obj/item/clothing/head/gadpathur
	name = "cadre cap"
	desc = "A snugly-fitting cap with the traditional Gadpathurian red-and-orange sun on its face. It has no other identifying features."
	desc_extended = "Soft headgear is commonly worn by cadre members while indoors on Gadpathur or while traveling abroad from the planet. \
	Gadpathurian cadres universally avoid decorating their headgear beyond the barest essentials - such as the cadre one belongs \
	to - in order to not give away unwanted information to observers."
	icon = 'icons/clothing/head/gadpathur_cap.dmi'
	icon_state = "gadpathur_cap"
	item_state = "gadpathur_cap"
	contained_sprite = TRUE

/obj/item/clothing/head/turban/gadpathur
	name = "gadpathurian turban"
	desc = "A turban commonly worn by Gadpathur's Sikh population. Like most Gadpathurian clothing, this turban is made of canvas."
	icon = 'icons/clothing/head/gadpathur_cap.dmi'
	icon_state = "turban_gadpathur"
	item_state = "turban_gadpathur"

/obj/item/clothing/head/beret/gadpathur
	name = "cadre beret"
	desc = "A canvas beret with the traditional Gadpathurian red-and-orange sun on its badge. It has no other identifying marks."
	desc_extended = "Berets are commonly worn by cadre members while indoors on Gadpathur or while traveling abroad from the planet. \
	Gadpathurian cadres universally avoid decorating their headgear beyond the barest essentials - such as the cadre one belongs \
	to - in order to not give away unwanted information to observers."
	icon = 'icons/clothing/head/gadpathur_beret.dmi'
	icon_state = "gadpathur_beret"
	item_state = "gadpathur_beret"

/obj/item/clothing/head/beret/gadpathur/engineer
	name = "gadpathurian industrial beret"
	desc = "A blue canvas beret with the typical crossed hammer and shovel icon of an industrial cadre on its badge."
	icon_state = "gadpathur_engineer_beret"
	item_state = "gadpathur_engineer_beret"

/obj/item/clothing/head/beret/gadpathur/medical
	name = "gadpathurian medical beret"
	desc = "A red canvas beret with the golden cross of a medical cadre upon its badge."
	icon_state = "gadpathur_medic_beret"
	item_state = "gadpathur_medic_beret"

/obj/item/clothing/head/ushanka/gadpathur
	name = "gadpathurian patrol cap"
	desc = "A Gadpathurian cap with a sun shade for protection against the planet's ash storms."
	icon_state = "gadpathur_kepi"
	item_state = "gadpathur_kepi"
	icon = 'icons/clothing/head/gadpathur_kepi.dmi'
	contained_sprite = TRUE

/obj/item/clothing/head/ushanka/gadpathur/attack_self(mob/user as mob)
	src.earsup = !src.earsup
	if(src.earsup)
		icon_state = "[initial(icon_state)]_up"
		item_state = "[initial(icon_state)]_up"
		to_chat(user, SPAN_NOTICE("You raise the sun shade on the cap."))
	else
		src.icon_state = initial(icon_state)
		to_chat(user, SPAN_NOTICE("You lower the sun shade on the cap."))
	update_clothing_icon()

/obj/item/clothing/accessory/armband/gadpathur
	name = "cadre brassard"
	desc = "Gadpathurian cadres use these brassards, worn on their uniforms or their coats, to distinguish themselves."
	desc_extended = "Stop reading the fluff description of an accessory friend, we must fight the Solarian imperialists!"
	icon = 'icons/clothing/accessories/gadpathur_brassard.dmi'
	icon_state = "gadpathur_brassard"
	item_state = "gadpathur_brassard"
	contained_sprite = TRUE

/obj/item/clothing/accessory/armband/gadpathur/med
	name = "medical cadre brassard"
	desc = "Gadpathurian cadres use these brassards, worn on their uniforms or their coats, to distinguish themselves. This one depicts a golden cross \
	on a white background."
	icon_state = "gadpathur_brassard_med"
	item_state = "gadpathur_brassard_med"

/obj/item/clothing/accessory/armband/gadpathur/ind
	name = "industrial cadre brassard"
	desc = "Gadpathurian cadres use these brassards, worn on their uniforms or their coats, to distinguish themselves. This one depicts a crossed hammer and\
	shovel with golden heads."
	icon_state = "gadpathur_brassard_ind"
	item_state = "gadpathur_brassard_ind"

/obj/item/clothing/accessory/gadpathurian_leader
	name = "section leader badge"
	desc = "A Section Leader's badge is typically worn below one's overwear, in order to ensure that the hated Solarians will be unable to easily identify a leader in a crowd."
	icon_state = "gadpathurleaderbadge"
	item_state = "gadpathurleaderbadge"
	overlay_state = "gadpathurleaderbadge"

	flippable = TRUE

	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/clothing/accessory/dogtags/gadpathur
	name = "gadpathurian dogtags"
	desc = "Gadpathurian dogtags are issued to every non-exiled member of the planet's highly-militarized society and list their wearer's name, cadre, cadre ID, religion, and blood type. \
	They can be easily ripped in half in the event of the wearer's death."
	icon_state = "gadpathur_dogtags"
	item_state = "gadpathur_dogtags"
	can_be_broken = TRUE
	tag_type = /obj/item/dogtag/gadpathur_tag

/obj/item/dogtag/gadpathur_tag
	name = "gadpathurian dogtag"
	desc = "Gadpathurian dogtags are issued to every non-exiled member of the planet's highly-militarized society and list their wearer's name, cadre, cadre ID, religion, and blood type. \
	They can be easily ripped in half in the event of the wearer's death."
	icon = 'icons/clothing/accessories/dogtags.dmi'
	icon_state = "gadpathur_tag"
	w_class = ITEMSIZE_SMALL