/obj/structure/telegraphy
	name = "telegraphy"
	desc = "A machine used to relay messages to far away places."
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "telegraphy"
	anchored = TRUE
	density = TRUE
	var/list/diplo_options = list("Message the capital", "Make Annoucement", "Order artillery bombardment", "Cancel")
	var/in_cooldown = FALSE
	var/datum/announcement/priority/crew_announcement = new

/obj/structure/telegraphy/Initialize()
	. = ..()
	crew_announcement.newscast = 1


/obj/structure/telegraphy/attack_hand(var/mob/living/carbon/human/user as mob)
	if(!ishuman(user))
		return
	if(in_cooldown)
		return
	in_cooldown = TRUE
	var/choice = input("Choose an option.") as null|anything in diplo_options

	switch(choice)


		if("Message the capital")
			var/input = sanitize(input("Please choose a message to transmit to the [current_map.boss_name] using the telegraphy. Transmission does not guarantee a response. Be clear, full and concise.", "To abort, send an empty message.", "") as null|text)
			if(!input)
				in_cooldown = FALSE
				return
			Centcomm_announce(input, user)
			log_say("[key_name(user)] has made an IA [current_map.boss_short] announcement: [input]",ckey=key_name(usr))
			addtimer(CALLBACK(src, .proc/rearm), 1 MINUTE)

		if("Make Annoucement")
			var/input = input(usr, "Please write a message to announce to the fortress and village.", "Announcement") as null|text
			if(!input)
				in_cooldown = FALSE
				return
			to_chat(user, "<span class='Notice'>The Message has been sent.</span>")
			crew_announcement.Announce(input)
			addtimer(CALLBACK(src, .proc/rearm), 1 MINUTE)

		if("Order artillery bombardment")
			var/ix = text2num(input("X"))
			var/iy = text2num(input("Y"))
			if(!ix || !iy)
				return
				in_cooldown = FALSE

			var/turf/T = get_turf(locate(ix, iy, 3))

			if(T)
				command_announcement.Announce("All soldiers to their positions, the artillery is opening fire!", "Artillery Bombardment")
				to_world(sound('sound/effects/yamato_fire.ogg'))
				message_admins("[key_name_admin(user)] has launched an artillery strike.", 1)
				explosion(T,2,5,11)
				addtimer(CALLBACK(src, .proc/rearm), 10 MINUTE)
			else
				in_cooldown = FALSE

		else
			in_cooldown = FALSE
			return

/obj/structure/telegraphy/proc/rearm()
	in_cooldown = FALSE

/obj/structure/telegraphy/mayor
	diplo_options = list("Message the capital", "Make Annoucement", "Cancel")