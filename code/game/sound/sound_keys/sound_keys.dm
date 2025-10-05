/*
# sound_effect datum
* use for when you need multiple sound files to play at random in a playsound
* see var documentation below
* initialized and added to sfx_datum_by_key in /datum/controller/subsystem/sounds/init_sound_keys()
*/
/datum/sound_effect
	/// sfx key define with which we are associated with, see code\__DEFINES\sound.dm
	var/key
	/// list of paths to our files, use the /assoc subtype if your paths are weighted
	var/list/file_paths

/datum/sound_effect/proc/return_sfx()
	return pick(file_paths)

/datum/sound_effect/shatter
	key = SFX_SHATTER
	file_paths = list(
		'sound/effects/glassbr1.ogg',
		'sound/effects/glassbr2.ogg',
		'sound/effects/glassbr3.ogg',
	)

/datum/sound_effect/explosion
	key = SFX_EXPLOSION
	file_paths = list(
		'sound/effects/explosion1.ogg',
		'sound/effects/explosion2.ogg',
	)

/datum/sound_effect/explosion_creaking
	key = SFX_EXPLOSION_CREAKING
	file_paths = list(
		'sound/effects/explosioncreak1.ogg',
		'sound/effects/explosioncreak2.ogg',
	)

/datum/sound_effect/hull_creaking
	key = SFX_HULL_CREAKING
	file_paths = list(
		'sound/effects/creak1.ogg',
		'sound/effects/creak2.ogg',
		'sound/effects/creak3.ogg',
	)

/datum/sound_effect/sparks
	key = SFX_SPARKS
	file_paths = list(
		'sound/effects/sparks1.ogg',
		'sound/effects/sparks2.ogg',
		'sound/effects/sparks3.ogg',
		'sound/effects/sparks4.ogg',
	)

/datum/sound_effect/rustle
	key = SFX_RUSTLE
	file_paths = list(
		'sound/effects/rustle1.ogg',
		'sound/effects/rustle2.ogg',
		'sound/effects/rustle3.ogg',
		'sound/effects/rustle4.ogg',
		'sound/effects/rustle5.ogg',
	)

/datum/sound_effect/bodyfall
	key = SFX_BODYFALL
	file_paths = list(
		'sound/effects/bodyfall1.ogg',
		'sound/effects/bodyfall2.ogg',
		'sound/effects/bodyfall3.ogg',
		'sound/effects/bodyfall4.ogg',
	)

/datum/sound_effect/punch
	key = SFX_PUNCH
	file_paths = list(
		'sound/weapons/punch1.ogg',
		'sound/weapons/punch2.ogg',
		'sound/weapons/punch3.ogg',
		'sound/weapons/punch4.ogg',
	)

/datum/sound_effect/clown_step
	key = SFX_CLOWN_STEP
	file_paths = list(
		'sound/effects/footstep/clownstep1.ogg',
		'sound/effects/footstep/clownstep2.ogg',
	)

/datum/sound_effect/suit_step
	key = SFX_SUIT_STEP
	file_paths = list(
		'sound/effects/suitstep1.ogg',
		'sound/effects/suitstep2.ogg',
	)

/datum/sound_effect/swing_hit
	key = SFX_SWING_HIT
	file_paths = list(
		'sound/weapons/genhit1.ogg',
		'sound/weapons/genhit2.ogg',
		'sound/weapons/genhit3.ogg',
	)

/datum/sound_effect/hiss
	key = SFX_HISS
	file_paths = list(
		'sound/voice/hiss1.ogg',
		'sound/voice/hiss2.ogg',
		'sound/voice/hiss3.ogg',
		'sound/voice/hiss4.ogg',
	)

/datum/sound_effect/page_turn
	key = SFX_PAGE_TURN
	file_paths = list(
		'sound/effects/pageturn1.ogg',
		'sound/effects/pageturn2.ogg',
		'sound/effects/pageturn3.ogg',
	)

/datum/sound_effect/ricochet
	key = SFX_RICOCHET
	file_paths = list(
		'sound/weapons/effects/ric1.ogg',
		'sound/weapons/effects/ric2.ogg',
		'sound/weapons/effects/ric3.ogg',
		'sound/weapons/effects/ric4.ogg',
		'sound/weapons/effects/ric5.ogg',
	)

/datum/sound_effect/terminal_type
	key = SFX_TERMINAL_TYPE
	file_paths = list(
		'sound/machines/terminal_button01.ogg',
		'sound/machines/terminal_button02.ogg',
		'sound/machines/terminal_button03.ogg',
		'sound/machines/terminal_button04.ogg',
		'sound/machines/terminal_button05.ogg',
		'sound/machines/terminal_button06.ogg',
		'sound/machines/terminal_button07.ogg',
		'sound/machines/terminal_button08.ogg',
	)

/datum/sound_effect/desecration
	key = SFX_DESECRATION
	file_paths = list(
		'sound/misc/desecration-01.ogg',
		'sound/misc/desecration-02.ogg',
		'sound/misc/desecration-03.ogg',
	)

/datum/sound_effect/im_here
	key = SFX_IM_HERE
	file_paths = list(
		'sound/hallucinations/im_here1.ogg',
		'sound/hallucinations/im_here2.ogg',
	)

/datum/sound_effect/can_open
	key = SFX_CAN_OPEN
	file_paths = list(
		'sound/effects/can_open1.ogg',
		'sound/effects/can_open2.ogg',
		'sound/effects/can_open3.ogg',
	)

/datum/sound_effect/bullet_miss
	key = SFX_BULLET_MISS
	file_paths = list(
		'sound/weapons/bulletflyby.ogg',
		'sound/weapons/bulletflyby2.ogg',
		'sound/weapons/bulletflyby3.ogg',
	)

/datum/sound_effect/revolver_spin
	key = SFX_REVOLVER_SPIN
	file_paths = list(
		'sound/weapons/gun/revolver/spin1.ogg',
		'sound/weapons/gun/revolver/spin2.ogg',
		'sound/weapons/gun/revolver/spin3.ogg',
	)

/datum/sound_effect/law
	key = SFX_LAW
	file_paths = list(
		'sound/voice/beepsky/creep.ogg',
		'sound/voice/beepsky/god.ogg',
		'sound/voice/beepsky/iamthelaw.ogg',
		'sound/voice/beepsky/radio.ogg',
		'sound/voice/beepsky/secureday.ogg',
	)

