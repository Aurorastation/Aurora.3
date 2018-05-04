//Advanced Inhalers
//Just like hypopsray code

/obj/item/weapon/reagent_containers/personal_inhaler_cartridge
	name = "small inhaler cartridge"
	desc = "Fill this when chemicals and attach this to personal inhalers. Contains enough areosol for 15u of reagents. The container must be activated for aerosol reagents to mix for the use in inhalers."
	icon = 'icons/obj/syringe.dmi'
	item_state = "buildpipe"
	icon_state = "pi_cart_small"
	volume = 15
	w_class = 2
	unacidable = 1
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10,15)
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 250)

/obj/item/weapon/reagent_containers/personal_inhaler_cartridge/examine(var/mob/user)
	if(!..(user, 2))
		return

	if(is_open_container())
		if(reagents && reagents.reagent_list.len)
			user.show_message("<span class='notice'>It contains [round(reagents.total_volume, accuracy)] units of non-aerosol mix.</span>")
		else
			user.show_message("<span class='notice'>It is empty.</span>")
	else
		user.show_message("<span class='notice'>The reagents are secured in the aerosol mix.</span>")

/obj/item/weapon/reagent_containers/personal_inhaler_cartridge/attack(obj/O as obj, mob/user as mob)

	if(!istype(O))
		return

	if(istype(O,/obj/item/weapon/personal_inhaler))
		var/obj/item/weapon/personal_inhaler/PI = O
		if(PI.stored_cartridge)
			user.show_message("<span class='notice'>\The [PI] already has a cartridge.</span>")
			return
		if(is_open_container())
			user.show_message("<span class='notice'>\The [src] needs to be secured first.</span>")
			return
		user.remove_from_mob(PI)
		PI.stored_cartridge = src
		PI.loc = loc
		return

	. = ..()

/obj/item/weapon/reagent_containers/personal_inhaler_cartridge/attack_self()
	if(is_open_container())
		user.show_message("<span class='notice'>With a quick twist, you secure the reagents inside \the [src].</span>")
		flags ^= OPENCONTAINER
	else
		user.show_message("<span class='notice'>\The reagents inside [src] are already secured.</span>")
	return

/obj/item/weapon/reagent_containers/personal_inhaler_cartridge/large
	name = "large inhaler cartridge"
	icon_state = "pi_cart_medium"
	volume = 30
	w_class = 3
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,30)
	origin_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4)

/obj/item/weapon/reagent_containers/personal_inhaler_cartridge/bluespace
	name = "bluespace inhaler cartridge"
	icon_state = "pi_cart_large"
	volume = 60
	w_class = 3
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,30,60)
	origin_tech = list(TECH_BLUESPACE = 2, TECH_BIO = 6, TECH_MATERIAL = 6)


/obj/item/weapon/personal_inhaler
	name = "inhaler"
	desc = "A safe way to administer small amounts of drugs into the lungs by trained personnel."
	icon = 'icons/obj/syringe.dmi'
	item_state = "buildpipe"
	icon_state = "pi"
	w_class = 2
	slot_flags = SLOT_BELT
	var/obj/item/weapon/reagent_containers/stored_cartridge
	var/transfer_amount = 5
	origin_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2)

/obj/item/weapon/personal_inhaler/examine(var/mob/user)
	if(!..(user, 2))
		return
	if(stored_cartridge)
		user.show_message("<span class='notice'>\The [stored_cartridge] is attached to \the [src].</span>")

/obj/item/weapon/personal_inhaler/update_icon()
	if(stored_cartridge)
		add_overlay(stored_cartridge.icon_state)

/obj/item/weapon/personal_inhaler/attack_self()
	if(stored_cartridge)
		user.put_in_hands(stored_cartridge)
		user.show_message("<span class='warning'>You remove \the [stored_cartridge] from the [src].</span>")
		stored_cartridge.update_icon()
		stored_cartridge = null

	update_icon()

/obj/item/weapon/personal_inhaler/attack(mob/living/M as mob, mob/user as mob)

	var/mob/living/carbon/human/H = M

	if (!istype(H))
		return

	if(!stored_cartridge)
		user.show_message("<span class='warning'>\The [src] has no cartridge installed!</span>")
		return

	if(!stored_cartridge.reagents || !stored_cartridge.reagents.total_volume)
		user.show_message("<span class='warning'>\The [src]'s cartridge is empty!</span>")
		return

	if ( ((CLUMSY in user.mutations) || (DUMB in user.mutations)) && prob(10))
		user.show_message("<span class='danger'>Your hand slips from clumsiness!</span>")
		eyestab(M,user)
		if(M.reagents)
			var/contained = stored_cartridge.reagentlist()
			var/trans = stored_cartridge.reagents.trans_to_mob(M, transfer_amount, CHEM_TOUCH)
			admin_inject_log(user, M, src, contained, trans)
			user.visible_message("<span class='notice'>[user] accidentally sticks the [src] in [M]'s eye and presses the injection button!</span>","<span class='notice'>You accidentally stick the [src] in [M]'s eye and press the injection button!</span>")
			user.show_message("<span class='notice'>[trans] units injected. [reagents.total_volume] units remaining in \the [src].</span>")
			playsound(src.loc, 'sound/items/stimpack.ogg', 50, 1)
		return

	if (!usr.IsAdvancedToolUser())
		usr << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return

	if(user == M)
		if(!M.can_eat(src))
			return
	else
		if(!M.can_force_feed(user, src))
			return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)

	if(user == M)
		user.visible_message("<span class='notice'>[user] sticks the [src] in their mouth and presses the injection button.</span>","<span class='notice'>You stick the [src] in your mouth and press the injection button</span>")
	else
		user.visible_message("<span class='warning'>[user] attempts to administer \the [src] to [M]...</span>","<span class='notice'>You attempt to administer \the [src] to [M]...</span>")
		if (!do_after(user, 1 SECONDS, act_target = M))
			user.show_message("<span class='notice'>You and the target need to be standing still in order to inject \the [src].</span>")
			return

		user.visible_message("<span class='notice'>[user] sticks the [src] in [M]'s mouth and presses the injection button.</span>","<span class='notice'>You stick the [src] in [M]'s mouth and press the injection button</span>")

	if(M.reagents)
		var/contained = stored_cartridge.reagentlist()
		var/trans = stored_cartridge.reagents.trans_to_mob(M, transfer_amount, CHEM_BREATHE)
		admin_inject_log(user, M, src, contained, trans)
		user.show_message("<span class='notice'>[trans] units injected. [reagents.total_volume] units remaining in \the [src].</span>")
		playsound(src.loc, 'sound/items/stimpack.ogg', 50, 1)

	return

/obj/item/weapon/personal_inhaler/combat
	name = "combat inhaler"
	desc = "A large, bulky inhaler design that injects the entire contents of the loaded cartridge via an aerosol system in a single button press."
	icon_state = "pi_combat"
	w_class = 3
	transfer_amount = 60
	origin_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4, TECH_ENGINEERING = 4)

/obj/item/weapon/reagent_containers/personal_inhaler_cartridge/large/hyperzine
	name = "large inhaler cartridge (hyperzine)"
	Initialize()
		. =..()
		reagents.add_reagent("hyperzine", 30)
		flags ^= OPENCONTAINER
		update_icon()
		return

/obj/item/weapon/reagent_containers/personal_inhaler_cartridge/large/inaprovaline
	name = "large inhaler cartridge (inaprovaline)"
	Initialize()
		. =..()
		reagents.add_reagent("inaprovaline", 30)
		flags ^= OPENCONTAINER
		update_icon()
		return