/mob/proc/changeling_equip_clothing(var/list/stuff_to_equip, var/cost)
	var/datum/changeling/changeling = changeling_power(cost,1,100,CONSCIOUS)
	if(!changeling)
		return

	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/M = src

	var/success = FALSE

	to_chat(M, SPAN_NOTICE("We begin growing our new equipment..."))

	var/list/grown_items_list = list()
	for(var/clothing_type in stuff_to_equip)
		if(do_after(src, 1 SECOND))
			var/obj/item/clothing/C = new clothing_type
			M.equip_to_appropriate_slot(C)
			grown_items_list.Add("\a [C]")
			playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
			success = TRUE

	var/feedback = english_list(grown_items_list)

	to_chat(M, SPAN_NOTICE("We have grown [feedback]."))

	if(success)
		changeling.use_charges(10)
	return success

/datum/power/changeling/fabricate_clothing
	name = "Fabricate Clothing"
	desc = "We reform our flesh to resemble various cloths, leathers, and other materials, allowing us to quickly create a disguise.  \
	We cannot be relieved of this clothing by others."
	helptext = "The disguise we create offers no defensive ability.  Each equipment slot that is empty will be filled with fabricated equipment. \
	To remove our new fabricated clothing, use this ability again."
	genomecost = 1
	verbpath = /mob/proc/changeling_fabricate_clothing

//Grows biological versions of chameleon clothes.
/mob/proc/changeling_fabricate_clothing()
	set category = "Changeling"
	set name = "Fabricate Clothing (10)"

	var/static/list/changeling_fabricated_clothing = list(
		/obj/item/clothing/under/chameleon/changeling,
		/obj/item/clothing/head/chameleon/changeling,
		/obj/item/clothing/suit/chameleon/changeling,
		/obj/item/clothing/shoes/chameleon/changeling,
		/obj/item/clothing/gloves/chameleon/changeling,
		/obj/item/clothing/mask/chameleon/changeling,
		/obj/item/clothing/glasses/chameleon/changeling,
		/obj/item/storage/backpack/chameleon/changeling,
		/obj/item/storage/belt/chameleon/changeling,
		/obj/item/card/id/syndicate/changeling
	)

	if(changeling_equip_clothing(changeling_fabricated_clothing, cost = 10))
		return TRUE
	return FALSE

/obj/item/clothing/under/chameleon/changeling
	name = "malformed flesh"
	desc = "The flesh all around us has grown a new layer of cells that can shift appearance and create a biological fabric that cannot be distinguished from \
	ordinary cloth, allowing us to make ourselves appear to wear almost anything."
	origin_tech = list() //The base chameleon items have origin technology, which we will inherit if we don't null out this variable.
	canremove = 0 //Since this is essentially flesh impersonating clothes, tearing someone's skin off as if it were clothing isn't possible.

/obj/item/clothing/under/chameleon/changeling/dropped(mob/user)
	. = ..()
	visible_message(SPAN_DANGER("With a sickening crunch, \the [src] falls apart!"))
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/clothing/under/chameleon/changeling/emp_act(severity) //As these are purely organic, EMP does nothing to them.
	return

/obj/item/clothing/under/chameleon/changeling/verb/shred() //Remove individual pieces if needed.
	set name = "Shred Jumpsuit"
	set category = "Chameleon Items"
	set src in usr
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		playsound(src, 'sound/effects/splat.ogg', 30, 1)
		visible_message("<span class='warning'>[H] tears off [src]!</span>",
		"<span class='notice'>We remove [src].</span>")
		qdel(src)

/obj/item/clothing/head/chameleon/changeling
	name = "malformed head"
	desc = "Our head is swelled with a large quanity of rapidly shifting skin cells.  We can reform our head to resemble various hats and \
	helmets that biologicals are so fond of wearing."
	origin_tech = list()
	canremove = 0

/obj/item/clothing/head/chameleon/changeling/dropped(mob/user)
	. = ..()
	visible_message(SPAN_DANGER("With a sickening crunch, \the [src] falls apart!"))
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/clothing/head/chameleon/changeling/emp_act(severity)
	return

