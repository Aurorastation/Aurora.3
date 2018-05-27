////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	unacidable = 1
	volume = 30
	possible_transfer_amounts = null
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT

///obj/item/weapon/reagent_containers/hypospray/Initialize() //comment this to make hypos start off empty
//	. = ..()
//	reagents.add_reagent("tricordrazine", 30)
//	return

/obj/item/weapon/reagent_containers/hypospray/attack(mob/living/M as mob, mob/user as mob)
	if(!reagents.total_volume)
		user << "<span class='warning'>[src] is empty.</span>"
		return
	if (!istype(M))
		return

	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/obj/item/organ/external/affected = H.get_organ(user.zone_sel.selecting)
		if(!affected)
			user << "<span class='danger'>\The [H] is missing that limb!</span>"
			return
		else if(affected.status & ORGAN_ROBOT)
			user << "<span class='danger'>You cannot inject a robotic limb.</span>"
			return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)
	user << "<span class='notice'>You inject [M] with [src].</span>"
	M << "<span class='notice'>You feel a tiny prick!</span>"
	playsound(src, 'sound/items/hypospray.ogg',25)

	if(M.reagents)
		var/contained = reagentlist()
		var/trans = reagents.trans_to_mob(M, amount_per_transfer_from_this, CHEM_BLOOD)
		admin_inject_log(user, M, src, contained, trans)
		user << "<span class='notice'>[trans] units injected. [reagents.total_volume] units remaining in \the [src].</span>"

	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector
	name = "autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	icon_state = "autoinjector"
	item_state = "autoinjector"
	amount_per_transfer_from_this = 5
	volume = 5

/obj/item/weapon/reagent_containers/hypospray/autoinjector/Initialize()
	. =..()
	reagents.add_reagent("inaprovaline", 5)
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/attack(mob/M as mob, mob/user as mob)
	..()
	if(reagents.total_volume <= 0) //Prevents autoinjectors to be refilled.
		flags &= ~OPENCONTAINER
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/update_icon()
	if(reagents.total_volume > 0)
		icon_state = "[initial(icon_state)]1"
	else
		icon_state = "[initial(icon_state)]0"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/examine(mob/user)
	..(user)
	if(reagents && reagents.reagent_list.len)
		user << "<span class='notice'>It is currently loaded.</span>"
	else
		user << "<span class='notice'>It is spent.</span>"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/stimpack
	name = "stimpack"
	desc = "A simple chemical cocktail of hyperzine and tramadol designed to boost efficiency by 6,000% (estimated). Hoo-rah!"
	volume = 20
	amount_per_transfer_from_this = 20

/obj/item/weapon/reagent_containers/hypospray/autoinjector/stimpack/Initialize()
		. = ..()
		reagents.add_reagent("hyperzine", 12)
		reagents.add_reagent("tramadol", 8)
		update_icon()

/obj/item/weapon/reagent_containers/hypospray/autoinjector/survival
	name = "survival autoinjector"
	desc = "A special cocktail designed to keep you alive in the field should disaster seek to prevail."
	volume = 35
	amount_per_transfer_from_this = 35

/obj/item/weapon/reagent_containers/hypospray/autoinjector/survival/Initialize()
		. = ..()
		reagents.add_reagent("tricordrazine", 15)
		reagents.add_reagent("inaprovaline", 5)
		reagents.add_reagent("dexalinp", 5)
		reagents.add_reagent("oxycodone", 5)
		reagents.add_reagent("methylphenidate", 5)
		update_icon()

/obj/item/weapon/reagent_containers/hypospray/combat
	name = "combat hypospray"
	desc = "A hypospray loaded with combat stimulants."
	item_state = "combat_hypo"
	icon_state = "combat_hypo"
	volume = 20

/obj/item/weapon/reagent_containers/hypospray/combat/Initialize()
	. = ..()
	reagents.add_reagent("oxycodone", 5)
	reagents.add_reagent("synaptizine", 5)
	reagents.add_reagent("hyperzine", 5)
	reagents.add_reagent("arithrazine", 5)

	return