/datum/sound_effect/honkbot_e
	key = SFX_HONKBOT_E
	file_paths = list(
		'sound/effects/pray.ogg',
		'sound/effects/reee.ogg',
		'sound/items/AirHorn.ogg',
		'sound/items/AirHorn2.ogg',
		'sound/items/bikehorn.ogg',
		'sound/items/WEEOO1.ogg',
		'sound/machines/buzz-sigh.ogg',
		'sound/machines/ping.ogg',
		'sound/magic/Fireball.ogg',
		'sound/misc/sadtrombone.ogg',
		'sound/voice/beepsky/creep.ogg',
		'sound/voice/beepsky/iamthelaw.ogg',
		'sound/voice/hiss1.ogg',
		'sound/weapons/bladeslice.ogg',
		'sound/weapons/flashbang.ogg',
	)

/datum/sound_effect/goose
	key = "goose"
	file_paths = list(
		'sound/creatures/goose1.ogg',
		'sound/creatures/goose2.ogg',
		'sound/creatures/goose3.ogg',
		'sound/creatures/goose4.ogg',
	)

/datum/sound_effect/warpspeed
	key = SFX_WARPSPEED
	file_paths = list(
		'sound/runtime/hyperspace/hyperspace_begin.ogg',
	)

/datum/sound_effect/sm_calm
	key = SFX_SM_CALM
	file_paths = list(
		'sound/machines/sm/accent/normal/1.ogg',
		'sound/machines/sm/accent/normal/2.ogg',
		'sound/machines/sm/accent/normal/3.ogg',
		'sound/machines/sm/accent/normal/4.ogg',
		'sound/machines/sm/accent/normal/5.ogg',
		'sound/machines/sm/accent/normal/6.ogg',
		'sound/machines/sm/accent/normal/7.ogg',
		'sound/machines/sm/accent/normal/8.ogg',
		'sound/machines/sm/accent/normal/9.ogg',
		'sound/machines/sm/accent/normal/10.ogg',
		'sound/machines/sm/accent/normal/11.ogg',
		'sound/machines/sm/accent/normal/12.ogg',
		'sound/machines/sm/accent/normal/13.ogg',
		'sound/machines/sm/accent/normal/14.ogg',
		'sound/machines/sm/accent/normal/15.ogg',
		'sound/machines/sm/accent/normal/16.ogg',
		'sound/machines/sm/accent/normal/17.ogg',
		'sound/machines/sm/accent/normal/18.ogg',
		'sound/machines/sm/accent/normal/19.ogg',
		'sound/machines/sm/accent/normal/20.ogg',
		'sound/machines/sm/accent/normal/21.ogg',
		'sound/machines/sm/accent/normal/22.ogg',
		'sound/machines/sm/accent/normal/23.ogg',
		'sound/machines/sm/accent/normal/24.ogg',
		'sound/machines/sm/accent/normal/25.ogg',
		'sound/machines/sm/accent/normal/26.ogg',
		'sound/machines/sm/accent/normal/27.ogg',
		'sound/machines/sm/accent/normal/28.ogg',
		'sound/machines/sm/accent/normal/29.ogg',
		'sound/machines/sm/accent/normal/30.ogg',
		'sound/machines/sm/accent/normal/31.ogg',
		'sound/machines/sm/accent/normal/32.ogg',
		'sound/machines/sm/accent/normal/33.ogg',
	)

/datum/sound_effect/sm_delam
	key = SFX_SM_DELAM
	file_paths = list(
		'sound/machines/sm/accent/delam/1.ogg',
		'sound/machines/sm/accent/delam/2.ogg',
		'sound/machines/sm/accent/delam/3.ogg',
		'sound/machines/sm/accent/delam/4.ogg',
		'sound/machines/sm/accent/delam/5.ogg',
		'sound/machines/sm/accent/delam/6.ogg',
		'sound/machines/sm/accent/delam/7.ogg',
		'sound/machines/sm/accent/delam/8.ogg',
		'sound/machines/sm/accent/delam/9.ogg',
		'sound/machines/sm/accent/delam/10.ogg',
		'sound/machines/sm/accent/delam/11.ogg',
		'sound/machines/sm/accent/delam/12.ogg',
		'sound/machines/sm/accent/delam/13.ogg',
		'sound/machines/sm/accent/delam/14.ogg',
		'sound/machines/sm/accent/delam/15.ogg',
		'sound/machines/sm/accent/delam/16.ogg',
		'sound/machines/sm/accent/delam/17.ogg',
		'sound/machines/sm/accent/delam/18.ogg',
		'sound/machines/sm/accent/delam/19.ogg',
		'sound/machines/sm/accent/delam/20.ogg',
		'sound/machines/sm/accent/delam/21.ogg',
		'sound/machines/sm/accent/delam/22.ogg',
		'sound/machines/sm/accent/delam/23.ogg',
		'sound/machines/sm/accent/delam/24.ogg',
		'sound/machines/sm/accent/delam/25.ogg',
		'sound/machines/sm/accent/delam/26.ogg',
		'sound/machines/sm/accent/delam/27.ogg',
		'sound/machines/sm/accent/delam/28.ogg',
		'sound/machines/sm/accent/delam/29.ogg',
		'sound/machines/sm/accent/delam/30.ogg',
		'sound/machines/sm/accent/delam/31.ogg',
		'sound/machines/sm/accent/delam/32.ogg',
		'sound/machines/sm/accent/delam/33.ogg',
	)

