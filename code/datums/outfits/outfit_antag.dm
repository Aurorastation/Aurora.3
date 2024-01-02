// Anything that's coded as an "antagonist" that needs outfits should go here, unless it's an ERT.

/datum/outfit/admin/syndicate
	name = "Syndicate Agent"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/syndicate
	back = null
	backpack = /obj/item/storage/backpack/syndie
	satchel = /obj/item/storage/backpack/satchel/syndie
	satchel_alt = /obj/item/storage/backpack/satchel/leather
	dufflebag = /obj/item/storage/backpack/duffel/syndie
	messengerbag = /obj/item/storage/backpack/messenger/syndie
	belt = /obj/item/storage/belt/utility/full
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/combat
	l_ear = /obj/item/device/radio/headset/syndicate/alt
	id = /obj/item/card/id/syndicate
	r_pocket = /obj/item/device/radio/uplink
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/device/flashlight = 1,
		/obj/item/card/emag = 1,
		/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket = 1,
		/obj/item/device/multitool = 1
	)

	id_iff = IFF_SYNDICATE

	var/id_access = "Syndicate Operative"
	var/uplink_uses = DEFAULT_TELECRYSTAL_AMOUNT

/datum/outfit/admin/syndicate/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/device/radio/uplink/U = H.r_store
	if(istype(U))
		U.hidden_uplink.uplink_owner = H.mind
		U.hidden_uplink.telecrystals = uplink_uses
		U.hidden_uplink.bluecrystals = round(uplink_uses / 2)
		U.hidden_uplink.tgui_menu = 1

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
	shoes = /obj/item/clothing/shoes/magboots/syndie
	l_pocket = /obj/item/pinpointer/nukeop
	l_hand = /obj/item/tank/jetpack/void

	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/reagent_containers/pill/cyanide = 1,
		/obj/item/gun/projectile/automatic/x9 = 1,
		/obj/item/ammo_magazine/c45m/auto = 1,
		/obj/item/crowbar/red = 1,
		/obj/item/plastique = 1,
		/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket = 1,
		/obj/item/device/flashlight = 1,
		/obj/item/clothing/shoes/combat = 1
)

/datum/outfit/admin/syndicate/officer
	name = "Syndicate Officer"

	head = /obj/item/clothing/head/beret/red
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/havana
	belt = /obj/item/gun/projectile/deagle
	l_ear = /obj/item/device/radio/headset/syndicate
	l_pocket = /obj/item/pinpointer/advpinpointer
	r_pocket = null // stop them getting a radio uplink, they get an implant instead

	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/device/flashlight = 1,
		/obj/item/reagent_containers/pill/cyanide = 1,
		/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket = 1,
		/obj/item/ammo_magazine/a50 = 2,
		/obj/item/clothing/shoes/magboots/syndie = 1,
		/obj/item/flame/lighter/zippo = 1
	)
	implants = list(
		/obj/item/implant/explosive
	)
	id_access = "Syndicate Operative Leader"

/datum/outfit/admin/syndicate/spy
	name = "Syndicate Spy"
	uniform = /obj/item/clothing/under/suit_jacket/really_black
	shoes = /obj/item/clothing/shoes/sneakers/black/noslip
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
	l_hand = /obj/item/hardsuit_token
	back = null
	belt = /obj/item/storage/belt/ninja
	shoes = /obj/item/clothing/shoes/combat
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

	H.equip_to_slot_or_del(new /obj/item/device/special_uplink/ninja(H, H.mind), slot_l_store)

/datum/outfit/admin/syndicate/mercenary
	name = "Mercenary"

	uniform = /obj/item/clothing/under/syndicate
	belt = /obj/item/storage/belt/military
	gloves = /obj/item/clothing/gloves/swat
	shoes = /obj/item/clothing/shoes/jackboots
	pda = /obj/item/modular_computer/handheld/pda/syndicate
	r_pocket = /obj/item/device/special_uplink/mercenary

	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/reagent_containers/pill/cyanide = 1
	)

	id_iff = IFF_MERCENARY

/datum/outfit/admin/syndicate/mercenary/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	if(!H.shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/toeless(H), slot_shoes)

/datum/outfit/admin/syndicate/mercenary/loner
	name = "Loner"

	l_ear = /obj/item/device/radio/headset/syndicate
	r_pocket = /obj/item/device/special_uplink/burglar

	backpack_contents = list(
		/obj/item/storage/box/syndie_kit/space = 1,
		/obj/item/gun/projectile/shotgun/foldable = 1,
		/obj/item/device/multitool/hacktool = 1
	)

	id_iff = IFF_LONER
	id_access = "Lone Operative"

