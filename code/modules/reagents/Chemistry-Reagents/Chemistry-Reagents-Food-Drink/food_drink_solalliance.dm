//
// Food related
//


//
// Drinks
//
/singleton/reagent/drink/tea/mars_tea
	name = "Martian Tea"
	description = "A foul-smelling brew that you probably don't want to try."
	color = "#101000"
	taste_description = "bitter tea, pungent black pepper and just a hint of shaky politics"

	glass_icon_state = "bigteacup"
	glass_name = "cup of martian tea"
	glass_desc = "A foul-smelling brew that you probably don't want to try."

/singleton/reagent/drink/coffee/mars
	name = "Martian Special"
	description = "Black coffee, heavily peppered."
	taste_description = "bitter coffee, pungent black pepper and just a hint of shaky politics"

	glass_icon_state = "hot_coffee"
	glass_name = "cup of Martian Special"
	glass_desc = "Just by the pungent, sharp smell, you figure you probably don't want to drink that..."

//
// Alcohol
//
/singleton/reagent/alcohol/wine/rose
	name = "Rose Wine"
	description = "A fruity, light, pink wine that looks and tastes like lighthearted fun."
	color = "#e77884"
	strength = 8
	taste_description = "citrus, cherry, and sweet wine"

	glass_icon_state = "roseglass"
	glass_name = "glass of rose"
	glass_desc = "A fruity, light, pink wine that looks and tastes like lighthearted fun."

/singleton/reagent/alcohol/jovian_storm
	name = "Jovian Storm"
	description = "Named after Jupiter's storm. It'll blow you away."
	color = "#AA856A"
	strength = 15
	taste_description = "stormy sweetness"

	value = 0.13

	glass_icon_state = "jovianstormglass"
	glass_name = "glass of Jovian Storm"
	glass_desc = "A classic Callistean drink named after Jupiter's storm. It'll blow you away."
	glass_center_of_mass = list("x"=16, "y"=5)

/singleton/reagent/alcohol/solarian_white
	name = "Solarian White"
	description = "Despite the name, this is not a security officer."
	color = "#C3D1D4"
	strength = 30
	taste_description = "creamy vodka and lime"

	value = 0.125

	glass_icon_state = "solarianwhiteglass"
	glass_name = "glass of Solarian White"
	glass_desc = "A classic Solarian cocktail. Despite the name, this is not a security officer."

	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/alcohol/solarian_marine
	name = "Solarian Marine"
	description = "Drink too many of these, and you'll wake up invading Tau Ceti."
	reagent_state = LIQUID
	color = "#33567A"
	strength = 35
	taste_description = "polished boots and nationalism"

	value = 0.2

	glass_icon_state = "solarianmarineglass"
	glass_name = "Solarian Marine"
	glass_desc = "Drink too many of these, and you'll wake up invading Tau Ceti."

	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/alcohol/internationale
	name = "Solarian White"
	description = "The subversive's choice."
	color = "#D9CCAA"
	strength = 28
	taste_description = "earthy, oily unity"

	value = 0.13

	glass_icon_state = "internationaleglass"
	glass_name = "glass of Internationale"
	glass_desc = "The nearest thing the Orion Spur has to left unity. The subversive's choice."

	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/alcohol/marsarita
	name = "Marsarita"
	description = "The margarita with a Martian twist. They call it something less embarrassing there."
	color = "#3eb7c9"
	strength = 30
	taste_description = "spicy, salty lime"

	glass_icon_state = "marsarita"
	glass_name = "glass of Marsarita"
	glass_desc = "The margarita with a Martian twist. They call it something less embarrassing there."

/singleton/reagent/alcohol/olympusmons
	name = "Olympus Mons"
	description = "Another, stronger version of the Black Russian. It's popular in some Martian arcologies."
	color = "#020407"
	strength = 30
	taste_description = "bittersweet independence"

	glass_icon_state = "olympusmons"
	glass_name = "glass of Olympus Mons"
	glass_desc = "Another, stronger version of the Black Russian. It's popular in some Martian arcologies."

/singleton/reagent/alcohol/europanail
	name = "Europa Nail"
	description = "Named for Jupiter's moon. It looks about as crusty."
	color = "#785327"
	strength = 30
	taste_description = "a coffee-flavored moon"

	glass_icon_state = "europanail"
	glass_name = "glass of Europa Nail"
	glass_desc = "Named for Jupiter's moon. It looks about as crusty."

/singleton/reagent/alcohol/pina_colada
	name = "Pina Colada"
	description = "Prepared just like in Silversun."
	strength = 30
	color = "#FFF1B2"
	taste_description = "pineapple, coconut, and a hint of the ocean"

	glass_icon_state = "pina_colada"
	glass_name = "glass of pina colada"
	glass_desc = "Prepared just like in Silversun."