/datum/sound_effect/hypertorus_calm
	key = SFX_HYPERTORUS_CALM
	file_paths = list(
		'sound/machines/sm/accent/normal/1.ogg',
		'sound/machines/sm/accent/normal/2.ogg',
		'sound/machines/sm/accent/normal/3.ogg',
		'sound/machines/sm/accent/normal/4.ogg',
		'sound/machines/sm/accent/normal/5.ogg',
		'sound/machines/sm/accent/normal/6.ogg',
		'sound/machines/sm/accent/normal/7.ogg',
		'sound/machines/sm/accent/normal/8.ogg',
		'sound/machines/sm/accent/normal/9.ogg',
		'sound/machines/sm/accent/normal/10.ogg',
		'sound/machines/sm/accent/normal/11.ogg',
		'sound/machines/sm/accent/normal/12.ogg',
		'sound/machines/sm/accent/normal/13.ogg',
		'sound/machines/sm/accent/normal/14.ogg',
		'sound/machines/sm/accent/normal/15.ogg',
		'sound/machines/sm/accent/normal/16.ogg',
		'sound/machines/sm/accent/normal/17.ogg',
		'sound/machines/sm/accent/normal/18.ogg',
		'sound/machines/sm/accent/normal/19.ogg',
		'sound/machines/sm/accent/normal/20.ogg',
		'sound/machines/sm/accent/normal/21.ogg',
		'sound/machines/sm/accent/normal/22.ogg',
		'sound/machines/sm/accent/normal/23.ogg',
		'sound/machines/sm/accent/normal/24.ogg',
		'sound/machines/sm/accent/normal/25.ogg',
		'sound/machines/sm/accent/normal/26.ogg',
		'sound/machines/sm/accent/normal/27.ogg',
		'sound/machines/sm/accent/normal/28.ogg',
		'sound/machines/sm/accent/normal/29.ogg',
		'sound/machines/sm/accent/normal/30.ogg',
		'sound/machines/sm/accent/normal/31.ogg',
		'sound/machines/sm/accent/normal/32.ogg',
		'sound/machines/sm/accent/normal/33.ogg',
	)

/datum/sound_effect/hypertorus_melting
	key = SFX_HYPERTORUS_MELTING
	file_paths = list(
		'sound/machines/sm/accent/delam/1.ogg',
		'sound/machines/sm/accent/delam/2.ogg',
		'sound/machines/sm/accent/delam/3.ogg',
		'sound/machines/sm/accent/delam/4.ogg',
		'sound/machines/sm/accent/delam/5.ogg',
		'sound/machines/sm/accent/delam/6.ogg',
		'sound/machines/sm/accent/delam/7.ogg',
		'sound/machines/sm/accent/delam/8.ogg',
		'sound/machines/sm/accent/delam/9.ogg',
		'sound/machines/sm/accent/delam/10.ogg',
		'sound/machines/sm/accent/delam/11.ogg',
		'sound/machines/sm/accent/delam/12.ogg',
		'sound/machines/sm/accent/delam/13.ogg',
		'sound/machines/sm/accent/delam/14.ogg',
		'sound/machines/sm/accent/delam/15.ogg',
		'sound/machines/sm/accent/delam/16.ogg',
		'sound/machines/sm/accent/delam/17.ogg',
		'sound/machines/sm/accent/delam/18.ogg',
		'sound/machines/sm/accent/delam/19.ogg',
		'sound/machines/sm/accent/delam/20.ogg',
		'sound/machines/sm/accent/delam/21.ogg',
		'sound/machines/sm/accent/delam/22.ogg',
		'sound/machines/sm/accent/delam/23.ogg',
		'sound/machines/sm/accent/delam/24.ogg',
		'sound/machines/sm/accent/delam/25.ogg',
		'sound/machines/sm/accent/delam/26.ogg',
		'sound/machines/sm/accent/delam/27.ogg',
		'sound/machines/sm/accent/delam/28.ogg',
		'sound/machines/sm/accent/delam/29.ogg',
		'sound/machines/sm/accent/delam/30.ogg',
		'sound/machines/sm/accent/delam/31.ogg',
		'sound/machines/sm/accent/delam/32.ogg',
		'sound/machines/sm/accent/delam/33.ogg',
	)

/datum/sound_effect/crunchy_bush_whack
	key = SFX_CRUNCHY_BUSH_WHACK
	file_paths = list(
		'sound/effects/crunchybushwhack1.ogg',
		'sound/effects/crunchybushwhack2.ogg',
		'sound/effects/crunchybushwhack3.ogg',
	)

/datum/sound_effect/tree_chop
	key = SFX_TREE_CHOP
	file_paths = list(
		'sound/effects/treechop1.ogg',
		'sound/effects/treechop2.ogg',
		'sound/effects/treechop3.ogg',
	)

/datum/sound_effect/rock_tap
	key = SFX_ROCK_TAP
	file_paths = list(
		'sound/effects/rocktap1.ogg',
		'sound/effects/rocktap2.ogg',
		'sound/effects/rocktap3.ogg',
	)

/datum/sound_effect/muffled_speech
	key = SFX_MUFFLED_SPEECH
	file_paths = list(
		'sound/effects/muffspeech/muffspeech1.ogg',
		'sound/effects/muffspeech/muffspeech2.ogg',
		'sound/effects/muffspeech/muffspeech3.ogg',
		'sound/effects/muffspeech/muffspeech4.ogg',
		'sound/effects/muffspeech/muffspeech5.ogg',
		'sound/effects/muffspeech/muffspeech6.ogg',
		'sound/effects/muffspeech/muffspeech7.ogg',
		'sound/effects/muffspeech/muffspeech8.ogg',
		'sound/effects/muffspeech/muffspeech9.ogg',
	)

/datum/sound_effect/keystroke
	key = SFX_KEYSTROKE
	file_paths = list(
		'sound/machines/keyboard/keypress1.ogg',
		'sound/machines/keyboard/keypress2.ogg',
		'sound/machines/keyboard/keypress3.ogg',
		'sound/machines/keyboard/keypress4.ogg',
	)

/datum/sound_effect/keyboard
	key = SFX_KEYBOARD
	file_paths = list(
		'sound/machines/keyboard/keystroke1.ogg',
		'sound/machines/keyboard/keystroke2.ogg',
		'sound/machines/keyboard/keystroke3.ogg',
		'sound/machines/keyboard/keystroke4.ogg',
	)

/datum/sound_effect/button
	key = SFX_BUTTON
	file_paths = list(
		'sound/machines/button1.ogg',
		'sound/machines/button2.ogg',
		'sound/machines/button3.ogg',
		'sound/machines/button4.ogg',
	)

/datum/sound_effect/use_switch
	key = SFX_SWITCH
	file_paths = list(
		'sound/machines/switch1.ogg',
		'sound/machines/switch2.ogg',
		'sound/machines/switch3.ogg',
	)

/datum/sound_effect/button_click
	key = SFX_BUTTON_CLICK
	file_paths = list(
		'monkestation/sound/effects/hl2/button-click.ogg',
	)

/datum/sound_effect/button_fail
	key = SFX_BUTTON_FAIL
	file_paths = list(
		'monkestation/sound/effects/hl2/button-fail.ogg',
	)

