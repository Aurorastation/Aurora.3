//
// Food related
//

//
// Alcohol
//
/singleton/reagent/drink/mushroom_kvass
	name = "Mushroom Kvass"
	description = "A fermented drink derived from mushroom bread. Contains too little alcohol to get anyone drunk."
	color = "#c7882a"
	taste_description = "tangy, earthy fruitiness"

	glass_icon_state = "mushroomkvass"
	glass_name = "glass of mushroom kvass"
	glass_desc = "Mushroom vodka's non-alcoholic cousin. For fellow workers of all ages."
	glass_center_of_mass = list("x"=16, "y"=9)

//
// Drinks
//
/singleton/reagent/drink/tea/hakhma_tea
	name = "Spiced Hakhma Tea"
	description = "A tea often brewed by Offworlders and Scarabs during important meals."
	color = "#8F6742"
	nutrition = 1 //hakhma milk has nutrition 4
	taste_description = "creamy, cinnamon-spiced alien milk"

	glass_icon_state = "hakhmatea"
	glass_name = "cup of spiced hakhma tea"
	glass_desc = "A tea often brewed by Offworlders and Scarabs during important meals."

/singleton/reagent/drink/tea/hakhma_tea/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder) //milk effects
	..()
	M.heal_organ_damage(0.1 * removed, 0)
	holder.remove_reagent(/singleton/reagent/capsaicin, 10 * removed)

/singleton/reagent/drink/bochbrew
	name = "Boch Brew"
	description = "A soft drink derived from the digestive sacs of the boch-kivir."
	color = "#b325b3"
	adj_sleepy = -1
	caffeine = 0.2
	taste_description = "fizzy fruit"
	carbonated = TRUE

	glass_icon_state = "berryjuice"
	glass_name = "glass of berry boch brew"
	glass_desc = "A soft drink derived from the digestive sacs of the boch-kivir."

/singleton/reagent/drink/bochbrew/buckthorn
	name = "Buckthorn Boch Brew"
	description = "A soft drink derived from the digestive sacs of the boch-kivir. This one is buckthorn flavored."
	color = "#cf7e14"
	taste_description = "fizzy sweet-tart candy"

	glass_icon_state = "orangejuice"
	glass_name = "glass of buckthorn boch brew"
	glass_desc = "A soft drink derived from the digestive sacs of the boch-kivir."

/singleton/reagent/drink/sugarcane
	name = "Mahendru's Best Blend"
	description = "All-natural sugarcane juice mixed with apple flavorings."
	color = "#dacfc6"
	taste_description = "flowery honey and apples"

/singleton/reagent/drink/galatea
	name = "Gala-Tea energy drink"
	description = "An extremely potent energy drink. The Ministry of Food Safety assures the public that drinking thirty standard units a week is perfectly safe."
	color = "#1bda9a"
	taste_description = "saccharine and formaldehyde"

/singleton/reagent/drink/galatea/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien != IS_DIONA)
		if(prob(2))
			to_chat(M, SPAN_GOOD(pick("You feel utterly focused.", "You have a sudden fit of creativity.", "You feel alert and focused.")))

/singleton/reagent/drink/galatea/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	if(!(alien in list(IS_DIONA)))
		M.make_jittery(5)
		if(prob(2))
			to_chat(M, SPAN_GOOD(pick("You find it difficult to tear yourself away from your current task.", "Your mind refuses to wander.")))

/singleton/reagent/drink/peach_soda
	name = "Xanu Rush!"
	description = "Made from the NEW Xanu Prime peaches."
	color = "#FFE5B4"
	taste_description = "dull peaches"
	carbonated = TRUE

	glass_icon_state = "glass_red"
	glass_name = "glass of Xanu Rush!"
	glass_desc = "Made from the NEW Xanu Prime peaches."

//
// Milk
//
/singleton/reagent/drink/milk/beetle
	name = "Hakhma Milk"
	description = "A milky substance extracted from the brood sac of the viviparous Hakhma, often consumed by Offworlders and Scarabs."
	nutrition = 4
	color = "#FFF8AD"
	taste_description = "alien milk"

	glass_name = "glass of hakhma milk"
	glass_desc = "A milky substance extracted from the brood sac of the viviparous Hakhma, often consumed by Offworlders and Scarabs."

//
// Alcohol
//
/singleton/reagent/alcohol/makgeolli
	name = "Makgeolli"
	description = "A mild Konyanger sparkling rice wine."
	color = "#c7b687"
	strength = 15
	taste_description = "creamy dry alcohol"

	glass_icon_state = "makgeolliglass"
	glass_name = "glass of makgeolli"
	glass_desc = "A clear alcohol similar to sparkling wine, brewed from rice."
	glass_center_of_mass = list("x"=16, "y"=12)

/singleton/reagent/alcohol/soju
	name = "Soju"
	description = "Also known as shochu or baijiu, this drink is made from fermented rice, much like sake, but at a generally higher proof making it more similar to a true spirit."
	color = "#f2f9fa"
	strength = 25
	taste_description = "stiff rice wine"

	glass_icon_state = "sojuglass"
	glass_name = "glass of soju"
	glass_desc = "A glass of strong rice wine."
	glass_center_of_mass = list("x"=16, "y"=12)

/singleton/reagent/alcohol/vodka/mushroom
	name = "Mushroom Vodka"
	description = "A strong drink distilled from mushrooms grown in caves. Tastes like dissatisfaction."
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 55
	taste_description = "strong earthy alcohol"
	glass_icon_state = "mushroomvodkaglass"
	glass_name = "glass of mushroom vodka"
	glass_desc = "The glass contain wodka made from mushrooms. Blyat."
	glass_center_of_mass = list("x"=16, "y"=12)

