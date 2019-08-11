/datum/outfit/admin
	var/id_icon

/datum/outfit/admin/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(!visualsOnly)
		if(H.mind)
			H.mind.assigned_role = name
		H.job = name

/datum/outfit/admin/imprint_idcard(mob/living/carbon/human/H, obj/item/weapon/card/id/C)
	..()
	if(id_icon)
		C.icon_state = id_icon

/datum/outfit/admin/lance
	name = "Lancer"

	uniform = /obj/item/clothing/under/lance
	back = /obj/item/weapon/gun/energy/rifle/pulse
	gloves = /obj/item/clothing/gloves/force/basic
	shoes = /obj/item/clothing/shoes/magboots
	belt = /obj/item/weapon/storage/belt/military
	l_ear = /obj/item/device/radio/headset/ert
	id = /obj/item/weapon/card/id/syndicate
	suit_store = /obj/item/weapon/tank/oxygen
	suit = /obj/item/clothing/suit/space/void/lancer
	head = /obj/item/clothing/head/helmet/space/void/lancer
	belt_contents = list(
							/obj/item/weapon/plastique = 1,
							/obj/item/weapon/grenade/frag = 1,
							/obj/item/weapon/melee/energy/sword = 1,
							/obj/item/weapon/shield/energy = 1,
							/obj/item/device/flash = 1,
							/obj/item/weapon/handcuffs/ziptie = 2,
							/obj/item/weapon/melee/baton/loaded = 1,
							/obj/item/weapon/grenade/empgrenade = 1
						)
	var/id_access = "Lancer"

/datum/outfit/admin/lance_operative/get_id_access()
	return get_syndicate_access(id_access)

/datum/outfit/admin/lance_engineer
	name = "Lance Engineer"

	uniform = /obj/item/clothing/under/lance
	back = /obj/item/weapon/gun/projectile/shotgun/pump/combat/sol
	gloves = /obj/item/clothing/gloves/yellow
	shoes = /obj/item/clothing/shoes/magboots
	belt = /obj/item/weapon/storage/belt/utility/full
	l_ear = /obj/item/device/radio/headset/ert
	id = /obj/item/weapon/card/id/syndicate
	suit_store = /obj/item/weapon/tank/oxygen
	suit = /obj/item/clothing/suit/space/void/lancer
	head = /obj/item/clothing/head/helmet/space/void/lancer
	accessory = /obj/item/clothing/accessory/storage/brown_vest
	accessory_contents = list(
								/obj/item/weapon/plastique = 3,
								/obj/item/weapon/grenade/frag = 1,
								/obj/item/device/flash = 1
							)
	belt_contents = list(
							/obj/item/device/multitool = 1
	)
	var/id_access = "Lance Engineer"

/datum/outfit/admin/lance_engineer/get_id_access()
	return get_syndicate_access(id_access)

/datum/outfit/admin/lance_medic
	name = "Lance Medic"

	uniform = /obj/item/clothing/under/lance
	gloves = /obj/item/clothing/gloves/latex/nitrile
	shoes = /obj/item/clothing/shoes/magboots
	belt = /obj/item/weapon/storage/belt/medical
	mask = /obj/item/clothing/mask/surgical
	l_ear = /obj/item/device/radio/headset/ert
	id = /obj/item/weapon/card/id/syndicate
	suit_store = /obj/item/weapon/tank/oxygen
	suit = /obj/item/clothing/suit/space/void/lancer
	head = /obj/item/clothing/head/helmet/space/void/lancer
	accessory = /obj/item/clothing/accessory/holster/thigh
	belt_contents = list(
							/obj/item/device/healthanalyzer = 1,
							/obj/item/weapon/reagent_containers/hypospray/combat = 1,
							/obj/item/weapon/reagent_containers/syringe = 1,
							/obj/item/weapon/personal_inhaler/combat = 1,
							/obj/item/weapon/reagent_containers/personal_inhaler_cartridge/large = 2,
							/obj/item/weapon/reagent_containers/glass/bottle/dexalin_plus = 1,
							/obj/item/weapon/reagent_containers/glass/bottle/epinephrine = 1,
							/obj/item/weapon/reagent_containers/glass/bottle/spaceacillin = 1,
							
						)
	accessory_contents = list(/obj/item/weapon/gun/energy/pulse/pistol = 1)
	var/id_access = "Lance Medic"

/datum/outfit/admin/lance_medic/get_id_access()
	return get_syndicate_access(id_access)

/datum/outfit/admin/lance_operative
	name = "Lance Operative"

	uniform = /obj/item/clothing/under/dress/lance_dress/male
	back = /obj/item/weapon/storage/backpack/satchel
	gloves = /obj/item/clothing/gloves/latex
	shoes = /obj/item/clothing/shoes/laceup
	belt = /obj/item/weapon/storage/belt/utility/full
	l_ear = /obj/item/device/radio/headset/ert
	id = /obj/item/weapon/card/id/syndicate
	suit_store = /obj/item/weapon/tank/oxygen
	suit = /obj/item/clothing/suit/space/void/lancer
	head = /obj/item/clothing/head/helmet/space/void/lancer
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/weapon/gun/energy/pulse/pistol = 1)

	backpack_contents = list(
		/obj/item/device/flash = 1,
		/obj/item/clothing/gloves/yellow = 1
	)
	belt_contents = list(
							/obj/item/device/multitool = 1
	)
	var/id_access = "Lance Operative"

/datum/outfit/admin/lance_operative/get_id_access()
	return get_syndicate_access(id_access)

/datum/outfit/admin/syndicate
	name = "Syndicate Agent"

	uniform = /obj/item/clothing/under/syndicate
	back = /obj/item/weapon/storage/backpack
	belt = /obj/item/weapon/storage/belt/utility/full
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/combat
	l_ear = /obj/item/device/radio/headset/syndicate
	id = /obj/item/weapon/card/id/syndicate
	r_pocket = /obj/item/device/radio/uplink
	backpack_contents = list(
		/obj/item/weapon/storage/box/engineer = 1,
		/obj/item/device/flashlight = 1,
		/obj/item/weapon/card/emag = 1,
		/obj/item/weapon/reagent_containers/food/snacks/donkpocket/sinpocket = 1,
		/obj/item/device/multitool = 1
	)
	var/id_access = "Syndicate Operative"
	var/uplink_uses = 20

/datum/outfit/admin/syndicate/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/device/radio/uplink/U = H.r_store
	if(istype(U))
		U.hidden_uplink.uplink_owner = "[H.key]"
		U.hidden_uplink.uses = uplink_uses

/datum/outfit/admin/syndicate/get_id_access()
	return get_syndicate_access(id_access)


/datum/outfit/admin/syndicate/operative
	name = "Syndicate Operative"

	suit = /obj/item/clothing/suit/space/void/merc
	belt = /obj/item/weapon/storage/belt/military/syndicate
	head = /obj/item/clothing/head/helmet/space/void/merc
	mask = /obj/item/clothing/mask/gas/syndicate
	l_ear = /obj/item/device/radio/headset/syndicate
	glasses = /obj/item/clothing/glasses/night
	shoes = /obj/item/clothing/shoes/magboots
	l_pocket = /obj/item/weapon/pinpointer/nukeop
	l_hand = /obj/item/weapon/tank/jetpack/void

	backpack_contents = list(
		/obj/item/weapon/storage/box/engineer = 1,
		/obj/item/weapon/reagent_containers/pill/cyanide = 1,
		/obj/item/weapon/gun/projectile/automatic/x9 = 1,
		/obj/item/ammo_magazine/c45x = 1,
		/obj/item/weapon/crowbar/red = 1,
		/obj/item/weapon/plastique = 1,
		/obj/item/weapon/reagent_containers/food/snacks/donkpocket/sinpocket = 1,
		/obj/item/device/flashlight = 1,
		/obj/item/clothing/shoes/combat = 1
)


/datum/outfit/admin/syndicate/officer
	name = "Syndicate Officer"

	head = /obj/item/clothing/head/beret
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/havana
	belt = /obj/item/weapon/gun/projectile/deagle
	l_ear = /obj/item/device/radio/headset/syndicate
	l_pocket = /obj/item/weapon/pinpointer/advpinpointer
	r_pocket = null // stop them getting a radio uplink, they get an implant instead

	backpack_contents = list(
		/obj/item/weapon/storage/box/engineer = 1,
		/obj/item/device/flashlight = 1,
		/obj/item/weapon/reagent_containers/pill/cyanide = 1,
		/obj/item/weapon/reagent_containers/food/snacks/donkpocket/sinpocket = 1,
		/obj/item/ammo_magazine/a50 = 2,
		/obj/item/clothing/shoes/magboots = 1,
		/obj/item/weapon/flame/lighter/zippo = 1
	)
	implants = list(
		/obj/item/weapon/implant/explosive
	)
	id_access = "Syndicate Operative Leader"


/datum/outfit/admin/syndicate/spy
	name = "Syndicate Spy"
	uniform = /obj/item/clothing/under/suit_jacket/really_black
	shoes = /obj/item/clothing/shoes/black/noslip
	uplink_uses = 40
	id_access = "Syndicate Agent"

	implants = list(
		/obj/item/weapon/implant/explosive
	)


/datum/outfit/admin/nt
	name = "NanoTrasen Representative"

	uniform = /obj/item/clothing/under/rank/centcom
	back = /obj/item/weapon/storage/backpack/satchel
	gloves = /obj/item/clothing/gloves/white
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/device/radio/headset/heads/hop
	glasses = /obj/item/clothing/glasses/sunglasses
	id = /obj/item/weapon/card/id

	backpack_contents = list(
		/obj/item/weapon/storage/box/engineer = 1
	)

	id_icon = "centcom"
	var/id_access = "NanoTrasen Representative"

/datum/outfit/admin/nt/get_id_access()
	return get_all_accesses() | get_centcom_access(id_access)


/datum/outfit/admin/nt/officer
	name = "NanoTrasen Navy Officer"

	uniform = /obj/item/clothing/under/rank/centcom_officer
	l_ear = /obj/item/device/radio/headset/heads/captain
	head = /obj/item/clothing/head/beret/centcom/officer


/datum/outfit/admin/nt/captain
	name = "NanoTrasen Navy Captain"

	uniform = /obj/item/clothing/under/rank/centcom_captain
	l_ear = /obj/item/device/radio/headset/heads/captain
	head = /obj/item/clothing/head/beret/centcom/captain


/datum/outfit/admin/nt/protection_detail
	name = "ERT Protection Detail"

	uniform = /obj/item/clothing/under/ccpolice
	suit = /obj/item/clothing/suit/storage/vest/heavy/ert/peacekeeper
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/swat/tactical
	l_ear = /obj/item/device/radio/headset/ert
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	head = /obj/item/clothing/head/beret/centcom/officer/civilprotection
	suit_store = /obj/item/weapon/gun/energy/gun
	belt = /obj/item/weapon/storage/belt/security

	backpack_contents = list(
		/obj/item/weapon/storage/box/engineer = 1,
		/obj/item/clothing/head/helmet/swat/peacekeeper = 1,
		/obj/item/clothing/accessory/holster/hip = 1,
		/obj/item/weapon/gun/energy/pistol = 1
	)

	implants = list(
		/obj/item/weapon/implant/loyalty
	)

/datum/outfit/admin/nt/protection_detail/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)

	if(H && H.belt)

		var/obj/item/weapon/reagent_containers/spray/pepper/pepperspray = new(H)
		var/obj/item/weapon/melee/baton/loaded/baton = new(H)
		var/obj/item/weapon/shield/riot/tact/shield = new(H)
		var/obj/item/weapon/grenade/flashbang/flashbang = new(H)
		var/obj/item/weapon/handcuffs/cuffs = new(H)
		var/obj/item/device/flash/flash = new(H)
		var/obj/item/device/flashlight/flare/flare = new(H)

		H.belt.contents += flare
		H.belt.contents += flashbang
		H.belt.contents += cuffs
		H.belt.contents += pepperspray
		H.belt.contents += flash
		H.belt.contents += baton
		H.belt.contents += shield


/datum/outfit/admin/nt/ert_commander
	name = "ERT Commander"

	uniform = /obj/item/clothing/under/rank/centcom_commander
	suit = /obj/item/clothing/suit/storage/vest/heavy/ert/commander
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/swat
	l_ear = /obj/item/device/radio/headset/ert
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	head = /obj/item/clothing/head/beret/centcom/commander

	backpack_contents = list(
		/obj/item/weapon/storage/fancy/cigar = 1,
		/obj/item/weapon/flame/lighter/zippo = 1,
		/obj/item/clothing/accessory/medal/gold/heroism = 1
	)

	implants = list(
		/obj/item/weapon/implant/loyalty
	)


/datum/outfit/admin/nt/odinsec
	name = "NTCC Odin Security Specialist"

	uniform = /obj/item/clothing/under/ccpolice
	suit = /obj/item/clothing/suit/storage/vest/heavy/ert/peacekeeper
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/swat/tactical
	l_ear = /obj/item/device/radio/headset/ert
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/tactical
	mask = /obj/item/clothing/mask/gas/tactical
	head = /obj/item/clothing/head/helmet/swat/peacekeeper
	back = null
	r_pocket = /obj/item/weapon/handcuffs/ziptie
	l_hand = /obj/item/weapon/shield/riot/tact
	suit_store = /obj/item/weapon/gun/energy/gun
	belt = /obj/item/weapon/storage/belt/security

	backpack_contents = null

	implants = list(
		/obj/item/weapon/implant/loyalty
	)