/datum/sound_effect/lightswitch
	key = SFX_LIGHTSWITCH
	file_paths = list(
		'monkestation/sound/effects/hl2/lightswitch.ogg',
	)

/datum/sound_effect/portal_close
	key = SFX_PORTAL_CLOSE
	file_paths = list('sound/effects/portal_close.ogg')

/datum/sound_effect/portal_enter
	key = SFX_PORTAL_ENTER
	file_paths = list('sound/effects/portal_travel.ogg')

/datum/sound_effect/portal_created
	key = SFX_PORTAL_CREATED
	file_paths = list(
		'sound/effects/portal_open_1.ogg',
		'sound/effects/portal_open_2.ogg',
		'sound/effects/portal_open_3.ogg',
	)

/datum/sound_effect/screech
	key = SFX_SCREECH
	file_paths = list(
		'sound/creatures/monkey/monkey_screech_1.ogg',
		'sound/creatures/monkey/monkey_screech_2.ogg',
		'sound/creatures/monkey/monkey_screech_3.ogg',
		'sound/creatures/monkey/monkey_screech_4.ogg',
		'sound/creatures/monkey/monkey_screech_5.ogg',
		'sound/creatures/monkey/monkey_screech_6.ogg',
		'sound/creatures/monkey/monkey_screech_7.ogg',
	)

/singleton/sound_category
	var/list/sounds = list()

/singleton/sound_category/proc/get_sound()
	return pick(sounds)

/singleton/sound_category/blank_footsteps
	key = SFX_FOOTSTEP
	sounds = list('sound/effects/footstep/blank.ogg')

/singleton/sound_category/catwalk_footstep
	key = SFX_FOOTSTEP
	sounds = list(
		'sound/effects/footstep/catwalk1.ogg',
		'sound/effects/footstep/catwalk2.ogg',
		'sound/effects/footstep/catwalk3.ogg',
		'sound/effects/footstep/catwalk4.ogg',
		'sound/effects/footstep/catwalk5.ogg'
	)

/singleton/sound_category/wood_footstep
	key = SFX_FOOTSTEP
	sounds = list(
		'sound/effects/footstep/wood1.ogg',
		'sound/effects/footstep/wood2.ogg',
		'sound/effects/footstep/wood3.ogg',
		'sound/effects/footstep/wood4.ogg',
		'sound/effects/footstep/wood5.ogg'
	)

/singleton/sound_category/tiles_footstep
	key = SFX_FOOTSTEP
	sounds = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'
	)

/singleton/sound_category/plating_footstep
	key = SFX_FOOTSTEP
	sounds = list(
		'sound/effects/footstep/plating1.ogg',
		'sound/effects/footstep/plating2.ogg',
		'sound/effects/footstep/plating3.ogg',
		'sound/effects/footstep/plating4.ogg',
		'sound/effects/footstep/plating5.ogg'
	)

/singleton/sound_category/carpet_footstep
	key = SFX_FOOTSTEP
	sounds = list(
		'sound/effects/footstep/carpet1.ogg',
		'sound/effects/footstep/carpet2.ogg',
		'sound/effects/footstep/carpet3.ogg',
		'sound/effects/footstep/carpet4.ogg',
		'sound/effects/footstep/carpet5.ogg'
	)

/singleton/sound_category/asteroid_footstep
	key = SFX_FOOTSTEP
	sounds = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg',
		'sound/effects/footstep/asteroid5.ogg'
	)

/singleton/sound_category/grass_footstep
	key = SFX_FOOTSTEP
	sounds = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'
	)

/singleton/sound_category/water_footstep
	key = SFX_FOOTSTEP
	sounds = list(
		'sound/effects/footstep/water1.ogg',
		'sound/effects/footstep/water2.ogg',
		'sound/effects/footstep/water3.ogg',
		'sound/effects/footstep/water4.ogg'
	)

/singleton/sound_category/lava_footstep
	key = SFX_FOOTSTEP
	sounds = list(
		'sound/effects/footstep/lava1.ogg',
		'sound/effects/footstep/lava2.ogg',
		'sound/effects/footstep/lava3.ogg'
	)

/singleton/sound_category/snow_footstep
	key = SFX_FOOTSTEP
	sounds = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg'
	)

/singleton/sound_category/sand_footstep
	key = SFX_FOOTSTEP
	sounds = list(
		'sound/effects/footstep/sand1.ogg',
		'sound/effects/footstep/sand2.ogg',
		'sound/effects/footstep/sand3.ogg',
		'sound/effects/footstep/sand4.ogg'
	)

/singleton/sound_category/glass_break_sound
	sounds = list(
		'sound/effects/glass_break1.ogg',
		'sound/effects/glass_break2.ogg',
		'sound/effects/glass_break3.ogg'
	)

/singleton/sound_category/cardboard_break_sound
	sounds = list(
		'sound/effects/cardboard_break1.ogg',
		'sound/effects/cardboard_break2.ogg',
		'sound/effects/cardboard_break3.ogg',
	)

/singleton/sound_category/wood_break_sound
	sounds = list(
		'sound/effects/wood_break1.ogg',
		'sound/effects/wood_break2.ogg',
		'sound/effects/wood_break3.ogg'
	)

/singleton/sound_category/explosion_sound
	sounds = list(
		'sound/effects/Explosion1.ogg',
		'sound/effects/Explosion2.ogg'
	)

/singleton/sound_category/spark_sound
	sounds = list(
		'sound/effects/sparks1.ogg',
		'sound/effects/sparks2.ogg',
		'sound/effects/sparks3.ogg',
		'sound/effects/sparks4.ogg'
	)

/singleton/sound_category/rustle_sound
	sounds = list(
		'sound/items/storage/rustle1.ogg',
		'sound/items/storage/rustle2.ogg',
		'sound/items/storage/rustle3.ogg',
		'sound/items/storage/rustle4.ogg',
		'sound/items/storage/rustle5.ogg'
	)

/singleton/sound_category/punch_sound
	sounds = list(
		'sound/weapons/punch1.ogg',
		'sound/weapons/punch2.ogg',
		'sound/weapons/punch3.ogg',
		'sound/weapons/punch4.ogg'
	)

/singleton/sound_category/punch_bassy_sound
	sounds = list(
		'sound/weapons/punch1_bass.ogg',
		'sound/weapons/punch2_bass.ogg',
		'sound/weapons/punch3_bass.ogg',
		'sound/weapons/punch4_bass.ogg'
	)

/singleton/sound_category/punchmiss_sound
	sounds = list(
		'sound/weapons/punchmiss1.ogg',
		'sound/weapons/punchmiss2.ogg'
	)

/singleton/sound_category/swing_hit_sound
	sounds = list(
		'sound/weapons/genhit1.ogg',
		'sound/weapons/genhit2.ogg',
		'sound/weapons/genhit3.ogg'
	)

/singleton/sound_category/hiss_sound
	sounds = list(
		'sound/voice/hiss1.ogg',
		'sound/voice/hiss2.ogg',
		'sound/voice/hiss3.ogg',
		'sound/voice/hiss4.ogg'
	)

/singleton/sound_category/page_sound
	sounds = list(
		'sound/effects/pageturn1.ogg',
		'sound/effects/pageturn2.ogg',
		'sound/effects/pageturn3.ogg'
	)

/singleton/sound_category/fracture_sound
	sounds = list(
		'sound/effects/bonebreak1.ogg',
		'sound/effects/bonebreak2.ogg',
		'sound/effects/bonebreak3.ogg',
		'sound/effects/bonebreak4.ogg'
	)

/singleton/sound_category/button_sound
	sounds = list(
		'sound/machines/button1.ogg',
		'sound/machines/button2.ogg',
		'sound/machines/button3.ogg',
		'sound/machines/button4.ogg'
	)

/singleton/sound_category/computerbeep_sound
	sounds = list(
		'sound/machines/compbeep1.ogg',
		'sound/machines/compbeep2.ogg',
		'sound/machines/compbeep3.ogg',
		'sound/machines/compbeep4.ogg',
		'sound/machines/compbeep5.ogg'
	)

/singleton/sound_category/switch_sound
	sounds = list(
		'sound/machines/switch1.ogg',
		'sound/machines/switch2.ogg',
		'sound/machines/switch3.ogg',
		'sound/machines/switch4.ogg'
	)

/singleton/sound_category/keyboard_sound
	sounds = list(
		'sound/machines/keyboard/keyboard1.ogg',
		'sound/machines/keyboard/keyboard2.ogg',
		'sound/machines/keyboard/keyboard3.ogg',
		'sound/machines/keyboard/keyboard4.ogg',
		'sound/machines/keyboard/keyboard5.ogg'
	)

/singleton/sound_category/pickaxe_sound
	sounds = list(
		'sound/weapons/mine/pickaxe1.ogg',
		'sound/weapons/mine/pickaxe2.ogg',
		'sound/weapons/mine/pickaxe3.ogg',
		'sound/weapons/mine/pickaxe4.ogg'
	)

/singleton/sound_category/glasscrack_sound
	sounds = list(
		'sound/effects/glass_crack1.ogg',
		'sound/effects/glass_crack2.ogg',
		'sound/effects/glass_crack3.ogg',
		'sound/effects/glass_crack4.ogg'
	)

/singleton/sound_category/bodyfall_sound
	sounds = list(
		'sound/effects/bodyfall1.ogg',
		'sound/effects/bodyfall2.ogg',
		'sound/effects/bodyfall3.ogg',
		'sound/effects/bodyfall4.ogg'
	)

/singleton/sound_category/bodyfall_skrell_sound
	sounds = list(
		'sound/effects/bodyfall_skrell1.ogg',
		'sound/effects/bodyfall_skrell2.ogg',
		'sound/effects/bodyfall_skrell3.ogg',
		'sound/effects/bodyfall_skrell4.ogg'
	)

/singleton/sound_category/bodyfall_machine_sound
	sounds = list(
		'sound/effects/bodyfall_machine1.ogg',
		'sound/effects/bodyfall_machine2.ogg'
	)
/singleton/sound_category/bulletflyby_sound
		sounds = list(
		'sound/effects/bulletflyby1.ogg',
		'sound/effects/bulletflyby2.ogg',
		'sound/effects/bulletflyby3.ogg'
	)

/singleton/sound_category/screwdriver_sound
	sounds = list(
		'sound/items/Screwdriver.ogg',
		'sound/items/Screwdriver2.ogg'
	)

/singleton/sound_category/crowbar_sound
	sounds = list(
		'sound/items/crowbar1.ogg',
		'sound/items/crowbar2.ogg',
		'sound/items/crowbar3.ogg',
		'sound/items/crowbar4.ogg'
	)

/singleton/sound_category/casing_drop_sound
	sounds = list(
		'sound/items/drop/casing1.ogg',
		'sound/items/drop/casing2.ogg',
		'sound/items/drop/casing3.ogg',
		'sound/items/drop/casing4.ogg',
		'sound/items/drop/casing5.ogg',
		'sound/items/drop/casing6.ogg',
		'sound/items/drop/casing7.ogg',
		'sound/items/drop/casing8.ogg',
		'sound/items/drop/casing9.ogg',
		'sound/items/drop/casing10.ogg',
		'sound/items/drop/casing11.ogg',
		'sound/items/drop/casing12.ogg',
		'sound/items/drop/casing13.ogg',
		'sound/items/drop/casing15.ogg',
		'sound/items/drop/casing16.ogg',
		'sound/items/drop/casing17.ogg',
		'sound/items/drop/casing18.ogg',
		'sound/items/drop/casing19.ogg',
		'sound/items/drop/casing20.ogg',
		'sound/items/drop/casing21.ogg',
		'sound/items/drop/casing22.ogg',
		'sound/items/drop/casing23.ogg',
		'sound/items/drop/casing24.ogg',
		'sound/items/drop/casing25.ogg'
	)

/singleton/sound_category/casing_drop_sound_shotgun
	sounds = list(
		'sound/items/drop/casing_shotgun1.ogg',
		'sound/items/drop/casing_shotgun2.ogg',
		'sound/items/drop/casing_shotgun3.ogg',
		'sound/items/drop/casing_shotgun4.ogg',
		'sound/items/drop/casing_shotgun5.ogg'
	)

/singleton/sound_category/out_of_ammo
	sounds = list(
		'sound/weapons/empty/empty2.ogg',
		'sound/weapons/empty/empty3.ogg',
		'sound/weapons/empty/empty4.ogg',
		'sound/weapons/empty/empty5.ogg',
		'sound/weapons/empty/empty6.ogg'
	)

/singleton/sound_category/out_of_ammo_revolver
	sounds = list(
		'sound/weapons/empty/empty_revolver.ogg',
		'sound/weapons/empty/empty_revolver3.ogg'
	)

/singleton/sound_category/out_of_ammo_rifle
	sounds = list(
		'sound/weapons/empty/empty_rifle1.ogg',
		'sound/weapons/empty/empty_rifle2.ogg'
	)

/singleton/sound_category/out_of_ammo_shotgun
	sounds = list(
		'sound/weapons/empty/empty_shotgun1.ogg'
	)

/singleton/sound_category/metal_slide_reload
	sounds = list(
		'sound/weapons/reloads/pistol_metal_slide1.ogg',
		'sound/weapons/reloads/pistol_metal_slide2.ogg',
		'sound/weapons/reloads/pistol_metal_slide3.ogg',
		'sound/weapons/reloads/pistol_metal_slide4.ogg',
		'sound/weapons/reloads/pistol_metal_slide5.ogg',
		'sound/weapons/reloads/pistol_metal_slide6.ogg',
		'sound/weapons/reloads/pistol_metal_slide7.ogg',
		'sound/weapons/reloads/pistol_metal_slide8.ogg',
		'sound/weapons/reloads/pistol_metal_slide9.ogg',
		'sound/weapons/reloads/pistol_metal_slide10.ogg',
		'sound/weapons/reloads/pistol_metal_slide11.ogg'
	)

/singleton/sound_category/polymer_slide_reload
	sounds = list(
		'sound/weapons/reloads/pistol_polymer_slide1.ogg',
		'sound/weapons/reloads/pistol_polymer_slide2.ogg',
		'sound/weapons/reloads/pistol_polymer_slide3.ogg',
		'sound/weapons/reloads/pistol_polymer_slide4.ogg',
		'sound/weapons/reloads/pistol_polymer_slide5.ogg'
	)

/singleton/sound_category/rifle_slide_reload
	sounds = list(
		'sound/weapons/reloads/rifle_slide.ogg',
		'sound/weapons/reloads/rifle_slide2.ogg',
		'sound/weapons/reloads/rifle_slide3.ogg',
		'sound/weapons/reloads/rifle_slide4.ogg',
		'sound/weapons/reloads/rifle_slide5.ogg',
		'sound/weapons/reloads/rifle_slide6.ogg',
		'sound/weapons/reloads/rifle_slide7.ogg',
		'sound/weapons/reloads/rifle_slide8.ogg',
		'sound/weapons/reloads/rifle_slide9.ogg',
		'sound/weapons/reloads/rifle_slide10.ogg',
		'sound/weapons/reloads/rifle_slide11.ogg',
		'sound/weapons/reloads/rifle_slide12.ogg'
	)

/singleton/sound_category/revolver_reload
	sounds = list(
		'sound/weapons/reloads/revolver_reload.ogg'
	)
/singleton/sound_category/shotgun_pump
	sounds = list(
		'sound/weapons/reloads/shotgun_pump2.ogg',
		'sound/weapons/reloads/shotgun_pump3.ogg',
		'sound/weapons/reloads/shotgun_pump4.ogg',
		'sound/weapons/reloads/shotgun_pump5.ogg',
		'sound/weapons/reloads/shotgun_pump6.ogg',
		'sound/weapons/reloads/shotgun_pump7.ogg',
		'sound/weapons/reloads/shotgun_pump8.ogg'
	)

/singleton/sound_category/shotgun_reload
	sounds = list(
		'sound/weapons/reloads/reload_shell.ogg',
		'sound/weapons/reloads/reload_shell2.ogg',
		'sound/weapons/reloads/reload_shell3.ogg',
		'sound/weapons/reloads/reload_shell4.ogg'
	)

/singleton/sound_category/heavy_machine_gun_reload
	sounds = list(
		'sound/weapons/reloads/hmg_reload1.ogg',
		'sound/weapons/reloads/hmg_reload2.ogg',
		'sound/weapons/reloads/hmg_reload3.ogg'
	)
/singleton/sound_category/drillhit_sound
	sounds = list(
		'sound/weapons/saw/drillhit1.ogg',
		'sound/weapons/saw/drillhit2.ogg'
	)

/singleton/sound_category/generic_drop_sound
	sounds = list(
		'sound/items/drop/generic1.ogg',
		'sound/items/drop/generic2.ogg'
	)
/singleton/sound_category/generic_pickup_sound
	sounds = list(
		'sound/items/pickup/generic1.ogg',
		'sound/items/pickup/generic2.ogg',
		'sound/items/pickup/generic3.ogg'
	)
/singleton/sound_category/generic_wield_sound
	sounds = list(
		'sound/items/wield/generic1.ogg',
		'sound/items/wield/generic2.ogg',
		'sound/items/wield/generic3.ogg'
	)

/singleton/sound_category/generic_pour_sound
	sounds = list(
		'sound/effects/pour1.ogg',
		'sound/effects/pour2.ogg'
	)

/singleton/sound_category/wield_generic_sound
	sounds = list(
		'sound/items/wield/generic1.ogg',
		'sound/items/wield/generic2.ogg',
		'sound/items/wield/generic3.ogg'
	)

/singleton/sound_category/sword_pickup_sound
	sounds = list(
		'sound/items/pickup/sword1.ogg',
		'sound/items/pickup/sword2.ogg',
		'sound/items/pickup/sword3.ogg'
	)

/singleton/sound_category/sword_equip_sound
	sounds = list(
		'sound/items/equip/sword1.ogg',
		'sound/items/equip/sword2.ogg'
	)

/singleton/sound_category/gauss_fire_sound
	sounds = list(
		'sound/weapons/gaussrifle1.ogg',
		'sound/weapons/gaussrifle2.ogg'
	)

/singleton/sound_category/bottle_hit_intact_sound
	sounds = list(
		'sound/weapons/bottlehit_intact1.ogg',
		'sound/weapons/bottlehit_intact2.ogg',
		'sound/weapons/bottlehit_intact3.ogg'
	)
/singleton/sound_category/bottle_hit_broken
	sounds = list(
		'sound/weapons/bottlehit_broken1.ogg',
		'sound/weapons/bottlehit_broken2.ogg',
		'sound/weapons/bottlehit_broken3.ogg'
	)
