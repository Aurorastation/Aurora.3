////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/hypospray
	name = "hypospray"
	desc = "A sterile, air-needle autoinjector for administration of drugs to patients."
	desc_fluff = "The Zeng-Hu Pharmaceuticals' Hypospray - 9 out of 10 doctors recommend it!"
	desc_info = "Unlike a syringe, reagents have to be poured into the hypospray before it can be used."
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
	possible_transfer_amounts = list(5, 10, 15)
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	drop_sound = 'sound/items/drop/gun.ogg'
	pickup_sound = 'sound/items/pickup/gun.ogg'
	var/armorcheck = 1
	var/time = 3 SECONDS
	var/image/filling //holds a reference to the current filling overlay
	matter = list(MATERIAL_GLASS = 400, DEFAULT_WALL_MATERIAL = 200)

/obj/item/reagent_containers/hypospray/Initialize()
	. = ..()
	update_icon()

/obj/item/reagent_containers/hypospray/AltClick(var/mob/user)
	set_APTFT()

/obj/item/reagent_containers/hypospray/on_reagent_change()
	update_icon()
	return

/obj/item/reagent_containers/hypospray/cmo
	name = "premium hypospray"
	desc = "A high-end version of the regular hypospray, it allows for a substantially higher rate of drug administration to patients."
	desc_fluff = "The Zeng-Hu Pharmaceuticals' Hypospray Mk-II is a cutting-edge version of the regular hypospray, with a much more expensive and streamlined injection process."
	desc_info = "This version of the hypospray has no delay before injecting a patient with reagent."
	icon_state = "cmo_hypo"
	volume = 30
	possible_transfer_amounts = list(5, 10, 15, 30)
	time = 0

/obj/item/reagent_containers/hypospray/attack(var/mob/M, var/mob/user, target_zone)
	. = ..()
	if(isliving(M))
		var/mob/living/L = M
		var/inj_time = time
		var/mod_time = L.can_inject(user, TRUE, target_zone, armorcheck)
		if(!mod_time)
			return
		else if(inj_time <= 0 && mod_time > 1)
			inj_time = (1 SECOND) * mod_time
		else
			inj_time *= mod_time
		user.visible_message(SPAN_WARNING("\The [user] is trying to inject \the [L] with \the [src]!"), SPAN_NOTICE("You are trying to inject \the [L] with \the [src]."))
		if(do_mob(user, L, inj_time))
			inject(M, user, M.Adjacent(user))

/obj/item/reagent_containers/hypospray/update_icon()
	cut_overlays()

	var/rounded_vol = round(reagents.total_volume, round(reagents.maximum_volume / (volume / 5)))
	icon_state = "[initial(icon_state)]_[rounded_vol]"

	if(reagents.total_volume)
		filling = image('icons/obj/syringe.dmi', src, "[initial(icon_state)][volume]")

		filling.icon_state = "[initial(icon_state)][rounded_vol]"

		filling.color = reagents.get_color()
		add_overlay(filling)

/obj/item/reagent_containers/hypospray/proc/inject(var/mob/M, var/mob/user, proximity)
	if(!proximity || !istype(M))
		return

	if(!reagents.total_volume)
		to_chat(user, SPAN_WARNING("\The [src] is empty."))
		return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)
	to_chat(user, SPAN_NOTICE("You inject \the [M] with \the [src]."))
	to_chat(M, SPAN_NOTICE("You feel a tiny prick!"))
	playsound(src, 'sound/items/hypospray.ogg',25)

	if(M.reagents)
		var/contained = reagentlist()
		var/temp = reagents.get_temperature()
		var/trans = reagents.trans_to_mob(M, amount_per_transfer_from_this, CHEM_BLOOD)
		admin_inject_log(user, M, src, contained, temp, trans)
		to_chat(user, SPAN_NOTICE("[trans] units injected. [reagents.total_volume] units remaining in \the [src]."))

	update_icon()
	return TRUE

/obj/item/reagent_containers/hypospray/afterattack(atom/target, mob/user, proximity)
	if (!proximity)
		return

	if (!isliving(target))
		return ..()