/singleton/reagent/alcohol/wine/assunzione
	name = "Assunzioni Wine"
	description = "A complex wine originating from the Dalyanese vineyards of Assunzione. The liturgical wine of choice for Luceian masses and holy gatherings."
	color = "#8b1b56"
	strength = 15
	taste_description = "red wine, truffles, hints of dried fruit, and herbs"

	glass_icon_state = "assunzionewineglass"
	glass_name = "glass of Assunzione wine"
	glass_desc = "A complex wine originating from the Dalyanese vineyards of Assunzione. The liturgical wine of choice for Luceian masses and holy gatherings."

/singleton/reagent/alcohol/twentytwo
	name = "Twenty-Two Seventy Five"
	description = "The king of brandy. Found in every bar on Xanu Prime, and every capital ship in the Coalition of Colonies."
	taste_description = "subtly sweet wine, with notes of oak and fruit"
	strength = 35

	glass_icon_state = "brandyglass"
	glass_name = "glass of 2275"
	glass_desc = "A classy liquor from the All-Xanu Republic. A longtime favorite of the Xanan everyman."

/singleton/reagent/alcohol/saintjacques
	name = "Saint-Jacques Black Label"
	description = "The gold standard of Xanan liquor, Saint-Jacques Black Label reigns supreme in the Coalition of Colonies. Expensive, but you'll understand why."
	taste_description = "rich, smooth autumn nights"
	strength = 45

	glass_icon_state = "cognacglass"
	glass_name = "glass of saint-jacques black label cognac"
	glass_desc = "A glass of premium Xanan cognac."

/singleton/reagent/alcohol/feni
	name = "Gadpathurian Feni"
	description = "The only liquor manufactured on Gadpathur, feni is a liquor originating in the Goa region of India and typically brewed from coconut sap, palm sap, or cashews. Typically issued as a morale supplement on celebratory occasions, the Planetary Defense Council has yet to disclose what this is precisely made from."
	taste_description = "fruity biodiesel"
	strength = 55

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of feni"
	glass_desc = "A glass of strong-smelling feni."

/singleton/reagent/alcohol/permanent_revolution
	name = "Permanent Revolution"
	description = "You have nothing to lose but your sobriety."
	color = "#A7AA60"
	strength = 65
	taste_description = "strong, earthy licorice"

	value = 0.13

	glass_icon_state = "permanentrevolutionglass"
	glass_name = "glass of Permanent Revolution"
	glass_desc = "A Himean cocktail, so named for its tendency to make the room spin.  You have nothing to lose but your sobriety."

	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/alcohol/staghunt
	name = "Stag Hunt"
	description = "The beloved cocktail of the Coalition's capital world, the All-Xanu Republic. Typically enjoyed outdoors, after a hunt or hike."
	color = "#ddb638"
	strength = 35
	taste_description = "brandy and lemonade"

	glass_icon_state = "staghunt"
	glass_name = "glass of Stag Hunt"
	glass_desc = "The national drink of the All-Xanu Republic. Brandy, tea, and lemonade, over ice. A perfect pairing with wild game, the setting sun, and a warm breeze."

/singleton/reagent/alcohol/ceasefire
	name = "Ceasefire"
	color = "#df5211"
	description = "Unfortunately, the flavors are unwilling to co-operate, and the kvass has fled to Xanu Prime."
	strength = 20
	taste_description = "bittersweet reunions"

	glass_icon_state = "ceasefireglass"
	glass_name = "glass of ceasefire"
	glass_desc = "Unfortunately, the flavors are unwilling to co-operate, and the kvass has fled to Xanu Prime."

/singleton/reagent/alcohol/lights_edge
	name = "Light's Edge"
	color = "#592ada"
	description = "A rich cocktail made with red wine, lemon juice, and gin. Unusual, rich, and with a touch of acidity -- just like its namesake."
	strength = 40
	taste_description = "rich wine, herbal liquor, and tartness"

	glass_icon_state = "lights_edge_glass"
	glass_name = "glass of Light's Edge"
	glass_desc = "A rich cocktail made with red wine, lemon juice, and gin. Unusual, rich, and with a touch of acidity -- just like its namesake."

/singleton/reagent/alcohol/weeping_stars
	name = "Weeping Stars"
	color = "#6f488f"
	description = "A sparkling, violet drink that almost takes the coloration of tears in its void."
	strength = 35
	taste_description = "sparkly violet cranberry juice"

	glass_icon_state = "weeping_stars_glass"
	glass_name = "glass of Weeping Stars"
	glass_desc = "A sparkling, violet drink that almost takes the coloration of tears in its void."

/singleton/reagent/alcohol/verdant
	name = "Verdant Green"
	color = "#248a21"
	description = "A refreshing, light drink that mixes soju with green tea and a splash of mint. Popular on Konyang."
	strength = 20
	taste_description = "refreshing minty tea with a kick"

	glass_icon_state = "verdant_glass"
	glass_name = "glass of Verdant Green"
	glass_desc = "A refreshing, light drink that mixes soju with green tea and a splash of mint. Popular on Konyang."

/singleton/reagent/alcohol/red_dwarf_sangria
	name = "Red Dwarf Sangria"
	description = "A rich, sweet wine punch made with Assunzione wine, applejack, and orange juice."
	strength = 30
	color = "#960e15"
	taste_description = "fruit cocktail, sweet red wine, and a hint of truffles"

	glass_icon_state = "redsangria"
	glass_name = "glass of red dwarf sangria"
	glass_desc = "A rich, sweet wine punch made with Assunzione wine, applejack, and orange juice."
