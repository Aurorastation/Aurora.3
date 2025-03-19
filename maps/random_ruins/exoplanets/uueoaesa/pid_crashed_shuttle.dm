/datum/map_template/ruin/exoplanet/pid_crashed_shuttle
	name = "Crashed Hegemony Shuttle"
	id = "pid-crashed_shuttle"
	description = "A crashed Hegemony shuttle on the moon Pid, filled with k'ois spores."
	sectors = list(SECTOR_UUEOAESA)
	prefix = "uueoaesa/"
	suffix = "pid_crashed_shuttle.dmm"
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED

	unit_test_groups = list(2)

/obj/effect/landmark/corpse/hegemony_shuttle
	name = "Hegemony Shuttle Pilot"
	corpseuniform = /obj/item/clothing/under/unathi/izweski
	corpsesuit = /obj/item/clothing/suit/space/void/hegemony
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/hegemony
	corpseshoes = /obj/item/clothing/shoes/magboots/hegemony
	corpsebelt = /obj/item/gun/energy/pistol/hegemony
	corpseid = FALSE
	species = SPECIES_UNATHI

/obj/effect/landmark/corpse/hegemony_shuttle/do_extra_customization(var/mob/living/carbon/human/M)
	M.change_hair_color(140, 134, 105)
	var/cadaver_color = pick("green", "red", "black")
	switch(cadaver_color)
		if("green")
			M.change_skin_color(27, 50, 27)
		if("red")
			M.change_skin_color(128, 62, 62)
		if("black")
			M.change_skin_color(28, 28, 28)

/obj/item/paper/fluff/pid_shuttle
	language = LANGUAGE_UNATHI

/obj/item/paper/fluff/pid_shuttle/entry1
	name = "pilot's log #1"
	info = "Those Izharshan scum blew out our thrusters. We've been leaking CO2 halfway across the system, and our distress beacon's not responding. I'm going to put us down on Pid. It's a long shot, but I know those Vaurca have been setting something up there. Maybe we can contact them. It'll be a rough landing, though. Spirits guide us."

/obj/item/paper/fluff/pid_shuttle/entry2
	name = "pilot's log #2"
	info = "Sk'akh be praised, we made it down in one piece. Atmosphere isn't breathable, but it's stable. No response on radio so far from the xsain. Kssighriss thinks that we have enough supplies and air to last three days, four if we stretch it. Hopefully help is coming soon."

/obj/item/paper/fluff/pid_shuttle/entry3
	name = "pilot's log #3"
	info = "Day three. We're out of food. We've been searching the surface on foot, and the inflatables have kept our oxygen in, but so far no sign of anyone, or any Hegemony ships in range. Hegemon's head, at this rate I'd take the pirates. Better dying on Izharshan blades than asphyxiating on this cursed rock."

/obj/item/paper/fluff/pid_shuttle/entry4
	name = "pilot's log #4"
	info = "Day four. Vharek and I tried to clear out some of the rocks around the shuttle, and one fell on my leg. Didn't breach my suit, but the bone's definitely broken. Hurts just to sit here. Kssighriss thinks he's picked up some sort of signal, about twelve miles to the west. Maybe it's the xsain, but it's further than I can go, and further than our air will last if the others have to help me."

/obj/item/paper/fluff/pid_shuttle/entry5
	name = "pilot's log #5"
	info = "The others won't go without me, and they won't make it with me. Our air is running out too fast. Kssighriss, Vharek, Ikhla. When you find this, take the remaining supplies and go after the signal. Tell my clan that I chose to go to my death with honor, for all of our sakes. Three Heads guide you all, my friends."
