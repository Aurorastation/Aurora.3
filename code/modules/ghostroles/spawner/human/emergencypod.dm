/datum/ghostspawner/human/rescuepodsurv
	short_name = "rescuepodsurv"
	name = "Rescue Pod Survivor"
	desc = "You managed to get into a rescue pod and landed somewhere on an asteroid in the sector."
	tags = list("External")

	enabled = FALSE
	req_perms = null
	max_count = 1

	//Vars related to human mobs
	outfit = /datum/outfit/admin/random/visitor
	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN,SPECIES_UNATHI,SPECIES_VAURCA_WARRIOR,SPECIES_VAURCA_WORKER)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Pod Survivor"
	special_role = "Pod Survivor"
	respawn_flag = null

	mob_name = null

/datum/ghostspawner/human/rescuepodsurv/New()
	. = ..()
	var/t = pick(list("star", "priest", "rep", "smuggler", "hunter", "occultist", "pmc", "tcfl", "fsf", "scc", "fib"))
	if(t == "star")
		welcome_message = "You are a stranded star!<br>You were relaxing comfortably in your cryo pod as tragedy struck - the pilot of your luxury yacht fell asleep under some mysterious circumstances. You were unceremoniously stuffed into an escape pod, and left to wander in space. What a despicable, low-quality plot to get rid of you. Should've chosen murder instead - you certainly know you'll convince someone nice to lend you a shuttle."
		outfit = /datum/outfit/admin/pod/star
		possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	else if(t == "priest")
		welcome_message = "You are a stranded Trinary Perfection priest!<br>You were traveling around space on your small shuttle, preaching peacefully of the future divinity of the synthetics, and the grand purpose of mankind as the ones to help them achieve that goal. Unfortunately, Dominians don't seem to be as peaceful in disagreeing with your views - and had to evacuate your shot-down ship. Have your prayers to the Divines helped you now?"
		outfit = /datum/outfit/admin/pod/priest
		possible_species = list(SPECIES_HUMAN)
	else if(t == "rep")
		welcome_message = "You are a stranded Idris Incorporated representative!<br>You were traveling back from your business in Sol to the Mendell City HQ. Unfortunately, after a very unusual set of circumstances, the engine broke down just almost as you got back. You're stranded somewhere nearby - perhaps your excellent customer service and negotiation skills might get you a ride back to Mendell?"
		outfit = /datum/outfit/admin/pod/rep
		possible_species = list(SPECIES_HUMAN)
	else if(t == "hunter")
		welcome_message = "You are a stranded space fauna hunter!<br>Your ship has been attacked by a wild megacarp - a rare, almost mythical animal... with very expensive trophies. In this encounter, you lost. But the hunt lives on! You just need to find a new spacefaring vessel!"
		outfit = /datum/outfit/admin/pod/hunter
		possible_species = list(SPECIES_HUMAN) // no ayyliums because the frontier rig only fits humans. i wish i could put unathi in here tho
	else if(t == "occultist")
		welcome_message = "You are a stranded occultist!<br>This unfortunate turn of events was in the cards. Nonetheless, you managed to save your most prized possessions - your magical deck of cards and your ominous, definitely magical robes. The cards have also told you that your bad luck will surely be followed by good fortune."
		outfit = /datum/outfit/admin/pod/occultist
	else if(t == "pmc")
		welcome_message = "You are a stranded Eridani paramilitary sergeant!<br>You aren't getting paid enough for this shit. Where's the pickup shuttle?"
		outfit = /datum/outfit/admin/pod/pmc
		possible_species = list(SPECIES_HUMAN) // no cycler in the pod, spawns in a voidsuit
	else if(t == "tcfl")
		welcome_message = "You are a stranded member of the Tau Ceti Foreign Legion!<br>Perhaps there was a training accident or maybe something went wrong during a routine operation in the Romanovich Cloud. The Prefect will never let you hear the end of this..."
		outfit = /datum/outfit/admin/pod/tcfl
		possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_DIONA) // TCFL accepts everyone. G1 and G2 have been excluded because they can't wear the hardsuit, which has the suit cooler.
	else if(t == "fsf")
		welcome_message = "You are a stranded Petty Officer of the Free Solarian Fleets!<br>Your skiff out of the FSFV Sforza was on a routine patrol when an accident or an attack forced you to abandon ship. Thankfully, you seem to be in friendly territory..."
		outfit = /datum/outfit/admin/pod/fsf
		possible_species = list(SPECIES_HUMAN)
	else if(t == "scc")
		welcome_message = "You are a stranded Stellar Corporate Conglomerate low-level functionary!<br>A routine inspection of SCC assets in the Romanovich cloud turned into disaster when your shuttle's reactor suddenly and mysteriously failed. You narrowly escaped with your life. Worst of all? You lost your paperwork."
		outfit = /datum/outfit/admin/pod/scc
		possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	else if(t == "fib")
		welcome_message = "You are a stranded Federal Investigation Bureau Agent!<br>What was supposed to be a standard investigation turned into a nightmare when the vessel you were supposed to board opened fire! You just managed to reach an escape pod before your own ship was turned into smoldering rubble. You really need some coffee."
		outfit = /datum/outfit/admin/pod/fib
		possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)

	else
		welcome_message = "You are a stranded drugs smuggler!<br>You shouldn't have had the fucking Tajara pilot your ship. <i>Of course</i> we crashed into a rock. Good thing you've got some of the stuff with you while evacuating - maybe you'll crash somewhere you could sell it for a ticket back?"
		outfit = /datum/outfit/admin/pod/smuggler
		possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_UNATHI)

