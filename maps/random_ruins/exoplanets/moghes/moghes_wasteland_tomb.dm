/datum/map_template/ruin/exoplanet/moghes_wasteland_tomb
	name = "Wasteland Tomb"
	id = "moghes_wasteland_tomb"
	description = "An ancient Unathi ancestral tomb, now lost to the Wasteland."
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	suffixes = list("moghes/moghes_wasteland_tomb.dmm")

/area/moghes_wasteland_tomb
	name = "Wasteland Tomb"
	icon_state = "bluenew"
	requires_power = FALSE
	ambience = AMBIENCE_RUINS
	dynamic_lighting = TRUE
	no_light_control = FALSE
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

/obj/structure/monolith/unathitomb/examine(mob/user)
	. = ..()
	if(GLOB.all_languages[LANGUAGE_AZAZIBA] in user.languages)
		to_chat(user, SPAN_NOTICE("The monolith tells of the rise of an ancient kingdom, in the years before the First Hegemony. Once, they ruled these lands with justice and fairness, and times were prosperous."))

/obj/structure/monolith/unathitomb/lineage
/obj/structure/monolith/unathitomb/lineage/examine(mob/user)
	. = ..()
	if(GLOB.all_languages[LANGUAGE_AZAZIBA] in user.languages)
		to_chat(user, SPAN_NOTICE("The monolith lists the names of the kingdom's ruling clan, the Vhrakis, and the year and manner of their death. It dates for centuries, but most of the more recent entries are related to war, plague and famine."))

/obj/structure/monolith/unathitomb/death
/obj/structure/monolith/unathitomb/death/examine(mob/user)
	. = ..()
	if(GLOB.all_languages[LANGUAGE_AZAZIBA] in user.languages)
		to_chat(user, SPAN_NOTICE("This monolith tells of a great plague which ravaged the Vhrakis Kingdom, and led to its enemies falling upon it with sword. The last King Vhrakis, seeing his homeland fall and his clan slaughtered, chose to end his own life with honor within the tomb of his ancestors."))

/obj/structure/monolith/unathitomb/king
/obj/structure/monolith/unathitomb/king/examine(mob/user)
	. = ..()
	if(GLOB.all_languages[LANGUAGE_AZAZIBA] in user.languages)
		to_chat(user, SPAN_NOTICE("The monolith is written in a different claw to the others. It reads \"With me dies the line of Vhrakis, at last conquered by death. To you Sinta of the future, who know not famine or war, I ask only that our name is remembered, and that my bones are left in peace. Should you violate this, may the spirits of my clan and kingdom bring vengeance upon you.\""))

/obj/structure/unathi_pillar
	name = "pillar"
	desc = "An ancient and weathered sandstone pillar. It is covered in what looks like Unathi runes."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "pillar"
	anchored = TRUE
	density = TRUE
	can_be_unanchored = FALSE

/obj/structure/unathi_statue
	name = "ancient statue"
	desc = "An ancient and crumbling sandstone statue of an Unathi."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "statue"
	anchored = TRUE
	density = TRUE

/obj/structure/unathi_statue/warrior
	name = "warrior statue"
	desc = "An ancient and crumbling sandstone statue of an Unathi. This one is armored, and wields a war scythe."
	icon_state = "warriorstatue_left"

/obj/structure/unathi_statue/warrior/right
	icon_state = "warriorstatue_right"

/obj/structure/unathi_statue/crown
	name = "crowned statue"
	desc = "An ancient and crumbling sandstone statue of an Unathi. This one is robed, and wears a crown upon its head."
	icon_state = "crownstatue"

/obj/structure/unathi_statue/robe
	name = "robed statue"
	desc = "An ancient and crumbling sandstone statue of an Unathi. This one is clad in a humble robe and hood, and bears no weapons."
	icon_state = "robestatue"

//flags & tapestries
/obj/item/flag/unathi_tapestry
	name = "folded tapestry"
	desc = "An ancient piece of woven cloth, carefully folded."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "tapestry_folded"
	flag_structure = /obj/structure/sign/flag/unathi_tapestry

/obj/structure/sign/flag/unathi_tapestry
	name = "sun tapestry"
	desc = "A worn and faded tapestry depicting a bright sun shining down on the surface of Moghes."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "sun"
	flag_path = "sun"
	flag_item = /obj/item/flag/unathi_tapestry

