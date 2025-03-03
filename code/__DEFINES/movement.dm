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
