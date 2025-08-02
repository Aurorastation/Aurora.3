//
// Food related
//


//
// Drinks
//
/singleton/reagent/drink/tea/mendell_tea
	name = "Mendell Afternoon Tea"
	description = "A simple, minty tea."
	color = "#EFB300"
	taste_description = "minty tea with a hint of lemon"

	glass_icon_state = "mendelltea"
	glass_name = "cup of Mendell Afternoon Tea"
	glass_desc = "A simple, minty tea. A Biesel favorite."

/singleton/reagent/drink/tea/portsvilleminttea
	name = "Portsville Mint Tea"
	description = "A popular iced pick-me-up originating from a city in Eos, on Biesel."
	color = "#b6f442"
	taste_description = "cool minty tea"

	glass_icon_state = "portsvilleminttea"
	glass_name = "glass of Portsville Mint Tea"
	glass_desc = "A popular iced pick-me-up originating from a city in Eos, on Biesel."

/singleton/reagent/drink/tea/cocatea
	name = "Mate de Coca"
	description = "An herbal tea made of coca leaves, this tea originated in South America in the Andean countries, and is still consumed there and in Mictlan to this day."
	color = "#adff2f"
	taste_description = "mildly bitter, but sweet"

	glass_icon_state = "bigteacup"
	glass_name = "cup of mate de coca"
	glass_desc = "An herbal tea made of coca leaves, this tea originated in South America in the Andean countries, and is still consumed there and in Mictlan to this day."
	adj_dizzy = -1
	adj_drowsy = -3
	adj_sleepy = -3

	value = 0.12

//
// Alcohol
//
/singleton/reagent/alcohol/gibsonpunch
	name = "Gibson Punch"
	description = "An alcoholic fruit punch. It seems horribly sour at first, but a sweetly bitter aftertaste lingers in the mouth."
	color = "#5f712e"
	strength = 40
	taste_description = "sour and bitter fruit"

	value = 0.19

	glass_icon_state = "gibsonpunch"
	glass_name = "glass of Gibson Punch"
	glass_desc = "An alcoholic fruit punch."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/gibsonhooch
	name = "Gibson Hooch"
	description = "A disgusting concoction of cheap alcohol and soda - just what you need after a busy day at the factories."
	color = "#ffcc66"
	strength = 65
	taste_description = "cheap labor"
	carbonated = TRUE

	value = 0.21

	glass_icon_state = "gibsonhooch"
	glass_name = "glass of Gibson Hooch"
	glass_desc = "A factory worker's favorite... Because they can't afford much else."
	glass_center_of_mass = list("x"=16, "y"=10)

/singleton/reagent/alcohol/mendellian
	name = "Mendellian"
	description = "A blue citrusy spin on the Cosmopolitan, named after the most cosmopolitan city in the Spur."
	color = "#4f66e7"
	strength = 27
	taste_description = "citrusy urbanism"

	glass_icon_state = "mendellian"
	glass_name = "glass of Mendellian"
	glass_desc = "A blue citrusy spin on the Cosmopolitan, named after the most cosmopolitan city in the Spur."

/singleton/reagent/alcohol/new_horizons
	name = "New Horizons"
	color = "#1d3fbb"
	description = "In-house celebratory cocktail of the SCCV Horizon herself, served in an immensely intricate Horizon-shaped glass. Intended for ship-wide celebrations but can happily be poured any day of the week."
	strength = 30
	taste_description = "the celebration of new horizons"

	glass_icon_state = "horizon_glass"
	glass_name = "glass of New Horizons"
	glass_desc = "In-house celebratory cocktail of the SCCV Horizon herself, served in an immensely intricate Horizon-shaped glass. Intended for ship-wide celebrations but can happily be poured any day of the week."

/singleton/reagent/alcohol/pulque
	name = "Pulque"
	description = "A traditional Mictlanian drink made from fermented sap of maguey."
	strength = 15
	color = "#f1f1f1"
	taste_description = "yeast"

	glass_icon_state = "pulque"
	glass_name = "pulque"
	glass_desc = "A traditional Mictlanian drink made from fermented sap of maguey."

/singleton/reagent/alcohol/pulque/dyn
	name = "Dyn Pulque"
	description = "A traditional Mictlanian drink made from fermented sap of maguey. This one is dyn flavored."
	color = "a8ffff"
	taste_description = "yeasty menthol"

	glass_icon_state = "pulque_dyn"
	glass_name = "dyn pulque"

/singleton/reagent/alcohol/pulque/banana
	name = "Banana Pulque"
	description = "A traditional Mictlanian drink made from fermented sap of maguey. This one is banana flavored."
	color = "ffe777"
	taste_description = "yeasty banana"

	glass_icon_state = "pulque_banana"
	glass_name = "banana pulque"

/singleton/reagent/alcohol/pulque/berry
	name = "Berry Pulque"
	description = "A traditional Mictlanian drink made from fermented sap of maguey. This one is berry flavored."
	color = "cc0066"
	taste_description = "yeasty berries"

	glass_icon_state = "pulque_berry"
	glass_name = "berry pulque"

/singleton/reagent/alcohol/pulque/coffee
	name = "Coffee Pulque"
	description = "A traditional Mictlanian drink made from fermented sap of maguey. This one is coffee flavored."
	color = "722b13"
	taste_description = "yeasty coffee"

	glass_icon_state = "pulque_coffee"
	glass_name = "coffee pulque"

/singleton/reagent/drink/chocolate_soda
	name = "Chocolate Soda"
	description = "Chocolate flavored soda made with real cocoa, popular in Mictlan under the name Mojoka."
	color = "#3b1e10"
	taste_description = "fizzy chocolate"
	carbonated = TRUE

	glass_icon_state = "chocolate_soda"
	glass_name = "glass of chocolate soda"
	glass_desc = "Mostly popular in Mictlan under the local name 'mojoka', this drink, mostly popular in friendly gatherings and celebrations, is in essence, a chocolate flavored soda made with real cocoa."
