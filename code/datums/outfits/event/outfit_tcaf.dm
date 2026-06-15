/** Tau Ceti Armed Forces outfits
 - Includes Republic Astroforce-proper crew and officers
 - Includes the Home Defence Forces (planetary)
 - Republic Espatiers can be found in the ERT outfits
**/

/// Republic Astroforce
/obj/outfit/admin/tcaf
	name = "TCAF Republic Astroforces Crewman (Equipped)"

	uniform = /obj/item/clothing/under/tcaf/crew
	suit = /obj/item/clothing/accessory/armor_plate/tcaf/tcaf_light
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/tcaf
	head = /obj/item/clothing/head/tcaf_rate
	belt = /obj/item/storage/belt/utility/very_full
	id = /obj/item/card/id/tcaf
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/energy/blaster = 1)
	l_ear = /obj/item/radio/headset/ship

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/melee/energy/sword/knife = 1
		/obj/item/gun/energy/blaster/carbine = 1)

	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/jackboots/toeless, // Vaurca shoes look odd with the uniforms.
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_ATTENDANT = /obj/item/clothing/shoes/jackboots/toeless
	)

/obj/outfit/admin/tcaf/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		H.update_body()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
	if(isipc(H))
		var/obj/item/organ/internal/machine/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
		if(istype(tag))
			tag.modify_tag_data()

/obj/outfit/admin/tcaf/get_id_access()
	return list(ACCESS_TCAF, ACCESS_EXTERNAL_AIRLOCKS)

/obj/outfit/admin/tcaf/co
	name = "TCAF Republic Astroforce Astrarch (Equipped)"

	head = /obj/item/clothing/head/tcaf_officer
	uniform = /obj/item/clothing/under/tcaf_officer
	suit = /obj/item/clothing/suit/storage/toggle/tcaf_officer_greatcoat
	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife = 1, /obj/item/shield/energy/tcaf = 1, /obj/item/clothing/accessory/tcaf/astrarch = 1)

/// Home Defence Forces
/// TBD
