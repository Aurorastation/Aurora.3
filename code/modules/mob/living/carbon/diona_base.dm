//This function is for code that is shared by diona nymphs and gestalt

#define TEMP_REGEN_STOP 223 //Regen rate scales down linearly from normal to this temperature, stops completely below this value
#define TEMP_REGEN_NORMAL 288 //normal body temperature
#define TEMP_INCREASE_REGEN_DOUBLE 700 //Health regen is increased by 100% (additive) for every increment of this value we are above normal
#define LIFETICK_INTERVAL_LESS	5

#define NYMPH_ABSORB_NUTRITION	650
#define NYMPH_ABSORB_DEAD_FACTOR	0.3

#define REGROW_FOOD_REQ		100
#define REGROW_ENERGY_REQ	40


#define LANGUAGE_POINTS_TO_LEARN	3 //The number of samples of a language required to learn it
var/list/diona_banned_languages = list(
	/datum/language/cult,
	/datum/language/cultcommon,
	/datum/language/corticalborer,
	/datum/language/binary,
	/datum/language/binary/drone)


/mob/living/carbon/proc/diona_handle_light(var/datum/dionastats/DS) //Carbon is the highest common denominator between gestalts and nymphs. They will share light code
	//if light_organ is non null, then we're working with a gestalt. otherwise nymph


	var/light_amount = DS.last_lightlevel //If we're not re-fetching the light level then we'll use a recent cached version

	if (life_tick % 2 == 0) //Only fetch the lightlevel every other proc to save performance
		if (DS.last_location != loc || life_tick % 4 == 0) //Fetch it even less often if we haven't moved since last check
			light_amount = get_lightlevel_diona(DS)
			DS.last_lightlevel = light_amount


	DS.stored_energy += light_amount

	if(DS.stored_energy > DS.max_energy)
		DS.stored_energy = DS.max_energy

	if(DS.stored_energy > 0) //if there's enough energy stored then diona heal
		diona_handle_regeneration(DS)
	else	//If light is <=0 then it hurts instead

		//var/severity = DS.stored_energy - (DS.stored_energy*2)
		var/severity = light_amount*-1 //Get a positive value which is the severity of the damage
		diona_darkness_damage(severity, DS)
	diona_handle_lightmessages(DS)

	DS.last_location = loc

/mob/living/carbon/proc/diona_handle_radiation(var/datum/dionastats/DS)
	//Converts radiation to stored energy if its needed, and gives messages related to radiation
	//Rads can be used to heal in place of light energy, that is handled in the regular regeneration proc

	var/radiation = total_radiation

	if (radiation && DS.stored_energy < (DS.max_energy * 0.8)) //Radiation can provide energy in place of light
		radiation -= 2
		DS.stored_energy += 2

	radiation -= 0.5 //Radiation is gradually wasted if its not used for something


//This proc handles when diona take damage from being in darkness
/mob/living/carbon/proc/diona_darkness_damage(var/severity, var/datum/dionastats/DS)
	adjustBruteLoss(severity*DS.trauma_factor)
	adjustHalLoss(severity*DS.pain_factor, 1)
	DS.stored_energy = 0 //We reset the energy back to zero after calculating the damage. dont want it to go negative

	//If the diona in question is a gestalt, then all the nymphs inside it will suffer damage too
	if (DS.dionatype == DIONA_WORKER)
		for(var/mob/living/carbon/alien/diona/D in src)
			D.adjustBruteLoss(severity*DS.trauma_factor*0.5)


