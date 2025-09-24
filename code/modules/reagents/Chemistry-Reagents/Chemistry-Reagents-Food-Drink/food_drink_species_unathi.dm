//
// Food related
//


//
// Drinks
//
/singleton/reagent/drink/tea/desert_tea //not in butanol path since xuizi is strength 5 by itself so the alcohol content is negligible when mixed
	name = "Desert Blossom Tea"
	description = "A simple, semi-sweet tea from Moghes, that uses a little xuizi juice for flavor."
	color = "#A8F062"
	taste_description = "sweet cactus water"

	glass_icon_state = "deserttea"
	glass_name = "cup of desert blossom tea"
	glass_desc = "A simple, semi-sweet tea from Moghes, popular with guildsmen and peasants."

//
// Juices
//
/singleton/reagent/drink/sarezhiberryjuice
	name = "Sarezhi Berry Juice"
	description = "The tart juice of the sarezhi berry, a rare Moghresian crop which is fermented into the famed Sarezshi Wine"
	color = "#bf8fbc"
	taste_description = "tart, bitter berry juice"
	glass_icon_state = "berryjuice"
	glass_name = "glass of sarezhi berry juice"
	glass_desc = "A glass of bitter, tart sarezhi juice. You know you're meant to make this into wine before drinking it, right?"

/singleton/reagent/drink/sthberryjuice
	name = "S'th Berry Juice"
	description = "The sweet, delectable juice of the S'th berry, a Moghresian fruit found in the Izweski Heartland"
	color = "#880029"
	taste_description = "sweet berry juice"
	glass_icon_state = "berryjuice"
	glass_name = "glass of S'th berry juice"
	glass_desc = "A glass of S'th berry juice, an Unathi delicacy"

//
// Butanol-based alcoholic drinks
//

/singleton/reagent/alcohol/butanol/xuizijuice
	name = "Xuizi Juice"
	description = "Blended flower buds from a Moghean Xuizi cactus. Has a mild butanol content and is a staple recreational beverage in Unathi culture."
	color = "#91de47"
	strength = 5
	taste_description = "water"
	species_taste_description = list(
		SPECIES_UNATHI = "a bit of watermelon and strawberry with a hint of salt"
	)

	glass_icon_state = "xuiziglass"
	glass_name = "glass of Xuizi Juice"
	glass_desc = "The clear green liquid smells like vanilla, tastes like water. Unathi swear it has a rich taste and texture."

	value = 0.2

/singleton/reagent/alcohol/butanol/sarezhiwine
	name = "Sarezhi Wine"
	description = "An alcoholic beverage made from lightly fermented Sareszhi berries, considered an upper class delicacy on Moghes. Significant butanol content indicates intoxicating effects on Unathi."
	color = "#bf8fbc"
	strength = 20
	taste_description = "berry juice"

	glass_icon_state = "sarezhiglass"
	glass_name = "glass of Sarezhi Wine"
	glass_desc = "It tastes like plain berry juice. Is this supposed to be alcoholic?"

/singleton/reagent/alcohol/butanol/threetownscider
	name = "Three Towns Cider"
	description = "A cider made on the west coast of the Moghresian Sea, this is simply one of many brands made in a region known for its craft local butanol, shipped throughout the Wasteland."
	color = "#b8f77e"
	strength = 20
	taste_description = "bittersweet root juice"

//Kaed's Unathi Cocktails
//=======
//What an exciting time we live in, that lizards may drink fruity girl drinks.
/singleton/reagent/alcohol/butanol/healerspride
	name = "Healer's Pride"
	description = "Traditionally, this sweet and sour cocktail was kept for healers, meant to be consumed after noteworthy interventions, like saving patients from grievous wounds or mortal diseases. \
	Nowadays it is enjoyed by all, except in the most traditional of clans."
	color = "#8CFF8C"
	strength = 30
	taste_description = "lime juice"

	glass_icon_state = "healerspride"
	glass_name = "glass of Healer's Pride"
	glass_desc = "Traditionally, this sweet and sour cocktail was kept for healers, meant to be consumed after noteworthy interventions, like saving patients from grievous wounds or mortal diseases. \
	Nowadays it is enjoyed by all, except in the most traditional of clans."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/butanol/palacedelight
	name = "Palace Delight"
	description = "A creamy, delightfully sweet drink, especially popular among Moghesian noblewomen. The typical berries used in this recipe became endangered after the Contact War, \
	thus, use of non-Moghesian berries as a replacement became common."
	color = "#ff666"
	strength = 15
	taste_description = "creamy berries"

	glass_icon_state = "palacedelight"
	glass_name = "glass of Palace Delight"
	glass_desc = "A creamy, delightfully sweet drink, especially popular among Moghesian noblewomen. The typical berries used in this recipe became endangered after the Contact War, \
	thus, use of non-Moghesian berries as a replacement became common.
	glass_center_of_mass = list("x"=17, "y"=8)

