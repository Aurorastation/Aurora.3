// Big, mean hivebot with incendiary ammunition. For use in boss battles.
// The Life() code for rampancy messages should be scrubbed if rampancy is ever made a proper subsystem.
/mob/living/simple_animal/hostile/hivebotboss
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
	ranged = TRUE
	speed = -2
	mob_swap_flags = ROBOT
	mob_push_flags = ALLMOBS
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

/mob/living/simple_animal/hostile/hivebotboss/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	if(istype(hitting_projectile, /obj/projectile/bullet/pistol/hivebotspike) || istype(hitting_projectile, /obj/projectile/beam/hivebot))
		return BULLET_ACT_BLOCK
	else
		. = ..()

/mob/living/simple_animal/hostile/hivebotboss/Initialize(mapload)
	. = ..()
	add_language(LANGUAGE_HIVEBOT)
	var/number = rand(1000,9999)
	name = initial(name) + " ([number])"
	real_name = name
	default_language = GLOB.all_languages[LANGUAGE_HIVEBOT]

/mob/living/simple_animal/hostile/hivebotboss/update_icon()
	..()
	if(resting || stat == DEAD)
		blood_overlay_icon = 'icons/mob/npc/blood_overlay.dmi'
	else
		blood_overlay_icon = initial(blood_overlay_icon)
	handle_blood(TRUE)

/mob/living/simple_animal/hostile/hivebotboss/get_blood_overlay_name()
	if(stance == HOSTILE_STANCE_IDLE)
		return "blood_overlay"
	else
		return "blood_overlay_armed"

/mob/living/simple_animal/hostile/hivebotboss/think()
	. =..()
	if(stance != HOSTILE_STANCE_IDLE)
		wander = 1
	else
		wander = 0

/mob/living/simple_animal/hostile/hivebotboss/Life()
	. = ..()
	adjustBruteLoss(-5)
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
			to_chat(H, SPAN_MACHINE_DANGER(pick("Secondary Transmitter lost. Prepare for retreat to primary transmission site.")))
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

/mob/living/simple_animal/hostile/hivebot/hivebotboss/verb/build_beacon()
	set name = "Assemble beacon"
	set desc = "Assemble a hivebot beacon."
	set category = "Hivebot"

	src.visible_message("\The [src] begins to construct a hivebot beacon.", "You begin to construct a hivebot beacon.", "You hear the sounds of fabrication...")
	if(!do_after(src, 12 SECONDS))
		return
	src.visible_message("\The [src] constructs a hivebot beacon!", "You construct a hivebot beacon!")
	new /mob/living/simple_animal/hostile/hivebotbeacon(get_turf(src))
