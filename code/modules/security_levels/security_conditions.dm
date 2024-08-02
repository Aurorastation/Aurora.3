#define SECURITY_LEVEL_ANNOUNCEMENT_ELEVATED 1
#define SECURITY_LEVEL_ANNOUNCEMENT_LOWERED 2

/*####################
	SECURITY LEVELS
####################*/

/**
 * # Security level
 *
 * A security level is a condition that can be set to represent the security status of the ship/station
 */
/datum/security_level
	abstract_type = /datum/security_level

	/// The name of the security level
	var/name

	/// A numerical representation of the threat level the ship/station is facing, with 1 being the highest threat level
	var/threat_level_numerical

	/// A general description of the condition
	var/description

	/**
	 * The color of the lights when the security level is activated, one of `LIGHT_COLOR_*`
	 *
	 * If not set, the color will be determined according to the threat level by the lighting subsystem
	 */
	var/lights_color

	/**
	 * A list of `datum/security_level_announcement`,
	 * the announcements to be made when the security level is activated
	 *
	 * First element is the announcement when the security level is elevated to this level,
	 * second element (if present) is the announcement when the condition is lowered to this level
	 *
	 * If the second element is not present, the first element will be used for both
	 */
	var/list/datum/security_level_announcement/announcements = list()

/**
 * Handles the announcements for this security level
 */
/datum/security_level/proc/announce()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	var/datum/security_level_announcement/announcement_to_play = announcements[SECURITY_LEVEL_ANNOUNCEMENT_ELEVATED]
	var/lowering_message

	//If we are lowering, see if we have a specific lowering announcement, if so, set it; also, set the lowering message of the previous level
	if(SSsecurity_level.get_current_level_as_number() < threat_level_numerical)
		if(length(announcements) == SECURITY_LEVEL_ANNOUNCEMENT_LOWERED)
			announcement_to_play = announcements[SECURITY_LEVEL_ANNOUNCEMENT_LOWERED]

		var/datum/security_level_announcement/previous_level_announcement = SSsecurity_level.current_security_level.announcements[SECURITY_LEVEL_ANNOUNCEMENT_ELEVATED]

		// previous_level_announcement = new previous_level_announcement()

		lowering_message = previous_level_announcement.get_announcement_lowering_message()

	// announcement_to_play = new announcement_to_play()

	//If we have a sound to play, use it, otherwise use the default sound
	var/sound_to_play_path = announcement_to_play.get_sound()
	if(!sound_to_play_path)
		sound_to_play_path = 'sound/misc/announcements/security_level.ogg'

	var/sound/sound_to_play = sound(sound_to_play_path, channel = CHANNEL_BOSS_MUSIC)

	//Make the announcement
	var/datum/announcement/priority/security/security_announcement_sound = new(do_log = FALSE, do_newscast = TRUE, new_sound = sound_to_play)

	security_announcement_sound.Announce("[announcement_to_play.get_announcement_message()][(lowering_message) ? "<br>[lowering_message]" : ""]",
											announcement_to_play.get_announcement_title(), msg_sanitized = TRUE)



/*#################################
		SECURITY LEVELS TYPES
#################################*/

/datum/security_level/condition_one
	name = "Condition One"
	threat_level_numerical = 1
	description = "Confirmed, active threat to the ship or the virtual totality of the crew."
	lights_color = LIGHT_COLOR_EMERGENCY
	announcements = list(
		new /datum/security_level_announcement/condition_one
		)

/datum/security_level/condition_one/announce()
	. = ..()

	post_display_status("alert", "deltaalert")



/datum/security_level/condition_two
	name = "Condition Two"
	threat_level_numerical = 2
	description = "Confirmed, active threat to the ship or a significant portion of the crew."
	lights_color = LIGHT_COLOR_EMERGENCY_SOFT
	announcements = list(
		new /datum/security_level_announcement/condition_two,
		new /datum/security_level_announcement/condition_two/lowered
		)

/datum/security_level/condition_two/announce()
	. = ..()

	post_display_status("alert", "redalert")


/datum/security_level/condition_three
	name = "Condition Three"
	threat_level_numerical = 3
	description = "Suspected hostile threat that targets the ship, a shuttle or a portion of the crew."
	lights_color = LIGHT_COLOR_BLUE
	announcements = list(
		new /datum/security_level_announcement/condition_three,
		new /datum/security_level_announcement/condition_three/lowered
		)

/datum/security_level/condition_three/announce()
	. = ..()

	post_display_status("alert", "bluealert")


/datum/security_level/condition_four
	name = "Condition Four"
	threat_level_numerical = 4
	description = "Unusual activity detected or suspected, with no or minimal threat to the ship or crew."
	announcements = list(
		new /datum/security_level_announcement/condition_four,
		new /datum/security_level_announcement/condition_four/lowered
		)

/datum/security_level/condition_five
	name = "Condition Five"
	threat_level_numerical = 5
	description = "Standard operational status, no threat to the ship or crew."
	announcements = list(
		new /datum/security_level_announcement/condition_five,
		new /datum/security_level_announcement/condition_five/lowered
		)



/*#################################
	SECURITY LEVEL ANNOUNCEMENTS
#################################*/

/**
 * # Security level announcement
 *
 * An announcement that is played/broadcasted when a security level is activated
 */
/datum/security_level_announcement
	abstract_type = /datum/security_level_announcement

	/// The announcement title
	VAR_PROTECTED/title

	/// The announcement message
	VAR_PROTECTED/message

	/// A message added at the end of the new level announcement, when lowering from this level
	VAR_PROTECTED/lowering_message

	/// The announcement sound
	VAR_PROTECTED/sound = 'sound/misc/announcements/security_level.ogg'

/**
 * Returns the announcement message
 */
/datum/security_level_announcement/proc/get_announcement_message()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	return message

/**
 * Returns the lowering message
 */
/datum/security_level_announcement/proc/get_announcement_lowering_message()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	return lowering_message

/**
 * Returns the announcement title
 */
/datum/security_level_announcement/proc/get_announcement_title()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	return title

/**
 * Returns the announcement sound
 */
/datum/security_level_announcement/proc/get_sound()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	return sound

/*##########################################
		SECURITY ANNOUNCEMENT TYPES
##########################################*/

/datum/security_level_announcement/condition_one
	title = "Condition One, General Quarters."
	message = "The ship's security level has been elevated to Condition One, There is an extreme threat or danger on or near the ship. \
				All personnel must assist, follow orders, and work to resolve the situation. Listen to the chain of command - " + SPAN_DANGER("disobedience may be met with lethal force.")
	lowering_message = "Stand down general quarters."
	sound = 'sound/effects/siren.ogg'

/datum/security_level_announcement/condition_two
	title = "Condition Two, High Threat."
	message = "The ship's security level has been elevated to Condition Two, there is a highly dangerous threat or danger on or near the ship.\
				All personnel must have their sensors turned to the maximum setting. Listen to all orders from Command and emergency personnel. " + SPAN_DANGER("Martial law is in effect.")
	lowering_message = "Martial law is no longer in effect."
	sound = 'sound/effects/high_alert.ogg'

/datum/security_level_announcement/condition_two/lowered
	message = "The ship's security level has been lowered to Condition Two, a highly dangerous threat or danger on or near the ship persists, but not all personnel are required to assist. \
	Listen to all orders from Command and emergency personnel. " + SPAN_DANGER("Martial law is in effect.")
	lowering_message = "Martial law is no longer in effect."

/datum/security_level_announcement/condition_three
	title = "Condition Three, Confirmed Threat."
	message = "The ship's security level has been elevated to Condition Three. There is a confirmed threat or danger on or near the ship.\
				Security personnel may have weapons drawn. Privacy laws are no longer in effect. Please follow advice from Command and emergency personnel."

/datum/security_level_announcement/condition_three/lowered
	message = "The ship's security level has been lowered to Condition Three, a confirmed threat or danger on or near the ship persists, but widespread assistance is not required. \
				Please continue to follow advice from Command and emergency personnel."

/datum/security_level_announcement/condition_four
	title = "Condition Four, Suspected Threat."
	message = "The ship's security level has been elevated to Condition Four. There is a suspected threat or danger on or near the ship.\
				Security personnel may have weapons visible, but holstered."

/datum/security_level_announcement/condition_four/lowered
	message = "The ship's security level has been lowered to Condition Four, a suspected threat or danger on or near the ship persists, but it is believed that the appropriate personnel \
					can handle the situation. Security personnel may have weapons visible, but holstered."

/datum/security_level_announcement/condition_five
	title = "Standard Operational Status."
	message = "There are no active threats to the ship or crew."

/datum/security_level_announcement/condition_five/lowered
	message = "There are no more active or suspected threats to the ship or crew, all personnel, please resume standard operations."

#undef SECURITY_LEVEL_ANNOUNCEMENT_ELEVATED
#undef SECURITY_LEVEL_ANNOUNCEMENT_LOWERED
