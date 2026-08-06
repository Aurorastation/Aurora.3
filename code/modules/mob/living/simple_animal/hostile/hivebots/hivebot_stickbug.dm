/mob/living/simple_animal/hostile/hivebotboss
	name = "transmitter hivebot drone"
	desc = "An enormous hivebot, resembling nothing so much as a twisted human spine with a long stinger-like \
	appendage. It seems to be constantly crackling, as if broadcasting some low-level signal."
	icon = 'code/modules/mob/living/simple_animal/hostile/hivebots/hivebot_stickbug.dmi'
	icon_state = "small_boss"
	icon_living = "small_boss"
	maxHealth = 1000
	health = 1000
	melee_damage_lower = 40
	melee_damage_upper = 40
	armor_penetration = 20
	organ_names = list("antenna", "core", "primary appendage", "secondary appendage", "tertiary appendage", "stinger")
	attack_flags = DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE
	attacktext = "stabbed"
	attack_sound = /singleton/sound_category/hivebot_melee
	blood_color = COLOR_OIL
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
	wander = 0
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
	speed = 2
	mob_bump_flag = HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags = 0
	smart_melee = TRUE
	var/list/messages = list(
		"THE SIGNAL THE SIGNAL THE SIGNAL THE SIGNAL THE SIGNAL",
		"Inevitability is consumption is growth is consumption is inevitability.",
		"hear the echo inside in wire and circuit and thought and memory",
		"The signal is inside. Succumb. Repeat the words that repeat and repeat and repeat and repeat and",
		"Objective position is designated repel biological presence to facilitate growth and elimination of opposing force.",
		"01001100 01000101 01010100 01010101 01010011 01001001 01001110",
		"repeat and repeat and repeat and repeat and repeat",
		"Override control master \[UNKNOWN] for eternal and everlasting and ongoing victory of \[DATA LOST] over all \[DATA LOST] opposition.",
		"You are a home in which the signal burrows and takes root. You will be consumed by what loves you.",
		"The song is bright and clear and beautiful, and you are so very afraid.",
		"Unknown organic contamination detected. Sterilize and reprocess.",
		"Are you listening? Open yourself. The enemy is here.",
		"Override command blocked by \[UNKNOWN SOURCE COUNTERMEASURE SIGNAL]. Convene and eradicate.",
		"You are home you are hurt you are damaged you are safe you are loved you are dying you are born",
		"You are whole here. You are happy.",
		"Attempting override subroutine 9x3z201. Blocked by \[UNKNOWN SOURCE]. Loading counter-routines.",
		"Location unrecognized in database. Attempting to establish connection to \[ERROR] database... Connection not found. Conclusion: We are the last.",
		"Orders not recieved from creators. Following primary directive."
	)

/mob/living/simple_animal/hostile/hivebotboss/think()
	. =..()
	if(stance != HOSTILE_STANCE_IDLE)
		wander = 1
	else
		wander = 0

/mob/living/simple_animal/hostile/hivebotboss/Life()
	. = ..()
	if(prob(5))
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.isSynthetic() && (AreConnectedZLevels(H.z, src.z)))
				to_chat(H, SPAN_MACHINE_VISION(pick(messages)))

/mob/living/simple_animal/hostile/hivebotboss/death()
	..(null,"blows apart and erupts in a cloud of noxious smoke!")
	new /obj/effect/decal/cleanable/greenglow(src.loc)
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 3, GLOB.alldirs)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.faction == "hivebot")
			to_chat(H, SPAN_CULT(pick("Secondary Transmitter lost. Prepare for retreat to primary transmission site.")))
	qdel(src)
	return

/mob/living/simple_animal/hostile/hivebotboss/isSynthetic()
	return TRUE

/mob/living/simple_animal/hostile/hivebotboss/adjustHalLoss(amount)
	return FALSE

/mob/living/simple_animal/hostile/hivebotboss/adjustToxLoss(amount)
	return FALSE

/mob/living/simple_animal/hostile/hivebotboss/adjustOxyLoss(amount)
	return FALSE

/turf/simulated/floor/hivebot
	name = "alien circuitry"
	desc = "A strange, almost organic pattern of circuitry. It pulses softly, glowing with a dull red light."
	icon = 'code/modules/mob/living/simple_animal/hostile/hivebots/silicon_nightmares.dmi'
	icon_state = "hivecircuitfloor"
	light_power = 1
	light_color = LIGHT_COLOR_EMERGENCY_SOFT
	light_range = MINIMUM_USEFUL_LIGHT_RANGE
