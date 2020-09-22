/obj/item/clothing/under/uniforms/gadpathur
	name = "gadpathurian fatigues"
	desc = "A simple black cloth shirt and brown NBC-treated pants commonly worn by Gadpathurians."
	desc_fluff = "Gadpathur is, perhaps, the only planet with a government-mandated planetary costume. These uniforms can be \
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
	desc_fluff = "Due to the extremely hostile surface conditions of Gadpathur, overcoats such as this one are a common sight \
	in order to protect against hazards. They are typically chemically treated to better resist chemicals and radiation, \
	and are often the difference between life and death on the planet's surface."
	icon = 'icons/clothing/suit/coats/gadpathur_coat'
	contained_sprite = TRUE

/obj/item/clothing/head/soft/gadpathur
	name = "cadre cap"
	desc = "A snugly-fitting cap with the traditional Gadpathurian red-and-orange sun on its face. It has no other identifying features."
	desc_fluff = "Soft headgear is commonly worn by cadre members while indoors on Gadpathur or while traveling abroad from the planet. \
	Gadpathurian cadres universally avoid decorating their headgear beyond the barest essentials - such as the cadre one belongs \
	to - in order to not give away unwanted information to observers."
	icon = 'icons/clothing/head/gadpathur_cap.dmi'
	icon_state = "gadpathur_cap"
	item_state = "gadpathur_cap"
	contained_sprite = TRUE

/obj/item/clothing/head/soft/gadpathur/beret
	name = "cadre beret"
	desc = "A canvas beret with the traditional Gadpathurian red-and-orange sun on its badge. It has no other identifying marks."
	desc_fluff = "Berets are commonly worn by cadre members while indoors on Gadpathur or while traveling abroad from the planet. \
	Gadpathurian cadres universally avoid decorating their headgear beyond the barest essentials - such as the cadre one belongs \
	to - in order to not give away unwanted information to observers."
	icon = 'icons/clothing/head/gadpathur_beret.dmi'
	icon_state = "gadpathur_beret"
	item_state = "gadpathur_beret"

/obj/item/clothing/head/helmet/gadpathur
	name = "gadpathurian helmet"
	desc = "A thin, mild steel helmet with a canvas band depicting the red-and-gold Gadpathurian sun on the front."
	desc_fluff = "Gadpathurians will recognize this as a typical civil defense helmet issued to almost every citizen of the planet. \
	It's sometimes taken abroad as a memento, and to be worn during moments of danger. After all, some protection is better than none at all. \
	Quite recently, NanoTrasen has requested all Gadpathurians make an effort to dull the edges of their helmets when bringing them aboard."
	armor = list(melee = 6, bullet = 5, laser = 5, energy = 3, bomb = 5, bio = 0, rad = 0)
	force = 4
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	flags_inv = HIDEEARS
	icon = 'icons/clothing/head/gadpathur_helmet.dmi'
	icon_state = "gadpathur_helmet"
	item_state = "gadpathur_helmet"
	contained_sprite = TRUE

/obj/item/clothing/mask/breath/gadpathur
	name = "gadpathurian rebreather"
	desc = "A sturdy-looking rebreather with a canvas scarf wrapped around it. Boring, but sturdy-looking."
	desc_fluff = "A common sight on Gadpathur, the Type 2308 (its year of creation) rebreather is typically worn with an oxygen tank or filtration\
	module to combat more minor contaminants found on Gadpathur. Not intended for use in seriously contaminated zones."
	icon_state = "gadpathur_breath"
	item_state = "gadpathur_breath"
	adjustable = FALSE
	contained_sprite = TRUE

/obj/item/clothing/accessory/armband/gadpathur
	name = "cadre brassard"
	desc = "Gadpathurian cadres use these brassards, worn on their uniforms or their coats, to distinguish themselves."
	desc_fluff = "Stop reading the fluff description of an accessory friend, we must fight the Solarian imperialists!"
	icon = 'icons/clothing/accessories/gadpathur_brassard'
	icon_state = "gadpathur_brassard"
	obj_state = "gadpathur_brassard"
	contained_sprite = TRUE

/obj/item/clothing/accessory/armband/gadpathur/med
	name = "medical cadre brassard"
	desc = "Gadpathurian cadres use these brassards, worn on their uniforms or their coats, to distinguish themselves. This one depicts a golden cross \
	on a white background."
	icon_state = "gadpathur_brassard_med"
	obj_state = "gadpathur_brassard_med"

/obj/item/clothing/accessory/armband/gadpathur/ind
	name = "industrial cadre brassard"
	desc = "Gadpathurian cadres use these brassards, worn on their uniforms or their coats, to distinguish themselves. This one depicts a crossed hammer and\
	shovel with golden heads."
	icon_state = "gadpathur_brassard_ind"
	obj_state = "gadpathur_brassard_ind"