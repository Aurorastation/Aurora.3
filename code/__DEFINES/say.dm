/*
	Defines for use in saycode and text formatting.
	Currently contains speech spans and message modes
*/
#define SAY_MOD_VERB "say_mod_verb"

//Message modes. Each one defines a radio channel, more or less.
//if you use ! as a mode key for some ungodly reason, change the first character for ion_num() so get_message_mode() doesn't freak out with state law prompts - shiz.
#define MODE_HEADSET "headset"
#define MODE_ROBOT "robot"

#define MODE_R_HAND "right hand"
#define MODE_KEY_R_HAND "r"

#define MODE_L_HAND "left hand"
#define MODE_KEY_L_HAND "l"

#define MODE_INTERCOM "intercom"
#define MODE_KEY_INTERCOM "i"
#define MODE_TOKEN_INTERCOM ":i"

#define MODE_BINARY "binary"
#define MODE_KEY_BINARY "b"
#define MODE_TOKEN_BINARY ":b"

#define WHISPER_MODE "the type of whisper"
#define MODE_WHISPER "whisper"
#define MODE_WHISPER_CRIT "whispercrit"

#define MODE_DEPARTMENT "department"
#define MODE_KEY_DEPARTMENT "h"
#define MODE_TOKEN_DEPARTMENT ":h"

#define MODE_ADMIN "admin"
#define MODE_KEY_ADMIN "p"

#define MODE_DEADMIN "deadmin"
#define MODE_KEY_DEADMIN "d"

#define MODE_PUPPET "puppet"
#define MODE_KEY_PUPPET "j"

#define MODE_ALIEN "alientalk"
#define MODE_KEY_ALIEN "a"

#define MODE_HOLOPAD "holopad"
#define MODE_KEY_HOLOPAD "h"

//#define MODE_CHANGELING "changeling"
#define MODE_KEY_CHANGELING "g"
#define MODE_TOKEN_CHANGELING ":g"

#define MODE_VOCALCORDS "cords"
#define MODE_KEY_VOCALCORDS "x"

/// Automatically playing a set of lines
#define MODE_SEQUENTIAL "sequential"

/// Applies singing characters to the message
#define MODE_SING "sing"
/// A custom say emote is being supplied [value = the emote]
#define MODE_CUSTOM_SAY_EMOTE "custom_say"
/// No message is following, just emote
#define MODE_CUSTOM_SAY_ERASE_INPUT "erase_input"
/// Message is being relayed through another object
#define MODE_RELAY "relayed"

/// Mute. Can't talk.
#define TRAIT_MUTE "mute"

//Spans. Robot speech, italics, etc. Applied in compose_message().
#define SPAN_ROBOT "robot"
#define SPAN_YELL "yell"
#define SPAN_ITALICS "italics"
#define SPAN_SANS "sans"
#define SPAN_PAPYRUS "papyrus"
#define SPAN_REALLYBIG "reallybig"
#define SPAN_COMMAND "command_headset"
#define SPAN_CLOWN "clown"
#define SPAN_SINGING "singing"
#define SPAN_TAPE_RECORDER "tape_recorder"
#define SPAN_SMALL_VOICE "small"
#define SPAN_SOAPBOX "soapbox"

// Audio/Visual Flags. Used to determine what sense are required to notice a message.
#define MSG_VISUAL (1<<0)
#define MSG_AUDIBLE (1<<1)


// Say mode message handling return flags, exist for readability.
/// Say mode has handled the message.
#define SAYMODE_MESSAGE_HANDLED (1<<0)

// Used in visible_message_flags, audible_message_flags and runechat_flags
/// Automatically applies emote related spans/fonts/formatting to the message
#define EMOTE_MESSAGE (1<<0)
/// By default, self_message will respect the visual / audible component of the message.
/// Meaning that if the message is visual, and sourced from a blind mob, they will not see it.
/// This flag skips that behavior, and will always show the self message to the mob.
#define ALWAYS_SHOW_SELF_MESSAGE (1<<1)
/// Applies emphasis formatting to the message.
#define WITH_EMPHASIS_MESSAGE (1<<2)
/// Blocks chat highlighting from being applied to the message sent to the self.
#define BLOCK_SELF_HIGHLIGHT_MESSAGE (1<<3)

///Defines for priorities for the bubble_icon_override comp
#define BUBBLE_ICON_PRIORITY_ACCESSORY 2
#define BUBBLE_ICON_PRIORITY_ORGAN 1
