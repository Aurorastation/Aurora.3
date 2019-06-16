//Standard Rings

/obj/item/clothing/ring/engagement
	name = "engagement ring"
	desc = "An engagement ring. It certainly looks expensive."
	icon_state = "diamond"

/obj/item/clothing/ring/engagement/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(ishuman(A) && user != A)
		user.visible_message("<span class='warning'>\The [user] gets down on one knee, presenting \the [src] to [A].</span>","<span class='warning'>You get down on one knee, presenting \the [src] to [A].</span>")

//Reagent Rings

/obj/item/clothing/ring/reagent
	icon_state = "material"
	flags = OPENCONTAINER
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 4)

/obj/item/clothing/ring/reagent/Initialize()
	. = ..()
	create_reagents(15)

/obj/item/clothing/ring/reagent/equipped(var/mob/living/carbon/human/H)
	..()
	if(istype(H) && H.gloves==src)

		if(reagents.total_volume)
			to_chat(H, "<span class='danger'>You feel a prick as you slip on \the [src].</span>")
			if(H.reagents)
				var/contained_reagents = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(H, 15, CHEM_BLOOD)
				admin_inject_log(usr, H, src, contained_reagents, reagents.get_temperature(), trans)
	return

//Sleepy Ring
/obj/item/clothing/ring/reagent/sleepy
	name = "silver ring"
	desc = "A ring made from what appears to be silver."
	icon_state = "material"
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/clothing/ring/reagent/sleepy/Initialize()
	. = ..()
	reagents.add_reagent("chloralhydrate", 15)

//Seals and Signet Rings

/obj/item/clothing/ring/seal/mason
	name = "masonic ring"
	desc = "The Square and Compasses feature prominently on this Masonic ring."
	icon_state = "seal-masonic"

/obj/item/clothing/ring/seal/signet
	name = "signet ring"
	desc = "A signet ring, for when you're too sophisticated to sign letters."
	icon_state = "seal-signet"
	var/nameset = 0

/obj/item/clothing/ring/seal/signet/attack_self(mob/user)
	if(nameset)
		to_chat(user, "<span class='notice'>\The [src] has already been claimed!</span>")
		return

	to_chat(user, "<span class='notice'>You claim \the [src] as your own!</span>")
	change_name(user)
	nameset = 1

/obj/item/clothing/ring/seal/signet/proc/change_name(var/signet_name = "Unknown")
	name = "[signet_name]'s signet ring"
	desc = "A signet ring belonging to [signet_name], for when you're too sophisticated to sign letters."