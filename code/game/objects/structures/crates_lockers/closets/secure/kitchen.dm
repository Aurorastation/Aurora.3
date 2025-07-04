//
// Refrigerators
//

// Empty Refrigerator
/obj/structure/closet/secure_closet/refrigerator
	name = "refrigerator"
	desc = "A white refrigerator."
	icon_state = "refrigerator"
	door_anim_squish = 0.22
	door_anim_angle = 123

// Standard Refrigerator
/obj/structure/closet/secure_closet/refrigerator/standard/fill()
	// 5 Cartons of Milk
	for(var/i = 0, i < 5, i++)
		new /obj/item/reagent_containers/food/drinks/carton/milk(src)
	// 2 Cartons of Soy Milk
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_containers/food/drinks/carton/soymilk(src)
	// 1 Egg Box
	for(var/i = 0, i < 2, i++)
		new /obj/item/storage/box/fancy/egg_box(src)
	// 1 Stick of Butter
	for(var/i = 0, i < 1, i++)
		new /obj/item/reagent_containers/food/snacks/spreads/butter(src)
	// 4 Random Condiments
	for(var/i = 0, i < 4, i++)
		new /obj/random/condiment(src)
	// 2 Random Kitchen Staples
	for(var/i = 0, i < 2, i++)
		new /obj/random/kitchen_staples(src)

// Cafe Refrigerator
/obj/structure/closet/secure_closet/refrigerator/cafe/fill()
	// 6 Cartons of Milk
	for(var/i = 0, i < 6, i++)
		new /obj/item/reagent_containers/food/drinks/carton/milk(src)
	// 3 Egg Boxes
	// 3 Bags of Flour
	for(var/i = 0, i < 3, i++)
		new /obj/item/storage/box/fancy/egg_box(src)
		new /obj/item/reagent_containers/food/condiment/flour(src)
	// 2 Cartons of Soymilk and 2 Bags of Sugar
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_containers/food/drinks/carton/soymilk(src)
		new /obj/item/reagent_containers/food/condiment/sugar(src)

//
// Freezers
//

// Empty Freezer
/obj/structure/closet/secure_closet/freezer
	name = "freezer"
	desc = "A white freezer."
	icon_state = "freezer"
	door_anim_squish = 0.22
	door_anim_angle = 123

// Meat Freezer
/obj/structure/closet/secure_closet/freezer/meat
	name = "meat freezer"
	desc = "A white freezer labelled \"Meat\"."

/obj/structure/closet/secure_closet/freezer/meat/fill()
	for(var/i = 0, i < 8, i++)
		new /obj/item/reagent_containers/food/snacks/meat(src)

/obj/structure/closet/secure_closet/freezer/meat/low_supply/fill()
	for(var/i = 0, i < 4, i++)
		new /obj/item/reagent_containers/food/snacks/meat(src)

// Grilling Meat Freezer
// Enough meat to do 10 grill batches.
/obj/structure/closet/secure_closet/freezer/meat/grill/fill()
	// 30 Meat
	for(var/i = 0, i < 30, i++)
		new /obj/item/reagent_containers/food/snacks/meat(src)
	// 1 Salt Shaker
	var/obj/item/reagent_containers/food/condiment/shaker/salt/S = new(src)
	S.pixel_x = 6
	S.pixel_y = 10
	// 1 Pepper Shaker
	var/obj/item/reagent_containers/food/condiment/shaker/peppermill/P = new(src)
	P.pixel_x = 6
	P.pixel_y = 8
	// 1 Space Spice Shaker
	var/obj/item/reagent_containers/food/condiment/shaker/spacespice/SS = new(src)
	SS.pixel_x = 6
	SS.pixel_y = 12

// Chicken and Fish Freezer
/obj/structure/closet/secure_closet/freezer/chicken_and_fish
	name = "chicken and fish freezer"
	desc = "A white freezer labelled \"Chicken and Fish\"."

/obj/structure/closet/secure_closet/freezer/chicken_and_fish/fill()
	// 6 Chicken and Fish Fillets
	for(var/i = 0, i < 6, i++)
		new /obj/item/reagent_containers/food/snacks/meat/chicken(src)
		new /obj/item/reagent_containers/food/snacks/fish/fishfillet(src)

/obj/structure/closet/secure_closet/freezer/chicken_and_fish/low_supply/fill()
	for(var/i = 0, i < 3, i++)
		new /obj/item/reagent_containers/food/snacks/meat/chicken(src)
		new /obj/item/reagent_containers/food/snacks/fish/fishfillet(src)

// Empty Biohazard Freezer
/obj/structure/closet/secure_closet/freezer/kois
	name = "biohazard freezer"
	desc = "A freezer, painted in a sickly yellow, with a biohazard sign on the door."
	icon_state = "freezer_biohazard"

// K'ois Freezer
/obj/structure/closet/secure_closet/freezer/kois/spores
	name = "k'ois freezer"
	desc = "A freezer labelled \"K'ois\", painted in a sickly yellow, with a biohazard sign on the door. "

/obj/structure/closet/secure_closet/freezer/kois/spores/fill()
	// 8 K'ois
	for(var/i = 0, i < 8, i++)
		new /obj/item/reagent_containers/food/snacks/grown/kois(src)

//
// Kitchen Cabinets
//

// Empty Kitchen Cabinet
/obj/structure/closet/secure_closet/kitchen_cabinet
	name = "kitchen cabinet"
	desc = "A white kitchen cabinet."

// Standard Kitchen Cabinet
/obj/structure/closet/secure_closet/kitchen_cabinet/standard/fill()
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_containers/food/condiment/flour(src)
	new /obj/item/reagent_containers/food/condiment/sugar(src)
	new /obj/item/reagent_containers/food/condiment/shaker/spacespice(src)

//
// Miscellaneous
//

// Money
// Used on the Grand Romanovich.
/obj/structure/closet/secure_closet/freezer/money
	name = "credits freezer"
	desc = "This contains cold, hard credits."

/obj/structure/closet/secure_closet/freezer/money/fill()
	for(var/i = 0, i < rand(15, 25), i++)
		new /obj/random/spacecash(src)

	for(var/i = 0, i < rand(6, 9), i++)
		new /obj/random/coin(src)
