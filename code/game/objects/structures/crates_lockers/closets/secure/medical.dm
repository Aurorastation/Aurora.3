/obj/structure/closet/secure_closet/medical1
	name = "medicine closet"
	desc = "Filled with medical junk."
	icon_state = "med"
	req_access = list(access_medical_equip)

/obj/structure/closet/secure_closet/medical1/fill()
	..()
	new /obj/item/storage/box/syringes(src)
	new /obj/item/reagent_containers/dropper(src)
	new /obj/item/reagent_containers/dropper(src)
	new /obj/item/reagent_containers/glass/beaker(src)
	new /obj/item/reagent_containers/glass/beaker(src)
	new /obj/item/reagent_containers/glass/bottle/inaprovaline(src)
	new /obj/item/reagent_containers/glass/bottle/inaprovaline(src)
	new /obj/item/reagent_containers/glass/bottle/antitoxin(src)
	new /obj/item/reagent_containers/glass/bottle/antitoxin(src)

/obj/structure/closet/secure_closet/medical2
	name = "anesthetics closet"
	desc = "Used to knock people out."
	icon_state = "med"
	req_access = list(access_surgery)

/obj/structure/closet/secure_closet/medical2/fill()
	new /obj/item/tank/anesthetic(src)
	new /obj/item/tank/anesthetic(src)
	new /obj/item/tank/anesthetic(src)
	new /obj/item/clothing/mask/breath/medical(src)
	new /obj/item/clothing/mask/breath/medical(src)
	new /obj/item/clothing/mask/breath/medical(src)

/obj/structure/closet/secure_closet/medical3
	name = "medical equipment locker"
	req_access = list(access_medical_equip)
	icon_state = "med"

