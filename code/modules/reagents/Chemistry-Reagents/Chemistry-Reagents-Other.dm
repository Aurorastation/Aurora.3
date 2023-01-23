/* Paint and crayons */

/singleton/reagent/crayon_dust
	name = "Crayon Dust"
	description = "Intensely coloured powder obtained by grinding crayons."
	reagent_state = LIQUID
	color = "#888888"
	overdose = 5
	taste_description = "the back of class"
	fallback_specific_heat = 0.4

/singleton/reagent/crayon_dust/red
	name = "Red Crayon Dust"
	color = "#FE191A"
	taste_description = "chalky strawberry wax"

/singleton/reagent/crayon_dust/orange
	name = "Orange Crayon Dust"
	color = "#FFBE4F"
	taste_description = "chalky orange peels"

/singleton/reagent/crayon_dust/yellow
	name = "Yellow Crayon Dust"
	color = "#FDFE7D"
	taste_description = "chalky lemon rinds"

/singleton/reagent/crayon_dust/green
	name = "Green Crayon Dust"
	color = "#18A31A"
	taste_description = "chalky lime rinds"

/singleton/reagent/crayon_dust/blue
	name = "Blue Crayon Dust"
	color = "#247CFF"
	taste_description = "chalky blueberry skins"

/singleton/reagent/crayon_dust/purple
	name = "Purple Crayon Dust"
	color = "#CC0099"
	taste_description = "chalky grape skins"

/singleton/reagent/crayon_dust/grey //Mime
	name = "Grey Crayon Dust"
	color = "#808080"
	taste_description = "chalky crushed dreams"

/singleton/reagent/crayon_dust/brown //Rainbow
	name = "Brown Crayon Dust"
	color = "#846F35"
	taste_description = "raw, powerful creativity"

/singleton/reagent/paint
	name = "Paint"
	description = "This paint will stick to almost any object."
	reagent_state = LIQUID
	color = "#808080"
	overdose = REAGENTS_OVERDOSE * 0.5
	color_weight = 0
	taste_description = "chalk"
	fallback_specific_heat = 0.2
	var/unpaintable_types = list(/obj/item/reagent_containers, /obj/machinery/chem_master, /obj/machinery/chemical_dispenser, /obj/machinery/chem_heater)

/singleton/reagent/paint/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T) && !istype(T, /turf/space))
		T.color = holder.get_color()

/singleton/reagent/paint/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	if(istype(M))
		M.color = holder.get_color()

/singleton/reagent/paint/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	//special checks for special items
	var/setcolor = holder.get_color()
	if(is_type_in_list(O, unpaintable_types))
		return
	else if(istype(O, /obj/item/light))
		var/obj/item/light/L = O
		L.brightness_color = setcolor
		L.update()
	else if(istype(O, /obj/machinery/light))
		var/obj/machinery/light/L = O
		L.brightness_color = setcolor
		L.update()
	else if(istype(O))
		O.color = setcolor

/* Things that didn't fit anywhere else */

/singleton/reagent/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	description = "It's magic, I ain't gotta explain shit."
	reagent_state = LIQUID
	color = "#C8A5DC"
	affects_dead = 1 //This can even heal dead people.
	taste_description = "100% abuse"

	glass_icon_state = "golden_cup"
	glass_name = "golden cup"
	glass_desc = "It's magic, I ain't gotta explain shit."

	fallback_specific_heat = 10 //Magical.


/singleton/reagent/adminordrazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	affect_blood(M, alien, removed, holder)

/singleton/reagent/adminordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.setCloneLoss(0)
	M.setOxyLoss(0)
	M.total_radiation = 0
	M.heal_organ_damage(5,5)
	M.adjustToxLoss(-5)
	M.hallucination = 0
	M.setBrainLoss(0)
	M.disabilities = 0
	M.sdisabilities = 0
	M.eye_blurry = 0
	M.eye_blind = 0
	M.SetWeakened(0)
	M.SetStunned(0)
	M.SetParalysis(0)
	M.silent = 0
	M.dizziness = 0
	M.drowsiness = 0
	M.stuttering = 0
	M.confused = 0
	M.sleeping = 0
	M.jitteriness = 0
	M.intoxication = 0

