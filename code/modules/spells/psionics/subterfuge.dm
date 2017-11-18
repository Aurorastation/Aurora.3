//Subterfuge is the discipline of manipulating the world in ways to allow the user to go undetected. It includes such arts as teleportation, mental suggestion
//enthrallment, and applying damage via indirect sources such as status effects. The opposite discipline to subterfuge is psychokinesis.

//-----------------------------------------------------------//

//Initiate:
//Latent powers are granted immediately to anyone who selects this discipline as their focus. Cantrips consume no willpower, only having a cooldown.

/spell/hand/psyker/whisper
	name = "Ghost Sound"
	desc = "Covertly whisper a message into the target's mind. The target can reply once if they so choose."
	school = SUB
	invocation_type = SpI_NONE
	power_level = 0
	power_cost = 0
	duration = 20
	spell_delay = 1
	friendly = 1
	charge_max = 50
	compatible_targets = list(/mob/living)

/spell/hand/psyker/whisper/cast_hand(var/atom/A,var/mob/user)
	..()
	var/whisper = input(user,"Write a message to send.","Input a message")
	if(whisper)
		to_chat(A,"<span class ='info'><i><b>You hear a whispering in your mind:</b></i>[whisper]</span>")
		return 0
	var/response = input(user,"Write a response. If you do not wish to respond, input nothing.","Response")
	if(response)
		to_chat(user,"<span class ='info'><i><b>\The [A] responds with a thought:</b></i>[response]</span>")
	return 1

/spell/hand/psyker/agony
	name = "Agonizing Touch"
	desc = "Fill someone's mind with agony."
	school = SUB
	power_level = 0
	power_cost = 0
	casts = -1
	spell_delay = 50
	duration = 15
	charge_max = 300
	min_range = 1
	compatible_targets = list(/mob/living)

/spell/hand/psyker/agony/cast_hand(var/atom/A,var/mob/user)
	..()
	var/mob/living/L = A
	L.adjustHalLoss(30)
	L << "<span class='danger'>Your mind fills with unbearable agony!</span>"
	return 1

/spell/hand/psyker/counterfeit
	name = "Counterfeit"
	desc = "Create a illusory counterfeit of any object in sight beneath you."
	school = SUB
	power_level = 0
	power_cost = 0
	duration = 20
	spell_delay = 5
	friendly = 1
	charge_max = 200
	casts = -1
	compatible_targets = list(/obj/item)

/spell/hand/psyker/counterfeit/cast_hand(var/atom/A,var/mob/user)
	..()
	var/obj/item/psionic_mimic/mimic = new /obj/item/psionic_mimic(get_turf(user))
	var/obj/item/I = A
	mimic.name = I.name
	mimic.desc = I.desc
	mimic.icon = I.icon
	mimic.icon_state = I.icon_state
	mimic.item_state = I.item_state
	mimic.overlays = I.overlays
	return 1

/obj/item/psionic_mimic
	name = "psionic illusion"
	icon = 'icons/mob/screen1.dmi'
	w_class = 1.0
	icon_state = "spell"

/obj/item/psionic_mimic/attack() //can't be used to actually bludgeon things
	return 1

/obj/item/psionic_mimic/afterattack(atom/A, mob/living/user)
	user << "<span class='warning'>As you attempt to use the [src], it disappears in a flash of psychic energy!</span>"
	qdel(src)
	return

//Adept:
//Adept powers are largely nonoffensive, with small willpower costs and low cooldowns.

/spell/hand/psyker/parrot
	name = "Throw Voice"
	desc = "A select target will speak a message of your own choosing aloud."
	school = SUB
	invocation_type = SpI_NONE
	power_level = 1
	power_cost = 20
	duration = 20
	spell_delay = 5
	casts = 2
	charge_max = 50
	compatible_targets = list(/mob/living)

/spell/hand/psyker/parrot/cast_hand(var/atom/A,var/mob/user)
	..()
	var/mob/living/L = A
	var/whisper = input(user,"Write a message to send.","Input a message")
	if(whisper)
		L.say(whisper)
		return 0
	return 1

/spell/hand/psyker/invisibility //some form of invisibility. probably won't be based on a /hand/ spell

//Operant:
/spell/hand/psyker/suggestion //temporary, limited dominate

/spell/hand/psyker/mindwipe //removes a target's memory

//Masterclass:
//Masterclass powers and above are available only to those who have specialized in this particular discipline.

/spell/hand/psyker/blink //teleport to any location in sight

/spell/hand/psyker/astral_project //like cult and wizard's fakeghost

//Grandmasterclass:

/spell/hand/psyker/mind_control //permanent enthrallment of target. only one thrall can exist at a time.