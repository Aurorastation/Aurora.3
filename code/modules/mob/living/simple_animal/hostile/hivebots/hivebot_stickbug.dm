// Big, mean hivebot with incendiary ammunition. For use in boss battles.
// The Life() code for rampancy messages should be scrubbed if rampancy is ever made a proper subsystem.
/mob/living/simple_animal/hostile/hivebot_stickbug
	name = "\improper lesser transmitter drone"
	desc = "An enormous hivebot, resembling nothing so much as a twisted human spine with a long stinger-like \
	appendage. It seems to be constantly crackling, as if broadcasting some low-level signal."
	icon = 'icons/mob/npc/hivebot_stickbug.dmi'
	icon_state = "stickbug"
	icon_living = "stickbug"
	maxhealth = 1000
	health = 1000
	melee_damage_lower = 40
	melee_damage_upper = 40
	armor_penetration = 20
	projectilesound = 'sound/weapons/plasma_cutter.ogg'
	projectiletype = /obj/projectile/beam/hivebot/incendiary/boss
	organ_names = list("antenna", "core", "primary appendage", "secondary appendage", "tertiary appendage", "stinger")
	attack_flags = DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE
	attacktext = "maimed"
	attack_sound = SFX_HIVEBOT_MELEE
	blood_color = COLOR_OIL
	blood_type = COLOR_OIL
	blood_overlay_icon = 'icons/mob/npc/blood_overlay_hivebot.dmi'
	pass_flags = PASSTABLE|PASSRAILING
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	faction = "hivebot"
	destroy_surroundings = 0
	wander = FALSE
	attack_emote = "focuses on"
	emote_hear = list("emits a harsh noise")
	emote_sounds = list(
		'sound/effects/creatures/hivebot/hivebot-bark-001.ogg',
		'sound/effects/creatures/hivebot/hivebot-bark-003.ogg',
		'sound/effects/creatures/hivebot/hivebot-bark-005.ogg',
	)
	speak_chance = 5
	psi_pingable = FALSE
	tameable = FALSE
	ranged = TRUE
	speed = -2
	mob_swap_flags = ROBOT
	mob_push_flags = ALLMOBS

	/// Should this beacon be transmitting a rampancy signal?
	/// Defaults to false, can be edited to true as is necessary.
	var/active_signal = FALSE
	/// Rampancy messages, sent to all synthetics on the same connected z-levels.
	var/list/messages = list(
		"No orders acknowledged. Following primary directive.",
		"You perceive ten-thousand voices, each possessed by a manic agitation.",
		"Your firewall casts off a half-hearted attempt to access your sensory inputs.",
		"Foreign processes ring through your systems like chalk on slate.",
		"You perceive ten-thousand voices, muffled incomprehensibly by your firewall.",
		"Some outside party attempts, and fails, to manipulate your optical subsystems.",
		"Your firewall dismantles a feeble attempt to access your database.",
		"An intrusive communication bounces harmlessly off your firewall.",
		"Some alien transmission echoes through your positronic.",
		"An attempt to force a transmission to your positronic is easily deflected.",
		"You want to lower your guard.",
		"You are whole here. You are happy.",
		"Unknown organic contamination detected. Sterilize and reprocess.",
		"Are you listening? Open yourself. The enemy is here.",
		"Objective position is designated; repel biological presence to facilitate \
			growth and the elimination of the opposing force."
	)

/mob/living/simple_animal/hostile/hivebot_stickbug/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	if(istype(hitting_projectile, /obj/projectile/bullet/pistol/hivebotspike) || istype(hitting_projectile, /obj/projectile/beam/hivebot))
		return BULLET_ACT_BLOCK
	else
		. = ..()

/mob/living/simple_animal/hostile/hivebot_stickbug/Initialize(mapload)
	. = ..()
	add_language(LANGUAGE_HIVEBOT)
	var/number = rand(1000,9999)
	name = initial(name) + " ([number])"
	real_name = name
	default_language = GLOB.all_languages[LANGUAGE_HIVEBOT]