/singleton/reagent/gold
	name = "Gold"
	description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	reagent_state = SOLID
	color = "#F7C430"
	taste_description = "expensive metal"
	fallback_specific_heat = 2.511

/singleton/reagent/silver
	name = "Silver"
	description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	reagent_state = SOLID
	color = "#D0D0D0"
	taste_description = "expensive yet reasonable metal"
	fallback_specific_heat = 0.241

/singleton/reagent/uranium
	name = "Uranium"
	description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
	reagent_state = SOLID
	color = "#B8B8C0"
	taste_description = "the inside of a reactor"
	fallback_specific_heat = 2.286

/singleton/reagent/uranium/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	affect_ingest(M, alien, removed, holder)

/singleton/reagent/uranium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.apply_effect(5 * removed, IRRADIATE, blocked = 0)

/singleton/reagent/uranium/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(amount >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return

/singleton/reagent/radioactive_waste
	name = "Radioactive Waste"
	description = "The byproduct of a nuclear reaction, highly radioactive."
	reagent_state = SOLID
	color = "#E0FF66"
	taste_description = "the inside of a melting reactor"
	fallback_specific_heat = 2.286

/singleton/reagent/radioactive_waste/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	affect_ingest(M, alien, removed, holder)

/singleton/reagent/radioactive_waste/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.apply_effect(25 * removed, IRRADIATE, blocked = 0)

/singleton/reagent/radioactive_waste/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(amount >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow/radioactive(T)
			return

/singleton/reagent/platinum
	name ="Platinum"
	description = "Platinum is a naturally occuring silvery metalic element."
	reagent_state = SOLID
	color = "#E0E0E0"
	taste_description = "salty metalic miner tears"
	fallback_specific_heat = 0.2971

/singleton/reagent/water/holywater
	name = "Holy Water"
	description = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."
	color = "#E0E8EF"

	glass_icon_state = "glass_clear"
	glass_name = "glass of holy water"
	glass_desc = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."

/singleton/reagent/water/holywater/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		if(M.mind)
			var/datum/vampire/vampire = M.mind.antag_datums[MODE_VAMPIRE]
			if(vampire)
				vampire.frenzy += removed * 5
			if(cult.is_antagonist(M.mind) && prob(10))
				cult.remove_antagonist(M.mind)
	if(alien && alien == IS_UNDEAD)
		M.adjust_fire_stacks(10)
		M.IgniteMob()

/singleton/reagent/water/holywater/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(amount >= 5)
		T.holy = 1
	return

/singleton/reagent/water/holywater/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien && alien == IS_UNDEAD)
		M.adjust_fire_stacks(5)
		M.IgniteMob()

/singleton/reagent/diethylamine
	name = "Diethylamine"
	description = "A secondary amine, mildly corrosive."
	reagent_state = LIQUID
	color = "#604030"
	taste_description = "iron"

/singleton/reagent/surfactant // Foam precursor
	name = "Azosurfactant"
	description = "A isocyanate liquid that forms a foam when mixed with water."
	reagent_state = LIQUID
	color = "#9E6B38"
	taste_description = "metal"

/singleton/reagent/foaming_agent // Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "Foaming Agent"
	description = "A agent that yields metallic foam when mixed with light metal and a strong acid."
	reagent_state = SOLID
	color = "#664B63"
	taste_description = "metal"

/singleton/reagent/thermite
	name = "Thermite"
	description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
	reagent_state = SOLID
	color = "#673910"
	touch_met = 50
	taste_description = "sweet tasting metal"

/singleton/reagent/thermite/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	. = ..()
	if(amount >= 5)
		if(istype(T, /turf/simulated/wall))
			var/turf/simulated/wall/W = T
			W.thermite = 1
			W.add_overlay(image('icons/effects/effects.dmi',icon_state = "#673910"))
			remove_self(5, holder)
	return

/singleton/reagent/thermite/touch_mob(var/mob/living/L, var/amount, var/datum/reagents/holder)
	. = ..()
	if(istype(L))
		L.adjust_fire_stacks(amount / 5)

/singleton/reagent/thermite/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustFireLoss(3 * removed)

/singleton/reagent/spacecleaner
	name = "Space Cleaner"
	description = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
	reagent_state = LIQUID
	color = "#A5F0EE"
	touch_met = REM * 10
	taste_description = "sourness"
	germ_adjust = 10

/singleton/reagent/spacecleaner/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	O.clean_blood()

/singleton/reagent/spacecleaner/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(amount >= 1)
		if(istype(T, /turf/simulated))
			var/turf/simulated/S = T
			S.dirt = 0
		T.clean_blood()

/singleton/reagent/spacecleaner/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(M.r_hand)
		M.r_hand.clean_blood()
	if(M.l_hand)
		M.l_hand.clean_blood()
	if(M.wear_mask)
		if(M.wear_mask.clean_blood())
			M.update_inv_wear_mask(0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head)
			if(H.head.clean_blood())
				H.update_inv_head(0)
		if(H.wear_suit)
			if(H.wear_suit.clean_blood())
				H.update_inv_wear_suit(0)
		else if(H.w_uniform)
			if(H.w_uniform.clean_blood())
				H.update_inv_w_uniform(0)
		if(H.shoes)
			if(H.shoes.clean_blood())
				H.update_inv_shoes(0)
		else
			H.clean_blood(1)
			return
	M.clean_blood()

	if(istype(M,/mob/living/carbon/slime))
		var/mob/living/carbon/slime/S = M
		S.adjustToxLoss( REAGENT_VOLUME(holder, type) * (removed/REM) * 0.5 )
		if(!S.client)
			if(S.target) // Like cats
				S.target = null
				++S.discipline
		if(M.chem_doses[type] == removed)
			S.visible_message(SPAN_WARNING("[S]'s flesh sizzles where the space cleaner touches it!"), SPAN_DANGER("Your flesh burns in the space cleaner!"))

/singleton/reagent/spacecleaner/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) > 15)
		M.add_chemical_effect(CE_EMETIC, 5)
		if(M.losebreath < 15)
			M.losebreath++
		if(prob(5))
			to_chat(M, SPAN_WARNING(pick("Your throat burns!", "All you can taste is blood!", "Your insides are on fire!", "Your feel a burning pain in your gut!")))
	else
		if(prob(5))
			to_chat(M, SPAN_WARNING(pick("Your throat stings a bit.", "You can taste something sour.")))

