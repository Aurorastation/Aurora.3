/obj/item/reagent_containers/chem_disp_cartridge/espresso
	name = "A jar of Coffee Beans "
	desc = "This goes into a coffee maker!"
	label = "Spesscafe Dark Blend"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "coffeejar"

	w_class = ITEMSIZE_NORMAL

	volume = CARTRIDGE_VOLUME_SMALL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(20, 40)
	unacidable = 1

	spawn_reagent = /datum/reagent/drink/coffee/espresso

