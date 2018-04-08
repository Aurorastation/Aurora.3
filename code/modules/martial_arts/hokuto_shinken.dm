#define SOKIN_JIZAI_KYAKU_COMBO "HHD"
#define GOSHI_RETSU_COMBO "DDHD"
#define GEKITSUI_SHI_COMBO "HDHDH"

/datum/martial_art/hokuto_shinken
	name = "Hokuto Shinken"
	deflection_chance = 100
	help_verb = /datum/martial_art/hokuto_shinken/proc/hokuto_shinken_help


/datum/martial_art/hokuto_shinken/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(findtext(streak,SOKIN_JIZAI_KYAKU_COMBO))
		streak = ""
		Sokin_Jizai_Kyaku(A,D)
		return 1
	if(findtext(streak,GOSHI_RETSU_COMBO))
		streak = ""
		Goshi_Retsu(A,D)
		return 1
	if(findtext(streak,GEKITSUI_SHI_COMBO))
		streak = ""
		Gekitsui_Shi(A,D)
		return 1
	return 0

/datum/martial_art/hokuto_shinken/proc/Sokin_Jizai_Kyaku(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)
	if(D.stat || D.weakened)
		return 0
	D.visible_message("<span class='warning'>[A] delivers two swift kicks to [D]\'s neck!</span>", \
					  	"<span class='userdanger'>[A] kicks you twice in the neck!</span>")
	playsound(get_turf(A), "swing_hit", 50, 1, -1)
	D.apply_damage(15, BRUTE)
	D.Weaken(10)
	return 1

/datum/martial_art/hokuto_shinken/proc/Goshi_Retsu(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)

	var/obj/item/organ/external/organ = D.get_organ(A.zone_sel.selecting)
	if(!organ)
		return 0
	else if(A.zone_sel.selecting == "l_hand" || A.zone_sel.selecting == "r_hand")
		A.visible_message("<span class='warning'>[A] strikes [D]'s [organ.name] with two extended fingers!</span>")
		admin_attack_log(A, D, "exploded [organ.joint].", "had his [organ.joint] exploded.", "exploded [organ.joint] of")
		playsound(get_turf(A), "strike_hit", 50, 1, -1)
		organ.droplimb(0, DROPLIMB_BLUNT)
		return 1
	else
		playsound(get_turf(A), "punch", 50, 1, -1)
		D.apply_damage(15, BRUTE)
		A.visible_message("<span class='warning'>[A] strikes [D] with their closed fist!</span>")
		return 1
	return 1

/datum/martial_art/hokuto_shinken/proc/Gekitsui_Shi(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	log_and_message_admins("gibbed [key_name(D)] with Hokuto Shinken.", A)

	A.do_attack_animation(D)
	A.visible_message("<span class='warning'>[A] strikes [D]\'s forehead with four extended fingers!</span>")
	playsound(get_turf(A), "sound/voice/already_dead.ogg", 50)
	D.Stun(10)
	A.say("Omae Wa Mou Shindeiru.")
	addtimer(CALLBACK(D, /mob/.proc/say, "Nani?!"), 25)
	addtimer(CALLBACK(D, /mob/.proc/gib), 33)
	addtimer(CALLBACK(GLOBAL_PROC, /proc/playsound, D.loc, "sound/magic/Disintegrate.ogg", 50, 1, -1), 33)
	return

/datum/martial_art/hokuto_shinken/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1

/datum/martial_art/hokuto_shinken/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1

/datum/martial_art/hokuto_shinken/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1

/datum/martial_art/hokuto_shinken/proc/hokuto_shinken_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques Hokuto Shinken."
	set category = "Hokuto Shinken"

	to_chat(usr, "<b><i>You clench your fists and have a flashback of knowledge...</i></b>")
	to_chat(usr, "<span class='notice'>Hakkei no Ho</span>: Passive. Deflects all projectiles.")
	to_chat(usr, "<span class='notice'>Sokin Jizai Kyaku</span>: Harm Harm Disarm. Paralyses an opponent for several seconds.")
	to_chat(usr, "<span class='notice'>Goshi Retsu Dan</span>: Disarm Disarm Harm Disarm. Explodes an opponent's hand.")
	to_chat(usr, "<span class='notice'>Gekitsui Shi</span>: Harm Disarm Harm Disarm Harm. They are already dead.")

/obj/item/hokuto_shinken_scroll
	name = "frayed scroll"
	desc = "An aged and frayed scrap of paper written in shifting runes. There are hand-drawn illustrations of pugilism."
	icon = 'icons/obj/wizard.dmi'
	icon_state ="scroll2"

/obj/item/hokuto_shinken_scroll/attack_self(mob/user as mob)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/datum/martial_art/hokuto_shinken/F = new/datum/martial_art/hokuto_shinken(null)
	F.teach(H)
	to_chat(H, "<span class='boldannounce'>You have learned the ancient martial art Hokuto Shinken.</span>")
	user.drop_item()
	qdel(src)