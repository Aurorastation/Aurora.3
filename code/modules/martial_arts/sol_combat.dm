#define NECK_CHOP "HHD"
#define LEG_SWEEP "DHD"
#define QUICK_CHOKE "HDH"

/datum/martial_art/sol_combat
	name = "Solarian Combat"
	help_verb = /datum/martial_art/sol_combat/proc/sol_combat_help

/datum/martial_art/sol_combat/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(findtext(streak,NECK_CHOP))
		streak = ""
		neck_chop(A,D)
		return 1
	if(findtext(streak,LEG_SWEEP))
		streak = ""
		leg_sweep(A,D)
		return 1
	if(findtext(streak,QUICK_CHOKE))
		streak = ""
		quick_choke(A,D)
		return 1
	return 0

/datum/martial_art/sol_combat/proc/leg_sweep(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)
	if(D.stat || D.weakened)
		return 0
	D.visible_message("<span class='warning'>[A] leg sweeps [D]!</span>", \
					  	"<span class='userdanger'>[A] leg sweeps you!</span>")
	playsound(get_turf(A), "swing_hit", 50, 1, -1)
	D.apply_damage(5, BRUTE)
	D.Weaken(2)
	return 1

/datum/martial_art/sol_combat/proc/quick_choke(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)//is actually lung punch
	A.do_attack_animation(D)
	D.visible_message("<span class='warning'>[A] pounds [D] on the chest!</span>", \
				  	"<span class='userdanger'>[A] slams your chest!</span>")
	playsound(get_turf(A), 'sound/weapons/punch1.ogg', 50, 1, -1)
	D.losebreath += 5
	D.adjustOxyLoss(10)
	return 1

/datum/martial_art/sol_combat/proc/neck_chop(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)
	D.visible_message("<span class='warning'>[A] karate chops [D]'s neck!</span>", \
				  	"<span class='userdanger'>[A] karate chops your neck, rendering you unable to speak for a short time!</span>")
	playsound(get_turf(A), "punch", 50, 1, -1)
	D.apply_damage(5, BRUTE)
	D.silent += 10
	return 1

datum/martial_art/sol_combat/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(check_streak(A,D))
		return 1
	..()

/datum/martial_art/sol_combat/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return 1
	add_logs(A, D, "punched")
	A.do_attack_animation(D)
	var/picked_hit_type = pick("punches", "kicks")
	var/bonus_damage = 10
	if(D.weakened || D.resting || D.lying)
		bonus_damage += 5
		picked_hit_type = "stomps on"
	D.apply_damage(bonus_damage, BRUTE)
	if(picked_hit_type == "kicks" || picked_hit_type == "stomps")
		playsound(get_turf(D), "swing_hit", 50, 1, -1)
	else
		playsound(get_turf(D), "punch", 50, 1, -1)
	D.visible_message("<span class='danger'>[A] [picked_hit_type] [D]!</span>", \
					  "<span class='userdanger'>[A] [picked_hit_type] you!</span>")
	return 1

/datum/martial_art/sol_combat/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("D",D)
	A.do_attack_animation(D)
	if(check_streak(A,D))
		return 1
	if(prob(60))
		if(D.hand)
			if(istype(D.l_hand, /obj/item))
				var/obj/item/I = D.l_hand
				D.drop_item()
				A.put_in_hands(I)
		else
			if(istype(D.r_hand, /obj/item))
				var/obj/item/I = D.r_hand
				D.drop_item()
				A.put_in_hands(I)
		D.visible_message("<span class='danger'>[A] has disarmed [D]!</span>", \
							"<span class='userdanger'>[A] has disarmed [D]!</span>")
		playsound(D, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	else
		D.visible_message("<span class='danger'>[A] attempted to disarm [D]!</span>", \
							"<span class='userdanger'>[A] attempted to disarm [D]!</span>")
		playsound(D, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	return 1

/obj/item/sol_combat_manual
	name = "SolCom manual"
	desc = "A manual designated to teach the user about the martial art of solarian combat, a style based on traditional human martial arts."
	icon = 'icons/obj/library.dmi'
	icon_state ="cqcmanual"

/obj/item/sol_combat_manual/attack_self(mob/user as mob)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/datum/martial_art/sol_combat/F = new/datum/martial_art/sol_combat(null)
	F.teach(H)
	to_chat(H, "<span class='notice'>You have learned the martial art of Solarian Combat.</span>")
	qdel(src)


/datum/martial_art/sol_combat/proc/sol_combat_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of the Solarian Combat."
	set category = "Solarian Combat"

	to_chat(usr, "<b><i>You clench your fists and have a flashback of knowledge...</i></b>")
	to_chat(usr, "<span class='notice'>Neck Chop</span>: Harm Harm Disarm. Injures the neck, stopping the victim from speaking for a while.")
	to_chat(usr, "<span class='notice'>Leg Sweep</span>: Disarm Harm Disarm. Trips the victim, rendering them prone and unable to move for a short time.")
	to_chat(usr, "<span class='notice'>Lung Punch</span>: Harm Disarm Harm. Delivers a strong punch just above the victim's abdomen, constraining the lungs. The victim will be unable to breathe for a short time.")