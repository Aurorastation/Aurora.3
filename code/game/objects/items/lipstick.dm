/datum/lipstick_data
	/// the color of the lipstick
	var/color = "#FFF"
	/// the "variant" of the lipstick, this is equal to the sprite's name in the dmi
	var/variant = DEFAULT_LIPSTICK_VARIANT
	/// which types of species this type of lipstick can adapt to. uses the species shortname style used by contained sprites. make empty list to remove adaptation
	var/species_types = list("una", "taj")

/datum/lipstick_data/New(var/set_color, var/set_variant, var/set_species_types)
	. = ..()
	if(set_color)
		color = set_color
	if(set_variant)
		variant = set_variant
	if(set_species_types)
		species_types = set_species_types


/obj/item/lipstick
	gender = PLURAL
	name = "red lipstick"
	desc = "A generic brand of lipstick."
	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "lipstick"
	item_state = "lipstick"
	build_from_parts = TRUE
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_TINY
	slot_flags = SLOT_EARS
	update_icon_on_init = TRUE
	var/lipstick_color = "#DC253A"
	var/lipstick_variant = DEFAULT_LIPSTICK_VARIANT
	var/list/lipstick_options = list("Lips" = DEFAULT_LIPSTICK_VARIANT, "Lips (Side-shifted)" = LOWER_LIPSTICK_VARIANT)
	var/open = 0
	drop_sound = 'sound/items/drop/screwdriver.ogg'
	pickup_sound = 'sound/items/pickup/screwdriver.ogg'

/obj/item/lipstick/get_examine_text(mob/user, distance, is_adjacent, infix, suffix, get_extended)
	. = ..()
	. += "It's applying in the [SPAN_BOLD("[get_key_by_value(lipstick_options, lipstick_variant)]")] style."

/obj/item/lipstick/verb/select_lipstick_variant()
	set name = "Select Lipstick Variant"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr, USE_FORCE_SRC_IN_USER))
		return

	var/selected_lipstick_variant = tgui_input_list(usr, "What kind of lipstick application do you want?", "Select Lipstick Variant", lipstick_options)
	if(selected_lipstick_variant)
		lipstick_variant = lipstick_options[selected_lipstick_variant]
		to_chat(usr, SPAN_NOTICE("You change the lipstick application type to [SPAN_BOLD("[selected_lipstick_variant]")]."))

/obj/item/lipstick/update_icon()
	ClearOverlays()
	if(open)
		worn_overlay = "open_overlay"
		worn_overlay_color = lipstick_color
		icon_state = "[initial(icon_state)]_open"
		var/image/stick_overlay = image('icons/obj/cosmetics.dmi', null, "[initial(icon_state)]_open_overlay")
		stick_overlay.color = lipstick_color
		AddOverlays(stick_overlay)
	else
		icon_state = initial(icon_state)
		worn_overlay = initial(worn_overlay)

/obj/item/lipstick/purple
	name = "purple lipstick"
	lipstick_color = "#9471C9"

/obj/item/lipstick/jade
	name = "jade lipstick"
	lipstick_color = "#3EB776"

/obj/item/lipstick/black
	name = "black lipstick"
	lipstick_color = "#56352F"

/obj/item/lipstick/amberred
	name = "amberred lipstick"
	lipstick_color = "#BA2E2A"

/obj/item/lipstick/cherry
	name = "cherry lipstick"
	lipstick_color = "#BD1E35"

/obj/item/lipstick/orange
	name = "orange lipstick"
	lipstick_color = "#F75F51"

/obj/item/lipstick/gold
	name = "gold lipstick"
	lipstick_color = "#DA8118"

/obj/item/lipstick/deepred
	name = "deepred lipstick"
	lipstick_color = "#850A1C"

/obj/item/lipstick/pink
	name = "pink lipstick"
	lipstick_color = "#E84272"

/obj/item/lipstick/rosepink
	name = "rosepink lipstick"
	lipstick_color = "#E2A4B1"

/obj/item/lipstick/nude
	name = "nude lipstick"
	lipstick_color = "#E7A097"

/obj/item/lipstick/wine
	name = "wine lipstick"
	lipstick_color = "#D25674"

/obj/item/lipstick/peach
	name = "peach lipstick"
	lipstick_color = "#D05049"

/obj/item/lipstick/forestgreen
	name = "forestgreen lipstick"
	lipstick_color = "#82B33B"

/obj/item/lipstick/skyblue
	name = "skyblue lipstick"
	lipstick_color = "#60C2C5"

/obj/item/lipstick/teal
	name = "teal lipstick"
	lipstick_color = "#0A857C"

/obj/item/lipstick/custom
	name = "lipstick"

/obj/item/lipstick/random
	name = "lipstick"

/obj/item/lipstick/random/Initialize()
	var/list/lipstick_subtypes = subtypesof(/obj/item/lipstick) - /obj/item/lipstick/random
	var/obj/item/lipstick/chosen_lipstick = pick(lipstick_subtypes)
	name = initial(chosen_lipstick.name)
	lipstick_color = initial(chosen_lipstick.lipstick_color)
	return ..()


/obj/item/lipstick/attack_self(mob/user as mob)
	to_chat(user, SPAN_NOTICE("You twist \the [src] [open ? "closed" : "open"]."))
	open = !open
	update_icon()

/obj/item/lipstick/attack(mob/M as mob, mob/user as mob)
	if(!open)	return

	if(!istype(M, /mob))	return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.lipstick_data)	//if they already have lipstick on
			to_chat(user, SPAN_NOTICE("You need to wipe off the old lipstick first!"))
			return

		var/datum/lipstick_data/lipstick_data = new /datum/lipstick_data(lipstick_color, lipstick_variant)
		if(H == user)
			user.visible_message(SPAN_NOTICE("[user] does their lips with \the [src]."), SPAN_NOTICE("You take a moment to apply \the [src]. Perfect!"))
			H.lipstick_data = lipstick_data
			H.update_body()
		else
			user.visible_message(SPAN_WARNING("[user] begins to do [H]'s lips with \the [src]."), SPAN_NOTICE("You begin to apply \the [src]."))
			if(do_after(user, 4 SECONDS, H, do_flags = DO_DEFAULT & ~DO_SHOW_PROGRESS & ~DO_BOTH_CAN_TURN))
				user.visible_message(SPAN_NOTICE("[user] does [H]'s lips with \the [src]."), SPAN_NOTICE("You apply \the [src]."))
				H.lipstick_data = lipstick_data
				H.update_body()
	else
		to_chat(user, SPAN_NOTICE("Where are the lips on that?"))

//you can wipe off lipstick with paper! see code/modules/paperwork/paper.dm, paper/attack()
