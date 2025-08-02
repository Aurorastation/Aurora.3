//
// Food Related
//
/singleton/reagent/nutriment/flour/nfrihi
	name = "blizzard ear flour"
	taste_description = "chalky starch"
	color = "#DFDEA1"
	condiment_name = "Adhomian flour sack"
	condiment_desc = "Flour ground from pure Adhomian blizzard ears!"
	condiment_icon_state = "flour_blizzard"

/singleton/reagent/condiment/syrup_dirtberry
	name = "Dirt Berry Syrup"
	description = "Thick dirt berry syrup used to flavor drinks."
	taste_description = "dirt berry"
	color = "#85572c"
	glass_name = "dirt berry syrup"
	glass_desc = "Thick dirt berry syrup used to flavor drinks."
	taste_mult = 5
	condiment_desc = "Concentrrrated flavorrr forrr theirrr desserrrts."
	condiment_icon_state = "syrup_dirtberry"
	condiment_center_of_mass = list("x"=16, "y"=8)

//
// Drinks
//
/singleton/reagent/drink/shake_dirtberry
	name = "Dirtberry Milkshake"
	description = "Milkshake with a healthy heaping of dirtberry syrup mixed in."
	color = "#92692c"
	taste_description = "smooth dirtberries"

	value = 0.13

	glass_icon_state = "shake_dirtberry"
	glass_name = "glass of dirtberry milkshake"
	glass_desc = "Don't let the name fool you, this dairy delight is smooth and sweet!"
	glass_center_of_mass = list("x"=16, "y"=7)


/singleton/reagent/drink/hrozamal_soda
	name = "Hro'zamal Soda"
	description = "A carbonated version of the herbal tea made with Hro'zamal Ras'Nifs powder."
	color = "#F0C56C"
	adj_sleepy = -1
	caffeine = 0.2
	taste_description = "carbonated fruit sweetness"
	carbonated = TRUE

	glass_icon_state = "hrozamal_soda_glass"
	glass_name = "glass of Hro'zamal Soda"
	glass_desc = "A carbonated version of the herbal tea made with Hro'zamal Ras'Nifs powder."

/singleton/reagent/drink/midynhr_water
	name = "Midynhr Water"
	description = "A soft drink made from honey and tree syrup."
	color = "#95D44C"
	taste_description = "creamy sweetness"

	glass_icon_state = "midynhrwater_glass"
	glass_name = "glass of midynhr water"
	glass_desc = "A soft drink made from honey and tree syrup."
	glass_center_of_mass = list("x"=15, "y"=9)

//
// Juices
//
/singleton/reagent/drink/dirtberryjuice
	name = "Dirt Berry Juice"
	description = "A delicious blend of several dirt berries."
	color = "#C4AE7A"
	taste_description = "dirt berries"
	glass_icon_state = "berryjuice"
	glass_name = "glass of dirt berry juice"
	glass_desc = "Dirt Berry juice. Or maybe it's jam. Who cares?"

/singleton/reagent/drink/earthenrootjuice
	name = "Earthen-Root Juice"
	description = "Juice extracted from earthen-root, a plant native to Adhomai."
	color = "#679fb6"
	taste_description = "sweetness"

	glass_icon_state = "bluelagoon"
	glass_name = "glass of earthen-root juice"
	glass_desc = "Juice extracted from earthen-root, a plant native to Adhomai."

//
// Milk
//
/singleton/reagent/drink/milk/adhomai
	name = "Fatshouters Milk"
	description = "An opaque white liquid produced by the mammary glands of native adhomian animal."
	taste_description = "fatty milk"

/singleton/reagent/drink/milk/adhomai/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(alien != IS_TAJARA && prob(5))
			H.delayed_vomit()

/singleton/reagent/drink/milk/adhomai/fermented
	name = "Fermented Fatshouters Milk"
	description = "A tajaran made fermented dairy product, traditionally consumed by nomadic population of Adhomai."
	taste_description = "sour milk"

	glass_name = "glass of fermented fatshouters milk"
	glass_desc = "A tajaran made fermented dairy product, traditionally consumed by nomadic population of Adhomai."

/singleton/reagent/drink/milk/adhomai/mutthir
	name = "Mutthir"
	description = "A beverage made with Fatshouters' yogurt mixed with Nm'shaan's sugar and sweet herbs."
	taste_description = "sweet fatty yogurt"

	glass_name = "glass of mutthir"
	glass_desc = "A beverage made with Fatshouters' yogurt mixed with Nm'shaan's sugar and sweet herbs."
	glass_icon_state = "mutthir_glass"

	condiment_name = "mutthir carton"
	condiment_desc = "A beverage made with Fatshouters' yogurt mixed with Nm'shaan's sugar and sweet herbs."
	condiment_icon = 'icons/obj/item/reagent_containers/food/drinks/carton.dmi'
	condiment_icon_state = "mutthir"

/singleton/reagent/drink/milk/schlorrgo
	name = "Schlorrgo Milk"
	description = "An opaque white liquid produced by the mammary glands of the Schlorrgo."
	taste_description = "bitter and fatty milk"

