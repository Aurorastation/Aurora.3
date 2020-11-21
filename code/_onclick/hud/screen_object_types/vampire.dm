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
		var/datum/vampire/vampire = usr.mind.antag_datums[MODE_VAMPIRE]
		to_chat(usr, SPAN_NOTICE("You have [vampire.blood_usable]u of blood to use for vampiric powers."))
		to_chat(usr, SPAN_WARNING("If it drops too low, you will go into a blood frenzy. You can only store a maximum of [VAMPIRE_MAX_USABLE_BLOOD]u."))

/obj/screen/vampire/frenzy
	name = "frenzy count"
	icon_state = "frenzy"
	screen_loc = ui_alien_fire

/obj/screen/vampire/frenzy/Click(var/location, var/control, var/params)
	if(ishuman(usr))
		var/datum/vampire/vampire = usr.mind.antag_datums[MODE_VAMPIRE]
		to_chat(usr, SPAN_WARNING("Your frenzy counter is at [vampire.frenzy]."))
		to_chat(usr, SPAN_WARNING("If it raises too high, you will gain incredible power, but they will be very unsubtle. You can lower your frenzy counter by getting out of holy areas and by obtaining usable blood."))

/obj/screen/vampire/suck
	name = "blood_suck"
	icon_state = "suck"
	screen_loc = ui_suck

/obj/screen/vampire/suck/Click(var/location, var/control, var/params)
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.vampire_drain_blood()