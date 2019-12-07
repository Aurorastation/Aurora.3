
/obj/machinery/megavendor
	name = "\improper NanoTrasen AutoDrobe"
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

	// Stuff relating vocalizations
	var/list/slogan_list = list("Don't deploy just yet! Grab your gear!","Forgetting something?","Don't hop on in your skivvies, mate!","It's not Casual Friday, y'know?","Heaven's above, put some clothes on!")
	var/shut_up = 0 //Stop spouting those godawful pitches!

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
	gearbox.name = "personal possessions box"
	gearbox.desc = "All of the personal effects of [H.real_name], packaged neatly by the AutoDrobe."
	for(var/obj/item/W in H.contents) //Strip 'em
		if(istype(W,/obj/item/organ))
			continue
		if(W.autodrobe_no_remove)
			continue
		if(!W.canremove)
			continue
		H.drop_from_inventory(W,gearbox)

	to_chat(H,"<span class='notice'>You feel a pleasant breeze as the autolocker whisks away all of your clothes, packing them neatly in a box.</span>")

	SSjobs.EquipRank(H, H.job, 1, 1) //Equip 'em
	H.megavend = 1

	//Give them the box
	if(istype(H.back,/obj/item/storage/backpack))
		var/obj/item/storage/backpack/B = H.back
		if(!B.insert_into_storage(gearbox))
			H.put_in_any_hand_if_possible(gearbox)
	else		
		H.put_in_any_hand_if_possible(gearbox)

	return
