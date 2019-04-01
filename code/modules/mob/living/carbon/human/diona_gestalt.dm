//This file defines variables and functions specific to diona worker gestalts, not used by nymphs


//Initialisation Section
//===========================
#define COLD_DAMAGE_LEVEL_1 0.5 //Copied from life.dm
#define COLD_DAMAGE_LEVEL_2 1.5
#define COLD_DAMAGE_LEVEL_3 3



#define NUM_NYMPHS	6
/mob/living/carbon/human
	var/datum/dionastats/DS


/mob/living/carbon/human/proc/setup_gestalt()
	composition_reagent = "nutriment"//Dionae are plants, so eating them doesn't give animal protein
	setup_dionastats()
	verbs += /mob/living/carbon/human/proc/check_light
	verbs += /mob/living/carbon/human/proc/diona_split_nymph
	verbs += /mob/living/proc/devour

	spawn(10)
	//This is delayed after a gestalt is spawned, to allow nymphs to be added to it before extras are created
	//These initial nymphs are the nymph which grows into a gestalt, and any others it had inside it
	//There are no initial nymphs for a newly spawned diona player

		if (mind && mind.name && name && mind.name != name)
			verbs += /mob/living/carbon/human/proc/gestalt_set_name
			var/datum/language/L = locate(/datum/language/diona) in languages
			var/newname
			if (L)
				newname = L.get_random_name()
			else
				newname = "Diona Gestalt ([rand(100,999)])"
			real_name = newname
			name = newname
			to_chat(src, "<span class=notice>We are named [real_name] for now, but we can choose a new name for our gestalt. (Check the Abilities Tab)</span>")
			//This allows a gestalt to rename itself -once- upon reforming

		verbs.Add(/mob/living/carbon/proc/absorb_nymph)

		topup_nymphs()

/mob/living/carbon/human/proc/topup_nymphs(var/max = 6)
	var/i = 0
	var/added = 0
	for(var/mob/living/carbon/alien/diona/D in src)
		i++
		D.stat = CONSCIOUS
		D.sync_languages(src)

	if (i < NUM_NYMPHS)
		for (i;i < NUM_NYMPHS;i++)
			add_nymph()
			added++
			if (added >= max)
				return added

	return added

/mob/living/carbon/human/proc/add_nymph()
	var/turf/T = get_turf(src)
	var/mob/living/carbon/alien/diona/M = new /mob/living/carbon/alien/diona(T)
	M.gestalt = src
	M.stat = CONSCIOUS
	M.update_verbs()
	spawn(1)
		M.forceMove(src)

//Environmental Functions
//================================

//This function is called when a gestalt is cold enough to take damage from icy temperatures
//It will also deal damage to contained nymphs, making them much less likely to survive and split if the diona dies of cold
//Damage is slightly randomised for each nymph, some will live longer than others, but in the long run all will die eventually
//Nymphs are slightly insulated from the cold within a gestalt. The temperature to hurt a nymph is 40k lower than what hurts the gestalt
/mob/living/carbon/human/proc/diona_contained_cold_damage()
	if (bodytemperature < (species.cold_level_1-40))
		var/damage
		if(bodytemperature > (species.cold_level_2-40))
			damage = COLD_DAMAGE_LEVEL_1
		else if(bodytemperature > (species.cold_level_3-40))
			damage = COLD_DAMAGE_LEVEL_2
		else
			damage = COLD_DAMAGE_LEVEL_3

		for (var/mob/living/carbon/alien/diona/D in src)
			D.adjustFireLoss(damage*(rand(30,150)/100))
			D.updatehealth()


//This is called when a gestalt is hit by an explosion. Nymphs will take damage too
//Damage to nymphs depends on the severity of the blast, and on explosive-resistant armour worn by the gestalt
//A severity 1 explosion without armour will usually kill all nymphs in the gestalt
//Damage is randomised for each nymph, often some will survive and others wont
//Nymphs have 100 health, so without armour there is a small possibility for each nymph to survive a severity 1 blast
/mob/living/carbon/human/proc/diona_contained_explosion_damage(var/severity)
	var/damage = 0
	var/damage_factor = 0.1 //Safety value
	if (severity)
		damage_factor = (1 / severity)

	var/armorval = 	getarmor(null, "bomb")
	if (armorval)
		damage_factor *= (1 - (armorval * 0.01))


	if (damage_factor > 0)
		for(var/mob/living/carbon/alien/diona/D in src)
			damage = (rand(95,200)*damage_factor)
			D.adjustBruteLoss(damage)
			D.updatehealth()

/mob/living/carbon/human/proc/check_light()
	set category = "Abilities"
	set name = "Check light level"

	if (!DS.light_organ || DS.light_organ.is_broken() || DS.light_organ.is_bruised())
		to_chat(usr, span("danger", "Our response node is damaged or missing, without it we can't tell light from darkness. We can only hope this area is bright enough to let us regenerate it!"))
		return
	var/light = get_lightlevel_diona(DS)
	if (light <= -0.75)
		to_chat(usr, span("danger", "It is pitch black here! This is extremely dangerous, we must find light, or death will soon follow!"))
	else if (light <= 0)
		to_chat(usr, span("danger", "This area is too dim to sustain us for long, we should move closer to the light, or we will shortly be in danger!"))
	else if (light > 0 && light < 1.5)
		to_chat(usr, span("warning", "The light here can sustain us, barely. It feels cold and distant."))
	else if (light <= 3)
		to_chat(usr, span("notice", "This light is comfortable and warm, Quite adequate for our needs."))
	else
		to_chat(usr, span("notice", "This warm radiance is bliss. Here we are safe and energised! Stay a while.."))



//1.5 is the maximum energy that can be lost per proc
//2.1 is the approximate delay between procs
/mob/living/carbon/human/proc/setup_dionastats()
	//Diona time variables, these differ slightly between a gestalt and a nymph. All values are times in seconds
	var/energy_duration = 120//How long this diona can exist in total darkness before its energy runs out
	var/dark_consciousness = 120//How long this diona can stay on its feet and keep moving in darkness after energy is gone.
	var/dark_survival = 180//How long this diona can survive in darkness after energy is gone, before it dies



	var/MLS = (1.5 / 2.1)//Maximum (energy) lost per second, in total darkness
	DS = new/datum/dionastats()
	DS.max_energy = energy_duration * MLS
	DS.max_health = maxHealth*2
	DS.stored_energy = DS.max_energy
	DS.pain_factor = (100 / dark_consciousness) / MLS
	DS.trauma_factor = (DS.max_health / dark_survival) / MLS
	DS.dionatype = 2//Gestalt

	for (var/organ in internal_organs)
		if (istype(organ, /obj/item/organ/diona/node))
			DS.light_organ = organ
		if (istype(organ, /obj/item/organ/diona/nutrients))
			DS.nutrient_organ = organ

//This proc can be called if some dionastats information needs to be refreshed or re-found
//Currently only used for refreshing organs
/mob/living/carbon/human/proc/update_dionastats()
	DS.light_organ = null
	DS.nutrient_organ = null

	for (var/organ in internal_organs)
		if (istype(organ, /obj/item/organ/diona/node))
			DS.light_organ = organ
		if (istype(organ, /obj/item/organ/diona/nutrients))
			DS.nutrient_organ = organ

//Splitting functions
//====================

/mob/living/carbon/human/proc/diona_split_nymph()
	set name = "Split"
	set desc = "Split your humanoid form into its constituent nymphs."
	set category = "Abilities"

	var/response = alert(src, "Are you sure you want to split? This will break your gestalt into many smaller nymphs, but you will only control one.","Confirm Split","Split","Not now")
	if(response != "Split") return

	diona_split_into_nymphs()


//This function allows a reformed gestalt to set its name, once only
/mob/living/carbon/human/proc/gestalt_set_name()
	set name = "Set Gestalt Name"
	set desc = "Choose a name for your new collective."
	set category = "Abilities"

	var/newname
	var/suggestion = ""
	var/textbox = ""
	var/datum/language/L = locate(/datum/language/diona) in languages
	if (L)
		suggestion = L.get_random_name()


	textbox	= "What shall we name our new collective? Type in a name, or leave blank to cancel. We recall that we were once part of a collective named [mind.name] but it is not necessary to return to that"

	newname = input(src,textbox,"Choosing a name.",suggestion)
	if (newname)
		real_name = newname
		name = newname
		mind.name = newname
		to_chat(src, "<span class=notice>Our collective shall now be known as [real_name] !</span>")
		verbs.Remove(/mob/living/carbon/human/proc/gestalt_set_name)


/mob/living/carbon/human/proc/diona_split_into_nymphs()
	var/turf/T = get_turf(src)
	var/mob/living/carbon/alien/diona/bestNymph = null
	var/bestHealth = 0


	var/nymphs_to_kill_off = 0



	//We iterate through all the nymphs and find which one is healthiest and not controlled
	//The gestalt's player will control that nymph

	//Start the splitting sound
	playsound(src.loc, 'sound/species/diona/gestalt_split.ogg', 100, 1)
	sleep(20)
	var/list/nymphos = list()

	var/list/organ_removal_priorities = list("l_arm","r_arm","l_leg","r_leg")
	for(var/organ_name in organ_removal_priorities)
		var/obj/item/organ/external/O = organs_by_name[organ_name]
		if(!O || O.is_stump())
			nymphs_to_kill_off += 1

	var/total_nymph = 0
	for(var/mob/living/carbon/alien/diona/D in src)
		if(nymphs_to_kill_off > 0)
			D.stat = DEAD
			nymphs_to_kill_off -= 1
			qdel(D)
			continue
		if ((!D.mind) && bestNymph == null)
			//As a safety, we choose the first unkeyed one to begin with, even if its dead.
			//We'll replace this choice when/if we find a better one
			bestNymph = D
		nymphos += D
		D.forceMove(T)
		D.split_languages(src)
		D.set_dir(pick(NORTH, SOUTH, EAST, WEST))
		D.gestalt = null
		if (D.stat != DEAD && D.health > (D.maxHealth*0.1))//If a nymph is alive and has enough health, it will emerge from the gestalt
			total_nymph += 1
			D.stat = CONSCIOUS
			D.stunned = 0
			D.update_verbs()
			if ((!D.key) && D.health > bestHealth)
				bestHealth = D.health
				bestNymph = D

		else //If a nymph is too heavily damaged, it cannot survive and will be born dead
			D.visible_message("[D] is too damaged to survive outside a gestalt, and expires with a pitiful chirrup", "You are too damaged to survive outside of your gestalt!", "You hear a pitiful chirrup!")
			D.stat = DEAD

	for(var/obj/item/W in src)
		drop_from_inventory(W)

	if (bestNymph)
		var/split_reag_volume = src.reagents.total_volume /  total_nymph // All nymps needs to get reagents of Gestal split between.
		for(var/mob/living/carbon/alien/diona/D in nymphos)
			src.reagents.trans_to_mob(D, split_reag_volume, CHEM_BLOOD)
			if(!D.mind)
				D.master_nymph = bestNymph
				D.birds_of_feather += nymphos
				D.pixel_y += rand(-10,10)
				D.pixel_x += rand(-10,10)
		bestNymph.set_dir(dir)
		transfer_languages(src, bestNymph)
		if(mind)
			mind.transfer_to(bestNymph)
			bestNymph.stunned = 0//Switching mind seems to temporarily stun mobs
			message_admins("\The [src] has split into nymphs; player now controls [key_name_admin(bestNymph)]")
			log_admin("\The [src] has split into nymphs; player now controls [key_name(bestNymph)]", ckey=key_name(bestNymph))

	//If bestNymph is still null at this point, it could only mean every nymph in the gestalt was a player
	//In this unfathomably rare case, the gestalt player simply dies as its mob is qdel'd.
	//We will generally prevent this from happening by ensuring any nymph-joining functions leave one free for the host

	visible_message("<span class='warning'>\The [src] quivers slightly, then splits apart with a wet slithering noise.</span>")
	qdel(src)

#undef COLD_DAMAGE_LEVEL_1
#undef COLD_DAMAGE_LEVEL_2
#undef COLD_DAMAGE_LEVEL_3