/datum/ghostspawner/human/rescuepodsurv/select_spawnlocation(var/use=TRUE)
	var/list/possible_areas = list(/area/exoplanet/barren/asteroid)
	var/turf/T = pick_area_turf(pick(possible_areas))
	if(!use) //If we are just checking if we can get one, return the turf we found
		return T

	if(!T) //If we didnt find a turn, return now
		return null

	//Otherwise spawn a droppod at that location
	var/x = T.x
	var/y = T.y
	var/z = T.z

	new /datum/random_map/droppod(null,x,y,z,supplied_drop="custom",do_not_announce=TRUE,automated=FALSE)
	return get_turf(locate(x+1,y+1,z)) //Get the turf again, so we end up inside of the pod - There is probs a better way to do this


//Base equipment for the pod (softsuit + emergency oxygen)
/datum/outfit/admin/pod
	head = /obj/item/clothing/head/helmet/space/emergency
	mask = /obj/item/clothing/mask/breath
	id = /obj/item/card/id
	suit = /obj/item/clothing/suit/space/emergency
	suit_store = /obj/item/tank/emergency_oxygen/double
	l_ear = /obj/item/device/radio/headset
	back = /obj/item/storage/backpack

/datum/outfit/admin/pod/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	//Turn on the oxygen tank
	H.internal = H.s_store
	if(istype(H.internal,/obj/item/tank) && H.internals)
		H.internals.icon_state = "internal1"
	//Spawn a drill
	new /obj/item/pickaxe/drill(H.loc)
	new /obj/item/device/gps(H.loc)
	new /obj/item/device/flashlight/flare/mech(H.loc) // spawns an active flare
	new /obj/item/clothing/suit/space/emergency(H.loc)        // weak softsuit, so if for whatever reason 
	new /obj/item/clothing/head/helmet/space/emergency(H.loc) // the survivor spawns with no EVA gear,
	new /obj/item/tank/emergency_oxygen/double(H.loc)         // they can use this, and not just die in space

/datum/outfit/admin/pod/star
	name = "RescuePod - Star"

	uniform = "suit selection"
	shoes = "oxford shoe selection"

	backpack_contents = list(
		/obj/item/lipstick/random = 2,
		/obj/item/haircomb/random = 1,
		/obj/item/spacecash/c1000 = 2,
		/obj/item/device/oxycandle = 1,
		/obj/item/airbubble = 1
	)