/singleton/sound_category/tray_hit_sound
	sounds = list(
		'sound/items/trayhit1.ogg',
		'sound/items/trayhit2.ogg'
	)

/singleton/sound_category/grab_sound
	sounds = list(
	'sound/weapons/grab/grab1.ogg',
	'sound/weapons/grab/grab2.ogg',
	'sound/weapons/grab/grab3.ogg',
	'sound/weapons/grab/grab4.ogg',
	'sound/weapons/grab/grab5.ogg'
)

/singleton/sound_category/gunshots
	sounds = list(
	'sound/weapons/gunshot/bolter.ogg',
	'sound/weapons/laser1.ogg',
	'sound/weapons/Laser2.ogg',
	'sound/weapons/laser3.ogg',
	'sound/weapons/lasercannonfire.ogg',
	'sound/weapons/marauder.ogg',
	'sound/weapons/laserdeep.ogg',
	'sound/weapons/laserstrong.ogg',
	'sound/weapons/gunshot/gunshot_dmr.ogg',
	'sound/weapons/gunshot/gunshot_light.ogg',
	'sound/weapons/gunshot/gunshot_mateba.ogg',
	'sound/weapons/gunshot/gunshot_pistol.ogg',
	'sound/weapons/gunshot/gunshot_revolver.ogg',
	'sound/weapons/gunshot/gunshot_rifle.ogg',
	'sound/weapons/gunshot/gunshot_saw.ogg',
	'sound/weapons/gunshot/gunshot_shotgun.ogg',
	'sound/weapons/gunshot/gunshot_shotgun2.ogg',
	'sound/weapons/gunshot/gunshot_smg.ogg',
	'sound/weapons/gunshot/gunshot_strong.ogg',
	'sound/weapons/gunshot/gunshot_suppressed.ogg',
	'sound/weapons/gunshot/gunshot_svd.ogg',
	'sound/weapons/gunshot/gunshot_tommygun.ogg',
	'sound/weapons/gunshot/gunshot1.ogg',
	'sound/weapons/gunshot/gunshot2.ogg',
	'sound/weapons/gunshot/gunshot3.ogg',
	'sound/weapons/gunshot/musket.ogg',
	'sound/weapons/gunshot/slammer.ogg'
)

/singleton/sound_category/gunshots/ballistic
	sounds = list(
	'sound/weapons/gunshot/gunshot_dmr.ogg',
	'sound/weapons/gunshot/gunshot_light.ogg',
	'sound/weapons/gunshot/gunshot_mateba.ogg',
	'sound/weapons/gunshot/gunshot_pistol.ogg',
	'sound/weapons/gunshot/gunshot_revolver.ogg',
	'sound/weapons/gunshot/gunshot_rifle.ogg',
	'sound/weapons/gunshot/gunshot_saw.ogg',
	'sound/weapons/gunshot/gunshot_shotgun.ogg',
	'sound/weapons/gunshot/gunshot_shotgun2.ogg',
	'sound/weapons/gunshot/gunshot_smg.ogg',
	'sound/weapons/gunshot/gunshot_strong.ogg',
	'sound/weapons/gunshot/gunshot_suppressed.ogg',
	'sound/weapons/gunshot/gunshot_svd.ogg',
	'sound/weapons/gunshot/gunshot_tommygun.ogg',
	'sound/weapons/gunshot/gunshot1.ogg',
	'sound/weapons/gunshot/gunshot2.ogg',
	'sound/weapons/gunshot/gunshot3.ogg',
	'sound/weapons/gunshot/musket.ogg',
	'sound/weapons/gunshot/slammer.ogg'
)

/singleton/sound_category/gunshots/energy
	sounds = list(
	'sound/weapons/gunshot/bolter.ogg',
	'sound/weapons/laser1.ogg',
	'sound/weapons/Laser2.ogg',
	'sound/weapons/laser3.ogg',
	'sound/weapons/lasercannonfire.ogg',
	'sound/weapons/marauder.ogg',
	'sound/weapons/laserdeep.ogg',
	'sound/weapons/laserstrong.ogg'
)

/singleton/sound_category/shaker_shaking
	sounds = list(
		'sound/items/shaking1.ogg',
		'sound/items/shaking2.ogg',
		'sound/items/shaking3.ogg',
		'sound/items/shaking4.ogg',
		'sound/items/shaking5.ogg',
		'sound/items/shaking6.ogg'
	)

/singleton/sound_category/shaker_lid_off
	sounds = list(
		'sound/items/shaker_lid_off1.ogg',
		'sound/items/shaker_lid_off2.ogg'
	)

/singleton/sound_category/boops
	sounds = list(
		'sound/machines/boop1.ogg',
		'sound/machines/boop2.ogg'
	)

/singleton/sound_category/quick_arcade // quick punchy arcade sounds
	sounds = list(
		'sound/arcade/get_fuel.ogg',
		'sound/arcade/heal.ogg',
		'sound/arcade/hit.ogg',
		'sound/arcade/kill_crew.ogg',
		'sound/arcade/lose_fuel.ogg',
		'sound/arcade/mana.ogg',
		'sound/arcade/steal.ogg'
	)

/singleton/sound_category/footstep_skrell_sound
	sounds = list(
		'sound/effects/footstep_skrell1.ogg',
		'sound/effects/footstep_skrell2.ogg',
		'sound/effects/footstep_skrell3.ogg',
		'sound/effects/footstep_skrell4.ogg',
		'sound/effects/footstep_skrell5.ogg',
		'sound/effects/footstep_skrell6.ogg'
	)

/singleton/sound_category/footstep_unathi_sound
	sounds = list(
		'sound/effects/footstep_unathi1.ogg',
		'sound/effects/footstep_unathi2.ogg',
		'sound/effects/footstep_unathi3.ogg',
		'sound/effects/footstep_unathi4.ogg',
		'sound/effects/footstep_unathi5.ogg'
	)

/singleton/sound_category/hammer_sound
	sounds = list(
		'sound/items/tools/hammer1.ogg',
		'sound/items/tools/hammer2.ogg',
		'sound/items/tools/hammer3.ogg',
		'sound/items/tools/hammer4.ogg'
	)

/singleton/sound_category/shovel_sound
	sounds = list(
		'sound/items/tools/shovel1.ogg',
		'sound/items/tools/shovel2.ogg',
		'sound/items/tools/shovel3.ogg'
	)