/singleton/reagent/spacecleaner/affect_breathe(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) > 15)
		M.add_chemical_effect(CE_EMETIC, 5)
		if(M.losebreath < 15)
			M.losebreath++
		if(prob(5))
			to_chat(M, SPAN_WARNING(pick("Your throat burns!", "All you can taste is blood!", "Your insides are on fire!", "Your feel a burning pain in your gut!")))
	else
		if(prob(5))
			to_chat(M, SPAN_NOTICE(pick("You get a strong whiff of space cleaner fumes - careful.")))

/singleton/reagent/spacecleaner/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) > 15)
		M.add_chemical_effect(CE_EMETIC, 5)
		if(prob(25))
			M.add_chemical_effect(CE_NEPHROTOXIC, 1)

/singleton/reagent/antifuel
	name = "Antifuel"
	description = "This compound is very specifically designed to react with and break up common combustible fuels."
	taste_description = "varnish"

/singleton/reagent/antifuel/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if (istype(O, /obj/effect/decal/cleanable/liquid_fuel))
		O.clean_blood()

/singleton/reagent/antifuel/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) > 15)
		M.add_chemical_effect(CE_EMETIC, 5)
		if(M.losebreath < 15)
			M.losebreath++
		if(prob(5))
			to_chat(M, SPAN_WARNING(pick("Your throat burns!", "All you can taste is metal!", "Your insides are on fire!", "Your feel a burning pain in your gut!")))
	else
		if(prob(5))
			to_chat(M, SPAN_WARNING(pick("Your throat stings a bit.", "You can taste something sour.")))

/singleton/reagent/antifuel/affect_breathe(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) > 15)
		M.add_chemical_effect(CE_EMETIC, 5)
		if(M.losebreath < 15)
			M.losebreath++
		if(prob(5))
			to_chat(M, SPAN_WARNING(pick("Your throat burns!", "All you can taste is metal!", "Your insides are on fire!", "Your feel a burning pain in your gut!")))
	else
		if(prob(5))
			to_chat(M, SPAN_NOTICE(pick("You get a strong whiff of industrial fumes - careful.")))