/datum/outfit/admin/pod/star/get_id_assignment()
	return "Visitor"

/datum/outfit/admin/pod/star/get_id_rank()
	return "Visitor"


/datum/outfit/admin/pod/priest
	name = "RescuePod - Priest"

	uniform = /obj/item/clothing/under/rank/chaplain
	shoes = /obj/item/clothing/shoes/black
	pda = /obj/item/modular_computer/handheld/pda/civilian/chaplain

	backpack_contents = list(
		/obj/item/device/oxycandle = 1,
		/obj/item/airbubble = 1
	)

/datum/outfit/admin/pod/priest/get_id_assignment()
	return "Priest"

/datum/outfit/admin/pod/priest/get_id_rank()
	return "Priest"


/datum/outfit/admin/pod/rep
	name = "RescuePod - IdrisRep"

	head = /obj/item/clothing/head/beret/corporate/idris
	uniform = /obj/item/clothing/under/rank/liaison/idris
	suit = /obj/item/clothing/suit/storage/liaison/idris
	id = /obj/item/card/id/idris
	pda = /obj/item/modular_computer/handheld/pda/civilian/lawyer
	shoes = /obj/item/clothing/shoes/laceup
	glasses = /obj/item/clothing/glasses/sunglasses/big
	l_hand =  /obj/item/storage/briefcase
	accessory = /obj/item/clothing/accessory/tie/corporate/idris
	suit_accessory = /obj/item/clothing/accessory/pin/corporate/idris
	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/gun/energy/pistol = 1,
		/obj/item/device/oxycandle = 1,
		/obj/item/airbubble = 1,
		/obj/item/stamp/idris = 1
	)

/datum/outfit/admin/pod/rep/get_id_assignment()
	return "Corporate Liaison (Idris)"

/datum/outfit/admin/pod/rep/get_id_rank()
	return "Corporate Liaison"


/datum/outfit/admin/pod/smuggler
	name = "RescuePod - Smuggler"

	shoes = "shoe selection"
	uniform = "pants selection"

	backpack_contents = list(
		/obj/item/reagent_containers/inhaler/space_drugs = 3,
		/obj/item/reagent_containers/inhaler/hyperzine = 2,
		/obj/item/reagent_containers/inhaler/soporific = 1,
		/obj/item/gun/projectile/leyon = 1,
		/obj/item/device/oxycandle = 1,
		/obj/item/airbubble = 1
	)

/datum/outfit/admin/pod/smuggler/get_id_assignment()
	return "Merchant"

/datum/outfit/admin/pod/smuggler/get_id_rank()
	return "Merchant"


/datum/outfit/admin/pod/hunter
	name = "RescuePod - Hunter"
	head = null
	suit = null
	suit_store = null // the rig has an inbuilt tank
	l_hand = /obj/item/material/twohanded/spear/plasteel
	shoes = /obj/item/clothing/shoes/jackboots
	id = /obj/item/card/id
	uniform = "pants selection"
	back = /obj/item/rig/gunslinger

/datum/outfit/admin/pod/hunter/get_id_assignment()
	return "Visitor"

/datum/outfit/admin/pod/hunter/get_id_rank()
	return "Visitor"


/datum/outfit/admin/pod/occultist
	name = "RescuePod - Occultist"
	id = /obj/item/card/id
	shoes = /obj/item/clothing/shoes/laceup
	uniform = "suit selection"
	backpack_contents = list(
		/obj/item/clothing/head/fake_culthood = 1,
		/obj/item/clothing/suit/fake_cultrobes = 1,
		/obj/item/deck/tarot = 1,
		/obj/item/device/oxycandle = 1,
		/obj/item/airbubble = 1
	)

/datum/outfit/admin/pod/occultist/get_id_assignment()
	return "Visitor"

/datum/outfit/admin/pod/occultist/get_id_rank()
	return "Visitor"


