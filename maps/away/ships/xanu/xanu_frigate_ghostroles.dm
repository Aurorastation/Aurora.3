/datum/ghostspawner/human/xanufrigate_crewman
	name = "All-Xanu Spacefleet Frigate Crewman"
	short_name = "xanufrigate_crewman"
	desc = "Serve as a crewmember aboard a naval frigate of the All-Xanu Spacefleet, the navy of Xanu Prime and one of the largest component navies of the Coalition of Colonies."
	tags = list("External")

	welcome_message = "You're a crewmember for an All-Xanu Spacefleet vessel, representing Xanu Prime and protecting the Coalition of Colonies. You are a military professional, and are trained extensively in combat, survival, and damage control, but \
	may specialize in specific fields such as infantry, engineering, security, or bridge crew."

	spawnpoints = list("xanufrigate_crewman")
	max_count = 4
	mob_name_prefix = "PO3. "

	outfit = /obj/outfit/admin/xanufrigate_crewman
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_DIONA, SPECIES_IPC, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	uses_species_whitelist = TRUE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "All-Xanu Spacefleet Crewman"
	special_role = "All-Xanu Spacefleet Crewman"
	respawn_flag = null

/datum/ghostspawner/human/xanufrigate_crewman/officer
	name = "All-Xanu Spacefleet Frigate Officer"
	short_name = "Xanufrigate_officer"
	desc = "Serve as an officer aboard a naval frigate of the All-Xanu Spacefleet, the navy of Xanu Prime and one of the largest component navies of the Coalition of Colonies."
	welcome_message = "You're an officer of an All-Xanu Spacefleet vessel, representing Xanu Prime and protecting the Coalition of Colonies. You are a military officer, and are trained extensively in combat, survival, and damage control, as well as \
	leadership and tactical strategy."
	max_count = 1
	outfit = /obj/outfit/admin/xanufrigate_crewman/officer
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_IPC, SPECIES_IPC_SHELL)
	mob_name_prefix = "LT. "

/datum/ghostspawner/human/xanufrigate_crewman/officer/captain
	name = "All-Xanu Spacefleet Frigate Captain"
	short_name = "Xanufrigate_captain"
	desc = "Serve as the captain aboard a naval frigate of the All-Xanu Spacefleet, the navy of Xanu Prime and one of the largest component navies of the Coalition of Colonies."
	welcome_message = "You're the captain of an All-Xanu Spacefleet vessel, representing Xanu Prime and protecting the Coalition of Colonies. You are a military officer, and are trained extensively in combat, survival, and damage control, as well as \
	leadership and tactical strategy."
	max_count = 1
	outfit = /obj/outfit/admin/xanufrigate_crewman/officer/captain
	spawnpoints = list("xanufrigate_captain")
	mob_name_prefix = "CDR. "

/obj/outfit/admin/xanufrigate_crewman
	name = "All-Xanu Armed Forces Crewman"
	uniform = /obj/item/clothing/under/xanu
	head = /obj/item/clothing/head/xanu
	shoes = /obj/item/clothing/shoes/jackboots
	l_ear = /obj/item/device/radio/headset/ship/coalition_navy
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/coalition
	l_pocket = /obj/item/device/radio/off
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/clothing/mask/gas/half = 1,
		)

/obj/outfit/admin/xanufrigate_crewman/officer
	name = "All-Xanu Armed Forces Officer"
	uniform = /obj/item/clothing/under/xanu/officer
	head = /obj/item/clothing/head/xanu/officer
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/projectile/xanupistol = 1)
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/ammo_magazine/c46m = 2,
		/obj/item/clothing/mask/gas/half = 1,
		)

/obj/outfit/admin/xanufrigate_crewman/officer/captain
	name = "All-Xanu Armed Forces Senior Officer"
	uniform = /obj/item/clothing/under/xanu/officer/senior
	head = /obj/item/clothing/head/xanu/senior

/obj/outfit/admin/xanufrigate_crewman/get_id_access()
	return list(ACCESS_COALITION, ACCESS_COALITION_NAVY, ACCESS_EXTERNAL_AIRLOCKS)
