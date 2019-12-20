// Anything that's coded as an "antagonist" that needs outfits should go here, unless it's an ERT.

/datum/outfit/admin/syndicate
	name = "Syndicate Agent"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/syndicate
	back = null
	backpack = /obj/item/storage/backpack/syndie
	satchel = /obj/item/storage/backpack/satchel_syndie
	satchel_alt = /obj/item/storage/backpack/satchel
	dufflebag = /obj/item/storage/backpack/duffel/syndie
	messengerbag = /obj/item/storage/backpack/messenger/syndie
	belt = /obj/item/storage/belt/utility/full
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/combat
	l_ear = /obj/item/device/radio/headset/syndicate/alt
	id = /obj/item/card/id/syndicate
	r_pocket = /obj/item/device/radio/uplink
	backpack_contents = list(
		/obj/item/storage/box/engineer = 1,
		/obj/item/device/flashlight = 1,
		/obj/item/card/emag = 1,
		/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket = 1,
		/obj/item/device/multitool = 1
	)

	var/id_access = "Syndicate Operative"
	var/uplink_uses = DEFAULT_TELECRYSTAL_AMOUNT

/datum/outfit/admin/syndicate/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/device/radio/uplink/U = H.r_store
	if(istype(U))
		U.hidden_uplink.uplink_owner = H.mind
		U.hidden_uplink.uses = uplink_uses
		U.hidden_uplink.nanoui_menu = 1

/datum/outfit/admin/syndicate/get_id_access()
	return get_syndicate_access(id_access)


/datum/outfit/admin/syndicate/operative
	name = "Syndicate Operative"

	suit = /obj/item/clothing/suit/space/void/merc
	belt = /obj/item/storage/belt/military/syndicate
	head = /obj/item/clothing/head/helmet/space/void/merc
	mask = /obj/item/clothing/mask/gas/syndicate
	l_ear = /obj/item/device/radio/headset/syndicate
	glasses = /obj/item/clothing/glasses/night
	shoes = /obj/item/clothing/shoes/magboots
	l_pocket = /obj/item/pinpointer/nukeop
	l_hand = /obj/item/tank/jetpack/void

	backpack_contents = list(
		/obj/item/storage/box/engineer = 1,
		/obj/item/reagent_containers/pill/cyanide = 1,
		/obj/item/gun/projectile/automatic/x9 = 1,
		/obj/item/ammo_magazine/c45x = 1,
		/obj/item/crowbar/red = 1,
		/obj/item/plastique = 1,
		/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket = 1,
		/obj/item/device/flashlight = 1,
		/obj/item/clothing/shoes/combat = 1
)

/datum/outfit/admin/syndicate/officer
	name = "Syndicate Officer"

	head = /obj/item/clothing/head/beret
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/havana
	belt = /obj/item/gun/projectile/deagle
	l_ear = /obj/item/device/radio/headset/syndicate
	l_pocket = /obj/item/pinpointer/advpinpointer
	r_pocket = null // stop them getting a radio uplink, they get an implant instead

	backpack_contents = list(
		/obj/item/storage/box/engineer = 1,
		/obj/item/device/flashlight = 1,
		/obj/item/reagent_containers/pill/cyanide = 1,
		/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket = 1,
		/obj/item/ammo_magazine/a50 = 2,
		/obj/item/clothing/shoes/magboots = 1,
		/obj/item/flame/lighter/zippo = 1
	)
	implants = list(
		/obj/item/implant/explosive
	)
	id_access = "Syndicate Operative Leader"

/datum/outfit/admin/syndicate/spy
	name = "Syndicate Spy"
	uniform = /obj/item/clothing/under/suit_jacket/really_black
	shoes = /obj/item/clothing/shoes/black/noslip
	uplink_uses = 40
	id_access = "Syndicate Agent"

	implants = list(
		/obj/item/implant/explosive
	)

// Syndicate Auxiliary Outfits (ninja, merc, etc.)

/datum/outfit/admin/syndicate/ninja
	name = "Infiltrator"
	allow_backbag_choice = FALSE

	uniform = /obj/item/clothing/under/syndicate/ninja
	back = null
	belt = /obj/item/storage/belt/ninja
	shoes = /obj/item/clothing/shoes/swat/ert
	gloves = /obj/item/clothing/ring/ninja
	mask = /obj/item/clothing/mask/balaclava
	l_ear = /obj/item/device/radio/headset/ninja
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/tactical
	id = /obj/item/card/id/syndicate
	l_pocket = null
	r_pocket = null
	accessory = /obj/item/clothing/accessory/storage/pouches/black

	backpack_contents = list()

	belt_contents = list(
		/obj/item/device/flashlight/maglight = 1,
		/obj/item/crowbar = 1,
		/obj/item/screwdriver = 1,
		/obj/item/device/paicard = 1
	)

	id_access = "Syndicate Agent"

/datum/outfit/admin/syndicate/ninja/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/rig/light/ninja/rig = new /obj/item/rig/light/ninja(src)
	rig.dnaLock = H.dna
	H.equip_to_slot_or_del(rig, slot_l_hand)

	H.equip_to_slot_or_del(new /obj/item/device/ninja_uplink(H, H.mind), slot_l_store)

/datum/outfit/admin/syndicate/mercenary
	name = "Mercenary"

	uniform = /obj/item/clothing/under/syndicate
	belt = /obj/item/storage/belt/military
	gloves = /obj/item/clothing/gloves/swat
	shoes = /obj/item/clothing/shoes/jackboots

	backpack_contents = list(
		/obj/item/storage/box/engineer = 1,
		/obj/item/reagent_containers/pill/cyanide = 1
	)

/datum/outfit/admin/syndicate/mercenary/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	if(!H.shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/unathi(H), slot_shoes)

/datum/outfit/admin/syndicate/raider
	name = "Raider"
	allow_backbag_choice = FALSE

	uniform = list(
		/obj/item/clothing/under/soviet,
		/obj/item/clothing/under/pirate,
		/obj/item/clothing/under/redcoat,
		/obj/item/clothing/under/serviceoveralls,
		/obj/item/clothing/under/captain_fly,
		/obj/item/clothing/under/det,
		/obj/item/clothing/under/brown,
		/obj/item/clothing/under/syndicate/tracksuit
		)

	suit = list(
		/obj/item/clothing/suit/pirate,
		/obj/item/clothing/suit/hgpirate,
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/suit/storage/toggle/leather_jacket,
		/obj/item/clothing/suit/storage/toggle/brown_jacket,
		/obj/item/clothing/suit/unathi/mantle,
		/obj/item/clothing/accessory/poncho,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/grey
	)

	shoes = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/laceup
	)
	glasses = list(
		/obj/item/clothing/glasses/thermal,
		/obj/item/clothing/glasses/eyepatch/hud/thermal,
		/obj/item/clothing/glasses/thermal/plain/monocle,
		/obj/item/clothing/glasses/thermal/aviator
	)
	head = list(
		/obj/item/clothing/head/bearpelt,
		/obj/item/clothing/head/ushanka,
		/obj/item/clothing/head/pirate,
		/obj/item/clothing/head/bandana,
		/obj/item/clothing/head/hgpiratecap
	)

	back = null
	belt = null
	gloves = null
	l_ear = /obj/item/device/radio/headset/raider
	r_pocket = null
	id = /obj/item/storage/wallet

	backpack_contents = list()

/datum/outfit/admin/syndicate/raider/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	if(!H.shoes)
		var/fallback_type = pick(/obj/item/clothing/shoes/sandal, /obj/item/clothing/shoes/jackboots/unathi)
		H.equip_to_slot_or_del(new fallback_type(H), slot_shoes)

	var/obj/item/storage/wallet/W = H.wear_id
	var/obj/item/card/id/syndicate/raider/id = new(H)
	id.name = "[H.real_name]'s Passport"
	if(W)
		W.handle_item_insertion(id)
		spawn_money(rand(50,150)*10,W)

// Non-syndicate antag outfits

/datum/outfit/admin/highlander
	name = "Highlander"

	uniform = /obj/item/clothing/under/kilt
	head = /obj/item/clothing/head/beret
	shoes = /obj/item/clothing/shoes/combat
	l_ear = /obj/item/device/radio/headset/heads/captain
	l_hand = /obj/item/material/sword
	l_pocket = /obj/item/pinpointer

	id = /obj/item/card/id/highlander

/datum/outfit/admin/highlander/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	if(W)
		W.name = "[H.real_name]'s ID"
		W.registered_name = H.real_name

/datum/outfit/admin/wizard
	name = "Space Wizard"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/lightpurple
	back = null
	backpack = /obj/item/storage/backpack/wizard
	satchel = /obj/item/storage/backpack/satchel_wizard
	satchel_alt = /obj/item/storage/backpack/satchel
	dufflebag = /obj/item/storage/backpack/duffel/wizard
	messengerbag = /obj/item/storage/backpack/messenger/wizard
	suit = /obj/item/clothing/suit/wizrobe
	head = /obj/item/clothing/head/wizard
	shoes = /obj/item/clothing/shoes/sandal
	l_ear = /obj/item/device/radio/headset
	r_pocket = /obj/item/teleportation_scroll
	l_hand = /obj/item/spellbook

	backpack_contents = list(
		/obj/item/storage/box = 1
	)
