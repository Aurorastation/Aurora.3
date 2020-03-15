/* Paint and crayons */

/datum/reagent/crayon_dust
	name = "Crayon dust"
	id = "crayon_dust"
	description = "Intensely coloured powder obtained by grinding crayons."
	reagent_state = LIQUID
	color = "#888888"
	overdose = 5
	taste_description = "the back of class"
	fallback_specific_heat = 0.4

/datum/reagent/crayon_dust/red
	name = "Red crayon dust"
	id = "crayon_dust_red"
	color = "#FE191A"
	taste_description = "chalky strawberry wax"

/datum/reagent/crayon_dust/orange
	name = "Orange crayon dust"
	id = "crayon_dust_orange"
	color = "#FFBE4F"
	taste_description = "chalky orange peels"

/datum/reagent/crayon_dust/yellow
	name = "Yellow crayon dust"
	id = "crayon_dust_yellow"
	color = "#FDFE7D"
	taste_description = "chalky lemon rinds"

/datum/reagent/crayon_dust/green
	name = "Green crayon dust"
	id = "crayon_dust_green"
	color = "#18A31A"
	taste_description = "chalky lime rinds"

/datum/reagent/crayon_dust/blue
	name = "Blue crayon dust"
	id = "crayon_dust_blue"
	color = "#247CFF"
	taste_description = "chalky blueberry skins"

/datum/reagent/crayon_dust/purple
	name = "Purple crayon dust"
	id = "crayon_dust_purple"
	color = "#CC0099"
	taste_description = "chalky grape skins"

/datum/reagent/crayon_dust/grey //Mime
	name = "Grey crayon dust"
	id = "crayon_dust_grey"
	color = "#808080"
	taste_description = "chalky crushed dreams"

/datum/reagent/crayon_dust/brown //Rainbow
	name = "Brown crayon dust"
	id = "crayon_dust_brown"
	color = "#846F35"
	taste_description = "raw, powerful creativity"

/datum/reagent/paint
	name = "Paint"
	id = "paint"
	description = "This paint will stick to almost any object."
	reagent_state = LIQUID
	color = "#808080"
	overdose = REAGENTS_OVERDOSE * 0.5
	color_weight = 20
	taste_description = "chalk"
	fallback_specific_heat = 0.2

/datum/reagent/paint/touch_turf(var/turf/T)
	if(istype(T) && !istype(T, /turf/space))
		T.color = color

/datum/reagent/paint/touch_obj(var/obj/O)
	//special checks for special items
	if(istype(O, /obj/item/reagent_containers))
		return
	else if(istype(O, /obj/item/light))
		var/obj/item/light/L = O
		L.brightness_color = color
		L.update()
	else if(istype(O, /obj/machinery/light))
		var/obj/machinery/light/L = O
		L.brightness_color = color
		L.update()
	else if(istype(O, /obj/item/clothing/suit/storage/toggle/det_trench/technicolor) || istype(O, /obj/item/clothing/head/det/technicolor))
		return

	else if(istype(O))
		O.color = color

/datum/reagent/paint/touch_mob(var/mob/M)
	. = ..()
	if(istype(M) && !istype(M, /mob/abstract)) //painting ghosts: not allowed
		M.color = color //maybe someday change this to paint only clothes and exposed body parts for human mobs.

/datum/reagent/paint/get_data()
	return color

/datum/reagent/paint/initialize_data(var/newdata)
	color = newdata
	return

/datum/reagent/paint/mix_data(var/newdata, var/newamount)
	var/list/colors = list(0, 0, 0, 0)
	var/tot_w = 0

	var/hex1 = uppertext(color)
	var/hex2 = uppertext(newdata)
	if(length(hex1) == 7)
		hex1 += "FF"
	if(length(hex2) == 7)
		hex2 += "FF"
	if(length(hex1) != 9 || length(hex2) != 9)
		return
	colors[1] += hex2num(copytext(hex1, 2, 4)) * volume
	colors[2] += hex2num(copytext(hex1, 4, 6)) * volume
	colors[3] += hex2num(copytext(hex1, 6, 8)) * volume
	colors[4] += hex2num(copytext(hex1, 8, 10)) * volume
	tot_w += volume
	colors[1] += hex2num(copytext(hex2, 2, 4)) * newamount
	colors[2] += hex2num(copytext(hex2, 4, 6)) * newamount
	colors[3] += hex2num(copytext(hex2, 6, 8)) * newamount
	colors[4] += hex2num(copytext(hex2, 8, 10)) * newamount
	tot_w += newamount

	color = rgb(colors[1] / tot_w, colors[2] / tot_w, colors[3] / tot_w, colors[4] / tot_w)
	return

