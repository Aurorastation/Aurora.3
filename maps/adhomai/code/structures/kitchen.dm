/obj/structure/reagent_dispensers/messakeg
	name = "mead keg"
	desc = "A wooden keg filled with Messa's mead."
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "woodkeg"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/messakeg/Initialize()
	. = ..()
	reagents.add_reagent("messa_mead",capacity)