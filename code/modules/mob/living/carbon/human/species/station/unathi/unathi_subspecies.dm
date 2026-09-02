/datum/species/unathi/unathi_urawani
	name = SPECIES_UNATHI_URAWANI
	name_plural = "Urawani Sinta"
	blurb = "Sinta'unathi (Unathi by outsiders, Sinta by themselves) are a reptilian species native to \
	Moghes, a planet in the Uueoa-Esa system in the Badlands. First contact was made with them in 2403, \
	and they have since become a major player in galactic politics. Often known for their martial prowess, \
	they are a storied and proud species, with a history of honor, tradition and spirituality.<br><br>\
	Urawani sinta hail from the Szerakreshani continent of Moghes, and are a smaller, more agile variant \
	of sinta and are known for relying on presistence hunting tactics as opposed to the ambush tactics of \
	Azaziba sinta. Urawani sinta are the first species of unathi to make contact with humans, and are often \
	viewed as the most level-headed and diplomatically minded of the unathi species. Urawani sinta view \
	themselves as a progressive, culturally homogenous and technologically advanced variant of sinta, \
	where Azaziba generally view Urawani as small, weak and unworthy of the role as spokespeople of unathi."
	species_height = HEIGHT_CLASS_TALL
	age_max = 95
	height_min = 175 			// Shortest of all unathi races on average
	height_max = 225 			// Shortest of all unathi races on average

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws/unathi,
		/datum/unarmed_attack/palm/unathi,
		/datum/unarmed_attack/bite/sharp
	)

	stamina	=	120			// Urawani are persistence hunters
	slowdown = 0.1 				// Urawani are more on-par with humans than any other variant
	sprint_cost_factor = 0.8 		// They still cannot sprint as long as any other species
	sprint_speed_factor = 0.9	// But they do maintain slightly slower-than-human speeds
	exhaust_threshold = 50	 	// Brings them back to the standard exhaust threshold
	bp_base_systolic = 100		// Default 120
	bp_base_disatolic = 60		// Default 80
	low_pulse = 30				// Default 40
	norm_pulse = 50			// Default 60
	fast_pulse = 80				// Default 90
	v_fast_pulse = 100			// Default 120
	max_pulse = 120			// Default 160

	stomach_capacity = 6
	max_nutrition_factor = 1.2
	max_hydration_factor = 1.2
	nutrition_loss_factor = 1
	hydration_loss_factor = 1

	pain_mod = 1				// Standard pain
	fall_mod = 0.9				// Acclimated to quick movement through trees
	grab_mod = 1				// Lithe and wily variants
	resist_mod = 1.5 			// Physically the weakest sinta, but still big lizardmen
	toxins_mod = 1.1			// They pump blood very quickly
	bleed_mod = 1.1				// They pump blood very quickly
	metabolism_mod = 1.1		// They pump blood very quickly

	natural_armor = list(
		ballistic = ARMOR_BALLISTIC_MINOR,
		melee = ARMOR_MELEE_KNIVES,
		laser = ARMOR_LASER_MINOR,
		rad =  ARMOR_RAD_MINOR
	)							// Osteodermous integumentary system

	climb_coeff = 0.8			// Acclimated to quick movement through trees
	standing_jump_range = 3	// Acclimated to quick movement through trees
	natural_climbing = TRUE	// Acclimated to quick movement through trees

	cold_level_1 = 260 //Default 260 - Lower is better
	cold_level_2 = 200 //Default 200
	cold_level_3 = 120 //Default 120

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 460 //Default 400
	heat_level_3 = 1060 //Default 1000

	heat_discomfort_level = 311 // 37°C
	heat_discomfort_strings = list(
		"You feel soothingly warm.",
		"You feel the heat sink into your bones.",
		"You feel warm enough to take a nap."
		)

	cold_discomfort_level = 291  // 18°C
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You feel sluggish and cold.",
		"Your scales bristle against the cold."
		)

	rarity_value = 3
	break_cuffs = FALSE
	mob_size = 9
	mob_weight = MOB_WEIGHT_MEDIUM
	mob_strength = MOB_STRENGTH_NORMAL

	maneuvers = list(
		/singleton/maneuver/leap
	)

	mass_modifier = REFERENCE_MASS_UNATHI_URAWANI / REFERENCE_MASS_HUMAN



