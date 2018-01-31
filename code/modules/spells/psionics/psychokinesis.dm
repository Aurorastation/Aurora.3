//Psychokinesis is the discipline of manipulating material objects through material forces, such as manipulating an object from afar, creating walls of force, shooting
//spikes of force, or levitating. The opposite discipline to psychokinesis is subterfuge.

//-----------------------------------------------------------//

//Initiate:
//Latent powers are granted immediately to anyone who selects this discipline as their focus. Cantrips consume no willpower, only having a cooldown.

/spell/hand/psyker/push
	name = "Psychic Push"
	desc = "You push an object or creature gently away from you. Does not affect targets firmly rooted."
	school = PSY
	duration = 30
	spell_delay = 5
	charge_max = 100
	friendly = 1
	casts = -1
	compatible_targets = list(/atom/movable)

/spell/hand/psyker/push/cast_hand(var/atom/A,var/mob/user)
	var/atom/movable/M = A
	user.visible_message("<span class='danger'>\The [user] gestures violently towards \the [A]!</span>")
	if(M.anchored)
		return 0
	if(ismob(M))
		for(var/i = 1 to 5)
			step_away(M,user,15)
			sleep(1)
	else
		for(var/i = 1 to 10)
			step_away(M,user,15)
			sleep(1)
	M << "<span class='danger'>You feel yourself propelled by invisible force!</span>"
	return 1

/spell/aoe_turf/conjure/forcewall/psyker
	name = "Forcewall"
	desc = "Create a wall of pure energy at your location."
	school = PSY
	spell_flags = Z2NOCAST
	invocation_type = SpI_EMOTE
	invocation = "forms a wall of cascading energy at the base of their feet!"
	message = ""
	summon_type = list(/obj/effect/forcefield/psy)
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
	spell_flags = Z2NOCAST
	invocation_type = SpI_EMOTE
	invocation = "snaps their fingers together, as their hand encases itself with malleable energy!"
	friendly = 1
	school = PSY
	duration = 30
	spell_delay = 5
	charge_max = 100
	casts = -1

/spell/hand/psyker/multitool/cast(list/targets, mob/user)
	for(var/mob/M in targets)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			psybrain = H.internal_organs_by_name["brain"]
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
			var/obj/item/weapon/magic_hand/multitool/Hand = new(get_turf(user), src, user)
			if(!H.put_in_active_hand(Hand))
				qdel(Hand)
				return
			hand = Hand
			brain.willpower -= power_cost
			if(brain.willpower < 0)
				H.backblast((brain.willpower * -1))
		else
			user << "<span class='warning'>Your mind is not complex enough for such artistry!</span>"
			return

/spell/hand/psyker/multitool/cast_hand(var/atom/A,var/mob/user)
	return 1

/obj/item/weapon/magic_hand/multitool
	force = 1
	var/emulating = "Crowbar"

/obj/item/weapon/magic_hand/multitool/iscrowbar()
	return emulating == "Crowbar"

/obj/item/weapon/magic_hand/multitool/iswrench()
	return emulating == "Wrench"

/obj/item/weapon/magic_hand/multitool/isscrewdriver()
	return emulating == "Screwdriver"

/obj/item/weapon/magic_hand/multitool/iswirecutter()
	return emulating == "Wirecutters"

/obj/item/weapon/magic_hand/multitool/attack_self(mob/living/user)

	if(!hand_spell || !user || !user.loc)
		return

	var/choice = input("Select a tool to emulate.","Power") as null|anything in list("Crowbar","Wrench","Screwdriver","Wirecutters","Dismiss Power")
	if(!choice)
		return

	if(!hand_spell || !user || !user.loc)
		return

	if(choice == "Dismiss Power")
		return ..()

	emulating = choice
	name = "power fist (Tinker - [emulating])"
	user << "<span class='notice'>You begin emulating \a [lowertext(emulating)].</span>"
	//user << 'sound/effects/psi/power_fabrication.ogg'

//Adept:
//Adept powers are largely nonoffensive, with small willpower costs and low cooldowns.

/spell/hand/psyker/pull
	name = "Psychic Pull"
	desc = "You pull an object or creature violently towards you. Does not affect targets firmly rooted."
	friendly = 1
	school = PSY
	power_level = 1
	power_cost = 20
	spell_delay = 20
	duration = 15
	compatible_targets = list(/atom/movable)

/spell/hand/psyker/pull/cast_hand(var/atom/A,var/mob/user)
	var/atom/movable/M = A
	user.visible_message("<span class='danger'>\The [user] gestures violently towards \the [A]!</span>")
	if(M.anchored)
		return 0
	if(isliving(M))
		var/mob/living/L = M
		for(var/i = 1 to 3)
			L.apply_effect(5, WEAKEN)
			step_to(L,user,1)
	else
		for(var/i = 1 to 5)
			step_to(M,user,1)
	M << "<span class='danger'>You feel yourself propelled by invisible force!</span>"
	return 1

/spell/hand/psyker/psyblade
	name = "Psy Blade"
	desc = "You conjured a blade of psionic energy that saps willpower from your target along with damaging them."
	school = PSY
	power_level = 1
	power_cost = 20
	spell_delay = 20
	duration = 30
	min_range = 1
	hand_state = "psy_blade"
	casts = -1

/spell/hand/psyker/psyblade/cast(list/targets, mob/user)
	..()
	if(hand)
		hand.sharp = 1
		hand.edge = 1
		hand.flags = NOBLOODY
		hand.force = round(10+(psybrain.power_level**2))

/spell/hand/psyker/pull/cast_hand(var/atom/A,var/mob/user)
	if(brain)
		if(brain.willpower > 0)
			var/soulfire = rand(hand.force/3,hand.force)
			brain.willpower -= soulfire
			if(psybrain.willpower < psybrain.max_willpower)
				psybrain.willpower += soulfire
				if(psybrain.willpower > psybrain.max_willpower)
					psybrain.willpower = psybrain.max_willpower
			anim(get_turf(A), A,'icons/effects/effects.dmi',,"soulfire",,A.dir)
			A.visible_message("<span class='danger'>\The [A] is surrounded by a pulse of psionic energy!</span>")
			return 1
	return 0

//Operant:

/spell/hand/psyker/crushing_grip //deal internal damage, crush walls, damage objects and structures, all touch-based

/spell/hand/psyker/unrelenting_force //violently push a target away, stunning and dealing brute

//Masterclass:
//Masterclass powers and above are available only to those who have specialized in this particular discipline.

/spell/targeted/genetic/telekinesis

/spell/hand/psyker/stun_cuff //stun and cuff a target

//Grandmasterclass:
/spell/hand/psyker/vortex
//create a vortex on the ground. all items and mobs are drawn towards that point until the vortex is destroyed or dissipates. mobs are not stunned
//if the vortex times out it deals organ damage to anyone on or adjacent to it. does not happen if destroyed.