/datum/outfit/admin/syndicate/raider
	name = "Raider"
	allow_backbag_choice = FALSE

	uniform = list(
		/obj/item/clothing/under/service_overalls,
		/obj/item/clothing/under/det/zavod,
		/obj/item/clothing/under/color/brown,
		/obj/item/clothing/under/syndicate/tracksuit,
		/obj/item/clothing/under/captainformal,
		/obj/item/clothing/under/dominia,
		/obj/item/clothing/under/dominia/lyodsuit/hoodie,
		/obj/item/clothing/under/elyra_holo/masc,
		/obj/item/clothing/under/kilt,
		/obj/item/clothing/under/lance,
		/obj/item/clothing/under/legion/pilot,
		/obj/item/clothing/under/offworlder,
		/obj/item/clothing/under/pants/jeans,
		/obj/item/clothing/under/pants/camo,
		/obj/item/clothing/under/pants/khaki,
		/obj/item/clothing/under/pants/mustang,
		/obj/item/clothing/under/rank/bartender,
		/obj/item/clothing/under/rank/hangar_technician/heph,
		/obj/item/clothing/under/rank/chef,
		/obj/item/clothing/under/rank/chaplain,
		/obj/item/clothing/under/rank/engineer,
		/obj/item/clothing/under/rank/sol,
		/obj/item/clothing/under/rank/miner,
		/obj/item/clothing/under/skirt/offworlder,
		/obj/item/clothing/under/suit_jacket/tan,
		/obj/item/clothing/under/tactical,
		/obj/item/clothing/under/tajaran,
		/obj/item/clothing/under/tajaran/nt,
		/obj/item/clothing/under/rank/engineer/apprentice/heph,
		/obj/item/clothing/under/unathi,
		/obj/item/clothing/under/waiter
		)

	suit = list(
		/obj/item/clothing/suit/pirate,
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/accessory/poncho/unathimantle,
		/obj/item/clothing/accessory/poncho,
		/obj/item/clothing/accessory/poncho/purple,
		/obj/item/clothing/accessory/poncho/roles/cloak/captain,
		/obj/item/clothing/accessory/poncho/roles/cloak/cargo,
		/obj/item/clothing/accessory/poncho/roles/cloak/mining,
		/obj/item/clothing/accessory/poncho/roles/cloak/rd,
		/obj/item/clothing/accessory/overalls/random,
		/obj/item/clothing/suit/captunic/capjacket,
		/obj/item/clothing/suit/ianshirt,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/random,
		/obj/item/clothing/suit/storage/hooded/wintercoat,
		/obj/item/clothing/suit/storage/hooded/wintercoat/red,
		/obj/item/clothing/suit/storage/hooded/wintercoat/miner,
		/obj/item/clothing/suit/storage/leathercoat,
		/obj/item/clothing/suit/storage/vest/ft,
		/obj/item/clothing/suit/storage/toggle/dominia/bomber,
		/obj/item/clothing/suit/storage/dominia/gold,
		/obj/item/clothing/suit/storage/toggle/flannel,
		/obj/item/clothing/suit/storage/toggle/flannel/gray,
		/obj/item/clothing/suit/storage/toggle/flannel/red,
		/obj/item/clothing/suit/storage/toggle/himeo,
		/obj/item/clothing/suit/storage/toggle/leather_vest,
		/obj/item/clothing/suit/storage/toggle/leather_jacket,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/biker,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/flight,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/green,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/white,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/designer/red,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/military,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/military/old,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/military/tan,
		/obj/item/clothing/suit/storage/toggle/tajaran,
		/obj/item/clothing/suit/storage/toggle/trench,
		/obj/item/clothing/suit/storage/toggle/trench/grey,
		/obj/item/clothing/suit/storage/toggle/trench/colorable/random
	)

	shoes = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/laceup/brown,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/shoes/combat,
		/obj/item/clothing/shoes/cowboy,
		/obj/item/clothing/shoes/lyodsuit,
		/obj/item/clothing/shoes/winter,
		/obj/item/clothing/shoes/sneakers/hitops/black,
		/obj/item/clothing/shoes/sneakers/black,
		/obj/item/clothing/shoes/sneakers/brown
	)

	head = list(
		/obj/item/clothing/head/bearpelt,
		/obj/item/clothing/head/ushanka,
		/obj/item/clothing/head/pirate,
		/obj/item/clothing/head/bandana/pirate,
		/obj/item/clothing/head/bandana/red,
		/obj/item/clothing/head/hgpiratecap,
		/obj/item/clothing/head/beanie/random,
		/obj/item/clothing/head/beaverhat,
		/obj/item/clothing/head/cowboy,
		/obj/item/clothing/head/fedora,
		/obj/item/clothing/head/fez,
		/obj/item/clothing/head/flatcap,
		/obj/item/clothing/head/headbando/random,
		/obj/item/clothing/head/helmet/formalcaptain,
		/obj/item/clothing/head/hijab,
		/obj/item/clothing/head/hijab/grey,
		/obj/item/clothing/head/hijab/red,
		/obj/item/clothing/head/sol/garrison,
		/obj/item/clothing/head/nonla,
		/obj/item/clothing/head/helmet/bucket,
		/obj/item/clothing/head/helmet/material/makeshift/plasteel,
		/obj/item/clothing/head/helmet/kettle,
		/obj/item/clothing/head/helmet/tank/olive,
		/obj/item/clothing/head/softcap,
		/obj/item/clothing/head/softcap/himeo,
		/obj/item/clothing/head/softcap/red,
		/obj/item/clothing/head/beret/red,
		/obj/item/clothing/head/that,
		/obj/item/clothing/head/turban,
		/obj/item/clothing/head/turban/grey,
		/obj/item/clothing/head/welding
	)

	back = null
	belt = null
	gloves = null
	glasses = list(
			/obj/item/clothing/glasses/sunglasses,
			/obj/item/clothing/glasses/sunglasses/aviator,
			/obj/item/clothing/glasses/sunglasses/big,
			/obj/item/clothing/glasses/sunglasses/visor
			)
	l_ear = /obj/item/device/radio/headset/raider
	l_pocket = /obj/item/device/special_uplink/raider
	r_pocket = list(
			/obj/item/clothing/glasses/eyepatch/hud/thermal,
			/obj/item/clothing/glasses/thermal,
			/obj/item/clothing/glasses/thermal/aviator
			)

	id = /obj/item/storage/wallet/random
	id_iff = IFF_RAIDER

	accessory = /obj/item/clothing/accessory/storage/webbing

	backpack_contents = list()

