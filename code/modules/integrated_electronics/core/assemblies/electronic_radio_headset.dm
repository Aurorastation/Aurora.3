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

	ks1type = /obj/item/encryptionkey/ship/common
	ks2type = null

	var/obj/item/electronic_assembly/clothing/small/circuit_assembly = null
	var/obj/item/integrated_circuit/built_in/action_button/circuit_action = null


/obj/item/radio/headset/circuitry/Initialize()
	. = ..()
	setup_headset_integrated_circuit()
	refresh_headset_sprite()
	refresh_radio_state()


/obj/item/radio/headset/circuitry/Destroy()
	QDEL_NULL(circuit_assembly)
	circuit_action = null
	return ..()


/obj/item/radio/headset/circuitry/proc/setup_headset_integrated_circuit()
	if(circuit_assembly)
		return

	circuit_assembly = new /obj/item/electronic_assembly/clothing/small(src)
	circuit_assembly.clothing = src
	circuit_assembly.name = name

	circuit_action = new(circuit_assembly)
	circuit_assembly.force_add_circuit(circuit_action)

	default_action_type = /datum/action/item_action/integrated_circuit
	action_button_name = "Activate [capitalize_first_letters(name)]"


/obj/item/radio/headset/circuitry/proc/refresh_radio_state()
	on = TRUE
	set_frequency(PUB_FREQ)
	set_listening(TRUE)
	recalculateChannels(TRUE)

	if(ismob(loc))
		possibly_deactivate_in_loc()


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


/obj/item/radio/headset/circuitry/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	if(circuit_assembly)
		examinate(user, circuit_assembly)

	return ..()


/obj/item/radio/headset/circuitry/attack_self(mob/user)
	return ..()


/obj/item/radio/headset/circuitry/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour == TOOL_CROWBAR && circuit_assembly)
		circuit_assembly.attackby(attacking_item, user)
		refresh_headset_sprite()
		refresh_radio_state()
		return

	if(istype(attacking_item, /obj/item/encryptionkey))
		. = ..()
		refresh_radio_state()
		return

	if(circuit_assembly?.opened)
		circuit_assembly.attackby(attacking_item, user)
		refresh_headset_sprite()
		return

	return ..()


/obj/item/radio/headset/circuitry/AltClick(mob/user)
	if(!circuit_assembly)
		return ..()

	if(!circuit_assembly.opened)
		to_chat(user, SPAN_WARNING("The circuit panel is closed."))
		return

	return circuit_assembly.attack_self(user)


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


/obj/item/radio/headset/circuitry/equipped(mob/user, slot)
	. = ..()

	if(slot == slot_l_ear || slot == slot_r_ear || slot == slot_l_ear_str || slot == slot_r_ear_str)
		refresh_radio_state()
		refresh_headset_sprite()


/obj/item/radio/headset/circuitry/dropped(mob/user)
	. = ..()
	set_listening(FALSE, actual_setting = FALSE)


/obj/item/radio/headset/circuitry/Moved(atom/old_loc, forced)
	. = ..()
	possibly_deactivate_in_loc()


/obj/item/radio/headset/circuitry/build_additional_parts(mob/living/carbon/human/H, mob_icon, slot)
	var/static/list/valid_slots

	if(!valid_slots)
		valid_slots = list(slot_l_ear_str, slot_r_ear_str)

	if(circuit_assembly?.detail_color && (slot in valid_slots))
		var/image/electronic_overlay = overlay_image(icon, "[item_state][slot_str_to_contained_flag(slot)]-color", circuit_assembly.detail_color, RESET_COLOR)
		return electronic_overlay

	return ..()


/obj/item/radio/headset/circuitry/proc/get_wearer()
	if(!ishuman(loc))
		return null

	var/mob/living/carbon/human/H = loc

	if(H.l_ear == src)
		return H

	if(H.r_ear == src)
		return H

	return null


/obj/item/radio/headset/circuitry/proc/private_output(message)
	var/mob/living/carbon/human/H = get_wearer()

	if(!H)
		return

	to_chat(H, SPAN_NOTICE("[message]"))


/obj/item/radio/headset/circuitry/proc/private_tts_output(message)
	var/mob/living/carbon/human/H = get_wearer()

	if(!H)
		return

	to_chat(H, SPAN_NOTICE("\The [src] states, \"[message]\""))


/obj/item/radio/headset/circuitry/proc/relay_radio_to_circuits(mob/living/speaker, message, channel, datum/language/speaking)
	/*
	 * Called by the radio receive/display path after this headset receives radio traffic.
	 * This forwards accepted radio traffic into installed microphone circuits.
	 */
	if(!circuit_assembly)
		return

	if(!get_wearer())
		return

	for(var/obj/item/integrated_circuit/input/microphone/MIC in circuit_assembly.contents)
		MIC.receive_radio_message(speaker, message, channel, speaking)


/obj/item/radio/headset/circuitry/proc/relay_radio_text_to_circuits(speaker_name, message, channel, language_name)
	/*
	 * Text-only fallback if the radio receive proc does not expose mob/language datums.
	 */
	if(!circuit_assembly)
		return

	if(!get_wearer())
		return

	for(var/obj/item/integrated_circuit/input/microphone/MIC in circuit_assembly.contents)
		MIC.receive_radio_text(speaker_name, message, channel, language_name)