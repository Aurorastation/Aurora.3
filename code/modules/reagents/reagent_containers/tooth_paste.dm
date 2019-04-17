/obj/item/weapon/reagent_containers/toothpaste
	name = "tube of toothpaste"
	desc = "A simple tube full of toothpaste."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "toothpaste"
	flags = OPENCONTAINER
	possible_transfer_amounts = null
	amount_per_transfer_from_this = 5
	volume = 20

/obj/item/weapon/reagent_containers/toothpaste/Initialize()
	. = ..()
	reagents.add_reagent("toothpaste", 20)

/obj/item/weapon/reagent_containers/toothpaste/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/toothpaste/update_icon()
	var/percent = round((reagents.total_volume / volume) * 100)
	switch(percent)
		if(0 to 9)			icon_state = "toothpaste_empty"
		if(10 to 50) 		icon_state = "toothpaste_half"
		if(51 to INFINITY)	icon_state = "toothpaste"

/obj/item/weapon/reagent_containers/toothpaste/attack_self(mob/user as mob)
	return

/obj/item/weapon/reagent_containers/toothbrush
	name = "toothbrush"
	desc = "An essential tool in dental hygiene."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "toothbrush_b"
	flags = OPENCONTAINER
	possible_transfer_amounts = null
	amount_per_transfer_from_this = 5
	volume = 5

/obj/item/weapon/reagent_containers/toothbrush/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/toothbrush/update_icon()
	cut_overlays()

	if(reagents.has_reagent("toothpaste"))
		add_overlay("toothpaste_overlay")

/obj/item/weapon/reagent_containers/toothbrush/attack_self(mob/user as mob)
	return

/obj/item/weapon/reagent_containers/toothbrush/self_feed_message(var/mob/user)
	user.visible_message("<span class='notice'>\The [user] brushes [user.get_pronoun(1)] teeth with \the [src]</span>","<span class='notice'>You brush your teeh with \the [src]</span>")

/obj/item/weapon/reagent_containers/toothbrush/other_feed_message_start(var/mob/user, var/mob/target)
	user.visible_message("<span class='warning'>[user] is trying to brush \the [target]'s teeth \the [src]!</span>")

/obj/item/weapon/reagent_containers/toothbrush/other_feed_message_finish(var/mob/user, var/mob/target)
	user.visible_message("<span class='warning'>[user] has brushed \the [target]'s teeth with \the [src]!</span>")

/obj/item/weapon/reagent_containers/toothbrush/feed_sound(var/mob/user)
	return

/obj/item/weapon/reagent_containers/toothbrush/green
	icon_state = "toothbrush_g"

/obj/item/weapon/reagent_containers/toothbrush/red
	icon_state = "toothbrush_r"