/obj/item/flag/unathi_tapestry/moon
	flag_structure = /obj/structure/sign/flag/unathi_tapestry/moon

/obj/structure/sign/flag/unathi_tapestry/moon
	name = "moon tapestry"
	desc = "A worn and faded tapestry depicting a crescent moon."
	icon_state = "moon"
	flag_path = "moon"
	flag_item = /obj/item/flag/unathi_tapestry/moon

/obj/item/flag/unathi_tapestry/crown
	flag_structure = /obj/structure/sign/flag/unathi_tapestry/crown

/obj/structure/sign/flag/unathi_tapestry/crown
	name = "crown tapestry"
	desc = "A worn and faded tapestry depicting an Unathi figure, with a crown being lowered onto their head."
	icon_state = "crown"
	flag_path = "crown"
	flag_item = /obj/item/flag/unathi_tapestry/crown

/obj/item/flag/unathi_tapestry/warrior
	flag_structure = /obj/structure/sign/flag/unathi_tapestry/warrior

/obj/structure/sign/flag/unathi_tapestry/warrior
	name = "warrior tapestry"
	desc = "A worn and faded tapestry depicting an Unathi figure in full battle armor."
	icon_state = "warrior"
	flag_path = "warrior"
	flag_item = /obj/item/flag/unathi_tapestry/warrior

/obj/item/flag/unathi_tapestry/brothers
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/unathi_tapestry/brothers

/obj/structure/sign/flag/unathi_tapestry/brothers
	name = "brothers tapestry"
	desc = "A large and faded tapestry depicting two Unathi wielding war scythes, standing back to back."
	icon_state = "brothers_l"
	flag_path = "brothers"
	flag_size = TRUE
	flag_item = /obj/item/flag/unathi_tapestry/brothers

/obj/structure/sign/flag/unathi_tapestry/brothers/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/unathi_tapestry/brothers/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/unathi_tapestry/brothers/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/unathi_tapestry/brothers/west/Initialize(mapload)
	. = ..(mapload, WEST)

/obj/item/flag/unathi_tapestry/city
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/unathi_tapestry/city

/obj/structure/sign/flag/unathi_tapestry/city
	name = "city tapestry"
	desc = "A large and faded tapestry depicting an ancient city, towering resplendent over the land."
	icon_state = "city_l"
	flag_path = "city"
	flag_size = TRUE
	flag_item = /obj/item/flag/unathi_tapestry/city

/obj/structure/sign/flag/unathi_tapestry/city/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/unathi_tapestry/city/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/unathi_tapestry/city/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/unathi_tapestry/city/west/Initialize(mapload)
	. = ..(mapload, WEST)

/obj/item/flag/unathi_tapestry/wall
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/unathi_tapestry/wall

/obj/structure/sign/flag/unathi_tapestry/wall
	name = "wall tapestry"
	desc = "A large and faded tapestry depicting a mighty wall, staffed by hundreds of warriors. Storm clouds gather above it."
	icon_state = "wall_l"
	flag_path = "wall"
	flag_size = TRUE
	flag_item = /obj/item/flag/unathi_tapestry/wall

/obj/structure/sign/flag/unathi_tapestry/wall/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/unathi_tapestry/wall/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/unathi_tapestry/wall/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/unathi_tapestry/wall/west/Initialize(mapload)
	. = ..(mapload, WEST)

/obj/item/flag/unathi_tapestry/unathi
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/unathi_tapestry/unathi

/obj/structure/sign/flag/unathi_tapestry/unathi
	name = "unathi tapestry"
	desc = "A large and faded tapestry depicting a single Unathi figure - regal, resplendent, and utterly alone.."
	icon_state = "unathi_l"
	flag_path = "unathi"
	flag_size = TRUE
	flag_item = /obj/item/flag/unathi_tapestry/unathi

/obj/structure/sign/flag/unathi_tapestry/unathi/north/Initialize(mapload)
	. = ..(mapload, NORTH)

/obj/structure/sign/flag/unathi_tapestry/unathi/south/Initialize(mapload)
	. = ..(mapload, SOUTH)

/obj/structure/sign/flag/unathi_tapestry/unathi/east/Initialize(mapload)
	. = ..(mapload, EAST)

/obj/structure/sign/flag/unathi_tapestry/unathi/west/Initialize(mapload)
	. = ..(mapload, WEST)