/datum/species/unathi/unathi_Ziralixi
	name = SPECIES_UNATHI_ZIRALIXI
	name_plural = "Ziralixi Sinta"
	blurb = "Sinta'unathi (Unathi by outsiders, Sinta by themselves) are a reptilian species native to \
	Moghes, a planet in the Uueoa-Esa system in the Badlands. First contact was made with them in 2403, \
	and they have since become a major player in galactic politics. Often known for their martial prowess, \
	they are a storied and proud species, with a history of honor, tradition and spirituality.<br><br>\
	Ziralixi sinta hail from the Szerakreshani continent of Moghes similarly to Urawani sinta, and are somewhat \
	of a middle ground between the two species. While it is commonly accepted that they are a literal mixture of \
	the two species, they are not a hybrid species and are instead a distinct species of sinta that evolved \
	independently. Ziralixi are persistence hunters, but due to the longer, flatter distances covering their \
	subcontinent, they are often slower and more methodical than Urawani sinta. Ziralixi are often viewed as \
	the most peaceful of the unathi species, with their culture being more focused on spirituality and growth- \
	both spiritually and physically, with many of the grasslands of their subcontinent being used for farming, \
	unlike the other species."
	species_height = HEIGHT_CLASS_TALL
	age_max = 95
	height_min = 185 			// Bigger cousins of Urawani sinta
	height_max = 235 			// Bigger cousins of Urawani sinta

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws/unathi,
		/datum/unarmed_attack/palm/unathi,
		/datum/unarmed_attack/bite/sharp
	)

	stamina	=	100				// Ziralixi are persistence hunters
	slowdown = 0.3 				// Ziralixi are slower, more methodical runners
	sprint_cost_factor = 0.7
	sprint_speed_factor = 0.7
	exhaust_threshold = 50	 	// Brings them back to the standard exhaust threshold
	bp_base_systolic = 90		// Default 120
	bp_base_disatolic = 55		// Default 80
	low_pulse = 25				// Default 40
	norm_pulse = 45				// Default 60
	fast_pulse = 70				// Default 90
	v_fast_pulse = 90			// Default 120
	max_pulse = 110				// Default 160

	stomach_capacity = 6
	max_nutrition_factor = 1.3
	max_hydration_factor = 1.3
	nutrition_loss_factor = 0.9
	hydration_loss_factor = 0.9

	pain_mod = 1				// Standard pain
	grab_mod = 1.25				// Easier to grab than Urawani
	resist_mod = 2				// Not as strong as Azaziba but still fairly buff
	flash_mod = 1.1				// Parietal eye sensitivity

	natural_armor = list(
		ballistic = ARMOR_BALLISTIC_MINOR,
		melee = ARMOR_MELEE_KNIVES,
		laser = ARMOR_LASER_SMALL,
		rad =  ARMOR_RAD_MINOR,
		bio = ARMOR_BIO_MINOR

	)							// Tuberculate integumentary system plus subtympanic shield

	climb_coeff = 1.1			// Closer to Azaziba than Urawani here
	standing_jump_range = 2	// More mobile than Azaziba, but not as much as Urawani

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 140 //Default 120

	heat_level_1 = 460 //Default 360 - Higher is better
	heat_level_2 = 500 //Default 400
	heat_level_3 = 1100 //Default 1000

	heat_discomfort_level = 316 // 43°C
	heat_discomfort_strings = list(
		"You feel soothingly warm.",
		"You feel the heat sink into your bones.",
		"You feel warm enough to take a nap."
		)

	cold_discomfort_level = 297  // 24°C
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You feel sluggish and cold.",
		"Your scales bristle against the cold."
		)

	rarity_value = 3
	break_cuffs = TRUE
	mob_size = 10
	mob_weight = MOB_WEIGHT_HEAVY
	mob_strength = MOB_STRENGTH_NORMAL

	maneuvers = list(
		/singleton/maneuver/leap
	)

	mass_modifier = REFERENCE_MASS_UNATHI_ZIRALIXI / REFERENCE_MASS_HUMAN
