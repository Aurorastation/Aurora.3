/*
 * core/assemblies/clothing.dm
 * Wearable electronic assemblies that can be embedded into clothing-style items and driven through item actions.
 */


// The base subtype for assemblies that can be worn. Certain pieces will have more or less capabilities
// E.g. Glasses have less room than something worn over the chest.
// Note that the electronic assembly is INSIDE the object that actually gets worn, in a similar way to implants.

/obj/item/electronic_assembly/clothing
	name = "electronic clothing"
	// Stores `clothing_icon_state` state used by this integrated electronics object.
	var/clothing_icon_state = "circuitry" // Needs to match the clothing's base icon_state.
	desc = "A clothing-mounted case for integrated electronics."
	w_class = WEIGHT_CLASS_SMALL
	max_components = IC_COMPONENTS_BASE
	max_complexity = IC_COMPLEXITY_BASE
	// Stores `clothing` state used by this integrated electronics object.
	var/obj/item/clothing = null

/// Implements `ui_host` behavior for this integrated electronics type.
/obj/item/electronic_assembly/clothing/ui_host()
	return clothing

/// Implements `resolve_ui_host` behavior for this integrated electronics type.
/obj/item/electronic_assembly/clothing/resolve_ui_host()
	return clothing

/// Returns the current `assembly_holder` value or object used by this electronics code.
/obj/item/electronic_assembly/clothing/get_assembly_holder()
	return clothing

/// Updates icon state, overlays, and visual appearance.
/obj/item/electronic_assembly/clothing/update_icon()
	if(!clothing)
		return

	clothing.icon_state = opened ? "[initial(clothing.icon_state)]-open" : initial(clothing.icon_state)
	clothing.ClearOverlays()

	// Stores `detail_overlay` state used by this integrated electronics object.
	var/image/detail_overlay = image('icons/obj/assemblies/wearable_electronic_setups.dmi', "[clothing.icon_state]-color")
	detail_overlay.color = detail_color
	clothing.AddOverlays(detail_overlay)

	if(hascall(clothing, "update_clothing_icon"))
		call(clothing, "update_clothing_icon")()

// This is 'small' relative to the size of regular clothing assemblies.
/obj/item/electronic_assembly/clothing/small
	max_components = IC_COMPONENTS_BASE / 2
	max_complexity = IC_COMPLEXITY_BASE / 2
	w_class = WEIGHT_CLASS_TINY

// Ditto.
/obj/item/electronic_assembly/clothing/large
	max_components = IC_COMPONENTS_BASE * 2
	max_complexity = IC_COMPLEXITY_BASE * 2
	w_class = WEIGHT_CLASS_NORMAL

/// Implements `rename` behavior for this integrated electronics type.
/obj/item/electronic_assembly/clothing/rename()
	// Stores `input_name` state used by this integrated electronics object.
	var/input_name = ..()
	if(input_name)
		clothing.name = input_name

// This is defined higher up, in /clothing to avoid lots of copypasta.
/obj/item/clothing
	// Stores `IC` state used by this integrated electronics object.
	var/obj/item/electronic_assembly/clothing/IC = null
	// Stores `action_circuit` state used by this integrated electronics object.
	var/obj/item/integrated_circuit/built_in/action_button/action_circuit = null // This gets pulsed when someone clicks the button on the hud, OR when certain interactions are performed (such as clicking on something with gloves worn)

/// Adds examine text shown to nearby users.
/obj/item/clothing/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	if(IC)
		examinate(user, IC)
	. = ..()

/// Handles direct use in hand by a mob.
/obj/item/clothing/attack_self(mob/user)
	if(IC?.opened)
		IC.attack_self(user)
	else
		..()

// Does most of the repeatative setup.
/obj/item/clothing/proc/setup_integrated_circuit(new_type)
	// Set up the internal circuit holder.
	IC = new new_type(src)
	IC.clothing = src
	IC.name = name

	// Clothing assemblies can be triggered by clicking on the HUD. This allows that to occur.
	action_circuit = new(src.IC)
	IC.force_add_circuit(action_circuit)
	default_action_type = /datum/action/item_action/integrated_circuit
	action_button_name = "Activate [capitalize_first_letters(name)]"

	icon = 'icons/obj/assemblies/wearable_electronic_setups.dmi'
	contained_sprite = TRUE

// Specific subtypes.

// Jumpsuit.
/obj/item/clothing/under/circuitry
	name = "electronic jumpsuit"
	desc = "A wearable case for integrated electronics. This one is a black jumpsuit with wiring weaved into the fabric."
	icon = 'icons/obj/assemblies/wearable_electronic_setups.dmi'
	contained_sprite = TRUE
	icon_state = "jumpsuit"
	item_state = "jumpsuit"
	worn_state = "jumpsuit"