/singleton/reagent/alcohol/butanol/forestsbounty
	name = "Forest's Bounty"
	description = "There was never a single recipe for the Forest’s Bounty, rather, it was meant \
	to be a cheap cocktail, made with whatever a Unathi could find in Moghes’ forests. With the Wastes ravaging Moghes’ forests and jungles, however, making this drink became much harder… And more expensive."
	color = "#FF7F3B"
	strength = 15
	taste_description = "sweet lemons"

	glass_icon_state = "forestsbounty"
	glass_name = "glass of Forest's Bounty"
	glass_desc = "There was never a single recipe for the Forest’s Bounty, rather, it was meant \
	to be a cheap cocktail, made with whatever a Unathi could find in Moghes’ forests. With the Wastes ravaging Moghes’ forests and jungles, however, making this drink became much harder… And more expensive."
	glass_center_of_mass = list("x"=16, "y"=5)

/singleton/reagent/alcohol/butanol/senssecret
	name = "Sen's Secret"
	description = "An old, famous Moghesian cocktail originating from the city of Sen. Only a few people in Sen knew the original recipe, lost with the destruction of the city during the Contact War. \
	Modern takes on Sen’s Secret are only attempts to imitate the original thing."
	color = "#8CFF8C"
	strength = 20
	taste_description = "creamy fruit"

	glass_icon_state = "senssecret"
	glass_name = "glass of Sen's Secret"
	glass_desc = "An old, famous Moghesian cocktail originating from the city of Sen. Only a few people in Sen knew the original recipe, lost with the destruction of the city during the Contact War. \
	Modern takes on Sen’s Secret are only attempts to imitate the original thing."

/singleton/reagent/alcohol/butanol/fishersreward
	name = "Fisher's Reward"
	description = "A fresh and pleasant drink. Traditionally, this simple drink could be made even in the poorest of villages, and often given to Fishers after a good day’s work."
	color = "#a02101"
	strength = 10
	taste_description = "tea"

	glass_icon_state = "icepick"
	glass_name = "glass of Fisher's Reward"
	glass_desc = "A fresh and pleasant drink. Traditionally, this simple drink could be made even in the poorest of villages, and often given to Fishers after a good day’s work."

/singleton/reagent/alcohol/butanol/queensgift
	name = "Queen's Gift"
	description = "A drink originating from the Szek’Hakh Queendom, generally enjoyed during parties and other joyous occasions for its fruity sweetness."
	color = "#cc0033"
	strength = 27
	taste_description = "fruity sweetness"

	glass_icon_state = "queensgift"
	glass_name = "glass of Queen's Gift"
	glass_desc = "A drink originating from the Szek’Hakh Queendom, generally enjoyed during parties and other joyous occasions for its fruity sweetness."

/singleton/reagent/alcohol/butanol/wastelandheat
	name = "Wasteland Heat"
	description = "A mix of spicy cactus juice to warm you up."
	color = "#d8d7ae"
	strength = 40
	adj_temp = 60
	targ_temp = 390
	taste_description = "burning heat"

	glass_icon_state = "moghesheat"
	glass_name = "glass of Wasteland Heat"
	glass_desc = "A mix of spicy cactus juice to warm you up. Maybe a little too warm for non-unathi, though."
	glass_center_of_mass = list("x"=17, "y"=8)

/singleton/reagent/alcohol/butanol/tasteofvictory
	name = "Taste of Victory"
	description = "The Unathi warrior’s traditional drink. Legends say that if a warrior was to drink it after a defeat, their spirit would be cursed to never win another battle."
	color = "#960707"
	strength = 30
	taste_description = "tart berries"

	glass_icon_state = "sangria"
	glass_name = "glass of Taste of Victory"
	glass_desc = "The Unathi warrior’s traditional drink. Legends say that if a warrior was to drink it after a defeat, their spirit would be cursed to never win another battle."

/singleton/reagent/alcohol/butanol/contactwine
	name = "Contact Wine"
	description = "A product of the Contact War, Contact Wine is a wastelander creation, mixed with whatever drink is at hand -often irradiated- and meant to hit as hard as possible to forget, for a time, the harshness of life in the Wastes."
	color = "#610704"
	strength = 50
	taste_description = "berries and regret"

	glass_icon_state = "contactwine"
	glass_name = "glass of Contact Wine"
	glass_desc = "A product of the Contact War, Contact Wine is a wastelander creation, mixed with whatever drink is at hand -often irradiated- and meant to hit as hard as possible to forget, for a time, the harshness of life in the Wastes."
	glass_center_of_mass = list("x"=17, "y"=4)