/datum/outfit/admin/pod/pmc
	name = "RescuePod - PMCG Sergeant"
	head = /obj/item/clothing/head/helmet/space/void/cruiser
	suit = /obj/item/clothing/suit/space/void/cruiser
	suit_store = /obj/item/tank/oxygen
	shoes = /obj/item/clothing/shoes/jackboots
	id = /obj/item/card/id/pmc
	pda = /obj/item/modular_computer/handheld/pda/security
	belt = /obj/item/gun/energy/gun/nuclear
	uniform = /obj/item/clothing/under/rank/security/pmc

/datum/outfit/admin/pod/pmc/get_id_assignment()
	return "Security Officer (PMCG)"

/datum/outfit/admin/pod/pmc/get_id_rank()
	return "Security Officer"

/datum/outfit/admin/pod/tcfl
	name = "RescuePod - TCFL Member"
	head = /obj/item/clothing/head/beret/legion/field
	l_ear = /obj/item/device/radio/headset/legion
	glasses = /obj/item/clothing/glasses/sunglasses/aviator
	suit = /obj/item/clothing/suit/storage/vest/legion
	suit_store = /obj/item/gun/energy/blaster/carbine
	back = /obj/item/rig/retro // has an oxygen tank built in
	belt = /obj/item/storage/belt/security/tactical
	gloves = /obj/item/clothing/gloves/swat/ert
	shoes = /obj/item/clothing/shoes/swat/ert
	id = /obj/item/card/id/distress/legion
	uniform = /obj/item/clothing/under/legion
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/energy/blaster/revolver = 1)
	l_hand =  /obj/item/material/twohanded/pike/flag
	r_hand = /obj/item/storage/backpack/legion

	belt_contents = list(
		/obj/item/melee/energy/sword/knife = 1,
		/obj/item/shield/riot/tact/legion = 1,
		/obj/item/grenade/flashbang = 1,
		/obj/item/device/flashlight/flare = 1,
		/obj/item/device/radio = 1
	)

/datum/outfit/admin/pod/tcfl/get_id_assignment()
	return "TCFL"

/datum/outfit/admin/pod/tcfl/get_id_rank()
	return "TCFL"

/datum/outfit/admin/pod/fsf
	name = "RescuePod - FSF Crewman"
	uniform = /obj/item/clothing/under/rank/sol/
	shoes = /obj/item/clothing/shoes/jackboots
	belt = /obj/item/storage/belt/military
	back = /obj/item/storage/backpack/satchel/norm
	head = /obj/item/clothing/head/helmet/space/void/sol
	suit = /obj/item/clothing/suit/space/void/sol
	suit_store = /obj/item/tank/oxygen
	id = /obj/item/card/id/distress/fsf
	accessory = /obj/item/clothing/accessory/holster/hip/
	accessory_contents = list(/obj/item/gun/projectile/pistol/sol = 1)


	belt_contents = list(
		/obj/item/melee/energy/sword/knife/sol = 1,
		/obj/item/ammo_magazine/mc9mm = 1,
		/obj/item/device/flashlight/flare = 1,
		/obj/item/device/radio = 1
	)

	backpack_contents = list(
		/obj/item/clothing/head/sol = 1
	)

/datum/outfit/admin/pod/fsf/get_id_assignment()
	return "Free Solarian Fleets Crewman"

/datum/outfit/admin/pod/fsf/get_id_rank()
	return "Free Solarian Fleets Crewman"

/datum/outfit/admin/pod/scc
	name = "RescuePod - SCC"

	uniform = /obj/item/clothing/under/rank/scc
	back = /obj/item/storage/backpack/satchel
	shoes = /obj/item/clothing/shoes/laceup
	glasses = /obj/item/clothing/glasses/sunglasses
	l_hand =  /obj/item/storage/briefcase
	back = /obj/item/storage/backpack/satchel
	accessory = /obj/item/clothing/accessory/holster/hip/
	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/gun/energy/repeater = 1,
		/obj/item/device/oxycandle = 1,
		/obj/item/airbubble = 1
	)



