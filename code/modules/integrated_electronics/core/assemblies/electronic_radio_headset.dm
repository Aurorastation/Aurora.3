/*
 * Electronic Radio Headset
 * Real radio headset + internal integrated circuit assembly.
 */

/obj/item/radio/headset/circuitry
	name = "electronic radio headset"
	desc = "A radio headset modified to accept integrated circuitry. Takes encryption keys."
	icon = 'icons/obj/assemblies/wearable_electronic_setups.dmi'
	contained_sprite = TRUE
	icon_state = "headset"
	item_state = "headset"
	slot_flags = SLOT_EARS

	ks1type = null
	ks2type = null

	// Internal assembly that stores the actual circuits installed inside the host item.
	var/obj/item/electronic_assembly/clothing/small/circuit_assembly = null
	// Built-in action circuit used to expose an activation button to the wearer/user.
	var/obj/item/integrated_circuit/built_in/action_button/circuit_action = null


/// Initializes runtime state after the parent type is constructed.
/obj/item/radio/headset/circuitry/Initialize()
	. = ..()
	setup_headset_integrated_circuit()
	refresh_headset_sprite()
	refresh_radio_state()


/// Releases owned objects and clears references before parent deletion runs.
/obj/item/radio/headset/circuitry/Destroy()
	QDEL_NULL(circuit_assembly)
	circuit_action = null
	return ..()


/// Creates or repairs the headset's internal circuit assembly and required built-in action circuit.
/obj/item/radio/headset/circuitry/proc/setup_headset_integrated_circuit()
	if(circuit_assembly)
		circuit_assembly.forceMove(src)
		circuit_assembly.clothing = src
		circuit_assembly.name = name
	else
		circuit_assembly = new /obj/item/electronic_assembly/clothing/small(src, TRUE)
		circuit_assembly.clothing = src
		circuit_assembly.name = name

	QDEL_NULL(circuit_assembly.battery)

	for(var/obj/item/integrated_circuit/C in circuit_assembly.contents)
		C.assembly = circuit_assembly

	circuit_action = locate(/obj/item/integrated_circuit/built_in/action_button) in circuit_assembly.contents

	if(!circuit_action)
		circuit_action = new(circuit_assembly)
		circuit_assembly.force_add_circuit(circuit_action)

	default_action_type = /datum/action/item_action/integrated_circuit
	action_button_name = "Activate [capitalize_first_letters(name)]"


/// Returns the assembly that should be used when this object is scanned or cloned.
/obj/item/radio/headset/circuitry/proc/get_cloneable_assembly()
	return circuit_assembly


/// Returns the host object path used when cloning this integrated item.
/obj/item/radio/headset/circuitry/proc/get_clone_host_type()
	return type

/// Adds modern examine/feedback hint lines for nearby users.
/obj/item/radio/headset/circuitry/feedback_hints(mob/user, distance, is_adjacent)
	. = ..()

	if(distance <= 1 && !circuit_assembly?.opened)
		return

	var/obj/item/electronic_assembly/E = get_cloneable_assembly()
	if(E)
		for(var/obj/item/integrated_circuit/IC in E.contents)
			. += SPAN_NOTICE("It contains \a [IC].")

/// Creates a host item and copies an integrated assembly into it.
/obj/item/radio/headset/circuitry/proc/clone_with_integrated_assembly(atom/location, obj/item/integrated_circuit_printer/printer, obj/item/electronic_assembly/source_assembly)
	if(!location || !printer || !source_assembly)
		return null

	var/obj/item/radio/headset/circuitry/new_headset = new type(location)

	if(!new_headset || !new_headset.circuit_assembly)
		if(new_headset)
			qdel(new_headset)
		return null

	var/obj/item/electronic_assembly/clothing/small/internal_assembly = new_headset.circuit_assembly

	if(!printer.copy_assembly_into_existing(source_assembly, internal_assembly))
		qdel(new_headset)
		return null

	internal_assembly.forceMove(new_headset)
	internal_assembly.clothing = new_headset
	internal_assembly.name = source_assembly.name
	internal_assembly.detail_color = source_assembly.detail_color
	internal_assembly.opened = FALSE
	internal_assembly.battery = null

	for(var/obj/item/integrated_circuit/C in internal_assembly.contents)
		C.assembly = internal_assembly

	new_headset.name = source_assembly.name
	new_headset.circuit_assembly = internal_assembly
	new_headset.circuit_action = locate(/obj/item/integrated_circuit/built_in/action_button) in internal_assembly.contents

	if(!new_headset.circuit_action)
		new_headset.circuit_action = new(internal_assembly)
		internal_assembly.force_add_circuit(new_headset.circuit_action)

	new_headset.default_action_type = /datum/action/item_action/integrated_circuit
	new_headset.action_button_name = "Activate [capitalize_first_letters(new_headset.name)]"

	new_headset.refresh_headset_sprite()
	new_headset.refresh_radio_state()

	return new_headset


