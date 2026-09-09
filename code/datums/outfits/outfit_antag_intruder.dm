/obj/outfit/antag/intruder
	name = "Intruder Outfit"
	uniform = /obj/item/clothing/under/color/black
	suit = null
	back = null
	belt = null
	l_pocket = null
	r_pocket = null
	pda = /obj/item/modular_computer/handheld/pda/civilian
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = null
	head = null
	glasses = null
	mask = null
	l_ear = /obj/item/radio/headset
	id = null

/obj/outfit/antag/intruder/pre_equip(var/mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	// Ensure they don't have an ID card yet
	for(var/obj/item/card/id/id in H.contents)
		qdel(id)
