/obj/item/device/cosmetic_surgery_kit
	name = "cosmetic surgery auto-kit"
	icon = 'icons/obj/item/autoimplanter.dmi'
	icon_state = "autoimplanter"
	item_state = "electronic"
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(
		TECH_ESOTERIC = 3,
		TECH_MAGNET = 4
	)

	/// Whether this cosmetic surgery kit is spent.
	var/used = FALSE


/obj/item/device/cosmetic_surgery_kit/attack_self(mob/living/carbon/human/user)
	if(used)
		to_chat(user, SPAN_WARNING("\The [src] remains lifeless, as its armatures dangle uselessly, now."))
		return
	if(!istype(user))
		return
	user.visible_message(
		SPAN_WARNING("\The [user] places \the [src] up to [user.get_pronoun("his")] face."),
		SPAN_WARNING("You place \the [src] up to your face."),
		range = 3
	)
	if(!do_after(user, 2 SECONDS))
		return
	user.visible_message(SPAN_DANGER("\The [src] purrs maliciously and unfurls its armatures with frightening speed!"), range = 3)
	playsound(user, 'sound/items/crank.ogg', 50, TRUE)
	user.visible_message(
		SPAN_DANGER("\The [src]'s armatures begin chipping away at \the [user]'s face!"),
		SPAN_DANGER("\The [src]'s armatures begin chipping away at your face!"),
		range = 3
	)
	user.custom_pain("Your face feels like it's being shredded apart!", 160)
	playsound(user, 'sound/effects/squelch1.ogg', 25, TRUE)
	if(!do_after(user, 2 SECONDS))
		return
	user.change_appearance(APPEARANCE_SURGERYKIT, user)
	used = TRUE
	var/response = tgui_input_text(user, "What would you like to call your new self?", "Name Change")
	response = sanitize(response, MAX_NAME_LEN)
	if(!response)
		return
	user.real_name = response
	user.name = response
	user.dna.real_name = response
	if(user.mind)
		user.mind.name = user.name
