//NEVER USE THIS IT SUX	-PETETHEGOAT
//THE GOAT WAS RIGHT - RKF

/obj/item/reagent_containers/glass/paint
	desc = "It's a paint bucket."
	name = "paint bucket"
	icon = 'icons/obj/items.dmi'
	icon_state = "paint_empty"
	item_state = "paintcan"
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	w_class = 3.0
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10,20,30,60)
	volume = 60
	unacidable = 0
	flags = OPENCONTAINER
	var/paint_reagent = null //name of the reagent responsible for colouring the paint
	var/paint_type = null //used for colouring detective technicolor coat and hat

/obj/item/reagent_containers/glass/paint/Initialize()
	. = ..()
	if(paint_type && lentext(paint_type) > 0)
		name = paint_type + " " + name
	reagents.add_reagent("water", volume*3/5)
	reagents.add_reagent("plasticide", volume/5)
	if(paint_reagent)
		reagents.add_reagent(paint_reagent, volume/5)
	reagents.handle_reactions()
	update_icon()

/obj/item/reagent_containers/glass/paint/update_icon()
	cut_overlays()
	if(!is_open_container())
		add_overlay("paint_lid")
	else if(reagents.total_volume)
		var/image/I = image(icon, "paint_full")
		I.color = reagents.get_color()
		add_overlay(I)

/obj/item/reagent_containers/glass/paint/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/glass/paint/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/paint/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/paint/attack_hand()
	..()
	update_icon()

/obj/item/reagent_containers/glass/paint/red
	paint_reagent = "crayon_dust_red"
	paint_type = "red"

/obj/item/reagent_containers/glass/paint/yellow
	paint_reagent = "crayon_dust_yellow"
	paint_type = "yellow"

/obj/item/reagent_containers/glass/paint/green
	paint_reagent = "crayon_dust_green"
	paint_type = "green"

/obj/item/reagent_containers/glass/paint/blue
	paint_reagent = "crayon_dust_blue"
	paint_type = "blue"

/obj/item/reagent_containers/glass/paint/purple
	paint_reagent = "crayon_dust_purple"
	paint_type = "purple"

/obj/item/reagent_containers/glass/paint/black
	paint_reagent = "carbon"
	paint_type = "black"

/obj/item/reagent_containers/glass/paint/white
	paint_reagent = "aluminum"
	paint_type = "white"
