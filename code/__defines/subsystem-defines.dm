// -- SSprocessing stuff --
#define START_PROCESSING(Processor, Datum) if (!Datum.isprocessing) {Datum.isprocessing = 1;Processor.processing += Datum}
#define STOP_PROCESSING(Processor, Datum) Datum.isprocessing = 0;Processor.processing -= Datum


// -- SStimer stuff --
//Don't run if there is an identical unique timer active
#define TIMER_UNIQUE		0x1

//For unique timers: Replace the old timer rather then not start this one
#define TIMER_OVERRIDE		0x2

//Timing should be based on how timing progresses on clients, not the sever.
//	tracking this is more expensive,
//	should only be used in conjuction with things that have to progress client side, such as animate() or sound()
#define TIMER_CLIENT_TIME	0x4

//Timer can be stopped using deltimer()
#define TIMER_STOPPABLE		0x8

//To be used with TIMER_UNIQUE
//prevents distinguishing identical timers with the wait variable
#define TIMER_NO_HASH_WAIT  0x10

//number of byond ticks that are allowed to pass before the timer subsystem thinks it hung on something
#define TIMER_NO_INVOKE_WARNING 600

#define TIMER_ID_NULL -1

// -- SSatoms stuff --
// Technically this check will fail if someone loads a map mid-round, but that's not enabled right now.
#define SSATOMS_IS_PROBABLY_DONE (SSatoms.initialized == INITIALIZATION_INNEW_REGULAR)

//type and all subtypes should always call Initialize in New()
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
    ..();\
    if(!initialized) {\
        args[1] = TRUE;\
        SSatoms.InitAtom(src, args);\
    }\
}

// 	SSatoms Initialization state.
#define INITIALIZATION_INSSATOMS 0	//New should not call Initialize
#define INITIALIZATION_INNEW_MAPLOAD 1	//New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_REGULAR 2	//New should call Initialize(FALSE)

//	Initialize() hints for SSatoms.
#define INITIALIZE_HINT_NORMAL 0    //Nothing happens
#define INITIALIZE_HINT_LATELOAD 1  //Call LateInitialize
#define INITIALIZE_HINT_QDEL 2  //Call qdel on the atom
#define INITIALIZE_HINT_LATEQDEL 3	//Call qdel on the atom instead of LateInitialize


// -- SSoverlays --
#define CUT_OVERLAY_IN(ovr, time) addtimer(CALLBACK(src, /atom/.proc/cut_overlay, ovr), time, TIMER_STOPPABLE | TIMER_CLIENT_TIME)
#define ATOM_USING_SSOVERLAY(atom) (atom.our_overlays || atom.priority_overlays)

// -- SSticker --
#define ROUND_IS_STARTED (SSticker.current_state >= GAME_STATE_PLAYING)

// -- SSeffects --
// tick/process() return vals.
#define EFFECT_CONTINUE 0 	// Keep processing.
#define EFFECT_HALT 1		// Stop processing, but don't qdel.
#define EFFECT_DESTROY 2	// qdel.

// Effect helpers.
#define QUEUE_EFFECT(effect) if (!effect.isprocessing) {effect.isprocessing = TRUE; SSeffects.effect_systems += effect;}
#define QUEUE_VISUAL(visual) if (!visual.isprocessing) {visual.isprocessing = TRUE; SSeffects.visuals += visual;}
#define STOP_EFFECT(effect) effect.isprocessing = FALSE; SSeffects.effect_systems -= effect;
#define STOP_VISUAL(visual)	visual.isprocessing = FALSE; SSeffects.visuals -= visual;

// -- SSopenturf --
#define CHECK_OO_EXISTENCE(OO) if (OO && !isopenturf(OO.loc)) { qdel(OO); }
#define UPDATE_OO_IF_PRESENT CHECK_OO_EXISTENCE(bound_overlay); if (bound_overlay) { update_above(); }

// -- SSfalling --
#define ADD_FALLING_ATOM(atom) if (!atom.multiz_falling) { atom.multiz_falling = 1; SSfalling.falling[atom] = 0; }

// -- SSmachinery --
#define RECIPE_LIST(T) (SSmachinery.recipe_datums["[T]"])
