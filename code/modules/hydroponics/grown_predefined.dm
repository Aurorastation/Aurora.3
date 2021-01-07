// Predefined types for placing on the map.

/obj/item/reagent_containers/food/snacks/grown/mushroom
	plantname = "amanita"

/obj/item/reagent_containers/food/snacks/grown/mushroom/libertycap
	plantname = "libertycap"

/obj/item/reagent_containers/food/snacks/grown/mushroom/glowshroom
	plantname = "glowshroom"

/obj/item/reagent_containers/food/snacks/grown/mushroom/reishi
	plantname = "reishi"

/obj/item/reagent_containers/food/snacks/grown/mushroom/destroyingangel
	plantname = "destroyingangel"

/obj/item/reagent_containers/food/snacks/grown/mushroom/ghostmushroom
	plantname = "ghostmushroom"

/obj/item/reagent_containers/food/snacks/grown/ambrosiavulgaris
	plantname = "ambrosia"

/obj/item/reagent_containers/food/snacks/grown/ambrosiadeus
	plantname = "ambrosiadeus"

/obj/item/reagent_containers/food/snacks/grown/kois
	plantname = "koisspore"

/obj/item/reagent_containers/food/snacks/grown/banana
	plantname = "banana"

/obj/item/reagent_containers/food/snacks/grown/banana/afterattack(atom/A, mob/living/carbon/human/user, proximity)
	if(!proximity && istype(user) && iscarbon(A))
		if(!user.aiming)
			user.aiming = new(user)
		if(user.client && user.aiming.active && user.aiming.aiming_at != A)
			user.face_atom(A)
			user.aiming.aim_at(A, src)
			return

	return ..()