/obj/item/device/megaphone
	name = "megaphone"
	desc = "Pretend to be a director for a brief moment before someone tackles you to make you shut up."
	desc_fluff = "Annoy your colleagues! Scare interns! Impress no one!"
	desc_info = "A device used to project your voice. Loudly."
	icon = 'icons/obj/contained_items/tools/megaphone.dmi'
	icon_state = "megaphone"
	item_state = "megaphone"
	contained_sprite = TRUE
	w_class = ITEMSIZE_SMALL
	flags = CONDUCT

	var/spamcheck = 0
	var/emagged = 0
	var/insults = 0
	var/list/insultmsg = list("FUCK EVERYONE!", "I'M A TATER!", "ALL SECURITY TO SHOOT ME ON SIGHT!", "I HAVE A BOMB!", "CAPTAIN IS A COMDOM!", "FOR THE SYNDICATE!")
	var/activation_sound = 'sound/items/megaphone.ogg'
	var/needs_user_location = TRUE

/obj/item/device/megaphone/attack_self(mob/living/user as mob)
	if(user.client)
		if(user.client.prefs.muted & MUTE_IC)
			to_chat(src, SPAN_WARNING("You cannot speak in IC (muted)."))
			return
	if(!ishuman(user))
		to_chat(user, SPAN_WARNING("You don't know how to use this!"))
		return
	if(user.silent)
		return
	if(spamcheck > world.time)
		to_chat(user, SPAN_WARNING("\The [src] needs to recharge!"))
		return

	var/message = sanitize(input(user, "Shout a message?", "Megaphone", null)  as text)
	if(!message)
		return
	message = capitalize(message)
	if ((user.stat == CONSCIOUS))
		if(needs_user_location)
			if(!src.loc == user)
				return
		if(emagged)
			if(insults)
				user.audible_message("<B>[user]</B> broadcasts, <FONT size=3>\"[pick(insultmsg)]\"</FONT>", "<B>[user]</B> speaks into \the [src].", 7)
				insults--
			else
				to_chat(user, SPAN_WARNING("*BZZZZzzzzzt*"))
		else
			user.audible_message("<B>[user]</B> broadcasts, <FONT size=3>\"[message]\"</FONT>", "<B>[user]</B> speaks into \the [src].", 7)
		if(activation_sound)
			playsound(loc, activation_sound, 100, 0, 1)
		for (var/mob/living/carbon/human/C in range(user, 2) - user)
			if (C in range(user, 1))
				C.earpain(3, TRUE, 2)
			else
				C.earpain(2, TRUE, 2)
		spamcheck = world.time + 50
		return

/obj/item/device/megaphone/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, SPAN_WARNING("You overload \the [src]'s voice synthesizer."))
		emagged = 1
		insults = rand(1, 3)//to prevent dickflooding
		return 1

/obj/item/device/megaphone/red
	name = "red megaphone"
	desc = "To make people do your bidding."
	desc_fluff = "It's in a menacing crimson red."
	icon_state = "megaphone_red"
	item_state = "megaphone_red"

/obj/item/device/megaphone/sec
	name = "security megaphone"
	desc = "To stop people from stepping over the police tape."
	desc_fluff = "Nothing to see here. Move along."
	icon_state = "megaphone_sec"
	item_state = "megaphone_sec"

/obj/item/device/megaphone/med
	name = "medical megaphone"
	desc = "To make people leave the ICU."
	desc_fluff = "Realistcally only used to startle the CMO's cat."
	icon_state = "megaphone_med"
	item_state = "megaphone_med"

/obj/item/device/megaphone/sci
	name = "science megaphone"
	desc = "To make people stand clear of the blast zone."
	desc_fluff = "Something to rival the explosions heard in the science department."
	icon_state = "megaphone_sci"
	item_state = "megaphone_sci"

/obj/item/device/megaphone/engi
	name = "engineering megaphone"
	desc = "To make people get out of construction sites."
	desc_fluff = "At home in construction sites and road works, it'll stick by you in diverting traffic and dim-witted coworkers."
	icon_state = "megaphone_engi"
	item_state = "megaphone_engi"

/obj/item/device/megaphone/cargo
	name = "operations megaphone"
	desc = "To make people to push crates."
	desc_fluff = "Only certified forklift operators will be able to handle the sheer power of this megaphone. Either that, or just be the Operations Manager."
	icon_state = "megaphone_cargo"
	item_state = "megaphone_cargo"

/obj/item/device/megaphone/command
	name = "command megaphone"
	desc = "To make people to get back to work."
	desc_fluff = "Exude authority by decree of having the louder voice."
	icon_state = "megaphone_command"
	item_state = "megaphone_command"

/obj/item/device/megaphone/clown
	name = "clown's megaphone"
	desc = "Something that should not exist."
	icon_state = "megaphone_clown"
	item_state = "megaphone_clown"

/obj/item/device/megaphone/stagemicrophone
	name = "dazzling stage microphone"
	desc = "A glamorous looking stage microphone, complete with running lights and holographic effects around it."
	icon_state = "stagemicrophone"
	item_state = "stagemicrophone"
