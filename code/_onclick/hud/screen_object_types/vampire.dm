/obj/screen/vampire
	icon = 'icons/mob/screen/vampire.dmi'
	maptext_x = 5
	maptext_y = 16

/obj/screen/vampire/blood
	name = "usable blood"
	icon_state = "blood"
	screen_loc = ui_alien_toxin

/obj/screen/vampire/blood/Click(var/location, var/control, var/params)
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(H.mind.vampire)
			to_chat(H, SPAN_NOTICE("You have [H.mind.vampire.blood_usable]u of blood to use for vampiric powers."))
			to_chat(H, SPAN_WARNING("If it drops too low, you will go into a blood frenzy. You can only store a maximum of 950u."))

/obj/screen/vampire/frenzy
	name = "frenzy count"
	icon_state = "frenzy"
	screen_loc = ui_alien_fire

/obj/screen/vampire/frenzy/Click(var/location, var/control, var/params)
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(H.mind.vampire)
			to_chat(H, SPAN_WARNING("Your frenzy counter is at [H.mind.vampire.frenzy]."))
			to_chat(H, SPAN_WARNING("If it raises too high, you will gain incredible power, but they will be very unsubtle. You can lower your frenzy counter by getting out of holy areas and by obtaining usable blood."))