/singleton/reagent/drink/milk/schlorrgo/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien == IS_TAJARA && prob(5))
		var/mob/living/carbon/human/H = M
		if(H.can_feel_pain())
			H.custom_pain("You feel a stinging pain in your abdomen!")
			H.Stun(3)

//
// Alcohol
//
/singleton/reagent/alcohol/victorygin
	name = "Victory Gin"
	description = "An oily Adhomai-based gin."
	color = "#dfeef0"
	strength = 18
	taste_description = "oily gin"

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of gin"
	glass_desc = "It has an oily smell and doesn't taste like typical gin."
	glass_center_of_mass = list("x"=16, "y"=12)

/singleton/reagent/alcohol/messa_mead
	name = "Messa's Mead"
	description = "A sweet alcoholic adhomian drink. Produced with Messa's tears and earthen-root."
	color = "#ffb417"
	strength = 25
	taste_description = "honey"

	glass_icon_state = "messa_mead_glass"
	glass_name = "glass of Messa's Mead"
	glass_desc = "A sweet alcoholic adhomian drink. Produced with Messa's tears."

/singleton/reagent/alcohol/winter_offensive
	name = "Winter Offensive"
	description = "An alcoholic tajaran cocktail, named after the famous military campaign."
	color = "#e4f2f5"
	strength = 15
	taste_description = "oily gin"
	targ_temp = 270

	glass_icon_state = "winter_offensive"
	glass_name = "glass of Winter Offensive"
	glass_desc = "An alcoholic tajaran cocktail, named after the famous military campaign."

/singleton/reagent/alcohol/mountain_marauder
	name = "Mountain Marauder"
	description = "An adhomian beverage made from fermented fatshouters milk and victory gin."
	color = "#DFDFDF"
	strength = 15
	taste_description = "alcoholic sour milk"

	glass_icon_state = "mountain_marauder"
	glass_name = "glass of Mountain Marauder"
	glass_desc = "An adhomian beverage made from fermented fatshouters milk and victory gin."

/singleton/reagent/alcohol/mountain_marauder/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(alien != IS_TAJARA && prob(5))
			H.delayed_vomit()

/singleton/reagent/alcohol/khlibnyz
	name = "Khlibnyz"
	color = "#843113"
	description = "A fermented beverage produced from Adhomian bread."
	taste_description = "earthy and salty"

	strength = 5
	nutriment_factor = 1
	carbonated = TRUE

	glass_icon_state = "khlibnyz_glass"
	glass_name = "glass of khlibnyz"
	glass_desc = "A fermented beverage produced from Adhomian bread."

/singleton/reagent/alcohol/shyyrkirrtyr_wine
	name = "Shyyr Kirr'tyr Wine"
	color = "#D08457"
	description = "Tajaran spirit infused with some eel-like Adhomian creature."
	taste_description = "dry alcohol with a hint of meat"

	strength = 20
	nutriment_factor = 1

	glass_icon_state = "shyrrkirrtyrwine_glass"
	glass_name = "glass of shyyr kirr'tyr wine"
	glass_desc = "Tajaran spirit infused with some eel-like Adhomian creature."

/singleton/reagent/alcohol/sugartree_liquor
	name = "Sugar Tree Liquor"
	color = "#FE6B03"
	description = "A strong Adhomian nm'shaan liquor reserved for special occasions."
	taste_description = "sweet and silky alcohol"

	strength = 70

	glass_icon_state = "sugartreeliquor_glass"
	glass_name = "glass of sugar tree liquor"
	glass_desc = "A strong nm'shaan Adhomian liquor reserved for special occasions."

/singleton/reagent/alcohol/sugartree_liquor/darmadhirbrew
	name = "Darmadhir Brew"
	color = "#E4A769"
	description = "A rare and expensive brand of nm'shaan liquor."
	taste_description = "expensive sweet and silky alcohol"

	strength = 75

	glass_icon_state = "darmadhirbrew_glass"
	glass_name = "glass of Darmadhir Brew"

	value = 25

/singleton/reagent/alcohol/treebark_firewater
	name = "Tree-Bark Firewater"
	color = "#ACAA1D"
	description = "High-content alcohol distilled from Earthen-Root or Blizzard Ears."
	taste_description = "earthy and bitter alcohol"

	strength = 65

	glass_icon_state = "treebarkfirewater_glass"
	glass_name = "glass of tree-bark firewater"
	glass_desc = "High-content alcohol distilled from Earthen-Root or Blizzard Ears."

/singleton/reagent/alcohol/veterans_choice
	name = "Veteran's Choice"
	color = "#7C7231"
	description = "A cocktail consisting of Messa's Mead and gunpowder."
	taste_description = "honey and salty"

	strength = 25

	glass_icon_state = "veteranschoice_glass"
	glass_name = "glass of veteran's choice"
	glass_desc = "A cocktail consisting of Messa's Mead and gunpowder."
