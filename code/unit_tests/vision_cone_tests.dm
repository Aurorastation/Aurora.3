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

/datum/unit_test/vision_cone_layers
	name = "MOB: Vision cone passes preserve mob layers"
	groups = list("mob")

/datum/unit_test/vision_cone_layers/start_test()
	var/mob/living/first = new
	var/mob/living/second = new
	. = check_layers(first, second)
	qdel(first)
	qdel(second)

/datum/unit_test/vision_cone_layers/proc/check_layers(mob/living/first, mob/living/second)
	TEST_ASSERT_NOTNULL(first.vision_cone_layer, "Living mobs must join a rendering pass.")
	TEST_ASSERT_EQUAL(first.vision_cone_layer, second.vision_cone_layer, "Mobs on the same layer must share one pass.")
	TEST_ASSERT_EQUAL(first.layer, MOB_LAYER, "The mob's gameplay layer must remain unchanged.")
	TEST_ASSERT_EQUAL(first.vision_cone_layer.target_layer, MOB_LAYER, "Standing mobs must relay at their original layer.")
	first.set_layer(HIDING_MOB_LAYER)
	TEST_ASSERT_EQUAL(first.vision_cone_layer.target_layer, HIDING_MOB_LAYER, "Hiding must change the output layer immediately.")
	TEST_ASSERT(first.plane != second.plane, "Different layers need separate masked passes.")
	first.set_layer(ABOVE_DOOR_LAYER + 0.1)
	TEST_ASSERT_EQUAL(first.vision_cone_layer.target_layer, ABOVE_DOOR_LAYER + 0.1, "Grabs and buckling must support arbitrary layers.")
	first.reset_plane_and_layer()
	TEST_ASSERT_EQUAL(first.vision_cone_layer, second.vision_cone_layer, "Resetting appearance must restore the original pass.")
	// Use a unique layer so removal can be checked regardless of mobs on the test map.
	first.set_layer(123.456)
	var/source_plane = first.plane
	TEST_ASSERT_NOTNULL(GLOB.vision_cone_planes["[source_plane]"], "The occupied pass must be registered.")
	first.set_layer(MOB_LAYER)
	TEST_ASSERT_NULL(GLOB.vision_cone_planes["[source_plane]"], "An unused pass must be released.")
	second.render_target = "vision_cone_test_source"
	first.render_target = "vision_cone_test_copy"
	first.copy_visual_appearance(second)
	TEST_ASSERT_EQUAL(first.vision_cone_layer, second.vision_cone_layer, "Copying a mob must join its visible layer's pass.")
	TEST_ASSERT_EQUAL(first.render_target, "vision_cone_test_copy", "Disguises must keep their own live render target.")
	first.plane = HUD_PLANE
	first.set_layer(FLOAT_LAYER)
	TEST_ASSERT_NULL(first.vision_cone_layer, "Explicit non-game appearances must leave the mob pass.")
	TEST_ASSERT_EQUAL(first.plane, HUD_PLANE, "Updating a preview layer must preserve its explicit plane.")
	TEST_PASS("Shared mob passes track hiding, arbitrary layer changes, reset and release.")
	return TRUE

/datum/unit_test/vision_cone_dionae
	name = "MOB: Dionae retain all-around vision"
	groups = list("mob")

/datum/unit_test/vision_cone_dionae/start_test()
	var/mob/living/carbon/human/diona/worker = new
	var/mob/living/carbon/human/diona/coeus/coeus = new
	var/obj/item/clothing/head/helmet/helmet = new
	worker.head = helmet
	var/worker_has_cone = worker.has_vision_cone()
	var/coeus_has_cone = coeus.has_vision_cone()
	worker.head = null
	qdel(helmet)
	qdel(worker)
	qdel(coeus)
	TEST_ASSERT(!worker_has_cone, "Dionae must retain all-around vision even in armored helmets.")
	TEST_ASSERT(!coeus_has_cone, "Coeus Dionae must also retain all-around vision.")
	TEST_PASS("Dionae and Coeus are exempt from vision cones.")
	return TRUE
