/obj/item/clothing/mask/lyodsuit
	name = "lyodsuit mask"
	desc = "A simple mask that forms a part of the Dominian lyodsuit. Rather cozy, if you're warm-blooded."
	icon = 'icons/clothing/masks/lyodsuit.dmi'
	icon_state = "dom_thermal_mask"
	item_state = "dom_thermal_mask"
	contained_sprite = TRUE
	canremove = FALSE

/obj/item/clothing/gloves/lyodsuit
	name = "lyodsuit gloves"
	desc = "A pair of thermal gloves, guaranteed to keep hands toasty."
	icon = 'icons/clothing/gloves/lyodsuit.dmi'
	icon_state = "dom_thermal_gloves"
	item_state = "dom_thermal_gloves"
	contained_sprite = TRUE

/obj/item/clothing/shoes/lyodsuit
	name = "lyodsuit boots"
	desc = "A pair of thermal boots, guaranteed to prevent cold feet."
	icon = 'icons/clothing/shoes/lyodsuit.dmi'
	icon_state = "dom_thermal_boots"
	item_state = "dom_thermal_boots"
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/dominia_cape
	name = "dominia cape"
	desc = "This is a cape in the style of Dominia nobility. It's the latest fashion across Dominian space."
	icon = 'icons/clothing/suits/capes/dominia.dmi'
	icon_state = "dominian_cape"
	item_state = "dominian_cape"
	icon_override = null
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/dominia
	name = "dominia great coat"
	desc = "This is a great coat in the style of Dominia nobility. It's the latest fashion across Dominian space."
	icon = 'icons/clothing/suits/coats/dominia_noble_red.dmi'
	icon_state = "dominia_noble_red"
	item_state = "dominia_noble_red"
	icon_open = "dominia_noble_red_open"
	icon_closed = "dominia_noble_red"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/dominia/gold
	icon = 'icons/clothing/suits/coats/dominia_noble_gold.dmi'
	icon_state = "dominia_noble_gold"
	item_state = "dominia_noble_gold"
	icon_open = "dominia_noble_gold_open"
	icon_closed = "dominia_noble_gold"

/obj/item/clothing/suit/storage/toggle/dominia/black
	icon = 'icons/clothing/suits/coats/dominia_noble_black.dmi'
	icon_state = "dominia_noble_black"
	item_state = "dominia_noble_black"
	icon_open = "dominia_noble_black_open"
	icon_closed = "dominia_noble_black"

/obj/item/clothing/suit/storage/toggle/dominia/bomber
	name = "dominia bomber jacket"
	desc = "This is a bomber jacket of Dominian style."
	icon = 'icons/clothing/suits/coats/dominia_bomber.dmi'
	icon_state = "dominia_bomber"
	item_state = "dominia_bomber"
	icon_open = "dominia_bomber_open"
	icon_closed = "dominia_bomber"

/obj/item/clothing/under/dominia
	name = "dominia suit"
	desc = "This is a suit in the style of Dominia nobility. It's the latest fashion across Dominian space."
	icon = 'icons/clothing/under/uniforms/dominia_uniform_red.dmi'
	icon_state = "dominia_uniform_red"
	item_state = "dominia_uniform_red"
	contained_sprite = TRUE
	rolled_sleeves = FALSE
	rolled_down = FALSE
	var/has_down_and_sleeves = TRUE

/obj/item/clothing/under/dominia/rollsuit()
	set name = "Roll Down Jumpsuit"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return
	if(has_down_and_sleeves == FALSE)
		to_chat(usr, span("notice", "You cannot roll down the [src]!"))
		return

	if((rolled_sleeves == TRUE) && !(rolled_down))
		rolled_sleeves = FALSE

	if(rolled_down)
		body_parts_covered = initial(body_parts_covered)
		item_state = "[initial(item_state)]" // REMINDER!: Contained Sprites automatically take out the _un after the spritename, somehow.
		to_chat(usr, span("notice", "You roll up your [src]."))
		rolled_down = FALSE
	else
		body_parts_covered &= LOWER_TORSO|LEGS|FEET
		item_state = "[initial(item_state)]_d"
		to_chat(usr, span("notice", "You roll down your [src]."))
		rolled_down = TRUE
	update_clothing_icon()