#define diona_max_pressure 100 //kpa, Highest pressure that has an effect
#define diona_nutrition_factor 0.5 //nutrients we gain per proc at max pressure
/mob/living/carbon/proc/diona_handle_air(var/datum/dionastats/DS, var/pressure)
	//Diona don't need to breathe, and can survive happily in a vacuum
	//But diona gestalts gain nutrition by extracting matter from gases in the air. If a gestalt spends a long time in space or on the asteroid, it may need to actually eat food
	//For simplicity, we'll assume any gas is fine, so they'll just absorb nutrition based on pressure
	if (!pressure)
		return 0

	if (DS.nutrient_organ)
		if (DS.nutrient_organ.is_broken())
			return 0

	var/plus= (min(pressure,diona_max_pressure)  / diona_max_pressure)* diona_nutrition_factor
	if (DS.nutrient_organ)
		if(DS.nutrient_organ.is_bruised())
			plus *= 0.5
	plus = min(plus, max_nutrition - nutrition)
	nutrition += plus
	return plus*7 //The return value is the number of moles to remove from the local environment

/mob/living/carbon/proc/diona_handle_temperature(var/datum/dionastats/DS)
	if (bodytemperature < TEMP_REGEN_STOP)
		DS.healing_factor = 0
	else if (bodytemperature <= TEMP_REGEN_NORMAL)
		DS.healing_factor = (bodytemperature - TEMP_REGEN_STOP) / (TEMP_REGEN_NORMAL - TEMP_REGEN_STOP)
	else
		DS.healing_factor = 1 + (bodytemperature - TEMP_REGEN_NORMAL) / TEMP_INCREASE_REGEN_DOUBLE



//This is a loooong function.
//Broken up into a few segments:
//Things that run every process: Healing trauma, burns and halloss. TODO: Reducing stun/weaken durations
//Things that run less often: Healing toxins, genetic damage, and (TODO) damage to internal organs
//Things that run even less often: Regrowing removed/destroyed limbs and internal organs.

//As long as a gestalt survives, and has either energy or radiation, it can regrow any part of itself,
//and will eventually become whole again without medical intervention, although medical can help.
//Most medicines don't work on diona, but physical treatment for external wounds helps a little,
//and some alternative things that are toxic to other life, such as radium and mutagen, will benefit diona
/mob/living/carbon/proc/diona_handle_regeneration(var/datum/dionastats/DS)
	if ((DS.stored_energy < 1 && !total_radiation)) //we need energy or radiation to heal
		return FALSE

	var/radiation = max(total_radiation, 0)


	var/value //A little variable we'll reuse to optimise
	var/CL //Cached loss, to save on repeatedly recalculating it
	var/HF = DS.healing_factor //I don't know if fetching a variable from an object repeatedly is slow, but this seems safe

	//Diona only get halloss from running out of energy. If they have any, and yet we get this far,
	//it means that they've just reached some light or radiation after almost dying.
	//Their body prioritises spending resources here first to keep them on their feet
	if (getHalLoss() > 0)
		CL = getHalLoss()
		if (CL > 0)
			if (radiation > 0)
				value = min(CL, radiation, 2*HF)
				adjustHalLoss(value*-3,1) //Halloss heals more quickly
				radiation -= value
				CL = getHalLoss()

			value = min(CL, DS.stored_energy, 1*HF)
			adjustHalLoss(value*-3,1)
			DS.stored_energy -= value

	//Next up, damage healing. Diona are only vulnerable to four of the six damage types
	//Oxyloss doesn't apply because they don't breathe, and are thus immune to aquiring it in any way
	//Brain damage is irrelevant because they have no brain.
	if (health < 100)
		CL = getBruteLoss()

		if (CL > 0)
			if (radiation > 0)
				value = min(CL, radiation, 2*HF)
				adjustBruteLoss(value*-1)
				radiation -= value
				CL = getBruteLoss() //After adjusting it, recalculate for the lighthealing

			value = min(CL, DS.stored_energy, 1*HF)
			adjustBruteLoss(value*-1)
			DS.stored_energy -= value

		CL = getFireLoss()
		if (CL > 0)
			if (radiation > 0)
				value = min(CL, radiation, 2*HF)
				adjustFireLoss(value*-1)
				radiation -= value
				CL = getFireLoss()

			value = min(CL, DS.stored_energy, 1*HF)
			adjustFireLoss(value*-1)
			DS.stored_energy -= value

		CL = stunned
		if (CL > 0)
			if (radiation > 0)
				value = min(CL, radiation, 2*HF)
				stunned -= value
				radiation -= value
				CL = stunned

			value = min(CL, DS.stored_energy, 1*HF)
			stunned -= value
			DS.stored_energy -= value


		CL = weakened
		if (CL > 0)
			if (radiation > 0)
				value = min(CL, radiation, 2*HF)
				weakened -= value
				radiation -= value
				CL = weakened

			value = min(CL, DS.stored_energy, 1*HF)
			weakened -= value
			DS.stored_energy -= value

		//Genetic damage and toxins are relatively rare. We'll process them less often to reduce on computations
		if (life_tick % LIFETICK_INTERVAL_LESS == 0)
			CL = getToxLoss()
			if (CL > 0)
				if (radiation > 0)
					value = min(CL, radiation, 2*HF*LIFETICK_INTERVAL_LESS)
					adjustToxLoss(value*-1)
					radiation -= value
					CL = getToxLoss()

				value = min(CL, DS.stored_energy, 1*HF*LIFETICK_INTERVAL_LESS)

				adjustToxLoss(value*-1)
				DS.stored_energy -= value

			CL = getCloneLoss()
			if (CL > 0)
				if (radiation > 0)
					value = min(CL, radiation, 2*HF*LIFETICK_INTERVAL_LESS)
					adjustCloneLoss(value/-2.5) //Genetic damage, should diona ever suffer it, heals much more slowly.
					radiation -= value //Most likely the only time they'll cloneloss is escaping from being partially devoured
					CL = getCloneLoss()

				value = min(CL, DS.stored_energy, 1*HF*LIFETICK_INTERVAL_LESS)
				adjustCloneLoss(value/-5)
				DS.stored_energy -= value

	if (src.is_diona() != DIONA_WORKER)
		updatehealth()
		return FALSE

	// A little inter-proc communication.
	// We need the continued radiation count for the sake of actually working.
	return max(radiation, 0)

