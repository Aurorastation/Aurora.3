/datum/ghostspawner/human/idris_cruiser_crew
	name = "Idris Cruise Crew Member"
	short_name = "idriscrew"
	desc = "Serve as either a staff member, engineer, janitor, bartender, chef, guard, or service provider of an Idris luxury cruise yacht."
	tags = list("External")

	welcome_message = "You're a crewmember for an Idris cruise vessel. Keep your clients happy, your ship in tip-top shape, and your smile uniquely Idris! You can take any service, maintenance, or security role on the ship as necessary."

	spawnpoints = list("idriscrew")
	max_count = 5

	outfit = /obj/outfit/admin/idris_cruiser_crew
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	uses_species_whitelist = TRUE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Idris Cruise Crew Member"
	special_role = "Idris Cruise Crew Member"
	respawn_flag = null

/datum/ghostspawner/human/idris_cruiser_crew/director
	name = "Idris Cruise Director"
	short_name = "idriscrew_director"
	spawnpoints = list("idriscrew_director")
	desc = "Serve as the prestigious director of an Idris luxury cruise yacht."
	welcome_message = "You're the prestigious director for an Idris luxury cruiser! Make sure the ship and its crew are in tip-top shape, and make sure to attract customers to your space getaway."
	max_count = 1

	outfit = /obj/outfit/admin/idris_cruiser_crew/director
	possible_species = list(SPECIES_HUMAN)

	assigned_role = "Idris Cruise Director"
	special_role = "Idris Cruise Director"

//Outfits
/obj/outfit/admin/idris_cruiser_crew
	name = "Idris Cruise Crew Member"
	uniform = /obj/item/clothing/under/librarian/idris
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/device/radio/headset/ship
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/idris
	l_pocket = /obj/item/reagent_containers/glass/rag/advanced/idris
	wrist = /obj/item/clothing/wrists/watch
	backpack_contents = list(/obj/item/storage/box/survival = 1)

/obj/outfit/admin/idris_cruiser_crew/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
		tag.ownership_info = IPC_OWNERSHIP_COMPANY
		tag.citizenship_info = CITIZENSHIP_NONE

/obj/outfit/admin/idris_cruiser_crew/director
	name = "Idris Cruise Director"
	head = /obj/item/clothing/head/beret/corporate/idris
	uniform = /obj/item/clothing/under/rank/liaison/idris
	suit = /obj/item/clothing/suit/storage/security/officer/idris/alt
	accessory = /obj/item/clothing/accessory/holster/waist
	accessory_contents = list(/obj/item/gun/energy/repeater/pistol = 1)
	l_pocket = /obj/item/stamp/idris
	wrist = /obj/item/clothing/wrists/watch/silver
	backpack_contents = list(/obj/item/storage/box/survival = 1)

/obj/outfit/admin/idris_cruiser_crew/director/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H && H.w_uniform)
		var/obj/item/clothing/under/U = H.w_uniform
		var/obj/item/clothing/accessory/tie/corporate/idris/tie = new()
		U.attach_accessory(null, tie)

/obj/outfit/admin/idris_cruiser_crew/get_id_access()
	return list(ACCESS_IDRIS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ENGINE_EQUIP, ACCESS_GUEST_ROOMS, ACCESS_GUEST_ROOM_1, ACCESS_GUEST_ROOM_2, ACCESS_GUEST_ROOM_3, ACCESS_GUEST_ROOM_4)