/singleton/reagent/alcohol/butanol/smokescalesblood
	name = "Smokescale's Blood"
	description = "A drink made by, and popular among Unathi pirates, legends say that this drink was created and enjoyed by none other than Variz Smokescales himself. \
	Supposedly, the original recipe used blood from those that would dare violate the Star Code."
	color = "#820000"
	strength = 15
	taste_description = "fizzy sweet iron"

	glass_icon_state = "demonsblood"
	glass_name = "glass of Smokescale's Blood"
	glass_desc = "A drink made by, and popular among Unathi pirates, legends say that this drink was created and enjoyed by none other than Variz Smokescales himself. \
	Supposedly, the original recipe used blood from those that would dare violate the Star Code."
	glass_center_of_mass = list("x"=16, "y"=2)

/singleton/reagent/alcohol/butanol/templetreasure
	name = "Sandpit"
	description = "A drink originally enjoyed by Akhanzi Order monks in their mountain temples. The recipe was found in the ruins of said temples after they were raised \
	by the Sk'akh Inquisition. Though drinking it in public in Sk’akhist circles is often highly frowned upon."
	color = "#A68310"
	strength = 15
	taste_description = "oranges"

	glass_icon_state = "screwdriverglass"
	glass_name = "glass of Temple Treasure"
	glass_desc = "A drink originally enjoyed by Akhanzi Order monks in their mountain temples. The recipe was found in the ruins of said temples after they were raised \
	by the Sk'akh Inquisition. Though drinking it in public in Sk’akhist circles is often highly frowned upon."
	glass_center_of_mass = list("x"=15, "y"=10)

/singleton/reagent/alcohol/butanol/cactuscola
	name = "Cactus Cola"
	description = "Traditionally, Bloodwine was a drink enjoyed by nobles and other well-to-do Sinta after a good hunt; while the meat of the game was processed, its blood was not wasted but used in drinks such as this one."
	color = "#3E1B00"
	strength = 15
	taste_description = "cola"
	carbonated = TRUE

	glass_icon_state = "whiskeycolaglass"
	glass_name = "glass of Cactus Cola"
	glass_desc = "Traditionally, Bloodwine was a drink enjoyed by nobles and other well-to-do Sinta after a good hunt; while the meat of the game was processed, its blood was not wasted but used in drinks such as this one."
	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/alcohol/butanol/bloodwine
	name = "Bloodwine"
	description = "Traditionally, Bloodwine was a drink enjoyed by nobles and other well-to-do Sinta after a good hunt; while the meat of the game was processed, its blood was not wasted but used in drinks such as this one."
	color = "#C73C00"
	strength = 21
	taste_description = "strong berries"

	glass_icon_state = "bloodwine"
	glass_name = "glass of Bloodwine"
	glass_desc = "Traditionally, Bloodwine was a drink enjoyed by nobles and other well-to-do Sinta after a good hunt; while the meat of the game was processed, its blood was not wasted but used in drinks such as this one."
	glass_center_of_mass = list("x"=15, "y"=7)

/singleton/reagent/alcohol/butanol/eszkazalsbite
	name = "Eszkazal's Bite"
	description = "Often regarded as disgusting if not outright toxic, stories say that the Eszkazal’s Bite was first meant as a punishment for Guwans. It is still enjoyed by some for its unique taste, and being strong-enough to knock out an Azkrazal."
	color = "#b0f442"
	strength = 50
	taste_description = "sour body sweat"

	glass_icon_state = "eszkaelsbite"
	glass_name = "glass of Eszkazal's Bite"
	glass_desc = "Often regarded as disgusting if not outright toxic, stories say that the Eszkazal’s Bite was first meant as a punishment for Guwans. It is still enjoyed by some for its unique taste, and being strong-enough to knock out an Azkrazal."

/singleton/reagent/alcohol/butanol/trizkizki_tea
	name = "Trizkizki Tea"
	description = "A popular drink from Ouerea that smells of crisp sea air."
	color = "#876185"
	strength = 5
	taste_description = "light, sweet wine, with a hint of sea breeze"

	glass_icon_state = "trizkizkitea"
	glass_name = "cup of Trizkizki tea"
	glass_desc = "A popular drink from Ouerea that smells of crisp sea air."


	var/last_taste_time = -100

/singleton/reagent/alcohol/butanol/pulque
	name = "Xuizi pulque"
	description = "A variation of Mictlanian pulque that is safe to consume for Unathi."
	color = "#80f580"
	strength = 5
	taste_description = "sweet yeast"

	glass_icon_state = "pulque_butanol"
	glass_name = "cup of xuizi pulque"
	glass_desc = "A variation of Mictlanian pulque that is safe to consume for Unathi."
