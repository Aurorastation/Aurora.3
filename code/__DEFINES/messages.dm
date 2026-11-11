/// Default local range for visible/audible messages and balloon alerts.
#define DEFAULT_MESSAGE_RANGE 7

// Shared by visible_message_flags and audible_message_flags.
/// Format an emote and display overhead text to listeners who perceive it.
#define EMOTE_MESSAGE (1<<0)
/// Deliver explicit self feedback even if its primary sense is unavailable.
#define ALWAYS_SHOW_SELF_MESSAGE (1<<1)
/// Apply the configured chat emphasis markup parser.
#define WITH_EMPHASIS_MESSAGE (1<<2)
/// Suppress chat highlighting on explicit self feedback.
#define BLOCK_SELF_HIGHLIGHT_MESSAGE (1<<3)
/// Limit delivery to local recipients, including nearby observers.
#define LOCAL_MESSAGE (1<<4)