/// Restores radio behavior after circuit, key, location, or equipment changes.
/obj/item/radio/headset/circuitry/proc/refresh_radio_state()
	on = TRUE
	set_frequency(PUB_FREQ)
	set_listening(TRUE)
	recalculateChannels(TRUE)

	if(ismob(loc))
		possibly_deactivate_in_loc()


/// Refreshes headset icon state and color overlays to match the internal assembly.
/obj/item/radio/headset/circuitry/proc/refresh_headset_sprite()
	icon = 'icons/obj/assemblies/wearable_electronic_setups.dmi'
	contained_sprite = TRUE
	icon_state = circuit_assembly?.opened ? "headset-open" : "headset"
	item_state = "headset"

	ClearOverlays()

	if(circuit_assembly?.detail_color)
		var/image/detail_overlay = image('icons/obj/assemblies/wearable_electronic_setups.dmi', "[icon_state]-color")
		detail_overlay.color = circuit_assembly.detail_color
		AddOverlays(detail_overlay)

	if(hascall(src, "update_clothing_icon"))
		call(src, "update_clothing_icon")()

/// Handles direct use in hand by a mob.
/obj/item/radio/headset/circuitry/attack_self(mob/user)
	return ..()


/// Handles another item being used on this object.
/obj/item/radio/headset/circuitry/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/integrated_circuit_printer))
		var/obj/item/integrated_circuit_printer/P = attacking_item
		if(P.scan_cloneable_item(src, user))
			return TRUE

	if(attacking_item.tool_behaviour == TOOL_CROWBAR && circuit_assembly)
		circuit_assembly.attackby(attacking_item, user)
		refresh_headset_sprite()
		refresh_radio_state()
		return TRUE

	if(istype(attacking_item, /obj/item/encryptionkey))
		. = ..()
		refresh_radio_state()
		return

	if(circuit_assembly?.opened)
		circuit_assembly.attackby(attacking_item, user)
		refresh_headset_sprite()
		return TRUE

	return ..()


/// Handles alternate-click interaction shortcuts.
/obj/item/radio/headset/circuitry/AltClick(mob/user)
	if(!circuit_assembly)
		return ..()

	if(!circuit_assembly.opened)
		to_chat(user, SPAN_WARNING("The circuit panel is closed."))
		return

	return circuit_assembly.attack_self(user)


/// Implements `access_integrated_circuit` behavior for this integrated electronics type.
/obj/item/radio/headset/circuitry/verb/access_integrated_circuit()
	set category = "Object.Equipped"
	set name = "Access Integrated Circuit"
	set src in usr

	if(!circuit_assembly)
		return

	if(!circuit_assembly.opened)
		to_chat(usr, SPAN_WARNING("The circuit panel is closed."))
		return

	circuit_assembly.attack_self(usr)


/// Runs when this item is equipped into an inventory slot.
/obj/item/radio/headset/circuitry/equipped(mob/user, slot)
	. = ..()

	if(slot == slot_l_ear || slot == slot_r_ear || slot == slot_l_ear_str || slot == slot_r_ear_str)
		refresh_radio_state()
		refresh_headset_sprite()


/// Runs when this item leaves an inventory slot or hand.
/obj/item/radio/headset/circuitry/dropped(mob/user)
	. = ..()
	set_listening(FALSE, actual_setting = FALSE)


/// Runs after this object changes location.
/obj/item/radio/headset/circuitry/Moved(atom/old_loc, forced)
	. = ..()
	possibly_deactivate_in_loc()


/// Adds worn overlays for this item when it appears on a human mob.
/obj/item/radio/headset/circuitry/build_additional_parts(mob/living/carbon/human/H, mob_icon, slot)
	// Stores `valid_slots` state used by this integrated electronics object.
	var/static/list/valid_slots

	if(!valid_slots)
		valid_slots = list(slot_l_ear_str, slot_r_ear_str)

	if(circuit_assembly?.detail_color && (slot in valid_slots))
		var/image/electronic_overlay = overlay_image(icon, "[item_state][slot_str_to_contained_flag(slot)]-color", circuit_assembly.detail_color, RESET_COLOR)
		return electronic_overlay

	return ..()


/// Returns the human currently wearing this item, if any.
/obj/item/radio/headset/circuitry/proc/get_wearer()
	if(!ishuman(loc))
		return null

	var/mob/living/carbon/human/H = loc

	if(H.l_ear == src)
		return H

	if(H.r_ear == src)
		return H

	return null


/// Sends private text output only to the wearer of the integrated headset.
/obj/item/radio/headset/circuitry/proc/private_output(message)
	// Stores `H` state used by this integrated electronics object.
	var/mob/living/carbon/human/H = get_wearer()

	if(!H)
		return

	to_chat(H, SPAN_NOTICE("[message]"))


/// Sends private TTS-style output only to the wearer of the integrated headset.
/obj/item/radio/headset/circuitry/proc/private_tts_output(message)
	// Stores `H` state used by this integrated electronics object.
	var/mob/living/carbon/human/H = get_wearer()

	if(!H)
		return

	to_chat(H, SPAN_NOTICE("\The [src] states, \"[message]\""))