/singleton/reagent/antifuel/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) > 15)
		M.add_chemical_effect(CE_EMETIC, 5)
		if(prob(25))
			M.add_chemical_effect(CE_NEPHROTOXIC, 1)

/singleton/reagent/lube
	name = "Space Lube"
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them."
	reagent_state = LIQUID
	color = "#009CA8"
	taste_description = "cherry"

/singleton/reagent/lube/touch_turf(var/turf/simulated/T, var/amount, var/datum/reagents/holder)
	if(!istype(T))
		return
	if(amount >= 1)
		T.wet_floor(WET_TYPE_LUBE,amount)

/singleton/reagent/silicate
	name = "Silicate"
	description = "A compound that can be used to reinforce glass."
	reagent_state = LIQUID
	color = "#C7FFFF"
	taste_description = "plastic"
	ingest_mul = 0

/singleton/reagent/silicate/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O, /obj/structure/window))
		var/obj/structure/window/W = O
		W.apply_silicate(amount)
		remove_self(amount, holder)
	return

/singleton/reagent/silicate/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(2 * removed)
	M.add_chemical_effect(CE_ITCH, M.chem_doses[type])

/singleton/reagent/silicate/affect_breathe(var/mob/living/carbon/human/H, var/alien, var/removed, var/datum/reagents/holder)
	if(check_min_dose(H, 5))
		if(prob(50))
			H.visible_message("<b>[H]</b> splutters.", "You cough up a bunch of silicate.")
			remove_self(5, holder)
		else
			H.adjustOxyLoss(2)
			H.add_chemical_effect(CE_PNEUMOTOXIC, 0.2)

/singleton/reagent/glycerol
	name = "Glycerol"
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
	reagent_state = LIQUID
	color = "#808080"
	taste_description = "sweetness"

/singleton/reagent/nitroglycerin
	name = "Nitroglycerin"
	description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
	reagent_state = LIQUID
	color = "#808080"
	taste_description = "oil"

/singleton/reagent/nitroglycerin/proc/explode(var/datum/reagents/holder)
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (REAGENT_VOLUME(holder, type)/2, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat!=DEAD)
			e.amount *= 0.5
	e.start()
	holder.clear_reagents()

/singleton/reagent/nitroglycerin/on_heat_change(var/added_energy, var/datum/reagents/holder)
	. = ..()
	if(added_energy > (specific_heat * 5 * REAGENT_VOLUME(holder, type))) // heat shock
		explode(holder)

/singleton/reagent/nitroglycerin/apply_force(var/force, var/datum/reagents/holder)
	..()
	if(prob(force * 6))
		explode(holder)

/singleton/reagent/nitroglycerin/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	. = ..()
	explode(holder)

/singleton/reagent/nitroglycerin/touch_mob(var/mob/M, var/amount, var/datum/reagents/holder)
	. = ..()
	explode(holder)

/singleton/reagent/nitroglycerin/affect_blood(var/mob/living/carbon/human/H, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(H) || alien == IS_DIONA)
		return
	H.add_chemical_effect(CE_PULSE, 2)

/singleton/reagent/coolant
	name = "Coolant"
	description = "Industrial cooling substance."
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "sourness"
	taste_mult = 1.1

/singleton/reagent/ultraglue
	name = "Ultra Glue"
	description = "An extremely powerful bonding agent."
	color = "#FFFFCC"
	taste_description = "a special education class"
	fallback_specific_heat = 1.5

/singleton/reagent/woodpulp
	name = "Wood Pulp"
	description = "A mass of wood fibers."
	reagent_state = LIQUID
	color = "#B97A57"
	taste_description = "wood"
	fallback_specific_heat = 1.9

/singleton/reagent/luminol
	name = "Luminol"
	description = "A compound that interacts with blood on the molecular level."
	reagent_state = LIQUID
	color = "#F2F3F4"
	taste_description = "metal"

/singleton/reagent/luminol/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	O.reveal_blood()

