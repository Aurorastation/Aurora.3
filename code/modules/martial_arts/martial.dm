/datum/martial_art
	var/name = "Martial Art"
	var/streak = ""
	var/max_streak_length = 6
	var/current_target = null
	var/datum/martial_art/base = null // The permanent style
	var/deflection_chance = 0 //Chance to deflect projectiles
	var/help_verb = null
	var/no_guns = FALSE	//set to TRUE to prevent users of this style from using guns
	var/no_guns_message = ""	//message to tell the style user if they try and use a gun while no_guns = TRUE (DISHONORABRU!)
	var/temporary = 0
	var/weapon_affinity	//if this martial art has any interaction with a weapon, also spawns said weapon when the manual is used
	var/parry_multiplier = 1	//if this martial art increases the chance of parrying with the weapon
	var/list/possible_weapons //if any weapon is spawned when you use the martial art manual

/datum/martial_art/proc/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/help_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/add_to_streak(var/element,var/mob/living/carbon/human/D)
	if(D != current_target)
		current_target = D
		streak = ""
	streak = streak+element
	if(length(streak) > max_streak_length)
		streak = copytext(streak,2)
	return

/datum/martial_art/proc/basic_hit(var/mob/living/carbon/human/A,var/mob/living/carbon/human/D)	//copy pasta of the regular unarmed attack, but can be replaced by something else
	var/rand_damage = rand(1, 5)
	var/block = 0
	var/accurate = 0
	var/hit_zone = A.zone_sel.selecting
	var/obj/item/organ/external/affecting = D.get_organ(hit_zone)

	if(!affecting || affecting.is_stump())
		to_chat(A, "<span class='danger'>They are missing that limb!</span>")
		return 1

	switch(D.a_intent)
		if(I_HELP)
			rand_damage = 5
			accurate = 1
		if(I_HURT, I_GRAB)
			if(D.canmove && D!=A && prob(20))
				block = 1

	if (D.grabbed_by.len)
		rand_damage = max(1, rand_damage - 2)

	if(D.grabbed_by.len || D.buckled || !D.canmove || D==A)
		accurate = 1
		rand_damage = 5

	var/miss_type = 0
	var/attack_message
	if(!accurate)
		if(prob(80))
			hit_zone = ran_zone(hit_zone)
		if(prob(15) && hit_zone != BP_CHEST) // Missed!
			if(!D.lying)
				attack_message = "[A] attempted to strike [D], but missed!"
			else
				attack_message = "[A] attempted to strike [D], but \he rolled out of the way!"
				D.set_dir(pick(cardinal))
			miss_type = 1

	if(!miss_type && block)
		attack_message = "[A] went for [D]'s [affecting.name] but was blocked!"
		miss_type = 2

			// See what attack they use
	var/datum/unarmed_attack/attack = A.get_unarmed_attack(src, hit_zone)
	if(!attack)
		return 0

	A.do_attack_animation(D)
	if(!attack_message)
		attack.show_attack(A, D, hit_zone, rand_damage)
	else
		D.visible_message("<span class='danger'>[attack_message]</span>")

	playsound(D.loc, ((miss_type) ? (miss_type == 1 ? attack.miss_sound : 'sound/weapons/thudswoosh.ogg') : attack.attack_sound), 25, 1, -1)
	A.attack_log += text("\[[time_stamp()]\] <font color='red'>[miss_type ? (miss_type == 1 ? "Missed" : "Blocked") : "[pick(attack.attack_verb)]"] [D.name] ([D.ckey])</font>")
	D.attack_log += text("\[[time_stamp()]\] <font color='orange'>[miss_type ? (miss_type == 1 ? "Was missed by" : "Has blocked") : "Has Been [pick(attack.attack_verb)]"] by [A.name] ([A.ckey])</font>")
	msg_admin_attack("[key_name(A)] [miss_type ? (miss_type == 1 ? "has missed" : "was blocked by") : "has [pick(attack.attack_verb)]"] [key_name(D)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[A.x];Y=[A.y];Z=[A.z]'>JMP</a>)",ckey=key_name(A),ckey_target=key_name(D))

	if(miss_type)
		return 0

	var/real_damage = rand_damage
	var/hit_dam_type = attack.damage_type
	var/is_sharp = 0
	var/is_edge = 0

	real_damage += attack.get_unarmed_damage(A)
	real_damage *= D.damage_multiplier
	rand_damage *= D.damage_multiplier

	if(HULK in A.mutations)
		real_damage *= 2 // Hulks do twice the damage
		rand_damage *= 2

	real_damage = max(1, real_damage)

	if(A.gloves)
		if(istype(A.gloves, /obj/item/clothing/gloves))
			var/obj/item/clothing/gloves/G = A.gloves
			real_damage += G.punch_force
			hit_dam_type = G.punch_damtype
			if(A.pulling_punches)
				hit_dam_type = PAIN

			if(G.sharp)
				is_sharp = 1

			if(G.edge)
				is_edge = 1

			if(istype(A.gloves,/obj/item/clothing/gloves/force))
				var/obj/item/clothing/gloves/force/X = A.gloves
				real_damage *= X.amplification

	if(attack.sharp)
		is_sharp = 1

	if(attack.edge)
		is_edge = 1

	var/armour = D.run_armor_check(hit_zone, "melee")

	attack.apply_effects(A, D, armour, rand_damage, hit_zone)

	D.apply_damage(real_damage, hit_dam_type, hit_zone, armour, sharp=is_sharp, edge=is_edge)

	return 1

/datum/martial_art/proc/teach(var/mob/living/carbon/human/H,var/make_temporary=0)
	if(help_verb)
		H.verbs += help_verb
	if(make_temporary)
		temporary = 1
	if(temporary)
		if(H.martial_art)
			base = H.martial_art.base
	else
		base = src
	H.martial_art = src

/datum/martial_art/proc/remove(var/mob/living/carbon/human/H)
	if(H.martial_art != src)
		return
	H.martial_art = base
	if(help_verb)
		H.verbs -= help_verb

/datum/martial_art/proc/TornadoAnimate(mob/living/carbon/human/A)
	set waitfor = FALSE
	for(var/i in list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH,NORTH,SOUTH,EAST,WEST,EAST,SOUTH))
		if(!A)
			break
		A.set_dir(i)
		playsound(A.loc, 'sound/weapons/punch1.ogg', 15, 1, -1)

/obj/item/martial_manual
	name = "SolCom manual"
	desc = "A manual designated to teach the user about the martial art of solarian combat, a style based on traditional human martial arts."
	icon = 'icons/obj/library.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_books.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_books.dmi'
		)
	icon_state ="cqcmanual"
	item_state ="book1"
	var/martial_art = /datum/martial_art/sol_combat

/obj/item/martial_manual/attack_self(mob/user as mob)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/datum/martial_art/F = new martial_art(null)
	F.teach(H)
	to_chat(H, "<span class='notice'>You have learned the martial art of [F.name].</span>")
	if(F.possible_weapons)
		var/weapon = pick(F.possible_weapons)
		var/obj/item/W = new weapon(get_turf(user))
		H.put_in_hands(W)
	qdel(src)