/obj/item/clothing/under/dominia/rollsleeves()
	set name = "Roll Up Sleeves"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return
	if(has_down_and_sleeves == FALSE)
		to_chat(usr, span("notice", "You cannot roll up your [src]'s sleeves!"))
		return

	if(rolled_down == TRUE)
		to_chat(usr, span("notice", "You must roll up your [src] first!"))
		return

	if(rolled_sleeves)
		body_parts_covered = initial(body_parts_covered)
		item_state = "[initial(item_state)]" // REMINDER!: Contained Sprites automatically take out the _un after the spritename, somehow.
		to_chat(usr, span("notice", "You roll down your [src]'s sleeves."))
		rolled_sleeves = FALSE
	else
		body_parts_covered &= ~(ARMS|HANDS)
		item_state = "[initial(item_state)]_r"
		to_chat(usr, span("notice", "You roll up your [src]'s sleeves."))
		rolled_sleeves = TRUE
	update_clothing_icon()

/obj/item/clothing/under/dominia/black
	icon = 'icons/clothing/under/uniforms/dominia_uniform_black.dmi'
	icon_state = "dominia_uniform_black"
	item_state = "dominia_uniform_black"

/obj/item/clothing/under/dominia/sweater
	name = "dominia sweater"
	desc = "This is a sweater of Dominian style."
	icon = 'icons/clothing/under/uniforms/dominia_sweater.dmi'
	icon_state = "dom_sweater"
	item_state = "dom_sweater"

/obj/item/clothing/under/dominia/lyodsuit
	name = "lyodsuit"
	desc = "An imitation Lyodsuit from Dominia. It's lightweight, and high has quality fabric that makes it extremely comfortable to wear."
	description_fluff = "This Lyodsuit was created in Dominia. It is fashionable amongst the middle and lower classes of Dominia."
	icon = 'icons/clothing/under/uniforms/lyodsuit.dmi'
	icon_state = "dom_thermal"
	item_state = "dom_thermal"
	contained_sprite = TRUE

/obj/item/clothing/under/dominia/lyodsuit/hoodie
	name = "hoodied lyodsuit"
	desc = "An imitation Lyodsuit from Dominia. It's lightweight, and high has quality fabric that makes it extremely comfortable to wear. This one has a hood mask attached."
	icon = 'icons/clothing/under/uniforms/lyodsuit_hoodie.dmi'
	icon_state = "dom_thermal_hoodie"
	item_state = "dom_thermal_hoodie"
	var/obj/item/clothing/mask/lyodsuit/mask
	var/hood_raised = FALSE

/obj/item/clothing/under/dominia/lyodsuit/hoodie/Initialize()
	. = ..()
	create_mask()

/obj/item/clothing/under/dominia/lyodsuit/hoodie/Destroy()
	QDEL_NULL(mask)
	return ..()

/obj/item/clothing/under/dominia/lyodsuit/hoodie/dropped()
	remove_mask()

/obj/item/clothing/under/dominia/lyodsuit/hoodie/on_slotmove()
	remove_mask()

/obj/item/clothing/under/dominia/lyodsuit/hoodie/equipped(mob/user, slot)
	if(slot != slot_w_uniform)
		remove_mask()
	..()

/obj/item/clothing/under/dominia/lyodsuit/hoodie/proc/create_mask()
	if(!mask)
		mask = new /obj/item/clothing/mask/lyodsuit(src)

/obj/item/clothing/under/dominia/lyodsuit/hoodie/proc/remove_mask()
	// Mask got nuked. Probably because of RIGs or the like.
	create_mask()

	if(ishuman(mask.loc))
		var/mob/living/carbon/H = mask.loc
		H.unEquip(mask, 1)
	mask.forceMove(src)
	hood_raised = FALSE

/obj/item/clothing/under/dominia/lyodsuit/hoodie/verb/toggle_mask()
	set name = "Toggle Lyodsuit Mask"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return FALSE

	// double check to make sure the lyodsuit has its mask
	create_mask()

	if(!hood_raised)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.w_uniform != src)
				to_chat(H, span("warning", "You must be wearing \the [src] to put up the hood!"))
				return
			if(H.wear_mask)
				to_chat(H, span("warning", "You're already wearing something on your head!"))
				return
			else
				H.equip_to_slot_if_possible(mask, slot_wear_mask, 0, 0, 1)
				hood_raised = TRUE
				H.update_inv_wear_mask()
	else
		remove_mask()

/obj/item/clothing/under/dominia/lyodsuit/hoodie/rollsuit()
	..()
	if(rolled_down == TRUE)
		remove_mask()