/datum/outfit/admin/pod/scc/get_id_assignment()
	return "Stellar Corporate Conglomerate Functionary"

/datum/outfit/admin/pod/scc/get_id_rank()
	return "Stellar Corporate Conglomerate Functionary"

/datum/outfit/admin/pod/fib
	name = "RescuePod - FIB" // Doctor Pavel, I'm FIB.

	uniform = /obj/item/clothing/under/rank/fib
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/black
	l_pocket = /obj/item/reagent_containers/spray/pepper
	glasses = /obj/item/clothing/glasses/sunglasses
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/sec/lethal = 1)
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(
    	/obj/item/device/camera = 1,
		/obj/item/clothing/suit/storage/toggle/fib = 1,
		/obj/item/handcuffs = 1,
		/obj/item/device/oxycandle = 1,
		/obj/item/airbubble = 1,
		/obj/item/ammo_magazine/c45m = 1
	)



/datum/outfit/admin/pod/fib/get_id_assignment()
	return "Federal Investigation Bureau Agent"

/datum/outfit/admin/pod/fib/get_id_rank()
	return "Federal Investigation Bureau Agent"


/datum/ghostspawner/human/rescuepodsurv/burglar
	short_name = "burglarpod"
	name = "Burglar"
	desc = "Your last attempt at petty theft went awry, and now you're heading toward an asteroid in a ratty escape pod."

/datum/ghostspawner/human/rescuepodsurv/burglar/New()
	welcome_message = "You're a petty criminal on the run from the law!<br>After a failed bit of theft and larceny, you've found yourself in an escape pod hurtling toward the [station_name()]. You'll probably end up incarcerated or dead, but...with a great risk comes great rewards. Maybe you can make a big score after all?"
	outfit = /datum/outfit/admin/pod/burglar

/datum/outfit/admin/pod/burglar
	name = "RescuePod - Burglar"

	uniform = list(
		/obj/item/clothing/under/suit_jacket/really_black,
		/obj/item/clothing/under/suit_jacket/charcoal,
		/obj/item/clothing/under/suit_jacket/navy,
		/obj/item/clothing/under/suit_jacket/burgundy
		)

	belt = null

	shoes = list(
		/obj/item/clothing/shoes/laceup/all_species,
		/obj/item/clothing/shoes/laceup/brown/all_species
	)

	glasses = list(
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/glasses/sunglasses/aviator
	)

	gloves = list(
		/obj/item/clothing/wrists/watch,
		/obj/item/clothing/wrists/watch/silver,
		/obj/item/clothing/wrists/watch/gold,
		/obj/item/clothing/wrists/watch/holo,
		/obj/item/clothing/wrists/watch/leather,
		/obj/item/clothing/wrists/watch/spy
	)

	l_pocket = /obj/item/syndie/teleporter
	r_pocket = /obj/item/device/special_uplink/burglar
	id = /obj/item/storage/wallet

	r_hand = /obj/item/storage/briefcase/black

	backpack_contents = list()

/datum/outfit/admin/pod/burglar/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if (visualsOnly)
		return

	var/static/list/burglar_guns = list(
		/obj/item/gun/energy/rifle/icelance,
		/obj/item/gun/energy/retro,
		/obj/item/gun/projectile/silenced,
		/obj/item/gun/projectile/colt,
		/obj/item/gun/projectile/revolver/lemat
		)

	var/new_gun = pick(burglar_guns)
	var/obj/item/primary = new new_gun(H.loc)
	var/obj/item/clothing/accessory/holster/armpit/holster

	if(primary.slot_flags & SLOT_HOLSTER)
		holster = new /obj/item/clothing/accessory/holster/armpit(H.loc)
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
	passport.name = "[H.real_name]'s Passport"
	if(W)
		W.handle_item_insertion(passport)

	burglars.add_antagonist(H.mind, TRUE, TRUE, FALSE, TRUE, TRUE)