/datum/outfit/admin/nt/odinsec/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)

	if(H && H.w_uniform)

		var/obj/item/clothing/accessory/holster/hip/holster = new(H)
		var/obj/item/weapon/gun/projectile/automatic/x9/weapon = new(H)
		holster.contents += weapon
		holster.holstered = weapon
		var/obj/item/clothing/under/rank/U = H.w_uniform
		U.attach_accessory(null, holster)

	if(H && H.belt)

		var/obj/item/weapon/reagent_containers/spray/pepper/pepperspray = new(H)
		var/obj/item/weapon/melee/baton/loaded/baton = new(H)
		var/obj/item/weapon/grenade/chem_grenade/gas/gasgrenade = new(H)
		var/obj/item/device/flash/flash = new(H)
		var/obj/item/ammo_magazine/c45x/mag1 = new(H)
		var/obj/item/ammo_magazine/c45x/mag2 = new(H)

		H.belt.contents += mag1
		H.belt.contents += mag2
		H.belt.contents += gasgrenade
		H.belt.contents += pepperspray
		H.belt.contents += flash
		H.belt.contents += baton

/datum/outfit/admin/nt/specops
	name = "Special Operations Officer"

	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/armor/swat/officer
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	l_ear = /obj/item/device/radio/headset/ert
	glasses = /obj/item/clothing/glasses/eyepatch/hud/thermal
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/havana
	head = /obj/item/clothing/head/helmet/space/deathsquad/beret
	belt = /obj/item/weapon/gun/energy/pulse/pistol
	r_pocket = /obj/item/weapon/flame/lighter/zippo

	implants = list(
		/obj/item/weapon/implant/loyalty
	)

	id_access = "Death Commando"


/datum/outfit/admin/pirate
	name = "Pirate"

	uniform = /obj/item/clothing/under/pirate
	shoes = /obj/item/clothing/shoes/brown
	head = /obj/item/clothing/head/bandana
	glasses = /obj/item/clothing/glasses/eyepatch
	r_hand = /obj/item/weapon/melee/energy/sword/pirate


/datum/outfit/admin/spacepirate
	name = "Space Pirate"

	uniform = /obj/item/clothing/under/pirate
	suit = /obj/item/clothing/suit/space/pirate
	shoes = /obj/item/clothing/shoes/brown
	head = /obj/item/clothing/head/helmet/space/pirate
	glasses = /obj/item/clothing/glasses/eyepatch
	r_hand = /obj/item/weapon/melee/energy/sword/pirate


/datum/outfit/admin/sovietsoldier
	name = "Soviet Soldier"

	uniform = /obj/item/clothing/under/soviet
	shoes = /obj/item/clothing/shoes/black
	head = /obj/item/clothing/head/ushanka/grey


/datum/outfit/admin/sovietsoldier
	name = "Soviet Admiral"

	uniform = /obj/item/clothing/under/soviet
	suit = /obj/item/clothing/suit/hgpirate
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/combat
	head = /obj/item/clothing/head/hgpiratecap
	belt = /obj/item/weapon/gun/projectile/revolver/mateba
	l_ear = /obj/item/device/radio/headset/heads/captain
	glasses = /obj/item/clothing/glasses/eyepatch/hud/thermal
	id = /obj/item/weapon/card/id

/datum/outfit/admin/sovietsoldier/get_id_assignment()
	return "Admiral"

/datum/outfit/admin/sovietsoldier/get_id_rank()
	return "Admiral"


/datum/outfit/admin/maskedkiller
	name = "Masked Killer"

	uniform = /obj/item/clothing/under/overalls
	suit = /obj/item/clothing/suit/apron
	shoes = /obj/item/clothing/shoes/white
	gloves = /obj/item/clothing/gloves/latex
	mask = /obj/item/clothing/mask/surgical
	head = /obj/item/clothing/head/welding
	l_ear = /obj/item/device/radio/headset
	glasses = /obj/item/clothing/glasses/thermal/plain/monocle
	l_pocket = /obj/item/weapon/material/knife
	r_pocket = /obj/item/weapon/scalpel
	r_hand = /obj/item/weapon/material/twohanded/fireaxe
	id = null