/obj/item/reagent_containers/hypospray/autoinjector
	name = "autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	desc_fluff = "Funded by the Stellar Corporate Conglomerate, produced by Zeng-Hu Pharmaceuticals, this autoinjector system was rebuilt from the ground up from the old variant to provide maximum user feedback."
	desc_info = "Autoinjectors are spent after using them. To re-use, use a screwdriver to open the back panel, then simply pour any desired reagent inside. Use in-hand, or click it while it's in your active hand to prepare it for reuse."
	icon_state = "autoinjector"
	item_state = "autoinjector"
	slot_flags = SLOT_EARS
	var/name_label
	var/spent = TRUE
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null
	volume = 5
	time = 0

/obj/item/reagent_containers/hypospray/autoinjector/Initialize()
	. = ..()
	if(name_label)
		name_unlabel = name
		name = "[name] ([name_label])"
		verbs += /atom/proc/remove_label
	if(reagents_to_add)
		flags = 0
		spent = FALSE
	update_icon()

/obj/item/reagent_containers/hypospray/autoinjector/attack(var/mob/M, var/mob/user, target_zone)
	if(is_open_container())
		to_chat(user, SPAN_NOTICE("You must secure the reagents inside \the [src] before using it!"))
		return FALSE
	. = ..()

/obj/item/reagent_containers/hypospray/autoinjector/inject(mob/M, mob/user, proximity)
	. = ..()
	if(.)
		spent = TRUE
		update_icon()

/obj/item/reagent_containers/hypospray/autoinjector/attack_self(mob/user as mob)
	if(is_open_container())
		if(LAZYLEN(reagents.reagent_volumes))
			to_chat(user, SPAN_NOTICE("With a quick twist of \the [src]'s lid, you secure the reagents inside."))
			spent = FALSE
			flags &= ~OPENCONTAINER
			update_icon()
		else
			to_chat(user, SPAN_NOTICE("You can't secure \the [src] without putting reagents in!"))
	else
		to_chat(user, SPAN_NOTICE("The reagents inside \the [src] are already secured."))
	return

/obj/item/reagent_containers/hypospray/autoinjector/attackby(obj/item/W, mob/user)
	if(W.isscrewdriver() && !is_open_container())
		to_chat(user, SPAN_NOTICE("Using \the [W], you unsecure the autoinjector's lid.")) // it locks shut after being secured
		flags |= OPENCONTAINER
		update_icon()
		return
	. = ..()

/obj/item/reagent_containers/hypospray/autoinjector/update_icon()
	cut_overlays()
	if(!is_open_container())
		var/mutable_appearance/backing_overlay = mutable_appearance(icon, "autoinjector_secured")
		add_overlay(backing_overlay)

	icon_state = "[initial(icon_state)][spent]"
	item_state = "[initial(item_state)][spent]"

	if(reagents.total_volume)
		var/mutable_appearance/reagent_overlay = mutable_appearance(icon, "autoinjector_reagents")
		reagent_overlay.color = reagents.get_color()
		add_overlay(reagent_overlay)

/obj/item/reagent_containers/hypospray/autoinjector/examine(mob/user)
	..(user)
	if(LAZYLEN(reagents.reagent_volumes))
		to_chat(user, SPAN_NOTICE("It is currently loaded."))
	else
		to_chat(user, SPAN_NOTICE("It is empty."))


/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline
	name_label = "inaprovaline"
	reagents_to_add = list(/decl/reagent/inaprovaline = 5)

/obj/item/reagent_containers/hypospray/autoinjector/dylovene
	name_label = "dylovene"
	reagents_to_add = list(/decl/reagent/dylovene = 5)

/obj/item/reagent_containers/hypospray/autoinjector/emergency
	name_label = "emergency"
	reagents_to_add = list(/decl/reagent/inaprovaline = 2.5, /decl/reagent/dexalin = 2.5)

/obj/item/reagent_containers/hypospray/autoinjector/emergency/Initialize()
	. = ..()
	desc += " This auto-injector is to be used in emergencies. It contains a small amount of inaprovaline and dexalin."

/obj/item/reagent_containers/hypospray/autoinjector/coagzolug
	name_label = "coagzolug"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel. This one contains coagzolug, a quick-acting blood coagulant that will slow bleeding for as long as it's within the bloodstream."
	volume = 5
	flags = 0
	reagents_to_add = list(/decl/reagent/coagzolug = 5)

