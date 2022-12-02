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
	l_ear = list(
		/obj/item/device/radio/headset,
		/obj/item/device/radio/headset/alt,
	)
	back = list(
		/obj/item/storage/backpack,
		/obj/item/storage/backpack/satchel,
		/obj/item/storage/backpack/satchel/leather,
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
				/obj/item/storage/box/fancy/cigarettes/cigar,
				/obj/item/storage/box/fancy/cigarettes
			))
			H.equip_or_collect(new path(), slot_wear_mask)

		if(prob(20)) //Equip some headgear
			var/datum/gear/G = gear_datums[pick(list("cap selection","beret, red","hat selection","hijab selection","turban selection"))]
			H.equip_or_collect(G.spawn_random(), slot_head)

		if(prob(20)) //Equip some sunglasses
			var/path = pick(list(
				/obj/item/clothing/glasses/eyepatch,
				/obj/item/clothing/glasses/regular,
				/obj/item/clothing/glasses/regular/hipster,
				/obj/item/clothing/glasses/monocle,
				/obj/item/clothing/glasses/sunglasses/aviator,
				/obj/item/clothing/glasses/sunglasses/prescription
			))
			H.equip_or_collect(new path(), slot_glasses)

		if(prob(20)) //Equip some gloves
			var/datum/gear/G = gear_datums["gloves selection"]
			H.equip_or_collect(G.spawn_random(), slot_gloves)

/datum/outfit/admin/random/visitor
	name = "Random Visitor"

	id = /obj/item/card/id
	pda = /obj/item/modular_computer/handheld/pda/civilian

/datum/outfit/admin/random/visitor/get_id_assignment()
	return "Visitor"

/datum/outfit/admin/random/visitor/get_id_rank()
	return "Visitor"

/datum/outfit/admin/virtual_reality
	name = "Virtual Reality Outfit"
	uniform = /obj/item/clothing/under/chameleon
	suit = /obj/item/clothing/suit/chameleon
	back = /obj/item/storage/backpack/chameleon
	gloves = /obj/item/clothing/gloves/chameleon
	shoes = /obj/item/clothing/shoes/chameleon
	head = /obj/item/clothing/head/chameleon
	mask = /obj/item/clothing/mask/chameleon
	glasses = /obj/item/clothing/glasses/chameleon
