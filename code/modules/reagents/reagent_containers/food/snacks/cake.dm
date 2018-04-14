//CAKE

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake
	name = "vanilla cake"
	desc = "A plain cake, not a lie."
	icon_state = "plaincake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cake
	slices_num = 5
	filling_color = "#F7EDD5"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "vanilla" = 15)
	nutriment_amt = 20

/obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake/Initialize()
	. = ..()

/obj/item/weapon/reagent_containers/food/snacks/cake
	name = "vanilla cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#F7EDD5"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/weapon/reagent_containers/food/snacks/cake/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5, "vanilla" = 5)
	nutriment_amt = 4

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/carrot
	name = "carrot cake"
	desc = "A favorite desert of a certain wascally wabbit. Not a lie."
	icon_state = "carrotcake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cake/carrot
	slices_num = 5
	filling_color = "#FFD675"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "carrot" = 15)
	nutriment_amt = 25
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/carrotcake/Initialize()
	. = ..()
	reagents.add_reagent("imidazoline", 10)

/obj/item/weapon/reagent_containers/food/snacks/cake/carrot
	name = "carrot cake slice"
	desc = "Carrotty slice of Carrot Cake, carrots are good for your eyes! Also not a lie."
	icon_state = "carrotcake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD675"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/weapon/reagent_containers/food/snacks/cake/carrot/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5, "carrot" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cake/carrot/filled/Initialize()
	. = ..()
	reagents.add_reagent("imidazoline", 1)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/brain
	name = "brain cake"
	desc = "A squishy cake-thing."
	icon_state = "braincake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cake/brain
	slices_num = 5
	filling_color = "#E6AEDB"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "slime" = 15)
	nutriment_amt = 5
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/brain/Initialize()
	. = ..()
	reagents.add_reagent("protein", 25)
	reagents.add_reagent("alkysine", 10)

/obj/item/weapon/reagent_containers/food/snacks/cake/brain
	name = "brain cake slice"
	desc = "Lemme tell you something about prions. THEY'RE DELICIOUS."
	icon_state = "braincakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#E6AEDB"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)

/obj/item/weapon/reagent_containers/food/snacks/cake/brain/filled
	nutriment_desc = list("cake" = 2, "sweetness" = 2, "slime" = 3)
	nutriment_amt = 1
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cake/brain/filled/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)
	reagents.add_reagent("alkysine", 2)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/cheese
	name = "cheese cake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cake/cheese
	slices_num = 5
	filling_color = "#FAF7AF"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "cream" = 10)
	nutriment_amt = 10
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/cheese/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 15)

/obj/item/weapon/reagent_containers/food/snacks/cake/cheese
	name = "cheese cake slice"
	desc = "Slice of pure cheestisfaction"
	icon_state = "cheesecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAF7AF"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/weapon/reagent_containers/food/snacks/cake/cheese/filled
	nutriment_desc = list("cake" = 5, "cream" = 5)
	nutriment_amt = 2
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cake/cheese/filled/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 3)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/orange
	name = "orange cake"
	desc = "A cake with added orange."
	icon_state = "orangecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cake/orange
	slices_num = 5
	filling_color = "#FADA8E"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "orange" = 15)
	nutriment_amt = 20

/obj/item/weapon/reagent_containers/food/snacks/cake/orange
	name = "orange cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "orangecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FADA8E"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/weapon/reagent_containers/food/snacks/cake/orange/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5, "orange" = 5)
	nutriment_amt = 4

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/lime
	name = "lime cake"
	desc = "A cake with added lime."
	icon_state = "limecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cake/lime
	slices_num = 5
	filling_color = "#CBFA8E"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "lime" = 15)
	nutriment_amt = 20

/obj/item/weapon/reagent_containers/food/snacks/cake/lime
	name = "lime cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "limecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#CBFA8E"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/weapon/reagent_containers/food/snacks/cake/lime/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5, "lime" = 5)
	nutriment_amt = 4

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/lemon
	name = "lemon cake"
	desc = "A cake with added lemon."
	icon_state = "lemoncake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cake/lemon
	slices_num = 5
	filling_color = "#FAFA8E"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "lemon" = 15)
	nutriment_amt = 20

/obj/item/weapon/reagent_containers/food/snacks/cake/lemon
	name = "lemon cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "lemoncake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAFA8E"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/weapon/reagent_containers/food/snacks/cake/lemon/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5, "lemon" = 5)
	nutriment_amt = 4

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/chocolate
	name = "chocolate cake"
	desc = "A cake with added chocolate."
	icon_state = "chocolatecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cake/chocolate
	slices_num = 5
	filling_color = "#805930"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "chocolate" = 15)
	nutriment_amt = 20

/obj/item/weapon/reagent_containers/food/snacks/cake/chocolate
	name = "chocolate cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "chocolatecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#805930"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/weapon/reagent_containers/food/snacks/cake/chocolate/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5, "chocolate" = 5)
	nutriment_amt = 4

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/birthday
	name = "birthday cake"
	desc = "Happy Birthday..."
	icon_state = "birthdaycake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cake/birthday
	slices_num = 5
	filling_color = "#FFD6D6"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10)
	nutriment_amt = 20
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/birthday/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 10)

/obj/item/weapon/reagent_containers/food/snacks/cake/birthday
	name = "birthday cake slice"
	desc = "A slice of your birthday."
	icon_state = "birthdaycakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD6D6"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/weapon/reagent_containers/food/snacks/cake/birthday/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5)
	nutriment_amt = 4
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/cake/birthday/filled/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 2)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/apple
	name = "apple cake"
	desc = "A cake centred with apples."
	icon_state = "applecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cake/apple
	slices_num = 5
	filling_color = "#EBF5B8"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "apple" = 15)
	nutriment_amt = 15

/obj/item/weapon/reagent_containers/food/snacks/cake/apple
	name = "apple cake slice"
	desc = "A slice of heavenly cake."
	icon_state = "applecakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#EBF5B8"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/weapon/reagent_containers/food/snacks/cake/apple/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5, "apple" = 5)
	nutriment_amt = 3