/* Things that didn't fit anywhere else */

/datum/reagent/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	id = "adminordrazine"
	description = "It's magic, I ain't gotta explain shit."
	reagent_state = LIQUID
	color = "#C8A5DC"
	affects_dead = 1 //This can even heal dead people.
	taste_description = "100% abuse"

	glass_icon_state = "golden_cup"
	glass_name = "golden cup"
	glass_desc = "It's magic, I ain't gotta explain shit."

	fallback_specific_heat = 10 //Magical.


/datum/reagent/adminordrazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed)

/datum/reagent/adminordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
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
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	M.sleeping = 0
	M.jitteriness = 0
	M.intoxication = 0
	for(var/datum/disease/D in M.viruses)
		D.spread = "Remissive"
		D.stage--
		if(D.stage < 1)
			D.cure()

/datum/reagent/gold
	name = "Gold"
	id = "gold"
	description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	reagent_state = SOLID
	color = "#F7C430"
	taste_description = "expensive metal"
	fallback_specific_heat = 2.511

/datum/reagent/silver
	name = "Silver"
	id = "silver"
	description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	reagent_state = SOLID
	color = "#D0D0D0"
	taste_description = "expensive yet reasonable metal"
	fallback_specific_heat = 0.241

/datum/reagent/uranium
	name = "Uranium"
	id = "uranium"
	description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
	reagent_state = SOLID
	color = "#B8B8C0"
	taste_description = "the inside of a reactor"
	fallback_specific_heat = 2.286

/datum/reagent/uranium/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_ingest(M, alien, removed)

/datum/reagent/uranium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.apply_effect(5 * removed, IRRADIATE, blocked = 0)

/datum/reagent/uranium/touch_turf(var/turf/T)
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return

/datum/reagent/platinum
	name ="Platinum"
	id = "platinum"
	description = "Platinum is a naturally occuring silvery metalic element."
	reagent_state = SOLID
	color = "#E0E0E0"
	taste_description = "salty metalic miner tears"
	fallback_specific_heat = 0.2971

/datum/reagent/water/holywater
	name = "Holy Water"
	id = "holywater"
	description = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."
	color = "#E0E8EF"

	glass_icon_state = "glass_clear"
	glass_name = "glass of holy water"
	glass_desc = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."

/datum/reagent/water/holywater/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(ishuman(M))
		if (M.mind && M.mind.vampire)
			var/datum/vampire/vampire = M.mind.vampire
			vampire.frenzy += removed * 5
		else if(M.mind && cult.is_antagonist(M.mind) && prob(10))
			cult.remove_antagonist(M.mind)
	if(alien && alien == IS_UNDEAD)
		M.adjust_fire_stacks(10)
		M.IgniteMob()

/datum/reagent/water/holywater/touch_turf(var/turf/T)
	if(volume >= 5)
		T.holy = 1
	return

/datum/reagent/water/holywater/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien && alien == IS_UNDEAD)
		M.adjust_fire_stacks(5)
		M.IgniteMob()

/datum/reagent/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	description = "A secondary amine, mildly corrosive."
	reagent_state = LIQUID
	color = "#604030"
	taste_description = "iron"

/datum/reagent/surfactant // Foam precursor
	name = "Azosurfactant"
	id = "surfactant"
	description = "A isocyanate liquid that forms a foam when mixed with water."
	reagent_state = LIQUID
	color = "#9E6B38"
	taste_description = "metal"

/datum/reagent/foaming_agent // Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "Foaming agent"
	id = "foaming_agent"
	description = "A agent that yields metallic foam when mixed with light metal and a strong acid."
	reagent_state = SOLID
	color = "#664B63"
	taste_description = "metal"

/datum/reagent/thermite
	name = "Thermite"
	id = "thermite"
	description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
	reagent_state = SOLID
	color = "#673910"
	touch_met = 50
	taste_description = "sweet tasting metal"

/datum/reagent/thermite/touch_turf(var/turf/T)
	. = ..()
	if(volume >= 5)
		if(istype(T, /turf/simulated/wall))
			var/turf/simulated/wall/W = T
			W.thermite = 1
			W.add_overlay(image('icons/effects/effects.dmi',icon_state = "#673910"))
			remove_self(5)
	return

/datum/reagent/thermite/touch_mob(var/mob/living/L, var/amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / 5)

/datum/reagent/thermite/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustFireLoss(3 * removed)

/datum/reagent/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	description = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
	reagent_state = LIQUID
	color = "#A5F0EE"
	touch_met = REM * 10
	taste_description = "sourness"
	germ_adjust = 10

/datum/reagent/space_cleaner/touch_obj(var/obj/O)
	O.clean_blood()

/datum/reagent/space_cleaner/touch_turf(var/turf/T)
	if(volume >= 1)
		if(istype(T, /turf/simulated))
			var/turf/simulated/S = T
			S.dirt = 0
		T.clean_blood()

/datum/reagent/space_cleaner/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
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
		S.adjustToxLoss( volume * (removed/REM) * 0.5 )
		if(!S.client)
			if(S.target) // Like cats
				S.target = null
				++S.discipline
		if(dose == removed)
			S.visible_message(span("warning", "[S]'s flesh sizzles where the space cleaner touches it!"), span("danger", "Your flesh burns in the space cleaner!"))

/datum/reagent/lube
	name = "Space Lube"
	id = "lube"
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them."
	reagent_state = LIQUID
	color = "#009CA8"
	taste_description = "cherry"

/datum/reagent/lube/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return
	if(volume >= 1)
		T.wet_floor(WET_TYPE_LUBE,volume)

/datum/reagent/silicate
	name = "Silicate"
	id = "silicate"
	description = "A compound that can be used to reinforce glass."
	reagent_state = LIQUID
	color = "#C7FFFF"
	taste_description = "plastic"

/datum/reagent/silicate/touch_obj(var/obj/O)
	if(istype(O, /obj/structure/window))
		var/obj/structure/window/W = O
		W.apply_silicate(volume)
		remove_self(volume)
	return

/datum/reagent/glycerol
	name = "Glycerol"
	id = "glycerol"
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
	reagent_state = LIQUID
	color = "#808080"
	taste_description = "sweetness"

/datum/reagent/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
	reagent_state = LIQUID
	color = "#808080"
	taste_description = "oil"
	var/temp_set = FALSE

/datum/reagent/nitroglycerin/proc/explode()
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (src.volume/2, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat!=DEAD)
			e.amount *= 0.5
	e.start()
	holder.clear_reagents()

/datum/reagent/nitroglycerin/add_thermal_energy(var/added_energy)
	. = ..()
	if(!temp_set) // so initial temperature-setting doesn't make stuff explode
		temp_set = TRUE
		return
	if(abs(added_energy) > (specific_heat * 5 / volume)) // can explode via cold or heat shock
		explode()

/datum/reagent/nitroglycerin/apply_force(var/force)
	..()
	if(prob(force * 6))
		explode()

/datum/reagent/nitroglycerin/touch_turf(var/turf/T)
	. = ..()
	explode()

/datum/reagent/nitroglycerin/touch_obj(var/obj/O)
	. = ..()
	explode()

/datum/reagent/nitroglycerin/touch_mob(var/mob/M)
	. = ..()
	explode()

/datum/reagent/nitroglycerin/affect_blood(var/mob/living/carbon/human/H, var/alien, var/removed)
	if(!istype(H) || alien == IS_DIONA)
		return
	H.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/coolant
	name = "Coolant"
	id = "coolant"
	description = "Industrial cooling substance."
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "sourness"
	taste_mult = 1.1

/datum/reagent/ultraglue
	name = "Ultra Glue"
	id = "glue"
	description = "An extremely powerful bonding agent."
	color = "#FFFFCC"
	taste_description = "a special education class"
	fallback_specific_heat = 1.5

/datum/reagent/woodpulp
	name = "Wood Pulp"
	id = "woodpulp"
	description = "A mass of wood fibers."
	reagent_state = LIQUID
	color = "#B97A57"
	taste_description = "wood"
	fallback_specific_heat = 1.9

/datum/reagent/luminol
	name = "Luminol"
	id = "luminol"
	description = "A compound that interacts with blood on the molecular level."
	reagent_state = LIQUID
	color = "#F2F3F4"
	taste_description = "metal"

/datum/reagent/luminol/touch_obj(var/obj/O)
	O.reveal_blood()

/datum/reagent/luminol/touch_mob(var/mob/living/L)
	. = ..()
	L.reveal_blood()

/datum/reagent/pyrosilicate
	name = "Pyrosilicate"
	id = "pyrosilicate"
	description = "A bright orange powder consisting of strange self-heating properties that reacts when exposed to sodium chloride."
	reagent_state = SOLID
	color = "#FFFF00"
	taste_description = "chalk"
	default_temperature = 600 //Kelvin

/datum/reagent/cryosurfactant
	name = "Cryosurfactant"
	id = "cryosurfactant"
	description = "A bright cyan liquid consisting of strange self-cooling properties that reacts when exposed to water."
	reagent_state = LIQUID
	color = "#00FFFF"
	taste_description = "needles"
	default_temperature = 100 //Kelvin

/datum/reagent/mutone
	name = "Mutone"
	id = "mutone"
	description = "A strange green powder with even stranger properties."
	reagent_state = SOLID
	color = "#11AA11"
	metabolism = (5/60) //5u every 60 seconds.
	taste_description = "sweet metal"
	var/stored_value = 0 //Internal value. Every 10 units equals a dosage.

/datum/reagent/mutone/initial_effect(var/mob/living/carbon/M, var/alien)
	stored_value = metabolism

/datum/reagent/mutone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	stored_value += removed
	if(stored_value >= 5)
		to_chat(M,span("notice","You feel strange..."))
		if(prob(25))
			randmutb(M)
		else
			randmutg(M)
		M.UpdateAppearance()
		stored_value -= 5

/datum/reagent/plexium
	name = "Plexium"
	id = "plexium"
	description = "A yellow, fowl smelling liquid that seems to affect the brain in strange ways."
	reagent_state = LIQUID
	color = "#888822"
	metabolism = 1 //1u every second
	taste_description = "brain freeze"
	var/stored_value = 0 //Internal value. Every 5 units equals a dosage.

/datum/reagent/plexium/initial_effect(var/mob/living/carbon/M, var/alien)
	stored_value = metabolism

/datum/reagent/plexium/affect_blood(var/mob/living/carbon/human/H, var/alien, var/removed)
	var/obj/item/organ/internal/brain/B = H.internal_organs_by_name[BP_BRAIN]
	if(B && H.species && H.species.has_organ[BP_BRAIN] && !isipc(H))
		stored_value += removed
		if(stored_value >= 5)
			if(prob(50) && !B.has_trauma_type(BRAIN_TRAUMA_MILD))
				B.gain_trauma_type(BRAIN_TRAUMA_MILD)
			else if(prob(50) && !B.has_trauma_type(BRAIN_TRAUMA_SEVERE))
				B.gain_trauma_type(BRAIN_TRAUMA_SEVERE)
			else if(prob(50) && !B.has_trauma_type(BRAIN_TRAUMA_SPECIAL))
				B.gain_trauma_type(BRAIN_TRAUMA_SPECIAL)
			stored_value -= 5

/datum/reagent/venenum
	name = "Venenum"
	id = "venenum"
	description = "A thick tar like liquid that seems to move around on it's own every now and then. Limited data shows it only works when injected into the bloodstream."
	reagent_state = LIQUID
	color = "#000000"
	taste_description = "tar"
	metabolism = (1/30) //1u = 30 seconds, 1 transform.
	metabolism_min = (1/30)*0.5
	ingest_mul = 0
	breathe_mul = 0
	touch_mul = 0
	var/stored_value = 0
	var/datum/dna/stored_dna

/datum/reagent/venenum/initial_effect(var/mob/living/carbon/M, var/alien)
	stored_value = metabolism
	stored_dna = M.dna.Clone()
	to_chat(M,span("warning","Your skin starts crawling..."))

/datum/reagent/venenum/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
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

/datum/reagent/venenum/final_effect(var/mob/living/carbon/M)
	if(stored_dna)
		M.dna = stored_dna.Clone()
		M.real_name = M.dna.real_name
		M.UpdateAppearance()

	to_chat(M,span("warning","You seem back to your normal self."))

/datum/reagent/fuel/zoragel
	name = "Inert Gel"
	id = "zoragel"
	description = "A particularly adhesive but otherwise inert and harmless gel."
	reagent_state = LIQUID
	color = "#D35908"
	touch_met = 50
	taste_description = "plhegm"

/datum/reagent/fuel/napalm
	name = "Zo'rane Fire"
	id = "greekfire"
	description = "A highly flammable and cohesive gel once used commonly in the tunnels of Sedantis. Napalm sticks to kids."
	reagent_state = LIQUID
	color = "#D35908"
	touch_met = 50
	taste_description = "fiery death"

