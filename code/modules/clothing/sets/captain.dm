// Standard
/obj/item/clothing/head/caphat
	name = "captain's hat"
	desc = "It's good being the king."
	icon_state = "captain"
	item_state_slots = list(
		slot_l_hand_str = "caphat",
		slot_r_hand_str = "caphat"
		)

/obj/item/clothing/head/caphat/scc
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "caphat"
	item_state = "caphat"
	contained_sprite = TRUE

/obj/item/clothing/head/caphat/cap
	name = "captain's cap"
	desc = "You fear to wear it for the negligence it brings."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain_cap"
	item_state = "captain_cap"
	item_state_slots = null
	contained_sprite = TRUE

/obj/item/clothing/head/bandana/captain
	name = "captain's bandana"
	desc = "It's the captain's bandana with some fine nanotech lining. All hands on deck!"
	icon_state = "bandana_captain"
	item_state = "bandana_captain"

/obj/item/clothing/under/rank/captain
	name = "captain's jumpsuit"
	desc = "It's a blue jumpsuit with some gold markings denoting the rank of \"Captain\"."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain_alt"
	item_state = "captain_alt"
	worn_state = "captain_alt"
	contained_sprite = TRUE
	var/is_open = FALSE

/obj/item/clothing/under/rank/captain/verb/fold_open()
	set name = "Fold Collar"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return

	if(is_open == -1)
		to_chat(usr, SPAN_WARNING("The collar on \the [src] cannot be folded."))
		return

	is_open = !is_open
	if(!is_open)
		to_chat(usr, SPAN_NOTICE("You fold the collar of \the [src] closed."))
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	else
		to_chat(usr, SPAN_NOTICE("You fold the collar of \the [src] open."))
		icon_state = "[initial(icon_state)]_open"
		item_state = "[initial(item_state)]_open"
	update_clothing_icon()

/obj/item/clothing/under/dress/dress_cap
	name = "captain's dress uniform"
	desc = "Feminine fashion for the style concious captain."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain_alt_skirt"
	item_state = "captain_alt_skirt"
	worn_state = "captain_alt_skirt"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	var/is_open = FALSE

/obj/item/clothing/under/dress/dress_cap/verb/fold_open()
	set name = "Fold Collar"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return

	if(is_open == -1)
		to_chat(usr, SPAN_WARNING("The collar on \the [src] cannot be folded."))
		return

	is_open = !is_open
	if(!is_open)
		to_chat(usr, SPAN_NOTICE("You fold the collar of \the [src] closed."))
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	else
		to_chat(usr, SPAN_NOTICE("You fold the collar of \the [src] open."))
		icon_state = "[initial(icon_state)]_open"
		item_state = "[initial(item_state)]_open"
	update_clothing_icon()

/obj/item/clothing/suit/captunic/capjacket
	name = "captain's uniform jacket"
	desc = "A less formal jacket for everyday captain use."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain_alt_jacket"
	item_state = "captain_alt_jacket"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = 0

/obj/item/clothing/gloves/captain
	name = "captain's gloves"
	desc = "Regal blue gloves, with a nice gold trim. Swanky."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain_gloves"
	item_state = "captain_gloves"
	contained_sprite = TRUE

/obj/item/clothing/shoes/captain
	name = "captain's shoes"
	desc = "Super comfortable blue shoes, capable of keeping you on your feet during any station-wide disaster."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain_shoes"
	item_state = "captain_shoes"
	contained_sprite = TRUE

/obj/item/storage/briefcase/nt/captain
	name = "captain uniform briefcase"
	desc = "An NT-branded briefcase containing various pieces of the captain's uniform, for use by stylish captains."
	starts_with = list(
		/obj/item/clothing/head/caphat = 1,
		/obj/item/clothing/head/caphat/cap = 1,
		/obj/item/clothing/head/bandana/captain = 1,
		/obj/item/clothing/under/rank/captain = 1,
		/obj/item/clothing/under/dress/dress_cap = 1,
		/obj/item/clothing/suit/captunic/capjacket = 1,
		/obj/item/clothing/gloves/captain = 1,
		/obj/item/clothing/shoes/captain = 1
	)

// White
/obj/item/clothing/head/caphat/cap/beret
	name = "captain's white beret"
	desc = "A beret, worn to passively instill authority at the audacity of wearing a puffy hat."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain_beret_white"
	item_state = "captain_beret_white"

/obj/item/clothing/head/caphat/cap/white
	name = "captain's white cap"
	desc = "No one in a commanding position should be without a perfect, white hat of ultimate authority."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain_cap_white"
	item_state = "captain_cap_white"

/obj/item/clothing/under/rank/captain/white
	name = "captain's white jumpsuit"
	desc = "It's a white jumpsuit with some gold markings denoting the rank of \"Captain\"."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain_white"
	item_state = "captain_white"
	is_open = -1

/obj/item/clothing/gloves/captain/white
	name = "captain's white gloves"
	desc = "Shiny white gloves, with a nice gold trim. Swanky."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain_gloves_white"
	item_state = "captain_gloves_white"

/obj/item/clothing/shoes/captain/white
	name = "captain's white shoes"
	desc = "Super comfortable white shoes, capable of keeping you on your feet during any station-wide disaster."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain_shoes_white"
	item_state = "captain_shoes_white"

/obj/item/clothing/under/rank/captain/white_dress
	name = "captain's white dress"
	desc = "The white variant of feminine fashion for the style conscious captain."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain_skirt_white"
	item_state = "captain_skirt_white"
	worn_state = "captain_skirt_white"
	is_open = -1

/obj/item/storage/briefcase/nt/captain_white
	name = "captain white uniform briefcase"
	desc = "An NT-branded briefcase containing various pieces of the captain's white uniform, for use when wine spillage is unlikely."
	starts_with = list(
		/obj/item/clothing/head/caphat/cap/beret = 1,
		/obj/item/clothing/head/caphat/cap/white = 1,
		/obj/item/clothing/under/rank/captain/white = 1,
		/obj/item/clothing/gloves/captain/white = 1,
		/obj/item/clothing/shoes/captain/white = 1,
		/obj/item/clothing/under/rank/captain/white_dress = 1
	)

// Formal
/obj/item/clothing/under/captainformal
	name = "captain's formal uniform"
	desc = "A captain's formal-wear, for special occasions."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain_formal"
	item_state = "captain_formal"
	worn_state = "captain_formal"
	contained_sprite = TRUE

/obj/item/clothing/suit/captunic
	name = "captain's parade jacket"
	desc = "Worn by a Captain to show their class."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain_formal_jacket"
	item_state = "captain_formal_jacket"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/shoes/captain/formal
	name = "captain's formal boots"
	desc = "Polished boots made of strong synthleather, capable of kicking through a wall without a scratch."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain_formal_boots"
	item_state = "captain_formal_boots"
	contained_sprite = TRUE

/obj/item/storage/briefcase/nt/captain_formal
	name = "captain formal uniform briefcase"
	desc = "An NT-branded briefcase containing various pieces of the captain's formal uniform, for use to style on the peasantry."
	starts_with = list(
		/obj/item/clothing/under/captainformal = 1,
		/obj/item/clothing/suit/captunic = 1,
		/obj/item/clothing/shoes/captain/formal = 1
	)

/obj/item/clothing/under/scc_captain
	name = "captain's jumpsuit"
	desc = "It's a blue jumpsuit with some gold markings denoting the rank of \"Captain\"."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "captain"
	item_state = "captain"
	contained_sprite = TRUE
