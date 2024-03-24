/datum/map_template/ruin/away_site/idris_wreck
	name = "Wrecked Idris Transport"
	description = "An Idris vessel, set upon by pirates and left in ruins."
	suffixes = list("away_site/idris_wreck/idris_wreck.dmm")
	sectors = list(SECTOR_BADLANDS, SECTOR_WEEPING_STARS, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE) //sectors that an idris ship might be passing through, but frontier enough that it could get raided
	spawn_weight = 1
	spawn_cost = 1
	id = "idris_wreck"
	unit_test_groups = list(1)

/singleton/submap_archetype/idris_wreck
	map = "Wrecked Idris Transport"
	descriptor = "An Idris vessel, set upon by pirates and left in ruins."

/obj/effect/overmap/visitable/idris_wreck
	name = "Wrecked Idris Transport"
	desc = "A Safeguard-class transport vessel, used by Idris Incorporated's security forces for the safe movement of high-value goods across the Spur. Sensor readings indicate that this one is severely damaged, with no life signs and minimal energy readings detected."
	class = "IIV" //Idris Incorporated Vessel
	icon = 'icons/obj/overmap/overmap_ships.dmi'
	icon_state = "generic"
	color = "#1cf2d2"
	initial_generic_waypoints = list(
		"nav_idris_1",
		"nav_idris_2",
		"nav_idris_3",
		"nav_idris_4"
	)

/obj/effect/overmap/visitable/idris_wreck/New()
	designation = "[pick("Vigilance", "Astronomical", "Unlimited", "Celestial")]"
	..()

/obj/effect/shuttle_landmark/idris_wreck
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/idris_wreck/nav1
	name = "Idris Vault Ship - Fore"
	landmark_tag = "nav_idris_1"

/obj/effect/shuttle_landmark/idris_wreck/nav2
	name = "Idris Vault Ship - Port"
	landmark_tag = "nav_idris_2"

/obj/effect/shuttle_landmark/idris_wreck/nav3
	name = "Idris Vault Ship - Starboard"
	landmark_tag = "nav_idris_3"

/obj/effect/shuttle_landmark/idris_wreck/nav4
	name = "Idris Vault Ship - Aft"
	landmark_tag = "nav_idris_4"

//Corpses

/obj/effect/landmark/corpse/idris
	name = "Idris Security Officer"
	corpseuniform = /obj/item/clothing/under/rank/security/idris/idrissec
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpsehelmet = /obj/item/clothing/head/beret/corporate/idris
	corpseglasses = /obj/item/clothing/glasses/safety/goggles/goon/idris
	corpseid = TRUE
	corpseidjob = "Security Officer (Idris)"
	corpseidicon = "idrissec_card"
	corpseidaccess = "Idris Ship Crew Member"
	corpsepocket1 = /obj/item/storage/wallet/random
	species = SPECIES_HUMAN

/obj/effect/landmark/corpse/idris/do_extra_customization(mob/living/carbon/human/M)
	if(prob(25))
		M.equip_to_slot_or_del(new /obj/item/clothing/suit/space/void/security(M), slot_wear_suit)
		M.equip_to_slot_or_del(new /obj/item/tank/oxygen(M), slot_s_store)
	M.ChangeToHusk()
	M.adjustBruteLoss(rand(200,400))
	M.dir = pick(GLOB.cardinal)

/obj/effect/landmark/corpse/idris/robot
	name = "Idris Security Unit"
	corpseshoes = /obj/item/clothing/shoes/laceup
	corpseglasses = /obj/item/clothing/glasses/sunglasses/sechud/aviator/idris
	corpsesuit = /obj/item/clothing/suit/storage/toggle/armor/vest/idris/longcoat
	corpsehelmet = null
	corpseback = /obj/item/device/suit_cooling_unit
	corpseidjob = "Idris Security Unit"
	species = SPECIES_IPC

