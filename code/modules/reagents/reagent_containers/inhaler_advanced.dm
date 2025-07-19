//Advanced Inhalers
//Just like hypopsray code

/obj/item/reagent_containers/personal_inhaler_cartridge
	name = "small inhaler cartridge"
	desc = "Fill this when chemicals and attach this to personal inhalers. Contains enough aerosol for 15u of reagents. The container must be activated for aerosol reagents to mix for the use in inhalers."
	icon = 'icons/obj/item/reagent_containers/syringe.dmi'
	item_state = "pi_cart_small"
	icon_state = "pi_cart_small"
	contained_sprite = TRUE
	volume = 15
	w_class = WEIGHT_CLASS_TINY
	unacidable = 1
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10,15)
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 250)
	center_of_mass = null
	storage_slot_sort_by_name = TRUE

/obj/item/reagent_containers/personal_inhaler_cartridge/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()

	if (distance > 2)
		return

	if(is_open_container())
		if(LAZYLEN(reagents.reagent_volumes))
			. += SPAN_NOTICE("It contains [round(reagents.total_volume, accuracy)] units of non-aerosol mix.")
		else
			. += SPAN_NOTICE("It is empty.")
	else
		if(LAZYLEN(reagents.reagent_volumes))
			. += SPAN_NOTICE("The reagents are secured in the aerosol mix.")
		else
			. += SPAN_NOTICE("The cartridge seems spent.")

/obj/item/reagent_containers/personal_inhaler_cartridge/on_reagent_change()
	update_icon()
	return

/obj/item/reagent_containers/personal_inhaler_cartridge/update_icon()
	ClearOverlays()
	var/rounded_vol = round(reagents.total_volume, round(reagents.maximum_volume / (volume / 5)))

	if(reagents.total_volume)
		var/mutable_appearance/filling = mutable_appearance(icon, "[initial(icon_state)][rounded_vol]")
		filling.color = reagents.get_color()
		AddOverlays(filling)

/obj/item/reagent_containers/personal_inhaler_cartridge/attack_self(mob/user as mob)
	if(is_open_container())
		if(LAZYLEN(reagents.reagent_volumes))
			to_chat(user,SPAN_NOTICE("With a quick twist of \the [src]'s lid, you secure the reagents inside."))
			atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
		else
			to_chat(user,SPAN_NOTICE("You can't secure \the [src] without putting reagents in!"))
	else
		to_chat(user,SPAN_NOTICE("The reagents inside \the [src] are already secured."))
	return

/obj/item/reagent_containers/personal_inhaler_cartridge/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver() && !is_open_container())
		to_chat(user,SPAN_NOTICE("Using \the [attacking_item], you unsecure the inhaler cartridge's lid.")) // it locks shut after being secured
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER
		return
	. = ..()

/obj/item/reagent_containers/personal_inhaler_cartridge/large
	name = "large inhaler cartridge"
	desc = "A large inhaler cartridge. It contains enough aerosol for 30 units of reagents. The container must be activated for aerosol to mix with reagents."
	icon_state = "pi_cart_medium"
	volume = 30
	w_class = WEIGHT_CLASS_SMALL
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,30)
	origin_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4)

/obj/item/reagent_containers/personal_inhaler_cartridge/bluespace
	name = "bluespace inhaler cartridge"
	desc = "An experimental bluespace inhaler cartridge. It has enough aerosol for 60 units of reagents. The container must be activated to mix aerosol with reagents inside."
	icon_state = "pi_cart_large"
	volume = 60
	w_class = WEIGHT_CLASS_SMALL
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,30,60)
	origin_tech = list(TECH_BLUESPACE = 2, TECH_BIO = 6, TECH_MATERIAL = 6)

/obj/item/personal_inhaler
	name = "inhaler"
	desc = "A safe way to administer small amounts of drugs into the lungs by trained personnel."
	icon = 'icons/obj/item/reagent_containers/syringe.dmi'
	item_state = "pi"
	icon_state = "pi"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_BELT
	var/obj/item/reagent_containers/stored_cartridge
	var/transfer_amount = 5
	origin_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2)
	var/eject_when_empty = FALSE

/obj/item/personal_inhaler/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance > 2)
		return
	if(stored_cartridge)
		. += SPAN_NOTICE("\The [stored_cartridge] is attached to \the [src].")

/obj/item/personal_inhaler/update_icon()
	ClearOverlays()
	if(stored_cartridge)
		AddOverlays(stored_cartridge.icon_state)
		if(stored_cartridge.reagents.total_volume)
			var/rounded_vol = round(stored_cartridge.reagents.total_volume, round(stored_cartridge.reagents.maximum_volume / (stored_cartridge.volume / 5)))
			var/image/filling = image(icon, "[stored_cartridge.icon_state][rounded_vol]")
			filling.color = stored_cartridge.reagents.get_color()
			AddOverlays(filling)

/obj/item/personal_inhaler/attack_self(mob/user as mob)
	if(stored_cartridge)
		user.put_in_hands(stored_cartridge)
		to_chat(user,SPAN_WARNING("You remove \the [stored_cartridge] from \the [src]."))
		stored_cartridge.update_icon()
		stored_cartridge = null
	update_icon()

