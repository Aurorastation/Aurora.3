
/obj/item/reagent_containers/glass/bottle/robot
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50,100)
	flags = OPENCONTAINER
	volume = 60
	fragile = 0 // do NOT shatter
	var/reagent = ""


/obj/item/reagent_containers/glass/bottle/robot/norepinephrine
	name = "internal norepinephrine bottle"
	desc = "A small bottle. Contains norepinephrine - used to stabilize patients."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	reagent = "norepinephrine"

	New()
		..()
		reagents.add_reagent("norepinephrine", 60)
		update_icon()


/obj/item/reagent_containers/glass/bottle/robot/antitoxin
	name = "internal anti-toxin bottle"
	desc = "A small bottle of Anti-toxins. Counters poisons, and repairs damage, a wonder drug."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	reagent = "dylovene"

	New()
		..()
		reagents.add_reagent("dylovene", 60)
		update_icon()

