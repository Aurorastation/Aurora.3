//
// Food related
//
/singleton/reagent/condiment/syrup_ylphaberry
	name = "Ylpha Berry Syrup"
	description = "Thick ylpha berry syrup used to flavor drinks."
	taste_description = "ylpha berry"
	color = "#790042"
	glass_name = "ylpha berry syrup"
	glass_desc = "Thick ylpha berry syrup used to flavor drinks."
	taste_mult = 5
	condiment_desc = "There's a fun fact sticker on the back that says what Ylpha berries are and where they come from but the ink is all smudged and you can't read it."
	condiment_icon_state = "syrup_ylpha"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/drink/jyalra
	name = "Jyalra"
	description = "Dyn that has been peeled and mashed into a savoury puree."
	reagent_state = LIQUID
	color = "#321b85"
	nutrition = 5
	hydration = 5
	taste_description = "savoury fruit mush"

	glass_name = "glass of jyalra"
	glass_desc = "A puree made from dyn."

/singleton/reagent/drink/jyalracheese
	name = "Jyalra With Nycii"
	description = "Dyn that has been peeled and mashed into a savoury puree. Nycii has been added to the puree for extra flavour."
	reagent_state = LIQUID
	color = "#d9cf4c"
	nutrition = 5
	hydration = 5
	taste_description = "alien cheese mush"

	glass_name = "glass of jyalra with nycii"
	glass_desc = "A puree made from dyn."

/singleton/reagent/drink/jyalraapple
	name = "Jyalra With Apples"
	description = "Dyn that has been peeled and mashed into a savoury puree. Apples have been added to the puree, making it sweeter."
	reagent_state = LIQUID
	color = "#1b8736"
	nutrition = 5
	hydration = 5
	taste_description = "sweet apple mush"

	glass_name = "glass of jyalra with apples"
	glass_desc = "A puree made from dyn."

/singleton/reagent/drink/jyalracherry
	name = "Jyalra With Cherries"
	description = "Dyn that has been peeled and mashed into a savoury puree. Cherries have been added to the puree, making it sweeter."
	reagent_state = LIQUID
	color = "#87241b"
	nutrition = 5
	hydration = 5
	taste_description = "sweet cherry mush"

	glass_name = "glass of jyalra with cherries"
	glass_desc = "A puree made from dyn."

//
// Drinks
//
/singleton/reagent/drink/dynjuice/thewake //dyn properties
	name = "The Wake"
	description = "The tea-based alternative to a Sromshine."
	color = "#00E0E0"
	adj_dizzy = -3
	adj_drowsy = -3
	adj_sleepy = -3
	taste_description = "orange juice mixed with minty toothpaste"

	glass_icon_state = "thewake"
	glass_name = "cup of The Wake"
	glass_desc = "Most young skrell get a kick out of letting humans try this."

/singleton/reagent/drink/shake_ylpha
	name = "Ylpha berry milkshake"
	description = "A milkshake with a heaping of Ylpha Berry syrup mixed in."
	color = "#a03257"
	taste_description = "tangy sweetness"

	value = 0.13

	glass_icon_state = "shake_purplered"
	glass_name = "glass of ylpha berry milkshake"
	glass_desc = "That trademark magenta mixture of tangy and sweet - now in a tall, creamy glass of Milkshake!"
	glass_center_of_mass = list("x"=16, "y"=7)

/singleton/reagent/drink/dyn_boba
	name = "Dyn Boba Tea"
	description = "Dyn ice tea with boba pearls."
	nutrition = 3
	color = "#00ecec"
	taste_description = "fizzy mint tapioca tea"
	glass_icon_state = "boba_dyn"
	glass_name = "dyn boba"
	glass_desc = "A dyn boba drink, sometimes referred to as 'boba dyn', combining both skrell and human cultures of putting tasty, soft, chewy things in drinks."
	glass_center_of_mass = list("x"=15, "y"=10)

//
// Juices
//
/singleton/reagent/drink/ylphaberryjuice
	name = "Ylpha Berry Juice"
	description = "A delicious blend of several ylpha berries."
	color = "#d46423"
	taste_description = "ylpha berries"
	glass_icon_state = "berryjuice"
	glass_name = "glass of ylpha berry juice"
	glass_desc = "Ylpha berry juice. Or maybe it's jam. Who cares?"

/singleton/reagent/drink/dynjuice
	name = "Dyn Juice"
	description = "Juice from a dyn leaf. Good for you, but normally not consumed undiluted."
	taste_description = "astringent menthol"
	color = "#00e0e0"

	glass_icon_state = "dynjuice"
	glass_name = "glass of dyn juice"
	glass_desc = "Juice from a dyn leaf. Good for you, but normally not consumed undiluted."

	condiment_name = "dyn juice"
	condiment_desc = "Juice from a Skrell medicinal herb. It's supposed to be diluted."
	condiment_icon = 'icons/obj/item/reagent_containers/food/drinks/carton.dmi'
	condiment_icon_state = "dyncarton"

/singleton/reagent/drink/dynjuice/hot
	name = "Dyn Tea"
	taste_description = "peppermint water"
	description = "An old-fashioned, but traditional Skrell drink with documented medicinal properties."

	glass_icon_state = "dynhot"
	glass_name = "cup of dyn tea"
	glass_desc = "An old-fashioned, but traditional Skrell drink with documented medicinal properties."

