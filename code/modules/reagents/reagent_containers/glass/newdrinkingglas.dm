/obj/item/reagent_containers/food/drinks/drinkingglass/newglass
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/on_reagent_change()
	update_icon()
	return

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image(icon, src, "[icon_state]10")
		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)
				filling.icon_state = null
				return
			if(10 to 19) 	filling.icon_state = "[icon_state]10"
			if(20 to 29)	filling.icon_state = "[icon_state]20"
			if(30 to 39)	filling.icon_state = "[icon_state]30"
			if(40 to 49)	filling.icon_state = "[icon_state]40"
			if(50 to 59)	filling.icon_state = "[icon_state]50"
			if(60 to 69)	filling.icon_state = "[icon_state]60"
			if(70 to 79)	filling.icon_state = "[icon_state]70"
			if(80 to 89)	filling.icon_state = "[icon_state]80"
			if(90 to 99)	filling.icon_state = "[icon_state]90"
			if(100 to INFINITY)	filling.icon_state = "[icon_state]100"
		filling.color = reagents.get_color()
		add_overlay(filling)

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/square
	name = "half-pint glass"
	icon_state = "square"
	icon = 'icons/obj/drink_glasses/square.dmi'
	desc = "Your standard drinking glass."
	volume = 30

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/rocks
	name = "rocks glass"
	desc = "A robust tumbler with a thick, weighted bottom."
	icon_state = "rocks"
	icon = 'icons/obj/drink_glasses/rocks.dmi'
	volume = 20

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/shake
	name = "sherry glass"
	desc = "Stemware with an untapered conical bowl."
	icon_state = "shake"
	icon = 'icons/obj/drink_glasses/shake.dmi'
	volume = 30

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/cocktail
	name = "cocktail glass"
	desc = "Fragile stemware with a stout conical bowl. Don't spill."
	icon_state = "cocktail"
	icon = 'icons/obj/drink_glasses/cocktail.dmi'
	volume = 15

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/shot
	name = "shot glass"
	desc = "A small glass, designed so that its contents can be consumed in one gulp."
	icon_state = "shot"
	icon = 'icons/obj/drink_glasses/shot.dmi'
	volume = 5
	matter = list(MATERIAL_GLASS = 15)

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/pint
	name = "pint glass"
	icon_state = "pint"
	icon = 'icons/obj/drink_glasses/pint.dmi'
	volume = 60
	matter = list(MATERIAL_GLASS = 125)

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/mug
	name = "glass mug"
	desc = "A heavy mug with thick walls."
	icon_state = "mug"
	icon = 'icons/obj/drink_glasses/mug.dmi'
	volume = 40

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/wine
	name = "wine glass"
	desc = "A piece of elegant stemware."
	icon_state = "wine"
	icon = 'icons/obj/drink_glasses/wine.dmi'
	volume = 25

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/flute
	name = "flute glass"
	desc = "A piece of very elegant stemware."
	icon_state = "flute"
	icon = 'icons/obj/drink_glasses/flute.dmi'
	volume = 25

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/carafe
	name = "pitcher"
	desc = "A handled glass pitcher."
	icon_state = "carafe"
	icon = 'icons/obj/drink_glasses/carafe.dmi'
	volume = 120
	matter = list(MATERIAL_GLASS = 250)
	possible_transfer_amounts = list(5,10,15,30,60,120)

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/teacup
	name = "teacup"
	desc = "A plain white porcelain teacup."
	icon = 'icons/obj/drink_glasses/teacup.dmi'
	icon_state = "teacup"
	volume = 20

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/teacup/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/drink_glasses/teacup.dmi', src, "[icon_state]100")
		filling.color = reagents.get_color()
		add_overlay(filling)

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/cognac
	name = "snifter glass"
	desc = "A snitfer, also known as a cognac glass, made for serving aged spirits."
	icon_state = "cognac"
	icon = 'icons/obj/drink_glasses/cognac.dmi'
	volume = 20

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/goblet
	name = "goblet"
	desc = "A glass goblet, used to deliver alcohol to the upper class since ancient times."
	icon_state = "goblet"
	icon = 'icons/obj/drink_glasses/goblet.dmi'
	volume = 25

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/konyang
	name = "yunomi"
	desc = "A ceramic teacup of Japanese origin, most frequently used for teas brewed at a lower temperature because of its lack of a handle. \
			This sort of teacup is popular on Konyang, owing to the Japanese origins of some of its population. \
			This one is unglazed and the plain brownish-gray of the clay most often used on Konyang."
	icon = 'icons/obj/item/reagent_containers/teaware.dmi'
	icon_state = "yunomi"
	item_state = "yunomi"
	contained_sprite = TRUE

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/konyang/update_icon()
	if(reagents?.total_volume)
		var/mutable_appearance/filling = mutable_appearance(icon, "yunomi-[get_filling_state()]")
		filling.color = reagents.get_color()
		add_overlay(filling)

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/konyang/grey
	desc = "A ceramic teacup of Japanese origin, most frequently used for teas brewed at a lower temperature because of its lack of a handle. \
			This sort of teacup is popular on Konyang, owing to the Japanese origins of some of its population. \
			This one is unglazed and a plain stone grey color."
	icon_state = "yunomi-grey"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/konyang/pattern
	desc = "A ceramic teacup of Japanese origin, most frequently used for teas brewed at a lower temperature because of its lack of a handle. \
			This sort of teacup is popular on Konyang, owing to the Japanese origins of some of its population. \
			This one is glazed and has a simple abstract pattern."
	icon_state = "yunomi-pattern"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/konyang/manila
	desc = "A ceramic teacup of Japanese origin, most frequently used for teas brewed at a lower temperature because of its lack of a handle. \
			This sort of teacup is popular on Konyang, owing to the Japanese origins of some of its population. \
			This one is glazed and a plain manila color."
	icon_state = "yunomi-manila"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/konyang/nature
	desc = "A ceramic teacup of Japanese origin, most frequently used for teas brewed at a lower temperature because of its lack of a handle. \
			This sort of teacup is popular on Konyang, owing to the Japanese origins of some of its population. \
			This one is glazed and depicts a nature scene, showing trees native to Konyang."
	icon_state = "yunomi-nature"