/obj/item/reagent_containers/hypospray/autoinjector/hyronalin
	name_label = "hyronalin"
	flags = 0
	reagents_to_add = list(/decl/reagent/hyronalin = 5)

/obj/item/reagent_containers/hypospray/autoinjector/sideeffectbgone
	name_label = "sideeffects-be-gone!"
	desc = "A special cocktail designed to counter the side-effects of various drugs. Has 2 uses."
	volume = 30
	amount_per_transfer_from_this = 15

	reagents_to_add = list(/decl/reagent/synaptizine = 5, /decl/reagent/cetahydramine = 10, /decl/reagent/oculine = 5, /decl/reagent/ethylredoxrazine = 10)

/obj/item/reagent_containers/hypospray/autoinjector/stimpack
	name = "stimpack"
	desc = "A simple chemical cocktail of hyperzine and mortaphenyl designed to boost efficiency by 6,000% (estimated). Hoo-rah!"
	volume = 20
	amount_per_transfer_from_this = 20

	reagents_to_add = list(/decl/reagent/hyperzine = 12, /decl/reagent/mortaphenyl = 6, /decl/reagent/synaptizine = 2)

/obj/item/reagent_containers/hypospray/autoinjector/survival
	name = "survival autoinjector"
	desc = "A special cocktail designed to keep you alive in the field should disaster seek to prevail."
	volume = 35
	amount_per_transfer_from_this = 35

	reagents_to_add = list(/decl/reagent/tricordrazine = 15, /decl/reagent/inaprovaline = 5, /decl/reagent/dexalin/plus = 5, /decl/reagent/oxycomorphine = 3, /decl/reagent/synaptizine = 2, /decl/reagent/mental/corophenidate = 5)

/obj/item/reagent_containers/hypospray/autoinjector/trauma
	name = "trauma hypo-injector"
	desc = "A special hypospray made to combat most forms of physical trauma."
	volume = 15
	amount_per_transfer_from_this = 15

	reagents_to_add = list(/decl/reagent/butazoline = 15)

/obj/item/reagent_containers/hypospray/autoinjector/burn
	name = "burn hypo-injector"
	desc = "A special hypospray made to combat most types of superficial burns."
	volume = 15
	amount_per_transfer_from_this = 15

	reagents_to_add = list(/decl/reagent/dermaline = 15)

/obj/item/reagent_containers/hypospray/autoinjector/oxygen
	name = "oxygenation hypo-injector"
	desc = "A special hypospray made to combat oxygen deprivation."
	volume = 15
	amount_per_transfer_from_this = 15

	reagents_to_add = list(/decl/reagent/dexalin/plus = 15)

/obj/item/reagent_containers/hypospray/autoinjector/purity
	name = "purity hypo-injector"
	desc = "A special hypospray made to combat most forms of impurities such as genetic damage and infections."
	volume = 15
	amount_per_transfer_from_this = 15

	reagents_to_add = list(/decl/reagent/thetamycin = 10, /decl/reagent/ryetalyn = 5)

/obj/item/reagent_containers/hypospray/autoinjector/organ
	name = "organ hypo-injector"
	desc = "A special hypospray made to combat internal damage."
	volume = 15
	amount_per_transfer_from_this = 15

	reagents_to_add = list(/decl/reagent/peridaxon = 10, /decl/reagent/oculine = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pain
	name = "numbing hypo-injector"
	desc = "A special hypospray made to combat pain. This one only injects <b>5 units</b> at a time."
	volume = 15
	amount_per_transfer_from_this = 5

	reagents_to_add = list(/decl/reagent/oxycomorphine = 15)

/obj/item/reagent_containers/hypospray/combat
	name = "combat hypospray"
	desc = "A hypospray loaded with combat stimulants. Its needle has the ability to bypass armor."
	item_state = "combat_hypo"
	icon_state = "combat_hypo"
	volume = 20
	armorcheck = FALSE
	time = 0

	reagents_to_add = list(/decl/reagent/oxycomorphine = 5, /decl/reagent/synaptizine = 5, /decl/reagent/hyperzine = 5, /decl/reagent/arithrazine = 5)

/obj/item/reagent_containers/hypospray/combat/empty
	name = "combat hypospray"
	desc = "A sleek black hypospray. Its needle has the ability to bypass armor."
	reagents_to_add = FALSE
