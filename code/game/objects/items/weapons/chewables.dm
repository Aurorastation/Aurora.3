/obj/item/clothing/mask/chewable
	name = "chewable item master"
	desc = "if you are holding this, ahelp it."
	icon = 'icons/obj/clothing/masks.dmi'
	body_parts_covered = 0

	var/type_butt = null
	var/chem_volume = 0
	var/chewtime = 0
	var/brand
	var/list/filling = list()

obj/item/clothing/mask/chewable/New()
	..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15
	for(var/R in filling)
		reagents.add_reagent(R, filling[R])

/obj/item/clothing/mask/chewable/equipped(var/mob/living/user, var/slot)
	..()
	if(slot == slot_wear_mask)
		var/mob/living/carbon/human/C = user
		if(C.check_has_mouth())
			START_PROCESSING(SSprocessing, src)
		else
			to_chat(user, "<span class='notice'>You don't have a mouth, and can't make much use of \the [src].</span>")

/obj/item/clothing/mask/chewable/dropped()
	STOP_PROCESSING(SSprocessing, src)
	..()

obj/item/clothing/mask/chewable/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/item/clothing/mask/chewable/proc/chew(amount)
	chewtime -= amount
	if(reagents && reagents.total_volume)
		if(ishuman(loc))
			var/mob/living/carbon/human/C = loc
			if (src == C.wear_mask && C.check_has_mouth())
				reagents.trans_to_mob(C, REM, CHEM_INGEST, 0.2)
		else
			STOP_PROCESSING(SSprocessing, src)

/obj/item/clothing/mask/chewable/process()
	chew(1)
	if(chewtime < 1)
		spitout()

/obj/item/clothing/mask/chewable/tobacco
	name = "wad"
	desc = "A chewy wad of tobacco. Cut in long strands and treated with syrups so it doesn't taste like a ash-tray when you stuff it into your face."
	throw_speed = 0.5
	icon_state = "chew"
	type_butt = /obj/item/trash/spitwad
	w_class = 1
	slot_flags = SLOT_EARS | SLOT_MASK
	chem_volume = 50
	chewtime = 300
	brand = "tobacco"

/obj/item/trash/spitwad
	name = "spit wad"
	desc = "A disgusting spitwad."
	icon_state = "spit-chew"

/obj/item/clothing/mask/chewable/proc/spitout(var/mob/user, var/no_message)
	STOP_PROCESSING(SSprocessing, src)
	if (type_butt)
		var/obj/item/butt = new type_butt(get_turf(src))
		transfer_fingerprints_to(butt)
		butt.color = color
		if(brand)
			butt.desc += " This one is \a [brand]."
		if(ismob(loc))
			var/mob/living/M = loc
			if (!no_message)
				to_chat(M, "<span class='notice'>You spit out the [name].</span>")
		qdel(src)

/obj/item/clothing/mask/chewable/tobacco/lenni
	name = "chewing tobacco"
	desc = "A chewy wad of tobacco. Cut in long strands and treated with syrups so it tastes less like a ash-tray when you stuff it into your face."
	filling = list("nicotine" = 2)

/obj/item/clothing/mask/chewable/tobacco/redlady
	name = "chewing tobacco"
	desc = "A chewy wad of fine tobacco. Cut in long strands and treated with syrups so it doesn't taste like a ash-tray when you stuff it into your face"
	filling = list("nicotine" = 2)

/obj/item/clothing/mask/chewable/tobacco/nico
	name = "nicotine gum"
	desc = "A chewy wad of synthetic rubber, laced with nicotine. Possibly the least disgusting method of nicotine delivery."
	icon_state = "nic_gum"
	type_butt = /obj/item/trash/spitgum
/obj/item/clothing/mask/chewable/tobacco/nico/New()
	..()
	reagents.add_reagent("nicotine", 2)
	color = reagents.get_color()

/obj/item/clothing/mask/chewable/candy
	name = "wad"
	desc = "A chewy wad of wadding material."
	throw_speed = 0.5
	icon_state = "chew"
	type_butt = /obj/item/trash/spitgum
	w_class = 1
	slot_flags = SLOT_EARS | SLOT_MASK
	chem_volume = 50
	chewtime = 300
	filling = list("sugar" = 2)



/obj/item/trash/spitgum
	name = "old gum"
	desc = "A disgusting chewed up wad of gum."
	icon_state = "spit-gum"

/obj/item/trash/lollibutt
	name = "popsicle stick"
	desc = "A popsicle stick devoid of pop."
	icon_state = "pop-stick"

/obj/item/clothing/mask/chewable/candy/gum
	name = "chewing gum"
	desc = "A chewy wad of fine synthetic rubber and artificial flavoring."
	icon_state = "gum"
	item_state = "gum"

/obj/item/clothing/mask/chewable/candy/gum/New()
	..()
	reagents.add_reagent(pick("banana","berryjuice","grapejuice","lemonjuice","limejuice","orangejuice","watermelonjuice"),10)
	color = reagents.get_color()

/obj/item/clothing/mask/chewable/candy/gum/verb/blowbubble()
	set name = "Blow bubble"
	set category = "Object"


	if (ismob(usr))
		var/mob/M = usr
		var/blowposition = M.loc
		if (M.loc != blowposition)
			to_chat(M, "<span class='notice'>You moved, popping your bubble!</span>")
			spitout()
		else
			src.visible_message("[M.name] blows a bubble, what a cool cat!.", "You blow a bubble!.")
		
	


/obj/item/clothing/mask/chewable/candy/lolli
	name = "lollipop"
	desc = "A simple artificially flavored sphere of sugar on a handle. Colloquially known as a sucker. Allegedly one is born every minute."
	type_butt = /obj/item/trash/lollibutt
	icon_state = "lollipop"
	item_state = "lollipop"

/obj/item/clothing/mask/chewable/candy/lolli/New()
	..()
	reagents.add_reagent(pick("banana","berryjuice","grapejuice","lemonjuice","limejuice","orangejuice","watermelonjuice"),20)
	color = reagents.get_color()

/obj/item/clothing/mask/chewable/candy/lolli/meds
	name = "lollipop"
	desc = "A sucrose sphere on a small handle, it has been infused with medication."
	type_butt = /obj/item/trash/lollibutt
	icon_state = "lollipop"

/obj/item/clothing/mask/chewable/candy/lolli/meds/New()
	..()
	reagents.add_reagent(pick("banana","berryjuice","grapejuice","lemonjuice","limejuice","orangejuice","watermelonjuice"),4)
	color = reagents.get_color()

/obj/item/clothing/mask/chewable/candy/lolli/weak_meds
	name = "medicine lollipop"
	desc = "A sucrose sphere on a small handle, it has been infused with medication."
	filling = list("sugar" = 6)

/obj/item/clothing/mask/chewable/candy/lolli/weak_meds/New()
	..()
	var/datum/reagent/payload = pick(list(
				"dylovene",
				"inaprovaline"))
	reagents.add_reagent(payload, 15)
	color = reagents.get_color()
	desc = "[desc]. This one is labeled '[initial(payload.name)]'"