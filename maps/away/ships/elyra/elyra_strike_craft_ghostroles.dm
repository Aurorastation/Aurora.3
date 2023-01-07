//elyran naval infantry

/datum/ghostspawner/human/elyran_naval_infantry
	short_name = "elyran_naval_infantry"
	name = "Elyran Naval Infantryman"
	desc = "Crew the Elyran naval infantry interdiction craft. Follow your Ensign's orders. (OOC Note: All characters must be of Elyran ethnic origin and background, this is enforceable by admin/moderator action.)"
	tags = list("External")
	mob_name_prefix = "RFLMN. " //Rifleman

	spawnpoints = list("elyran_naval_infantry")
	max_count = 3

	outfit = /datum/outfit/admin/elyran_naval_infantry
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Elyran Naval Infantryman"
	special_role = "Elyran Naval Infantryman"
	respawn_flag = null

	visitable_overmap_type = /obj/effect/overmap/visitable/ship/elyran_strike_craft


/datum/outfit/admin/elyran_naval_infantry
	name = "Elyran Naval Infantryman"

	uniform = /obj/item/clothing/under/rank/elyran_fatigues
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/elyran_naval_infantry_craft

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/admin/elyran_naval_infantry/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/inhaler/phoron_special, slot_in_backpack)
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

/datum/outfit/admin/elyran_naval_infantry/get_id_access()
	return list(access_elyran_naval_infantry_ship, access_external_airlocks)

/datum/ghostspawner/human/elyran_naval_infantry/officer
	short_name = "elyran_naval_infantry_officer"
	name = "Elyran Naval Infantry Officer"
	desc = "Command and pilot the Elyran naval infantry strike craft. (OOC Note: All characters must be of Elyran ethnic origin and background, this is enforceable by admin/moderator action.)"
	mob_name_prefix = "ENS. "

	spawnpoints = list("elyran_naval_infantry_officer")
	max_count = 1

	outfit = /datum/outfit/admin/elyran_naval_infantry/officer

	assigned_role = "Elyran Naval Infantry Officer"
	special_role = "Elyran Naval Infantry Officer"


/datum/outfit/admin/elyran_naval_infantry/officer
	name = "Elyran Naval Infantry Officer"
	uniform = /obj/item/clothing/under/rank/elyran_fatigues/commander


/datum/ghostspawner/human/elyran_naval_infantry/nco
	short_name = "elyran_naval_infantry_nco"
	name = "Elyran Naval Infantry Fireteam Leader"
	desc = "Lead the Elyran naval infantry strike craft's riflemen. Serve as the Ensign's second-in-command, and follow their orders. (OOC Note: All characters must be of Elyran ethnic origin and background, this is enforceable by admin/moderator action.)"
	mob_name_prefix = "PO3. "

	max_count = 1

	outfit = /datum/outfit/admin/elyran_naval_infantry/nco

	assigned_role = "Elyran Naval Infantry Fireteam Leader"
	special_role = "Elyran Naval Infantry Fireteam Leader"


/datum/outfit/admin/elyran_naval_infantry/nco
	name = "Elyran Naval Infantry Fireteam Leader"

//items

/obj/item/card/id/elyran_naval_infantry_craft
	name = "elyran naval infantry craft id"
	access = list(access_elyran_naval_infantry_ship, access_external_airlocks)
