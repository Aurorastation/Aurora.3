
/obj/machinery/megavendor
	name = "\improper AutoDrobe"
	desc = "NanoTrasen science proudly brings to you the wardrobe of the future! No more hassle in getting dressed! Order one today!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "tele0"
	layer = 2.9
	anchored = 1
	density = 0
	use_power = 0
	var/selectedrank
	var/last_reply = 0
	var/last_slogan = 0 //When did we last pitch?
	var/slogan_delay = 6000 //How long until we can pitch again?
	var/change_message = "You feel a pleasant breeze as the autolocker whisks away all of your clothes, packing them neatly in a box."

	// Stuff relating vocalizations
	var/list/slogan_list = list("Don't deploy just yet! Grab your gear!","Forgetting something?","Don't hop on in your skivvies, mate!","It's not Casual Friday, y'know?","Heaven's above, put some clothes on!")
	var/shut_up = FALSE //Stop spouting those godawful pitches!

/obj/machinery/megavendor/machinery_process()
	if(((src.last_slogan + src.slogan_delay) <= world.time) && (src.slogan_list.len > 0) && (!src.shut_up) && prob(5))
		var/slogan = pick(src.slogan_list)
		src.ping(slogan)
		src.last_slogan = world.time

/obj/machinery/megavendor/Crossed(O)
	if(istype(O,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = O
		if(!H.megavend)
			flick("telefast",src)
			playsound(src,'sound/effects/sparks4.ogg',50,1)
			megavend(H)

/obj/machinery/megavendor/proc/megavend(var/mob/living/carbon/human/H)
	if(H.megavend)
		return

	var/obj/item/storage/box/gearbox = new(null, TRUE)
	var/list/AC
	var/obj/BE
	LAZYINITLIST(AC)
	gearbox.name = "personal possessions box"
	gearbox.desc = "All of the personal effects of [H.real_name], packaged neatly by the AutoDrobe."

	if(H.belt)
		BE = H.belt
	for(var/obj/item/W in H.contents) //Strip 'em
		if(istype(W,/obj/item/organ))
			continue
		if(W.autodrobe_no_remove)
			continue
		if(!W.canremove)
			continue

		if(isclothing(W))
			var/obj/item/clothing/U = W
			for(var/obj/item/clothing/accessory/A in U.accessories)
				U.remove_accessory(H, A)
				LAZYADD(AC, A)
		H.drop_from_inventory(W,gearbox)

	to_chat(H, SPAN_NOTICE(change_message))

	SSjobs.EquipRank(H, H.job, 1, 1) //Equip 'em

	//Give them the box
	if(istype(H.back,/obj/item/storage/backpack))
		var/obj/item/storage/backpack/B = H.back
		if(!B.insert_into_storage(gearbox))
			H.put_in_any_hand_if_possible(gearbox)
	else
		H.put_in_any_hand_if_possible(gearbox)

	for(var/obj/item/clothing/accessory/A as anything in AC)
		H.remove_from_mob(A)
		H.equip_to_slot(A, slot_tie, FALSE)
		LAZYREMOVE(AC, A)
	if(BE)
		H.equip_to_slot_if_possible(BE, slot_belt, disable_warning = TRUE)
	return

/obj/machinery/megavendor/vendor
	name = "\improper AutoDrobe Vendor"
	desc = "A NanoTrasen AutoDrobe machine to help through the trouble of getting dressed for work in the spur of a moment!"
	icon_state = "clothing"
	shut_up = TRUE
	density = 1
	change_message = "The autolocker issues your equipment and you quickly get changed."

/obj/machinery/megavendor/vendor/Crossed(O)
	return

/obj/machinery/megavendor/vendor/attack_hand(mob/user)
	..()
	if(ishuman(user) && Adjacent(user))
		var/mob/living/carbon/human/H = user
		if(!H.megavend)
			playsound(src,'sound/effects/sparks4.ogg',50,1)
			megavend(H)
		else
			to_chat(user, "\The [src]'s screen lights up a brief message: 'Equipment already claimed. Have a nice day!'")