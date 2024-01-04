//
// Freezer
//
/obj/structure/closet/secure_closet/freezer
	name = "freezer"
	desc = "A freezer."
	icon_state = "freezer"
	door_anim_squish = 0.22
	door_anim_angle = 123

// Meat Freezer
/obj/structure/closet/secure_closet/freezer/meat
	name = "meat freezer"

/obj/structure/closet/secure_closet/freezer/meat/fill()
	..()
	for(var/i = 0, i < 8, i++)
		new /obj/item/reagent_containers/food/snacks/meat(src)

/obj/structure/closet/secure_closet/freezer/meat/super_meat/fill() // This is enough meat to do 10 grill batches.
	for(var/i = 0, i < 30, i++)
		new /obj/item/reagent_containers/food/snacks/meat(src)
	var/obj/item/reagent_containers/food/condiment/shaker/spacespice/SS = new(src)
	SS.pixel_x = 6
	SS.pixel_y = 12
	var/obj/item/reagent_containers/food/condiment/shaker/salt/S = new(src)
	S.pixel_x = 6
	S.pixel_y = 10
	var/obj/item/reagent_containers/food/condiment/shaker/peppermill/P = new(src)
	P.pixel_x = 6
	P.pixel_y = 8

// Chicken and Fish Freezer
/obj/structure/closet/secure_closet/freezer/chicken_and_fish
	name = "chicken and fish freezer"

/obj/structure/closet/secure_closet/freezer/chicken_and_fish/fill()
	..()
	// 6 Chicken Fillets
	for(var/i = 0, i < 6, i++)
		new /obj/item/reagent_containers/food/snacks/meat/chicken(src)
	// 6 Fish Fillets
	for(var/i = 0, i < 6, i++)
		new /obj/item/reagent_containers/food/snacks/fish/fishfillet(src)

/obj/structure/closet/secure_closet/freezer/fridge
	name = "refrigerator"
	desc = "A refrigerator."

/obj/structure/closet/secure_closet/freezer/fridge/fill()
	..()
	for(var/i = 0, i < 5, i++)
		new /obj/item/reagent_containers/food/drinks/carton/milk(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_containers/food/drinks/carton/soymilk(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/storage/box/fancy/egg_box(src)

/obj/structure/closet/secure_closet/freezer/kitchen
	name = "kitchen cabinet"
	desc = "A cabinet."
	req_access = list(ACCESS_KITCHEN)

/obj/structure/closet/secure_closet/freezer/kitchen/fill()
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_containers/food/condiment/flour(src)
	new /obj/item/reagent_containers/food/condiment/sugar(src)
	new /obj/item/reagent_containers/food/condiment/shaker/spacespice(src)

/obj/structure/closet/secure_closet/freezer/kitchen/mining
	req_access = list()

/obj/structure/closet/secure_closet/freezer/money
	name = "freezer"
	desc = "This contains cold hard cash."
	req_access = list(ACCESS_HEADS_VAULT)

/obj/structure/closet/secure_closet/freezer/money/fill()
	..()
	for(var/i = 0, i < rand(15,25), i++)
		new /obj/random/spacecash(src)

	for(var/i = 0, i < rand(6,9), i++)
		new /obj/random/coin(src)

/obj/structure/closet/secure_closet/freezer/cafe/fill()
	..()
	for(var/i = 0, i < 6, i++)
		new /obj/item/reagent_containers/food/drinks/carton/milk(src)
	for(var/i = 0, i < 3, i++)
		new /obj/item/storage/box/fancy/egg_box(src)
		new /obj/item/reagent_containers/food/condiment/flour(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_containers/food/drinks/carton/soymilk(src)
		new /obj/item/reagent_containers/food/condiment/sugar(src)

/obj/structure/closet/secure_closet/freezer/kois
	name = "k'ois freezer"
	desc = "A freezer with k'ois inside. Don't eat this unless you're a Vaurca!"

/obj/structure/closet/secure_closet/freezer/kois/fill()
	..()
	for(var/i = 0, i < 8, i++)
		new /obj/item/reagent_containers/food/snacks/grown/kois(src)