/datum/reagent/fuel/napalm/touch_turf(var/turf/T)
	new /obj/effect/decal/cleanable/liquid_fuel/napalm(T, volume/3)
	for(var/mob/living/L in T)
		L.adjust_fire_stacks(volume / 10)
		L.add_modifier(/datum/modifier/napalm, MODIFIER_CUSTOM, _strength = 2)
	remove_self(volume)
	return

/datum/reagent/fuel/napalm/touch_mob(var/mob/living/L, var/amount)
	. = ..()
	if(istype(L))
		L.adjust_fire_stacks(amount / 10) // Splashing people with welding fuel to make them easy to ignite!
		new /obj/effect/decal/cleanable/liquid_fuel/napalm(get_turf(L), amount/3)
		L.adjustFireLoss(amount / 10)
		remove_self(volume)
		L.add_modifier(/datum/modifier/napalm, MODIFIER_CUSTOM, _strength = 2)

//Secret chems.
//Shhh don't tell no one.
/datum/reagent/estus
	name = "Liquid Light"
	id = "estus"
	description = "This impossible substance slowly converts from a liquid into actual light."
	reagent_state = LIQUID
	color = "#ffff40"
	scannable = 1
	metabolism = REM * 0.25
	taste_description = "bottled fire"
	var/datum/modifier/modifier
	fallback_specific_heat = 2.75
	unaffected_species = IS_MACHINE

/datum/reagent/estus/affect_blood(var/mob/living/carbon/M, var/removed)
	if (!modifier)
		modifier = M.add_modifier(/datum/modifier/luminous, MODIFIER_REAGENT, src, _strength = 4, override = MODIFIER_OVERRIDE_STRENGTHEN)
	if(isundead(M))
		M.heal_organ_damage(10 * removed, 15 * removed)

/datum/reagent/estus/affect_ingest(var/mob/living/carbon/M, var/removed)
	if (!modifier)
		modifier = M.add_modifier(/datum/modifier/luminous, MODIFIER_REAGENT, src, _strength = 4, override = MODIFIER_OVERRIDE_STRENGTHEN)
	if(isundead(M))
		M.heal_organ_damage(10 * removed, 15 * removed)

/datum/reagent/estus/affect_touch(var/mob/living/carbon/M, var/removed)
	if (!modifier)
		modifier = M.add_modifier(/datum/modifier/luminous, MODIFIER_REAGENT, src, _strength = 4, override = MODIFIER_OVERRIDE_STRENGTHEN)
	if(isundead(M))
		M.heal_organ_damage(10 * removed, 15 * removed)

/datum/reagent/liquid_fire
	name = "Liquid Fire"
	id = "liquid_fire"
	description = "A dangerous flammable chemical, capable of causing fires when in contact with organic matter."
	reagent_state = LIQUID
	color = "#E25822"
	touch_met = 5
	taste_description = "metal"
	fallback_specific_heat = 20 //This holds a ton of heat.
	unaffected_species = IS_MACHINE

/datum/reagent/liquid_fire/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	. = ..()
	if(istype(M))
		M.adjust_fire_stacks(10)
		M.IgniteMob()

/datum/reagent/liquid_fire/touch_mob(var/mob/living/L, var/amount)
	if(istype(L))
		L.adjust_fire_stacks(10)
		L.IgniteMob()

/datum/reagent/black_matter
	name = "Unstable Black Matter"
	id = "black_matter"
	description = "A pitch black blend of cosmic origins, handle with care."
	color = "#000000"
	taste_description = "emptyness"
	fallback_specific_heat = 100 //Yeah...
	unaffected_species = IS_MACHINE

/datum/reagent/black_matter/touch_turf(var/turf/T)
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
	remove_self(volume)
	return

/datum/reagent/bluespace_dust
	name = "Bluespace Dust"
	id = "bluespace_dust"
	description = "A dust composed of microscopic bluespace crystals."
	color = "#1f8999"
	taste_description = "fizzling blue"
	fallback_specific_heat = 0.1
	unaffected_species = IS_MACHINE

/datum/reagent/bluespace_dust/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(25))
		M.make_jittery(5)
		to_chat(M, "<span class='warning'>You feel unstable...</span>")

	if(prob(10))
		do_teleport(M, get_turf(M), 5, asoundin = 'sound/effects/phasein.ogg')

/datum/reagent/bluespace_dust/touch_mob(var/mob/living/L, var/amount)
	. = ..()
	do_teleport(L, get_turf(L), amount, asoundin = 'sound/effects/phasein.ogg')

