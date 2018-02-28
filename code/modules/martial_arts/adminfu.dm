///Adminfu
//Help act:Heal/revie GP //p is for help
//Disarm:Stun
//Grab:Neck
//Harm:Gib
#define HEAL_COMBO "GP"

/datum/martial_art/adminfu
	name = "Way of the Dancing Admin"
	help_verb = /mob/living/carbon/human/proc/adminfu_help

/datum/martial_art/adminfu/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(findtext(streak,HEAL_COMBO))
		streak = ""
		healPalm(A,D)
		return 1
	return 0

/datum/martial_art/adminfu/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)

	if(!D.stat)//do not kill what is dead...
		A.do_attack_animation(D)
		D.visible_message("<span class='warning'>[A] manifests a large glowing toolbox and shoves it in [D]'s chest!</span>", \
							"<spac class='userdanger'>[A] shoves a mystical toolbox in your chest!</span>")
		D.death()

		return 1


/datum/martial_art/adminfu/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)
	D.Weaken(25)
	D.Stun(25)
	return 1

/datum/martial_art/adminfu/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return 1
	D.grabbedby(A,1)
	var/obj/item/weapon/grab/G = A.get_active_hand()
	if(G)
		G.state = GRAB_NECK

/datum/martial_art/adminfu/help_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("P",D)
	if(check_streak(A,D))
		return 1

/datum/martial_art/adminfu/proc/healPalm(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)
	D.visible_message("<span class='warning'>[A] smacks [D] in the forehead!</span>")

	if(istype(D,/mob))

		D.revive()


/mob/living/carbon/human/proc/adminfu_help()
	set name = "Recall Teachings"
	set desc = "Remember the way of the dancing admin."
	set category = "Adminfu"

	to_chat(usr, "<span class='notice'>Grab</span>: Automatic Neck Grab.")
	to_chat(usr, "<span class='notice'>Disarm</span>: Stun/weaken")
	to_chat(usr, "<span class='notice'>Harm</span>: Death.")
	to_chat(usr, "<span class='notice'>Healing Palm:</span>:Combo:Grab,Help intent. Heals or revives a crature.")


/obj/item/adminfu_scroll
	name = "frayed scroll"
	desc = "An aged and frayed scrap of paper written in shifting runes. There are hand-drawn illustrations of pugilism."
	icon = 'icons/obj/wizard.dmi'
	icon_state ="scroll2"
	var/used = 0

/obj/item/adminfu_scroll/attack_self(mob/user as mob)
	if(!ishuman(user))
		return
	if(!used)
		var/mob/living/carbon/human/H = user
		var/datum/martial_art/adminfu/F = new/datum/martial_art/adminfu(null)
		F.teach(H)
		to_chat(H, "<span class='boldannounce'>You have learned the ancient martial art of the Admins.</span>")
		used = 1
		desc = "It's completely blank."
		name = "empty scroll"
		icon_state = "blankscroll"