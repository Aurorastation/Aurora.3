/**
 * Storytelling Holograms
 * Compatible to use in any maps. Ported and adapted from Paradise Station.
 *
 * How does it work?
 * * Once a player crosses a 'step_trigger' placed by this object, it activates the holopad.
 * * Hologram repeats the things written in 'list/things_to_say' in a loop.
 */
/obj/structure/environmental_storytelling_holopad
	name = "holopad"
	desc = "It's a floor-mounted device for projecting holographic images."
	icon = 'icons/obj/holopad.dmi'
	icon_state = "holopad0"
	anchored = TRUE
	layer = ABOVE_TILE_LAYER

	/// Have we been activated? If we have, we do not activate again.
	var/activated = FALSE

	/// Tied effect to kill when we die.
	var/obj/effect/overlay/our_holo

	/// Name of who we are speaking as.
	var/speaking_name = "placeholder"

	/// Appearance of the hologram.
	var/mob/holo_icon

	/// An assoc list of things to say. Key should contain the actual dialogue string, value will dictate whether the key is an emote or regular say.
	/// eg: list("Billions must code a silly functionality!" = "says", "smiles like :)" = "emote")
	/// If value is "emote", it will do an emote. Any other value will be displayed in the text along with the key.
	var/list/things_to_say = list(
		"Hi future coders." = "says",
		"Welcome to real lore hologram hours." = "says sagely",
		"People should have fun with these!" = "yells",
		"does an emote because they can." = "emote"
		)

	/// The sounds our hologram makes when it speaks. Supports singleton sound categories. Null by default.
	var/list/soundblock

	/// How long do we sleep between messages? 5 seconds by default.
	var/loop_sleep_time = 5 SECONDS

	/// Seconds integer. If set, the hologram will wait the set amount of seconds before making its speech. This applied only once and is null by default.
	var/sleep_before_speak = 5 SECONDS

	/// Accent tag of the holo. By default it's Text-to-Speech. For the full list, see: '_DEFINES/background.dm'
	var/holo_accent_tag = ACCENT_TTS

	/// The language our hologram will speak. Tau Ceti by default. For the full list, see: '_DEFINES/species_languages.dm'
	var/language = LANGUAGE_TCB

	/// How long should be the radius of step_triggers to place? 2 by default, so we get 5x5 area covered.
	var/trigger_radius = 2

	/// List of step_triggers associated with this instance.
	var/list/step_trigger_group = list()

	/// Hologram icon path.
	var/holo_icon_path = 'icons/mob/AI.dmi'
	var/holo_icon_state = "floating_face_glitchy"

	/// Hex colour of the hologram.
	var/holo_color = COLOR_SILVER

/obj/structure/environmental_storytelling_holopad/mechanics_hints()
	. += ..()
	. += "This is a special holopad allows you to listen messages recorded in it. You may <b>left click</b> this [src] to replay the recorded message!"

/obj/structure/environmental_storytelling_holopad/Initialize(mapload)
	. = ..()
	if(mapload) // give it some time for the map to initialize
		addtimer(CALLBACK(src, PROC_REF(set_the_triggers)), 3 MINUTES)
	else
		set_the_triggers()


/obj/structure/environmental_storytelling_holopad/Destroy()
	QDEL_NULL(our_holo)
	QDEL_LAZYLIST(step_trigger_group)
	return ..()

/obj/structure/environmental_storytelling_holopad/proc/set_the_triggers()
	for(var/turf/I in range(trigger_radius, src))
		var/obj/effect/step_trigger/holopad/H = new(I)
		H.tied_holopad = src
		step_trigger_group += H

/obj/structure/environmental_storytelling_holopad/proc/start_message()
	if(activated)
		return

	QDEL_LAZYLIST(step_trigger_group)
	activated = TRUE
	holo_icon = new /mob/abstract(src)
	holo_icon.set_invisibility(0)
	holo_icon.icon = icon(holo_icon_path, holo_icon_state)
	holo_icon.accent = holo_accent_tag
	holo_icon.name = speaking_name
	icon_state = "holopad2"
	update_icon()
	var/obj/effect/overlay/hologram = new(get_turf(src))
	our_holo = hologram
	hologram.appearance = holo_icon.appearance
	hologram.alpha = 150
	hologram.color = holo_color
	hologram.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	hologram.layer = FLY_LAYER
	hologram.anchored = TRUE
	hologram.set_light(2, 1, holo_color)
	hologram.pixel_y = 16
	hologram.name = speaking_name

	for(var/I in things_to_say)
		if(sleep_before_speak)
			sleep(sleep_before_speak)
			sleep_before_speak = null

		if(things_to_say[I] == "emote")
			holo_icon.custom_emote(AUDIBLE_MESSAGE, "[I]")
			sleep(loop_sleep_time)
			continue

		hologram.langchat_speech("[I]", get_hearers_in_view(7, src), skip_language_check = TRUE)
		for(var/mob/living/L in get_hearers_in_view(7, src))
			L.hear_say("[I]", "[things_to_say[I]]", GLOB.all_languages[language], speaker = holo_icon)
		if(soundblock)
			playsound(get_turf(src), text2path(soundblock), 60, FALSE)
		sleep(loop_sleep_time)

	QDEL_NULL(our_holo)
	icon_state = "holopad0"
	activated = FALSE

/obj/structure/environmental_storytelling_holopad/attack_hand(mob/user)
	if(activated)
		to_chat(user, SPAN_WARNING("\The [src] is already active!"))
		return

	user.visible_message(SPAN_NOTICE("<b>[user]</b> presses their foot down on \the [src], replays the holopad message."),
	SPAN_NOTICE("You press your foot down on \the [src], it replays the message."))
	start_message()

// ---- Step trigger for holopads

/obj/effect/step_trigger/holopad
	name = "I shouldn't be placed by hand!"
	players_only = TRUE
	mobs_only = TRUE

	var/obj/structure/environmental_storytelling_holopad/tied_holopad

/obj/effect/step_trigger/holopad/Trigger()
	tied_holopad.start_message()

// ---- Base type
/obj/structure/environmental_storytelling_holopad/quarantined_outpost
	speaking_name = "Amalthea"
	holo_accent_tag = ACCENT_SOL
	holo_color = COLOR_PURPLE_GRAY
	loop_sleep_time = 12 SECONDS
	soundblock = "/singleton/sound_category/robot_talk"
	things_to_say = list()

/obj/structure/environmental_storytelling_holopad/quarantined_outpost/greet
	things_to_say = list(
		"Welcome, visitors. Your arrival constitutes an unschedul—sched... vi—visit to Sovereign Alliance pro—prop...erty." = "examines the visitors one by one, then says in a glitchy tone",
		"This anomaly has been logged. Please refrain from committing further trespass." = "states flatly",
		"This unit is designated as Amalthea, facility intelligence of S-S-F Nemora. This unit informs, this is not an appropriate time for visitation." = "adds monotonously",
		"This facility is currently under quarantine measures, as per Directorate directives and universal biohazard safety protocols." = "says",
		"Th# #nt—itie@#s po#sess... a lif# threa—... danger... Recommended co—courzzzzt... leave..." = "'s transmission abruptly broken into static, its words are now fractured into noise",
	)

/obj/structure/environmental_storytelling_holopad/quarantined_outpost/console_inform
	things_to_say = list(
		"Facility's internal network has been neglected for ERR#... cycles, as much can be stated for the rest of systems." = "abruptly explains",
		"This unit has a proposal. Your presence here will be permitted to provide assistance to maintenance crew, who are currently otherwise engaged, presumed missing or deceased." = "says after a moment of pause",
		"As for compensation, your valiant efforts for the Greater Alliance will be mentioned in facility logs, addition to discussing a further agreement when the ne—ne—xtzzzzzt... director is appointed." = "says",
		"For now, you will run into terminals similar to this one throughout the facility. They were repurposed to display tracking scan results for public access." = "says",
		"Provided the link is established manually, it may prove to be crucial for neutralizing current outbreak." = "says",
		"Nearest server relay is located at: cargo bay. You will find it at eastern wing, into the maintenance tunnels." = "says",
		"There are one more located at atmospherics and another one accessible through hallway, outside of medical ward. Activating either one of the relays is likely to be sufficient." = "says"
	)

/obj/structure/environmental_storytelling_holopad/quarantined_outpost/engineering_inform
	things_to_say = list(
		"Despite the engineering's best attempts to optimise the power consumption and provide a controlled combustion ignition, they had to shut the systems down to save what remains for the moment of need." = "says",
		"Some systems may still experience stutter, especially after such an extended period of sleep." = "says",
		"Remaining gas supply is likely to be sufficient to power the facility once more time. East from here, across the rift is where the extraction laboratory located at." = "says",
		"Laboratory remains sealed and can only be unlocked from its checkpoint, which is located at the other side of this floor." = "says",
		"Please excercise extreme caution." = "says"
	)

/obj/structure/environmental_storytelling_holopad/quarantined_outpost/extraction_lab_inform
	things_to_say = list(
		"This laboratory is built on top a rift which was initially discovered by first expedition members sent by Department of Colonization." = "informs",
		"It is also assumed to be the same location where the team in question went missing. Deep within is where the unidentified energy signature is originated at." = "says",
		"There has been many attempts before the outbreak to understand what lies beneath, ranging from expedition to excavation. Each determined attempt was met with unideal consequences." = "says",
		"This machinery, while this unit must inform that it is not at any liberty to disclose the details, is designed to extract the samples required for the next step." = "says",
		"However, this will necessitate a thorough preparation. Firstly, this until will not permit activating the machine until the floor is neutralized from threats." = "says after a brief pause",
		"Secondly, five sample canisters will be required to be brought to this room. First two conditions can be fulfilled with the help of tracking scanners, accessible in the public terminals." = "says",
		"Lastly, it is highly recommended to barricade the laboratory. It is safe to assume below this rift is swarmed by the entities and the noise caused by the extraction process will alert a big majority of them." = "says, emphasizing on certain words",
		"Their muscle tissues are developed enough to allow them break the walls apart, therefore it is advised to not rely on the wall barricades." = "says",
		"Protect the machine, otherwise the operation will be a failure." = "says"
	)
