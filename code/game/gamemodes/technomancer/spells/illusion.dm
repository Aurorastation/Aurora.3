/datum/technomancer/spell/illusion
	name = "Illusion"
	desc = "Allows you to create and control a holographic illusion, that can take the form of most object or entities."
	enhancement_desc = "Illusions will be made of hard light, allowing the interception of attacks, appearing more realistic."
	cost = 25
	obj_path = /obj/item/spell/illusion
	ability_icon_state = "tech_illusion"
	category = UTILITY_SPELLS

/obj/item/spell/illusion
	name = "illusion"
	icon_state = "illusion"
	desc = "Now you can toy with the minds of the whole colony."
	aspect = ASPECT_LIGHT
	cast_methods = CAST_RANGED | CAST_USE
	var/atom/movable/copied = null
	var/mob/living/simple_animal/illusion/illusion = null

/obj/item/spell/illusion/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /atom/movable))
		var/atom/movable/AM = hit_atom
		if(pay_energy(100))
			copied = AM
			update_icon()
			to_chat(user, "<span class='notice'>You've copied \the [AM]'s appearance.</span>")
			sound_to(user, 'sound/weapons/flash.ogg')
			return 1
	else if(istype(hit_atom, /turf))
		var/turf/T = hit_atom
		if(!illusion)
			if(!copied)
				copied = user
			if(pay_energy(500))
				illusion = new(T)
				illusion.copy_appearance(copied)
				to_chat(user, "<span class='notice'>An illusion of \the [copied] is made on \the [T].</span>")
				sound_to(user, 'sound/effects/pop.ogg')
				return 1

/obj/item/spell/illusion/on_use_cast(mob/user)
	if(illusion)
		var/choice = alert(user, "Would you like to have \the [illusion] speak, or do an emote?", "Illusion", "Speak","Emote","Cancel")
		switch(choice)
			if("Cancel")
				return
			if("Speak")
				var/what_to_say = input(user, "What do you want \the [illusion] to say?","Illusion Speak") as null|text
				//what_to_say = sanitize(what_to_say) //Sanitize occurs inside say() already.
				if(what_to_say)
					illusion.say(what_to_say)
			if("Emote")
				var/what_to_emote = input(user, "What do you want \the [illusion] to do?","Illusion Emote") as null|text
				if(what_to_emote)
					illusion.emote(what_to_emote)

/obj/item/spell/illusion/Destroy()
	QDEL_NULL(illusion)
	copied = null
	return ..()

// Makes a tiny overlay of the thing the player has copied, so they can easily tell what they currently have.
/obj/item/spell/illusion/update_icon()
	overlays.Cut()
	if(copied)
		var/image/temp_image = image(copied)
		var/matrix/M = matrix()
		M.Scale(0.5, 0.5)
		temp_image.transform = M
//		temp_image.pixel_y = 8
		src.overlays.Add(temp_image)
