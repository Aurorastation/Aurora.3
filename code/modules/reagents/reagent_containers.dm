/obj/item/reagent_containers
	name = "Container"
	desc = "..."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	w_class = ITEMSIZE_SMALL
	recyclable = TRUE
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = list(5,10,15,25,30)
	var/volume = 30
	var/filling_states				// List of percentages full that have icons
	var/accuracy = 1
	var/fragile = 0        // If nonzero, above what force do we shatter?
	var/shatter_sound = /singleton/sound_category/glass_break_sound
	var/material/shatter_material = MATERIAL_GLASS //slight typecasting abuse here, gets converted to a material in initializee
	var/can_be_placed_into = list(
		/obj/machinery/chem_master,
		/obj/machinery/chem_heater,
		/obj/machinery/chemical_dispenser,
		/obj/structure/reagent_dispensers,
		/obj/machinery/reagentgrinder,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/storage,
		/obj/machinery/atmospherics/unary/cryo_cell,
		/obj/machinery/dna_scannernew,
		/obj/item/grenade/chem_grenade,
		/mob/living/bot/medbot,
		/obj/item/storage/secure/safe,
		/obj/machinery/iv_drip,
		/obj/machinery/disposal,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/hostile/retaliate/goat,
		/obj/machinery/sleeper,
		/obj/machinery/smartfridge,
		/obj/machinery/biogenerator,
		/obj/machinery/constructable_frame,
		/obj/machinery/radiocarbon_spectrometer,
		/obj/item/storage/part_replacer
	)
	//The above list a misnomer. This basically means that anything in this list has their own way of handling reagent transfers and should be ignored in afterattack.

/obj/item/reagent_containers/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in range(0)
	var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
	if(N)
		amount_per_transfer_from_this = N

/obj/item/reagent_containers/Initialize()
	. = ..()
	if(!possible_transfer_amounts)
		src.verbs -= /obj/item/reagent_containers/verb/set_APTFT
	create_reagents(volume)
	shatter_material = SSmaterials.get_material_by_name(shatter_material)

/obj/item/reagent_containers/attack_self(mob/user)
	return

/obj/item/reagent_containers/proc/get_filling_state()
	var/percent = round((reagents.total_volume / volume) * 100)
	var/list/increments = cached_number_list_decode(filling_states)
	if(!length(increments))
		return

	var/last_increment = increments[1]
	for(var/increment in increments)
		if(percent < increment)
			break

		last_increment = increment

	return last_increment

/obj/item/reagent_containers/throw_impact(atom/hit_atom, var/speed)
	. = ..()
	if(ismob(loc))
		return
	if(fragile && (speed >= fragile))
		shatter()
	if(flags && NOREACT)
		return
	if(!reagents)
		return
	reagents.apply_force(speed)

/obj/item/reagent_containers/proc/shatter(var/obj/item/W, var/mob/user)
	if(reagents.total_volume)
		reagents.splash(src.loc, reagents.total_volume) // splashes the mob holding it or the turf it's on
	audible_message(SPAN_WARNING("\The [src] shatters with a resounding crash!"), SPAN_WARNING("\The [src] breaks."))
	playsound(src, shatter_sound, 70, 1)
	shatter_material.place_shard(loc)
	qdel(src)

/obj/item/reagent_containers/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/dipped = W
		dipped.attempt_apply_coating(src, user)
		return
	if(!(W.flags & NOBLUDGEON) && (user.a_intent == I_HURT) && fragile && (W.force > fragile))
		if(do_after(user, 10))
			if(!QDELETED(src))
				visible_message(SPAN_WARNING("[user] smashes [src] with \a [W]!"))
				user.do_attack_animation(src)
				shatter(W, user)
				return TRUE
	return ..()

/obj/item/reagent_containers/attack(mob/M, mob/user, def_zone)
	if(can_operate(M) && do_surgery(M, user, src))
		return
	if(!reagents.total_volume && user.a_intent == I_HURT)
		return ..()

/obj/item/reagent_containers/afterattack(var/atom/target, var/mob/user, var/proximity, var/params)
	if(!proximity || !is_open_container())
		return
	if(is_type_in_list(target,can_be_placed_into))
		return
	if(standard_feed_mob(user,target))
		return
	if(standard_splash_mob(user, target))
		return
	if(standard_pour_into(user, target))
		SSvueui.check_uis_for_change(target)
		return
	if(standard_splash_obj(user, target))
		return

	if(istype(target, /obj/))
		var/obj/O = target
		if(!(O.flags & NOBLUDGEON) && reagents)
			reagents.apply_force(O.force)
	return ..()

/obj/item/reagent_containers/proc/get_temperature()
	return reagents.get_temperature()

/obj/item/reagent_containers/proc/reagentlist() // For attack logs
	return reagents.get_reagents()

/obj/item/reagent_containers/proc/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target)
	if(!istype(target))
		return 0

	if(!target.reagents || !target.reagents.total_volume)
		to_chat(user, "<span class='notice'>[target] is empty.</span>")
		return 1

	if(!REAGENTS_FREE_SPACE(reagents))
		to_chat(user, "<span class='notice'>[src] is full.</span>")
		return 1

	var/trans = target.reagents.trans_to_obj(src, target.amount_per_transfer_from_this)
	to_chat(user, "<span class='notice'>You fill [src] with [trans] units of the contents of [target].</span>")
	return 1

