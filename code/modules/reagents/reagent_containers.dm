	name = "Container"
	desc = "..."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	w_class = 2
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = list(5,10,15,25,30)
	var/volume = 30
	var/accuracy = 1

	set name = "Set transfer amount"
	set category = "Object"
	set src in range(0)
	var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
	if(N)
		amount_per_transfer_from_this = N

	. = ..()
	if(!possible_transfer_amounts)
	create_reagents(volume)

	return

	if(can_operate(M))//Checks if mob is lying down on table for surgery
		if(do_surgery(M, user, src))
			return

	return

	if(reagents)
		return reagents.get_reagents()
	return "No reagent holder"

	if(!istype(target))
		return 0

	if(!target.reagents || !target.reagents.total_volume)
		user << "<span class='notice'>[target] is empty.</span>"
		return 1

	if(reagents && !reagents.get_free_space())
		user << "<span class='notice'>[src] is full.</span>"
		return 1

	var/trans = target.reagents.trans_to_obj(src, target:amount_per_transfer_from_this)
	user << "<span class='notice'>You fill [src] with [trans] units of the contents of [target].</span>"
	return 1

	if(!istype(target))
		return

	if(!reagents || !reagents.total_volume)
		user << "<span class='notice'>[src] is empty.</span>"
		return 1

	if(target.reagents && !target.reagents.get_free_space())
		user << "<span class='notice'>[target] is full.</span>"
		return 1



	var/contained = reagentlist()
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been splashed with [name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [name] to splash [target.name] ([target.key]). Reagents: [contained]</font>")
	msg_admin_attack("[user.name] ([user.ckey]) splashed [target.name] ([target.key]) with [name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))

	user.visible_message("<span class='danger'>[target] has been splashed with something by [user]!</span>", "<span class = 'notice'>You splash the solution onto [target].</span>")
	reagents.splash(target, reagents.total_volume)

	if (istype(target, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = target
		R.spark_system.queue()

	return 1

	user << "<span class='notice'>You eat \the [src]</span>"

	user.visible_message("<span class='warning'>[user] is trying to feed [target] \the [src]!</span>")

	user.visible_message("<span class='warning'>[user] has fed [target] \the [src]!</span>")

	return

	if(!istype(target))
		return 0

	if(!reagents || !reagents.total_volume)
		user << "<span class='notice'>\The [src] is empty.</span>"
		return 1

	//var/types = target.find_type()
	var/mob/living/carbon/human/H
	if(istype(target, /mob/living/carbon/human))
		H = target

	if(target == user)
		if(istype(user, /mob/living/carbon/human))
			H = user
			if(!H.check_has_mouth())
				user << "Where do you intend to put \the [src]? You don't have a mouth!"
				return 1
			var/obj/item/blocked = H.check_mouth_coverage()
			if(blocked)
				user << "<span class='warning'>\The [blocked] is in the way!</span>"
				return

		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //puts a limit on how fast people can eat/drink things
		self_feed_message(user)
		reagents.trans_to_mob(user, amount_per_transfer_from_this, CHEM_INGEST)
		feed_sound(user)
		return 1
	else
		if(istype(target, /mob/living/carbon/human))
			H = target
			if(!H.check_has_mouth())
				user << "Where do you intend to put \the [src]? \The [H] doesn't have a mouth!"
				return
			var/obj/item/blocked = H.check_mouth_coverage()
			if(blocked)
				user << "<span class='warning'>\The [blocked] is in the way!</span>"
				return

		other_feed_message_start(user, target)

		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(!do_mob(user, target))
			return

		other_feed_message_finish(user, target)

		var/contained = reagentlist()
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [name] by [target.name] ([target.ckey]). Reagents: [contained]</font>")
		msg_admin_attack("[key_name(user)] fed [key_name(target)] with [name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))

		reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_INGEST)
		feed_sound(user)
		return 1

	if(!target.reagents)
		return 0

	// Ensure we don't splash beakers and similar containers.
		user << "<span class='notice'>\The [target] is closed.</span>"
		return 1
	// Otherwise don't care about splashing.
	else if(!target.is_open_container())
		return 0

	if(!reagents || !reagents.total_volume)
		user << "<span class='notice'>[src] is empty.</span>"
		return 1

	if(!target.reagents.get_free_space())
		user << "<span class='notice'>[target] is full.</span>"
		return 1

	var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
	user << "<span class='notice'>You transfer [trans] units of the solution to [target].</span>"
	return 1
