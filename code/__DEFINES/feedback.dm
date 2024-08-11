/// Generic feedback failure message handler.
#define FEEDBACK_FAILURE(USER, MSG) to_chat(USER, SPAN_WARNING(MSG))

/// Feedback messages intended for use in `use_*` overrides. These assume the presence of the `user` variable.
#define USE_FEEDBACK_FAILURE(MSG) FEEDBACK_FAILURE(user, MSG)