/datum/outfit/admin/syndicate/raider/equip(mob/living/carbon/human/H, visualsOnly = FALSE)

	new /obj/random/backpack(H.loc)
	var/obj/item/storage/backpack/bag
	for(var/obj/item/storage/backpack/b in H.loc)
		bag = b
		break

	if(bag)
		new /obj/random/weapon_and_ammo/concealable(bag)
		new /obj/random/weapon_and_ammo(bag)

	for(var/obj/item/gun/G in bag)
		if(G.slot_flags & SLOT_HOLSTER && !accessory_contents.len)
			accessory_contents += G.type
			qdel(G)
			continue
		if(G.slot_flags & SLOT_BELT && !belt)
			belt = G.type
			qdel(G)
			continue
		if(G.slot_flags & SLOT_BACK && !back)
			back = G.type
			qdel(G)

	if(accessory_contents.len)
		accessory = pick(typesof(/obj/item/clothing/accessory/holster) - typesof(/obj/item/clothing/accessory/holster/thigh/fluff))

	if(!back)
		H.equip_to_slot_or_del(bag, slot_back)
	else
		H.put_in_any_hand_if_possible(bag)

	return ..()

/datum/outfit/admin/syndicate/raider/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	if(!H.shoes)
		var/fallback_type = pick(/obj/item/clothing/shoes/sandals, /obj/item/clothing/shoes/jackboots/toeless, /obj/item/clothing/shoes/laceup/brown, /obj/item/clothing/shoes/laceup)
		H.equip_to_slot_or_del(new fallback_type(H), slot_shoes)

	var/obj/item/storage/wallet/W = H.wear_id
	var/obj/item/card/id/syndicate/raider/passport = new(H.loc)
	imprint_idcard(H, passport)
	if(W)
		W.handle_item_insertion(passport)

/datum/outfit/admin/syndicate/burglar
	name = "Burglar"
	allow_backbag_choice = FALSE

	uniform = list(
		/obj/item/clothing/under/suit_jacket/really_black,
		/obj/item/clothing/under/suit_jacket/charcoal,
		/obj/item/clothing/under/suit_jacket/navy,
		/obj/item/clothing/under/suit_jacket/burgundy
		)

	belt = null
	suit = null

	shoes = list(
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/shoes/laceup/brown
	)

	glasses = list(
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/glasses/sunglasses/aviator
	)

	head = null

	gloves = list(
		/obj/item/clothing/wrists/watch,
		/obj/item/clothing/wrists/watch/silver,
		/obj/item/clothing/wrists/watch/gold,
		/obj/item/clothing/wrists/watch/holo,
		/obj/item/clothing/wrists/watch/leather,
		/obj/item/clothing/wrists/watch/spy
	)

	l_ear = /obj/item/device/radio/headset/burglar
	l_pocket = /obj/item/syndie/teleporter
	r_pocket = /obj/item/device/special_uplink/burglar
	id = /obj/item/storage/wallet

	r_hand = /obj/item/storage/briefcase/black

	backpack_contents = list()

	id_iff = IFF_BURGLAR

/datum/outfit/admin/syndicate/burglar/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/static/list/burglar_guns = list(
		/obj/item/gun/energy/rifle/icelance,
		/obj/item/gun/energy/retro,
		/obj/item/gun/projectile/silenced,
		/obj/item/gun/projectile/colt,
		/obj/item/gun/projectile/colt/super,
		/obj/item/gun/projectile/revolver/lemat
		)

	var/new_gun = pick(burglar_guns)
	var/turf/T = get_turf(H)

	var/obj/item/primary = new new_gun(T)
	var/obj/item/clothing/accessory/holster/armpit/holster

	if(primary.slot_flags & SLOT_HOLSTER)
		holster = new /obj/item/clothing/accessory/holster/armpit(T)
		holster.holstered = primary
		primary.forceMove(holster)
	else if(!H.belt && (primary.slot_flags & SLOT_BELT))
		H.equip_to_slot_or_del(primary, slot_belt)
	else if(!H.back && (primary.slot_flags & SLOT_BACK))
		H.equip_to_slot_or_del(primary, slot_back)
	else
		H.put_in_any_hand_if_possible(primary)

	if(istype(primary, /obj/item/gun/projectile))
		var/obj/item/gun/projectile/bullet_thrower = primary
		var/obj/item/storage/briefcase/B = locate() in H
		if(bullet_thrower.magazine_type)
			new bullet_thrower.magazine_type(B)
			if(prob(20)) //don't want to give them too much
				new bullet_thrower.magazine_type(B)
		else if(bullet_thrower.ammo_type)
			for(var/i in 1 to rand(3, 5) + rand(0, 2))
				new bullet_thrower.ammo_type(B)
		H.put_in_hands(B)

	if(holster)
		var/obj/item/clothing/under/uniform = H.w_uniform
		if(istype(uniform) && uniform.can_attach_accessory(holster))
			uniform.attackby(holster, H)
		else
			H.put_in_any_hand_if_possible(holster)

	var/obj/item/storage/wallet/W = H.wear_id
	var/obj/item/card/id/syndicate/raider/passport = new(H.loc)
	imprint_idcard(H, passport)
	if(W)
		W.handle_item_insertion(passport)


/datum/outfit/admin/syndicate/jockey
	name = "Jockey"
	allow_backbag_choice = FALSE

	uniform = list(
		/obj/item/clothing/under/color/darkred,
		/obj/item/clothing/under/color/red,
		/obj/item/clothing/under/color/lightred
	)

	suit = list(
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/suit/storage/hazardvest/green,
		/obj/item/clothing/suit/storage/hazardvest/red
	)

	back = /obj/item/storage/backpack/duffel/syndie

	belt = /obj/item/storage/belt/utility/very_full
	shoes = /obj/item/clothing/shoes/workboots/all_species
	glasses = null
	head = /obj/item/clothing/head/welding

	gloves = /obj/item/clothing/gloves/yellow // glubbs

	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/device/flashlight = 1,
		/obj/item/card/emag = 1
	)

	l_ear = /obj/item/device/radio/headset/jockey
	r_pocket = /obj/item/device/special_uplink/jockey
	id = /obj/item/storage/wallet

	id_iff = IFF_JOCKEY

/datum/outfit/admin/syndicate/jockey/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/turf/T = get_turf(H)
	var/obj/item/gun/projectile/primary = new /obj/item/gun/projectile/silenced(T)
	var/obj/item/magazine = new primary.magazine_type(T)
	H.equip_to_slot_or_del(magazine, slot_l_store)
	var/obj/item/clothing/accessory/holster/armpit/holster = new /obj/item/clothing/accessory/holster/armpit(T)
	holster.holstered = primary
	primary.forceMove(holster)

	var/obj/item/clothing/under/uniform = H.w_uniform
	uniform.attackby(holster, H)

	var/obj/item/storage/wallet/W = H.wear_id
	var/obj/item/card/id/syndicate/raider/passport = new(H.loc)
	imprint_idcard(H, passport)
	if(W)
		W.handle_item_insertion(passport)

// Non-syndicate antag outfits

/datum/outfit/admin/highlander
	name = "Highlander"

	uniform = /obj/item/clothing/under/kilt
	head = /obj/item/clothing/head/beret/red
	shoes = /obj/item/clothing/shoes/combat
	l_ear = /obj/item/device/radio/headset/heads/captain
	l_hand = /obj/item/material/sword
	l_pocket = /obj/item/pinpointer

	id = /obj/item/card/id/highlander
	id_iff = IFF_HIGHLANDER

/datum/outfit/admin/highlander/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	if(W)
		W.name = "[H.real_name]'s ID"
		W.registered_name = H.real_name

/datum/outfit/admin/syndicate/cultist
	name = "Cultist"
	allow_backbag_choice = FALSE

	head = /obj/item/clothing/head/culthood/alt
	uniform = /obj/item/clothing/under/service_overalls
	suit = /obj/item/clothing/suit/cultrobes/alt
	back = /obj/item/storage/backpack/cultpack
	belt = /obj/item/book/tome
	gloves = null
	shoes = /obj/item/clothing/shoes/cult
	l_ear = null
	id = null
	r_pocket = null
	backpack_contents = null

	r_hand = /obj/item/melee/cultblade

	id_iff = IFF_CULTIST

/datum/outfit/admin/syndicate/cultist/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	return

/datum/outfit/admin/syndicate/cultist/super
	name = "Super Cultist"

	head = /obj/item/clothing/head/helmet/space/cult
	suit = /obj/item/clothing/suit/space/cult

	suit_store = /obj/item/gun/energy/rifle/cult

/datum/outfit/admin/syndicate/raider_techno
	name = "Raider Techno"
	allow_backbag_choice = FALSE

	uniform = /obj/item/clothing/under/syndicate/ninja
	suit = null
	shoes = /obj/item/clothing/shoes/sandals
	head = null

	belt = /obj/item/storage/belt/fannypack/component
	gloves = null
	l_ear = /obj/item/device/radio/headset/bluespace
	l_pocket = /obj/item/technomancer_catalog/apprentice
	r_pocket = null
	id = /obj/item/storage/wallet/random

	accessory = /obj/item/clothing/accessory/storage/webbing
	backpack_contents = list()

	id_iff = IFF_BLUESPACE

/datum/outfit/admin/syndicate/raider_techno/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/list/loadouts = list("Nature", "Techno", "Cobra", "Brawler", "Shimmer")
	if(H.gender in list(FEMALE, PLURAL, NEUTER))
		loadouts += list("Storm", "Sorceress")

	switch(pick(loadouts))
		if("Nature")
			head = /obj/item/clothing/head/wizard/nature
			suit = /obj/item/clothing/suit/wizrobe/nature
			suit_accessory = /obj/item/clothing/accessory/poncho/nature
			back = /obj/item/technomancer_core/safety
		if("Techno")
			head = /obj/item/clothing/head/wizard/techno
			suit = /obj/item/clothing/suit/wizrobe/techno
			uniform = /obj/item/clothing/under/techo
			shoes = /obj/item/clothing/shoes/techno
			back = /obj/item/technomancer_core/recycling
		if("Cobra")
			head = /obj/item/clothing/head/wizard/cobra
			suit = /obj/item/clothing/suit/wizrobe/cobra
			shoes = /obj/item/clothing/shoes/sneakers/hitops/red
			back = /obj/item/technomancer_core/overcharged
		if("Brawler")
			head = /obj/item/clothing/head/wizard/brawler
			suit = /obj/item/clothing/suit/wizrobe/brawler
			shoes = /obj/item/clothing/shoes/sandals/caligae
			back = /obj/item/technomancer_core/bulky
		if("Shimmer")
			head = /obj/item/clothing/head/wizard/shimmer
			suit = /obj/item/clothing/suit/wizrobe/shimmer
			back = /obj/item/technomancer_core/rapid
		if("Storm")
			head = /obj/item/clothing/head/wizard/storm
			suit = /obj/item/clothing/suit/wizrobe/storm
			shoes = /obj/item/clothing/shoes/heels
			back = /obj/item/technomancer_core/unstable
		if("Sorceress")
			head = /obj/item/clothing/head/wizard/sorceress
			suit = /obj/item/clothing/suit/wizrobe/sorceress
			back = /obj/item/technomancer_core/summoner
	return ..()