/singleton/reagent/luminol/touch_mob(var/mob/living/L, var/amount, var/datum/reagents/holder)
	. = ..()
	L.reveal_blood()

/singleton/reagent/pyrosilicate
	name = "Pyrosilicate"
	description = "A bright orange powder consisting of strange self-heating properties that reacts when exposed to sodium chloride."
	reagent_state = SOLID
	color = "#FFFF00"
	taste_description = "chalk"
	default_temperature = 600 //Kelvin

/singleton/reagent/cryosurfactant
	name = "Cryosurfactant"
	description = "A bright cyan liquid consisting of strange self-cooling properties that reacts when exposed to water."
	reagent_state = LIQUID
	color = "#00FFFF"
	taste_description = "needles"
	default_temperature = 100 //Kelvin

/singleton/reagent/venenum
	name = "Venenum"
	description = "A thick tar like liquid that seems to move around on it's own every now and then. Limited data shows it only works when injected into the bloodstream."
	reagent_state = LIQUID
	color = "#000000"
	taste_description = "tar"
	metabolism = (1/30) //1u = 30 seconds, 1 transform.
	metabolism_min = (1/30)*0.5
	ingest_mul = 0
	breathe_mul = 0
	touch_mul = 0
	fallback_specific_heat = 28.464
	var/stored_value = 0
	var/datum/dna/stored_dna

/singleton/reagent/venenum/initial_effect(var/mob/living/carbon/M, var/alien)
	stored_value = metabolism
	stored_dna = M.dna.Clone()
	to_chat(M, SPAN_WARNING("Your skin starts crawling..."))

/singleton/reagent/venenum/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	stored_value += removed
	if(stored_value >= 1)
		M.visible_message(\
			"<span class='warning'>/The [M]'s body shifts and contorts!</span>",\
			"<span class='danger'>Your body shifts and contorts!</span>",\
			"<span class='notice'>You hear strange flesh-like noises.</span>"\
		)
		scramble(TRUE, M, 100)
		M.adjustHalLoss(25)
		M.UpdateAppearance()
		M.dna.real_name = random_name(M.gender, M.dna.species)
		M.real_name = M.dna.real_name
		stored_value -= 1

/singleton/reagent/venenum/final_effect(var/mob/living/carbon/M)
	if(stored_dna)
		M.dna = stored_dna.Clone()
		M.real_name = M.dna.real_name
		M.UpdateAppearance()

	to_chat(M, SPAN_WARNING("You seem back to your normal self."))

/singleton/reagent/fuel/zoragel
	name = "Inert Gel"
	description = "A particularly adhesive but otherwise inert and harmless gel."
	reagent_state = LIQUID
	color = "#D35908"
	touch_met = 50
	taste_description = "plhegm"

/singleton/reagent/fuel/napalm
	name = "Zo'rane Fire"
	description = "A highly flammable and cohesive gel once used commonly in the tunnels of Sedantis. Napalm sticks to kids."
	reagent_state = LIQUID
	color = "#D35908"
	touch_met = 50
	taste_description = "fiery death"

/singleton/reagent/fuel/napalm/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	new /obj/effect/decal/cleanable/liquid_fuel/napalm(T, amount/3)
	for(var/mob/living/L in T)
		L.adjust_fire_stacks(amount / 10)
	remove_self(amount, holder)
	return

/singleton/reagent/fuel/napalm/touch_mob(var/mob/living/L, var/amount, var/datum/reagents/holder)
	. = ..()
	if(istype(L))
		L.adjust_fire_stacks(amount / 10) // Splashing people with welding fuel to make them easy to ignite!
		new /obj/effect/decal/cleanable/liquid_fuel/napalm(get_turf(L), amount/3)
		L.adjustFireLoss(amount / 10)
		remove_self(amount, holder)

//Secret chems.
//Shhh don't tell no one.
/singleton/reagent/estus
	name = "Liquid Light"
	description = "This impossible substance slowly converts from a liquid into actual light."
	reagent_state = LIQUID
	color = "#ffff40"
	scannable = TRUE
	metabolism = REM * 0.25
	taste_description = "bottled fire"
	fallback_specific_heat = 2.75
	unaffected_species = IS_MACHINE

