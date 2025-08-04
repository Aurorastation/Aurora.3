/obj/item/reagent_containers
	name = "Container"
	desc = "..."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	w_class = WEIGHT_CLASS_SMALL
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
	var/N = tgui_input_list(usr, "Select the amount to transfer from this. ", "[src]", possible_transfer_amounts, amount_per_transfer_from_this)
	if(N)
		amount_per_transfer_from_this = N

/obj/item/reagent_containers/Initialize(mapload)
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

/obj/item/reagent_containers/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(ismob(loc))
		return
	if(fragile && (throwingdatum.speed >= fragile))
		shatter()
	if(atom_flags && ATOM_FLAG_NO_REACT)
		return
	if(!reagents)
		return
	reagents.apply_force(throwingdatum.speed)

/obj/item/reagent_containers/proc/shatter(var/obj/item/W, var/mob/user)
	if(reagents?.total_volume)
		reagents.splash(src.loc, reagents.total_volume) // splashes the mob holding it or the turf it's on
	audible_message(SPAN_WARNING("\The [src] shatters with a resounding crash!"), SPAN_WARNING("\The [src] breaks."))
	playsound(src, shatter_sound, 70, 1)
	shatter_material.place_shard(loc)
	qdel(src)

/obj/item/reagent_containers/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/dipped = attacking_item
		dipped.attempt_apply_coating(src, user)
		return
	if(!(attacking_item.item_flags & ITEM_FLAG_NO_BLUDGEON) && (user.a_intent == I_HURT) && fragile && (attacking_item.force > fragile))
		if(do_after(user, 1 SECOND, src))
			if(!QDELETED(src))
				visible_message(SPAN_WARNING("[user] smashes [src] with \a [attacking_item]!"))
				user.do_attack_animation(src)
				shatter(attacking_item, user)
				return TRUE
	return ..()

/obj/item/reagent_containers/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(can_operate(target_mob) && do_surgery(target_mob, user, src))
		return
	if(!reagents.total_volume && user.a_intent == I_HURT)
		return ..()

/obj/item/reagent_containers/afterattack(var/atom/target, var/mob/user, var/proximity, var/params)
	if(!proximity || (!is_open_container() && !is_pour_container()))
		return
	if(is_type_in_list(target,can_be_placed_into))
		return
	if(standard_feed_mob(user,target))
		return
	if(standard_splash_mob(user, target))
		return
	if(standard_pour_into(user, target))
		SStgui.update_uis(target)
		return
	if(standard_splash_obj(user, target))
		return

	if(istype(target, /obj/item))
		var/obj/item/O = target
		if(!(O.item_flags & ITEM_FLAG_NO_BLUDGEON) && reagents)
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
		to_chat(user, SPAN_NOTICE("[target] is empty."))
		return 1

	if(!REAGENTS_FREE_SPACE(reagents))
		to_chat(user, SPAN_NOTICE("[src] is full."))
		return 1

	var/trans = target.reagents.trans_to_obj(src, target.amount_per_transfer_from_this)
	to_chat(user, SPAN_NOTICE("You fill [src] with [trans] units of the contents of [target]."))
	return 1

/obj/item/reagent_containers/proc/standard_splash_obj(var/mob/user, var/target)

	if(user.a_intent != I_HURT)
		return

	if(!reagents.total_volume)
		return

	user.visible_message(SPAN_DANGER("\The [target] has been splashed with something by \the [user]!"),
							SPAN_WARNING("You splash the solution onto \the [target]."))

	reagents.splash(target, reagents.total_volume)
	return

// This goes into afterattack
/obj/item/reagent_containers/proc/standard_splash_mob(var/mob/user, var/mob/target)
	if(!istype(target))
		return

	if(user.a_intent != I_HURT)
		return 0

	if(!reagents.total_volume)
		to_chat(user, SPAN_NOTICE("[src] is empty."))
		return 1

	if(target.reagents && !REAGENTS_FREE_SPACE(target.reagents))
		to_chat(user, SPAN_NOTICE("[target] is full."))
		return 1

	var/contained = reagentlist()
	var/temperature = reagents.get_temperature()
	var/temperature_text = "Temperature: ([temperature]K/[temperature]C)"
	target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been splashed with [name] by [user.name] ([user.ckey]). Reagents: [contained] [temperature_text].</font>"
	user.attack_log += "\[[time_stamp()]\] <span class='warning'>Used the [name] to splash [target.name] ([target.key]). Reagents: [contained] [temperature_text].</span>"
	msg_admin_attack("[user.name] ([user.ckey]) splashed [target.name] ([target.key]) with [name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))

	user.visible_message(SPAN_DANGER("\The [target] has been splashed with something by \the [user]!"),
							SPAN_WARNING("You splash the solution onto \the [target]."))

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
		to_chat(user, SPAN_NOTICE("\The [src] is empty."))
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
			if(!H.can_drink(src))
				return

		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //puts a limit on how fast people can eat/drink things
		self_feed_message(user)
		reagents.trans_to_mob(user, min(10,amount_per_transfer_from_this), CHEM_INGEST) //A sane limiter. So you don't go drinking 300u all at once.
		feed_sound(user)
		return TRUE
	else
		if(istype(target, /mob/living/carbon/human))
			H = target
			if(!H.check_has_mouth())
				to_chat(user, "Where do you intend to put \the [src]? \The [H] doesn't have a mouth!")
				return
			var/obj/item/blocked = H.check_mouth_coverage()
			if(blocked)
				to_chat(user, SPAN_WARNING("\The [blocked] is in the way!"))
				return

		if(isanimal(target))
			var/mob/living/simple_animal/C = target
			if(C.can_be_milked)
				return

		other_feed_message_start(user, target)

		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(!do_mob(user, target))
			return

		other_feed_message_finish(user, target)

		var/contained = reagentlist()
		target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been fed [name] by [user.name] ([user.ckey]). Reagents: [contained]</font>"
		user.attack_log += "\[[time_stamp()]\] <span class='warning'>Fed [name] by [target.name] ([target.ckey]). Reagents: [contained]</span>"
		msg_admin_attack("[key_name(user)] fed [key_name(target)] with [name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))

		reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_INGEST)
		feed_sound(user)
		return 1

/obj/item/reagent_containers/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	. = ..()
	if(ishuman(over))
		var/mob/living/carbon/human/H = over
		if(usr != H)
			return

		if(!H.can_drink())
			return

		if(!(H.l_hand == src) && !(H.r_hand == src))
			return

		if(!reagents.total_volume)
			to_chat(H, SPAN_NOTICE("\The [src] is empty."))
			return

		if(H.isSynthetic() && !isipc(H))
			return

		visible_message(SPAN_NOTICE("[H] starts chugging from \the [src]!"))
		var/chugs = 0
		while(reagents.total_volume)
			if(do_after(H, 1.5 SECONDS))
				chugs++
				reagents.trans_to_mob(H, min(10, amount_per_transfer_from_this), CHEM_INGEST)
				if(!(H.species.flags & NO_BREATHE))
					if(chugs > 3)
						if(H.losebreath < 6)
							H.losebreath += 1
							H.adjustOxyLoss(1)
				feed_sound(H)
			else
				break
		if(chugs > 3)
			if(!(H.species.flags & NO_BREATHE))
				H.visible_message(SPAN_NOTICE("[H] finishes chugging, exhausted..."), SPAN_NOTICE("You finish chugging, exhausted..."))
				H.emote("gasp")
		return

/obj/item/reagent_containers/proc/standard_pour_into(var/mob/user, var/atom/target) // This goes into afterattack and yes, it's atom-level
	if(!target.reagents)
		return 0

	// Ensure we don't splash beakers and similar containers.
	if(!target.is_open_container())
		if(target.atom_flags & ATOM_FLAG_DISPENSER && istype(target, /obj/item/reagent_containers))
			var/obj/item/reagent_containers/dispenser = target
			return dispenser.standard_pour_into(user, src)
		to_chat(user, SPAN_NOTICE("\The [target] is closed."))
		return 1
	// Otherwise don't care about splashing.
	else if(!target.is_open_container())
		return 0

	if(!reagents.total_volume)
		if(force) // bash people!
			return 0
		to_chat(user, SPAN_NOTICE("[src] is empty."))
		return 1

	if(!REAGENTS_FREE_SPACE(target.reagents))
		to_chat(user, SPAN_NOTICE("[target] is full."))
		return 1

	var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
	to_chat(user, SPAN_NOTICE("You transfer [trans] units of the solution to [target]."))
	on_pour()
	return 1

/obj/item/reagent_containers/proc/on_pour()
	playsound(src, /singleton/sound_category/generic_pour_sound, 25, 1)