/singleton/reagent/drink/dynjuice/cold
	name = "Dyn Ice Tea"
	taste_description = "fizzy mint tea"
	description = "A modern spin on an old formula, popular among Skrell youngsters. Good for you."

	glass_icon_state = "dyncold"
	glass_name = "glass of dyn ice tea"
	glass_desc = "A modern spin on an old formula, popular among Skrell youngsters. Good for you."

//
// Alcohol
//
/singleton/reagent/alcohol/djinntea
	name = "Djinn Tea"
	description = "A mildly alcoholic spin on a popular Skrell drink."
	color = "#84C0C0"
	strength = 20
	taste_description = "fizzy mint tea"

	value = 0.12

	glass_icon_state = "djinnteaglass"
	glass_name = "glass of Djinn Tea"
	glass_desc = "A mildly alcoholic spin on a popular Skrell drink. Less good for you than the original."

/singleton/reagent/alcohol/thirdincident
	name = "The Third Incident"
	color = "#1936a0"
	strength = 10
	description = "A controversial drink popular with the punk youth of the Nralakk Federation. Represents blood, eggs, and tears."
	taste_description = "X'Lu'oa sadness"

	glass_icon_state = "thirdincident"
	glass_name = "glass of the Third Incident"
	glass_desc = "A controversial drink popular with the punk youth of the Nralakk Federation. Represents blood, eggs, and tears."

/singleton/reagent/drink/upsidedowncup
	name = "Upside-Down Cup"
	color = "#B2110A"
	description = "An age-old part of Skrell culture. Even children know of the humor."
	taste_description = "esoteric humor"

	glass_icon_state = "upsidedowncup"
	glass_name = "glass of Upside-Down Cup"
	glass_desc = "An age-old part of Skrell culture. Even children know of the humor. It's not actually upside down."

/singleton/reagent/drink/smokinglizard
	name = "Cigarette Lizard"
	color = "#80C274"
	description = "The amusement of Cigarette Lizard, now in a cup!"
	taste_description = "minty sass"

	glass_icon_state = "cigarettelizard"
	glass_name = "glass of Cigarette Lizard"
	glass_desc = "The amusement of Cigarette Lizard, now in a cup!"

/singleton/reagent/drink/coffee/sromshine
	name = "Sromshine"
	color = "#A14702"
	description = "The best part of waking up."
	taste_description = "bitter citrus"

	glass_icon_state = "sromshine"
	glass_name = "cup of Sromshine"
	glass_desc = "The best part of waking up."

/singleton/reagent/alcohol/cbsc
	name = "Complex Bluespace Calculation"
	color = "#000000"
	strength = 25
	description = "A loud bang. No, really, that's the joke. Skrell get a kick out of it."
	taste_description = "fizzling spatiotemporal instability"

	glass_icon_state = "cbsc"
	glass_name = "glass of Complex Bluespace Calculation"
	glass_desc = "A loud bang. No, really, that's the joke. Skrell get a kick out of it."

/singleton/reagent/alcohol/cbsc/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.make_jittery(10)

/singleton/reagent/drink/algaesuprise
	name = "Pl'iuop Algae Surprise"
	color = "#FFFF80"
	description = "This bubbling drink gives off a faint moldy aroma."
	taste_description = "swamp fungus"

	glass_icon_state = "algae_surprise"
	glass_name = "glass of Pl'iuop Algae Surprise"
	glass_desc = "This bubbling drink gives off a faint moldy aroma."

/singleton/reagent/drink/xrim
	name = "Xrim Garden"
	color = "#F6668E"
	description = "A colorful drink that smells a lot like rotten fruit."
	taste_description = "sweet, fruity slime"

	glass_icon_state = "xrim"
	glass_name = "glass of Xrim Garden"
	glass_desc = "A colorful drink that smells a lot like rotten fruit."

/singleton/reagent/alcohol/rixulin_sundae
	name = "Rixulin Sundae"
	color = "#83E2C6"
	description = "A fizzing drink that looks like a really great time."
	taste_description = "spacetime and warbling music"

	strength = 15
	druggy = 30

	glass_icon_state = "rixulin_sundae"
	glass_name = "glass of Rixulin Sundae"
	glass_desc = "A fizzing drink that looks like a really great time."

/singleton/reagent/alcohol/small/skrellbeerdyn
	name = "Dyn Beer"
	description = "A low-alcohol content beverage made from fermented dyn leaves. Unlike the fruit, this drink is quite bitter on its own and is usually spiced to give it a more palatable flavour profile."
	reagent_state = LIQUID
	color = "#31b0b0"
	strength = 2
	nutriment_factor = 1
	taste_description = "spiced bitter beer"
	carbonated = TRUE

	glass_name = "glass of dyn beer"
	glass_desc = "A low-alcohol content beverage made from fermented dyn leaves. Unlike the fruit, this drink is quite bitter on its own and is usually spiced to give it a more palatable flavour profile."

/singleton/reagent/alcohol/bottle/skrellwineylpha
	name = "Ylpha Wine"
	description = "A low-alcohol content beverage made from fermented ylpha berries. It's considered very sweet."
	reagent_state = LIQUID
	color = "#964e24"
	strength = 3
	nutriment_factor = 1
	taste_description = "sweet red wine"

	glass_name = "glass of ylpha wine"
	glass_desc = "A low-alcohol content beverage made from fermented ylpha berries. It's considered very sweet."
