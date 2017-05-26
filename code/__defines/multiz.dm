/**
 * Bitflags for handling can_fall return. Determines which chains SSfalling should
 * execute for a mob in case of can_fall failure.
 */
#define FALL_STOP_NOW		0x1
#define FALL_INVOKE_THROUGH	0x2
#define FALL_INVOKE_IMPACT	0x4
