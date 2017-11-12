//Coercion is the discipline of manipulating intelligent beings and their component organs. It includes arts such as manipulating the musculature of the hand to drop
//an object, eradicating physical wounds, strengthening the flesh, or even reviving the dead. The opposite discipline to coercion is energistics.

//-----------------------------------------------------------//

//Initiate:
//Latent powers are granted immediately to anyone who selects this discipline as their focus. Cantrips consume no willpower, only having a cooldown.\

/spell/hand/psyker/vomit
	name = "Revulsion"
	desc = "Fill the target with revulsion, forcing them to vomit."
	school = COE
	invocation = "is surrounded by purplish light as their dominant hand fills with volatile energy."
	invocation_type = SpI_EMOTE
	message = "You feel your stomach upturn itself involuntarily, sending its contents up your throat and across the floor."
	power_level = 0
	power_cost = 0
	casts = 2
	duration = 15
	spell_delay = 50
	charge_max = 500

/spell/hand/psyker/vomit/cast_hand(var/atom/A,var/mob/user)
	..()
	if(istype(A,/mob/living/carbon))
		var/mob/living/carbon/C = A
		C.vomit()
	return 1


/spell/hand/psyker/antivomit
	name = "Nutrition"
	desc = "Convert the target's aura into nutrition, filling their stomach with psychic goodness.."
	school = COE
	invocation = "is surrounded by purplish light as their dominant hand fills with volatile energy."
	invocation_type = SpI_EMOTE
	message = "You feel your stomach warm, before feeling slightly fuller..."
	power_level = 0
	power_cost = 0
	duration = 15
	spell_delay = 50
	charge_max = 100

/spell/hand/psyker/antivomit/cast_hand(var/atom/A,var/mob/user)
	..()
	if(istype(A,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = A
		H.nutrition += 60
	return 1

/spell/hand/psyker/mend
	name = "Mend Flesh"
	desc = "You touch the target and fill them with healing energy. Cannot be used on self."
	school = COE
	invocation = "is surrounded by purplish light as their dominant hand fills with volatile energy."
	invocation_type = SpI_EMOTE
	message = "You feel your muscles relax as a pleasant sensation fills your body."
	power_level = 0
	power_cost = 0
	touch = 1
	duration = 25
	spell_delay = 50
	charge_max = 100

/spell/hand/psyker/mend/cast_hand(var/atom/A,var/mob/user)
	..()
	if(istype(A,/mob/living) && A != user)
		var/mob/living/L = A
		L.adjustBruteLoss(-5)
		L.adjustToxLoss(-5)
		L.adjustOxyLoss(-5)
		L.adjustFireLoss(-5)
	return 1

//Adept:
//Adept powers are largely nonoffensive, with small willpower costs and low cooldowns.

//Operant:

//Masterclass:
//Masterclass powers and above are available only to those who have specialized in this particular discipline.

//Grandmasterclass: