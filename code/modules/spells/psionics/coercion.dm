//Coercion is the discipline of manipulating intelligent beings and their component organs. It includes arts such as manipulating the musculature of the hand to drop
//an object, eradicating physical wounds, strengthening the flesh, or even reviving the dead. The opposite discipline to coercion is energistics.

//-----------------------------------------------------------//

//Initiate:
//Latent powers are granted immediately to anyone who selects this discipline as their focus. Cantrips consume no willpower, only having a cooldown.\

/spell/hand/psyker/vomit
	name = "Revulsion"
	desc = "Fill the target with revulsion, forcing them to vomit."
	school = COE
	power_level = 0
	power_cost = 0
	spell_delay = 50
	duration = 15
	spell_delay = 50
	charge_max = 500
	compatible_targets = list(/mob/living/carbon)

/spell/hand/psyker/vomit/cast_hand(var/atom/A,var/mob/user)
	..()
	var/mob/living/carbon/C = A
	user << "<span class='danger'>You fill \the [C] with negative energy!</span>"
	C.vomit()
	user << "<span class='danger'>You feel your insides cramp as your stomach upheaves itself!</span>"
	return 1

/spell/hand/psyker/antivomit
	name = "Nutrition"
	desc = "Convert the target's aura into nutrition, filling their stomach with psychic goodness. Cannot be used on self."
	school = COE
	power_level = 0
	power_cost = 0
	duration = 15
	spell_delay = 50
	charge_max = 100
	casts = -1
	compatible_targets = list(/mob/living/carbon/human)

/spell/hand/psyker/antivomit/cast_hand(var/atom/A,var/mob/user)
	..()
	var/mob/living/carbon/human/H = A
	H.nutrition += 60
	user << "<span class='info'>You fill \the [H] with positive energy, recharging their energy!</span>"
	H << "<span class='info'>You feel your stomach fill with warmth and your hunger disappear!</span>"
	return 1

/spell/hand/psyker/skinsight
	name = "Skin Sight"
	desc = "You percieve the damages of a target's mind and body."
	school = COE
	power_level = 0
	power_cost = 0
	duration = 25
	spell_delay = 50
	charge_max = 100
	casts = -1
	compatible_targets = list(/mob/living)

/spell/hand/psyker/skinsight/cast_hand(var/atom/A,var/mob/user)
	..()
	var/mob/living/L = A
	user << "<span class='info'>Oxygen Deprivation: [L.getOxyLoss()].</span>"
	user << "<span class='info'>Toxicity: [L.getToxLoss()].</span>"
	user << "<span class='info'>Burn Damage: [L.getFireLoss()].</span>"
	user << "<span class='info'>Physical Trauma: [L.getBruteLoss()].</span>"
	user << "<span class='info'>Brain Damage: [L.getBrainLoss()].</span>"
	user << "<span class='info'>Genetic Damage: [L.getCloneLoss()].</span>"
	if(brain)
		user << "<span class='info'>Willpower [brain.max_willpower].</span>"
		user << "<span class='info'>Willpower Available: [brain.willpower].</span>"
	return 1

//Adept:
//Adept powers are largely nonoffensive, with small willpower costs and low cooldowns.

/spell/hand/psyker/cramp
	name = "Spasm"
	desc = "Force the target to be disarmed of their tools."
	school = COE
	power_level = 1
	power_cost = 20
	spell_delay = 20
	duration = 15
	compatible_targets = list(/mob/living/carbon)

/spell/hand/psyker/cramp/cast_hand(var/atom/A,var/mob/user)
	..()
	var/mob/living/carbon/C = A
	user << "<span class='danger'>You stab a lance of psipower into \the [target]'s muscles!</span>"

	if(C.stat != CONSCIOUS)
		return

	C << "<span class='danger'>The muscles in your hands cramp horrendously!</span>"
	if(prob(75))
		C.emote("scream")
	if(prob(75) && C.l_hand && !C.l_hand.abstract && C.unEquip(C.l_hand))
		C.visible_message("<span class='danger'>\The [C] drops what they were holding as their left hand spasms!</span>")
	if(prob(75) && C.r_hand && !C.r_hand.abstract && C.unEquip(C.r_hand))
		C.visible_message("<span class='danger'>\The [C] drops what they were holding as their right hand spasms!</span>")
	return 1

/spell/targeted/genetic/mute //anyone in sight can be muted

//Operant:

/spell/hand/psyker/blindstrike
	name = "Mind Static"
	desc = "Fill the target's mind with static, rendering them temporarily blind and deaf."
	school = COE
	power_level = 1
	power_cost = 20
	duration = 15
	spell_delay = 50
	charge_max = 200
	compatible_targets = list(/mob/living/carbon)

/spell/hand/psyker/blindstrike/cast_hand(var/atom/A,var/mob/user)
	..()
	var/mob/living/carbon/C = A
	user << "<span class='danger'>You fill \the [C]'s mind with psionic static!</span>"
	C.vomit()
	C.emote("scream")
	C << "<span class='danger'>Your sense are blasted into oblivion by a burst of mental static!</span>"
	flick("e_flash", C.flash)
	C.eye_blind = max(C.eye_blind,3)
	C.ear_deaf = max(C.ear_deaf,6)
	return 1

/spell/hand/psyker/mend
	name = "Mend Flesh"
	desc = "You touch the target and fillthem with healing energy."
	school = COE
	power_level = 1
	power_cost = 20
	spell_delay = 20
	duration = 15
	spell_delay = 50
	charge_max = 100
	min_range = 1
	compatible_targets = list(/mob/living)

/spell/hand/psyker/mend/cast_hand(var/atom/A,var/mob/user)
	..()
	user << "<span class='info'>You fill \the [A] with positive psionic energy!</span>"
	var/mob/living/L = A
	L.adjustBruteLoss(-15)
	L.adjustToxLoss(-15)
	L.adjustOxyLoss(-15)
	L.adjustFireLoss(-15)
	L.adjustBrainLoss(-15)
	L.adjustCloneLoss(-15)
	L << "<span class='info'>You feel warmth coalesce throughout your weary body and your troubles dampen slightly!</span>"
	return 1

//Masterclass:
//Masterclass powers and above are available only to those who have specialized in this particular discipline.

/spell/targeted/genetic/hulk //anyone in touch can be hulk'd

/spell/hand/psyker/revive //bring a body back from the dead for a willpower cost AND self-inflicted brute damage

//Grandmasterclass:
/spell/hand/psyker/puppet //temporary mind-swap. psyker's body is moved to the void while it goes on.