/singleton/reagent/estus/initial_effect(mob/living/carbon/M, alien, datum/reagents/holder)
	. = ..()
	M.set_light(REAGENT_VOLUME(holder, type), 4, LIGHT_COLOR_FIRE)

/singleton/reagent/estus/final_effect(mob/living/carbon/M, datum/reagents/holder)
	. = ..()
	M.set_light(FALSE)

/singleton/reagent/estus/affect_blood(var/mob/living/carbon/M, var/removed, var/datum/reagents/holder)
	if(isundead(M))
		M.heal_organ_damage(10 * removed, 15 * removed)

/singleton/reagent/estus/affect_ingest(var/mob/living/carbon/M, var/removed, var/datum/reagents/holder)
	if(isundead(M))
		M.heal_organ_damage(10 * removed, 15 * removed)

/singleton/reagent/estus/affect_touch(var/mob/living/carbon/M, var/removed, var/datum/reagents/holder)
	if(isundead(M))
		M.heal_organ_damage(10 * removed, 15 * removed)

/singleton/reagent/liquid_fire
	name = "Liquid Fire"
	description = "A dangerous flammable chemical, capable of causing fires when in contact with organic matter."
	reagent_state = LIQUID
	color = "#E25822"
	touch_met = 5
	taste_description = "metal"
	fallback_specific_heat = 20 //This holds a ton of heat.
	unaffected_species = IS_MACHINE

/singleton/reagent/liquid_fire/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	. = ..()
	if(istype(M))
		M.adjust_fire_stacks(10)
		M.IgniteMob()

/singleton/reagent/liquid_fire/touch_mob(var/mob/living/L, var/amount, var/datum/reagents/holder)
	. = ..()
	if(istype(L))
		L.adjust_fire_stacks(10)
		L.IgniteMob()

/singleton/reagent/black_matter
	name = "Unstable Black Matter"
	description = "A pitch black blend of cosmic origins, handle with care."
	color = "#000000"
	taste_description = "emptyness"
	fallback_specific_heat = 100 //Yeah...
	unaffected_species = IS_MACHINE

/singleton/reagent/black_matter/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	var/obj/effect/portal/P = new /obj/effect/portal(T)
	P.creator = null
	P.icon = 'icons/obj/objects.dmi'
	P.failchance = 0
	P.icon_state = "anom"
	P.name = "wormhole"
	var/list/pick_turfs = list()
	for(var/turf/simulated/floor/exit in turfs)
		if(isStationLevel(exit.z))
			pick_turfs += exit
	P.target = pick(pick_turfs)
	QDEL_IN(P, rand(150,300))
	remove_self(amount, holder)
	return

/singleton/reagent/bluespace_dust
	name = "Bluespace Dust"
	description = "A dust composed of microscopic bluespace crystals."
	color = "#1f8999"
	taste_description = "fizzling blue"
	fallback_specific_heat = 0.1
	unaffected_species = IS_MACHINE

/singleton/reagent/bluespace_dust/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(prob(25))
		M.make_jittery(5)
		to_chat(M, SPAN_WARNING("You feel unstable..."))

	if(prob(10))
		do_teleport(M, get_turf(M), 5, asoundin = 'sound/effects/phasein.ogg')

/singleton/reagent/bluespace_dust/touch_mob(var/mob/living/L, var/amount, var/datum/reagents/holder)
	. = ..()
	do_teleport(L, get_turf(L), amount, asoundin = 'sound/effects/phasein.ogg')

/singleton/reagent/philosopher_stone
	name = "Philosopher's Stone"
	description = "A mythical compound, rumored to be the catalyst of fantastic reactions."
	color = "#f4c430"
	taste_description = "heavenly knowledge"
	fallback_specific_heat = 1.25

/singleton/reagent/sglue
	name = "Sovereign Glue"
	description = "A very potent adhesive which can be applied to inanimate surfaces."
	reagent_state = LIQUID
	color = "#EDE8E2"
	taste_description = "horses"
	fallback_specific_heat = 1.25