/datum/outfit/admin/maskedkiller/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	for(var/obj/item/carried_item in H.contents)
		if(!istype(carried_item, /obj/item/weapon/implant))//If it's not an implant.
			carried_item.add_blood(H)//Oh yes, there will be blood...


/datum/outfit/admin/assassin
	name = "Assassin"

	uniform = /obj/item/clothing/under/suit_jacket
	suit = /obj/item/clothing/suit/wcoat
	shoes = /obj/item/clothing/shoes/black
	gloves = /obj/item/clothing/gloves/black
	l_ear = /obj/item/device/radio/headset
	glasses = /obj/item/clothing/glasses/sunglasses
	l_pocket = /obj/item/weapon/melee/energy/sword
	r_pocket = /obj/item/weapon/cloaking_device
	id = /obj/item/weapon/card/id/syndicate
	pda = /obj/item/device/pda/heads

/datum/outfit/admin/assassin/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/weapon/storage/secure/briefcase/sec_briefcase = new(H)
	for(var/obj/item/briefcase_item in sec_briefcase)
		qdel(briefcase_item)
	for(var/i=3, i>0, i--)
		sec_briefcase.contents += new /obj/item/weapon/spacecash/c1000
	sec_briefcase.contents += new /obj/item/weapon/gun/energy/crossbow
	sec_briefcase.contents += new /obj/item/weapon/gun/projectile/revolver/mateba
	sec_briefcase.contents += new /obj/item/ammo_magazine/a357
	sec_briefcase.contents += new /obj/item/weapon/plastique
	H.equip_to_slot_or_del(sec_briefcase, slot_l_hand)

/datum/outfit/admin/assassin/get_id_access()
	return get_all_station_access()


/datum/outfit/admin/random_employee
	name = "Random Employee"

/datum/outfit/admin/random_employee/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(!visualsOnly)
		//Select a random job, set the assigned_role / job var and equip it
		var/datum/job/job = SSjobs.GetRandomJob()
		var/alt_title = null
		if(job.alt_titles && prob(50))
			alt_title = pick(job.alt_titles)

		if(H.mind)
			H.mind.assigned_role = alt_title ? alt_title : job.title
		H.job = alt_title ? alt_title : job.title

		job.equip(H, FALSE, FALSE, alt_title)


/datum/outfit/admin/random
	name = "Random Civilian"

	uniform = "suit selection"
	shoes = "shoe selection"
	l_ear = /obj/item/device/radio/headset
	back = list(
		/obj/item/weapon/storage/backpack,
		/obj/item/weapon/storage/backpack/satchel_norm,
		/obj/item/weapon/storage/backpack/satchel,
		/obj/item/weapon/storage/backpack/duffel,
		/obj/item/weapon/storage/backpack/duffel
	)

/datum/outfit/admin/random/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(!visualsOnly)
		if(prob(10)) //Equip something smokable
			var/path = pick(list(
				/obj/item/clothing/mask/smokable/pipe,
				/obj/item/clothing/mask/smokable/pipe/cobpipe,
				/obj/item/weapon/storage/fancy/cigar,
				/obj/item/weapon/storage/fancy/cigarettes
			))
			H.equip_or_collect(new path(), slot_wear_mask)

		if(prob(20)) //Equip some headgear
			var/datum/gear/G = gear_datums[pick(list("cap selection","beret, red","hat selection","hijab selection","turban selection"))]
			H.equip_or_collect(G.spawn_random(), slot_head)

		if(prob(20)) //Equip some sunglasses
			var/path = pick(list(
				/obj/item/clothing/glasses/eyepatch,
				/obj/item/clothing/glasses/regular,
				/obj/item/clothing/glasses/gglasses,
				/obj/item/clothing/glasses/regular/hipster,
				/datum/gear/eyes/glasses/monocle,
				/datum/gear/eyes/shades/aviator,
				/datum/gear/eyes/glasses/fakesun
			))
			H.equip_or_collect(new path(), slot_glasses)

		if(prob(20)) //Equip some gloves
			var/datum/gear/G = gear_datums["gloves selection"]
			H.equip_or_collect(G.spawn_random(), slot_gloves)


/datum/outfit/admin/random/visitor
	name = "Random Visitor"

	id = /obj/item/weapon/card/id
	pda = /obj/item/device/pda

/datum/outfit/admin/random/visitor/get_id_assignment()
	return "Visitor"

/datum/outfit/admin/random/visitor/get_id_rank()
	return "Visitor"