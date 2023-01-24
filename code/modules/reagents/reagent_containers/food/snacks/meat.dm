/obj/item/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat."
	icon_state = "meat"
	health = 180
	filling_color = "#FF1C1C"
	center_of_mass = list("x"=16, "y"=14)
	cooked_icon = "meatstake"
	slice_path = /obj/item/reagent_containers/food/snacks/rawcutlet
	slices_num = 3
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/nutriment/triglyceride = 2)
	bitesize = 1.5

/obj/item/reagent_containers/food/snacks/meat/cook()

	if (!isnull(cooked_icon))
		icon_state = cooked_icon
		flat_icon = null //Force regenating the flat icon for coatings, since we've changed the icon of the thing being coated
	..()

	if (name == initial(name))
		name = "cooked [name]"

/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

// TODO cancelled, subtypes are fine. recipes use istype checks
/obj/item/reagent_containers/food/snacks/meat/human

/obj/item/reagent_containers/food/snacks/meat/bug
	filling_color = "#E6E600"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/nutriment/triglyceride = 2, /singleton/reagent/toxin/phoron/base = 27)
	bitesize = 1.5

/obj/item/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/reagent_containers/food/snacks/meat/neaera
	name = "neaera meat"
	icon_state = "neaera_meat"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 3, /singleton/reagent/nutriment/protein/seafood = 3, /singleton/reagent/nutriment/triglyceride = 2)

/obj/item/reagent_containers/food/snacks/meat/corgi
	name = "corgi meat"
	desc = "Tastes like... well, you know."

/obj/item/reagent_containers/food/snacks/meat/chicken
	name = "chicken meat"
	icon_state = "chickenbreast"
	cooked_icon = "chickenbreast_cooked"
	filling_color = "#BBBBAA"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6) //Chicken is low fat. Less total calories than other meats

/obj/item/reagent_containers/food/snacks/meat/pig
	name = "pig meat"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/nutriment/triglyceride = 4)

/obj/item/reagent_containers/food/snacks/meat/biogenerated
	name = "meat substitute"
	desc = "A slab of extruded plant bits that pretends to be meat."
	icon_state = "plantmeat"
	filling_color = "#A8AA00"
	reagents_to_add = list(/singleton/reagent/nutriment = 6)

/obj/item/reagent_containers/food/snacks/meat/undead
	name = "rotten meat"
	desc = "A slab of rotten meat."
	icon_state = "shadowmeat"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/toxin/undead = 5)

/obj/item/reagent_containers/food/snacks/meat/adhomai
	name = "adhomian meat"
	desc = "A slab of an animal native from Adhomai."
	icon_state = "adhomai_meat"
	desc_extended = "For much of Tajaran history, the herbivorous and graceful Nav'twir were the main prey of Tajaran hunters, and still are today in rural areas of the planet. \
	Their meat was nice and hearty and healthy, and the thick furs were good for making clothes to keep themselves warm in the snow. As the modern ages came, the hunting of the \
	'striders', as their name translates, slowed as the Tajara started to learn how to capture and farm them for their resources more efficiently. That being said, not that the modern \
	day Adhomai needs their resources less thanks to synthetic fabric and more efficient food sources, both the meat and the fur of the nav'twir has become an export of the Adhomai \
	people. In the olden days, carved nav'twir antlers were used as decoration for pelts and armors."

/obj/item/reagent_containers/food/snacks/meat/rat
	name = "rat meat"
	icon_state = "chickenbreast"
	desc = "You have reached the epitome of poorness: eating the station's vermin."
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 5, /singleton/reagent/nutriment/triglyceride = 2)
	bitesize = 1.5

/obj/item/reagent_containers/food/snacks/meat/dionanymph
	name = "diona nymph meat"
	desc = "A slab of weird green meat."
	icon_state = "plantmeat"
	reagents_to_add = list(/singleton/reagent/diona_powder = 10)

/obj/item/reagent_containers/food/snacks/meat/vannatusk
	desc = "A slab of weird blue meat."
	icon = 'icons/mob/npc/vannatusk.dmi'
	icon_state = "vannameat"
	item_state = "vannameat"
	contained_sprite = TRUE
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/mindbreaker = 6)

/obj/item/reagent_containers/food/snacks/meat/bat
	name = "bat wings"
	desc = "Like chicken wings, but with even less meat!"
	icon_state = "batmeat"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 1)
