////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/hypospray
	name = "hypospray"
	desc = "A sterile, air-needle autoinjector for administration of drugs to patients."
	description_fluff = "The Zeng-Hu Pharmaceuticals' Hypospray - 9 out of 10 doctors recommend it!"
	description_info = "Unlike a syringe, reagents have to be poured into the hypospray before it can be used."
	icon = 'icons/obj/syringe.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_medical.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_medical.dmi',
		)
	item_state = "hypo"
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	unacidable = 1
	volume = 15
	possible_transfer_amounts = null
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	drop_sound = 'sound/items/drop/gun.ogg'
	var/armorcheck = 1
	var/time = 3 SECONDS
	var/image/filling //holds a reference to the current filling overlay
	matter = list(MATERIAL_GLASS = 400, DEFAULT_WALL_MATERIAL = 200)

/obj/item/reagent_containers/hypospray/Initialize()
	. = ..()
	update_icon()

/obj/item/reagent_containers/hypospray/on_reagent_change()
	update_icon()
	return

/obj/item/reagent_containers/hypospray/cmo
	name = "premium hypospray"
	desc = "A high-end version of the regular hypospray, it allows for a substantially higher rate of drug administration to patients."
	description_fluff = "The Zeng-Hu Pharmaceuticals' Hypospray Mk-II is a cutting-edge version of the regular hypospray, with a much more expensive and streamlined injection process."
	description_info = "This version of the hypospray has no delay before injecting a patient with reagent."
	icon_state = "cmo_hypo"
	volume = 30
	time = 0

/obj/item/reagent_containers/hypospray/attack(var/mob/M, var/mob/user, target_zone)
	. = ..()
	var/mob/living/carbon/human/H = M
	if(istype(H))
		user.visible_message(span("warning", "\The [user] is trying to inject \the [M] with \the [src]!"),span("notice", "You are trying to inject \the [M] with \the [src]."))
		var/inj_time = time
		if(armorcheck && H.run_armor_check(target_zone,"melee",0,"Your armor slows down the injection!","Your armor slows down the injection!"))
			inj_time += 6 SECONDS
		if(!do_mob(user, M, inj_time))
			return 1

/obj/item/reagent_containers/hypospray/update_icon()
	cut_overlays()

	var/rounded_vol = round(reagents.total_volume, round(reagents.maximum_volume / (volume / 5)))
	icon_state = "[initial(icon_state)]_[rounded_vol]"

	if(reagents.total_volume)
		filling = image('icons/obj/syringe.dmi', src, "[initial(icon_state)][volume]")

		filling.icon_state = "[initial(icon_state)][rounded_vol]"

		filling.color = reagents.get_color()
		add_overlay(filling)
/obj/item/reagent_containers/hypospray/afterattack(var/mob/M, var/mob/user, proximity)

	if (!istype(M))
		return ..()

	if(!proximity)
		return

	if(!reagents.total_volume)
		to_chat(user,span("warning", "\The [src] is empty."))
		return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)
	to_chat(user,span("notice", "You inject \the [M] with \the [src]."))
	to_chat(M,span("notice", "You feel a tiny prick!"))
	playsound(src, 'sound/items/hypospray.ogg',25)

	if(M.reagents)
		var/contained = reagentlist()
		var/temp = reagents.get_temperature()
		var/trans = reagents.trans_to_mob(M, amount_per_transfer_from_this, CHEM_BLOOD)
		admin_inject_log(user, M, src, contained, temp, trans)
		to_chat(user,span("notice", "[trans] units injected. [reagents.total_volume] units remaining in \the [src]."))

	update_icon()
	return TRUE

/obj/item/reagent_containers/hypospray/autoinjector
	name = "autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	icon_state = "autoinjector1"
	item_state = "autoinjector1"
	var/empty_state = "autoinjector0"
	flags = OPENCONTAINER
	amount_per_transfer_from_this = 5
	volume = 5
	time = 0

