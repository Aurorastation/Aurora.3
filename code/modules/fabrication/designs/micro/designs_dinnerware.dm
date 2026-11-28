ABSTRACT_TYPE(/singleton/fabricator_recipe/dinnerware)
	name = "Abstract Dinnerware"
	category = "Dinnerware"
	fabricator_types = list(FABRICATOR_CLASS_MICRO, FABRICATOR_CLASS_GENERAL)

/singleton/fabricator_recipe/dinnerware/jar
	name = "jar"
	path = /obj/item/glass_jar

/singleton/fabricator_recipe/dinnerware/bowl
	name = "bowl"
	path = /obj/item/reagent_containers/cooking_container/board/bowl

/singleton/fabricator_recipe/dinnerware/bottle
	name = "bottle"
	path = /obj/item/reagent_containers/food/drinks/bottle

/singleton/fabricator_recipe/dinnerware/ashtray_glass
	name = "glass ashtray"
	path = /obj/item/material/ashtray/glass

ABSTRACT_TYPE(/singleton/fabricator_recipe/dinnerware/autolathe)
	name = "Abstract Autolathe Dinnerware"
	fabricator_types = list(FABRICATOR_CLASS_GENERAL)

/singleton/fabricator_recipe/dinnerware/autolathe/rolling_pin
	name = "rolling pin"
	path = /obj/item/material/kitchen/rollingpin
	resources = list(MATERIAL_STEEL = 500)

/singleton/fabricator_recipe/dinnerware/autolathe/oven_dish
	name = "oven dish"
	path = /obj/item/reagent_containers/cooking_container/oven
	resources = list(MATERIAL_STEEL = 500)

/singleton/fabricator_recipe/dinnerware/autolathe/fryer_basket
	name = "fryer basket"
	path = /obj/item/reagent_containers/cooking_container/fryer
	resources = list(MATERIAL_STEEL = 500)

/singleton/fabricator_recipe/dinnerware/autolathe/skillet
	name = "skillet"
	path = /obj/item/reagent_containers/cooking_container/skillet
	resources = list(MATERIAL_STEEL = 750)

/singleton/fabricator_recipe/dinnerware/autolathe/saucepan
	name = "saucepan"
	path = /obj/item/reagent_containers/cooking_container/saucepan
	resources = list(MATERIAL_STEEL = 750)

/singleton/fabricator_recipe/dinnerware/autolathe/pot
	name = "cooking pot"
	path = /obj/item/reagent_containers/cooking_container/pot
	resources = list(MATERIAL_STEEL = 1000)

/singleton/fabricator_recipe/dinnerware/autolathe/chopping_board
	name = "chopping board"
	path = /obj/item/reagent_containers/cooking_container/board
	resources = list(MATERIAL_PLASTIC = 500)

/singleton/fabricator_recipe/dinnerware/autolathe/ladle
	name = "ladle"
	path = /obj/item/reagent_containers/ladle
	resources = list(MATERIAL_STEEL = 300)

/singleton/fabricator_recipe/dinnerware/autolathe/tray
	name = "tray"
	path = /obj/item/tray

/singleton/fabricator_recipe/dinnerware/autolathe/tray/plate
	name = "plate tray"
	path = /obj/item/tray/plate

/singleton/fabricator_recipe/dinnerware/autolathe/tray/tea
	name = "tea tray"
	path = /obj/item/tray/tea

/singleton/fabricator_recipe/dinnerware/autolathe/serving_bowl
	name = "serving bowl"
	path = /obj/item/reagent_containers/bowl
	resources = list(MATERIAL_PLASTIC = 200)

/singleton/fabricator_recipe/dinnerware/autolathe/serving_plate
	name = "serving plate"
	path = /obj/item/reagent_containers/bowl/plate
	resources = list(MATERIAL_PLASTIC = 200)

/singleton/fabricator_recipe/dinnerware/autolathe/gravy_boat
	name = "gravy boat"
	path = /obj/item/reagent_containers/bowl/gravy_boat
	resources = list(MATERIAL_PLASTIC = 200)