/// Initializes runtime state after the parent type is constructed.
/obj/item/clothing/under/circuitry/Initialize()
	setup_integrated_circuit(/obj/item/electronic_assembly/clothing)
	return ..()

/// Adds worn overlays for this item when it appears on a human mob.
/obj/item/clothing/under/circuitry/build_additional_parts(mob/living/carbon/human/H, mob_icon, slot)
	// Stores `valid_slots` state used by this integrated electronics object.
	var/static/list/valid_slots
	if(!valid_slots)
		valid_slots = list(slot_w_uniform_str)
	if(IC?.detail_color && (slot in valid_slots))
		var/image/electronic_overlay = overlay_image(icon, "[item_state][slot_str_to_contained_flag(slot)]-color", IC.detail_color, RESET_COLOR)
		return electronic_overlay
	return ..()

// Gloves.
/obj/item/clothing/gloves/circuitry
	name = "electronic gloves"
	desc = "A wearable case for integrated electronics. This one is a pair of black gloves, with wires woven into them. A small \
	device with a screen is attached to the left glove."
	icon = 'icons/obj/assemblies/wearable_electronic_setups.dmi'
	contained_sprite = TRUE
	icon_state = "gloves"
	item_state = "gloves"

/// Initializes runtime state after the parent type is constructed.
/obj/item/clothing/gloves/circuitry/Initialize()
	setup_integrated_circuit(/obj/item/electronic_assembly/clothing/small)
	return ..()

/// Adds worn overlays for this item when it appears on a human mob.
/obj/item/clothing/gloves/circuitry/build_additional_parts(mob/living/carbon/human/H, mob_icon, slot)
	// Stores `valid_slots` state used by this integrated electronics object.
	var/static/list/valid_slots
	if(!valid_slots)
		valid_slots = list(slot_gloves_str)
	if(IC?.detail_color && (slot in valid_slots))
		var/image/electronic_overlay = overlay_image(icon, "[item_state][slot_str_to_contained_flag(slot)]-color", IC.detail_color, RESET_COLOR)
		return electronic_overlay
	return ..()

/// Implements `Touch` behavior for this integrated electronics type.
/obj/item/clothing/gloves/circuitry/Touch(var/atom/A, var/mob/user, var/proximity)
	if(!A || !proximity)
		return 0

	if(istype(action_circuit) && action_circuit.check_power())
		action_circuit.set_pin_data(IC_OUTPUT, 1, A)
		action_circuit.push_data() // we have to not return 1 so we can still do normal stuff like picking things up, etc.
		action_circuit.activate_pin(1)
	return 0

// Glasses.
/obj/item/clothing/glasses/circuitry
	name = "electronic goggles"
	desc = "A wearable case for integrated electronics. This one is a pair of goggles, with wiring sticking out. \
	Could this augment your vision?" // Sadly it won't, or at least not yet.
	icon = 'icons/obj/assemblies/wearable_electronic_setups.dmi'
	contained_sprite = TRUE
	icon_state = "goggles"
	item_state = "goggles"

/// Initializes runtime state after the parent type is constructed.
/obj/item/clothing/glasses/circuitry/Initialize()
	setup_integrated_circuit(/obj/item/electronic_assembly/clothing/small)
	return ..()

/// Adds worn overlays for this item when it appears on a human mob.
/obj/item/clothing/glasses/circuitry/build_additional_parts(mob/living/carbon/human/H, mob_icon, slot)
	// Stores `valid_slots` state used by this integrated electronics object.
	var/static/list/valid_slots
	if(!valid_slots)
		valid_slots = list(slot_glasses_str, slot_l_hand_str, slot_r_hand_str)
	if(IC?.detail_color && (slot in valid_slots))
		var/image/electronic_overlay = overlay_image(icon, "[item_state][slot_str_to_contained_flag(slot)]-color", IC.detail_color, RESET_COLOR)
		return electronic_overlay
	return ..()

/// Handles direct use in hand by a mob.
/obj/item/clothing/glasses/circuitry/attack_self(mob/user)
	if(IC)
		return IC.attack_self(user)
	return ..()

/// Implements `Look` behavior for this integrated electronics type.
/obj/item/clothing/glasses/circuitry/Look(var/atom/A, mob/user, var/proximity)
	if(!A)
		return 0

	if(istype(action_circuit) && action_circuit.check_power())
		action_circuit.set_pin_data(IC_OUTPUT, 1, A)
		action_circuit.push_data() // we have to not return 1 so we can still do normal stuff like picking things up, etc.
		action_circuit.activate_pin(1)
	return 0

