//Psychokinesis is the discipline of manipulating material objects through material forces, such as manipulating an object from afar, creating walls of force, shooting
//spikes of force, or levitating. The opposite discipline to psychokinesis is subterfuge.

//-----------------------------------------------------------//

//Initiate:
//Latent powers are granted immediately to anyone who selects this discipline as their focus. Cantrips consume no willpower, only having a cooldown.

/spell/hand/psyker/push
	name = "Psychic Push"
	desc = "You push an object or creature gently away from you. Does not affect targets firmly rooted."
	school = PSY
	invocation = "is surrounded by purplish light as their dominant hand fills with psionic energy."
	invocation_type = SpI_EMOTE
	message = "You feel a strong gust of wind push you away!"
	duration = 30
	spell_delay = 5
	charge_max = 100

/spell/hand/psyker/push/cast_hand(var/atom/A,var/mob/user)
	if(istype(A,/atom/movable))
		var/atom/movable/M = A
		if(M.anchored)
			return 0
	if(ismob(A))
		for(var/i = 1 to 5)
			step_away(A,user,15)
	else
		for(var/i = 1 to 10)
			step_away(A,user,15)
	return 1

/spell/aoe_turf/conjure/forcewall/psyker
	name = "Forcewall"
	desc = "Create a wall of pure energy at your location."
	school = PSY
	summon_type = list(/obj/effect/forcefield/psy)
	invocation = "fills the area around them with cascading psionic force."
	invocation_type = SpI_EMOTE
	duration = 300
	charge_max = 100
	range = 0
	cast_sound = 'sound/magic/ForceWall.ogg'

	hud_state = "wiz_psy"

/obj/effect/forcefield/psy
	desc = "A wall of psionic force, preventing movement."
	name = "forcewall"
	icon = 'icons/effects/effects.dmi'
	icon_state = "psy_wall"

/spell/hand/psyker/multitool
	name = "Tinker"
	desc = "You manipulate machinery, simulating screwdrivers, crowbars, wrenches, and wirecutters with your mind."
	school = PSY
	message = ""
	duration = 60
	spell_delay = 5
	charge_max = 100

/spell/hand/psyker/multitool/cast(list/targets, mob/user)
	for(var/mob/M in targets)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.get_active_hand())
				user << "<span class='warning'>You need an empty hand to cast this spell.</span>"
				return
			brain = H.internal_organs_by_name["brain"]
			if(!istype(brain,/obj/item/organ/brain) || !brain)
				user << "<span class='warning'>You lack the brain necessary for psionic power!</span>"
				return
			if(brain.max_willpower <= 0)
				user << "<span class='warning'>You lack the willpower necessary for psionic power!</span>"
				return
			if(!brain.awoken)
				user << "<span class='warning'>You do not know how to access the secrets of the mind!</span>"
				return
			var/obj/item/magic_hand/psyker/multitool/Hand = new(src)
			if(!H.put_in_active_hand(Hand))
				qdel(Hand)
				return
			brain.willpower -= power_cost
			if(brain.willpower < 0)
				H.backblast((brain.willpower * -1))
		else
			user << "<span class='warning'>Your mind is not complex enough for such artistry!</span>"
			return

/spell/hand/psyker/multitool/cast_hand(var/atom/A,var/mob/user)
	return 1

/obj/item/magic_hand/psyker/multitool/ismultitool()
	return 1

/obj/item/magic_hand/psyker/multitool/iscrowbar()
	return 1

/obj/item/magic_hand/psyker/multitool/iswrench()
	return 1

/obj/item/magic_hand/psyker/multitool/isscrewdriver()
	return 1

/obj/item/magic_hand/psyker/multitool/iswirecutter()
	return 1

//Adept:
//Adept powers are largely nonoffensive, with small willpower costs and low cooldowns.

//Operant:

//Masterclass:
//Masterclass powers and above are available only to those who have specialized in this particular discipline.

//Grandmasterclass: