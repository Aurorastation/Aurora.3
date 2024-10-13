/datum/ghostspawner/human/fishing_trawler_crewman
	name = "Fishing League Trawler Multipurpose Crewman"
	short_name = "fishing_trawler_crewman"
	desc = "Serve as a crewman aboard a Fishing League contracted Hegemony Freighter; seeking and collecting carp and other food for billions of sinta."
	tags = list("External")

	welcome_message = "You are a semi-skilled crewmember of a Hegemony Freighter bound by the Fishing League and thereby also Hephaestus Industries. You and your fellow crewmen perform many duties around the ship and are not relegated to just one job. Your goal is to harvest the bounty of space and collect as much carp and other food as you can to feed the masses of the Hegemony. Fill the freezer with as much meat as the ship can carry."
	spawnpoints = list("fishing_trawler_crewman")
	max_count = 4

	outfit = /obj/outfit/admin/fishing_trawler_crewman
	possible_species = list(SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_ATTENDANT)
	uses_species_whitelist = FALSE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Fishing League Trawler Crewman"
	special_role = "Fishing League Trawler Crewman"
	respawn_flag = null

/datum/ghostspawner/human/fishing_trawler_crewman/captain
	name = "Fishing League Trawler Captain"
	short_name = "fishing_trawler_captain"
	desc = "Serve as Captain of a Fishing League contracted Hegemony Freighter; seeking and collecting carp and other food for billions of sinta."
	welcome_message = "You are Captain of a Hegemony Freighter bound by the Fishing League and therefore also Hephaestus Industries. You must strive to keep your crew working and ensure your perishable storage is full to the brim before returning home."
	max_count = 1
	outfit = /obj/outfit/admin/fishing_trawler_crewman/captain
	spawnpoints = list("fishing_trawler_captain")

/obj/outfit/admin/fishing_trawler_crewman
	name = "Fishing Trawler Crewman"
	uniform = /obj/item/clothing/under/unathi
	shoes = /obj/item/clothing/shoes/workboots
	back = /obj/item/storage/backpack/satchel/hegemony
	l_ear = /obj/item/device/radio/headset/ship
	id = /obj/item/card/id/hephaestus
	backpack_contents = list(/obj/item/storage/box/survival = 1)

	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_ATTENDANT = /obj/item/clothing/shoes/workboots/toeless
	)
	species_suit = list(
		SPECIES_UNATHI = /obj/item/clothing/accessory/poncho/unathimantle/fisher
	)

/obj/outfit/admin/fishing_trawler_crewman/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
		var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
		A.replaced(H, affected)
		H.update_body()
	if(H?.wear_suit)
		H.wear_suit.color = pick("#4f3911", "#292826")

/obj/outfit/admin/fishing_trawler_crewman/get_id_access()
	return list(ACCESS_FISHING_LEAGUE, ACCESS_EXTERNAL_AIRLOCKS)

/obj/outfit/admin/fishing_trawler_crewman/captain
	name = "Fishing Trawler Captain"
	uniform = /obj/item/clothing/under/unathi/mogazali/orange