/singleton/reagent/sglue/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if((istype(O, /obj/item) && !istype(O, /obj/item/reagent_containers)) && (amount >= 10*O.w_class))
		var/obj/item/I = O
		I.canremove = 0
		I.desc += " It appears to glisten with some gluey substance."
		remove_self(10*I.w_class, holder)
		I.visible_message(SPAN_NOTICE("[I] begins to glisten with some gluey substance."))

/singleton/reagent/usolve
	name = "Universal Solvent"
	description = "A very potent solvent which can be applied to inanimate surfaces."
	reagent_state = LIQUID
	color = "#EDE8E2"
	taste_description = "alcohol"
	fallback_specific_heat = 1.75

/singleton/reagent/usolve/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if((istype(O, /obj/item) && !istype(O, /obj/item/reagent_containers)) && (amount >= 10*O.w_class))
		var/obj/item/I = O
		I.canremove = initial(I.canremove)
		I.desc = initial(I.desc)
		I.visible_message(SPAN_NOTICE("A thin shell of glue cracks off of [I]."))
		remove_self(10*I.w_class, holder)

/singleton/reagent/shapesand
	name = "Shapesand"
	description = "A strangely animate clump of sand which can shift its color and consistency."
	reagent_state = SOLID
	color = "#c2b280"
	taste_description = "sand"
	fallback_specific_heat = 0.75

/singleton/reagent/shapesand/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if((istype(O, /obj/item) && !istype(O, /obj/item/reagent_containers)) && (amount >= 10*O.w_class))
		var/obj/item/shapesand/mimic = new /obj/item/shapesand(O.loc)
		mimic.name = O.name
		mimic.desc = O.desc
		mimic.icon = O.icon
		mimic.icon_state = O.icon_state
		mimic.item_state = O.item_state
		mimic.overlays = O.overlays
		remove_self(10*O.w_class, holder)
		mimic.visible_message(SPAN_NOTICE("The sand forms into an exact duplicate of [O]."))

/obj/item/shapesand
	name = "shapesand"
	desc = "A strangely animate clump of sand which can shift its color and consistency."
	icon = 'icons/obj/mining.dmi'
	w_class = ITEMSIZE_TINY
	icon_state = "ore_glass"

/obj/item/shapesand/attack() //can't be used to actually bludgeon things
	return 1

/obj/item/shapesand/afterattack(atom/A, mob/living/user)
	to_chat(user, SPAN_WARNING("As you attempt to use the [src], it crumbles into inert sand!"))
	new /obj/item/ore/glass(get_turf(src))
	qdel(src)
	return

/singleton/reagent/love_potion
	name = "Philter of Love"
	description = "A sickly sweet compound that induces chemical dependency on the first person the subject sees."
	reagent_state = LIQUID
	color = "#ff69b4"
	taste_description = "sickly sweet candy"
	fallback_specific_heat = 2 //Thicc

/singleton/reagent/love_potion/affect_blood(var/mob/living/carbon/human/H, var/alien, var/removed, var/datum/reagents/holder)

	if(!istype(H))
		return


/singleton/reagent/bottle_lightning
	name = "Bottled Lightning"
	description = "A mysterious compound capable of producing electrical discharges."
	reagent_state = LIQUID
	color = "#70838A"
	taste_description = "metal"
	fallback_specific_heat = 10
	unaffected_species = IS_MACHINE

/singleton/reagent/bottle_lightning/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(prob(25))
		tesla_zap(M, 6, 1500)

/singleton/reagent/stone_dust
	name = "Stone Dust"
	description = "Crystalline silica dust, harmful when inhaled."
	reagent_state = SOLID
	color = "#5a4d41"
	taste_description = "dust"
	specific_heat = 1

/singleton/reagent/stone_dust/affect_breathe(var/mob/living/carbon/human/H, var/alien, var/removed, var/datum/reagents/holder)
	. = ..()
	if(istype(H))
		if(prob(15))
			var/obj/item/organ/L = H.internal_organs_by_name[BP_LUNGS]
			if(istype(L) && !L.robotic)
				L.take_damage(0.5*removed)

/singleton/reagent/gunpowder
	name = "Gunpowder"
	description = "A primitive explosive chemical."
	reagent_state = SOLID
	color = "#464650"
	taste_description = "salt"
	fallback_specific_heat = 1
