/* Paint and crayons */

/datum/reagent/crayon_dust
	name = "Crayon dust"
	id = "crayon_dust"
	description = "Intensely coloured powder obtained by grinding crayons."
	reagent_state = LIQUID
	color = "#888888"
	overdose = 5
	taste_description = "the back of class"

/datum/reagent/crayon_dust/red
	name = "Red crayon dust"
	id = "crayon_dust_red"
	color = "#FE191A"

/datum/reagent/crayon_dust/orange
	name = "Orange crayon dust"
	id = "crayon_dust_orange"
	color = "#FFBE4F"

/datum/reagent/crayon_dust/yellow
	name = "Yellow crayon dust"
	id = "crayon_dust_yellow"
	color = "#FDFE7D"

/datum/reagent/crayon_dust/green
	name = "Green crayon dust"
	id = "crayon_dust_green"
	color = "#18A31A"

/datum/reagent/crayon_dust/blue
	name = "Blue crayon dust"
	id = "crayon_dust_blue"
	color = "#247CFF"

/datum/reagent/crayon_dust/purple
	name = "Purple crayon dust"
	id = "crayon_dust_purple"
	color = "#CC0099"

/datum/reagent/crayon_dust/grey //Mime
	name = "Grey crayon dust"
	id = "crayon_dust_grey"
	color = "#808080"

/datum/reagent/crayon_dust/brown //Rainbow
	name = "Brown crayon dust"
	id = "crayon_dust_brown"
	color = "#846F35"

/datum/reagent/paint
	name = "Paint"
	id = "paint"
	description = "This paint will stick to almost any object."
	reagent_state = LIQUID
	color = "#808080"
	overdose = REAGENTS_OVERDOSE * 0.5
	color_weight = 20
	taste_description = "chalk"

/datum/reagent/paint/touch_turf(var/turf/T)
	if(istype(T) && !istype(T, /turf/space))
		T.color = color

/datum/reagent/paint/touch_obj(var/obj/O)
	//special checks for special items
	if(istype(O, /obj/item/weapon/reagent_containers))
		return
	else if(istype(O, /obj/item/weapon/light))
		var/obj/item/weapon/light/L = O
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
	description = "It's magic. We don't have to explain it."
	reagent_state = LIQUID
	color = "#C8A5DC"
	affects_dead = 1 //This can even heal dead people.
	taste_description = "100% abuse"

	glass_icon_state = "golden_cup"
	glass_name = "golden cup"
	glass_desc = "It's magic. We don't have to explain it."

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

/datum/reagent/silver
	name = "Silver"
	id = "silver"
	description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	reagent_state = SOLID
	color = "#D0D0D0"
	taste_description = "expensive yet reasonable metal"

/datum/reagent/uranium
	name ="Uranium"
	id = "uranium"
	description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
	reagent_state = SOLID
	color = "#B8B8C0"
	taste_description = "the inside of a reactor"

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

/datum/reagent/adrenaline
	name = "Adrenaline"
	id = "adrenaline"
	description = "Adrenaline is a hormone used as a drug to treat cardiac arrest and other cardiac dysrhythmias resulting in diminished or absent cardiac output."
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "bitterness"

/datum/reagent/adrenaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.SetParalysis(0)
	M.SetWeakened(0)
	M.adjustToxLoss(rand(3)*removed)

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
	touch_met = 50
	taste_description = "sourness"

/datum/reagent/space_cleaner/touch_obj(var/obj/O)
	O.clean_blood()

/datum/reagent/space_cleaner/touch_turf(var/turf/T)
	if(volume >= 1)
		if(istype(T, /turf/simulated))
			var/turf/simulated/S = T
			S.dirt = 0
		T.clean_blood()

		for(var/mob/living/carbon/slime/M in T)
			M.adjustToxLoss(rand(5, 10))

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

/datum/reagent/lube // TODO: spraying on borgs speeds them up
	name = "Space Lube"
	id = "lube"
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
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

/datum/reagent/woodpulp
	name = "Wood Pulp"
	id = "woodpulp"
	description = "A mass of wood fibers."
	reagent_state = LIQUID
	color = "#B97A57"
	taste_description = "wood"

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
	L.reveal_blood()

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

/datum/reagent/estus/affect_blood(var/mob/living/carbon/M, var/removed)
	if (!modifier)
		modifier = M.add_modifier(/datum/modifier/luminous, MODIFIER_REAGENT, src, _strength = 4, override = MODIFIER_OVERRIDE_STRENGTHEN)
	if(isskeleton(M))
		M.heal_organ_damage(10 * removed, 15 * removed)

/datum/reagent/estus/affect_ingest(var/mob/living/carbon/M, var/removed)
	if (!modifier)
		modifier = M.add_modifier(/datum/modifier/luminous, MODIFIER_REAGENT, src, _strength = 4, override = MODIFIER_OVERRIDE_STRENGTHEN)
	if(isskeleton(M))
		M.heal_organ_damage(10 * removed, 15 * removed)

/datum/reagent/estus/affect_touch(var/mob/living/carbon/M, var/removed)
	if (!modifier)
		modifier = M.add_modifier(/datum/modifier/luminous, MODIFIER_REAGENT, src, _strength = 4, override = MODIFIER_OVERRIDE_STRENGTHEN)
	if(isskeleton(M))
		M.heal_organ_damage(10 * removed, 15 * removed)

/datum/reagent/liquid_fire
	name = "Liquid Fire"
	id = "liquid_fire"
	description = "A dangerous flammable chemical, capable of causing fires when in contact with organic matter."
	reagent_state = LIQUID
	color = "#E25822"
	touch_met = 5
	taste_description = "metal"

/datum/reagent/liquid_fire/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
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

/datum/reagent/black_matter/touch_turf(var/turf/T)
	var/obj/effect/portal/P = new /obj/effect/portal(T)
	P.creator = null
	P.icon = 'icons/obj/objects.dmi'
	P.failchance = 0
	P.icon_state = "anom"
	P.name = "wormhole"
	var/list/pick_turfs = list()
	for(var/turf/simulated/floor/exit in turfs)
		if(exit.z in current_map.station_levels)
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

/datum/reagent/bluespace_dust/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(25))
		M.make_jittery(5)
		M << "<span class='warning'>You feel unstable...</span>"

	if(prob(10))
		do_teleport(M, get_turf(M), 5, asoundin = 'sound/effects/phasein.ogg')

/datum/reagent/bluespace_dust/touch_mob(var/mob/living/L, var/amount)
	do_teleport(L, get_turf(L), amount, asoundin = 'sound/effects/phasein.ogg')

/datum/reagent/philosopher_stone
	name = "Philosopher's Stone"
	id = "philosopher_stone"
	description = "A mythical compound, rumored to be the catalyst of fantastic reactions."
	color = "#f4c430"
	taste_description = "heavenly knowledge"

/datum/reagent/sglue
	name = "Sovereign Glue"
	id = "sglue"
	description = "A very potent adhesive which can be applied to inanimate surfaces."
	reagent_state = LIQUID
	color = "#EDE8E2"
	taste_description = "horses"

/datum/reagent/sglue/touch_obj(var/obj/O)
	if((istype(O, /obj/item) && !istype(O, /obj/item/weapon/reagent_containers)) && (volume > 10*O.w_class))
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

/datum/reagent/usolve/touch_obj(var/obj/O)
	if((istype(O, /obj/item) && !istype(O, /obj/item/weapon/reagent_containers)) && (volume > 10*O.w_class))
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

/datum/reagent/shapesand/touch_obj(var/obj/O)
	if((istype(O, /obj/item) && !istype(O, /obj/item/weapon/reagent_containers)) && (volume > 10*O.w_class))
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
	user << "<span class='warning'>As you attempt to use the [src], it crumbles into inert sand!</span>"
	new /obj/item/weapon/ore/glass(get_turf(src))
	qdel(src)
	return

/datum/reagent/love_potion
	name = "Philter of Love"
	id = "love"
	description = "A sickly sweet compound that induces chemical dependency on the first person the subject sees."
	reagent_state = LIQUID
	color = "#ff69b4"
	taste_description = "sickly sweet candy"

/datum/reagent/love_potion/affect_blood(var/mob/living/carbon/human/H, var/alien, var/removed)

	if(!istype(H))
		return

	var/obj/item/organ/brain/B = H.internal_organs_by_name["brain"]
	if(!H.has_trauma_type(/datum/brain_trauma/special/love))
		B.gain_trauma(/datum/brain_trauma/special/love,FALSE)