// Continuation of the Diona regen proc, but for human specific actions.
/mob/living/carbon/human/diona_handle_regeneration(var/datum/dionastats/DS)
	. = ..()

	// We cancel with regening organ, as it's meant to stop all other regenerative
	// processes. Just pray to shit the timers don't implode.
	if (!. || DS.regening_organ)
		return FALSE

	var/radiation = .

	//Next up, healing any damage to internal organs.
	//Diona really only have one critical organ, the light receptor node in the head.
	//If badly damaged, the light receptor reduces the effectiveness of incoming light
	//Nevertheless, we should still heal them all
	if (life_tick % LIFETICK_INTERVAL_LESS == 0)
		if (bad_internal_organs.len)
			for (var/obj/item/organ/O in bad_internal_organs)
				var/CL = O.damage
				var/value
				if (radiation > 0)
					value = min(CL, radiation, 2 * DS.healing_factor * LIFETICK_INTERVAL_LESS)
					O.damage += value/-1.5
					radiation -= value
					CL = getCloneLoss()

				value = min(CL, DS.stored_energy, 1 * DS.healing_factor * LIFETICK_INTERVAL_LESS)
				O.damage += value/-3
				DS.stored_energy -= value


			//We only regenerate nymphs if the gestalt has plenty of energy to spare.
			//Survival of the collective is prioritised over individual members
				//And healing nymphs can suck up a lot of energy, which the gestalt may need
			if (DS.stored_energy > (0.75 * DS.max_energy))
				for (var/mob/living/carbon/alien/diona/D in bad_internal_organs)
					if (!D.stat != DEAD)
						D.diona_handle_regeneration(DS)
						//IF a nymph inside the gestalt is damaged, we trigger its own regeneration function
						//but we pass in the gestalt's Dionastats, so its energy/rads will be used to heal them



	//Last up, growing brand new limbs and organs to replace those lost or removed.
	if (life_tick % (LIFETICK_INTERVAL_LESS*8) == 0 && (DS.stored_energy > (0.5 * DS.max_energy)))
		//We will only replace ONE organ or limb each time this procs
		var/path
		for (var/i in species.has_limbs)
			path = species.has_limbs[i]["path"]
			var/limb_exists = 0
			for (var/obj/item/organ/external/B in organs)
				if (B.type == path)
					limb_exists = 1
					break

			if (!limb_exists) //We've found a limb which is missing!
				break
			else
				path = null


		if (path)
			if (DS.stored_energy < REGROW_ENERGY_REQ)
				to_chat(src, "<span class='danger'>You try to regrow a lost limb, but you lack the energy. Find more light!</span>")
				return
			if (nutrition < REGROW_FOOD_REQ)
				to_chat(src, "<span class='danger'>You try to regrow a lost limb, but you lack the biomass. Find some food!</span>")
				return
			DS.stored_energy -= REGROW_ENERGY_REQ
			nutrition -= REGROW_FOOD_REQ
			playsound(src, 'sound/species/diona/gestalt_grow.ogg', 30, 1)
			visible_message("<span class='warning'>[src] begins to shift and quiver.</span>",
				"<span class='warning'>You begin to shift and quiver, feeling a stirring within your trunk</span>")

			DS.regening_organ = TRUE
			addtimer(CALLBACK(src, .proc/diona_regen_callback, path), 52)
			return


		//Now regrowing internal organs
		for (var/i in species.has_organ)
			path = species.has_organ[i]
			var/organ_exists = 0
			for (var/obj/item/organ/diona/B in internal_organs)
				if (B.type == path)
					organ_exists = 1
					break

			if (!organ_exists) //We've found an organ which is missing!
				break
			else
				path = null

		if (path)
			if (DS.stored_energy < REGROW_ENERGY_REQ)
				to_chat(src, "<span class='danger'>You try to regrow a lost organ, but you lack the energy. Find more light!</span>")
				return

			if (nutrition < REGROW_FOOD_REQ)
				to_chat(src, "<span class='danger'>You try to regrow a lost organ, but you lack the biomass. Find some food!</span>")
				return

			DS.stored_energy -= REGROW_ENERGY_REQ
			nutrition -= REGROW_FOOD_REQ
			var/obj/item/organ/O = new path(src)
			internal_organs_by_name[O.organ_tag] = O
			internal_organs.Add(O)
			to_chat(src, "<span class='danger'>You feel a shifting sensation inside you as your nymphs move apart to make space, forming a new [O.name]</span>")
			regenerate_icons()
			DS.LMS = max(2, DS.LMS) //Prevents a message about darkness in light areas
			update_dionastats() //Re-find the organs in case they were lost or regained
			updatehealth()
			return

		if (DS.stored_energy < REGROW_ENERGY_REQ || nutrition < REGROW_FOOD_REQ)
			return

		for (var/mob/living/carbon/alien/diona/D in bad_internal_organs)
			if (D.stat == DEAD || D.health <= 0)
				D.health = 1
				D.stat = CONSCIOUS
				to_chat(src, "<span class='danger'>You feel a stirring within you as [D.name] returns to life!</span>")
				updatehealth()
				return
				//Only one per proc

		//If we have less than six nymphs, we add one each proc
		if (topup_nymphs(1))
			DS.stored_energy -= REGROW_ENERGY_REQ
			nutrition -= REGROW_FOOD_REQ
			to_chat(src, "<span class='danger'>You feel a stirring inside you as a new nymph is born within your trunk!</span>")

	updatehealth()

