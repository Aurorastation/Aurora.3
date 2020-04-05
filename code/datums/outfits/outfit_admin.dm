/datum/outfit/admin
	var/id_icon

/datum/outfit/admin/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(!visualsOnly)
		if(H.mind)
			H.mind.assigned_role = name
		H.job = name

/datum/outfit/admin/imprint_idcard(mob/living/carbon/human/H, obj/item/card/id/C)
	..()
	if(id_icon)
		C.icon_state = id_icon

/datum/outfit/admin/lance
	name = "Lancer"

	uniform = /obj/item/clothing/under/lance
	back = /obj/item/gun/energy/rifle/pulse
	gloves = /obj/item/clothing/gloves/force/basic
	shoes = /obj/item/clothing/shoes/magboots
	belt = /obj/item/storage/belt/military
	l_ear = /obj/item/device/radio/headset/ert
	id = /obj/item/card/id/syndicate
	suit_store = /obj/item/tank/oxygen
	suit = /obj/item/clothing/suit/space/void/lancer
	head = /obj/item/clothing/head/helmet/space/void/lancer
	belt_contents = list(
							/obj/item/plastique = 1,
							/obj/item/grenade/frag = 1,
							/obj/item/melee/energy/sword = 1,
							/obj/item/shield/energy = 1,
							/obj/item/device/flash = 1,
							/obj/item/handcuffs/ziptie = 2,
							/obj/item/melee/baton/loaded = 1,
							/obj/item/grenade/empgrenade = 1
						)
	var/id_access = "Lancer"

/datum/outfit/admin/lance_operative/get_id_access()
	return get_syndicate_access(id_access)

/datum/outfit/admin/lance_engineer
	name = "Lance Engineer"

	uniform = /obj/item/clothing/under/lance
	back = /obj/item/gun/projectile/shotgun/pump/combat/sol
	gloves = /obj/item/clothing/gloves/yellow
	shoes = /obj/item/clothing/shoes/magboots
	belt = /obj/item/storage/belt/utility/full
	l_ear = /obj/item/device/radio/headset/ert
	id = /obj/item/card/id/syndicate
	suit_store = /obj/item/tank/oxygen
	suit = /obj/item/clothing/suit/space/void/lancer
	head = /obj/item/clothing/head/helmet/space/void/lancer
	accessory = /obj/item/clothing/accessory/storage/brown_vest
	accessory_contents = list(
								/obj/item/plastique = 3,
								/obj/item/grenade/frag = 1,
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
	belt = /obj/item/storage/belt/medical
	mask = /obj/item/clothing/mask/surgical
	l_ear = /obj/item/device/radio/headset/ert
	id = /obj/item/card/id/syndicate
	suit_store = /obj/item/tank/oxygen
	suit = /obj/item/clothing/suit/space/void/lancer
	head = /obj/item/clothing/head/helmet/space/void/lancer
	accessory = /obj/item/clothing/accessory/holster/thigh
	belt_contents = list(
							/obj/item/device/healthanalyzer = 1,
							/obj/item/reagent_containers/hypospray/combat = 1,
							/obj/item/reagent_containers/syringe = 1,
							/obj/item/personal_inhaler/combat = 1,
							/obj/item/reagent_containers/personal_inhaler_cartridge/large = 2,
							/obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
							/obj/item/reagent_containers/glass/bottle/norepinephrine = 1,
							/obj/item/reagent_containers/glass/bottle/deltamivir = 1,
							/obj/item/reagent_containers/glass/bottle/thetamycin = 1,

						)
	accessory_contents = list(/obj/item/gun/energy/pulse/pistol = 1)
	var/id_access = "Lance Medic"

/datum/outfit/admin/lance_medic/get_id_access()
	return get_syndicate_access(id_access)

/datum/outfit/admin/lance_operative
	name = "Lance Operative"

	uniform = /obj/item/clothing/under/dress/lance_dress/male
	back = /obj/item/storage/backpack/satchel
	gloves = /obj/item/clothing/gloves/latex
	shoes = /obj/item/clothing/shoes/laceup
	belt = /obj/item/storage/belt/utility/full
	l_ear = /obj/item/device/radio/headset/ert
	id = /obj/item/card/id/syndicate
	suit_store = /obj/item/tank/oxygen
	suit = /obj/item/clothing/suit/space/void/lancer
	head = /obj/item/clothing/head/helmet/space/void/lancer
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/energy/pulse/pistol = 1)

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

/datum/outfit/admin/nt
	name = "NanoTrasen Representative"

	uniform = /obj/item/clothing/under/rank/centcom
	back = /obj/item/storage/backpack/satchel
	gloves = /obj/item/clothing/gloves/white
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/device/radio/headset/ert/ccia
	glasses = /obj/item/clothing/glasses/sunglasses
	id = /obj/item/card/id

	backpack_contents = list(
		/obj/item/storage/box/engineer = 1
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
	suit_store = /obj/item/gun/energy/gun
	belt = /obj/item/storage/belt/security

	backpack_contents = list(
		/obj/item/storage/box/engineer = 1,
		/obj/item/clothing/head/helmet/swat/peacekeeper = 1,
		/obj/item/clothing/accessory/holster/hip = 1,
		/obj/item/gun/energy/pistol = 1
	)

	implants = list(
		/obj/item/implant/mindshield
	)

/datum/outfit/admin/nt/protection_detail/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)

	if(H && H.belt)

		var/obj/item/reagent_containers/spray/pepper/pepperspray = new(H)
		var/obj/item/melee/baton/loaded/baton = new(H)
		var/obj/item/shield/riot/tact/shield = new(H)
		var/obj/item/grenade/flashbang/flashbang = new(H)
		var/obj/item/handcuffs/cuffs = new(H)
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
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/white
	l_ear = /obj/item/device/radio/headset/ert
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	head = /obj/item/clothing/head/beret/centcom/commander

	backpack_contents = list(
		/obj/item/storage/fancy/cigar = 1,
		/obj/item/flame/lighter/zippo = 1,
		/obj/item/clothing/accessory/medal/gold/heroism = 1
	)

	implants = list(
		/obj/item/implant/mindshield
	)

/datum/outfit/admin/nt/tcfl_legate
	name = "TCFL Legate"

	uniform = /obj/item/clothing/under/legion/legate
	suit = /obj/item/clothing/suit/storage/vest/legion/legate
	gloves = /obj/item/clothing/gloves/swat/tactical
	shoes = /obj/item/clothing/shoes/swat/ert
	l_ear = /obj/item/device/radio/headset/legion
	head = /obj/item/clothing/head/legion/legate
	glasses = /obj/item/clothing/glasses/sunglasses/aviator
	id = /obj/item/card/id/distress/legion
	belt = /obj/item/storage/belt/security/tactical
	r_pocket = /obj/item/clothing/mask/gas/tactical
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/revolver/mateba = 1)
	back = null

	backpack_contents = null

	belt_contents = list(
		/obj/item/melee/energy/sword/knife = 1,
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/ammo_magazine/a454 = 2,
		/obj/item/shield/energy/legion = 1
	)

/datum/outfit/admin/nt/cciaa
	name = "CCIA Agent"

	uniform = /obj/item/clothing/under/rank/centcom_officer
	suit = /obj/item/clothing/suit/storage/toggle/liaison
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/white
	l_ear = /obj/item/device/radio/headset/ert/ccia
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	head = /obj/item/clothing/head/beret/centcom/officer
	l_pocket = /obj/item/reagent_containers/spray/pepper
	r_pocket = /obj/item/device/taperecorder/cciaa
	l_hand = /obj/item/storage/lockbox/cciaa
	pda = /obj/item/device/pda/central

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
	r_pocket = /obj/item/handcuffs/ziptie
	l_hand = /obj/item/shield/riot/tact
	suit_store = /obj/item/gun/energy/gun
	belt = /obj/item/storage/belt/security

	backpack_contents = null

	belt_contents = list(
		/obj/item/reagent_containers/spray/pepper = 1,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/grenade/chem_grenade/gas = 1,
		/obj/item/device/flash = 1,
		/obj/item/ammo_magazine/c45x = 2
	)

	implants = list(
		/obj/item/implant/mindshield
	)

/datum/outfit/admin/nt/odinsec/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)

	if(H && H.w_uniform)

		var/obj/item/clothing/accessory/holster/hip/holster = new(H)
		var/obj/item/gun/projectile/automatic/x9/weapon = new(H)
		holster.contents += weapon
		holster.holstered = weapon
		var/obj/item/clothing/under/rank/U = H.w_uniform
		U.attach_accessory(null, holster)

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
	belt = /obj/item/gun/energy/pulse/pistol
	r_pocket = /obj/item/flame/lighter/zippo

	implants = list(
		/obj/item/implant/mindshield
	)

	id_access = "Death Commando"

/datum/outfit/admin/nt/fib
	name = "FIB Agent"

	uniform = /obj/item/clothing/under/rank/fib
	suit = /obj/item/clothing/suit/storage/fib
	gloves = /obj/item/clothing/gloves/black

	l_pocket = /obj/item/reagent_containers/spray/pepper
	r_pocket = /obj/item/device/taperecorder/cciaa
	l_hand = /obj/item/storage/lockbox/cciaa/fib

	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/sec/lethal = 1)

	backpack_contents = list(
		/obj/item/storage/box/engineer = 1,
		/obj/item/device/flash = 1,
		/obj/item/handcuffs = 1
	)

/datum/outfit/admin/nt/fib/guard
	name = "FIB Escort"

	suit = /obj/item/clothing/suit/armor/vest/fib
	belt =/obj/item/storage/belt/security
	r_pocket = null
	l_hand = null
	belt_contents = list(
		/obj/item/device/flash = 1,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/handcuffs = 2,
		/obj/item/ammo_magazine/c45m = 2
	)

	backpack_contents = list(
		/obj/item/storage/box/engineer = 1,
		/obj/item/storage/box/zipties = 1,
		/obj/item/clothing/head/helmet = 1
	)


/datum/outfit/admin/pirate
	name = "Pirate"

	uniform = /obj/item/clothing/under/pirate
	shoes = /obj/item/clothing/shoes/brown
	head = /obj/item/clothing/head/bandana
	glasses = /obj/item/clothing/glasses/eyepatch
	r_hand = /obj/item/melee/energy/sword/pirate


/datum/outfit/admin/spacepirate
	name = "Space Pirate"

	uniform = /obj/item/clothing/under/pirate
	suit = /obj/item/clothing/suit/space/pirate
	shoes = /obj/item/clothing/shoes/brown
	head = /obj/item/clothing/head/helmet/space/pirate
	glasses = /obj/item/clothing/glasses/eyepatch
	r_hand = /obj/item/melee/energy/sword/pirate


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
	belt = /obj/item/gun/projectile/revolver/mateba
	l_ear = /obj/item/device/radio/headset/heads/captain
	glasses = /obj/item/clothing/glasses/eyepatch/hud/thermal
	id = /obj/item/card/id

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
	l_pocket = /obj/item/material/knife
	r_pocket = /obj/item/surgery/scalpel
	r_hand = /obj/item/material/twohanded/fireaxe
	id = null

/datum/outfit/admin/maskedkiller/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	for(var/obj/item/carried_item in H.contents)
		if(!istype(carried_item, /obj/item/implant))//If it's not an implant.
			carried_item.add_blood(H)//Oh yes, there will be blood...


/datum/outfit/admin/assassin
	name = "Assassin"

	uniform = /obj/item/clothing/under/suit_jacket
	suit = /obj/item/clothing/suit/wcoat
	shoes = /obj/item/clothing/shoes/black
	gloves = /obj/item/clothing/gloves/black
	l_ear = /obj/item/device/radio/headset
	glasses = /obj/item/clothing/glasses/sunglasses
	l_pocket = /obj/item/melee/energy/sword
	r_pocket = /obj/item/cloaking_device
	id = /obj/item/card/id/syndicate
	pda = /obj/item/device/pda/heads

/datum/outfit/admin/assassin/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/storage/secure/briefcase/sec_briefcase = new(H)
	for(var/obj/item/briefcase_item in sec_briefcase)
		qdel(briefcase_item)
	for(var/i=3, i>0, i--)
		sec_briefcase.contents += new /obj/item/spacecash/c1000
	sec_briefcase.contents += new /obj/item/gun/energy/crossbow
	sec_briefcase.contents += new /obj/item/gun/projectile/revolver/mateba
	sec_briefcase.contents += new /obj/item/ammo_magazine/a357
	sec_briefcase.contents += new /obj/item/plastique
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
		/obj/item/storage/backpack,
		/obj/item/storage/backpack/satchel_norm,
		/obj/item/storage/backpack/satchel,
		/obj/item/storage/backpack/duffel,
		/obj/item/storage/backpack/duffel
	)

/datum/outfit/admin/random/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(!visualsOnly)
		if(prob(10)) //Equip something smokable
			var/path = pick(list(
				/obj/item/clothing/mask/smokable/pipe,
				/obj/item/clothing/mask/smokable/pipe/cobpipe,
				/obj/item/storage/fancy/cigar,
				/obj/item/storage/fancy/cigarettes
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

	id = /obj/item/card/id
	pda = /obj/item/device/pda

/datum/outfit/admin/random/visitor/get_id_assignment()
	return "Visitor"

/datum/outfit/admin/random/visitor/get_id_rank()
	return "Visitor"
