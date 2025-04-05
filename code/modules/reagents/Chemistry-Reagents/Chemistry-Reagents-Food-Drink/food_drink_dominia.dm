//
// Food related
//

//
// Wine
//
/singleton/reagent/alcohol/wine/dominian
	name = "Geneboosted Wine"
	description = "A popular vintage among the Dominian elite. Worth every Imperial Pound."
	strength = 10
	taste_description = "expensive red wine, dates, and bittersweet chocolate"

	glass_icon_state = "sacredwineglass"
	glass_name = "glass of geneboosted wine"
	glass_desc = "An imperiously classy drink. In Her name, so shall it be drunk!"

/singleton/reagent/alcohol/wine/algae
	name = "Algae Wine"
	description = "More of an absinthe than a wine. The favored drink of the Imperial military."
	taste_description = "licorice and spinach"

	glass_icon_state = "algaewineglass"
	glass_name = "glass of algae wine"
	glass_desc = "Smells like a hydroponic basin. Not very classy."

/singleton/reagent/alcohol/wine/valokki
	name = "Valokki Wine"
	description = "A smooth, rich wine distilled from the cloudberry fruit found within the taiga bordering the Lyod."
	taste_description = "smooth, rich wine"
	strength = 25

	glass_icon_state = "valokkiwineglass"
	glass_name = "glass of valokki wine"
	glass_desc = "A very classy, powerful drink."

//
// Alcohol
//
/singleton/reagent/alcohol/kvass
	name = "Kvass"
	description = "A sweet-and-sour grain drink, originating in Northeastern Europe."
	taste_description = "bittersweet yeast"
	strength = 15

	glass_icon_state = "kvassglass"
	glass_name = "glass of kvass"
	glass_desc = "A cloudy, slightly effervescent drink."

/singleton/reagent/alcohol/tarasun
	name = "Tarasun"
	description = "An incredibly potent alcoholic beverage distilled and fermented from tenelote milk, often enjoyed during tribal festivities among Lyodii."
	taste_description = "whey liquor"
	strength = 30

	glass_icon_state = "tarasunglass"
	glass_name = "glass of tarasun"
	glass_desc = "An incredibly potent alcoholic beverage, distilled and fermented from tenelote milk."

/singleton/reagent/alcohol/fisfirebomb
	name = "Fisanduhian Firebomb"
	description = "Mmm, tastes like spicy chocolate..."
	color = "#320C00"
	strength = 50
	taste_description = "anti-dominian sentiment"
	carbonated = TRUE

	value = 0.15

	glass_icon_state = "fisfirebombglass"
	glass_name = "glass of Fisanduhian Firebomb"
	glass_desc = "The somewhat spicier cousin to the Irish Car Bomb."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/coffee/fiscoffee
	name = "Fisanduhian Coffee"
	description = "Coffee, and spicy alcohol. Popular among people who dislike Dominians."
	color = "#A9501C"
	strength = 50
	caffeine = 0.3
	taste_description = "giving up on peaceful coexistence"

	value = 0.13

	glass_icon_state = "fiscoffeeglass"
	glass_name = "glass of Fisanduhian coffee"
	glass_desc = "It's like an Irish coffee, but spicy and angry about Dominia."
	glass_center_of_mass = list("x"=15, "y"=10)

/singleton/reagent/alcohol/fiscream
	name = "Fisanduhian Cream"
	description = "A sweet, slightly spicy alcoholic cream. Fisanduh is not yet lost."
	color = "#C8AC97"
	strength = 25
	taste_description = "creamy spiced alcohol"

	value = 0.14

	glass_icon_state = "irishcreamglass"
	glass_name = "glass of Fisanduhian cream"
	glass_desc = "A sweet, slightly spicy alcoholic cream. Fisanduh is not yet lost."
	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/alcohol/universalist
	name = "The Universalist"
	color = "#a05416"
	description = "Under the Fifth Edict, this should be drunk immediately!"
	strength = 25
	taste_description = "shutdown codes"

	glass_icon_state = "universalistglass"
	glass_name = "glass of the universalist"
	glass_desc = "Under the Fifth Edict, this should be drunk immediately!"

/singleton/reagent/alcohol/scramegg
	name = "SCRAMbled Egg"
	color = "#cfb024"
	description = "The closest thing you can get to breakfast in most of Neubach."
	strength = 15
	taste_description = "slimy raw egg and beer"

	glass_icon_state = "scrameggglass"
	glass_name = "glass of SCRAMbled egg"
	glass_desc = "A raw egg in a glass of kvass. The closest thing you can get to breakfast in most of Neubach."

/singleton/reagent/alcohol/governmentinexile
	name = "Government in Exile"
	color = "#2ab888"
	description = "A united front of flavors."
	strength = 15
	taste_description = "homesickness"

	glass_icon_state = "goeglass"
	glass_name = "glass of government in exile"
	glass_desc = "A united front of flavors."

