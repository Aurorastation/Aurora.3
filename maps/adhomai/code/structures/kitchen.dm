/obj/structure/reagent_dispensers/messakeg
	name = "mead keg"
	desc = "A wooden keg filled with Messa's mead."
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "woodkeg"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/messakeg/Initialize()
	. = ..()
	reagents.add_reagent("messa_mead",capacity)

/obj/structure/reagent_dispensers/winekeg
	name = "cask of wine"
	desc = "A wooden keg filled with delicious wine. Vintage!"
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "woodkeg"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/winekeg/Initialize()
	. = ..()
	reagents.add_reagent("wine",capacity)

/obj/structure/sink/well
	name = "well"
	desc = "An old fashioned well. It seems to have been here for awhile."
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "well"