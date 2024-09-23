/datum/map_template/ruin/exoplanet/moghes_wasteland_tomb
	name = "Wasteland Tomb"
	id = "moghes_wasteland_tomb"
	description = "An ancient Unathi ancestral tomb, now lost to the Wasteland."
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_wasteland_tomb.dmm"
	unit_test_groups = list(2)

/area/moghes_wasteland_tomb
	name = "Wasteland Tomb"
	icon_state = "bluenew"
	requires_power = FALSE
	ambience = AMBIENCE_RUINS
	dynamic_lighting = TRUE
	no_light_control = FALSE
	is_outside = OUTSIDE_NO
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	base_turf = /turf/simulated/floor/exoplanet/desert
	area_blurb = "This ancient place is quiet and still, dust hanging in the air between intricately carved sandstone walls. You feel that you are one of the first people to set foot here in a very, very long time."

/obj/effect/landmark/corpse/ancient_unathi
	name = "Ancient Unathi"
	corpseuniform = /obj/item/clothing/under/unathi/ancient
	corpsesuit = /obj/item/clothing/suit/armor/unathi/ancient
	corpseshoes = /obj/item/clothing/shoes/ancient_unathi
	corpsehelmet = /obj/item/clothing/head/helmet/unathi/ancient
	corpsebelt = /obj/item/material/scythe/sickle/warsickle/bronze
	corpseid = FALSE
	species = SPECIES_UNATHI

/obj/effect/landmark/corpse/ancient_unathi/do_extra_customization(var/mob/living/carbon/human/M)
	M.ChangeToSkeleton()

/obj/effect/landmark/corpse/ancient_unathi/ruler
	name = "Ancient Unathi Ruler"
	corpseuniform = /obj/item/clothing/under/unathi/ancient/robes
	corpsebelt = /obj/item/material/sword/longsword
	corpsesuit = /obj/item/clothing/suit/armor/unathi/ancient //ideally get some medieval drip for this dude
	corpsehelmet = /obj/item/clothing/head/unathi/ancienthood/crown

/obj/structure/monolith/unathitomb
	name = "ancient monolith"
	desc = "An ancient monolith, with carvings in what looks like Sinta'Azaziba."
	color = "#99957d"

/obj/structure/monolith/unathitomb/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	if(GLOB.all_languages[LANGUAGE_AZAZIBA] in user.languages)
		to_chat(user, SPAN_NOTICE("The monolith tells of the rise of an ancient kingdom, in the years before the First Hegemony. Once, they ruled these lands with justice and fairness, and times were prosperous."))

/obj/structure/monolith/unathitomb/lineage
/obj/structure/monolith/unathitomb/lineage/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	if(GLOB.all_languages[LANGUAGE_AZAZIBA] in user.languages)
		to_chat(user, SPAN_NOTICE("The monolith lists the names of the kingdom's ruling clan, the Vhrakis, and the year and manner of their death. It dates for centuries, but most of the more recent entries are related to war, plague and famine."))

/obj/structure/monolith/unathitomb/death
/obj/structure/monolith/unathitomb/death/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	if(GLOB.all_languages[LANGUAGE_AZAZIBA] in user.languages)
		to_chat(user, SPAN_NOTICE("This monolith tells of a great plague which ravaged the Vhrakis Kingdom, and led to its enemies falling upon it with sword. The last King Vhrakis, seeing his homeland fall and his clan slaughtered, chose to end his own life with honor within the tomb of his ancestors."))

/obj/structure/monolith/unathitomb/king
/obj/structure/monolith/unathitomb/king/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	if(GLOB.all_languages[LANGUAGE_AZAZIBA] in user.languages)
		to_chat(user, SPAN_NOTICE("The monolith is written in a different claw to the others. It reads \"With me dies the line of Vhrakis, at last conquered by death. To you Sinta of the future, who know not famine or war, I ask only that our name is remembered, and that my bones are left in peace. Should you violate this, may the spirits of my clan and kingdom bring vengeance upon you.\""))
