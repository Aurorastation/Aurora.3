//Due to how large this one is it gets its own file
/datum/job/chaplain
	title = "Chaplain"
	flag = CHAPLAIN
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#90524b"
	access = list(access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels)
	minimal_access = list(access_morgue, access_chapel_office, access_crematorium)
	alt_titles = list("Presbyter","Rabbi","Imam","Priest","Shaman","Counselor")
	outfit = /datum/outfit/job/chaplain

/datum/outfit/job/chaplain
	name = "Chaplain"
	jobtype = /datum/job/chaplain
	uniform = /obj/item/clothing/under/rank/chaplain
	shoes = /obj/item/clothing/shoes/black
	headset = /obj/item/device/radio/headset/headset_service
	bowman = /obj/item/device/radio/headset/headset_service/alt
	double_headset = /obj/item/device/radio/headset/alt/double/service
	tab_pda = /obj/item/modular_computer/handheld/pda/civilian/chaplain
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/chaplain
	tablet = /obj/item/modular_computer/handheld/preset/civilian/chaplain

/datum/outfit/job/chaplain/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	if(visualsOnly)
		return

	var/obj/item/storage/bible/B = new /obj/item/storage/bible(get_turf(H)) //BS12 EDIT
	var/obj/item/storage/S = locate() in H.contents
	if(S && istype(S))
		B.forceMove(S)

	var/datum/religion/religion = SSrecords.religions[H.religion]
	if (religion)

		if(religion.name == "None" || religion.name == "Other")
			B.verbs += /obj/item/storage/bible/proc/Set_Religion
			return 1

		B.icon_state = religion.book_sprite
		B.name = religion.book_name
		SSticker.Bible_icon_state = religion.book_sprite
		SSticker.Bible_item_state = religion.book_sprite
		SSticker.Bible_name = religion.book_name
		return 1
