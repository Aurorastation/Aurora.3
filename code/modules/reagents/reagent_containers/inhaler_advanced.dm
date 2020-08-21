//Advanced Inhalers
//Just like hypopsray code

/obj/item/reagent_containers/personal_inhaler_cartridge
	name = "small inhaler cartridge"
	desc = "Fill this when chemicals and attach this to personal inhalers. Contains enough aerosol for 15u of reagents. The container must be activated for aerosol reagents to mix for the use in inhalers."
	icon = 'icons/obj/syringe.dmi'
	item_state = "buildpipe"
	icon_state = "pi_cart_small"
	volume = 15
	w_class = 1
	unacidable = 1
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10,15)
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 250)
	center_of_mass = null

/obj/item/reagent_containers/personal_inhaler_cartridge/examine(var/mob/user)
	if(!..(user, 2))
		return

	if(is_open_container())
		if(reagents && reagents.reagent_list.len)
			to_chat(user,SPAN_NOTICE("It contains [round(reagents.total_volume, accuracy)] units of non-aerosol mix."))
		else
			to_chat(user,SPAN_NOTICE("It is empty."))
	else
		if(reagents && reagents.reagent_list.len)
			to_chat(user,SPAN_NOTICE("The reagents are secured in the aerosol mix."))
		else
			to_chat(user,SPAN_NOTICE("The cartridge seems spent."))

/obj/item/reagent_containers/personal_inhaler_cartridge/attack_self(mob/user as mob)
	if(is_open_container())
		if(reagents && reagents.reagent_list.len)
			to_chat(user,SPAN_NOTICE("With a quick twist of \the [src]'s lid, you secure the reagents inside."))
			flags &= ~OPENCONTAINER
		else
			to_chat(user,SPAN_NOTICE("You can't secure \the [src] without putting reagents in!"))
	else
		to_chat(user,SPAN_NOTICE("The reagents inside \the [src] are already secured."))
	return

/obj/item/reagent_containers/personal_inhaler_cartridge/attackby(obj/item/W, mob/user)
	if(W.isscrewdriver() && !is_open_container())
		to_chat(user,SPAN_NOTICE("Using \the [W], you unsecure the inhaler cartridge's lid.")) // it locks shut after being secured
		flags |= OPENCONTAINER
		return
	. = ..()

/obj/item/reagent_containers/personal_inhaler_cartridge/large
	name = "large inhaler cartridge"
	desc = "A large inhaler cartridge. It contains enough aerosol for 30 units of reagents. The container must be activated for aerosol to mix with reagents."
	icon_state = "pi_cart_medium"
	volume = 30
	w_class = 2
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,30)
	origin_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4)

/obj/item/reagent_containers/personal_inhaler_cartridge/bluespace
	name = "bluespace inhaler cartridge"
	desc = "An experimental bluespace inhaler cartridge. It has enough aerosol for 60 units of reagents. The container must be activated to mix aerosol with reagents inside."
	icon_state = "pi_cart_large"
	volume = 60
	w_class = 2
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,30,60)
	origin_tech = list(TECH_BLUESPACE = 2, TECH_BIO = 6, TECH_MATERIAL = 6)

/obj/item/personal_inhaler
	name = "inhaler"
	desc = "A safe way to administer small amounts of drugs into the lungs by trained personnel."
	icon = 'icons/obj/syringe.dmi'
	item_state = "buildpipe"
	icon_state = "pi"
	w_class = 2
	slot_flags = SLOT_BELT
	var/obj/item/reagent_containers/stored_cartridge
	var/transfer_amount = 5
	origin_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2)
	var/eject_when_empty = FALSE

/obj/item/personal_inhaler/examine(var/mob/user)
	if(!..(user, 2))
		return
	if(stored_cartridge)
		to_chat(user,SPAN_NOTICE("\The [stored_cartridge] is attached to \the [src]."))

/obj/item/personal_inhaler/update_icon()
	cut_overlays()
	if(stored_cartridge)
		add_overlay(stored_cartridge.icon_state)

