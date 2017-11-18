/obj/item/organ/brain
	name = "brain"
	health = 400 //They need to live awhile longer than other organs. Is this even used by organ code anymore?
	desc = "A piece of juicy meat found in a person's head."
	organ_tag = "brain"
	parent_organ = "head"
	vital = 1
	icon_state = "brain2"
	force = 1.0
	w_class = 2.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_BIO = 3)
	attack_verb = list("attacked", "slapped", "whacked")
	var/mob/living/carbon/brain/brainmob = null
	var/lobotomized = 0
	var/can_lobotomize = 1
	var/max_willpower = 20
	var/willpower //willpower is related to psionics and psionic resistance. psions use it for powers, nonpsions use it to resist powers.
	var/awoken = 0 //if they are awoken psions or not. the potential lurks in us all.
	var/can_awake = 1//if they can ever awake, such as for robits and golems 'n shit
	var/psy_rank = RANK_0
	var/power_points //discipline points available left
	var/discipline //what psionic discipline they follow
	var/power_level = 1

/obj/item/organ/pariah_brain
	name = "brain remnants"
	desc = "Did someone tread on this? It looks useless for cloning or cyborgification."
	organ_tag = "brain"
	parent_organ = "head"
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"
	vital = 1

/obj/item/organ/brain/xeno
	name = "thinkpan"
	desc = "It looks kind of like an enormous wad of purple bubblegum."
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"

/obj/item/organ/brain/Initialize(mapload)
	. = ..()
	health = config.default_brain_health
	if(owner && owner.species)
		max_willpower = owner.species.willpower
		awoken = owner.species.awoken
	if(max_willpower < 0)
		awoken = 0
		can_awake = 0
	willpower = max_willpower
	if (!mapload)
		addtimer(CALLBACK(src, .proc/clear_screen), 5)

/obj/item/organ/brain/proc/clear_screen()
	if (brainmob && brainmob.client)
		brainmob.client.screen.Cut()

/obj/item/organ/brain/Destroy()
	if(brainmob)
		qdel(brainmob)
		brainmob = null
	return ..()

/obj/item/organ/brain/proc/transfer_identity(var/mob/living/carbon/H)
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna.Clone()
	brainmob.timeofhostdeath = H.timeofdeath
	if(H.mind)
		H.mind.transfer_to(brainmob)

	brainmob << "<span class='notice'>You feel slightly disoriented. That's normal when you're just a [initial(src.name)].</span>"
	callHook("debrain", list(brainmob))

/obj/item/organ/brain/examine(mob/user) // -- TLE
	..(user)
	if(brainmob && brainmob.client)//if thar be a brain inside... the brain.
		user << "You can feel the small spark of life still left in this one."
	else
		user << "This one seems particularly lifeless. Perhaps it will regain some of its luster later.."

/obj/item/organ/brain/removed(var/mob/living/user)

	var/mob/living/simple_animal/borer/borer = owner.has_brain_worms()

	if(borer)
		borer.detatch() //Should remove borer if the brain is removed - RR

	var/obj/item/organ/brain/B = src
	if(istype(B) && istype(owner))
		B.transfer_identity(owner)

	..()

/obj/item/organ/brain/replaced(var/mob/living/target)

	if(target.key)
		target.ghostize()

	if(brainmob)
		if(brainmob.mind)
			brainmob.mind.transfer_to(target)
		else
			target.key = brainmob.key
	..()

/obj/item/organ/brain/proc/lobotomize(mob/user as mob)
	lobotomized = 1
	max_willpower = -1 //you can't use psionic powers but hey at least you're immune to most of them too.
	willpower = 0

	if(owner)
		owner << "<span class='danger'>As part of your brain is drilled out, you feel your past self, your memories, your very being slip away...</span>"
		owner << "<b>Your brain has been surgically altered to remove your memory recall. Your ability to recall your former life has been surgically removed from your brain, and while your brain is in this state you remember nothing that ever came before this moment.</b>"

	else if(brainmob)
		brainmob << "<span class='danger'>As part of your brain is drilled out, you feel your past self, your memories, your very being slip away...</span>"
		brainmob << "<b>Your brain has been surgically altered to remove your memory recall. Your ability to recall your former life has been surgically removed from your brain, and while your brain is in this state you remember nothing that ever came before this moment.</b>"

	return

/obj/item/organ/brain/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/surgicaldrill))
		if(!lobotomized)
			user.visible_message("<span class='danger'>[user] drills [src] deftly with [W] into the brain!</span>")
			lobotomize(user)
		else
			user << "<span class='notice'>The brain has already been operated on!</span>"
	..()

/obj/item/organ/brain/process()
	..()

	if(!owner)
		return

	if(lobotomized && (owner.getBrainLoss() < 50)) //lobotomized brains cannot be healed with chemistry. Part of the brain is irrevocably missing. Can be fixed magically with cloning, ofc.
		owner.setBrainLoss(50)

	if(awoken && owner.client)
		check_on_psy()

/obj/item/organ/brain/proc/check_on_psy()
	switch(psy_rank)
		if(RANK_0)
			if(max_willpower >= RANK_1_WILL)
				psy_rank = RANK_1
				power_level = 1
				psy_level(power_level)
		if(RANK_1)
			if(max_willpower >= RANK_2_WILL)
				psy_rank = RANK_2
				power_level = 2
				psy_level(power_level)
		if(RANK_2)
			if(max_willpower >= RANK_3_WILL)
				psy_rank = RANK_3
				power_level = 3
				psy_level(power_level)
		if(RANK_3)
			if(max_willpower >= RANK_4_WILL)
				psy_rank = RANK_4
				power_level = 4
				psy_level(power_level)
		if(RANK_4)
			if(max_willpower >= RANK_5_WILL)
				psy_rank = RANK_5
				power_level = 5
				psy_level(power_level)

/obj/item/organ/brain/proc/psy_level(var/rank)
	var/list/discipline_list = list(
		COE = TRUE,
		PSY = TRUE,
		ENE = TRUE,
		SUB = TRUE
	)
	if(!discipline)
		to_chat(owner, "<span class='info'><b>[COE]:</b> The discipline of manipulating intelligent beings and their component organs. Its opposing discipline is [SUB].</span>")
		to_chat(owner, "<span class='info'><b>[PSY]:</b> The discipline of manipulating material elements through physical force. Its opposing discipline is [ENE].</span>")
		to_chat(owner, "<span class='info'><b>[ENE]:</b> The discipline of manipulating immaterial elements or material elements through non-physical force. Its opposing discipline is [PSY].</span>")
		to_chat(owner, "<span class='info'><b>[SUB]:</b> The discipline of manipulating the world in ways to allow the user to go undetected. Its opposing discipline is [COE].</span>")
		discipline = input(owner,"Select a discipline. This choice is permanent.") as anything in discipline_list
	power_points += rank
	var/list/spell/Powers = list()
	for(var/spell in spells)
		var/spell/P = new spell
		if(discipline_list[P.school])
			switch(discipline)
				if(COE)
					if(P.school == SUB)
						qdel(P)
						continue
				if(PSY)
					if(P.school == ENE)
						qdel(P)
						continue
				if(ENE)
					if(P.school == PSY)
						qdel(P)
						continue
				if(SUB)
					if(P.school == COE)
						qdel(P)
						continue
			if(P.power_level > rank)
				qdel(P)
				continue
			if(P.power_level > 3 && P.school != discipline)
				qdel(P)
				continue
			if(P in owner.mind.learned_spells)
				qdel(P)
				continue
			if(P.power_level == 0)
				if(P.school == discipline)
					owner.add_spell(P, master_type=/obj/screen/movable/spell_master/psy)
					continue
				else
					qdel(P)
					continue
			Powers += P
	if(Powers.len)
		for(var/i = 1 to power_points)
			for(var/spell in Powers)
				var/spell/P = spell
				to_chat(owner, "<span class='info'><b>[P.name]:</b> [P.desc] <b>(POWER LEVEL: [P.power_level])</b>.</span>")
			var/spell/P = input(owner,"Select a new psychic power to learn.") as anything in Powers
			if(P)
				owner.add_spell(P, master_type=/obj/screen/movable/spell_master/psy)
				Powers -= P
				power_points -= P.power_level
		for(var/spell/P in Powers)
			qdel(P)


/obj/item/organ/brain/slime
	name = "slime core"
	desc = "A complex, organic knot of jelly and crystalline particles."
	robotic = 2
	icon = 'icons/mob/slimes.dmi'
	icon_state = "green slime extract"
	can_lobotomize = 0

/obj/item/organ/brain/golem
	name = "chelm"
	desc = "A tightly furled roll of paper, covered with indecipherable runes."
	robotic = 2
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"
	can_lobotomize = 0