/obj/item/personal_inhaler/attack(mob/living/target_mob, mob/living/user, target_zone)

	var/mob/living/carbon/human/H = target_mob

	if (!istype(H))
		to_chat(user,SPAN_WARNING("You can't find a way to use \the [src] on \the [H]!"))
		return

	if(!stored_cartridge)
		to_chat(user,SPAN_WARNING("\The [src] has no cartridge installed!"))
		return

	if(!stored_cartridge.reagents || !stored_cartridge.reagents.total_volume)
		to_chat(user,SPAN_WARNING("\The [src]'s cartridge is empty!"))
		return

	if (((user.is_clumsy()) || (user.mutations & DUMB)) && prob(10))
		to_chat(user,SPAN_DANGER("Your hand slips from clumsiness!"))
		if(H.eyes_protected(src, FALSE))
			eyestab(H,user)
		user.visible_message(SPAN_NOTICE("[user] accidentally sticks \the [src] in [H]'s eye!"),
								SPAN_NOTICE("You accidentally stick the [src] in [H]'s eye!"))

		return

	if (!user.IsAdvancedToolUser())
		to_chat(user,SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	if(user == H && !H.can_eat(src))
		return
	else if(!H.can_force_feed(user, src))
		return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(H)

	if(user == H)
		user.visible_message(SPAN_NOTICE("[user] sticks \the [src] in their mouth and presses the injection button."),
								SPAN_NOTICE("You stick \the [src] in your mouth and press the injection button."))

	else
		user.visible_message(SPAN_WARNING("[user] attempts to administer \the [src] to [H]..."),
								SPAN_NOTICE("You attempt to administer \the [src] to [H]..."))
		if (!do_after(user, 1 SECONDS, H))
			to_chat(user,SPAN_NOTICE("You and \the [H] need to be standing still in order to inject \the [src]."))
			return

		user.visible_message(SPAN_NOTICE("[user] sticks \the [src] in [H]'s mouth and presses the injection button."),
								SPAN_NOTICE("You stick \the [src] in [H]'s mouth and press the injection button."))


	if(H.reagents)
		var/contained = stored_cartridge.reagentlist()
		var/temp = stored_cartridge.reagents.get_temperature()
		var/trans = stored_cartridge.reagents.trans_to_mob(H, transfer_amount, CHEM_BREATHE, bypass_checks = TRUE)
		admin_inject_log(user, H, src, contained, temp, trans)
		playsound(H.loc, 'sound/items/stimpack.ogg', 50, 1)
		if(eject_when_empty)
			to_chat(user,SPAN_NOTICE("\The [stored_cartridge] automatically ejects from \the [src]."))
			stored_cartridge.forceMove(user.loc)
			stored_cartridge.update_icon()
			stored_cartridge = null
			update_icon()
	else
		to_chat(user,SPAN_WARNING("Nothing happens!"))

	update_icon()
	return

/obj/item/personal_inhaler/attackby(obj/item/attacking_item, mob/user)
	var/obj/item/reagent_containers/personal_inhaler_cartridge/cartridge = attacking_item
	if(istype(cartridge))
		if(src.stored_cartridge)
			to_chat(user,SPAN_NOTICE("\The [src] already has a cartridge."))
			return
		if(cartridge.is_open_container())
			to_chat(user,SPAN_NOTICE("\The [cartridge] needs to be secured first."))
			return
		user.remove_from_mob(cartridge)
		src.stored_cartridge = cartridge
		cartridge.forceMove(src)
		update_icon()
		return
	. = ..()

/obj/item/personal_inhaler/combat
	name = "combat inhaler"
	desc = "A large, bulky inhaler design that injects the entire contents of the loaded cartridge via an aerosol system in a single button press."
	icon_state = "pi_combat"
	w_class = WEIGHT_CLASS_NORMAL
	transfer_amount = 60
	origin_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	eject_when_empty = TRUE

/obj/item/reagent_containers/personal_inhaler_cartridge/large/hyperzine
	name = "large inhaler cartridge (hyperzine)"

/obj/item/reagent_containers/personal_inhaler_cartridge/large/hyperzine/Initialize()
	. = ..()
	reagents.add_reagent(/singleton/reagent/hyperzine, 30)
	atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
	update_icon()
	return

/obj/item/reagent_containers/personal_inhaler_cartridge/large/inaprovaline
	name = "large inhaler cartridge (inaprovaline)"

/obj/item/reagent_containers/personal_inhaler_cartridge/large/inaprovaline/Initialize()
	. = ..()
	reagents.add_reagent(/singleton/reagent/inaprovaline, 30)
	atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
	update_icon()
	return

/obj/item/reagent_containers/personal_inhaler_cartridge/mms
	name = "inhaler cartridge (Mercury Monolithium Sucrose)"
	desc = "An inhaler cartridge containing 15 units of MMS."

/obj/item/reagent_containers/personal_inhaler_cartridge/mms/Initialize()
	. = ..()
	reagents.add_reagent(/singleton/reagent/drugs/mms, volume)
	atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
	update_icon()
	return