/datum/reagent/philosopher_stone
	name = "Philosopher's Stone"
	id = "philosopher_stone"
	description = "A mythical compound, rumored to be the catalyst of fantastic reactions."
	color = "#f4c430"
	taste_description = "heavenly knowledge"
	fallback_specific_heat = 1.25

/datum/reagent/sglue
	name = "Sovereign Glue"
	id = "sglue"
	description = "A very potent adhesive which can be applied to inanimate surfaces."
	reagent_state = LIQUID
	color = "#EDE8E2"
	taste_description = "horses"
	fallback_specific_heat = 1.25

/datum/reagent/sglue/touch_obj(var/obj/O)
	if((istype(O, /obj/item) && !istype(O, /obj/item/reagent_containers)) && (volume > 10*O.w_class))
		var/obj/item/I = O
		I.canremove = 0
		I.desc += " It appears to glisten with some gluey substance."
		remove_self(10*I.w_class)
		I.visible_message("<span class='notice'>[I] begins to glisten with some gluey substance.</span>")

/datum/reagent/usolve
	name = "Universal Solvent"
	id = "usolve"
	description = "A very potent solvent which can be applied to inanimate surfaces."
	reagent_state = LIQUID
	color = "#EDE8E2"
	taste_description = "alcohol"
	fallback_specific_heat = 1.75

/datum/reagent/usolve/touch_obj(var/obj/O)
	if((istype(O, /obj/item) && !istype(O, /obj/item/reagent_containers)) && (volume > 10*O.w_class))
		var/obj/item/I = O
		I.canremove = initial(I.canremove)
		I.desc = initial(I.desc)
		I.visible_message("<span class='notice'>A thin shell of glue cracks off of [I].</span>")
		remove_self(10*I.w_class)

/datum/reagent/shapesand
	name = "Shapesand"
	id = "shapesand"
	description = "A strangely animate clump of sand which can shift its color and consistency."
	reagent_state = SOLID
	color = "#c2b280"
	taste_description = "sand"
	fallback_specific_heat = 0.75

/datum/reagent/shapesand/touch_obj(var/obj/O)
	if((istype(O, /obj/item) && !istype(O, /obj/item/reagent_containers)) && (volume > 10*O.w_class))
		var/obj/item/shapesand/mimic = new /obj/item/shapesand(O.loc)
		mimic.name = O.name
		mimic.desc = O.desc
		mimic.icon = O.icon
		mimic.icon_state = O.icon_state
		mimic.item_state = O.item_state
		mimic.overlays = O.overlays
		remove_self(10*O.w_class)
		mimic.visible_message("<span class='notice'>The sand forms into an exact duplicate of [O].</span>")

/obj/item/shapesand
	name = "shapesand"
	desc = "A strangely animate clump of sand which can shift its color and consistency."
	icon = 'icons/obj/mining.dmi'
	w_class = 1.0
	icon_state = "ore_glass"

/obj/item/shapesand/attack() //can't be used to actually bludgeon things
	return 1

/obj/item/shapesand/afterattack(atom/A, mob/living/user)
	to_chat(user, "<span class='warning'>As you attempt to use the [src], it crumbles into inert sand!</span>")
	new /obj/item/ore/glass(get_turf(src))
	qdel(src)
	return

/datum/reagent/love_potion
	name = "Philter of Love"
	id = "love"
	description = "A sickly sweet compound that induces chemical dependency on the first person the subject sees."
	reagent_state = LIQUID
	color = "#ff69b4"
	taste_description = "sickly sweet candy"
	fallback_specific_heat = 2 //Thicc

/datum/reagent/love_potion/affect_blood(var/mob/living/carbon/human/H, var/alien, var/removed)

	if(!istype(H))
		return

	var/obj/item/organ/internal/brain/B = H.internal_organs_by_name[BP_BRAIN]
	if(!H.has_trauma_type(/datum/brain_trauma/special/love))
		B.gain_trauma(/datum/brain_trauma/special/love,FALSE)

/datum/reagent/bottle_lightning
	name = "Bottled Lightning"
	id = "lightning"
	description = "A mysterious compound capable of producing electrical discharges."
	reagent_state = LIQUID
	color = "#70838A"
	taste_description = "metal"
	fallback_specific_heat = 10
	unaffected_species = IS_MACHINE

/datum/reagent/bottle_lightning/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(25))
		tesla_zap(M, 6, 1500)
