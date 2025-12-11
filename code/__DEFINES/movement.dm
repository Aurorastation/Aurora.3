/// The minimum for glide_size to be clamped to.
#define MIN_GLIDE_SIZE 1
/// The maximum for glide_size to be clamped to.
/// This shouldn't be higher than the icon size, and generally you shouldn't be changing this, but it's here just in case.
#define MAX_GLIDE_SIZE ICON_SIZE_ALL

/// Compensating for time dilation
GLOBAL_VAR_INIT(glide_size_multiplier, 1.0)

///Broken down, here's what this does:
/// divides the world icon_size by delay divided by ticklag to get the number of pixels something should be moving each tick.
/// The division result is given a min value of 1 to prevent obscenely slow glide sizes from being set
/// Then that's multiplied by the global glide size multiplier. 1.25 by default feels pretty close to spot on. This is just to try to get byond to behave.
/// The whole result is then clamped to within the range above.
/// Not very readable but it works
#define DELAY_TO_GLIDE_SIZE(delay) (clamp(((ICON_SIZE_ALL / max((delay) / world.tick_lag, 1)) * GLOB.glide_size_multiplier), MIN_GLIDE_SIZE, MAX_GLIDE_SIZE))

///Similar to DELAY_TO_GLIDE_SIZE, except without the clamping, and it supports piping in an unrelated scalar
#define MOVEMENT_ADJUSTED_GLIDE_SIZE(delay, movement_disparity) (ICON_SIZE_ALL / ((delay) / world.tick_lag) * movement_disparity * GLOB.glide_size_multiplier)

//Movement loop priority. Only one loop can run at a time, this dictates that
// Higher numbers beat lower numbers
///Standard, go lower then this if you want to override, higher otherwise
#define MOVEMENT_DEFAULT_PRIORITY 10
///Very few things should override this
#define MOVEMENT_SPACE_PRIORITY 100
///Higher then the heavens
#define MOVEMENT_ABOVE_SPACE_PRIORITY (MOVEMENT_SPACE_PRIORITY + 1)

//Movement loop flags
///Should the loop act immediately following its addition?
#define MOVEMENT_LOOP_START_FAST (1<<0)
///Do we not use the priority system?
#define MOVEMENT_LOOP_IGNORE_PRIORITY (1<<1)
///Should we override the loop's glide?
#define MOVEMENT_LOOP_IGNORE_GLIDE (1<<2)
///Should we not update our movables dir on move?
#define MOVEMENT_LOOP_NO_DIR_UPDATE (1<<3)
///Is the loop moving the movable outside its control, like it's an external force? e.g. footsteps won't play if enabled.
#define MOVEMENT_LOOP_OUTSIDE_CONTROL (1<<4)

// Movement loop status flags
/// Has the loop been paused, soon to be resumed?
#define MOVELOOP_STATUS_PAUSED (1<<0)
/// Is the loop running? (Is true even when paused)
#define MOVELOOP_STATUS_RUNNING (1<<1)
/// Is the loop queued in a subsystem?
#define MOVELOOP_STATUS_QUEUED (1<<2)

//Index defines for movement bucket data packets
#define MOVEMENT_BUCKET_TIME 1
#define MOVEMENT_BUCKET_LIST 2

//Diagonal movement is split into two cardinal moves
/// The first step of the diagnonal movement
#define FIRST_DIAG_STEP 1
/// The second step of the diagnonal movement
#define SECOND_DIAG_STEP 2

///Return values for moveloop Move()
#define MOVELOOP_FAILURE 0
#define MOVELOOP_SUCCESS 1
#define MOVELOOP_NOT_READY 2
