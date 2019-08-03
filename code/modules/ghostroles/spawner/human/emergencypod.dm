/datum/ghostspawner/human/rescuepodsurv
	short_name = "rescuepodsurv"
	name = "Rescue Pod Survivor"
	desc = "You managed to get into a rescue pod and landed somewhere on a asteroid."
	tags = list("External")

	enabled = FALSE
	req_perms = null
	max_count = 1

	//Vars related to human mobs
	outfit = /datum/outfit/admin/random/visitor
	possible_species = list("Human","Skrell","Tajara","Unathi")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = TRUE

	assigned_role = "Pod Survivor"
	special_role = "Pod Survivor"
	respawn_flag = CREW

	mob_name = FALSE

	enable_chance = 10

/datum/ghostspawner/human/rescuepodsurv/New()
	. = ..()
	var/t = pick(list("star","priest","rep","smuggler"))
	if(t == "star")
		welcome_message = "You are a stranded starlet!<br>You were relaxing comfortably in your cryo pod as tragedy struck - the pilot of your luxury yacht fell asleep under some mysterious circumstances. You were unceremoniously stuffed into an escape pod, and left to wander in space. What a despicable, low-quality plot to get rid of you. Should've chosen murder instead - you certainly know you'll convince someone nice to lend you a shuttle."
		outfit = /datum/outfit/admin/pod/star
		possible_genders = list(FEMALE)
		possible_species = list("Human","Skrell","Tajara")
	else if(t == "priest")
		welcome_message = "You are a stranded Trinary Perfection priest!<br>You were traveling around space on your small shuttle, preaching peacefully of the future divinity of the synthetics, and the grand purpose of mankind as the ones to help them achieve that goal. Unfortunately, Dominians don't seem to be as peaceful in disagreeing with your views - and had to evacuate your shot-down ship. Have your prayers to the Divines helped you now?"
		outfit = /datum/outfit/admin/pod/priest
		possible_species = list("Human")
	else if(t == "rep")
		welcome_message = "You are a stranded Idris Incorporated representative!<br>You were traveling back from your business in Sol to the Mendell City HQ. Unfortunately, after a very unusual set of circumstances, the engine broke down just almost as you got back. You're stranded somewhere nearby - perhaps your excellent customer service and negotiation skills might get you a ride back to Mendell?"
		outfit = /datum/outfit/admin/pod/rep
		possible_species = list("Human")
	else
		welcome_message = "You are a stranded drugs smuggler!<br>You shouldn't have had the fucking Tajara pilot your ship. <i>Of course</i> we crashed into a rock. Good thing you've got some of the stuff with you while evacuating - maybe you'll crash somewhere you could sell it for a ticket back?"
		outfit = /datum/outfit/admin/pod/smuggler
		possible_species = list("Human","Skrell","Unathi")

/datum/ghostspawner/human/rescuepodsurv/select_spawnpoint(var/use=TRUE)
	//Randomly select a Turf on the asteroid.
	var/turf/T = pick_area_turf(/area/mine/unexplored)
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
	suit = /obj/item/clothing/suit/space/emergency
	suit_store = /obj/item/weapon/tank/emergency_oxygen/double
	l_ear = /obj/item/device/radio/headset
	back = /obj/item/weapon/storage/backpack

/datum/outfit/admin/pod/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	//Turn on the oxygen tank
	H.internal = H.s_store
	if(istype(H.internal,/obj/item/weapon/tank) && H.internals)
		H.internals.icon_state = "internal1"

/datum/outfit/admin/pod/star
	name = "RescuePod - Star"

	uniform = "dress selection"
	shoes = "flats selection"
	id = /obj/item/weapon/card/id

	backpack_contents = list(
		/obj/item/weapon/lipstick/random = 2,
		/obj/item/weapon/haircomb/random = 1,
		/obj/item/weapon/spacecash/c1000 = 2,
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
	id = /obj/item/weapon/card/id
	pda = /obj/item/device/pda/chaplain

	backpack_contents = list(
		/obj/item/weapon/storage/bible/fluff/oscar_bible = 1,
		/obj/item/device/oxycandle = 1,
		/obj/item/airbubble = 1
	)	

/datum/outfit/admin/pod/priest/get_id_assignment()
	return "Priest"

/datum/outfit/admin/pod/priest/get_id_rank()
	return "Priest"


/datum/outfit/admin/pod/rep
	name = "RescuePod - IdrisRep"

	uniform = /obj/item/clothing/under/rank/idris
	id = /obj/item/weapon/card/id/idris
	pda = /obj/item/device/pda/lawyer
	shoes = /obj/item/clothing/shoes/laceup
	glasses = /obj/item/clothing/glasses/sunglasses/big
	l_hand =  /obj/item/weapon/storage/briefcase
	backpack_contents = list(
		/obj/item/clothing/head/beret/liaison = 1,
		/obj/item/device/camera = 1,
		/obj/item/weapon/gun/energy/pistol = 1,
		/obj/item/device/oxycandle = 1,
		/obj/item/airbubble = 1
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
		/obj/item/weapon/reagent_containers/inhaler/space_drugs = 3,
		/obj/item/weapon/reagent_containers/inhaler/hyperzine = 2,
		/obj/item/weapon/reagent_containers/inhaler/soporific = 1,
		/obj/item/weapon/gun/projectile/leyon = 1,
		/obj/item/device/oxycandle = 1,
		/obj/item/airbubble = 1
	)

/datum/outfit/admin/pod/smuggler/get_id_assignment()
	return "Merchant"

/datum/outfit/admin/pod/smuggler/get_id_rank()
	return "Merchant"