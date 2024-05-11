
// ---------------------- spawners

/datum/ghostspawner/human/tret_industrial
	name = "Tret Industrial Worker"
	short_name = "tret_industrial"
	desc = "You are a Vaurca Worker of the Hive K'lax in one of the many industrial facilities of Tret. Mine, extract and process valuable materials for the glory of the Hive K'lax."
	tags = list("External")
	spawnpoints = list("tret_industrial")
	max_count = 4

	outfit = /obj/outfit/admin/tret_industrial/vaurca
	possible_species = list(SPECIES_VAURCA_WORKER)
	uses_species_whitelist = FALSE
	assigned_role = "Tret Industrial Worker"
	special_role = "Tret Industrial Worker"
	respawn_flag = null

	mob_name_suffix = " K'lax"
	mob_name_pick_message = "Pick a Vaurca Worker name."

	extra_languages = list(LANGUAGE_VAURCA)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	welcome_message = "You are a Vaurca Worker of the Hive K'lax in an industrial mining facility on the planet Tret. Remember, as a Worker you are generally averse to violence, and should rely on the protection of Warriors where possible. \
	IMPORTANT - Vaurca are a very alien species, and can be difficult to roleplay. It is recommended that you read the Aurorastation wiki page for the species, as well as the Vaurca Hives page for information on K'lax coloration."

/datum/ghostspawner/human/tret_industrial/bulwark
	name = "Tret Industrial Bulwark"
	short_name = "tret_industrial_bulwark"
	desc = "You are a Vaurca Bulwark of the Hive K'lax in one of the many industrial facilities of Tret. Mine, extract and process valuable materials for the glory of the Hive K'lax."
	max_count = 1
	possible_species = list(SPECIES_VAURCA_BULWARK)
	uses_species_whitelist = TRUE

	mob_name_suffix = " K'lax"
	mob_name_pick_message = "Pick a Vaurca Bulwark name."
	welcome_message = "You are a Vaurca Bulwark of the Hive K'lax, working on an industrial facility on Tret. Remember, as a Bulwark you should not seek out conflict, but you may fight to defend yourself or the Workers beside you."

/datum/ghostspawner/human/tret_industrial/warrior
	name = "Tret Industrial Warrior"
	short_name = "tret_industrial_warrior"
	desc = "You are a Vaurca Warrior of the Hive K'lax, assigned to protecting one of the industrial facilities of Tret. Keep the Workers at this facility safe."
	max_count = 2
	possible_species = list(SPECIES_VAURCA_WARRIOR)
	uses_species_whitelist = TRUE
	outfit = /obj/outfit/admin/tret_industrial/vaurca/warrior
	mob_name_suffix = " K'lax"
	mob_name_pick_message = "Pick a Vaurca Warrior name."
	welcome_message = "You are a Vaurca Warrior of the Hive K'lax, assigned to protect an industrial facility on Tret. Your primary duty is to keep the Workers of the facility safe from any threats."

// ---------------------- corpses

/obj/effect/landmark/corpse/tret_industrial_sinta
	name = "Cult Base Cultist Corpse"
	species = list(SPECIES_UNATHI)
	outfit = list(/obj/outfit/admin/tret_industrial/sinta)

/obj/effect/landmark/corpse/tret_industrial_sinta/do_extra_customization(var/mob/living/carbon/human/human)
	human.dir = pick(NORTH, SOUTH, EAST, WEST)
	human.take_overall_damage(150, 20)

// ---------------------- outfits

/obj/outfit/admin/tret_industrial/vaurca
	uniform = /obj/item/clothing/under/vaurca
	shoes = /obj/item/clothing/shoes/vaurca
	mask = /obj/item/clothing/mask/gas/vaurca/filter
	back = /obj/item/storage/backpack/cloak/cargo
	id = /obj/item/card/id

/obj/outfit/admin/tret_industrial/get_id_access()
	return list(ACCESS_EXTERNAL_AIRLOCKS)

/obj/outfit/admin/tret_industrial/vaurca/warrior
	belt = /obj/item/melee/energy/vaurca
	back = /obj/item/storage/backpack/cloak/sec
	l_hand = /obj/item/martial_manual/vaurca

/obj/outfit/admin/tret_industrial/vaurca/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.wear_mask && H.species.has_organ[BP_PHORON_RESERVE])
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"

	var/obj/item/organ/B = new /obj/item/organ/internal/augment/tool/drill(H)
	var/obj/item/organ/external/affectedB = H.get_organ(B.parent_organ)
	B.replaced(H, affectedB)
	H.update_body()

/obj/outfit/admin/tret_industrial/sinta
	uniform = list(/obj/item/clothing/under/unathi/mogazali/blue, /obj/item/clothing/under/unathi/mogazali/orange)
	wrist = /obj/item/clothing/wrists/unathi/jeweled
	shoes = /obj/item/clothing/shoes/footwraps
	back = /obj/item/storage/backpack/satchel/pocketbook
	suit = /obj/item/clothing/suit/space
	accessory = /obj/item/clothing/accessory/poncho/unathimantle/hephaestus

/obj/outfit/admin/tret_industrial/sinta/post_equip(mob/living/carbon/human/human, visualsOnly = FALSE)
	. = ..()

	// add some items
	if(prob(75))
		human.equip_or_collect(new /obj/item/spacecash/c500, slot_in_backpack)
	if(prob(75))
		human.equip_or_collect(new /obj/item/spacecash/ewallet/c2000, slot_in_backpack)
	if(prob(75))
		human.equip_or_collect(new /obj/item/spacecash/c200, slot_in_backpack)
	human.equip_or_collect(new /obj/item/folder/white, slot_in_backpack)
	human.equip_or_collect(new /obj/item/paper/fluff/tret_industrial/inspection_report, slot_in_backpack)
	human.equip_or_collect(new /obj/item/pen/fountain/silver, slot_in_backpack)
	if(prob(75))
		human.equip_or_collect(new /obj/item/spacecash/c100, slot_in_backpack)
	if(prob(75))
		human.equip_or_collect(new /obj/random/highvalue/cash, slot_in_backpack)

	// add blood
	human.w_uniform?.add_blood(human)
	human.wear_suit?.add_blood(human)
	human.gloves?.add_blood(human)
	human.shoes?.add_blood(human)

/obj/item/paper/fluff/tret_industrial/inspection_report
	name = "inspection report"
	desc = "A written, unfinished inspection report."
	language = LANGUAGE_UNATHI
	info = "\
		TO: REGION COMMAND<br>\
		FROM:<br>\
		INSPECTOR ID: 3526071-39352<br>\
		SUBJECT: INSPECTION REPORT<br>\
		LOCATION: OUTPOST 200-14D<br>\
		INDEX: 2137<br>\
		<br>\
		<br>\
		YARD NOT FREE OF DEBRIS<br>\
		ROOF IS CRACKED<br>\
		EXTERIOR DOORS NOT SECURE<br>\
		CO2 CANISTER LEAKY<br>\
		CRACKS IN FOUNDATION<br>\
		CRACKS IN EXTERIOR WALL<br>\
		COMPUTER SYSTEM OUT OF DATE<br>\
		DOCKING CODES NOT SET<br>\
		UNAUTHORIZED GARDEN EXPANSION<br>\
		UNAPPROVED KOIS GROWING<br>\
		<br>\
		"
