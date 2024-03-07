/obj/item/herb
	name = "pharmaceutical green herb"
	desc = "A vial of pharmaceutical herbs produced by Zeng-Hu. <span class='notice'>This will heal minor damage of all types, restore some blood, \
			and restore some organ damage.</span> It can be combined with a red herb to make a stronger herb."
	icon = 'icons/obj/raccoon_city/herbs.dmi'
	icon_state = "green"
	w_class = ITEMSIZE_TINY
	force = 1
	var/herb_type = "green"

/obj/item/herb/attack_self(mob/user)
	. = ..()
	if(isipc(user) || isvaurca(user) || user.is_diona() || !ishuman(user))
		return FALSE

	var/mob/living/carbon/human/H = user
	if(H.incapacitated())
		return FALSE

	to_chat(user, SPAN_NOTICE("You consume the contents of the vial!"))
	playsound(H, 'sound/items/raccoon_city/herb_use.ogg')
	consume_vial(H)
	qdel(src)

/obj/item/herb/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(!ishuman(user))
		return FALSE

	var/mob/living/carbon/human/H = user
	if(H.incapacitated())
		return FALSE

	if(istype(attacking_item, /obj/item/herb))
		var/obj/item/herb/herb = attacking_item
		if(herb.herb_type != "mixed")
			if(herb.herb_type != herb_type)
				to_chat(H, SPAN_NOTICE("You haphazardly combine the two herbs to create a stronger herb vial."))
				playsound(H, 'sound/items/raccoon_city/herb.ogg')
				qdel(herb)
				var/obj/item/herb/mixed/new_herb = new(get_turf(H))
				H.put_in_any_hand_if_possible(new_herb)
				qdel(src)

/obj/item/herb/proc/consume_vial(mob/living/carbon/human/H)
	H.bloodstr.add_reagent(/singleton/reagent/bicaridine, 10)
	H.bloodstr.add_reagent(/singleton/reagent/kelotane, 10)
	H.bloodstr.add_reagent(/singleton/reagent/peridaxon, 9.5)
	H.add_blood_simple(H.bloodstr.total_volume * 0.15)
	return TRUE

/obj/item/herb/red
	name = "pharmaceutical red herb"
	desc = "A vial of pharmaceutical herbs produced by Zeng-Hu. <span class='notice'>This will heal very little damage of all types, restore little blood, \
			and restore very little organ damage.</span> It can be combined with a green herb to make a stronger herb."
	icon_state = "red"
	herb_type = "red"

/obj/item/herb/red/consume_vial(mob/living/carbon/human/H)
	H.bloodstr.add_reagent(/singleton/reagent/bicaridine, 5)
	H.bloodstr.add_reagent(/singleton/reagent/kelotane, 5)
	H.bloodstr.add_reagent(/singleton/reagent/peridaxon, 5)
	H.add_blood_simple(H.bloodstr.total_volume * 0.10)
	return TRUE

/obj/item/herb/mixed
	name = "pharmaceutical green+red herb"
	desc = "A vial of pharmaceutical herbs produced by Zeng-Hu. <span class='notice'>This will heal a good amount of damage of all types, restore a good amount of blood, \
			and restore some organ damage.</span>"
	icon_state = "mixed"
	herb_type = "mixed"

/obj/item/herb/consume_vial(mob/living/carbon/human/H)
	H.bloodstr.add_reagent(/singleton/reagent/butazoline, 15)
	H.bloodstr.add_reagent(/singleton/reagent/dermaline, 15)
	H.bloodstr.add_reagent(/singleton/reagent/peridaxon, 9.5)
	H.bloodstr.add_reagent(/singleton/reagent/adipemcina, 10)
	H.add_blood_simple(H.bloodstr.total_volume * 0.25)