/mob/living/carbon/human/proc/diona_regen_callback(organ_path, /datum/dionastats/DS)
	if (!organ_path || !DS)
		return

	var/obj/item/organ/O = new organ_path(src)
	visible_message("<span class='danger'>With a shower of sticky sap, a new mass of tendrils bursts forth from [src]'s trunk, forming a new [O]</span>",
		"<span class='danger'>With a shower of sticky sap, a new mass of tendrils bursts forth from your trunk, forming a new [O]</span>")
	var/datum/reagents/vessel = get_vessel(0)
	var/datum/reagent/B = vessel.get_master_reagent()
	B.touch_turf(get_turf(src))
	regenerate_icons()

	DS.LMS = min(2, DS.LMS) //Prevents a message about darkness in light areas
	DS.regening_organ = FALSE

	update_dionastats() //Re-find the organs in case they were lost or regained
	updatehealth()

//MESSAGE FUNCTIONS
/mob/living/carbon/proc/diona_handle_lightmessages(var/datum/dionastats/DS)
	//This function handles the RP messages that inform the diona player about their light/withering state
	//Lightstates:
	//1: Full. Go down from this state below 80%
	//2. average: Go up a state at 100%, go down a state at 50%
	//3. Subsisting: Go down from this state at 0.% light, go up from it at 40%
	//4: Pain: Go up to this state when light is negative and damage < 40. Go down from when damage >60
	//5: Critical:Go up to this state when damage < 100 and not paralysed. Go down from it when halloss hits 100 and you're paralysed
	//6: Dying: You've collapsed from pain and are dying. theres nothing below this but death
	DS.EP = DS.stored_energy / DS.max_energy

	if (DS.LMS == 1) //If we're full
		if (DS.EP <= 0.8 && DS.last_lightlevel <= 0) //But at <=80% energy
			DS.LMS = 2
			to_chat(src, "<span class='warning'>The darkness makes you uncomfortable.</span>")

	else if (DS.LMS == 2)
		if (DS.EP >= 0.99)
			DS.LMS = 1
			to_chat(src, "You bask in the light")
		else if (DS.EP <= 0.4 && DS.last_lightlevel <= 0)
			DS.LMS = 3
			to_chat(src, "<span class='warning'>You feel lethargic as your energy drains away. Find some light soon!</span>")

	else if (DS.LMS == 3)
		if (DS.EP >= 0.5)
			DS.LMS = 2
			to_chat(src, "You feel a little more energised as you return to the light. Stay awhile.")
		else if (DS.EP <= 0.0 && DS.last_lightlevel <= 0)
			DS.LMS = 4
			to_chat(src, "<span class='danger'>You feel sensory distress as your tendrils start to wither in the darkness. You will die soon without light.</span>")
	//From here down, we immediately return to state 3 if we get any light
	else
		if (DS.EP > 0.0) //If there's any light at all, we can be saved
			to_chat(src, "At long last, light! Treasure it, savour it, hold onto it.")
			DS.LMS = 3
		else if(DS.last_lightlevel <= 0)
			var/HP = 1 //HP  = health-percentage
			if (DS.LMS == 4)
				if (HP < 0.6)
					to_chat(src, "<span class='danger'>The darkness burns. Your nymphs decay and wilt You are in mortal danger!</span>")
					DS.LMS = 5

			else if (DS.LMS == 5)
				if (paralysis > 0)
					to_chat(src, "<span class='danger'>Your body has reached critical integrity, it can no longer move. The end comes soon.</span>")
					DS.LMS = 6
			else if (DS.LMS == 6)
				return

//GETTER FUNCTIONS

/mob/living/carbon/proc/get_lightlevel_diona(var/datum/dionastats/DS)
	var/light_factor = 1.15
	var/turf/T = get_turf(src)
	if (is_ventcrawling)
		return -1.5 //no light inside pipes


	if (DS.light_organ)
		if (DS.light_organ.is_broken())
			light_factor *= 0.55
		else if (DS.light_organ.is_bruised())
			light_factor *= 0.8
	else if (DS.dionatype == 2)
		light_factor = 1

	if (T)
		var/raw = min(T.get_uv_lumcount(0, 2) * light_factor * 5.5, 5.5)
		return raw - 1.5

/mob/living/carbon/proc/diona_get_health(var/datum/dionastats/DS)
	if (DS.dionatype == 0)
		return health
	else
		return health+(maxHealth*0.5)

/mob/living/carbon/proc/get_dionastats()
	if (istype(src, /mob/living/carbon/alien/diona))
		var/mob/living/carbon/alien/diona/T = src
		return T.DS

	if (istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/T = src
		if (istype(T.species, /datum/species/diona))
			return T.DS
	return null

//Called on a nymph when it merges with a gestalt
//The nymph and gestalt get the combined total of both of their languages
//Note that the nymphs only have all languages while they're inside the gestalt.
/mob/living/carbon/proc/sync_languages(var/mob/living/carbon/host)
	for (var/datum/language/L in languages)
		if (!(L in host.languages))
			host.add_language(L.name)
			to_chat(host, "<span class='notice'><font size=3>[src] has passed on its knowledge of the [L.name] language to you!</font></span>")

	languages = host.languages.Copy()


//Called on a nymph when it splits off from a gestalt.
//Or on all of them if the gestalt splits into a swarm of nymphs
//The nymph has a chance to inherit each language
/mob/living/carbon/alien/diona/proc/split_languages(var/mob/living/carbon/host)
	languages.Cut()

	add_language(species.default_language) //They always have rootsong

	for (var/datum/language/L in host.languages)
		var/chance = 40

		if (istype(L, /datum/language/diona))
			continue

		if (istype(L, /datum/language/common)) //more likely to keep common
			chance = 85


		if (prob(chance))
			add_language(L.name)
		else
			to_chat(src, "<span class='danger'>You have forgotten the [L.name] language!</span>")

//DIONASTATS DEFINES

//Dionastats is an instanced object that diona will each create and hold a reference to.
//It's used to store information which are relevant to both types of diona, to save on adding variables to carbon
//Most of these values are calculated from information configured at authortime in either diona_nymph.dm or diona_gestalt.dm
/datum/dionastats
	var/max_energy //how much energy the diona can store. will determine how long its energy lasts in darkness
	var/stored_energy //how much is currently stored
	var/EP //Energy percentage.
	var/trauma_factor //Multiplied with severity to determine how much damage the diona takes in darkness
	var/pain_factor //Multiplied with severity to determine how much pain the diona takes in darkness
	var/max_health = 100
	var/healing_factor = 1.0 //A multiplier that changes with body temperature
	var/atom/last_location = null
	var/last_lightlevel = 0

	var/regening_organ = FALSE // Tracking whether or not an organ is currently
                               // being regenreated.

	var/restrictedlight_factor = 0.8 //A value between 0 and 1 that determines how much we nerf the strength of certain worn lights
		//1 means flashlights work normally., 0 means they do nothing

	var/obj/item/organ/diona/node/light_organ = null //The organ this gestalt uses to recieve light. This is left null for nymphs
	var/obj/item/organ/diona/nutrients/nutrient_organ = null //Organ
	var/LMS = 1 //Lightmessage state. Switching between states gives the user a message
	var/dionatype //1 = nymph, 2 = worker gestalt


/datum/dionastats/Destroy()
	light_organ = null //Nulling out these references to prevent GC errors
	nutrient_organ = null
	return ..()


#undef FLASHLIGHT_STRENGTH
#undef PDALIGHT_STRENGTH
#undef DIONA_MAX_LIGHT
#undef TEMP_REGEN_STOP
#undef TEMP_REGEN_NORMAL
#undef TEMP_INCREASE_REGEN_DOUBLE
#undef LIFETICK_INTERVAL_LESS
#undef REGROW_FOOD_REQ
#undef REGROW_ENERGY_REQ
#undef diona_max_pressure
#undef diona_nutrition_factor