/datum/outfit/admin/syndicate/raider_techno/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	if(!H.shoes)
		var/fallback_type = pick(/obj/item/clothing/shoes/sandals, /obj/item/clothing/shoes/jackboots/toeless, /obj/item/clothing/shoes/laceup/brown, /obj/item/clothing/shoes/laceup)
		H.equip_to_slot_or_del(new fallback_type(H), slot_shoes)

	var/obj/item/storage/wallet/W = H.wear_id
	var/obj/item/card/id/syndicate/raider/passport = new(H.loc)
	imprint_idcard(H, passport)
	if(W)
		W.handle_item_insertion(passport)

	var/obj/item/technomancer_core/TC = H.back
	if(TC)
		technomancer_belongings.Add(TC)

	var/obj/item/technomancer_catalog/catalog = H.l_store
	if(catalog)
		catalog.bind_to_owner(H)

/datum/outfit/admin/golem
	name = "Bluespace Golem"
	allow_backbag_choice = FALSE

	l_ear = /obj/item/device/radio/headset/bluespace
	id_iff = IFF_BLUESPACE

/datum/outfit/admin/techomancer
	name = "Technomancer"
	allow_backbag_choice = FALSE

	head = /obj/item/clothing/head/chameleon/technomancer
	l_ear = /obj/item/device/radio/headset/bluespace
	uniform = /obj/item/clothing/under/chameleon/technomancer
	suit = /obj/item/clothing/suit/chameleon/technomancer
	belt = /obj/item/device/flashlight
	back = /obj/item/technomancer_core
	shoes = /obj/item/clothing/shoes/chameleon/technomancer

	r_pocket = /obj/item/disposable_teleporter/free
	l_pocket = /obj/item/technomancer_catalog

	id = /obj/item/card/id/bluespace
	id_iff = IFF_BLUESPACE

	var/id_assignment = "Technomagus"

/datum/outfit/admin/techomancer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	if(W)
		W.assignment = id_assignment
		H.set_id_info(W)

	var/obj/item/technomancer_core/TC = H.back
	if(TC)
		technomancer_belongings.Add(TC)

	var/obj/item/technomancer_catalog/catalog = H.l_store
	if(catalog)
		catalog.bind_to_owner(H)

/datum/outfit/admin/techomancer/apprentice
	name = "Technomancer Apprentice"

	head = /obj/item/clothing/head/chameleon/technomancer
	uniform = /obj/item/clothing/under/chameleon/technomancer
	suit = /obj/item/clothing/suit/chameleon/technomancer
	shoes = /obj/item/clothing/shoes/chameleon/technomancer

	l_pocket = /obj/item/technomancer_catalog/apprentice

	id_assignment = "Techno-apprentice"

/datum/outfit/admin/techomancer/apprentice/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return

	to_chat(H, "<b>You are the Technomancer's apprentice! Your goal is to assist them in their mission at the [station_name()].</b>")
	to_chat(H, "<b>Your service has not gone unrewarded, however. Studying under them, you have learned how to use a Manipulation Core \
	of your own.  You also have a catalog, to purchase your own functions and equipment as you see fit.</b>")
	to_chat(H, "<b>It would be wise to speak to your master, and learn what their plans are for today. Your clothing is holographic, you should change its look before leaving.</b>")

/datum/outfit/admin/techomancer/golem
	name = "Technomancer Golem"

	head = null
	l_ear = /obj/item/device/radio/headset/bluespace
	uniform = null
	suit = null
	belt = null
	back = /obj/item/technomancer_core/golem
	shoes = null

	r_pocket = /obj/item/disposable_teleporter/free
	l_pocket = /obj/item/technomancer_catalog/golem

	id = /obj/item/card/id/bluespace