/obj/item/personal_inhaler/attack_self(mob/user as mob)
	if(stored_cartridge)
		user.put_in_hands(stored_cartridge)
		to_chat(user,SPAN_WARNING("You remove \the [stored_cartridge] from \the [src]."))
		stored_cartridge.update_icon()
		stored_cartridge = null
	update_icon()

/obj/item/personal_inhaler/attack(mob/living/M as mob, mob/user as mob)

	var/mob/living/carbon/human/H = M

	if (!istype(H))
		to_chat(user,SPAN_WARNING("You can't find a way to use \the [src] on \the [M]!"))
		return

	if(!stored_cartridge)
		to_chat(user,SPAN_WARNING("\The [src] has no cartridge installed!"))
		return

	if(!stored_cartridge.reagents || !stored_cartridge.reagents.total_volume)
		to_chat(user,SPAN_WARNING("\The [src]'s cartridge is empty!"))
		return

	if (((user.is_clumsy()) || (DUMB in user.mutations)) && prob(10))
		to_chat(user,SPAN_DANGER("Your hand slips from clumsiness!"))
		eyestab(M,user)
		user.visible_message(SPAN_NOTICE("[user] accidentally sticks \the [src] in [M]'s eye!"),SPAN_NOTICE("You accidentally stick [src] in [M]'s eye!"))
		return

	if (!user.IsAdvancedToolUser())
		to_chat(user,SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	if(user == H && !H.can_eat(src))
		return
	else if(!H.can_force_feed(user, src))
		return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)

	if(user == M)
		user.visible_message(SPAN_NOTICE("[user] sticks \the [src] in their mouth and presses the injection button."),SPAN_NOTICE("You stick \the [src] in your mouth and press the injection button."))
	else
		user.visible_message(SPAN_WARNING("[user] attempts to administer \the [src] to [M]..."),SPAN_NOTICE("You attempt to administer \the [src] to [M]..."))
		if (!do_after(user, 1 SECONDS, act_target = M))
			to_chat(user,SPAN_NOTICE("You and \the [M] need to be standing still in order to inject \the [src]."))
			return

		user.visible_message(SPAN_NOTICE("[user] sticks \the [src] in [M]'s mouth and presses the injection button."),SPAN_NOTICE("You stick \the [src] in [M]'s mouth and press the injection button."))

	if(M.reagents)
		var/contained = stored_cartridge.reagentlist()
		var/trans = stored_cartridge.reagents.trans_to_mob(M, transfer_amount, CHEM_BREATHE, bypass_checks = TRUE)
		admin_inject_log(user, M, src, contained, reagents.get_temperature(), trans)
		playsound(M.loc, 'sound/items/stimpack.ogg', 50, 1)
		if(eject_when_empty)
			to_chat(user,SPAN_NOTICE("\The [stored_cartridge] automatically ejects from \the [src]."))
			stored_cartridge.forceMove(user.loc)
			stored_cartridge.update_icon()
			stored_cartridge = null
			update_icon()
	else
		to_chat(user,SPAN_WARNING("Nothing happens!"))

	return

/obj/item/personal_inhaler/attackby(var/obj/item/reagent_containers/personal_inhaler_cartridge/cartridge as obj, var/mob/user as mob)
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
	w_class = 3
	transfer_amount = 60
	origin_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	eject_when_empty = TRUE

/obj/item/reagent_containers/personal_inhaler_cartridge/large/hyperzine
	name = "large inhaler cartridge (hyperzine)"
	Initialize()
		. =..()
		reagents.add_reagent(/datum/reagent/hyperzine, 30)
		flags ^= OPENCONTAINER
		update_icon()
		return

/obj/item/reagent_containers/personal_inhaler_cartridge/large/inaprovaline
	name = "large inhaler cartridge (inaprovaline)"
	Initialize()
		. =..()
		reagents.add_reagent(/datum/reagent/inaprovaline, 30)
		flags ^= OPENCONTAINER
		update_icon()
		return
