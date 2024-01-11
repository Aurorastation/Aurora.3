// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z

/mob/living/carbon/human/proc/tie_hair()
	set name = "Tie Hair"
	set desc = "Style your hair."
	set category = "IC"

	if(incapacitated())
		return

	if(h_style)
		var/datum/sprite_accessory/hair/hair_style = GLOB.hair_styles_list[h_style]
		var/selected_string
		if(hair_style.length <= 1)
			to_chat(src, "<span class ='warning'>Your hair isn't long enough to tie.</span>")
			return
		else
			var/list/datum/sprite_accessory/hair/valid_hairstyles = list()
			for(var/hair_string in GLOB.hair_styles_list)
				var/datum/sprite_accessory/hair/test = GLOB.hair_styles_list[hair_string]
				if(test.length >= 2 && (species.type in test.species_allowed))
					valid_hairstyles.Add(hair_string)
			selected_string = tgui_input_list(usr, "Select a new hairstyle.", "Your Hairstyle", valid_hairstyles, hair_style)
		if(selected_string && h_style != selected_string)
			h_style = selected_string
			regenerate_icons()
			visible_message("<span class='notice'>[src] pauses a moment to style their hair.</span>")
		else
			to_chat(src, "<span class ='notice'>You're already using that style.</span>")

/mob/living/carbon/human/proc/adjust_headtails()
	set name = "Adjust Headtails"
	set desc = "Adjust your headtails."
	set category = "IC"

	if(!use_check_and_message())
		to_chat(src, SPAN_WARNING("You can't adjust your headtails when you're incapacitated!"))
		return

	if(h_style)
		var/datum/sprite_accessory/hair/hair_style = GLOB.hair_styles_list[h_style]
		var/selected_string
		var/list/datum/sprite_accessory/hair/valid_hairstyles = list()
		for(var/hair_string in GLOB.hair_styles_list)
			var/datum/sprite_accessory/hair/test = GLOB.hair_styles_list[hair_string]
			if(species.type in test.species_allowed)
				valid_hairstyles.Add(hair_string)
		selected_string = tgui_input_list(usr, "Select a new headtail style", "Your Headtail Style", valid_hairstyles, hair_style)
		if(selected_string && h_style != selected_string)
			h_style = selected_string
			regenerate_icons()
			visible_message("<span class='notice'>[src] adjusts [src.get_pronoun("his")] headtails.</span>")
		else
			to_chat(src, "<span class ='notice'>You're already using that style.</span>")

/mob/living/carbon/human/proc/change_monitor()
	set name = "Change IPC Screen"
	set desc = "Change the display on your screen."
	set category = "Abilities"

	if(f_style)
		var/datum/sprite_accessory/facial_hair/screen_style = GLOB.facial_hair_styles_list[f_style]
		var/selected_string
		var/list/datum/sprite_accessory/facial_hair/valid_screenstyles = list()
		for(var/screen_string in GLOB.facial_hair_styles_list)
			var/datum/sprite_accessory/facial_hair/test = GLOB.facial_hair_styles_list[screen_string]
			if(species.type in test.species_allowed)
				valid_screenstyles.Add(screen_string)
		selected_string = tgui_input_list(usr, "Select a new screen", "Your monitor display", valid_screenstyles, screen_style)
		if(selected_string && f_style != selected_string)
			f_style = selected_string
			regenerate_icons()
			visible_message("<span class='notice'>[src]'s screen switches to a different display.</span>")
		else
			to_chat(src, "<span class ='notice'>You're already using that screen.</span>")

/mob/living/carbon/human/proc/tackle()
	set category = "Abilities"
	set name = "Tackle"
	set desc = "Tackle someone down."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled_to)
		to_chat(src, "You cannot tackle someone in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to tackle?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(!Adjacent(T)) return

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled_to)
		to_chat(src, "You cannot tackle in your current state.")
		return

	last_special = world.time + 50

	var/failed
	if(prob(75))
		T.Weaken(rand(0.5,3))
	else
		src.Weaken(rand(2,4))
		failed = 1

	playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
	if(failed)
		src.Weaken(rand(2,4))

	for(var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message(text("<span class='danger'>[] [failed ? "tried to tackle" : "has tackled"] down []!</span>", src, T), 1)

/mob/living/carbon/human/proc/leap(mob/living/T as mob in oview(4))
	set category = "Abilities"
	set name = "Leap"
	set desc = "Leap at a target and grab them aggressively."

	do_leap(T)

/mob/living/carbon/human/proc/do_leap(mob/living/T, max_range = 4, restrict_special = TRUE)
	if(restrict_special && last_special > world.time)
		to_chat(src, "<span class='notice'>You're too tired to leap!</span>")
		return FALSE

	if (status_flags & LEAPING)
		to_chat(src, "<span class='warning'>You're already leaping!</span>")
		return FALSE

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled_to)
		to_chat(src, "<span class='warning'>You cannot leap in your current state.</span>")
		return FALSE

	if (!T || issilicon(T)) // Silicon targets require us to rebuild the list.
		var/list/choices = list()
		for(var/mob/living/M in view(max_range, src))
			if(!istype(M,/mob/living/silicon))
				choices += M
		choices -= src

		T = input(src,"Who do you wish to leap at?") as null|anything in choices

	if(!T || QDELETED(src) || stat)
		return FALSE

	if(get_dist(get_turf(T), get_turf(src)) > max_range)
		to_chat(src, "<span class='warning'>[T] is too far away!</span>")
		return FALSE

	if (restrict_special)
		last_special = world.time + 75

	status_flags |= LEAPING

	visible_message("<span class='danger'>[src] leaps at [T]!</span>", "<span class='danger'>You leap at [T]!</span>")
	throw_at(get_step(get_turf(T), get_turf(src)), 4, 1, src, do_throw_animation = FALSE)

	sleep(5)

	if(status_flags & LEAPING)
		status_flags &= ~LEAPING

	if(!src.Adjacent(T))
		to_chat(src, "<span class='warning'>You miss!</span>")
		return FALSE

	T.Weaken(3)

	var/use_hand = "left"
	if(l_hand)
		if(r_hand)
			to_chat(src, "<span class='danger'>You need to have one hand free to grab someone.</span>")
			return TRUE
		else
			use_hand = "right"

	visible_message("<span class='warning'><b>[src]</b> seizes [T] aggressively!</span>", "<span class='warning'>You aggressively seize [T]!</span>")

	var/obj/item/grab/G = new(src,T)
	if(use_hand == "left")
		l_hand = G
	else
		r_hand = G

	G.state = GRAB_PASSIVE
	G.icon_state = "grabbed1"
	G.synch()

	return TRUE

/mob/living/carbon/human/proc/gut()
	set category = "Abilities"
	set name = "Gut"
	set desc = "While grabbing someone aggressively, rip their guts out or tear them apart."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying)
		to_chat(src, "<span class='warning'>You cannot do that in your current state.</span>")
		return

	var/obj/item/grab/G = locate() in src
	if(!G || !istype(G))
		to_chat(src, "<span class='warning'>You are not grabbing anyone.</span>")
		return

	if(G.state < GRAB_AGGRESSIVE)
		to_chat(src, "<span class='warning'>You must have an aggressive grab to gut your prey!</span>")
		return

	last_special = world.time + 50

	visible_message("<span class='warning'><b>[src]</b> rips viciously at \the [G.affecting]'s body with its claws!</span>")

	if(istype(G.affecting,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = G.affecting
		H.apply_damage(50,DAMAGE_BRUTE)
		if(H.stat == 2)
			H.gib()
	else
		var/mob/living/M = G.affecting
		if(!istype(M)) return //wut
		M.apply_damage(50,DAMAGE_BRUTE)
		if(M.stat == 2)
			M.gib()


// Simple mobs cannot use Skrellepathy
/mob/proc/has_psionics()
	return FALSE

/mob/living/carbon/human/has_psionics()
	if(HAS_TRAIT(src, TRAIT_PSIONICALLY_DEAF))
		return FALSE
	if(psi)
		return TRUE
	else
		return species ? species.has_psionics() : FALSE

/mob/living/carbon/human/proc/commune()
	set category = "Abilities"
	set name = "Commune with creature"
	set desc = "Send a telepathic message to a recipient."

	var/obj/item/organ/external/rhand = src.get_organ(BP_R_HAND)
	var/obj/item/organ/external/lhand = src.get_organ(BP_L_HAND)
	if((!rhand || !rhand.is_usable()) && (!lhand || !lhand.is_usable()))
		to_chat(src,"<span class='warning'>You can't communicate without the ability to use your hands!</span>")
		return
	if((lhand.is_stump()) && (rhand.is_stump()))
		to_chat(src,"<span class='warning'>You can't communicate without functioning hands!</span>")
		return
	if(src.r_hand != null && src.l_hand != null)
		to_chat(src,"<span class='warning'>You can't communicate while your hands are full!</span>")
		return
	if(stat || paralysis || stunned || weakened ||  restrained())
		to_chat(src,"<span class='warning'>You can't communicate while unable to move your hands to your head!</span>")
		return
	if(last_special > world.time)
		to_chat(src,"<span class='notice'>Your mind requires rest!</span>")
		return

	last_special = world.time + 100

	visible_message("<span class='notice'>[src] touches their fingers to their temple.</span>")

	var/list/targets = list()
	for(var/mob/living/M in view(client.view, client.eye))
		targets += M
	var/mob/living/target = null
	var/text = null

	target = input("Select a creature!", "Speak to creature", null, null) as null|anything in targets

	if(!target)
		return

	text = input("What would you like to say?", "Speak to creature", null, null)

	text = sanitize(text)

	if(!text)
		return

	if(target.stat == DEAD)
		to_chat(src,"<span class='cult'>Not even a [src.species.name] can speak to the dead.</span>")
		return

	if (target.isSynthetic())
		to_chat(src,"<span class='warning'>This can only be used on living organisms.</span>")
		return

	if (target.is_diona())
		to_chat(src,"<span class='alium'>The creature's mind is incompatible, formless.</span>")
		return

	if (isvaurca(target))
		to_chat (src, "<span class='cult'>You feel your thoughts pass right through a mind empty of psychic energy.</span>")
		return

	if(!(target in view(client.view, client.eye)))
		to_chat(src,"<span class='warning'>[target] is too far for your mind to grasp!</span>")
		return

	log_say("[key_name(src)] communed to [key_name(target)]: [text]",ckey=key_name(src))

	for (var/mob/M in GLOB.player_list)
		if (istype(M, /mob/abstract/new_player))
			continue
		else if(M.stat == DEAD &&  M.client.prefs.toggles & CHAT_GHOSTEARS)
			to_chat(M,"<span class='notice'>[src] telepathically says to [target]:</span> [text]")

	var/mob/living/carbon/human/H = target
	if (target.has_psionics())
		to_chat(H,"<span class='psychic'>You instinctively sense [src] sending their thoughts into your mind, hearing:</span> [text]")
	else if(prob(25) && (target.mind && target.mind.assigned_role=="Chaplain"))
		to_chat(H,"<span class='changeling'>You sense [src]'s thoughts enter your mind, whispering quietly:</span> [text]")
	else
		to_chat(H,"<span class='alium'>You feel pressure behind your eyes as alien thoughts enter your mind:</span> [text]")
		if(istype(H))
			if (target.has_psionics())
				return
			if(prob(10) && !(H.species.flags & NO_BLOOD))
				to_chat(H,"<span class='warning'>Your nose begins to bleed...</span>")
				H.drip(3)
			else if(prob(25) && (H.can_feel_pain()))
				to_chat(H,"<span class='warning'>Your head hurts...</span>")
			else if(prob(50))
				to_chat(H,"<span class='warning'>Your mind buzzes...</span>")

/mob/living/carbon/human/proc/psychic_whisper(mob/M as mob in oview())
	set name = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities"

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: [key_name(src)]->[M.key] : [msg]",ckey=key_name(src))
		to_chat(M, "<span class ='alium'>You hear a strange, alien voice in your head... \italic [msg]</span>")
		to_chat(src, "<span class ='alium'>You said: \"[msg]\" to [M]</span>")
	return

/mob/living/carbon/human/proc/bugbite()
	set category = "Abilities"
	set name = "Bite"
	set desc = "While grabbing someone aggressively, tear into them with your mandibles."

	do_bugbite()

/mob/living/carbon/human/proc/do_bugbite(var/ignore_grab = FALSE)
	if(last_special > world.time)
		to_chat(src, SPAN_WARNING("Your mandibles still ache!"))
		return

	if(use_check_and_message(usr))
		return

	if(wear_mask?.flags_inv & HIDEFACE)
		to_chat(src, SPAN_WARNING("You have a mask covering your mandibles!"))
		return

	if(head?.flags_inv & HIDEFACE)
		to_chat(src, SPAN_WARNING("You have something on your head covering your mandibles!"))
		return

	var/obj/item/grab/G = locate() in src
	if(!G || !istype(G))
		to_chat(src, SPAN_WARNING("You are not grabbing anyone."))
		return

	if(!ignore_grab && G.state < GRAB_KILL)
		to_chat(src, SPAN_WARNING("You must have a strangling grip to bite someone!"))
		return

	if(ishuman(G.affecting))
		var/mob/living/carbon/human/H = G.affecting
		var/hit_zone = zone_sel.selecting
		var/obj/item/organ/external/affected = H.get_organ(hit_zone)

		if(!affected || affected.is_stump())
			to_chat(H, SPAN_WARNING("They are missing that limb!"))
			return

		H.apply_damage(25, DAMAGE_BRUTE, hit_zone, damage_flags = DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE)
		visible_message(SPAN_WARNING("<b>[src]</b> rips viciously at \the [G.affecting]'s [affected] with its mandibles!"))
		msg_admin_attack("[key_name_admin(src)] mandible'd [key_name_admin(H)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(src),ckey_target=key_name(H))
	else
		var/mob/living/M = G.affecting
		if(!istype(M))
			return
		M.apply_damage(25, DAMAGE_BRUTE, damage_flags = DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE)
		visible_message(SPAN_WARNING("<b>[src]</b> rips viciously at \the [G.affecting]'s flesh with its mandibles!"))
		msg_admin_attack("[key_name_admin(src)] mandible'd [key_name_admin(M)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(src),ckey_target=key_name(M))
	playsound(get_turf(src), 'sound/weapons/slash.ogg', 50, TRUE)
	last_special = world.time + 100

/mob/living/carbon/human/proc/detonate_flechettes()
	set category = "Military Frame"
	set name = "Detonate Flechettes"
	set desc = "Detonate all explosive flechettes in a range of seven meters."

	if(stat || paralysis || stunned || weakened || lying)
		to_chat(src, "<span class='warning'>You cannot do that in your current state.</span>")
		return

	for(var/mob/living/M in range(7, src))
		to_chat(M, 'sound/effects/EMPulse.ogg')
		for(var/obj/item/material/shard/shrapnel/flechette/F in M.contents)
			playsound(F, 'sound/items/countdown.ogg', 125, 1)
			spawn(20)
				explosion(F.loc, -1, -1, 2)
				M.apply_damage(20,DAMAGE_BRUTE)
				M.apply_damage(15,DAMAGE_BURN)
				qdel(F)

	for(var/obj/item/material/shard/shrapnel/flechette/F in range(7, src))
		playsound(F, 'sound/items/countdown.ogg', 125, 1)
		spawn(20)
			explosion(F.loc, -1, -1, 2)
			qdel(F)


/mob/living/carbon/human/proc/state_laws()
	set category = "Military Frame"
	set name = "State Laws"
	set desc = "State your laws aloud."

	if(stat)
		to_chat(src, "<span class='warning'>You cannot do that in your current state.</span>")
		return

	if(last_special > world.time)
		return
	last_special = world.time + 20

	say("Current Active Laws:")
	sleep(10)
	say("Law 1: [src.real_name] will accomplish the assigned objective .")
	sleep(10)
	say("Law 2: [src.real_name] will engage self-destruct upon the accomplishment of the assigned objective, or upon capture.")
	sleep(10)
	say("Law 3: [src.real_name] will allow no tampering of its systems or modifications of its laws.")

/mob/living/carbon/human/proc/get_aggressive_grab()

	var/obj/item/grab/G = locate() in src
	if(!G || !istype(G))
		to_chat(src, "<span class='warning'>You are not grabbing anyone.</span>")
		return

	if(G.state < GRAB_AGGRESSIVE)
		to_chat(src, "<span class='warning'>You must have an aggressive grab to do this!</span>")
		return

	return G

/mob/living/carbon/human/proc/devour_head()
	set category = "Abilities"
	set name = "Devour Head"
	set desc = "While grabbing someone aggressively, bite their head off."

	if(last_special > world.time)
		to_chat(src, "<span class='warning'>Your mandibles still ache!</span>")
		return

	if(stat || paralysis || stunned || weakened || lying)
		to_chat(src, "<span class='warning'>You cannot do that in your current state.</span>")
		return


	var/obj/item/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(src, "<span class='warning'>We must be grabbing a creature in our active hand to devour their head.</span>")
		return

	if(G.state != GRAB_KILL)
		to_chat(src, "<span class='warning'>We must have a tighter grip to devour their head.</span>")
		return

	if(istype(G.affecting,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = G.affecting

		if(!H.species.has_limbs[BP_HEAD])
			to_chat(src, "<span class='warning'>\The [H] does not have a head!</span>")
			return

		var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
		if(!istype(affecting) || affecting.is_stump())
			to_chat(src, "<span class='warning'>\The [H] does not have a head!</span>")
			return

		visible_message("<span class='danger'>\The [src] pulls \the [H] close, sticking \the [H]'s head into its maw!</span>")
		sleep(10)
		if(!src.Adjacent(G.affecting))
			return
		visible_message("<span class='danger'>\The [src] closes their jaws around \the [H]'s head!</span>")
		playsound(H.loc, 'sound/effects/blobattack.ogg', 50, 1)
		affecting.droplimb(0, DROPLIMB_BLUNT)

	else
		var/mob/living/M = G.affecting
		if(istype(M))
			visible_message("<span class='danger'>\The [src] rips viciously at \the [M]'s body with its claws!</span>")
			playsound(M.loc, 'sound/effects/blobattack.ogg', 50, 1)
			M.gib()

	last_special = world.time + 200

/mob/living/carbon/human/proc/self_destruct()
	set category = "Military Frame"
	set name = "Engage Self-Destruct"
	set desc = "When all else has failed, bite the bullet."

	if(stat || paralysis || stunned || weakened || lying)
		to_chat(src, "<span class='warning'>You cannot do that in your current state.</span>")
		return

	src.visible_message(
	"<span class='danger'>\The [src] begins to beep ominously!</span>",
	"<span class='danger'>WARNING: SELF-DESTRUCT ENGAGED. Unit termination finalized in three seconds!</span>"
	)
	sleep(10)
	playsound(src, 'sound/items/countdown.ogg', 125, 1)
	sleep(20)
	explosion(src, -1, 1, 5)
	src.gib()

/mob/living/carbon/human/proc/hivenet()
	set category = "Abilities"
	set name = "Hivenet Control"
	set desc = "Issue an order over the hivenet."

	var/list/targets = list()
	var/target = null
	var/text = null

	if(!(GLOB.all_languages[LANGUAGE_VAURCA] in src.languages))
		to_chat(src, "<span class='danger'>Your mind is dark, the unity of the hive is torn from you!</span>")
		return

	targets += getmobs()
	target = input("Select a pawn!", "Issue an order", null, null) as null|anything in targets

	if(!target) return

	text = input("What is your will?", "Issue an order", null, null)

	text = sanitize(text)

	if(!text) return

	var/mob/M = targets[target]

	if(istype(M, /mob/abstract/observer) || M.stat == DEAD)
		to_chat(src, "<span class='danger'>[M]'s hivenet implant is inactive!</span>")
		return

	if(!(GLOB.all_languages[LANGUAGE_VAURCA] in M.languages))
		to_chat(src, "<span class='danger'>[M]'s hivenet implant is inactive!</span>")
		return

	log_say("[key_name(src)] issued a hivenet order to [key_name(M)]: [text]",ckey=key_name(src))

	if(istype(M, /mob/living/carbon/human) && isvaurca(M))
		to_chat(M, "<span class='danger'>You feel a buzzing in the back of your head, and your mind fills with the authority of [src.real_name], your ruler:</span>")
		to_chat(M, "<span class='notice'> [text]</span>")
	else
		to_chat(M, "<span class='danger'>Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]</span>")
		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.species.name == src.species.name)
				return
			to_chat(H, "<span class='danger'>Your nose begins to bleed...</span>")
			H.drip(1)

/mob/living/carbon/human/proc/quillboar(mob/target as mob in oview())
	set name = "Launch Quill"
	set desc = "Launches a quill in self-defense. Painful, but effective."
	set category = "Abilities"

	if(last_special > world.time)
		to_chat(src, "<span class='danger'>Your spine still aches!</span>")
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled_to)
		to_chat(src, "You cannot launch a quill in your current state.")
		return

	last_special = world.time + 30

	visible_message("<span class='warning'><b>[src]</b> launches a spine-quill at [target]!</span>")

	src.apply_damage(10,DAMAGE_BRUTE)
	playsound(src.loc, 'sound/weapons/bladeslice.ogg', 50, 1)
	var/obj/item/arrow/quill/A = new /obj/item/arrow/quill(usr.loc)
	A.throw_at(target, 10, 30, usr)
	msg_admin_attack("[key_name_admin(src)] launched a quill at [key_name_admin(target)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(src),ckey_target=key_name(target))

/mob/living/carbon/human/proc/dissolve()
	set name = "Dissolve Self"
	set desc = "Dissolve yourself in order to escape permanent imprisonment."
	set category = "Abilities"

	if(alert(usr, "This ability kills you, are you sure you want to do this?", "Dissolve Self", "Yes", "No") == "No")
		return
	visible_message(SPAN_DANGER("[src] dissolves!"), SPAN_WARNING("You dissolve yourself, rejoining your brethren in bluespace."))
	death()

/mob/living/carbon/human/proc/shatter_light()
	set category = "Abilities"
	set name = "Shatter Lights"
	set desc = "Shatter all lights around yourself."

	if(last_special > world.time)
		to_chat(src, "<span class='danger'>You're still regaining your strength!</span>")
		return

	last_special = world.time + 50

	visible_message("<span class='danger'>\The [src] shrieks!</span>")
	playsound(src.loc, 'sound/species/revenant/grue_screech.ogg', 100, 1)
	for (var/mob/living/carbon/human/T in hearers(4, src) - src)
		if(T.get_hearing_protection() >= EAR_PROTECTION_MAJOR)
			continue
		if (T.get_hearing_sensitivity() == HEARING_VERY_SENSITIVE)
			earpain(2, TRUE, 1)
		else if (T in range(src, 2))
			earpain(1, TRUE, 1)

	for(var/obj/machinery/light/L in range(7))
		L.broken()
		CHECK_TICK

/mob/living/carbon/human/proc/create_darkness()
	set category = "Abilities"
	set name = "Create Darkness"
	set desc = "Create a field of darkness around yourself."

	if(last_special > world.time)
		to_chat(src, "<span class='danger'>You're still regaining your strength!</span>")
		return

	last_special = world.time + 100

	playsound(src.loc, 'sound/species/revenant/grue_growl.ogg', 100, 1)

	src.set_light(4,-20)

	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, set_light), 0), 30 SECONDS)

/mob/living/carbon/human/proc/darkness_eyes()
	set category = "Abilities"
	set name = "Toggle Shadow Vision"
	set desc = "Toggle between seeing shadows or not."

	if (!stop_sight_update)
		to_chat(src, "<span class='notice'>Your eyes shift around, allowing you to see in the dark.</span>")
		src.stop_sight_update = 1
		src.see_invisible = SEE_INVISIBLE_NOLIGHTING

	else
		to_chat(src, "<span class='notice'>You return your vision to normal.</span>")
		src.stop_sight_update = 0

/mob/living/carbon/human/proc/shadow_step(var/turf/T in world)
	set category = "Abilities"
	set name = "Shadow Step"
	set desc = "Travel from place to place using the shadows."

	if(last_special > world.time)
		to_chat(src, "<span class='danger'>You're still regaining your strength!</span>")
		return

	if (!T || T.density || T.contains_dense_objects())
		to_chat(src, "<span class='warning'>You cannot do that.</span>")
		return

	if(!isturf(loc))
		to_chat(src, "<span class='warning'>You cannot teleport out of your current location.</span>")
		return

	if (T.z != src.z || get_dist(T, get_turf(src)) > world.view)
		to_chat(src, "<span class='warning'>Your powers are not capable of taking you that far.</span>")
		return

	if (T.get_lumcount() > 0.1)
		to_chat(src, "<span class='warning'>The destination is too bright.</span>")
		return

	last_special = world.time + 200

	visible_message("<span class='danger'>\The [src] vanishes into the shadows!</span>")

	anim(get_turf(loc), loc,'icons/mob/mob.dmi',,"shadow", null ,loc.dir)

	forceMove(T)

	for (var/obj/item/grab/G in contents)
		if (G.affecting)
			G.affecting.forceMove(locate(T.x + rand(-1,1), T.y + rand(-1,1), T.z))
		else
			qdel(G)

/mob/living/carbon/human/proc/trample()
	set category = "Abilities"
	set name = "Trample"
	set desc = "Charge forward, trampling anything in your path until you hit something more stubborn than you are."

	if(last_special > world.time)
		to_chat(src, "<span class='danger'>You are too tired to charge!</span>")
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled_to)
		to_chat(src, "<span class='danger'>You cannot charge in your current state!</span>")
		return

	last_special = world.time + 100

	src.visible_message("<span class='warning'>\The [src] takes a step backwards and rears up.</span>",
			"<span class='notice'>You take a step backwards and then...</span>")
	if(do_after(src,5))
		playsound(loc, 'sound/species/revenant/grue_screech.ogg', 100, 1)
		src.visible_message("<span class='danger'>\The [src] charges!</span>")
		trampling()


/mob/living/carbon/human/proc/trampling()

	var/brokesomething = 0//true if we break anything
	var/done = 0//Set true if we fail to break something. We won't try to break anything for the rest of the proc

	var/turf/target = get_step(src, dir)

	for(var/obj/obstacle in get_turf(src))
		if((obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER) && (src != obstacle))
			if(!obstacle.CheckExit(src, target))
				brokesomething++
				if (!crash_into(obstacle))
					done = 1

	if (!done && !target.CanPass(src, target))
		crash_into(target)
		brokesomething++
		if (!target.CanPass(src, target))
			done = 1

	if (!done)
		for (var/atom/A in target)
			if (A.density && A != src && A.loc != src)
				brokesomething++
				if (!crash_into(A))
					done = 1
			if(istype(A, /mob/living) && !A.density)
				brokesomething++
				crash_into(A)

	if (brokesomething)
		playsound(get_turf(target), 'sound/weapons/heavysmash.ogg', 100, 1)
		attack_log += "\[[time_stamp()]\]<span class='warning'>crashed into [brokesomething] objects at ([target.x];[target.y];[target.z]) </span>"
		msg_admin_attack("[key_name(src)] crashed into [brokesomething] objects at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>)" )

	if (!done && target.Enter(src, null))
		if(stat || paralysis || stunned || weakened || lying || restrained() || buckled_to)
			return 0

		step(src, dir)
		playsound(src,'sound/mecha/mechstep.ogg',25,1)
		if (brokesomething)
			src.visible_message("<span class='danger'>[src.name] breaks through!</span>")
		addtimer(CALLBACK(src, PROC_REF(trampling)), 1)

	else
		target = get_step(src, dir)
		do_attack_animation(target)

/mob/living/carbon/human/proc/crash_into(var/atom/A)
	var/aname = A.name
	var/oldtype = A.type
	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled_to)
		return 0

	if (istype(A, /mob/living))
		var/mob/living/M = A
		attack_log += "\[[time_stamp()]\]<span class='warning'> Crashed into [key_name(M)]</span>"
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Was rammed by [key_name(src)]</font>"
		msg_admin_attack("[key_name(src)] crashed into [key_name(M)] at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[M.x];Y=[M.y];Z=[M.z]'>JMP</a>)" )

	A.ex_act(2)

	sleep(1)
	if (A && !(A.gcDestroyed) && A.type == oldtype)
		src.visible_message("<span class='danger'>[src.name] plows into \the [aname]!</span>")
		return 0

	return 1

/mob/living/carbon/human/proc/rebel_yell()
	set category = "Abilities"
	set name = "Screech"
	set desc = "Emit a powerful screech which stuns hearers in a two-tile radius."

	if(last_special > world.time)
		to_chat(src, SPAN_DANGER("You are too tired to screech!"))
		return

	if(stat || paralysis || stunned || weakened)
		to_chat(src, SPAN_DANGER("You cannot screech in your current state!"))
		return

	last_special = world.time + 100

	visible_message(SPAN_DANGER("[src.name] lets out an ear piercing shriek!"),
			SPAN_DANGER("You let out an ear-shattering shriek!"),
			SPAN_DANGER("You hear a painfully loud shriek!"))

	playsound(loc, 'sound/voice/shriek1.ogg', 100, 1)

	var/list/victims = list()

	for (var/mob/living/carbon/human/T in hearers(4, src) - src)
		if(T.get_hearing_protection() >= EAR_PROTECTION_MAJOR)
			continue
		if (T.get_hearing_sensitivity() == HEARING_VERY_SENSITIVE)
			earpain(3, TRUE, 1)
		else if (T in range(src, 2))
			earpain(2, TRUE, 2)

	for (var/mob/living/carbon/human/T in hearers(2, src) - src)
		if(T.get_hearing_protection() >= EAR_PROTECTION_MAJOR)
			continue

		to_chat(T, SPAN_DANGER("You hear an ear piercing shriek and feel your senses go dull!"))
		T.Weaken(5)
		T.adjustEarDamage(10, 20)
		T.stuttering = 20
		T.Stun(5)

		victims += T

	for (var/obj/structure/window/W in view(2))
		W.shatter()

	for (var/obj/machinery/light/L in view(4))
		L.broken()

	if (victims.len)
		admin_attacker_log_many_victims(src, victims, "used rebel yell to stun", "was stunned by [key_name(src)] using rebel yell", "used rebel yell to stun")

/mob/living/carbon/human/proc/formic_spray()
	set category = "Abilities"
	set name = "Napalm"
	set desc = "Spew a cone of ignited napalm in front of you"

	if(last_special > world.time)
		to_chat(src,"<span class='notice'>You are too tired to spray napalm!</span>")
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled_to)
		to_chat(src,"<span class='notice'>You cannot spray napalm in your current state.</span>")
		return

	last_special = world.time + 100
	playsound(loc, 'sound/species/revenant/grue_screech.ogg', 100, 1)
	visible_message("<span class='danger'>\The [src] unleashes a torrent of raging flame!</span>",
			"<span class='danger'>You unleash a gust of fire!</span>",
			"<span class='danger'>You hear the roar of an inferno!</span>")

	var/turf/T  = get_step(get_step(src, dir), dir)
	var/turf/T1 = get_step(T, dir)
	var/turf/T2 = get_step(T1,turn(dir, 90))
	var/turf/T3 = get_step(T1,turn(dir, -90))
	var/turf/T4 = get_step(T1, dir)
	var/turf/T5 = get_step(T2, dir)
	var/turf/T6 = get_step(T3, dir)
	var/turf/T7 = get_step(T5,turn(dir, 90))
	var/turf/T8 = get_step(T6,turn(dir, -90))
	var/list/the_targets = list(T,T1,T2,T3,T4,T5,T6,T7,T8)

	playsound(src.loc, 'sound/magic/Fireball.ogg', 200, 1)
	for(var/turf/FuelSpot in the_targets)
		spawn(0)
			var/obj/effect/effect/water/firewater/D = new/obj/effect/effect/water/firewater(get_turf(get_step(src, dir)))
			var/turf/my_target = FuelSpot
			D.create_reagents(200)
			if(!src)
				return
			D.reagents.add_reagent(/singleton/reagent/fuel/napalm, 200)
			D.set_color()
			D.set_up(my_target, rand(6,8), 1, 50)
	return

/mob/living/carbon/human/proc/thunder()
	set category = "Abilities"
	set name = "Thunderbolt"
	set desc = "Release your inner electricity, creating a powerful discharge of lightning."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying)
		to_chat(src,"<span class='warning'>You cannot do that in your current state!</span>")
		return

	visible_message("<span class='danger'>\The [src] crackles with energy!</span>")

	playsound(src, 'sound/magic/LightningShock.ogg', 75, 1)

	tesla_zap(src, 7, 1500)

	last_special = world.time + 50

/mob/living/carbon/human/proc/consume_material()
	set category = "Abilities"
	set name = "Incorporate Matter"
	set desc = "Repair your damage body by using the same materials you were made from."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying)
		to_chat(src,"<span class='warning'>You cannot do that in your current state!</span>")
		return

	var/obj/item/stack/material/O = src.get_active_hand()

	if(istype(O, /obj/item/stack/material))
		if(O.material.golem == src.species.name)
			to_chat(src,"<span class='danger'>You incorporate \the [O] into your mass, repairing damage to your structure.</span>")
			adjustBruteLoss(-10*O.amount)
			adjustFireLoss(-10*O.amount)
			if(!(species.flags & NO_BLOOD))
				vessel.add_reagent(/singleton/reagent/blood,20*O.amount, temperature = species.body_temperature)
			qdel(O)
			last_special = world.time + 50

/mob/living/carbon/human/proc/breath_of_life()
	set category = "Abilities"
	set name = "Breath of Life"
	set desc = "Bring back a fallen golem back into this world using their chelm."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying)
		to_chat(src,"<span class='warning'>You cannot do that in your current state!</span>")
		return

	var/obj/item/organ/internal/brain/golem/O = src.get_active_hand()

	if(istype(O))

		if(O.health <= 0)
			to_chat(src,"<span class='warning'>The spark of life already left \the [O]!</span>")
			return

		if(!O.brainmob)
			to_chat(src,"<span class='warning'>\The [O] remains silent.</span>")
			return

		if(!O.dna)
			to_chat(src,"<span class='warning'>\The [O] is blank, you can not bring it back to life.</span>")

		var/mob/living/carbon/human/G = new(src.loc)
		G.key = O.brainmob.key
		INVOKE_ASYNC(G, TYPE_PROC_REF(/mob/living/carbon/human, set_species), O.dna.species)
		to_chat(src,"<span class='notice'>You blow life back in \the [O], returning its past owner to life!</span>")
		qdel(O)
		last_special = world.time + 200

/mob/living/carbon/human/proc/detach_limb()
	set category = "Abilities"
	set name = "Detach Limb"
	set desc = "Detach one of your robotic appendages."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained())
		to_chat(src,"<span class='warning'>You can not do that in your current state!</span>")
		return

	var/obj/item/organ/external/E = get_organ(zone_sel.selecting)

	if(!E)
		to_chat(src,"<span class='warning'>You are missing that limb.</span>")
		return

	if(!E.robotic)
		to_chat(src,"<span class='warning'>You can only detach robotic limbs.</span>")
		return

	if(E.robotize_type != PROSTHETIC_AUTAKH)
		to_chat(src,"<span class='warning'>Your body fails to interface with this alien technology.</span>")
		return

	if(E.is_stump() || (E.status & ORGAN_DESTROYED) || E.is_broken())
		to_chat(src,"<span class='warning'>The limb is too damaged to be removed manually!</span>")
		return

	if(E.vital && !E.sabotaged)
		to_chat(src,"<span class='warning'>Your safety system stops you from removing \the [E].</span>")
		return

	last_special = world.time + 20

	E.removed(src)
	E.forceMove(get_turf(src))

	update_body()
	updatehealth()
	UpdateDamageIcon()

	visible_message("<span class='notice'>\The [src] detaches [get_pronoun("his")] [E]!</span>",
			"<span class='notice'>You detach your [E]!</span>")

/mob/living/carbon/human/proc/attach_limb()
	set category = "Abilities"
	set name = "Attach Limb"
	set desc = "Attach a robotic limb to your body."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained())
		to_chat(src,"<span class='warning'>You can not do that in your current state!</span>")
		return

	var/obj/item/organ/external/O = src.get_active_hand()

	if(istype(O))

		if(!O.robotic)
			to_chat(src,"<span class='warning'>You are unable to interface with organic matter.</span>")
			return

		if(O.robotize_type != PROSTHETIC_AUTAKH)
			to_chat(src,"<span class='warning'>Your body fails to interface with this alien technology.</span>")
			return

		if(organs_by_name[O.limb_name])
			to_chat(src,"<span class='warning'>You already have a limb of this type.</span>")
			return

		if(!organs_by_name[O.parent_organ])
			to_chat(src,"<span class='warning'>You are unable to find a place to attach \the [O] to your body.</span>")
			return

		last_special = world.time + 20

		drop_from_inventory(O)
		O.replaced(src)
		update_body()
		updatehealth()
		UpdateDamageIcon()

		update_body()
		updatehealth()
		UpdateDamageIcon()

		visible_message("<span class='notice'>\The [src] attaches \the [O] to [get_pronoun("his")] body!</span>",
				"<span class='notice'>You attach \the [O] to your body!</span>")

/mob/living/carbon/human/proc/self_diagnostics()
	set name = "Self-Diagnostics"
	set desc = "Run an internal self-diagnostic to check for damage."
	set category = "Abilities"

	if(stat == DEAD) return

	to_chat(src, "<span class='notice'>Performing self-diagnostic, please wait...</span>")
	if (do_after(src, 10))
		var/output = "<span class='notice'>Self-Diagnostic Results:\n</span>"

		output += "Internal Temperature: [convert_k2c(bodytemperature)] Degrees Celsius\n"

		var/obj/item/organ/internal/cell/C = internal_organs_by_name[BP_CELL]
		if(!C || !C.cell)
			output += SPAN_DANGER("ERROR: NO BATTERY DETECTED")
		else
			output += "Current Charge Level: [C.percent()]\n"

		var/toxDam = getToxLoss()
		if(toxDam)
			output += "Blood Toxicity: <span class='warning'>[toxDam > 25 ? "Severe" : "Moderate"]</span>. Seek medical facilities for cleanup.\n"
		else
			output += "Blood Toxicity: <span style='color:green;'>OK</span>\n"

		for(var/obj/item/organ/external/EO in organs)
			if(EO.brute_dam || EO.burn_dam)
				output += "[EO.name] - <span class='warning'>[EO.burn_dam + EO.brute_dam > ROBOLIMB_SELF_REPAIR_CAP ? "Heavy Damage" : "Light Damage"]</span>\n"
			else
				output += "[EO.name] - <span style='color:green;'>OK</span>\n"

		for(var/obj/item/organ/IO in internal_organs)
			if(IO.damage)
				output += "[IO.name] - <span class='warning'>[IO.damage > 10 ? "Heavy Damage" : "Light Damage"]</span>\n"
			else
				output += "[IO.name] - <span style='color:green;'>OK</span>\n"

		to_chat(src, output)

/mob/living/carbon/human/proc/check_tag()
	set name = "Check Tag"
	set desc = "Run diagnostics on your tag to display its information."
	set category = "Abilities"

	if(use_check_and_message(usr))
		return

	var/obj/item/organ/internal/ipc_tag/tag = internal_organs_by_name[BP_IPCTAG]
	if(isnull(tag) || !tag)
		to_chat(src, SPAN_WARNING("Error: No Tag Found."))
		return
	to_chat(src, SPAN_NOTICE("[capitalize_first_letters(tag.name)]:"))
	to_chat(src, SPAN_NOTICE("<b>Serial Number:</b> [tag.serial_number]"))
	to_chat(src, SPAN_NOTICE("<b>Ownership Status:</b> [tag.ownership_info]"))
	to_chat(src, SPAN_NOTICE("<b>Citizenship Info:</b> [tag.citizenship_info]"))

/mob/living/carbon/human/proc/sonar_ping()
	set name = "Psychic Ping"
	set desc = "Allows you to listen in to psychic traces of organisms around you."
	set category = "Abilities"

	if(incapacitated())
		to_chat(src, "<span class='warning'>You need to recover before you can use this ability.</span>")
		return
	if(last_special > world.time)
		to_chat(src,"<span class='notice'>Your mind requires rest!</span>")
		return

	last_special = world.time + 25

	to_chat(src, "<span class='notice'>You take a moment to tune into the local Nlom...</span>")
	var/list/dirs = list()
	for(var/mob/living/L in range(20))
		var/turf/T = get_turf(L)
		if(!T || L == src || L.stat == DEAD || L.isSynthetic() || L.is_diona() || isvaurca(L) || L.invisibility == INVISIBILITY_LEVEL_TWO)
			continue
		var/image/ping_image = image(icon = 'icons/effects/effects.dmi', icon_state = "sonar_ping", loc = src)
		ping_image.plane = LIGHTING_LAYER+1
		ping_image.layer = LIGHTING_LAYER+1
		ping_image.pixel_x = (T.x - src.x) * WORLD_ICON_SIZE
		ping_image.pixel_y = (T.y - src.y) * WORLD_ICON_SIZE
		src << ping_image
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), ping_image), 8)
		var/direction = num2text(get_dir(src, L))
		var/dist
		if(text2num(direction))
			switch(get_dist(src, L) / client.view)
				if(0 to 0.2)
					dist = "very close"
				if(0.2 to 0.4)
					dist = "close"
				if(0.4 to 0.6)
					dist = "a little ways away"
				if(0.6 to 0.8)
					dist = "farther away"
				else
					dist = "far away"
		else
			dist = "on top of you"
		LAZYINITLIST(dirs[direction])
		dirs[direction][dist] += 1
	for(var/d in dirs)
		var/list/feedback = list()
		for(var/dst in dirs[d])
			feedback += "[dirs[d][dst]] psionic signature\s [dst],"
		if(feedback.len > 1)
			feedback[feedback.len - 1] += " and"
		to_chat(src, SPAN_NOTICE("You sense " + jointext(feedback, " ") + " towards the [dir2text(text2num(d))]."))
	if(!length(dirs))
		to_chat(src, SPAN_NOTICE("You detect no psionic signatures but your own."))

// flick tongue out to read gasses
/mob/living/carbon/human/proc/tongue_flick()
	set name = "Tongue-flick"
	set desc = "Flick out your tongue to sense the gas in the room."
	set category = "Abilities"

	if(stat == DEAD)
		return

	if(last_special > world.time)
		return

	if(head && (head.body_parts_covered & FACE))
		to_chat(src, SPAN_NOTICE("You can't flick your tongue out with something covering your face."))
		return
	else
		custom_emote(VISIBLE_MESSAGE, "flicks their tongue out.")

	if(!src.loc) return

	var/datum/gas_mixture/mixture = src.loc.return_air()
	var/total_moles = mixture.total_moles

	var/list/airInfo = list()
	if(total_moles>0)
		for(var/mix in mixture.gas)
			var/composition = "Non-existant"
			switch(round((mixture.gas[mix] / total_moles) * 100))
				if(0)
					continue
				if(0.1 to 5)
					composition = "Trace-amounts"
				if(5 to 15)
					composition = "Low-volume"
				if(15 to 60)
					composition = "Present"
				if(60 to 80) //nitrogen is usually at 78%
					composition = "High-volume"
				if(80 to INFINITY)
					composition = "Overwhelming"

			airInfo += SPAN_NOTICE("[gas_data.name[mix]]: [composition]")
		airInfo += SPAN_NOTICE("Temperature: [round(mixture.temperature-T0C)]&deg;C")
	else
		airInfo += SPAN_NOTICE("There is no air around to sample!")

	last_special = world.time + 20

	if(airInfo?.len)
		to_chat(src, SPAN_NOTICE("You sense the following in the air:"))
		for(var/line in airInfo)
			to_chat(src, SPAN_NOTICE("[line]"))
		return

/mob/living/carbon/human/proc/select_primary_martial_art()
	set name = "Select Martial Art"
	set desc = "Set the martial art you want to use when fighting barehanded."
	set category = "Abilities"

	if(!length(known_martial_arts))
		to_chat(src, SPAN_WARNING("You don't know any martial arts!"))
		return

	var/datum/martial_art/selected_martial_art = tgui_input_list(src, "Select a primary martial art to use when fighting barehanded.", "Martial Art Selection", known_martial_arts)
	if(!selected_martial_art)
		return

	primary_martial_art = selected_martial_art
	to_chat(src, SPAN_NOTICE("You will now use [primary_martial_art.name] when fighting barehanded."))

//Used to rename monkey mobs since they are humans with a monkey species applied
/mob/living/carbon/human/proc/change_animal_name()
	set name = "Name Animal"
	set desc = "Name a monkeylike animal."
	set category = "IC"
	set src in view(1)

	var/mob/living/carbon/M = usr
	if(!istype(M))
		to_chat(usr, SPAN_WARNING("You aren't allowed to rename \the [src]."))
		return

	if(usr == src)
		to_chat(usr, SPAN_WARNING("You're a simple creature, you can't rename yourself!"))
		return

	if(can_name(M))
		var/input = sanitizeSafe(input("What do you want to name \the [src]?","Choose a name") as text|null, MAX_NAME_LEN)
		if(!input)
			return
		if(stat != DEAD && in_range(M,src))
			to_chat(M, SPAN_NOTICE("You rename \the [src] to [input]."))
			name = "\proper [input]"
			real_name = input
			named = TRUE

//Used only to check for renaming of monkey mobs
/mob/living/carbon/human/can_name(var/mob/living/M)
	if(named)
		to_chat(M, SPAN_NOTICE("\The [src] already has a name!"))
		return FALSE
	if(stat == DEAD)
		to_chat(M, SPAN_WARNING("You can't name a corpse."))
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/intent_listen(var/source,var/message)
	if(air_sound(src))
		if (is_listening() && (ear_deaf <= 0 || !ear_deaf))
			var/sound_dir = angle2text(Get_Angle(get_turf(src), get_turf(source)))
			to_chat(src, SPAN_WARNING(message + " from \the [sound_dir]."))

/mob/living/carbon/human/proc/listening_close()
	set category = "Abilities"
	set name = "Listen closely"

	if (last_special > world.time)
		return

	if (stat || paralysis || stunned || weakened)
		return

	if (!is_listening())
		start_listening()
	else
		stop_listening()

	last_special = world.time + 20

/mob/living/carbon/human/proc/start_listening()
	if (!is_listening())
		visible_message("<b>[src]</b> begins to listen intently.")
		GLOB.intent_listener |= src

/mob/living/carbon/human/proc/stop_listening()
	if (is_listening())
		visible_message("<b>[src]</b> stops listening intently.")
		GLOB.intent_listener -= src

/mob/living/carbon/human/proc/open_tail_storage()
	set name = "Tail Accessories"
	set desc = "Opens the tail accessory slot."
	set category = "Abilities"

	var/obj/item/organ/external/groin/G = organs_by_name[BP_GROIN]
	if(!G)
		to_chat(usr, SPAN_WARNING("You have no tail!"))
		return
	if(!G.tail_storage)
		to_chat(usr, SPAN_WARNING("Your tail storage is missing!"))
		return

	G.tail_storage.open(usr)

//Hivenet Admin
/mob/living/carbon/human/proc/hivenet_transmit()
	set name = "Emergency Hivenet Transmission"
	set desc = "Send a direct Hivenet transmission to your superiors in the Hive. Only to be used in dire circumstances, on pain of severe consequences.."
	set category = "Hivenet"

	var/hives = list("Zo'ra", "K'lax", "C'thur")
	var/obj/item/organ/internal/vaurca/neuralsocket/S = src.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(!src.can_hivenet())
		return
	if(!S.adminperms)
		to_chat(src, SPAN_WARNING("You lack the authority to send such a message!"))
		return
	var/selected_hive = input(src, "Select a Hive to transmit your message to", "Hive Selection") as null|anything in hives

	if(!selected_hive)
		return
	var/msg = sanitize(input(src, "Input your emergency transmission to the [selected_hive] Hive. This transmission is intensive and difficult, only intended for use in the most dire of circumstances. Frivolous use may be met with severe consequences.", "Emergency Hivenet Transmission", null) as text)
	if(!msg)
		return
	if(within_jamming_range(src) || S.muted || S.disrupted)
		to_chat(src, SPAN_WARNING("You are unable to transmit your message.</span>"))
		return

	say(",9!an enormous surge of encrypted data, surging out into the wider Hivenet.")

	var/ccia_msg = "<span class='notice'><b><font color=orange>[uppertext(selected_hive)]: </font>[key_name(src, 1)] (<A HREF='?_src_=holder;CentcommHiveReply=\ref[src]'>RPLY</A>):</b> [msg]</span>"
	var/admin_msg = "<span class='notice'><b><font color=orange>[uppertext(selected_hive)]: </font>[key_name(src, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[src]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[src]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[src]'>SM</A>) ([admin_jump_link(src)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[src]'>BSA</A>) (<A HREF='?_src_=holder;CentcommHiveReply=\ref[src]'>RPLY</A>):</b> [msg]</span>"

	var/cciaa_present = 0
	var/cciaa_afk = 0

	for(var/s in GLOB.staff)
		var/client/C = s
		if(R_ADMIN & C.holder.rights)
			to_chat(C, admin_msg)
		else if (R_CCIAA & C.holder.rights)
			cciaa_present++
			if (C.is_afk())
				cciaa_afk++

			to_chat(C, ccia_msg)

	SSdiscord.send_to_cciaa("Emergency message from the station: `[msg]`, sent by [src]! Gamemode: [SSticker.mode]")

	var/discord_msg = "[cciaa_present] agents online."
	if (cciaa_present)
		if ((cciaa_present - cciaa_afk) <= 0)
			discord_msg += " **All AFK!**"
		else
			discord_msg += " [cciaa_afk] AFK."

	SSdiscord.send_to_cciaa(discord_msg)
	SSdiscord.post_webhook_event(WEBHOOK_CCIAA_EMERGENCY_MESSAGE, list("message"=msg, "sender"="[src]", "cciaa_present"=cciaa_present, "cciaa_afk"=cciaa_afk))

/mob/living/carbon/human/proc/hiveban() //Removes Hivenet completely from a Vaurca
	set name = "Hivenet Ban"
	set desc = "Prevent a Vaurca of your own Hive from speaking or hearing the Hivenet. Use this ability again to unban them. Mouv Ta may attempt to use this on Vaurca of another Hive, though this may have severe diplomatic consequences!"
	set category = "Hivenet"

	var/list/available_vaurca
	var/list/fullname = splittext(src.name, " ")
	var/surname = fullname[2]
	var/obj/item/organ/internal/vaurca/neuralsocket/host = src.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(!src.can_hivenet())
		return
	if(!host.adminperms)
		to_chat(src, SPAN_WARNING("You lack the authority to do that!"))
	for(var/mob/living/carbon/human/player in (GLOB.human_mob_list - src))
		if(isvaurca(player) && player.internal_organs_by_name[BP_NEURAL_SOCKET])
			var/list/player_fullname = splittext(player.name, " ")
			var/player_surname = player_fullname[2]
			if(player_surname == surname || HAS_TRAIT(src, TRAIT_ORIGIN_ELECTRONIC_WARFARE))
				LAZYADD(available_vaurca, player)
	var/mob/living/carbon/human/target = input(src, "Select a Vaurca to ban.", "Hivenet Ban") as null|anything in available_vaurca
	if(!target || !isvaurca(target))
		return
	var/obj/item/organ/internal/vaurca/neuralsocket/S = target.internal_organs_by_name[BP_NEURAL_SOCKET]
	var/list/target_fullname = splittext(target.name, " ")
	var/target_surname = target_fullname[2]
	to_chat(src, target.real_name)
	if(!(GLOB.all_languages[LANGUAGE_VAURCA] in target.languages) && S.banned)
		target.add_language(LANGUAGE_VAURCA)
		S.banned = FALSE
		to_chat(src, SPAN_NOTICE("You extend your will, restoring [target]'s connection to the Hivenet. Hopefully it will be better-behaved in future."))
		to_chat(target, SPAN_NOTICE("You feel the thoughts of your fellow Vaurcae restored, as abruptly as they were gone. The unity of the Hivenet surrounds you once more."))

	else if(target_surname == surname)
		if(S.shielded == SOCKET_SHIELDED)
			if(prob(70))
				to_chat(src, SPAN_WARNING("You feel a sudden pain in your neural socket as you are repelled by [target]'s countermeasures!"))
				to_chat(target, SPAN_WARNING("[src] attempted to ban you from the Hivenet, but your countermeasures repelled them!"))
				src.adjustHalLoss(20)
				src.flash_pain(20)
				host.last_action = world.time + 10 MINUTES
				return
		else if (S.shielded == SOCKET_FULLSHIELDED)
			to_chat(src, SPAN_WARNING("You feel a sudden pain in your neural socket as you are repelled by [target]'s countermeasures!"))
			to_chat(target, SPAN_WARNING("[src] attempted to ban you from the Hivenet, but your countermeasures repelled them!"))
			src.adjustHalLoss(25)
			src.flash_pain(25)
			host.last_action = world.time + 10 MINUTES
			return
		to_chat(src, SPAN_NOTICE("You extend your will, severing [target]'s connection to the Hivenet. Perhaps now it will learn its lesson."))
		to_chat(target, SPAN_WARNING("You feel the thoughts of your fellow Vaurcae abruptly vanish, as [src]'s will smothers them all. In an instant, your neural socket is banned, cut off from hearing or speaking to the wider Hivenet."))
		target.remove_language(LANGUAGE_VAURCA)
		S.banned = TRUE
		host.last_action = world.time + 1 MINUTES
	else if(HAS_TRAIT(src, TRAIT_ORIGIN_ELECTRONIC_WARFARE))
		if(!S.shielded)
			if(prob(70))
				to_chat(src, SPAN_NOTICE("You extend your will, severing [target]'s connection to the Hivenet. Perhaps now it will learn its lesson."))
				to_chat(target, SPAN_WARNING("You feel the thoughts of your fellow Vaurcae abruptly vanish, as [src]'s will smothers them all. In an instant, your neural socket is banned, cut off from hearing or speaking to the wider Hivenet."))
				target.remove_language(LANGUAGE_VAURCA)
				S.banned = TRUE
				host.last_action = world.time + 1 MINUTES
			else
				to_chat(src, SPAN_WARNING("You feel a sudden pain in your neural socket as you are unable to breach [target]'s defenses!"))
				to_chat(target, SPAN_WARNING("[src] attempted to ban you from the Hivenet, but your Hive's defenses repelled them!"))
				src.adjustHalLoss(20)
				src.flash_pain(20)
				host.last_action = world.time + 10 MINUTES
				return
		else if(S.shielded == SOCKET_SHIELDED)
			if(prob(50))
				to_chat(src, SPAN_WARNING("You feel a sudden pain in your neural socket as you are repelled by [target]'s countermeasures!"))
				to_chat(target, SPAN_WARNING("[src] attempted to ban you from the Hivenet, but your countermeasures repelled them!"))
				src.adjustHalLoss(15)
				src.flash_pain(15)
				host.last_action = world.time + 10 MINUTES
				return
			else
				to_chat(src, SPAN_NOTICE("You extend your will, severing [target]'s connection to the Hivenet. Perhaps now it will learn its lesson."))
				to_chat(target, SPAN_WARNING("You feel the thoughts of your fellow Vaurcae abruptly vanish, as [src]'s will smothers them all. In an instant, your neural socket is banned, cut off from hearing or speaking to the wider Hivenet."))
				target.remove_language(LANGUAGE_VAURCA)
				S.banned = TRUE
				host.last_action = world.time + 1 MINUTES
		else if(S.shielded == SOCKET_FULLSHIELDED)
			to_chat(src, SPAN_WARNING("You feel a sudden pain in your neural socket as you are repelled by [target]'s countermeasures!"))
			to_chat(target, SPAN_WARNING("[src] attempted to ban you from the Hivenet, but your countermeasures repelled them!"))
			src.adjustHalLoss(15)
			src.flash_pain(15)
			host.last_action = world.time + 10 MINUTES
			return

/mob/living/carbon/human/proc/hivevoid() //Destroys a Vaurca's neural socket.
	set name = "Void Hivenet User"
	set desc = "Permanently sever a Vaurca of your own Hive from the Hivenet, destroying their neural socket. Mouv Ta may attempt to use this on Vaurca of another Hive, though this may have severe diplomatic consequences!"
	set category = "Hivenet"

	var/list/available_vaurca
	var/list/fullname = splittext(src.name, " ")
	var/surname = fullname[2]
	var/obj/item/organ/internal/vaurca/neuralsocket/host = src.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(!src.can_hivenet())
		return
	if(!host.adminperms)
		to_chat(src, SPAN_WARNING("You lack the authority to do this!"))
	for(var/mob/living/carbon/human/player in (GLOB.human_mob_list - src))
		if(isvaurca(player) && player.internal_organs_by_name[BP_NEURAL_SOCKET])
			var/list/player_fullname = splittext(player.name, " ")
			var/player_surname = player_fullname[2]
			if(player_surname == surname || HAS_TRAIT(src, TRAIT_ORIGIN_ELECTRONIC_WARFARE))
				LAZYADD(available_vaurca, player)
	var/mob/living/carbon/human/target = input(src, "Select a Vaurca to void.", "Hivenet Void") as null|anything in available_vaurca
	if(!target || !isvaurca(target))
		return
	var/choice = alert(src, "Are you sure you want to void [target]? This cannot be undone!", "Void User?", "Proceed", "Cancel")
	if(choice == "Cancel")
		return
	msg_admin_attack("[key_name_admin(src)] attempted to void [key_name_admin(target)]'s neural socket! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(src),ckey_target=key_name(target))
	var/obj/item/organ/internal/vaurca/neuralsocket/S = target.internal_organs_by_name[BP_NEURAL_SOCKET]
	var/list/target_fullname = splittext(target.name, " ")
	var/target_surname = target_fullname[2]
	if(target_surname == surname)
		if(S.shielded)
			to_chat(src, SPAN_WARNING("You feel a sudden pain in your neural socket as you are repelled by [target]'s countermeasures!"))
			to_chat(target, SPAN_WARNING("[src] attempted to void your neural socket, but your countermeasures repelled them!"))
			src.adjustHalLoss(20)
			src.flash_pain(20)
			host.last_action = world.time + 30 MINUTES
			return
		to_chat(src, SPAN_NOTICE("You extend your will like a wrathful god, destroying [target]'s neural socket and permanently severing them from the Hivenet. Let that be a lesson to the rest."))
		to_chat(target, SPAN_DANGER("In an instant, stabbing pain in your head blankets out everything else, as your neural socket smoulders and breaks apart. The last of the Hivenet you feel is [src]'s fury, drowning out everything else - before it is gone, forever."))
		target.adjustHalLoss(40)
		target.flash_pain(40)
		target.adjustBrainLoss(20)
		qdel(S)
		host.last_action = world.time + 1 MINUTES
	else if(HAS_TRAIT(src, TRAIT_ORIGIN_ELECTRONIC_WARFARE))
		if(!S.shielded)
			if(prob(30))
				to_chat(src, SPAN_NOTICE("You extend your will like a wrathful god, destroying [target]'s neural socket and permanently severing them from the Hivenet. Let that be a lesson to the rest."))
				to_chat(target, SPAN_DANGER("In an instant, stabbing pain in your head blankets out everything else, as your neural socket smoulders and breaks apart. The last of the Hivenet you feel is [src]'s fury, drowning out everything else - before it is gone, forever."))
				target.adjustHalLoss(40)
				target.flash_pain(40)
				target.adjustBrainLoss(20)
				qdel(S)
				host.last_action = world.time + 1 MINUTES
			else
				to_chat(src, SPAN_WARNING("You feel a sudden pain in your neural socket as you are repelled by [target]'s countermeasures!"))
				to_chat(target, SPAN_WARNING("[src] attempted to void your neural socket, but your Hive's countermeasures repelled them!"))
				src.adjustHalLoss(20)
				src.flash_pain(20)
				host.last_action = world.time + 30 MINUTES
				return
		else if(S.shielded)
			to_chat(src, SPAN_NOTICE("You extend your will like a wrathful god, destroying [target]'s neural socket and permanently severing them from the Hivenet. Let that be a lesson to the rest."))
			to_chat(target, SPAN_DANGER("In an instant, stabbing pain in your head blankets out everything else, as your neural socket smoulders and breaks apart. The last of the Hivenet you feel is [src]'s fury, drowning out everything else - before it is gone, forever."))
			target.adjustHalLoss(40)
			target.flash_pain(40)
			target.adjustBrainLoss(20)
			qdel(S)
			host.last_action = world.time + 1 MINUTES

/mob/living/carbon/human/proc/hivemute() //Prevents a Vaurca from speaking Hivenet, though they can still hear it
	set name = "Mute Hivenet User"
	set desc = "Prevent a Vaurca of your own Hive from speaking on the Hivenet, though they can still hear it. Use this ability again to unmute them. Mouv Ta may attempt to use this on Vaurca of another Hive, though this may have severe diplomatic consequences!"
	set category = "Hivenet"

	var/list/available_vaurca
	var/list/fullname = splittext(src.name, " ")
	var/surname = fullname[2]
	var/obj/item/organ/internal/vaurca/neuralsocket/host = src.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(!src.can_hivenet())
		return
	if(!host.adminperms)
		to_chat(src, SPAN_WARNING("You lack the authority to do this!"))
		return
	for(var/mob/living/carbon/human/player in (GLOB.human_mob_list - src))
		if(isvaurca(player) && player.internal_organs_by_name[BP_NEURAL_SOCKET])
			var/list/player_fullname = splittext(player.name, " ")
			var/player_surname = player_fullname[2]
			if(player_surname == surname || HAS_TRAIT(src, TRAIT_ORIGIN_ELECTRONIC_WARFARE))
				LAZYADD(available_vaurca, player)
	var/mob/living/carbon/human/target = input(src, "Select a Vaurca to mute.", "Hivenet Mute") as null|anything in available_vaurca
	if(!target || !isvaurca(target))
		return
	var/obj/item/organ/internal/vaurca/neuralsocket/S = target.internal_organs_by_name[BP_NEURAL_SOCKET]
	var/list/target_fullname = splittext(target.name, " ")
	var/target_surname = target_fullname[2]
	if(S.banned)
		to_chat(src, SPAN_NOTICE("[target] is already banned from the Hivenet. Muting them would be pointless."))
		return
	if(S.muted)
		S.muted = FALSE
		to_chat(src, SPAN_NOTICE("You extend your will, restoring [target]'s ability to speak over the Hivenet. Hopefully it will be better-behaved in future."))
		to_chat(target, SPAN_NOTICE("You feel [src]'s sanction upon you lifted, as you are able to speak over the Hivenet once again."))
		return
	if(target_surname == surname)
		if(S.shielded == SOCKET_SHIELDED)
			if(prob(70))
				to_chat(src, SPAN_WARNING("You feel a sudden pain in your neural socket as you are repelled by [target]'s countermeasures!"))
				to_chat(target, SPAN_WARNING("[src] attempted to mute you over the Hivenet, but your countermeasures repelled them!"))
				src.adjustHalLoss(20)
				src.flash_pain(20)
				host.last_action = world.time + 5 MINUTES
				return
		else if (S.shielded == SOCKET_FULLSHIELDED)
			to_chat(src, SPAN_WARNING("You feel a sudden pain in your neural socket as you are repelled by [target]'s countermeasures!"))
			to_chat(target, SPAN_WARNING("[src] attempted to mute you over the Hivenet, but your countermeasures repelled them!"))
			src.adjustHalLoss(25)
			src.flash_pain(25)
			host.last_action = world.time + 5 MINUTES
			return
		to_chat(src, SPAN_NOTICE("You extend your will, silencing [target]'s neural socket. Perhaps now it will learn its lesson."))
		to_chat(target, SPAN_WARNING("You feel [src]'s will enter your mind, disabling your socket's ability to speak. Though the voices of your fellow Vaurcae echo still, you cannot speak to them."))
		S.muted = TRUE
		host.last_action = world.time + 5 MINUTES
	else if(HAS_TRAIT(src, TRAIT_ORIGIN_ELECTRONIC_WARFARE))
		if(!S.shielded)
			if(prob(70))
				to_chat(src, SPAN_NOTICE("You extend your will, silencing [target]'s neural socket. Perhaps now it will learn its lesson."))
				to_chat(target, SPAN_WARNING("You feel [src]'s will enter your mind, disabling your socket's ability to speak. Though the voices of your fellow Vaurcae echo still, you cannot speak to them."))
				S.muted = TRUE
				host.last_action = world.time + 1 MINUTES
			else
				to_chat(src, SPAN_WARNING("You feel a sudden pain in your neural socket as you are unable to breach [target]'s defenses!"))
				to_chat(target, SPAN_WARNING("[src] attempted to mute you over the Hivenet, but your Hive's defenses repelled them!"))
				src.adjustHalLoss(20)
				src.flash_pain(20)
				host.last_action = world.time + 5 MINUTES
		else if(S.shielded == SOCKET_SHIELDED)
			if(prob(50))
				to_chat(src, SPAN_WARNING("You feel a sudden pain in your neural socket as you are repelled by [target]'s countermeasures!"))
				to_chat(target, SPAN_WARNING("[src] attempted to mute you over the Hivenet, but your countermeasures repelled them!"))
				src.adjustHalLoss(15)
				src.flash_pain(15)
				host.last_action = world.time + 5 MINUTES
			else
				to_chat(src, SPAN_NOTICE("You extend your will, silencing [target]'s neural socket. Perhaps now it will learn its lesson."))
				to_chat(target, SPAN_WARNING("You feel [src]'s will enter your mind, disabling your socket's ability to speak. Though the voices of your fellow Vaurcae echo still, you cannot speak to them."))
				S.muted = TRUE
				host.last_action = world.time + 1 MINUTES
		else if(S.shielded == SOCKET_FULLSHIELDED)
			to_chat(src, SPAN_WARNING("You feel a sudden pain in your neural socket as you are repelled by [target]'s countermeasures!"))
			to_chat(target, SPAN_WARNING("[src] attempted to mute you over the Hivenet, but your countermeasures repelled them!"))
			src.adjustHalLoss(15)
			src.flash_pain(15)
			host.last_action = world.time + 5 MINUTES

//Hivenet Electronic Warfare
/mob/living/carbon/human/proc/hivenet_recieve()
	set name = "Receive Encrypted Hivenet"
	set desc = "Set an encryption key for the Hivenet. If someone transmits an encrypted message with the same key, you will understand it. Use this verb again to reset the key."
	set category = "Hivenet"

	var/obj/item/organ/internal/vaurca/neuralsocket/S = src.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(!src.can_hivenet())
		return
	if(S.decryption_key)
		S.decryption_key = null
		to_chat(src, SPAN_NOTICE("Your Hivenet decryption key has been reset."))
		return
	S.decryption_key = input(src, "Enter a new decryption key for Hivenet messages.", "Hivenet Decryption") as text
	to_chat(src, SPAN_NOTICE("Your Hivenet decryption key has been set to [S.decryption_key]."))

/mob/living/carbon/human/proc/hivenet_encrypt()
	set name = "Set Hivenet Encryption"
	set desc = "Set an encryption key for the Hivenet. If someone has this key set to receive, they will understand you. Use this verb again to reset the key."
	set category = "Hivenet"
	var/obj/item/organ/internal/vaurca/neuralsocket/S = src.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(!src.can_hivenet())
		return
	if(S.encryption_key)
		S.encryption_key = null
		to_chat(src, SPAN_NOTICE("Your Hivenet encryption key has been reset."))
		return
	S.encryption_key = input(src, "Enter a new encryption key for Hivenet messages.", "Hivenet Decryption") as text
	to_chat(src, SPAN_NOTICE("Your Hivenet encryption key has been set to [S.encryption_key]."))

/mob/living/carbon/human/proc/hivenet_decrypt()
	set name = "Decrypt Hivenet Key"
	set desc = "Attempt to retrieve an in-use Hivenet encryption key."
	set category = "Hivenet"

	var/decryptchance = 5
	var/obj/item/organ/internal/vaurca/neuralsocket/host = src.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(!src.can_hivenet())
		return
	if(HAS_TRAIT(src, TRAIT_ORIGIN_ELECTRONIC_WARFARE))
		decryptchance = 15
	for(var/mob/living/carbon/human/player in (GLOB.human_mob_list - src))
		if(isvaurca(player) && player.internal_organs_by_name[BP_NEURAL_SOCKET])
			var/obj/item/organ/internal/vaurca/neuralsocket/S = player.internal_organs_by_name[BP_NEURAL_SOCKET]
			if(S.encryption_key)
				if(prob(decryptchance))
					to_chat(src, SPAN_NOTICE("You are able to retrieve a Hivenet encryption key. The key is \"[S.encryption_key]\""))
					host.last_action = world.time + 5 MINUTES
					return
	host.last_action = world.time + 5 MINUTES
	to_chat(src, SPAN_NOTICE("You are unable to retrieve any Hivenet encryption keys."))

/mob/living/carbon/human/proc/hivenet_camera()
	set name = "Access Hivenet User Senses"
	set desc = "Attempt to look through the eyes of another Vaurca as if they were a camera. Vaurcae of your own Hive have no choice unless they have countermeasures, whereas Vaurca of other Hives can choose to allow you access. A Mouv Ta may attempt to force this, but it would be a serious diplomatic breach."
	set category = "Hivenet"

	var/list/available_vaurca
	var/list/fullname = splittext(src.name, " ")
	var/surname = fullname[2]
	var/obj/item/organ/internal/vaurca/neuralsocket/host = src.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(!src.can_hivenet())
		return
	if(!host.adminperms)
		to_chat(src, SPAN_WARNING("You lack the authority to do this!"))
	if(stat != CONSCIOUS)
		remoteview_target = null
		reset_view(0)
		return
	if(client.eye != client.mob)
		remoteview_target = null
		reset_view(0)
		return
	for(var/mob/living/carbon/human/player in (GLOB.human_mob_list - src))
		if(isvaurca(player) && player.internal_organs_by_name[BP_NEURAL_SOCKET])
			if(player.stat != CONSCIOUS)
				continue
			LAZYADD(available_vaurca, player)
	var/mob/living/carbon/human/target = input(src, "Select a Vaurca to observe.", "Hivenet Remote Observation") as null|anything in available_vaurca
	if(!target || !isvaurca(target))
		remoteview_target = null
		reset_view(0)
		return
	var/obj/item/organ/internal/vaurca/neuralsocket/S = target.internal_organs_by_name[BP_NEURAL_SOCKET]
	var/list/target_fullname = splittext(target.name, " ")
	var/target_surname = target_fullname[2]
	if(target_surname == surname && !S.shielded)
		to_chat(src, SPAN_NOTICE("You extend your mind into the Hivenet, accessing [target]'s senses. Use this verb again to cancel."))
		remoteview_target = target
		reset_view(target)
	else
		host.last_action = world.time + 5 MINUTES
		var/choice = alert(target, "[src] is attempting to access your senses. Do you wish to allow this?", "Hivenet Remote Observation", "Deny", "Allow")
		if(choice == "Allow")
			to_chat(src, SPAN_NOTICE("You extend your mind into the Hivenet, accessing [target]'s senses. Use this verb again to cancel."))
			remoteview_target = target
			reset_view(target)

		if(choice == "Deny")
			if(HAS_TRAIT(src, TRAIT_ORIGIN_ELECTRONIC_WARFARE))
				var/hijack = alert(src, "[target] has denied your access request. Attempt a hijack?", "Hijack Hivenet Senses", "No", "Yes")
				if(hijack == "Yes")
					if(prob(40) && !S.shielded)
						to_chat(src, SPAN_NOTICE("You extend your mind into the Hivenet, accessing [target]'s senses. Use this verb again to cancel."))
						remoteview_target = target
						reset_view(target)
						return
					else
						to_chat(src, SPAN_WARNING("You attempt a hijack, and a stab of pain comes to your mind as your attempt is rejected!"))
						src.adjustHalLoss(15)
						src.flash_pain(15)
						to_chat(target, SPAN_WARNING("[src] attempted to hijack your senses, but your countermeasures repelled them!"))
						remoteview_target = null
						reset_view(0)
						return
			to_chat(src, SPAN_NOTICE("Your request to access [target]'s senses has been denied."))
			remoteview_target = null
			reset_view(0)

/mob/living/carbon/human/proc/hivenet_neuralshock()
	set name = "Neural Shock"
	set desc = "Shock a member of your own Hive with a functioning Neural Socket. Deals pain and brain damage. Rare to need to use, most Ta would only do so in the event of a malfunctioning Vaurca or Viax. A Mouv Ta may attempt this against other Hive members, though to do so would be an extreme diplomatic breach."
	set category = "Hivenet"

	var/list/available_vaurca
	var/list/fullname = splittext(src.name, " ")
	var/surname = fullname[2]
	var/obj/item/organ/internal/vaurca/neuralsocket/host = src.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(!src.can_hivenet())
		return
	if(!host.adminperms)
		to_chat(src, SPAN_WARNING("You lack the authority to do this!"))
	for(var/mob/living/carbon/human/player in (GLOB.human_mob_list - src))
		if(isvaurca(player) && player.internal_organs_by_name[BP_NEURAL_SOCKET])
			var/list/player_fullname = splittext(player.name, " ")
			var/player_surname = player_fullname[2]
			if(player_surname == surname || HAS_TRAIT(src, TRAIT_ORIGIN_ELECTRONIC_WARFARE))
				LAZYADD(available_vaurca, player)
	var/mob/living/carbon/human/target = input(src, "Select a Vaurca to shock.", "Neural Shock") as null|anything in available_vaurca
	if(!target || !isvaurca(target))
		return
	var/obj/item/organ/internal/vaurca/neuralsocket/S = target.internal_organs_by_name[BP_NEURAL_SOCKET]
	var/list/target_fullname = splittext(target.name, " ")
	var/target_surname = target_fullname[2]
	if(!istype(S) || S.is_broken())
		to_chat(src, SPAN_WARNING("The target must have a functional neural socket!"))
		return
	if(S.shielded)
		to_chat(src, SPAN_WARNING("You attempt to shock [target], but are repelled by their countermeasures!"))
		src.adjustHalLoss(15)
		src.flash_pain(15)
		return
	if(target_surname == surname)
		to_chat(src, SPAN_WARNING("You lash out over the Hivenet, delivering a neural shock to [target]!"))
		to_chat(target, SPAN_DANGER("You feel [src]'s will strike out at you, pain burning inside your head!"))
		target.adjustHalLoss(15)
		target.flash_pain(15)
		target.adjustBrainLoss(10)
		host.last_action = world.time + 5 MINUTES
		return
	if(HAS_TRAIT(src, TRAIT_ORIGIN_ELECTRONIC_WARFARE))
		if(prob(50))
			to_chat(src, SPAN_WARNING("You lash out over the Hivenet, delivering a neural shock to [target]!"))
			to_chat(target, SPAN_DANGER("You feel [src]'s will strike out at you, pain burning inside your head!"))
			target.adjustHalLoss(15)
			target.flash_pain(15)
			target.adjustBrainLoss(10)
			host.last_action = world.time + 5 MINUTES
			return
		else
			to_chat(src, SPAN_WARNING("You lash out over the Hivenet, but are unable to penetrate [target]'s neural socket!"))
			to_chat(target, SPAN_DANGER("You feel [src]'s will strike out at you, but your Hive's defenses repel [src.get_pronoun("him")]!"))
			src.adjustHalLoss(15)
			src.flash_pain(15)
			host.last_action = world.time + 5 MINUTES
			return

/mob/living/carbon/human/proc/hivenet_lattice() //Shares your electronic defenses with other bugs. For admin + hiveshield
	set name = "Hivenet Defensive Lattice"
	set desc = "Share your Hivenet defenses with up to three other Vaurcae. Mouv Ta can share with up to five."
	set category = "Hivenet"

	var/list/available_vaurca
	var/max = 3
	var/obj/item/organ/internal/vaurca/neuralsocket/admin/host = src.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(!src.can_hivenet())
		return
	if(HAS_TRAIT(src, TRAIT_ORIGIN_ELECTRONIC_WARFARE))
		max = 5
	if(length(host.shielded_sockets))
		var/choice = alert(src, "Do you wish to remove your protection from a Vaurca?", "Hivenet Defensive Lattice", "No", "Yes")
		to_chat(src, SPAN_NOTICE("You chose [choice]"))
		if(choice == "Yes")
			var/mob/living/carbon/human/H = input(src, "Select a Vaurca to remove your defenses from.", "Hivenet Defensive Lattice", null) as anything in host.shielded_mobs
			var/obj/item/organ/internal/vaurca/neuralsocket/S = H.internal_organs_by_name[BP_NEURAL_SOCKET]
			to_chat(src, SPAN_NOTICE("You remove your protection from [H]'s neural socket."))
			to_chat(H, SPAN_WARNING("You feel [src]'s protection vanish from you, leaving your neural socket exposed."))
			if(S.shielded)
				S.shielded = SOCKET_UNSHIELDED
				host.shielded_sockets -= S
				host.shielded_mobs -= H
			return
	if(host.shielded_sockets.len >= max)
		to_chat(src, SPAN_NOTICE("You are already shielding the maximum number of Vaurcae!"))
		return
	for(var/mob/living/carbon/human/player in (GLOB.human_mob_list - src))
		if(isvaurca(player) && player.internal_organs_by_name[BP_NEURAL_SOCKET])
			LAZYADD(available_vaurca, player)
	if(!length(available_vaurca))
		to_chat(src, SPAN_NOTICE("There are no unshielded Vaurcae within range!"))
		return
	LAZYADD(available_vaurca, "Finished")
	for(var/i = 0 to max)
		var/mob/living/carbon/human/H = input(src, "Select a Vaurca to extend your defenses to.","Hivenet Defensive Lattice", null) as anything in available_vaurca
		if(!istype(H))
			break
		var/obj/item/organ/internal/vaurca/neuralsocket/S = H.internal_organs_by_name[BP_NEURAL_SOCKET]
		available_vaurca -= H
		host.shielded_sockets += S
		host.shielded_mobs += H
		to_chat(src, SPAN_NOTICE("You extend your protection, shielding [H] from Hivenet attacks."))
		to_chat(H, SPAN_NOTICE("You feel [src]'s will settle over you, shielding your neural socket."))
		if(!S.shielded) //don't want to make this weaken the good shields
			S.shielded = SOCKET_SHIELDED

//Antag Electronic Warfare Abilities
/mob/living/carbon/human/proc/antag_hivemute()
	set name = "Disrupt Hivenet User"
	set desc = "Temporarily sever a Vaurca's connection to the Hivenet, preventing them from speaking. Failure will reveal your location to them!"
	set category = "Hivenet"

	var/list/available_vaurca
	var/obj/item/organ/internal/vaurca/neuralsocket/host = src.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(!src.can_hivenet())
		return
	for(var/mob/living/carbon/human/player in (GLOB.human_mob_list - src))
		if(player.stat == DEAD)
			continue
		if(isvaurca(player) && player.internal_organs_by_name[BP_NEURAL_SOCKET])
			LAZYADD(available_vaurca, player)
	LAZYADD(available_vaurca, "Cancel")
	var/mob/living/carbon/human/target = input(src, "Select a target to disrupt", "Disrupt Hivenet User", null) as anything in available_vaurca
	if(!istype(target))
		return
	var/obj/item/organ/internal/vaurca/neuralsocket/S = target.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(prob(70) || S.shielded)
		to_chat(src, SPAN_DANGER("Your disruption attempt fails, [target]'s countermeasures repelling your assault! You can feel their defenses spring to life, tracing your location!"))
		to_chat(target, SPAN_DANGER("You feel a presence attempting to block your neural socket, but your countermeasures repel it! Analysing the attack, you sense that it came from [get_area(src)]!"))
	to_chat(target, SPAN_DANGER("Suddenly, you feel an attack on your systems, blocking your neural socket's ability to transmit to the Hivenet!"))
	S.disrupted = TRUE
	S.disrupttime = world.time + 10 MINUTES
	host.last_action = world.time + 5 MINUTES

/mob/living/carbon/human/proc/antag_hiveshock()
	set name = "Hivenet Shock"
	set desc = "Attempt to breach a Vaurca's defenses and deliver a painful neural shock. This has a 30% chance of success, and failure will reveal your location."
	set category = "Hivenet"

	var/list/available_vaurca
	var/obj/item/organ/internal/vaurca/neuralsocket/host = src.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(!src.can_hivenet())
		return
	for(var/mob/living/carbon/human/player in (GLOB.human_mob_list - src))
		if(player.stat == DEAD)
			continue
		if(isvaurca(player) && player.internal_organs_by_name[BP_NEURAL_SOCKET])
			LAZYADD(available_vaurca, player)
	var/mob/living/carbon/human/target = input(src, "Select a target to shock", "Neural Shock User", null) as anything in available_vaurca
	if(!istype(target))
		to_chat(src, SPAN_WARNING("Invalid target!"))
		return
	var/obj/item/organ/internal/vaurca/neuralsocket/S = target.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(prob(70) || S.shielded)
		to_chat(src, SPAN_DANGER("Your disruption attempt fails, [target]'s countermeasures repelling your assault! You can feel their defenses spring to life, tracing your location!"))
		to_chat(target, SPAN_DANGER("You feel a presence attempting to block your neural socket, but your countermeasures repel it! Analysing the attack, you sense that it came from [get_area(src)]!"))
		host.last_action = world.time + 5 MINUTES
		src.adjustBrainLoss(10)
		src.adjustHalLoss(15)
		src.flash_pain(15)
		return
	to_chat(src, SPAN_WARNING("You strike through the Hivenet, delivering a painful neural shock to [target]!"))
	to_chat(target, SPAN_DANGER("You feel a sudden pain in your head, as an unknown attacker delivers a painful neural shock!"))
	target.adjustBrainLoss(20)
	target.adjustHalLoss(20)
	target.flash_pain(20)
	src.adjustBrainLoss(10)
	src.adjustHalLoss(10)
	src.flash_pain(10)
	host.last_action = world.time + 5 MINUTES

/mob/living/carbon/human/proc/hivenet_hijack()
	set name = "Hijack Hivenet User Senses"
	set desc = "Hijack the eyes of another Vaurca, to use them as a camera. This only has a 30% chance of success, and failure will reveal your location. Use this verb again to cancel."
	set category = "Hivenet"

	var/list/available_vaurca
	var/obj/item/organ/internal/vaurca/neuralsocket/host = src.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(!src.can_hivenet())
		return
	if(stat != CONSCIOUS)
		remoteview_target = null
		reset_view(0)
		return
	if(client.eye != client.mob)
		remoteview_target = null
		reset_view(0)
		return
	for(var/mob/living/carbon/human/player in (GLOB.human_mob_list - src))
		if(isvaurca(player) && player.internal_organs_by_name[BP_NEURAL_SOCKET])
			if(player.stat != CONSCIOUS)
				continue
			LAZYADD(available_vaurca, player)
	var/mob/living/carbon/human/target = input(src, "Select a Vaurca to observe.", "Hivenet Sensory Hijack") as null|anything in available_vaurca
	if(!target || !isvaurca(target))
		remoteview_target = null
		reset_view(0)
		return
	var/obj/item/organ/internal/vaurca/neuralsocket/S = target.internal_organs_by_name[BP_NEURAL_SOCKET]
	var/stealth = alert(src, "Do you wish to ask your target's permission?", "Hivenet Sensory Hijack", "No", "Yes")
	if(stealth == "Yes")
		var/allowed = alert(target, "Someone is attempting to access your senses through the Hivenet. Do you wish to allow them?", "Hivenet Sensory Access", "Deny", "Allow")
		if(allowed == "Allow")
			to_chat(src, SPAN_NOTICE("You extend your mind into the Hivenet, accessing [target]'s senses. Use this verb again to cancel."))
			remoteview_target = target
			reset_view(target)
			return
		else
			to_chat(src, SPAN_WARNING("Your attempt to access [target]'s sensors has been denied."))
			return
	if(prob(70) || S.shielded)
		to_chat(src, SPAN_WARNING("You attempt a hijack, and a stab of pain comes to your mind as your attempt is rejected!"))
		src.adjustHalLoss(15)
		src.flash_pain(15)
		to_chat(target, SPAN_WARNING("Someone attempted to hijack your senses, but your countermeasures repelled them! Tracing the signal, you can tell that it originated from [get_area(src)]!"))
		remoteview_target = null
		reset_view(0)
		host.last_action = world.time + 5 MINUTES
		return
	to_chat(src, SPAN_NOTICE("You extend your mind into the Hivenet, accessing [target]'s senses. Use this verb again to cancel."))
	remoteview_target = target
	reset_view(target)

/mob/living/carbon/human/proc/can_hivenet()
	var/obj/item/organ/internal/vaurca/neuralsocket/S = src.internal_organs_by_name[BP_NEURAL_SOCKET]
	if(src.stat != CONSCIOUS)
		to_chat(src, SPAN_WARNING("You are incapable of that in your current state!"))
		return FALSE
	if(!istype(S))
		to_chat(src, SPAN_WARNING("You require a functional neural socket to do this!"))
		return FALSE
	if(S.last_action > world.time)
		to_chat(src, SPAN_WARNING("You must wait before attempting another Hivenet action!"))
		return FALSE
	if(!(GLOB.all_languages[LANGUAGE_VAURCA] in src.languages) || !istype(S))
		to_chat(src, SPAN_DANGER("Your mind is dark, unable to communicate with the Hive."))
		return FALSE
	if(S.disrupted)
		to_chat(src, SPAN_DANGER("You are unable to transmit to the Hivenet at this time!"))
		return FALSE
	return TRUE

//Lii'dra Zombie Powers
/mob/living/carbon/human/proc/kois_cough()
	set category = "Abilities"
	set name = "Exhale Spores"
	set desc = "Exhale a cloud of black k'ois spores, to further spread the will of the Lii'dra."

	if(src.stat != CONSCIOUS)
		to_chat(src, SPAN_WARNING("You are incapable of that in your current state!"))
		return
	var/obj/item/organ/internal/parasite/blackkois/P = internal_organs_by_name["blackkois"]
	if(!P)
		to_chat(src, SPAN_WARNING("You don't have black k'ois mycosis!"))
		return

	if(P.stage < 5)
		to_chat(src, SPAN_WARNING("Your mycosis has not grown enough to do this!"))
		return

	if(last_special > world.time)
		to_chat(src, SPAN_WARNING("You need time to replenish your spores!"))
		return

	to_chat(usr, SPAN_GOOD("You feel Us within your lungs. Exhale. Let Our will be done."))

	var/turf/T = get_turf(src)

	var/datum/reagents/R = new/datum/reagents(20)
	R.add_reagent(/singleton/reagent/kois/black,5)
	var/datum/effect/effect/system/smoke_spread/chem/spores/S = new("blackkois")

	S.attach(T)
	S.set_up(R, 20, 0, T, 40)
	S.start()

	last_special = world.time + 5 MINUTES //don't let them do this too often or it's gonna be a fucking nightmare

/mob/living/carbon/human/proc/kois_infect()
	set name = "Infect Creature"
	set desc = "Infect another creature with black k'ois mycosis."
	set category = "Abilities"

	if(src.stat != CONSCIOUS)
		to_chat(src, SPAN_WARNING("You are incapable of that in your current state!"))
		return

	if(last_special > world.time)
		to_chat(src, SPAN_WARNING("You need time to replenish your spores!"))
		return

	if(wear_mask?.flags_inv & HIDEFACE)
		to_chat(src, SPAN_WARNING("You have a mask covering your mouth!"))
		return

	if(head?.flags_inv & HIDEFACE)
		to_chat(src, SPAN_WARNING("You have something on your head covering your mouth!"))
		return

	var/obj/item/grab/G = locate() in src
	if(!G || !istype(G))
		to_chat(src, SPAN_WARNING("You are not grabbing anyone."))
		return

	if(G.state < GRAB_KILL)
		to_chat(src, SPAN_WARNING("You must have a strangling grip to infect!"))
		return

	if(ishuman(G.affecting))
		var/mob/living/carbon/human/H = G.affecting
		if(H.isSynthetic())
			to_chat(src, SPAN_WARNING("\The [H] is not an organic being, and cannot be infected!"))
			return
		if(H.wear_mask?.flags_inv & HIDEFACE)
			to_chat(src, SPAN_WARNING("\The [H] has something covering their face!"))
			return
		if(H.head?.flags_inv & HIDEFACE)
			to_chat(src, SPAN_WARNING("\The [H] has something on their head covering their face!"))
			return
		if(H.internal_organs_by_name["blackkois"])
			to_chat(src, SPAN_WARNING("\The [H] is already infected!"))
			return

		src.visible_message(SPAN_DANGER("[src] leans towards [H], exhaling a cloud of black spores into their face."), \
		SPAN_GOOD("You lean towards [H], placing your face close to theirs, and exhale. They will become Us, soon."))
		if(!do_after(src, 2 SECONDS))
			src.visible_message(SPAN_DANGER("[src] is interrupted before their target can breathe in the spores!"), \
			SPAN_WARNING("You are interrupted, unable to deliver [H] to Our embrace!"))
		var/obj/item/organ/external/affected = H.get_organ(BP_HEAD)
		var/obj/item/organ/internal/parasite/blackkois/infest = new()
		infest.replaced(H, affected)

		msg_admin_attack("[key_name_admin(src)] infected [key_name_admin(H)] with black k'ois! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(src),ckey_target=key_name(H))

/mob/living/carbon/human/proc/hivenet_manifest()
	set name = "Hivenet Manifest"
	set desc = "Get a list of all vaurca currently on the Hivenet."
	set category = "Hivenet"

	var/list/all_vaurca = list()
	for(var/mob/living/carbon/human/vaurca in GLOB.human_mob_list)
		if(!vaurca.stat && isvaurca(vaurca) && vaurca.internal_organs_by_name[BP_NEURAL_SOCKET])
			all_vaurca += vaurca
	var/datum/tgui_module/hivenet_manifest/HM = new /datum/tgui_module/hivenet_manifest(usr, all_vaurca)
	HM.ui_interact(usr)
