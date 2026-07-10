/mob
	density = TRUE
	layer = MOB_LAYER
	animate_movement = 2
	movable_flags = MOVABLE_FLAG_PROXMOVE
	sight = DEFAULT_SIGHT
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	pass_flags_self = PASSMOB
	/// Determines what the alpha of the lighting is to this mob.
	var/lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	var/datum/mind/mind
	var/static/next_mob_id = 0

	// Client and client-adjacent worries
	/// Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled
	var/client/my_client
	/// It's like a client, but persists! Persistent clients will stick to a mob until the client in question is logged into a different mob.
	var/datum/persistent_client/persistent_client
	/// If set, indicates that the client "belonging" to this (clientless) mob is currently controlling some other mob
	/// so don't treat them as being SSD even though their client var is null.
	var/mob/teleop = null
	/// Time of client loss, set by Logout(), for timekeeping
	var/disconnect_time = null

	/// List of movement speed modifiers applying to this mob. Lazylist, see mob_movespeed.dm
	var/list/movespeed_modification
	/// List of movement speed modifiers ignored by this mob. List -> List (id) -> List (sources). Lazylist, see mob_movespeed.dm
	var/list/movespeed_mod_immunities
	/// The calculated mob speed slowdown based on the modifiers list
	var/cached_multiplicative_slowdown

	/// we never want to hide a turf because it's not lit
	/// We can rely on the lighting plane to handle that for us
	see_in_dark = 1e6

	/// Whether a mob is alive or dead. TODO: Move this to living - Nodrak
	var/stat = 0
	can_be_buckled = TRUE

	var/atom/movable/screen/cells = null
	var/atom/movable/screen/flash = null
	var/atom/movable/screen/blind = null
	var/atom/movable/screen/hands = null
	var/atom/movable/screen/pullin = null
	var/atom/movable/screen/purged = null
	var/atom/movable/screen/internals/internals = null
	var/atom/movable/screen/oxygen = null
	var/atom/movable/screen/paralysis_indicator = null
	var/atom/movable/screen/i_select = null
	var/atom/movable/screen/m_select = null
	var/atom/movable/screen/toxin = null
	var/atom/movable/screen/bodytemp = null
	var/atom/movable/screen/healths = null
	var/atom/movable/screen/throw_icon = null
	var/atom/movable/screen/nutrition_icon = null
	var/atom/movable/screen/hydration_icon = null
	var/atom/movable/screen/pressure = null
	var/atom/movable/screen/damageoverlay = null
	var/atom/movable/screen/pain = null
	var/atom/movable/screen/gun/item/item_use_icon = null
	var/atom/movable/screen/gun/radio/radio_use_icon = null
	var/atom/movable/screen/gun/move/gun_move_icon = null
	var/atom/movable/screen/gun/mode/gun_setting_icon = null
	var/atom/movable/screen/gun/unique_action_icon = null
	var/atom/movable/screen/gun/toggle_firing_mode = null
	var/atom/movable/screen/energy/energy_display = null
	var/atom/movable/screen/instability/instability_display = null
	var/atom/movable/screen/up_hint = null
	/// The IPC version of the fullscreen pain texture.
	var/atom/movable/screen/fullscreen/robot_pain

	//spells hud icons - this interacts with add_spell and remove_spell
	var/list/atom/movable/screen/movable/spell_master/spell_masters = null
	var/atom/movable/screen/movable/ability_master/ability_master = null

	/*A bunch of this stuff really needs to go under their own defines instead of being globally attached to mob.
	A variable should only be globally attached to turfs/objects/whatever, when it is in fact needed as such.
	The current method unnecessarily clusters up the variable list, especially for humans (although rearranging won't really clean it up a lot but the difference will be noticable for other mobs).
	I'll make some notes on where certain variable defines should probably go.
	Changing this around would probably require a good look-over the pre-existing code.
	*/
	var/atom/movable/screen/zone_sel/zone_sel = null

	/// Allows all mobs to use the me verb by default, will have to manually specify they cannot
	var/use_me = 1
	var/damageoverlaytemp = 0
	var/computer_id = null
	var/character_id = 0
	var/obj/structure/machinery/machine = null
	var/height = HEIGHT_NOT_USED
	/// Carbon
	var/sdisabilities = 0
	/// Carbon
	var/disabilities = 0
	var/atom/movable/pulling = null
	var/next_move = null
	/// Carbon
	var/transforming = null
	var/other = 0.0
	var/hand = null
	/// Carbon
	var/eye_blind = null
	/// Carbon
	var/eye_blurry = null
	/// Carbon
	var/ear_deaf = null
	/// Carbon
	var/ear_damage = null
	var/stuttering = null
	var/slurring = null
	var/brokejaw = null
	var/real_name = null
	var/flavor_text = ""
	var/list/additional_vision_handlers = list()
	var/blinded = null
	var/ajourn = 0
	/// Carbon
	var/druggy = 0
	/// Carbon
	var/confused = 0
	var/antitoxs = null
	var/phoron = null
	/// Carbon
	var/sleeping = 0
	/// Carbon - Used to show a message once every time someone falls asleep.
	var/sleeping_msg_debounce = FALSE
	/// Carbon - Used to avoid falling over after waking up
	var/recently_slept = 0
	var/sleeping_indefinitely = FALSE
	/// Used for indefinite sleeping
	var/sleep_buffer = 0
	/// Carbon
	var/resting = 0
	/// Is the mob lying down?
	var/lying = 0
	/// Was the mob lying down before?
	var/lying_prev = 0
	/// Is the mob lying down intentionally? (eg. a manouver)
	var/lying_is_intentional = FALSE
	var/canmove = 1
	//Allows mobs to move through dense areas without restriction. For instance, in space or out of holder objects.
	var/incorporeal_move = INCORPOREAL_DISABLE
	var/lastpuke = 0
	var/unacidable = 0
	/// List of things pinning this creature to walls (see living_defense.dm)
	var/list/pinned = list()
	/// Embedded items, since simple mobs don't have organs.
	var/list/embedded = list()
	/// For speaking/listening.
	var/list/languages = list()
	/// Verbs used when speaking. Defaults to 'say' if speak_emote is null.
	var/list/speak_emote = list("says")
	/// Define emote default type, 1 for seen emotes, 2 for heard emotes
	var/emote_type = 1
	/// Used for the ancient art of moonwalking.
	var/facing_dir = null

	var/obj/structure/machinery/hologram/holopad/holo = null

	/// For admin things like possession
	var/name_archive

	/// Living
	var/timeofdeath = 0.0
	/// Whether the mob is performing cpr or not
	var/cpr = FALSE

	/// 98.7 F
	var/bodytemperature = 310.055
	var/old_x = 0
	var/old_y = 0
	/// Carbon
	var/drowsiness = 0
	var/charges = 0.0
	/// Carbon
	var/nutrition = BASE_MAX_NUTRITION * CREW_NUTRITION_SLIGHTLYHUNGRY
	/// How much hunger is lost per tick. This is modified by species
	var/nutrition_loss = HUNGER_FACTOR
	/// A multiplier for how much nutrition this specific mob loses per tick.
	var/nutrition_attrition_rate = 1
	var/max_nutrition = BASE_MAX_NUTRITION

	/// Carbon
	var/hydration = BASE_MAX_HYDRATION * CREW_HYDRATION_SLIGHTLYTHIRSTY
	/// How much hunger is lost per tick. This is modified by species
	var/hydration_loss = THIRST_FACTOR
	/// A multiplier for how much hydration this specific mob loses per tick.
	var/hydration_attrition_rate = 1
	var/max_hydration = BASE_MAX_NUTRITION

	/// Carbon
	/// How long this guy is overeating
	var/overeatduration = 0
	/// Carbon
	/// How long this guy is overdrinking
	var/overdrinkduration = 0

	var/paralysis = 0
	var/stunned = 0
	var/weakened = 0
	/// Carbon
	var/losebreath = 0
	/// Living
	var/a_intent = I_HELP
	/// Living
	var/m_intent = M_WALK
	var/lastKnownIP = null
	/// Living
	var/obj/item/l_hand = null
	/// Living
	var/obj/item/r_hand = null
	/// Human/Monkey
	var/obj/item/back = null
	/// Human/Monkey
	var/obj/item/tank/internal = null
	/// Carbon
	var/obj/item/storage/s_active = null
	/// Carbon
	var/obj/item/clothing/mask/wear_mask = null

	/// contains [/atom/movable/screen/alert only] // On /mob so clientless mobs will throw alerts properly
	var/list/alerts = list()
	var/list/screens = list()

	var/datum/hud/hud_used = null

	var/list/grabbed_by = list(  )

	var/list/mapobjs = list()

	var/in_throw_mode = 0

	var/inertia_dir = 0

	/// Living
	var/job = null

	/// Maximum w_class the mob can pull.
	var/can_pull_size = 10
	/// Whether or not the mob can pull other mobs.
	var/can_pull_mobs = MOB_PULL_LARGER

	/// Carbon
	var/datum/dna/dna = null

	/// Carbon -- Doohl
	var/mutations = 0
	//see: setup.dm for list of mutations

	var/voice_name = "unidentifiable voice"
	var/accent

	/// Used for checking whether hostile simple animals will attack you, possibly more stuff later
	var/faction = "neutral"
	/// Functionally, should give the same effect as being buckled_to into a chair when true.
	var/captured = 0

	//Generic list for proc holders. Only way I can see to enable certain verbs/procs. Should be modified if needed.
	//var/proc_holder_list[] = list()//Right now unused.
	//Also unlike the spell list, this would only store the object in contents, not an object in itself.

	/* Add this line to whatever stat module you need in order to use the proc holder list.
	Unlike the object spell system, it's also possible to attach verb procs from these objects to right-click menus.
	This requires creating a verb for the object proc holder.

	if (proc_holder_list.len)//Generic list for proc_holder objects.
		for(var/obj/effect/proc_holder/P in proc_holder_list)
			statpanel("[P.panel]","",P)
	*/

	//The last mob/living/carbon to push/drag/grab this mob (mostly used by slimes friend recognition)
	/// This is stored as a weakref because BYOND's harddeleter sucks ass.
	var/datum/weakref/LAssailant

	/// Wizard mode, but can be used in other modes thanks to the brand new "Give Spell" badmin button
	var/list/spell/spell_list

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	/// Set to 1 to trigger update_icon() at the next life() call
	var/update_icon = 1

	/// Bitflags defining which status effects can be inflicted (replaces canweaken, canstun, etc)
	var/status_flags = CANSTUN|CANWEAKEN|CANPARALYSE|CANPUSH

	var/area/lastarea = null

	/// Can they be tracked by the AI?
	var/digitalcamo = 0

	/// Used by admins to possess objects. All mobs should have this var
	var/obj/control_object

	//Whether or not mobs can understand other mobtypes. These stay in /mob so that ghosts can hear everything.
	/// Set to 1 to enable the mob to speak to everyone -- TLE
	var/universal_speak = 0
	/// Set to 1 to enable the mob to understand everyone, not necessarily speak
	var/universal_understand = 0

	/// The current turf being examined in the stat panel
	var/turf/listed_turf = null
	var/list/item_verbs = list()
	/// Typecache of objects that this mob shouldn't see in the stat panel. this silliness is needed because of AI alt+click and cult blood runes
	var/list/shouldnt_see = list()

	var/list/active_genes = list()

	var/mob_size = MOB_MEDIUM
	/// The icon size width of the mob. Used for langchat resizing.
	var/icon_size = 32

	/// The weight of the mob. Affects if the mob can be easily lifted or not. Separate from size, as some mobs may be big but not particularly heavy.
	var/mob_weight = MOB_WEIGHT_LIGHT
	/// The strength of the mob. Affects what kind of mobs can be thrown or carried. By default, does not give any buff.
	var/mob_strength = MOB_STRENGTH_NORMAL

	var/list/progressbars

	/// Related to wizard statues, if set to true, life won't process
	var/frozen = FALSE

	var/mob_thinks = TRUE

	var/authed = TRUE
	var/player_age = "Requires database"

	/// Override for sound_environmentironments. If this is set the user will always hear a specific type of reverb (Instead of the area defined reverb)
	var/sound_environment_override = SOUND_ENVIRONMENT_NONE

	/// The icon currently used for the typing indicator's bubble
	var/atom/movable/typing_indicator/typing_indicator
	/// User is thinking in character. Used to revert to thinking state after stop_typing
	var/thinking_IC = FALSE

	/// A assoc lazylist of to_chat notifications, key = string message, value = world time integer
	var/list/message_notifications

	/// In which mob is our mind
	var/mob/living/vr_mob = null
	/// Which mob is our old mob
	var/mob/living/old_mob = null

	/**
	* LAZYLIST (Instances of `/datum/click_handler`). Click handlers for this mob that should intercept and handle click
	* calls.
	*
	* The 'topmost'/'active' click handler for the mob is the handler currently at index `1`. By default, this will be
	* `/datum/click_handler/default`.
	*/
	var/list/click_handlers

	var/should_add_to_mob_list = TRUE

	/// Integer. Unique sequential ID from the `do_after` proc used to validate `DO_USER_UNIQUE_ACT` flag checks.
	var/do_unique_user_handle = 0

	var/mob/lastattacker = null
	var/mob/lastattacked = null
	var/list/logging = list()

	/// Spam control, can only point when the previous pointer qdels
	var/obj/effect/decal/point/pointing_effect = null

	/// 1 decisecond click delay (above and beyond mob/next_move)
	var/next_click = 0

	/// Carbon
	var/dizziness = 0
	var/is_dizzy = 0
	var/is_jittery = 0
	/// Carbon
	var/jitteriness = 0

	//handles up-down floaty effect in space and zero-gravity
	var/is_floating = FALSE

	var/last_pain_message = ""
	var/next_pain_time = 0

	/**
	* global
	*
	* Tracks open UIs for a user.
	*/
	var/list/tgui_open_uis = list()

	var/tmp/last_airflow_stun = 0

	//thou shall always be able to see the Geometer of Blood
	var/image/narsimage = null
	var/image/narglow = null

	//thou shall always be able to see the rift
	var/image/riftimage = null

	var/list/client_colors = list()

	var/bloody_hands = null
	var/datum/weakref/bloody_hands_mob
	var/track_footprint = 0
	var/list/feet_blood_DNA
	var/track_footprint_type
	var/footprint_color

	var/mob/abstract/eye/eyeobj

	var/mob/living/brain_ghost/bg

	var/list/default_emotes = list()
	var/list/usable_emotes = list()

	var/thinking_enabled = FALSE
