// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z

/mob/living/carbon/human/proc/tie_hair()
	set name = "Tie Hair"
	set desc = "Style your hair."
	set category = "IC"
	
	if(!use_check_and_message())
		to_chat(src, span("warning", "You can't tie your hair when you are incapacitated!"))
		return

	if(h_style)
		var/datum/sprite_accessory/hair/hair_style = hair_styles_list[h_style]
		var/selected_string
		if(hair_style.length <= 1)
			to_chat(src, "<span class ='warning'>Your hair isn't long enough to tie.</span>")
			return
		else
			var/list/datum/sprite_accessory/hair/valid_hairstyles = list()
			for(var/hair_string in hair_styles_list)
				var/datum/sprite_accessory/hair/test = hair_styles_list[hair_string]
				if(test.length >= 2 && (species.bodytype in test.species_allowed))
					valid_hairstyles.Add(hair_string)
			selected_string = input("Select a new hairstyle", "Your hairstyle", hair_style) as null|anything in valid_hairstyles
		if(selected_string && h_style != selected_string)
			h_style = selected_string
			regenerate_icons()
			visible_message("<span class='notice'>[src] pauses a moment to style their hair.</span>")
		else
			to_chat(src, "<span class ='notice'>You're already using that style.</span>")

mob/living/carbon/human/proc/change_monitor()
	set name = "Change IPC Screen"
	set desc = "Change the display on your screen."
	set category = "Abilities"

	if(f_style)
		var/datum/sprite_accessory/facial_hair/screen_style = facial_hair_styles_list[f_style]
		var/selected_string
		var/list/datum/sprite_accessory/facial_hair/valid_screenstyles = list()
		for(var/screen_string in facial_hair_styles_list)
			var/datum/sprite_accessory/facial_hair/test = facial_hair_styles_list[screen_string]
			if(species.bodytype in test.species_allowed)
				valid_screenstyles.Add(screen_string)
		selected_string = input("Select a new screen", "Your monitor display", screen_style) as null|anything in valid_screenstyles
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

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
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

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
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

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
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

	// Only Vox get to shriek. Seriously.
	if (isvox(src))
		playsound(loc, 'sound/voice/shriek1.ogg', 50, 1)

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

	visible_message("<span class='warning'><b>\The [src]</b> rips viciously at \the [G.affecting]'s body with its claws!</span>")

	if(istype(G.affecting,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = G.affecting
		H.apply_damage(50,BRUTE)
		if(H.stat == 2)
			H.gib()
	else
		var/mob/living/M = G.affecting
		if(!istype(M)) return //wut
		M.apply_damage(50,BRUTE)
		if(M.stat == 2)
			M.gib()


// Simple mobs cannot use Skrellepathy
/mob/proc/can_commune()
	return FALSE

/mob/living/carbon/human/can_commune()
	if(psi)
		return TRUE
	else
		return species ? species.can_commune() : FALSE

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

	for (var/mob/M in player_list)
		if (istype(M, /mob/abstract/new_player))
			continue
		else if(M.stat == DEAD &&  M.client.prefs.toggles & CHAT_GHOSTEARS)
			to_chat(M,"<span class='notice'>[src] telepathically says to [target]:</span> [text]")

	var/mob/living/carbon/human/H = target
	if (target.can_commune())
		to_chat(H,"<span class='psychic'>You instinctively sense [src] sending their thoughts into your mind, hearing:</span> [text]")
	else if(prob(25) && (target.mind && target.mind.assigned_role=="Chaplain"))
		to_chat(H,"<span class='changeling'>You sense [src]'s thoughts enter your mind, whispering quietly:</span> [text]")
	else
		to_chat(H,"<span class='alium'>You feel pressure behind your eyes as alien thoughts enter your mind:</span> [text]")
		if(istype(H))
			if (target.can_commune())
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

	if(G.state < GRAB_KILL)
		to_chat(src, SPAN_WARNING("You must have a strangling grip to bite someone!"))
		return

	if(ishuman(G.affecting))
		var/mob/living/carbon/human/H = G.affecting
		var/hit_zone = zone_sel.selecting
		var/obj/item/organ/external/affected = H.get_organ(hit_zone)

		if(!affected || affected.is_stump())
			to_chat(H, SPAN_WARNING("They are missing that limb!"))
			return

		H.apply_damage(25, BRUTE, hit_zone, sharp = TRUE, edge = TRUE)
		visible_message(SPAN_WARNING("<b>\The [src]</b> rips viciously at \the [G.affecting]'s [affected] with its mandibles!"))
		msg_admin_attack("[key_name_admin(src)] mandible'd [key_name_admin(H)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(src),ckey_target=key_name(H))
	else
		var/mob/living/M = G.affecting
		if(!istype(M))
			return
		M.apply_damage(25, BRUTE, sharp = TRUE, edge = TRUE)
		visible_message(SPAN_WARNING("<b>\The [src]</b> rips viciously at \the [G.affecting]'s flesh with its mandibles!"))
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
				M.apply_damage(20,BRUTE)
				M.apply_damage(15,BURN)
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

	if(!(all_languages[LANGUAGE_VAURCA] in src.languages))
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

	if(!(all_languages[LANGUAGE_VAURCA] in M.languages))
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

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot launch a quill in your current state.")
		return

	last_special = world.time + 30

	visible_message("<span class='warning'><b>\The [src]</b> launches a spine-quill at [target]!</span>")

	src.apply_damage(10,BRUTE)
	playsound(src.loc, 'sound/weapons/bladeslice.ogg', 50, 1)
	var/obj/item/arrow/quill/A = new /obj/item/arrow/quill(usr.loc)
	A.throw_at(target, 10, 30, usr)
	msg_admin_attack("[key_name_admin(src)] launched a quill at [key_name_admin(target)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(src),ckey_target=key_name(target))


/mob/living/carbon/human/proc/shatter_light()
	set category = "Abilities"
	set name = "Shatter Lights"
	set desc = "Shatter all lights around yourself."

	if(last_special > world.time)
		to_chat(src, "<span class='danger'>You're still regaining your strength!</span>")
		return

	last_special = world.time + 50

	visible_message("<span class='danger'>\The [src] shrieks!</span>")
	playsound(src.loc, 'sound/species/shadow/grue_screech.ogg', 100, 1)

	for(var/obj/machinery/light/L in range(7))
		L.broken()

/mob/living/carbon/human/proc/create_darkness()
	set category = "Abilities"
	set name = "Create Darkness"
	set desc = "Create a field of darkness around yourself."

	if(last_special > world.time)
		to_chat(src, "<span class='danger'>You're still regaining your strength!</span>")
		return

	last_special = world.time + 100

	playsound(src.loc, 'sound/species/shadow/grue_growl.ogg', 100, 1)

	src.set_light(4,-20)

	addtimer(CALLBACK(src, /atom/.proc/set_light, 0), 30 SECONDS)

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

/mob/living/carbon/human/proc/shadow_step(var/turf/T in turfs)
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

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "<span class='danger'>You cannot charge in your current state!</span>")
		return

	last_special = world.time + 100

	src.visible_message("<span class='warning'>\The [src] takes a step backwards and rears up.</span>",
			"<span class='notice'>You take a step backwards and then...</span>")
	if(do_after(src,5))
		playsound(loc, 'sound/species/shadow/grue_screech.ogg', 100, 1)
		src.visible_message("<span class='danger'>\The [src] charges!</span>")
		trampling()


/mob/living/carbon/human/proc/trampling()

	var/brokesomething = 0//true if we break anything
	var/done = 0//Set true if we fail to break something. We won't try to break anything for the rest of the proc

	var/turf/target = get_step(src, dir)

	for(var/obj/obstacle in get_turf(src))
		if((obstacle.flags & ON_BORDER) && (src != obstacle))
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
		attack_log += "\[[time_stamp()]\]<font color='red'>crashed into [brokesomething] objects at ([target.x];[target.y];[target.z]) </font>"
		msg_admin_attack("[key_name(src)] crashed into [brokesomething] objects at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>)" )

	if (!done && target.Enter(src, null))
		if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
			return 0

		step(src, dir)
		playsound(src,'sound/mecha/mechstep.ogg',25,1)
		if (brokesomething)
			src.visible_message("<span class='danger'>[src.name] breaks through!</span>")
		addtimer(CALLBACK(src, .proc/trampling), 1)

	else
		target = get_step(src, dir)
		do_attack_animation(target)

/mob/living/carbon/human/proc/crash_into(var/atom/A)
	var/aname = A.name
	var/oldtype = A.type
	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		return 0

	if (istype(A, /mob/living))
		var/mob/living/M = A
		attack_log += "\[[time_stamp()]\]<font color='red'> Crashed into [key_name(M)]</font>"
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
		to_chat(src, "<span class='danger'>You are too tired to screech!</span>")
		return

	if(stat || paralysis || stunned || weakened)
		to_chat(src, "<span class='danger'>You cannot screech in your current state!</span>")
		return

	last_special = world.time + 100

	visible_message("<span class='danger'>[src.name] lets out an ear piercing shriek!</span>",
			"<span class='danger'>You let out an ear-shattering shriek!</span>",
			"<span class='danger'>You hear a painfully loud shriek!</span>")

	playsound(loc, 'sound/voice/shriek1.ogg', 100, 1)

	var/list/victims = list()

	for (var/mob/living/carbon/human/T in hearers(2, src))
		if (T == src)
			continue

		if (istype(T) && (T:l_ear || T:r_ear) && istype((T:l_ear || T:r_ear), /obj/item/clothing/ears/earmuffs))
			continue

		to_chat(T, "<span class='danger'>You hear an ear piercing shriek and feel your senses go dull!</span>")
		T.Weaken(5)
		T.ear_deaf = 20
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

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src,"<span class='notice'>You cannot spray napalm in your current state.</span>")
		return

	last_special = world.time + 100
	playsound(loc, 'sound/species/shadow/grue_screech.ogg', 100, 1)
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
			D.reagents.add_reagent("greekfire", 200)
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
				vessel.add_reagent("blood",20*O.amount)
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
		addtimer(CALLBACK(G, /mob/living/carbon/human.proc/set_species, O.dna.species), 0)
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

	visible_message("<span class='notice'>\The [src] detaches \his [E]!</span>",
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

		src.drop_from_inventory(O)
		O.replaced(src)
		src.update_body()
		src.updatehealth()
		src.UpdateDamageIcon()

		update_body()
		updatehealth()
		UpdateDamageIcon()

		visible_message("<span class='notice'>\The [src] attaches \the [O] to \his body!</span>",
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

		output += "Current Charge Level: [nutrition]\n"

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
		addtimer(CALLBACK(GLOBAL_PROC, /proc/qdel, ping_image), 8)
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
		to_chat(src, span("notice", "You sense " + jointext(feedback, " ") + " towards the [dir2text(text2num(d))]."))
	if(!length(dirs))
		to_chat(src, span("notice", "You detect no psionic signatures but your own."))

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
		to_chat(src, span("notice", "You can't flick your tongue out with something covering your face."))
		return
	else
		custom_emote(1, "flicks their tongue out.")

	var/datum/gas_mixture/mixture = src.loc.return_air()
	var/total_moles = mixture.total_moles

	var/list/airInfo = list()
	if(total_moles>0)
		for(var/mix in mixture.gas)
			var/composition = "Non-existant"
			switch(round((mixture.gas[mix] / total_moles) * 100))
				if(0)
					composition = "Non-existent"
				if(0 to 5)
					composition = "Trace-amounts"
				if(5 to 15)
					composition = "Low-volume"
				if(15 to 60)
					composition = "Present"
				if(60 to 80) //nitrogen is usually at 78%
					composition = "High-volume"
				if(80 to INFINITY)
					composition = "Overwhelming"

			airInfo += span("notice", "[gas_data.name[mix]]: [composition]")
		airInfo += span("notice", "Temperature: [round(mixture.temperature-T0C)]&deg;C")
	else
		airInfo += span("notice", "There is no air around to sample!")

	last_special = world.time + 20

	if(airInfo?.len)
		to_chat(src, span("notice", "You sense the following in the air:"))
		for(var/line in airInfo)
			to_chat(src, span("notice", "[line]"))
		return

/mob/living/carbon/human/proc/crush()
	set category = "Abilities"
	set name = "Crush"
	set desc = "While grabbing someone in a neck grab, crush them with your arms."

	if(last_special > world.time)
		to_chat(src, "<span class='warning'>Your arms are still recovering!</span>")
		return

	if(use_check_and_message(usr))
		return

	var/obj/item/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(src, "<span class='warning'>You are not grabbing anyone.</span>")
		return

	if(G.state < GRAB_NECK)
		to_chat(src, "<span class='warning'>You must have a stronger grab to crush your prey!</span>")
		return

	if(ishuman(G.affecting))
		var/mob/living/carbon/human/H = G.affecting
		var/hit_zone = zone_sel.selecting
		var/obj/item/organ/external/affected = H.get_organ(hit_zone)

		if(!affected || affected.is_stump())
			to_chat(H, "<span class='danger'>They are missing that limb!</span>")
			return

		H.apply_damage(40, BRUTE, hit_zone)
		visible_message("<span class='warning'><b>\The [src]</b> viciously crushes [affected] of [G.affecting] with its metallic arms!</span>")
		msg_admin_attack("[key_name_admin(src)] crushed [key_name_admin(H)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(src),ckey_target=key_name(H))
	else
		var/mob/living/M = G.affecting
		if(!istype(M))
			return
		M.apply_damage(40,BRUTE)
		visible_message("<span class='warning'><b>\The [src]</b> viciously crushes [G.affecting]'s flesh with its metallic arms!</span>")
		msg_admin_attack("[key_name_admin(src)] crushed [key_name_admin(M)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(src),ckey_target=key_name(M))
	playsound(src.loc, 'sound/weapons/heavysmash.ogg', 50, 1)
	last_special = world.time + 100
