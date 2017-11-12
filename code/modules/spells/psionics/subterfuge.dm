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

/spell/hand/psyker/blind_touch
	name = "Blinding Touch"
	desc = "Affect someone with a temporary blindness."
	message = "Your eyes cloud over!"
	school = SUB
	power_level = 0
	power_cost = 0
	touch = 1
	casts = 1
	charge_max = 300

/spell/hand/psyker/blind_touch/cast_hand(var/atom/A,var/mob/user)
	..()
	if(isliving(A))
		var/mob/living/L = A
		L.eye_blurry += 20
		L.eye_blind += 10
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

/spell/hand/psyker/counterfeit/cast_hand(var/atom/A,var/mob/user)
	..()
	if(istype(A,/obj/item))
		var/obj/item/psionic_mimic/mimic = new /obj/item/psionic_mimic(get_turf(user))
		mimic.name = A.name
		mimic.desc = A.desc
		mimic.icon = A.icon
		mimic.icon_state = A.icon_state
		mimic.overlays = A.overlays
	return 1

/obj/item/psionic_mimic
	name = "Psionic Illusion"
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

//Operant:

//Masterclass:
//Masterclass powers and above are available only to those who have specialized in this particular discipline.

//Grandmasterclass: