
/datum/ghostspawner/human/izweski
	short_name = "heg_crew"
	name = "Hegemony Navy Crewman"
	desc = "You are a sworn warrior of the Izweski Hegemony Navy, your life and honor pledged to Hegemon Not'zar. Abide by the Warrior's Code, and follow the orders of your superior officers. Remember, you serve the Izweski Hegemony."
	tags = list("External")
	spawnpoints = list("hegemony_crew")
	req_perms = null
	max_count = 2
	uses_species_whitelist = FALSE
	mob_name_pick_message = "Pick an Unathi name."
	welcome_message = "As an Unathi warrior, abide by the Warrior's Code - act with righteousness, mercy, integrity, courage and loyalty. Defend the life and honor of Hegemony citizens, and ensure that enemies of the Izweski cannot threaten your vessel."

	outfit = /obj/outfit/admin/izweski
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Izweski Navy Crewman"
	special_role = "Izweski Navy Crewman"
	respawn_flag = null
	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	away_site = TRUE

/datum/ghostspawner/human/izweski/klax
	short_name = "heg_crew_klax"
	name = "Hegemony K'laxan Auxiliary"
	desc = "You are a Warrior of the Hive K'lax, assigned to serve with the Izweski Hegemony Navy. Follow the orders of your superiors, and act to ensure the Hegemony's victory over its enemies."
	max_count = 1
	uses_species_whitelist = TRUE
	outfit = /obj/outfit/admin/izweski/klax
	spawnpoints = list("hegemony_klax")
	possible_species = list(SPECIES_VAURCA_WARRIOR)
	extra_languages = list(LANGUAGE_VAURCA)
	welcome_message = "As a K'laxan auxiliary, you are fundamentally an outsider to the ship and the crew you have been assigned to. Attempt to act according to Unathi codes of honor, even if you do not fully understand them yourself."

/datum/ghostspawner/human/izweski/captain
	short_name = "heg_cap"
	name = "Hegemony Navy Captain"
	desc = "You are an officer in the Izweski Hegemony Navy, your life and honor pledged to Hegemon Not'zar. Abide by the Warrior's Code, and lead your crew with honor. Remember, you serve the Izweski Hegemony."
	max_count = 1
	uses_species_whitelist = TRUE
	outfit = /obj/outfit/admin/izweski/captain
	assigned_role = "Izweski Navy Captain"
	special_role = "Izweski Navy Captain"
	welcome_message = "As an Unathi warrior, abide by the Warrior's Code - act with righteousness, mercy, integrity, courage and loyalty. Your duty is to protect the Hegemony, your ship, and the warriors under your command - and to lead them to triumph over whatever foes you may face."

	spawnpoints = list("hegemony_cap")

/datum/ghostspawner/human/izweski/specialist
	short_name = "heg_spec"
	name = "Hegemony Navy Specialist"
	desc = "You are a specialist in the Izweski Hegemony Navy, your life and honor pledged to Hegemon Not'zar. Act as the right hand of your captain, and always abide by the Warrior's Code. Remember, you serve the Izweski Hegemony."
	max_count = 1
	assigned_role = "Izweski Navy Specialist"
	special_role = "Izweski Navy Specialist"

/datum/ghostspawner/human/izweski/warpriest
	short_name = "heg_pri"
	name = "Hegemony Navy Warpriest"
	desc = "You are a Sk'akh Priest of the Warrior, serving as an officer  with the Izweski Hegemony Navy. Ensure that the warriors on your vessel abide by the Warrior's Code, and call upon Sk'akh's name to bless your crew against harm. Remember, you serve the Izweski Hegemony."
	max_count = 1
	uses_species_whitelist = TRUE
	assigned_role = "Izweski Navy Warpriest"
	special_role = "Izweski Navy Warpriest"
	outfit = /obj/outfit/admin/izweski/priest
	spawnpoints = list("hegemony_warpriest")
	welcome_message = "As a Priest of the Aspect, you are sworn more than any others to embody the honor of the Warrior, and to live by the Warrior's Code - to act with righteousness, mercy, integrity, courage and loyalty. Ensure that your crew does the same, \
	and guide their souls towards te glory befitting true warriors. However, you are still a soldier, and should follow your captain's orders."

/obj/outfit/admin/izweski
	name = "Izweski Crewman"

	uniform = /obj/item/clothing/under/unathi/izweski
	belt = /obj/item/melee/energy/sword/hegemony
	shoes = /obj/item/clothing/shoes/sandals/caligae
	id = /obj/item/card/id/distress/kataphract
	back = /obj/item/storage/backpack/satchel/hegemony


	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/box/donkpockets = 1
	)

/obj/outfit/admin/izweski/get_id_access()
	return list(ACCESS_KATAPHRACT, ACCESS_EXTERNAL_AIRLOCKS)

/obj/outfit/admin/izweski/klax

	uniform = /obj/item/clothing/under/unathi/izweski
	mask = /obj/item/clothing/mask/gas/vaurca/filter
	belt = /obj/item/melee/energy/sword/hegemony
	shoes = /obj/item/clothing/shoes/vaurca
	id = /obj/item/card/id/distress/kataphract
	back = /obj/item/storage/backpack/satchel/hegemony

	l_hand = /obj/item/martial_manual/vaurca


	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/koisbar_clean = 3
	)

/obj/outfit/admin/izweski/klax/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.wear_mask && H.species.has_organ[BP_PHORON_RESERVE])
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"

	var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
	var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
	A.replaced(H, affected)
	H.update_body()

/obj/outfit/admin/izweski/captain
	name = "Hegemony Navy Captain"
	uniform = /obj/item/clothing/under/unathi/izweski/officer

/obj/outfit/admin/izweski/captain/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)

/obj/outfit/admin/izweski/captain/get_id_access()
	return list(ACCESS_KATAPHRACT, ACCESS_KATAPHRACT_KNIGHT, ACCESS_EXTERNAL_AIRLOCKS)

/obj/outfit/admin/izweski/priest
	name = "Hegemony Warpriest"
	uniform = /obj/item/clothing/under/unathi/skakh/warrior
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/box/donkpockets = 1,
		/obj/item/device/versebook/skakh = 1
	)


/obj/outfit/admin/izweski/priest/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