/obj/structure/closet/secure_closet/medical3/fill()
	if(prob(50))
		new /obj/item/storage/backpack/medic(src)
	else
		new /obj/item/storage/backpack/satchel/med(src)
	new /obj/item/storage/backpack/duffel/med(src)
	new /obj/item/clothing/head/nursehat (src)
	switch(pick("blue", "green", "purple"))
		if ("blue")
			new /obj/item/clothing/under/rank/medical/surgeon/pmc(src)
			new /obj/item/clothing/head/surgery/pmc(src)
		if ("green")
			new /obj/item/clothing/under/rank/medical/surgeon/idris(src)
			new /obj/item/clothing/head/surgery/idris(src)
		if ("purple")
			new /obj/item/clothing/under/rank/medical/surgeon/zeng(src)
			new /obj/item/clothing/head/surgery/zeng(src)
	switch(pick("blue", "green", "purple"))
		if ("blue")
			new /obj/item/clothing/under/rank/medical/surgeon/pmc(src)
			new /obj/item/clothing/head/surgery/pmc(src)
		if ("green")
			new /obj/item/clothing/under/rank/medical/surgeon/idris(src)
			new /obj/item/clothing/head/surgery/idris(src)
		if ("purple")
			new /obj/item/clothing/under/rank/medical/surgeon/zeng(src)
			new /obj/item/clothing/head/surgery/zeng(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/pmc(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/idris(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/zeng(src)
	new /obj/item/clothing/head/headmirror
	new /obj/item/clothing/shoes/medical(src)
	new /obj/item/device/radio/headset/headset_med(src)
	new /obj/item/device/radio/headset/headset_med/alt(src)
	new /obj/item/clothing/glasses/hud/health/aviator(src)
	new /obj/item/clothing/glasses/eyepatch/hud/medical(src)

/obj/structure/closet/secure_closet/medical_fr
	name = "first responder's locker"
	desc = "An immobile, card-locked storage unit containing all the necessary equipment for a first responder."
	req_access = list(access_first_responder)
	icon_state = "med"

/obj/structure/closet/secure_closet/medical_fr/fill()
	..()
	new /obj/item/storage/backpack/satchel/med(src)
	new /obj/item/storage/backpack/duffel/med(src)
	new /obj/item/clothing/head/hardhat/first_responder(src)
	new /obj/item/device/radio/headset/headset_med(src)
	new /obj/item/clothing/glasses/hud/health(src)
	new /obj/item/storage/backpack/medic(src)
	new /obj/item/clothing/suit/storage/medical_chest_rig(src)
	new /obj/item/clothing/under/rank/medical/first_responder(src)
	new /obj/item/clothing/under/rank/medical/first_responder/zeng(src)
	new /obj/item/clothing/under/rank/medical/first_responder/pmc(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/device/flashlight/pen(src)
	new /obj/item/clothing/accessory/stethoscope(src)
	new /obj/item/storage/belt/medical/first_responder(src)
	new /obj/item/device/gps(src)
	new /obj/item/reagent_containers/hypospray(src)
	new /obj/item/taperoll/medical(src)
	new /obj/item/device/radio/med(src)
	new /obj/item/roller(src)
	new /obj/item/crowbar/red(src)
	new /obj/item/clothing/mask/gas/alt(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/auto_cpr(src)
	new /obj/item/clothing/suit/storage/toggle/fr_jacket(src)
	new /obj/item/clothing/suit/storage/toggle/fr_jacket/zeng(src)
	new /obj/item/clothing/suit/storage/toggle/fr_jacket/pmc(src)


/obj/structure/closet/secure_closet/CMO
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmo"

/obj/structure/closet/secure_closet/CMO/fill()
	if(prob(50))
		new /obj/item/storage/backpack/medic(src)
	else
		new /obj/item/storage/backpack/satchel/med(src)
	new /obj/item/storage/backpack/duffel/med(src)
	new /obj/item/clothing/suit/bio_suit/cmo(src)
	new /obj/item/clothing/head/bio_hood/cmo(src)
	new /obj/item/clothing/shoes/medical(src)
	new /obj/item/clothing/under/rank/chief_medical_officer(src)
	new /obj/item/clothing/gloves/latex/nitrile(src)
	new /obj/item/device/radio/headset/heads/cmo(src)
	new /obj/item/device/radio/headset/heads/cmo/alt(src)
	new /obj/item/device/megaphone/med(src)
	new /obj/item/device/flash(src)
	new /obj/item/reagent_containers/hypospray/cmo(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/cmo(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/cmoalt(src)
	new /obj/item/storage/box/inhalers(src)
	new /obj/item/clothing/glasses/hud/health/aviator(src)
	new /obj/item/storage/box/fancy/keypouch/med(src)
	new /obj/item/device/advanced_healthanalyzer(src)
	new /obj/item/gun/energy/disruptorpistol/miniature(src)

/obj/structure/closet/secure_closet/CMO2
	name = "chief medical officer's attire"
	req_access = list(access_cmo)
	icon_state = "cmo"

/obj/structure/closet/secure_closet/CMO2/fill()
	new /obj/item/storage/backpack/medic(src)
	new /obj/item/storage/backpack/satchel/med(src)
	new /obj/item/clothing/under/rank/medical/surgeon/pmc(src)
	new /obj/item/clothing/head/surgery/pmc(src)
	new /obj/item/clothing/under/rank/medical/surgeon/idris(src)
	new /obj/item/clothing/under/rank/medical/surgeon/idris(src)
	new /obj/item/clothing/under/rank/medical/surgeon/zeng(src)
	new /obj/item/clothing/under/rank/medical/surgeon/zeng(src)
	new /obj/item/clothing/under/rank/chief_medical_officer(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/cmo(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/cmoalt(src)
	new /obj/item/clothing/shoes/brown	(src)
	new /obj/item/device/radio/headset/heads/cmo(src)


/obj/structure/closet/secure_closet/animal
	name = "animal control closet"
	req_access = list(access_surgery)


/obj/structure/closet/secure_closet/animal/fill()
	..()
	new /obj/item/device/assembly/signaler(src)
	new /obj/item/device/radio/electropack(src)
	new /obj/item/device/radio/electropack(src)
	new /obj/item/device/radio/electropack(src)


/obj/structure/closet/secure_closet/chemical
	name = "chemistry equipment closet"
	desc = "Contains equipment useful to chemists."
	icon_state = "med"
	icon_door = "chemical"
	req_access = list(access_pharmacy)

/obj/structure/closet/secure_closet/chemical/fill()
	..()
	new /obj/item/storage/box/pillbottles(src)
	new /obj/item/storage/box/pillbottles(src)
	new /obj/item/storage/box/spraybottles(src)
	new /obj/item/storage/box/spraybottles(src)
	new /obj/item/storage/box/inhalers(src)
	new /obj/item/storage/box/inhalers_auto(src)
	new /obj/item/storage/box/autoinjectors(src)
	new /obj/item/storage/box/syringes(src)
	new /obj/item/storage/box/beakers(src)
	new /obj/item/storage/box/beakers(src)
	new /obj/item/storage/bag/chemistry(src)
	new /obj/item/storage/bag/chemistry(src)