/singleton/reagent/alcohol/instrument
	name = "Instrument of Surrender"
	color = "#1dbcd1"
	description = "A good, strong drink must be erected upon the ruins, if any of us are to have a future."
	strength = 20
	taste_description = "freedom from want"

	glass_icon_state = "insurrenderglass"
	glass_name = "glass of instrument of surrender"
	glass_desc = "A good, strong drink must be erected upon the ruins, if any of us are to have a future."

/singleton/reagent/alcohol/armsalchemy
	name = "Armsman's Alchemy"
	color = "#13707c"
	description = "An astoundingly bad idea."
	strength = 30
	overdose = 30
	caffeine = 0.4
	taste_description = "a burning cosmos"

	glass_icon_state = "armsalcglass"
	glass_name = "glass of armsman's alchemy"
	glass_desc = "A litany in itself."

/singleton/reagent/alcohol/armsalchemy/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien != IS_DIONA)
		if(prob(2))
			to_chat(M, SPAN_GOOD(pick("You feel like undeath.", "You feel your mind wander...", "You feel restless.")))

/singleton/reagent/alcohol/armsalchemy/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	if(!(alien in list(IS_DIONA, IS_VAURCA)))
		M.make_jittery(5)


/singleton/reagent/alcohol/inquisitrix
	name = "The Inquisitrix"
	color = "#2646b1"
	description = "Greatness is achieved through strength of beverage."
	strength = 35
	taste_description = "tomorrow's headache"

	glass_icon_state = "inquisitrixglass"
	glass_name = "glass of the inquisitrix"
	glass_desc = "Greatness is achieved through strength of beverage."

/singleton/reagent/alcohol/songwater
	name = "Songwater"
	description = "Consists of tarasun mixed with nutmeg and pepper to give it an aggressive burn, leading to the imbiber to gasp for air incoherently - hence 'songwater'."
	strength = 35
	taste_description = "frostbite in your throat"

	glass_icon_state = "songwaterglass"
	glass_name = "glass of songwater"
	glass_desc = "Consists of tarasun mixed with nutmeg and pepper to give it an aggressive burn, leading to the imbiber to gasp for air incoherently - hence 'songwater'."

	var/agony_dose = 5
	var/agony_amount = 1
	var/discomfort_message = SPAN_DANGER("Your insides feel uncomfortably hot!")
	var/slime_temp_adj = 3

/singleton/reagent/alcohol/songwater/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(0.1 * removed)

/singleton/reagent/alcohol/songwater/initial_effect(mob/living/carbon/M, alien, datum/reagents/holder)
	. = ..()
	to_chat(M, discomfort_message)

/singleton/reagent/alcohol/songwater/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien != IS_DIONA)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(!H.can_feel_pain())
				return
		if(M.chem_doses[type] < agony_dose)
			if(prob(5))
				to_chat(M, discomfort_message)
		else
			M.apply_effect(agony_amount, DAMAGE_PAIN, 0)
			if(prob(5))
				M.visible_message("<b>[M]</b> [pick("dry heaves!","coughs!","splutters!")]")
				to_chat(M, SPAN_DANGER("You feel like your insides are burning!"))
		if(istype(M, /mob/living/carbon/slime))
			M.bodytemperature += rand(0, 15) + slime_temp_adj
		holder.remove_reagent(/singleton/reagent/frostoil, 2)

/singleton/reagent/alcohol/threefold
	name = "Threefold"
	color = "#8a1153"
	description = "Praise its holy name! Praise its holy hangover!"
	strength = 35
	taste_description = "incense"

	glass_icon_state = "threefoldglass"
	glass_name = "glass of threefold"
	glass_desc = "And She stood before Katarina in the guise of her very own squire, mortally wounded on her own pike, and she gurgled, 'Remedy affliction with temperance.'"

/singleton/reagent/alcohol/godhead
	name = "Godhead"
	color = "#8f3bb1"
	description = "And She whispered to Jarmila in the guise of a brewer-woman, and She said 'Know temptation and spit on its embers.'"
	strength = 40
	taste_description = "morozi winter, with all its hardships"

	glass_icon_state = "godheadglass"
	glass_name = "glass of godhead"
	glass_desc = "And She whispered to Jarmila in the guise of a brewer-woman, and She said 'Know temptation and spit on its embers.'"

/singleton/reagent/alcohol/tribunal
	name = "Tribunal"
	color = "#47092b"
	description = "And so She said to Giovanna, 'Make merry, for there is always a bitter tomorrow!'."
	strength = 75
	taste_description = "alcoholic rapture"

	glass_icon_state = "tribunalglass"
	glass_name = "rapturous sacrament of the threefold goddess"
	glass_desc = "And Our Lady did come down from the mountain, and She was flanked in radiant and ever-burning cosmic fires. And She spoke with the Lady Caladius for what seemed an eternity, \
	and the Lady Caladius did finally emerge. And we happy few were so blessed as to hear her- the Prophetess Giovanna- say, 'Drink today not as warriors, but as immortals.'."