/obj/item/reagent_containers/hypospray/autoinjector/Initialize()
	. =..()
	icon_state = empty_state
	item_state = empty_state
	update_icon()

/obj/item/reagent_containers/hypospray/autoinjector/attack(var/mob/M, var/mob/user, target_zone)
	if(is_open_container())
		to_chat(user,span("notice", "You must secure the reagents inside \the [src] before using it!"))
		return FALSE
	. = ..()

/obj/item/reagent_containers/hypospray/autoinjector/attack_self(mob/user as mob)
	if(is_open_container())
		if(reagents && reagents.reagent_list.len)
			to_chat(user,span("notice", "With a quick twist of \the [src]'s lid, you secure the reagents inside."))
			flags &= ~OPENCONTAINER
			update_icon()
		else
			to_chat(user,span("notice", "You can't secure \the [src] without putting reagents in!"))
	else
		to_chat(user,span("notice", "The reagents inside \the [src] are already secured."))
	return

/obj/item/reagent_containers/hypospray/autoinjector/attackby(obj/item/W, mob/user)
	if(W.isscrewdriver() && !is_open_container())
		to_chat(user,span("notice", "Using \the [W], you unsecure the autoinjector's lid.")) // it locks shut after being secured
		flags |= OPENCONTAINER
		update_icon()
		return
	. = ..()

/obj/item/reagent_containers/hypospray/autoinjector/update_icon()
	if(reagents.total_volume > 0 && !is_open_container())
		icon_state = initial(icon_state)
		item_state = initial(icon_state)
	else
		icon_state = empty_state
		item_state = empty_state

/obj/item/reagent_containers/hypospray/autoinjector/examine(mob/user)
	..(user)
	if(reagents && reagents.reagent_list.len)
		to_chat(user, span("notice", "It is currently loaded."))
	else
		to_chat(user, span("notice", "It is empty."))


/obj/item/reagent_containers/hypospray/autoinjector/norepinephrine
	name = "autoinjector (norepinephrine)"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	volume = 5
	amount_per_transfer_from_this = 20
	flags = 0

/obj/item/reagent_containers/hypospray/autoinjector/norepinephrine/Initialize()
	. =..()
	reagents.add_reagent("norepinephrine", 5)
	update_icon()
	return

/obj/item/reagent_containers/hypospray/autoinjector/stimpack
	name = "stimpack"
	desc = "A simple chemical cocktail of hyperzine and tramadol designed to boost efficiency by 6,000% (estimated). Hoo-rah!"
	volume = 20
	amount_per_transfer_from_this = 20

/obj/item/reagent_containers/hypospray/autoinjector/stimpack/Initialize()
	. = ..()
	reagents.add_reagent("hyperzine", 12)
	reagents.add_reagent("tramadol", 8)
	update_icon()

/obj/item/reagent_containers/hypospray/autoinjector/survival
	name = "survival autoinjector"
	desc = "A special cocktail designed to keep you alive in the field should disaster seek to prevail."
	volume = 35
	amount_per_transfer_from_this = 35

/obj/item/reagent_containers/hypospray/autoinjector/survival/Initialize()
	. = ..()
	reagents.add_reagent("tricordrazine", 15)
	reagents.add_reagent("norepinephrine", 5)
	reagents.add_reagent("dexalinp", 5)
	reagents.add_reagent("oxycodone", 5)
	reagents.add_reagent("methylphenidate", 5)
	update_icon()

/obj/item/reagent_containers/hypospray/combat
	name = "combat hypospray"
	desc = "A hypospray loaded with combat stimulants. Its needle has the ability to bypass armor."
	item_state = "combat_hypo"
	icon_state = "combat_hypo"
	volume = 20
	armorcheck = 0
	time = 0

/obj/item/reagent_containers/hypospray/combat/Initialize()
	. = ..()
	reagents.add_reagent("oxycodone", 5)
	reagents.add_reagent("synaptizine", 5)
	reagents.add_reagent("hyperzine", 5)
	reagents.add_reagent("arithrazine", 5)
	update_icon()