/obj/effect/landmark/corpse/idris/robot/do_extra_customization(mob/living/carbon/human/M)
	M.adjustBruteLoss(rand(200,400))
	M.dir = pick(GLOB.cardinal)
	var/obj/item/organ/internal/ipc_tag/tag = M.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(M.real_name), 12))
		tag.ownership_info = IPC_OWNERSHIP_COMPANY
		tag.citizenship_info = CITIZENSHIP_NONE

/obj/effect/landmark/corpse/idris/captain
	name = "Idris Captain"
	corpseshoes = /obj/item/clothing/shoes/laceup
	corpseuniform = /obj/item/clothing/under/rank/liaison/idris
	corpsesuit = /obj/item/clothing/suit/storage/liaison/idris
	corpsehelmet = /obj/item/clothing/head/beret/corporate/idris
	corpseidjob = "Captain"

/obj/effect/landmark/corpse/idris/captain/do_extra_customization(mob/living/carbon/human/M)
	M.ChangeToHusk()
	M.adjustBruteLoss(rand(200,400))
	M.dir = pick(GLOB.cardinal)

/obj/effect/landmark/corpse/izharshan
	name = "Izharshan Pirate"
	corpseuniform = /obj/item/clothing/under/unathi/izharshan
	corpseshoes = /obj/item/clothing/shoes/sandals/caligae
	corpsesuit = /obj/item/clothing/suit/space/void/unathi_pirate
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/unathi_pirate
	corpseid = FALSE
	species = SPECIES_UNATHI

/obj/effect/landmark/corpse/izharshan/do_extra_customization(mob/living/carbon/human/M)
	M.ChangeToHusk()
	M.equip_to_slot_or_del(new /obj/item/tank/oxygen(M), slot_s_store)
	M.adjustFireLoss(rand(200,400))
	M.dir = pick(GLOB.cardinal)

//Areas
/area/idris_wreck
	name = "Idris Vault Ship"
	icon_state = "green"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/space
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/idris_wreck/bridge
	name = "Idris Vault Ship - Bridge"
	icon_state = "bridge"

/area/idris_wreck/forehall
	name = "Idris Vault Ship - Fore Hall"
	icon_state = "hallF"

/area/idris_wreck/cryo
	name = "Idris Vault Ship - Cryogenic Storage"
	icon_state = "cryo"

/area/idris_wreck/cryoentrance
	name = "Idris Vault Ship - Cryogenic Entryway"
	icon_state = "crew"

/area/idris_wreck/eva
	name = "Idris Vault Ship - EVA Storage"
	icon_state = "exit"

/area/idris_wreck/armory
	name = "Idris Vault Ship - Security Equipment"
	icon_state = "armory"

/area/idris_wreck/kitchen
	name = "Idris Vault Ship - Mess Hall"
	icon_state = "kitchen"

/area/idris_wreck/captain
	name = "Idris Vault Ship - Captain's Office"
	icon_state = "captain"

/area/idris_wreck/central
	name = "Idris Vault Ship - Central Ring"
	icon_state = "hallC"

/area/idris_wreck/vault
	name = "Idris Vault Ship - Vault"
	icon_state = "storage"
	ambience = AMBIENCE_HIGHSEC

/area/idris_wreck/afthall
	name = "Idris Vault Ship - Aft Hall"
	icon_state = "hallA"

/area/idris_wreck/engi
	name = "Idris Vault Ship - Engineering"
	icon_state = "engineering"

/area/idris_wreck/atmos
	name = "Idris Vault Ship - Atmospherics"
	icon_state = "atmos"

/area/idris_wreck/mainthall
	name = "Idris Vault Ship - Maintenance Hall"
	icon_state = "engineering_foyer"

/area/idris_wreck/portthrust
	name = "Idris Vault Ship - Port Nacelle"
	icon_state = "engine"

/area/idris_wreck/starbthrust
	name = "Idris Vault Ship - Starboard Nacelle"
	icon_state = "engine"