/obj/item/clothing/head/chameleon/changeling/verb/shred() //The copypasta is real.
	set name = "Shred Helmet"
	set category = "Chameleon Items"
	set src in usr
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		playsound(src, 'sound/effects/splat.ogg', 30, 1)
		visible_message("<span class='warning'>[H] tears off [src]!</span>",
		"<span class='notice'>We remove [src].</span>")
		qdel(src)

/obj/item/clothing/suit/chameleon/changeling
	name = "chitinous chest"
	desc = "The cells in our chest are rapidly shifting, ready to reform into material that can resemble most pieces of clothing."
	origin_tech = list()
	canremove = 0

/obj/item/clothing/suit/chameleon/changeling/dropped(mob/user)
	. = ..()
	visible_message(SPAN_DANGER("With a sickening crunch, \the [src] falls apart!"))
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/clothing/suit/chameleon/changeling/emp_act(severity)
	return

/obj/item/clothing/suit/chameleon/changeling/verb/shred()
	set name = "Shred Suit"
	set category = "Chameleon Items"
	set src in usr
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		playsound(src, 'sound/effects/splat.ogg', 30, 1)
		visible_message("<span class='warning'>[H] tears off [src]!</span>",
		"<span class='notice'>We remove [src].</span>")
		qdel(src)

/obj/item/clothing/shoes/chameleon/changeling
	name = "malformed feet"
	desc = "Our feet are overlayed with another layer of flesh and bone on top.  We can reform our feet to resemble various boots and shoes."
	origin_tech = list()
	canremove = 0

/obj/item/clothing/shoes/chameleon/changeling/dropped(mob/user)
	. = ..()
	visible_message(SPAN_DANGER("With a sickening crunch, \the [src] falls apart!"))
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/clothing/shoes/chameleon/changeling/emp_act()
	return

/obj/item/clothing/shoes/chameleon/changeling/verb/shred()
	set name = "Shred Shoes"
	set category = "Chameleon Items"
	set src in usr
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		playsound(src, 'sound/effects/splat.ogg', 30, 1)
		visible_message("<span class='warning'>[H] tears off [src]!</span>",
		"<span class='notice'>We remove [src].</span>")
		qdel(src)

/obj/item/storage/backpack/chameleon/changeling
	name = "backpack"
	desc = "A large pouch embedded in our back, it can shift form to resemble many common backpacks that other biologicals are fond of using."
	origin_tech = list()
	canremove = 0

/obj/item/clothing/backpack/chameleon/changeling/dropped(mob/user)
	. = ..()
	visible_message(SPAN_DANGER("With a sickening crunch, \the [src] falls apart!"))
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/storage/backpack/chameleon/changeling/emp_act()
	return

/obj/item/storage/backpack/chameleon/changeling/verb/shred()
	set name = "Shred Backpack"
	set category = "Chameleon Items"
	set src in usr
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		playsound(src, 'sound/effects/splat.ogg', 30, 1)
		visible_message("<span class='warning'>[H] tears off [src]!</span>",
		"<span class='notice'>We remove [src].</span>")
		for(var/atom/movable/AM in src.contents) //Dump whatever's in the bag before deleting.
			AM.forceMove(get_turf(loc))
		qdel(src)

/obj/item/clothing/gloves/chameleon/changeling
	name = "malformed hands"
	desc = "Our hands have a second layer of flesh on top.  We can reform our hands to resemble a large variety of fabrics and materials that biologicals \
	tend to wear on their hands.  Remember that these won't protect your hands from harm."
	origin_tech = list()
	canremove = 0

/obj/item/clothing/gloves/chameleon/changeling/dropped(mob/user)
	. = ..()
	visible_message(SPAN_DANGER("With a sickening crunch, \the [src] falls apart!"))
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/clothing/gloves/chameleon/changeling/emp_act()
	return

/obj/item/clothing/gloves/chameleon/changeling/verb/shred()
	set name = "Shred Gloves"
	set category = "Chameleon Items"
	set src in usr
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		playsound(src, 'sound/effects/splat.ogg', 30, 1)
		visible_message("<span class='warning'>[H] tears off [src]!</span>",
		"<span class='notice'>We remove [src].</span>")
		qdel(src)

/obj/item/clothing/mask/chameleon/changeling
	name = "chitin visor"
	desc = "A transparent visor of brittle chitin covers our face.  We can reform it to resemble various masks that biologicals use.  It can also utilize internal \
	tanks.."
	origin_tech = list()
	canremove = 0

/obj/item/clothing/mask/chameleon/changeling/dropped(mob/user)
	. = ..()
	visible_message(SPAN_DANGER("With a sickening crunch, \the [src] falls apart!"))
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/clothing/mask/chameleon/changeling/emp_act()
	return

/obj/item/clothing/mask/chameleon/changeling/verb/shred()
	set name = "Shred Mask"
	set category = "Chameleon Items"
	set src in usr
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		playsound(src, 'sound/effects/splat.ogg', 30, 1)
		visible_message("<span class='warning'>[H] tears off [src]!</span>",
		"<span class='notice'>We remove [src].</span>")
		qdel(src)

/obj/item/clothing/glasses/chameleon/changeling
	name = "chitin goggles"
	desc = "A transparent piece of eyewear made out of brittle chitin.  We can reform it to resemble various glasses and goggles."
	origin_tech = list()
	canremove = 0

/obj/item/clothing/glasses/chameleon/changeling/dropped(mob/user)
	. = ..()
	visible_message(SPAN_DANGER("With a sickening crunch, \the [src] falls apart!"))
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)


/obj/item/clothing/glasses/chameleon/changeling/emp_act()
	return

/obj/item/clothing/glasses/chameleon/changeling/verb/shred()
	set name = "Shred Glasses"
	set category = "Chameleon Items"
	set src in usr
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		playsound(src, 'sound/effects/splat.ogg', 30, 1)
		visible_message("<span class='warning'>[H] tears off [src]!</span>",
		"<span class='notice'>We remove [src].</span>")
		qdel(src)

/obj/item/storage/belt/chameleon/changeling
	name = "waist pouch"
	desc = "We can store objects in this, as well as shift its appearance, so that it resembles various common belts."
	origin_tech = list()
	canremove = 0

/obj/item/clothing/storage/belt/chameleon/changeling/dropped(mob/user)
	. = ..()
	visible_message(SPAN_DANGER("With a sickening crunch, \the [src] falls apart!"))
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/storage/belt/chameleon/changeling/emp_act()
	return

/obj/item/storage/belt/chameleon/changeling/verb/shred()
	set name = "Shred Belt"
	set category = "Chameleon Items"
	set src in usr
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		playsound(src, 'sound/effects/splat.ogg', 30, 1)
		visible_message("<span class='warning'>[H] tears off [src]!</span>",
		"<span class='notice'>We remove [src].</span>")
		qdel(src)

/obj/item/card/id/syndicate/changeling
	name = "chitinous card"
	desc = "A card that we can reform to resemble identification cards.  Due to the nature of the material this is made of, it cannot store any access codes."
	assignment = "Harvester"
	origin_tech = list()
	electronic_warfare = 1 //The lack of RFID stuff makes it hard for AIs to track, I guess. *handwaves*
	registered_user = null
	access = null
	canremove = 0

/obj/item/card/id/syndicate/changeling/Initialize()
	. = ..()
	if(ismob(loc))
		registered_user = loc
	access = null

/obj/item/card/id/syndicate/changeling/dropped(mob/user)
	. = ..()
	visible_message(SPAN_DANGER("With a sickening crunch, \the [src] falls apart!"))
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/card/id/syndicate/changeling/verb/shred()
	set name = "Shred ID Card"
	set category = "Chameleon Items"
	set src in usr
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		playsound(src, 'sound/effects/splat.ogg', 30, 1)
		visible_message("<span class='warning'>[H] tears off [src]!</span>",
		"<span class='notice'>We remove [src].</span>")
		qdel(src)

/obj/item/card/id/syndicate/changeling/Click() //Since we can't hold it in our hands, and attack_hand() doesn't work if it in inventory...
	if(!registered_user)
		registered_user = usr
		usr.set_id_info(src)
	ui_interact(registered_user)
	..()