/singleton/sound_category/supermatter_calm
	sounds = list(
					'sound/machines/sm/accent/normal/1.ogg',
					'sound/machines/sm/accent/normal/2.ogg',
					'sound/machines/sm/accent/normal/3.ogg',
					'sound/machines/sm/accent/normal/4.ogg',
					'sound/machines/sm/accent/normal/5.ogg',
					'sound/machines/sm/accent/normal/6.ogg',
					'sound/machines/sm/accent/normal/7.ogg',
					'sound/machines/sm/accent/normal/8.ogg',
					'sound/machines/sm/accent/normal/9.ogg',
					'sound/machines/sm/accent/normal/10.ogg',
					'sound/machines/sm/accent/normal/11.ogg',
					'sound/machines/sm/accent/normal/12.ogg',
					'sound/machines/sm/accent/normal/13.ogg',
					'sound/machines/sm/accent/normal/14.ogg',
					'sound/machines/sm/accent/normal/15.ogg',
					'sound/machines/sm/accent/normal/16.ogg',
					'sound/machines/sm/accent/normal/17.ogg',
					'sound/machines/sm/accent/normal/18.ogg',
					'sound/machines/sm/accent/normal/19.ogg',
					'sound/machines/sm/accent/normal/20.ogg',
					'sound/machines/sm/accent/normal/21.ogg',
					'sound/machines/sm/accent/normal/22.ogg',
					'sound/machines/sm/accent/normal/23.ogg',
					'sound/machines/sm/accent/normal/24.ogg',
					'sound/machines/sm/accent/normal/25.ogg',
					'sound/machines/sm/accent/normal/26.ogg',
					'sound/machines/sm/accent/normal/27.ogg',
					'sound/machines/sm/accent/normal/28.ogg',
					'sound/machines/sm/accent/normal/29.ogg',
					'sound/machines/sm/accent/normal/30.ogg',
					'sound/machines/sm/accent/normal/31.ogg',
					'sound/machines/sm/accent/normal/32.ogg',
					'sound/machines/sm/accent/normal/33.ogg'
				)

/singleton/sound_category/supermatter_delam
	sounds = list(
					'sound/machines/sm/accent/delam/1.ogg',
					'sound/machines/sm/accent/delam/2.ogg',
					'sound/machines/sm/accent/delam/3.ogg',
					'sound/machines/sm/accent/delam/4.ogg',
					'sound/machines/sm/accent/delam/5.ogg',
					'sound/machines/sm/accent/delam/6.ogg',
					'sound/machines/sm/accent/delam/7.ogg',
					'sound/machines/sm/accent/delam/8.ogg',
					'sound/machines/sm/accent/delam/9.ogg',
					'sound/machines/sm/accent/delam/10.ogg',
					'sound/machines/sm/accent/delam/11.ogg',
					'sound/machines/sm/accent/delam/12.ogg',
					'sound/machines/sm/accent/delam/13.ogg',
					'sound/machines/sm/accent/delam/14.ogg',
					'sound/machines/sm/accent/delam/15.ogg',
					'sound/machines/sm/accent/delam/16.ogg',
					'sound/machines/sm/accent/delam/17.ogg',
					'sound/machines/sm/accent/delam/18.ogg',
					'sound/machines/sm/accent/delam/19.ogg',
					'sound/machines/sm/accent/delam/20.ogg',
					'sound/machines/sm/accent/delam/21.ogg',
					'sound/machines/sm/accent/delam/22.ogg',
					'sound/machines/sm/accent/delam/23.ogg',
					'sound/machines/sm/accent/delam/24.ogg',
					'sound/machines/sm/accent/delam/25.ogg',
					'sound/machines/sm/accent/delam/26.ogg',
					'sound/machines/sm/accent/delam/27.ogg',
					'sound/machines/sm/accent/delam/28.ogg',
					'sound/machines/sm/accent/delam/29.ogg',
					'sound/machines/sm/accent/delam/30.ogg',
					'sound/machines/sm/accent/delam/31.ogg',
					'sound/machines/sm/accent/delam/32.ogg',
					'sound/machines/sm/accent/delam/33.ogg'
				)

/singleton/sound_category/rip_sound
	sounds = list(
		'sound/items/rip1.ogg',
		'sound/items/rip2.ogg',
		'sound/items/rip3.ogg',
		'sound/items/rip4.ogg'
	)

/singleton/sound_category/ointment_sound
	sounds = list(
		'sound/items/ointment1.ogg',
		'sound/items/ointment2.ogg',
		'sound/items/ointment3.ogg'
	)

/singleton/sound_category/clown_sound
	sounds = list(
		'sound/effects/clownstep1.ogg',
		'sound/effects/clownstep2.ogg'
	)

/singleton/sound_category/hivebot_melee
	sounds = list(
		'sound/effects/creatures/hivebot/hivebot-attack.ogg',
		'sound/effects/creatures/hivebot/hivebot-attack-001.ogg'
	)

/singleton/sound_category/hivebot_wail
	sounds = list(
		'sound/effects/creatures/hivebot/hivebot-bark-001.ogg',
		'sound/effects/creatures/hivebot/hivebot-bark-003.ogg',
		'sound/effects/creatures/hivebot/hivebot-bark-005.ogg',
	)

/singleton/sound_category/print_sound
	sounds = list(
		'sound/items/polaroid1.ogg',
		'sound/items/polaroid2.ogg'
	)

/singleton/sound_category/hatch_open
	sounds = list(
		'sound/machines/hatch_open1.ogg',
		'sound/machines/hatch_open2.ogg',
		'sound/machines/hatch_open3.ogg',
		'sound/machines/hatch_open4.ogg'
	)

/singleton/sound_category/hatch_close
	sounds = list(
		'sound/machines/hatch_close1.ogg',
		'sound/machines/hatch_close2.ogg'
	)

/singleton/sound_category/electrical_hum
	sounds = list(
		'sound/machines/electrical_hum1.ogg',
		'sound/machines/electrical_hum2.ogg'
	)

/singleton/sound_category/electrical_spark
	sounds = list(
		'sound/machines/electrical_spark1.ogg'
	)

/singleton/sound_category/steam_pipe
	sounds = list(
		'sound/machines/steam_pipe1.ogg',
		'sound/machines/steam_pipe2.ogg',
		'sound/machines/steam_pipe3.ogg',
		'sound/machines/steam_pipe4.ogg'
	)