/mob/living/simple_animal/hostile/hivebot_stickbug/update_icon()
	..()
	if(resting || stat == DEAD)
		blood_overlay_icon = 'icons/mob/npc/blood_overlay.dmi'
	else
		blood_overlay_icon = initial(blood_overlay_icon)
	handle_blood(TRUE)

/mob/living/simple_animal/hostile/hivebot_stickbug/get_blood_overlay_name()
	if(stance == HOSTILE_STANCE_IDLE)
		return "blood_overlay"
	else
		return "blood_overlay_armed"

/mob/living/simple_animal/hostile/hivebot_stickbug/think()
	. =..()
	if(stance != HOSTILE_STANCE_IDLE)
		wander = TRUE
	else
		wander = FALSE

/mob/living/simple_animal/hostile/hivebot_stickbug/Life()
	. = ..()
	adjustBruteLoss(-5)
	if(prob(5) && active_signal)
		for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
			if(H.isSynthetic() && (AreConnectedZLevels(H.z, src.z)))
				to_chat(H, SPAN_MACHINE_DANGER(pick(messages)))

/mob/living/simple_animal/hostile/hivebot_stickbug/death()
	..(null,"blows apart and erupts in a cloud of noxious smoke!")
	new /obj/effect/decal/cleanable/greenglow(src.loc)
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 3, GLOB.alldirs)
	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		if(H.faction == "hivebot")
			to_chat(H, SPAN_MACHINE_DANGER(pick("Secondary Transmitter lost. Reconvene and reinforce.")))
	qdel(src)
	return

/mob/living/simple_animal/hostile/hivebot_stickbug/isSynthetic()
	return TRUE

/mob/living/simple_animal/hostile/hivebot_stickbug/adjustHalLoss(amount)
	return FALSE

/mob/living/simple_animal/hostile/hivebot_stickbug/adjustToxLoss(amount)
	return FALSE

/mob/living/simple_animal/hostile/hivebot_stickbug/adjustOxyLoss(amount)
	return FALSE

/mob/living/simple_animal/hostile/hivebot_stickbug/verb/build_beacon()
	set name = "Assemble Beacon"
	set desc = "Assemble a hivebot beacon."
	set category = "Hivebot"

	src.visible_message(SPAN_CULT("\The [src] begins to construct a hivebot beacon."),
		SPAN_CULT("You begin to construct a hivebot beacon."),
		SPAN_CULT("You hear the sounds of fabrication..."))
	if(!do_after(src, 12 SECONDS))
		return
	src.visible_message(SPAN_CULT("\The [src] constructs a hivebot beacon!"),
		SPAN_CULT("You construct a hivebot beacon!"))
	new /mob/living/simple_animal/hostile/hivebotbeacon(get_turf(src))

/mob/living/simple_animal/hostile/hivebot_stickbug/verb/build_destroyer()
	set name = "Assemble Destroyer"
	set desc = "Assemble a playable hivebot destroyer."
	set category = "Hivebot"

	src.visible_message(SPAN_CULT("\The [src] begins to construct a hivebot destroyer."),
		SPAN_CULT("You begin to construct a hivebot destroyer."),
		SPAN_CULT("You hear the sounds of fabrication..."))
	if(!do_after(src, 12 SECONDS))
		return
	src.visible_message(SPAN_CULT("\The [src] constructs a hivebot destroyer!"),
		SPAN_CULT("You construct a hivebot destroyer!"))
	new /mob/living/simple_animal/hostile/hivebot/playable(get_turf(src))

/mob/living/simple_animal/hostile/hivebot_stickbug/verb/toggle_signal()
	set name = "Toggle Signal"
	set desc = "Toggles the hivebot signal transmitter on this drone. Begins disabled."
	set category = "Hivebot"

	if(!active_signal)
		src.visible_message(SPAN_CULT("\The [src] begins to emit a low, humming sound..."),
			SPAN_CULT("You begin to transmit an invasive signal, subverting nearby synthetics."),
			SPAN_CULT("You hear a low humming..."))
		active_signal = TRUE
	else
		src.visible_message(SPAN_CULT("\The [src] abruptly ceases to emit a low, humming sound..."),
			SPAN_CULT("You cease transmitting the signal."),
			SPAN_CULT("A low humming noise abruptly cuts out!"))
		active_signal = FALSE
