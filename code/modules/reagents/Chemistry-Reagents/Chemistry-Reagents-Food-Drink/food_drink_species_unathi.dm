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
/singleton/reagent/alcohol/butanol/moghesmargarita
	name = "Moghes Margarita"
	description = "A classic human cocktail, now ruined with cactus juice instead of tequila."
	color = "#8CFF8C"
	strength = 30
	taste_description = "lime juice"

	glass_icon_state = "cactusmargarita"
	glass_name = "glass of Moghes Margarita"
	glass_desc = "A classic human cocktail, now ruined with cactus juice instead of tequila."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/butanol/cactuscreme
	name = "Cactus Creme"
	description = "A tasty mix of berries and cream with xuizi juice, for the discerning unathi."
	color = "#ff666"
	strength = 15
	taste_description = "creamy berries"

	glass_icon_state = "cactuscreme"
	glass_name = "glass of Cactus Creme"
	glass_desc = "A tasty mix of berries and cream with xuizi juice, for the discerning unathi."
	glass_center_of_mass = list("x"=17, "y"=8)

/singleton/reagent/alcohol/butanol/bahamalizard
	name = "Bahama Lizard"
	description = "A tropical cocktail containing cactus juice from Moghes, but no actual alcohol."
	color = "#FF7F3B"
	strength = 15
	taste_description = "sweet lemons"

	glass_icon_state = "bahamalizard"
	glass_name = "glass of Bahama Lizard"
	glass_desc = "A tropical cocktail containing cactus juice from Moghes, but no actual alcohol."
	glass_center_of_mass = list("x"=16, "y"=5)

/singleton/reagent/alcohol/butanol/lizardphlegm
	name = "Lizard Phlegm"
	description = "Looks gross, but smells fruity."
	color = "#8CFF8C"
	strength = 20
	taste_description = "creamy fruit"

	glass_icon_state = "lizardphlegm"
	glass_name = "glass of Lizard Phlegm"
	glass_desc = "Looks gross, but smells fruity."

/singleton/reagent/alcohol/butanol/cactustea
	name = "Cactus Tea"
	description = "Tea flavored with xuizi juice."
	color = "#a02101"
	strength = 10
	taste_description = "tea"

	glass_icon_state = "icepick"
	glass_name = "glass of Cactus Tea"
	glass_desc = "Tea flavored with xuizi juice."

/singleton/reagent/alcohol/butanol/moghespolitan
	name = "Moghespolitan"
	description = "Pomegranate syrup and cactus juice, with a splash of Sarezhi Wine. Delicious!"
	color = "#cc0033"
	strength = 27
	taste_description = "fruity sweetness"

	glass_icon_state = "moghespolitan"
	glass_name = "glass of Moghespolitan"
	glass_desc = "Pomegranate syrup and cactus juice, with a splash of Sarezhi Wine. Delicious!"

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

/singleton/reagent/alcohol/butanol/sandgria
	name = "Sandgria"
	description = "Sarezhi wine, blended with citrus and a splash of cactus juice."
	color = "#960707"
	strength = 30
	taste_description = "tart berries"

	glass_icon_state = "sangria"
	glass_name = "glass of Sandgria"
	glass_desc = "Sarezhi wine, blended with citrus and a splash of cactus juice."

/singleton/reagent/alcohol/butanol/contactwine
	name = "Contact Wine"
	description = "A perfectly good glass of Sarezhi wine, ruined by adding radioactive material. It reminds you of something..."
	color = "#610704"
	strength = 50
	taste_description = "berries and regret"

	glass_icon_state = "contactwine"
	glass_name = "glass of Contact Wine"
	glass_desc = "A perfectly good glass of Sarezhi wine, ruined by adding radioactive material. It reminds you of something..."
	glass_center_of_mass = list("x"=17, "y"=4)

/singleton/reagent/alcohol/butanol/hereticblood
	name = "Heretics Blood"
	description = "A fizzy cocktail made with cactus juice and heresy."
	color = "#820000"
	strength = 15
	taste_description = "heretically sweet iron"

	glass_icon_state = "demonsblood"
	glass_name = "glass of Heretics' Blood"
	glass_desc = "A fizzy cocktail made with cactus juice and heresy."
	glass_center_of_mass = list("x"=16, "y"=2)

/singleton/reagent/alcohol/butanol/sandpit
	name = "Sandpit"
	description = "An unusual mix of cactus and orange juice, mostly favored by unathi."
	color = "#A68310"
	strength = 15
	taste_description = "oranges"

	glass_icon_state = "screwdriverglass"
	glass_name = "glass of Sandpit"
	glass_desc = "An unusual mix of cactus and orange juice, mostly favored by unathi."
	glass_center_of_mass = list("x"=15, "y"=10)

/singleton/reagent/alcohol/butanol/cactuscola
	name = "Cactus Cola"
	description = "Cactus juice splashed with cola, on ice. Simple and delicious."
	color = "#3E1B00"
	strength = 15
	taste_description = "cola"
	carbonated = TRUE

	glass_icon_state = "whiskeycolaglass"
	glass_name = "glass of Cactus Cola"
	glass_desc = "Cactus juice splashed with cola, on ice. Simple and delicious."
	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/alcohol/butanol/bloodwine
	name = "Bloodwine"
	description = "A traditional unathi drink said to strengthen one before a battle."
	color = "#C73C00"
	strength = 21
	taste_description = "strong berries"

	glass_icon_state = "bloodwine"
	glass_name = "glass of Bloodwine"
	glass_desc = "A traditional unathi drink said to strengthen one before a battle."
	glass_center_of_mass = list("x"=15, "y"=7)

/singleton/reagent/alcohol/butanol/crocodile_booze
	name = "Crocodile Guwan"
	description = "A highly alcoholic butanol based beverage typically fermented using the venom of a zerl'ock and cheaply made Sarezhi Wine. A popular drink among Unathi troublemakers, conviently housed in a 2L plastic bottle."
	color = "#b0f442"
	strength = 50
	taste_description = "sour body sweat"

	glass_icon_state = "crocodile_glass"
	glass_name = "glass of Crocodile Guwan"
	glass_desc = "The smell says no, but the pretty colors say yes."

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
