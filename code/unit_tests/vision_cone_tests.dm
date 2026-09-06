/datum/unit_test/vision_cone_periphery
	name = "MOB: Vision cone has a compact peripheral opening"
	groups = list("mob")

/datum/unit_test/vision_cone_periphery/start_test()
	var/icon/mask = get_vision_cone_peripheral_mask()
	var/center = ceil(mask.Width() / 2 + 0.5)
	// Adjacent tile centers remain visible without clearing their entire far edges.
	for(var/offset in list(-world.icon_size, 0, world.icon_size))
		TEST_ASSERT_EQUAL(mask.GetPixel(center + offset, center), "#ffffff", "Cardinally adjacent tile centers must remain visible.")
		TEST_ASSERT_EQUAL(mask.GetPixel(center, center + offset), "#ffffff", "Cardinally adjacent tile centers must remain visible.")
	var/far_edge = world.icon_size * 1.5
	TEST_ASSERT_NULL(mask.GetPixel(center + far_edge, center), "The opening must stop short of the adjacent tile's far edge.")
	TEST_ASSERT_NULL(mask.GetPixel(center, center + far_edge), "The opening must stop short of the adjacent tile's far edge.")
	TEST_ASSERT_NULL(mask.GetPixel(1, 1), "The opening must remain circular.")
	TEST_ASSERT_NULL(mask.GetPixel(mask.Width(), mask.Height()), "The opening must remain circular.")
	var/edge_x = center + round(world.icon_size * 1.125)
	var/edge_color = mask.GetPixel(edge_x, center)
	TEST_ASSERT(!isnull(edge_color) && edge_color != "#ffffff", "The edge must fade through partial opacity.")
	TEST_ASSERT_EQUAL(edge_color, mask.GetPixel(mask.Width() - edge_x + 1, center), "The fade must be symmetric.")
	TEST_PASS("The circular opening keeps nearby tile centers clear and fades at its edge.")
	return TRUE

/datum/unit_test/vision_cone_equipment
	name = "MOB: Equipment vision restrictions"
	groups = list("mob")

/datum/unit_test/vision_cone_equipment/start_test()
	var/mob/living/carbon/human/wearer = new
	var/obj/item/clothing/head/helmet/helmet = new
	var/obj/item/clothing/head/helmet/space/softsuit = new
	var/obj/item/clothing/head/hat = new
	var/obj/item/clothing/mask/mask = new
	. = check_equipment(wearer, helmet, softsuit, hat, mask)
	wearer.head = null
	wearer.wear_mask = null
	qdel(mask)
	qdel(hat)
	qdel(softsuit)
	qdel(helmet)
	qdel(wearer)

/datum/unit_test/vision_cone_equipment/proc/check_equipment(mob/living/carbon/human/wearer, obj/item/clothing/head/helmet/helmet, obj/item/clothing/head/helmet/space/softsuit, obj/item/clothing/head/hat, obj/item/clothing/mask/mask)
	TEST_ASSERT_EQUAL(wearer.get_vision_cone_state(), "combat", "No equipment must preserve the default cone.")
	wearer.head = helmet
	TEST_ASSERT_EQUAL(wearer.get_vision_cone_state(), "behind", "An armored helmet must restrict the rear half.")
	wearer.head = null
	TEST_ASSERT_EQUAL(wearer.get_vision_cone_state(), "combat", "Removing the helmet must restore the cone.")
	wearer.head = softsuit
	TEST_ASSERT_EQUAL(wearer.get_vision_cone_state(), "combat", "Environmental protection alone must not restrict vision.")
	wearer.head = hat
	TEST_ASSERT_EQUAL(wearer.get_vision_cone_state(), "combat", "Ordinary hats must not restrict vision.")

	var/datum/component/armor/helmet_armor = helmet.GetComponent(/datum/component/armor)
	TEST_ASSERT_NOTNULL(helmet_armor, "The test helmet must have an armor component.")
	wearer.head = helmet
	for(var/armor_type in list(MELEE, BULLET, LASER, ENERGY, BOMB))
		helmet_armor.armor_values = list()
		helmet_armor.armor_values[armor_type] = 1
		TEST_ASSERT_EQUAL(wearer.get_vision_cone_state(), "behind", "Every combat armor category must restrict vision.")
	helmet_armor.armor_values = list(BIO = 100, RAD = 100)
	TEST_ASSERT_EQUAL(wearer.get_vision_cone_state(), "combat", "Restrictions must follow live armor values.")

	// All combinations must select matching terrain and mob masks.
	wearer.head = hat
	wearer.wear_mask = mask
	var/list/states = list("combat", "behind", "left", "behind_l", "right", "behind_r", "both", "both")
	var/list/available_states = icon_states('icons/mob/vision_cone.dmi')
	for(var/restrictions in 0 to 7)
		hat.vision_cone_restrictions = restrictions & FOV_RESTRICT_BEHIND
		mask.vision_cone_restrictions = restrictions & (FOV_RESTRICT_LEFT | FOV_RESTRICT_RIGHT)
		var/state = wearer.get_vision_cone_state()
		TEST_ASSERT_EQUAL(state, states[restrictions + 1], "Head and mask restrictions must combine.")
		TEST_ASSERT((state in available_states) && ("[state]_v" in available_states), "Both cone masks must exist.")
	TEST_PASS("Armored helmets restrict vision, removal restores it, and head/mask restrictions combine correctly.")
	return TRUE
