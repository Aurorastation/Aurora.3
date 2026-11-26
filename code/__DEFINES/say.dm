/* Shared speech metadata and preparation results. */

/// Speech attribution, such as says, asks, or transmits.
#define SAY_MOD_VERB "say_mod_verb"
/// Optional text appended after the resolved speaker name.
#define SAY_MOD_NAME_SUFFIX "say_name_suffix"
/// A transmitted identity captured when the event is created, independent of the emitter.
#define MODE_SPEAKER_NAME_OVERRIDE "speaker_name_override"
/// Local amplified presentation; does not imply radio transport or increased range.
#define MODE_AMPLIFIED "amplified"
/// Parsed mob radio/mode prefix, carried into the shared builder.
#define SAY_MOD_MESSAGE_MODE "say_message_mode"
/// Message is being relayed through another object.
#define MODE_RELAY "relayed"

/// Preparation completed and local dispatch should continue.
#define SAY_PREPARE_CONTINUE 1
/// A specialized route consumed the message successfully.
#define SAY_PREPARE_HANDLED 2