/obj/item/reagent_containers/proc/standard_splash_obj(var/mob/user, var/target)

	if(user.a_intent != I_HURT)
		return

	if(!reagents.total_volume)
		return

	user.visible_message("<span class='danger'>\The [target] has been splashed with something by \the [user]!</span>", "<span class = 'warning'>You splash the solution onto \the [target].</span>")
	reagents.splash(target, reagents.total_volume)
	return

// This goes into afterattack
/obj/item/reagent_containers/proc/standard_splash_mob(var/mob/user, var/mob/target)
	if(!istype(target))
		return

	if(user.a_intent != I_HURT)
		return 0

	if(!reagents.total_volume)
		to_chat(user, "<span class='notice'>[src] is empty.</span>")
		return 1

	if(target.reagents && !REAGENTS_FREE_SPACE(target.reagents))
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return 1

	var/contained = reagentlist()
	var/temperature = reagents.get_temperature()
	var/temperature_text = "Temperature: ([temperature]K/[temperature]C)"
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been splashed with [name] by [user.name] ([user.ckey]). Reagents: [contained] [temperature_text].</font>")
	user.attack_log += text("\[[time_stamp()]\] <span class='warning'>Used the [name] to splash [target.name] ([target.key]). Reagents: [contained] [temperature_text].</span>")
	msg_admin_attack("[user.name] ([user.ckey]) splashed [target.name] ([target.key]) with [name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))

	user.visible_message("<span class='danger'>\The [target] has been splashed with something by \the [user]!</span>", "<span class = 'warning'>You splash the solution onto \the [target].</span>")
	reagents.splash(target, min(120,reagents.total_volume) ) //Splash Limit

	if (istype(target, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = target
		R.spark_system.queue()

	return 1

/obj/item/reagent_containers/proc/self_feed_message(var/mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] drinks from \the [src]."), SPAN_NOTICE("You drink from \the [src]."))

/obj/item/reagent_containers/proc/other_feed_message_start(var/mob/user, var/mob/target)
	user.visible_message(SPAN_WARNING("\The [user] is trying to feed \the [target] \the [src]!"), SPAN_WARNING("You start trying to feed \the [target] \the [src]!"))

/obj/item/reagent_containers/proc/other_feed_message_finish(var/mob/user, var/mob/target)
	user.visible_message(SPAN_WARNING("\The [user] has fed \the [target] \the [src]!"), SPAN_WARNING("You have fed \the [target] \the [src]."))

/obj/item/reagent_containers/proc/feed_sound(var/mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/reagent_containers/proc/standard_feed_mob(var/mob/user, var/mob/living/target) // This goes into attack

	if(!istype(target))
		return 0

	if(user.a_intent == I_HURT)
		return 0

	if(!reagents.total_volume)
		to_chat(user, "<span class='notice'>\The [src] is empty.</span>")
		return 1

	if(target.isSynthetic() && !isipc(target))
		return FALSE

	//var/types = target.find_type()

	var/mob/living/carbon/human/H
	if(istype(target, /mob/living/carbon/human))
		H = target

	if(target == user)
		if(istype(user, /mob/living/carbon/human))
			H = user
			if(!H.check_has_mouth())
				to_chat(user, "Where do you intend to put \the [src]? You don't have a mouth!")
				return 1
			var/obj/item/blocked = H.check_mouth_coverage()
			if(blocked)
				to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
				return

		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //puts a limit on how fast people can eat/drink things
		self_feed_message(user)
		reagents.trans_to_mob(user, min(10,amount_per_transfer_from_this), CHEM_INGEST) //A sane limiter. So you don't go drinking 300u all at once.
		feed_sound(user)
		return 1
	else
		if(istype(target, /mob/living/carbon/human))
			H = target
			if(!H.check_has_mouth())
				to_chat(user, "Where do you intend to put \the [src]? \The [H] doesn't have a mouth!")
				return
			var/obj/item/blocked = H.check_mouth_coverage()
			if(blocked)
				to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
				return

		if(isanimal(target))
			var/mob/living/simple_animal/C = target
			if(C.has_udder)
				return

		other_feed_message_start(user, target)

		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(!do_mob(user, target))
			return

		other_feed_message_finish(user, target)

		var/contained = reagentlist()
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
		user.attack_log += text("\[[time_stamp()]\] <span class='warning'>Fed [name] by [target.name] ([target.ckey]). Reagents: [contained]</span>")
		msg_admin_attack("[key_name(user)] fed [key_name(target)] with [name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))

		reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_INGEST)
		feed_sound(user)
		return 1

/obj/item/reagent_containers/proc/standard_pour_into(var/mob/user, var/atom/target) // This goes into afterattack and yes, it's atom-level
	if(!target.reagents)
		return 0

	// Ensure we don't splash beakers and similar containers.
	if(!target.is_open_container() && istype(target, /obj/item/reagent_containers))
		to_chat(user, "<span class='notice'>\The [target] is closed.</span>")
		return 1
	// Otherwise don't care about splashing.
	else if(!target.is_open_container())
		return 0

	if(!reagents.total_volume)
		if(force) // bash people!
			return 0
		to_chat(user, "<span class='notice'>[src] is empty.</span>")
		return 1

	if(!REAGENTS_FREE_SPACE(target.reagents))
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return 1

	var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
	to_chat(user, "<span class='notice'>You transfer [trans] units of the solution to [target].</span>")
	on_pour()
	return 1

/obj/item/reagent_containers/proc/on_pour()
	playsound(src, /singleton/sound_category/generic_pour_sound, 25, 1)