// Shoes
/obj/item/clothing/shoes/circuitry
	name = "electronic boots"
	desc = "A wearable case for integrated electronics. This one is a pair of boots, with wires attached to a small \
	cover."
	icon = 'icons/obj/assemblies/wearable_electronic_setups.dmi'
	contained_sprite = TRUE
	icon_state = "shoes"
	item_state = "shoes"

/// Initializes runtime state after the parent type is constructed.
/obj/item/clothing/shoes/circuitry/Initialize()
	setup_integrated_circuit(/obj/item/electronic_assembly/clothing/small)
	return ..()

/// Adds worn overlays for this item when it appears on a human mob.
/obj/item/clothing/shoes/circuitry/build_additional_parts(mob/living/carbon/human/H, mob_icon, slot)
	// Stores `valid_slots` state used by this integrated electronics object.
	var/static/list/valid_slots
	if(!valid_slots)
		valid_slots = list(slot_shoes_str)
	if(IC?.detail_color && (slot in valid_slots))
		var/image/electronic_overlay = overlay_image(icon, "[item_state][slot_str_to_contained_flag(slot)]-color", IC.detail_color, RESET_COLOR)
		return electronic_overlay
	return ..()

// Head
/obj/item/clothing/head/circuitry
	name = "electronic headwear"
	desc = "A wearable case for integrated electronics. This one appears to be a very technical-looking piece that \
	goes around the collar, with a heads-up-display attached on the right."
	icon = 'icons/obj/assemblies/wearable_electronic_setups.dmi'
	contained_sprite = TRUE
	icon_state = "head"
	item_state = "head"

/// Initializes runtime state after the parent type is constructed.
/obj/item/clothing/head/circuitry/Initialize()
	setup_integrated_circuit(/obj/item/electronic_assembly/clothing/small)
	return ..()

/// Adds worn overlays for this item when it appears on a human mob.
/obj/item/clothing/head/circuitry/build_additional_parts(mob/living/carbon/human/H, mob_icon, slot)
	// Stores `valid_slots` state used by this integrated electronics object.
	var/static/list/valid_slots
	if(!valid_slots)
		valid_slots = list(slot_head_str)
	if(IC?.detail_color && (slot in valid_slots))
		var/image/electronic_overlay = overlay_image(icon, "[item_state][slot_str_to_contained_flag(slot)]-color", IC.detail_color, RESET_COLOR)
		return electronic_overlay
	return ..()

// Ears
/obj/item/clothing/ears/circuitry
	name = "electronic earwear"
	desc = "A wearable case for integrated electronics. This one appears to be a technical-looking headset."
	icon = 'icons/obj/assemblies/wearable_electronic_setups.dmi'
	contained_sprite = TRUE
	icon_state = "headset"
	item_state = "headset"

/// Initializes runtime state after the parent type is constructed.
/obj/item/clothing/ears/circuitry/Initialize()
	setup_integrated_circuit(/obj/item/electronic_assembly/clothing/small)
	return ..()

/// Adds worn overlays for this item when it appears on a human mob.
/obj/item/clothing/ears/circuitry/build_additional_parts(mob/living/carbon/human/H, mob_icon, slot)
	// Stores `valid_slots` state used by this integrated electronics object.
	var/static/list/valid_slots
	if(!valid_slots)
		valid_slots = list(slot_l_ear_str, slot_r_ear_str)
	if(IC?.detail_color && (slot in valid_slots))
		var/image/electronic_overlay = overlay_image(icon, "[item_state][slot_str_to_contained_flag(slot)]-color", IC.detail_color, RESET_COLOR)
		return electronic_overlay
	return ..()

// Exo-slot
/obj/item/clothing/suit/circuitry
	name = "electronic chestpiece"
	desc = "A wearable case for integrated electronics. This one appears to be a very technical-looking vest, that \
	almost looks professionally made, however the wiring popping out betrays that idea."
	icon = 'icons/obj/assemblies/wearable_electronic_setups.dmi'
	contained_sprite = TRUE
	icon_state = "chest"
	item_state = "chest"

/// Initializes runtime state after the parent type is constructed.
/obj/item/clothing/suit/circuitry/Initialize()
	setup_integrated_circuit(/obj/item/electronic_assembly/clothing/large)
	return ..()

/// Adds worn overlays for this item when it appears on a human mob.
/obj/item/clothing/suit/circuitry/build_additional_parts(mob/living/carbon/human/H, mob_icon, slot)
	// Stores `valid_slots` state used by this integrated electronics object.
	var/static/list/valid_slots
	if(!valid_slots)
		valid_slots = list(slot_wear_suit_str)
	if(IC?.detail_color && (slot in valid_slots))
		var/image/electronic_overlay = overlay_image(icon, "[item_state][slot_str_to_contained_flag(slot)]-color", IC.detail_color, RESET_COLOR)
		return electronic_overlay
	return ..()
