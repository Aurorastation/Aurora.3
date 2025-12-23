/**
 * Sound_effect datum
 * Use for when you need multiple sound files to play at random in a playsound
 * Initialized and added to sfx_datum_by_key in /datum/controller/subsystem/sounds/init_sound_keys()
 * See also 'code\__DEFINES\sound.dm'
 */
/datum/sound_effect
	/// sfx key define with which we are associated with, see code\__DEFINES\sound.dm
	var/key
	/// list of paths to our files, use the /assoc subtype if your paths are weighted
	var/list/file_paths

/datum/sound_effect/proc/return_sfx()
	return pick(file_paths)

/datum/sound_effect/blank_footsteps
	key = SFX_FOOTSTEP_BLANK
	file_paths = list('sound/effects/footstep/blank.ogg')

/datum/sound_effect/catwalk_footstep
	key = SFX_FOOTSTEP_CATWALK
	file_paths = list(
		'sound/effects/footstep/catwalk1.ogg',
		'sound/effects/footstep/catwalk2.ogg',
		'sound/effects/footstep/catwalk3.ogg',
		'sound/effects/footstep/catwalk4.ogg',
		'sound/effects/footstep/catwalk5.ogg'
	)

/datum/sound_effect/wood_footstep
	key = SFX_FOOTSTEP_WOOD
	file_paths = list(
		'sound/effects/footstep/wood1.ogg',
		'sound/effects/footstep/wood2.ogg',
		'sound/effects/footstep/wood3.ogg',
		'sound/effects/footstep/wood4.ogg',
		'sound/effects/footstep/wood5.ogg'
	)

/datum/sound_effect/tiles_footstep
	key = SFX_FOOTSTEP_TILES
	file_paths = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'
	)

/datum/sound_effect/plating_footstep
	key = SFX_FOOTSTEP_PLATING
	file_paths = list(
		'sound/effects/footstep/plating1.ogg',
		'sound/effects/footstep/plating2.ogg',
		'sound/effects/footstep/plating3.ogg',
		'sound/effects/footstep/plating4.ogg',
		'sound/effects/footstep/plating5.ogg'
	)

/datum/sound_effect/carpet_footstep
	key = SFX_FOOTSTEP_CARPET
	file_paths = list(
		'sound/effects/footstep/carpet1.ogg',
		'sound/effects/footstep/carpet2.ogg',
		'sound/effects/footstep/carpet3.ogg',
		'sound/effects/footstep/carpet4.ogg',
		'sound/effects/footstep/carpet5.ogg'
	)

/datum/sound_effect/asteroid_footstep
	key = SFX_FOOTSTEP_ASTEROID
	file_paths = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg',
		'sound/effects/footstep/asteroid5.ogg'
	)

/datum/sound_effect/grass_footstep
	key = SFX_FOOTSTEP_GRASS
	file_paths = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'
	)

/datum/sound_effect/water_footstep
	key = SFX_FOOTSTEP_WATER
	file_paths = list(
		'sound/effects/footstep/water1.ogg',
		'sound/effects/footstep/water2.ogg',
		'sound/effects/footstep/water3.ogg',
		'sound/effects/footstep/water4.ogg'
	)

/datum/sound_effect/lava_footstep
	key = SFX_FOOTSTEP_LAVA
	file_paths = list(
		'sound/effects/footstep/lava1.ogg',
		'sound/effects/footstep/lava2.ogg',
		'sound/effects/footstep/lava3.ogg'
	)

/datum/sound_effect/snow_footstep
	key = SFX_FOOTSTEP_SNOW
	file_paths = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg'
	)

/datum/sound_effect/sand_footstep
	key = SFX_FOOTSTEP_SAND
	file_paths = list(
		'sound/effects/footstep/sand1.ogg',
		'sound/effects/footstep/sand2.ogg',
		'sound/effects/footstep/sand3.ogg',
		'sound/effects/footstep/sand4.ogg'
	)

/datum/sound_effect/glass_break_sound
	key = SFX_BREAK_GLASS
	file_paths = list(
		'sound/effects/glass_break1.ogg',
		'sound/effects/glass_break2.ogg',
		'sound/effects/glass_break3.ogg'
	)

/datum/sound_effect/cardboard_break_sound
	key = SFX_BREAK_CARDBOARD
	file_paths = list(
		'sound/effects/cardboard_break1.ogg',
		'sound/effects/cardboard_break2.ogg',
		'sound/effects/cardboard_break3.ogg',
	)

/datum/sound_effect/wood_break_sound
	key = SFX_BREAK_WOOD
	file_paths = list(
		'sound/effects/wood_break1.ogg',
		'sound/effects/wood_break2.ogg',
		'sound/effects/wood_break3.ogg'
	)

/datum/sound_effect/explosion_sound
	key = SFX_EXPLOSION
	file_paths = list(
		'sound/effects/Explosion1.ogg',
		'sound/effects/Explosion2.ogg'
	)

/datum/sound_effect/spark_sound
	key = SFX_SPARKS
	file_paths = list(
		'sound/effects/sparks1.ogg',
		'sound/effects/sparks2.ogg',
		'sound/effects/sparks3.ogg',
		'sound/effects/sparks4.ogg'
	)

/datum/sound_effect/rustle_sound
	key = SFX_RUSTLE
	file_paths = list(
		'sound/items/storage/rustle1.ogg',
		'sound/items/storage/rustle2.ogg',
		'sound/items/storage/rustle3.ogg',
		'sound/items/storage/rustle4.ogg',
		'sound/items/storage/rustle5.ogg'
	)

/datum/sound_effect/punch_sound
	key = SFX_PUNCH
	file_paths = list(
		'sound/weapons/punch1.ogg',
		'sound/weapons/punch2.ogg',
		'sound/weapons/punch3.ogg',
		'sound/weapons/punch4.ogg'
	)

/datum/sound_effect/punch_bassy_sound
	key = SFX_PUNCH_BASSY
	file_paths = list(
		'sound/weapons/punch1_bass.ogg',
		'sound/weapons/punch2_bass.ogg',
		'sound/weapons/punch3_bass.ogg',
		'sound/weapons/punch4_bass.ogg'
	)

/datum/sound_effect/punchmiss_sound
	key = SFX_PUNCH_MISS
	file_paths = list(
		'sound/weapons/punchmiss1.ogg',
		'sound/weapons/punchmiss2.ogg'
	)

/datum/sound_effect/swing_hit_sound
	key = SFX_SWING_HIT
	file_paths = list(
		'sound/weapons/genhit1.ogg',
		'sound/weapons/genhit2.ogg',
		'sound/weapons/genhit3.ogg'
	)

/datum/sound_effect/hiss_sound
	key = SFX_HISS
	file_paths = list(
		'sound/voice/hiss1.ogg',
		'sound/voice/hiss2.ogg',
		'sound/voice/hiss3.ogg',
		'sound/voice/hiss4.ogg'
	)

/datum/sound_effect/page_sound
	key = SFX_PAGE_TURN
	file_paths = list(
		'sound/effects/pageturn1.ogg',
		'sound/effects/pageturn2.ogg',
		'sound/effects/pageturn3.ogg'
	)

/datum/sound_effect/fracture_sound
	key = SFX_FRACTURE
	file_paths = list(
		'sound/effects/bonebreak1.ogg',
		'sound/effects/bonebreak2.ogg',
		'sound/effects/bonebreak3.ogg',
		'sound/effects/bonebreak4.ogg'
	)

/datum/sound_effect/button_sound
	key = SFX_BUTTON
	file_paths = list(
		'sound/machines/button1.ogg',
		'sound/machines/button2.ogg',
		'sound/machines/button3.ogg',
		'sound/machines/button4.ogg'
	)

/datum/sound_effect/computerbeep_sound
	key = SFX_COMPUTER_BEEP
	file_paths = list(
		'sound/machines/compbeep1.ogg',
		'sound/machines/compbeep2.ogg',
		'sound/machines/compbeep3.ogg',
		'sound/machines/compbeep4.ogg',
		'sound/machines/compbeep5.ogg'
	)

/datum/sound_effect/boops
	key = SFX_COMPUTER_BOOP
	file_paths = list(
		'sound/machines/boop1.ogg',
		'sound/machines/boop2.ogg'
	)

/datum/sound_effect/switch_sound
	key = SFX_SWITCH
	file_paths = list(
		'sound/machines/switch1.ogg',
		'sound/machines/switch2.ogg',
		'sound/machines/switch3.ogg',
		'sound/machines/switch4.ogg'
	)

/datum/sound_effect/keyboard_sound
	key = SFX_KEYBOARD
	file_paths = list(
		'sound/machines/keyboard/keyboard1.ogg',
		'sound/machines/keyboard/keyboard2.ogg',
		'sound/machines/keyboard/keyboard3.ogg',
		'sound/machines/keyboard/keyboard4.ogg',
		'sound/machines/keyboard/keyboard5.ogg'
	)

/datum/sound_effect/pickaxe_sound
	key = SFX_PICKAXE
	file_paths = list(
		'sound/weapons/mine/pickaxe1.ogg',
		'sound/weapons/mine/pickaxe2.ogg',
		'sound/weapons/mine/pickaxe3.ogg',
		'sound/weapons/mine/pickaxe4.ogg'
	)

/datum/sound_effect/glasscrack_sound
	key = SFX_GLASS_CRACK
	file_paths = list(
		'sound/effects/glass_crack1.ogg',
		'sound/effects/glass_crack2.ogg',
		'sound/effects/glass_crack3.ogg',
		'sound/effects/glass_crack4.ogg'
	)

/datum/sound_effect/bodyfall_sound
	key = SFX_BODYFALL
	file_paths = list(
		'sound/effects/bodyfall1.ogg',
		'sound/effects/bodyfall2.ogg',
		'sound/effects/bodyfall3.ogg',
		'sound/effects/bodyfall4.ogg'
	)

/datum/sound_effect/bodyfall_skrell_sound
	key = SFX_BODYFALL_SKRELL
	file_paths = list(
		'sound/effects/bodyfall_skrell1.ogg',
		'sound/effects/bodyfall_skrell2.ogg',
		'sound/effects/bodyfall_skrell3.ogg',
		'sound/effects/bodyfall_skrell4.ogg'
	)

/datum/sound_effect/bodyfall_machine_sound
	key = SFX_BODYFALL_MACHINE
	file_paths = list(
		'sound/effects/bodyfall_machine1.ogg',
		'sound/effects/bodyfall_machine2.ogg'
	)
/datum/sound_effect/bulletflyby_sound
	key = SFX_BULLET_MISS
	file_paths = list(
		'sound/effects/bulletflyby1.ogg',
		'sound/effects/bulletflyby2.ogg',
		'sound/effects/bulletflyby3.ogg'
	)

/datum/sound_effect/screwdriver_sound
	key = SFX_SCREWDRIVER
	file_paths = list(
		'sound/items/Screwdriver.ogg',
		'sound/items/Screwdriver2.ogg'
	)

/datum/sound_effect/crowbar_sound
	key = SFX_CROWBAR
	file_paths = list(
		'sound/items/crowbar1.ogg',
		'sound/items/crowbar2.ogg',
		'sound/items/crowbar3.ogg',
		'sound/items/crowbar4.ogg'
	)

/datum/sound_effect/casing_drop_sound
	key = SFX_CASING_DROP
	file_paths = list(
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

/datum/sound_effect/casing_drop_sound_shotgun
	key = SFX_CASING_DROP_SHOTGUN
	file_paths = list(
		'sound/items/drop/casing_shotgun1.ogg',
		'sound/items/drop/casing_shotgun2.ogg',
		'sound/items/drop/casing_shotgun3.ogg',
		'sound/items/drop/casing_shotgun4.ogg',
		'sound/items/drop/casing_shotgun5.ogg'
	)

/datum/sound_effect/out_of_ammo
	key = SFX_OUT_OF_AMMO
	file_paths = list(
		'sound/weapons/empty/empty2.ogg',
		'sound/weapons/empty/empty3.ogg',
		'sound/weapons/empty/empty4.ogg',
		'sound/weapons/empty/empty5.ogg',
		'sound/weapons/empty/empty6.ogg'
	)

/datum/sound_effect/out_of_ammo_revolver
	key = SFX_OUT_OF_AMMO_REVOLVER
	file_paths = list(
		'sound/weapons/empty/empty_revolver.ogg',
		'sound/weapons/empty/empty_revolver3.ogg'
	)

/datum/sound_effect/out_of_ammo_rifle
	key = SFX_OUT_OF_AMMO_RIFLE
	file_paths = list(
		'sound/weapons/empty/empty_rifle1.ogg',
		'sound/weapons/empty/empty_rifle2.ogg'
	)

/datum/sound_effect/out_of_ammo_shotgun
	key = SFX_OUT_OF_AMMO_SHOTGUN
	file_paths = list(
		'sound/weapons/empty/empty_shotgun1.ogg'
	)

/datum/sound_effect/metal_slide_reload
	key = SFX_RELOAD_METAL_SLIDE
	file_paths = list(
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

/datum/sound_effect/polymer_slide_reload
	key = SFX_RELOAD_POLYMER_SLIDE
	file_paths = list(
		'sound/weapons/reloads/pistol_polymer_slide1.ogg',
		'sound/weapons/reloads/pistol_polymer_slide2.ogg',
		'sound/weapons/reloads/pistol_polymer_slide3.ogg',
		'sound/weapons/reloads/pistol_polymer_slide4.ogg',
		'sound/weapons/reloads/pistol_polymer_slide5.ogg'
	)

/datum/sound_effect/rifle_slide_reload
	key = SFX_RELOAD_RIFLE_SLIDE
	file_paths = list(
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

/datum/sound_effect/revolver_reload
	key = SFX_RELOAD_REVOLVER
	file_paths = list(
		'sound/weapons/reloads/revolver_reload.ogg'
	)
/datum/sound_effect/shotgun_pump
	key = SFX_PUMP_SHOTGUN
	file_paths = list(
		'sound/weapons/reloads/shotgun_pump2.ogg',
		'sound/weapons/reloads/shotgun_pump3.ogg',
		'sound/weapons/reloads/shotgun_pump4.ogg',
		'sound/weapons/reloads/shotgun_pump5.ogg',
		'sound/weapons/reloads/shotgun_pump6.ogg',
		'sound/weapons/reloads/shotgun_pump7.ogg',
		'sound/weapons/reloads/shotgun_pump8.ogg'
	)

/datum/sound_effect/shotgun_reload
	key = SFX_RELOAD_SHOTGUN
	file_paths = list(
		'sound/weapons/reloads/reload_shell.ogg',
		'sound/weapons/reloads/reload_shell2.ogg',
		'sound/weapons/reloads/reload_shell3.ogg',
		'sound/weapons/reloads/reload_shell4.ogg'
	)

/datum/sound_effect/heavy_machine_gun_reload
	key = SFX_RELOAD_HMG
	file_paths = list(
		'sound/weapons/reloads/hmg_reload1.ogg',
		'sound/weapons/reloads/hmg_reload2.ogg',
		'sound/weapons/reloads/hmg_reload3.ogg'
	)
/datum/sound_effect/drillhit_sound
	key = SFX_DRILL_HIT
	file_paths = list(
		'sound/weapons/saw/drillhit1.ogg',
		'sound/weapons/saw/drillhit2.ogg'
	)

/datum/sound_effect/generic_drop_sound
	key = SFX_DROP
	file_paths = list(
		'sound/items/drop/generic1.ogg',
		'sound/items/drop/generic2.ogg'
	)
/datum/sound_effect/generic_pickup_sound
	key = SFX_PICKUP
	file_paths = list(
		'sound/items/pickup/generic1.ogg',
		'sound/items/pickup/generic2.ogg',
		'sound/items/pickup/generic3.ogg'
	)
/datum/sound_effect/generic_wield_sound
	key = SFX_WIELD
	file_paths = list(
		'sound/items/wield/generic1.ogg',
		'sound/items/wield/generic2.ogg',
		'sound/items/wield/generic3.ogg'
	)

/datum/sound_effect/generic_pour_sound
	key = SFX_POUR
	file_paths = list(
		'sound/effects/pour1.ogg',
		'sound/effects/pour2.ogg'
	)

/datum/sound_effect/sword_pickup_sound
	key = SFX_PICKUP_SWORD
	file_paths = list(
		'sound/items/pickup/sword1.ogg',
		'sound/items/pickup/sword2.ogg',
		'sound/items/pickup/sword3.ogg'
	)

/datum/sound_effect/sword_equip_sound
	key = SFX_EQUIP_SWORD
	file_paths = list(
		'sound/items/equip/sword1.ogg',
		'sound/items/equip/sword2.ogg'
	)

/datum/sound_effect/gauss_fire_sound
	key = SFX_SHOOT_GAUSS
	file_paths = list(
		'sound/weapons/gaussrifle1.ogg',
		'sound/weapons/gaussrifle2.ogg'
	)

/datum/sound_effect/bottle_hit_intact_sound
	key = SFX_BOTTLE_HIT_INTACT
	file_paths = list(
		'sound/weapons/bottlehit_intact1.ogg',
		'sound/weapons/bottlehit_intact2.ogg',
		'sound/weapons/bottlehit_intact3.ogg'
	)
/datum/sound_effect/bottle_hit_broken
	key = SFX_BOTTLE_HIT_BROKEN
	file_paths = list(
		'sound/weapons/bottlehit_broken1.ogg',
		'sound/weapons/bottlehit_broken2.ogg',
		'sound/weapons/bottlehit_broken3.ogg'
	)
/datum/sound_effect/tray_hit_sound
	key = SFX_TRAY_HIT
	file_paths = list(
		'sound/items/trayhit1.ogg',
		'sound/items/trayhit2.ogg'
	)

/datum/sound_effect/grab_sound
	key = SFX_GRAB
	file_paths = list(
	'sound/weapons/grab/grab1.ogg',
	'sound/weapons/grab/grab2.ogg',
	'sound/weapons/grab/grab3.ogg',
	'sound/weapons/grab/grab4.ogg',
	'sound/weapons/grab/grab5.ogg'
)

/datum/sound_effect/gunshots
	key = SFX_GUNSHOT_ANY
	file_paths = list(
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

/datum/sound_effect/gunshots/ballistic
	key = SFX_GUNSHOT_BALLISTIC
	file_paths = list(
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

/datum/sound_effect/gunshots/energy
	key = SFX_GUNSHOT_ENERGY
	file_paths = list(
	'sound/weapons/gunshot/bolter.ogg',
	'sound/weapons/laser1.ogg',
	'sound/weapons/Laser2.ogg',
	'sound/weapons/laser3.ogg',
	'sound/weapons/lasercannonfire.ogg',
	'sound/weapons/marauder.ogg',
	'sound/weapons/laserdeep.ogg',
	'sound/weapons/laserstrong.ogg'
)

/datum/sound_effect/shaker_shaking
	key = SFX_SHAKER_SHAKING
	file_paths = list(
		'sound/items/shaking1.ogg',
		'sound/items/shaking2.ogg',
		'sound/items/shaking3.ogg',
		'sound/items/shaking4.ogg',
		'sound/items/shaking5.ogg',
		'sound/items/shaking6.ogg'
	)

/datum/sound_effect/shaker_lid_off
	key = SFX_SHAKER_LID_OFF
	file_paths = list(
		'sound/items/shaker_lid_off1.ogg',
		'sound/items/shaker_lid_off2.ogg'
	)

/datum/sound_effect/quick_arcade
	key = SFX_ARCADE
	file_paths = list(
		'sound/arcade/get_fuel.ogg',
		'sound/arcade/heal.ogg',
		'sound/arcade/hit.ogg',
		'sound/arcade/kill_crew.ogg',
		'sound/arcade/lose_fuel.ogg',
		'sound/arcade/mana.ogg',
		'sound/arcade/steal.ogg'
	)

/datum/sound_effect/footstep_skrell_sound
	key = SFX_FOOTSTEP_SKRELL
	file_paths = list(
		'sound/effects/footstep_skrell1.ogg',
		'sound/effects/footstep_skrell2.ogg',
		'sound/effects/footstep_skrell3.ogg',
		'sound/effects/footstep_skrell4.ogg',
		'sound/effects/footstep_skrell5.ogg',
		'sound/effects/footstep_skrell6.ogg'
	)

/datum/sound_effect/footstep_unathi_sound
	key = SFX_FOOTSTEP_UNATHI
	file_paths = list(
		'sound/effects/footstep_unathi1.ogg',
		'sound/effects/footstep_unathi2.ogg',
		'sound/effects/footstep_unathi3.ogg',
		'sound/effects/footstep_unathi4.ogg',
		'sound/effects/footstep_unathi5.ogg'
	)

/datum/sound_effect/hammer_sound
	key = SFX_HAMMER
	file_paths = list(
		'sound/items/tools/hammer1.ogg',
		'sound/items/tools/hammer2.ogg',
		'sound/items/tools/hammer3.ogg',
		'sound/items/tools/hammer4.ogg'
	)

/datum/sound_effect/shovel_sound
	key = SFX_SHOVEL
	file_paths = list(
		'sound/items/tools/shovel1.ogg',
		'sound/items/tools/shovel2.ogg',
		'sound/items/tools/shovel3.ogg'
	)

/datum/sound_effect/supermatter_calm
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
					'sound/machines/sm/accent/normal/33.ogg'
				)

/datum/sound_effect/supermatter_delam
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
					'sound/machines/sm/accent/delam/33.ogg'
				)

/datum/sound_effect/rip_sound
	key = SFX_RIP
	file_paths = list(
		'sound/items/rip1.ogg',
		'sound/items/rip2.ogg',
		'sound/items/rip3.ogg',
		'sound/items/rip4.ogg'
	)

/datum/sound_effect/ointment_sound
	key = SFX_OINTMENT
	file_paths = list(
		'sound/items/ointment1.ogg',
		'sound/items/ointment2.ogg',
		'sound/items/ointment3.ogg'
	)

/datum/sound_effect/clown_sound
	key = SFX_FOOTSTEP_CLOWN
	file_paths = list(
		'sound/effects/clownstep1.ogg',
		'sound/effects/clownstep2.ogg'
	)

/datum/sound_effect/hivebot_melee
	key = SFX_HIVEBOT_MELEE
	file_paths = list(
		'sound/effects/creatures/hivebot/hivebot-attack.ogg',
		'sound/effects/creatures/hivebot/hivebot-attack-001.ogg'
	)

/datum/sound_effect/hivebot_wail
	key = SFX_HIVEBOT_WAIL
	file_paths = list(
		'sound/effects/creatures/hivebot/hivebot-bark-001.ogg',
		'sound/effects/creatures/hivebot/hivebot-bark-003.ogg',
		'sound/effects/creatures/hivebot/hivebot-bark-005.ogg',
	)

/datum/sound_effect/print_sound
	key = SFX_PRINT
	file_paths = list(
		'sound/items/polaroid1.ogg',
		'sound/items/polaroid2.ogg'
	)

/datum/sound_effect/hatch_open
	key = SFX_HATCH_OPEN
	file_paths = list(
		'sound/machines/hatch_open1.ogg',
		'sound/machines/hatch_open2.ogg',
		'sound/machines/hatch_open3.ogg',
		'sound/machines/hatch_open4.ogg'
	)

/datum/sound_effect/hatch_close
	key = SFX_HATCH_CLOSE
	file_paths = list(
		'sound/machines/hatch_close1.ogg',
		'sound/machines/hatch_close2.ogg'
	)

/datum/sound_effect/electrical_hum
	key = SFX_ELECTRICAL_HUM
	file_paths = list(
		'sound/machines/electrical_hum1.ogg',
		'sound/machines/electrical_hum2.ogg'
	)

// Few seconds of sparking sounds, unlike SFX_SPARKS, which is just a single spark sound.
/datum/sound_effect/electrical_spark
	key = SFX_ELECTRICAL_SPARK
	file_paths = list(
		'sound/machines/electrical_spark1.ogg'
	)

/datum/sound_effect/steam_pipe
	key = SFX_STEAM_PIPE
	file_paths = list(
		'sound/machines/steam_pipe1.ogg',
		'sound/machines/steam_pipe2.ogg',
		'sound/machines/steam_pipe3.ogg',
		'sound/machines/steam_pipe4.ogg'
	)

/datum/sound_effect/bear_loud
	key = SFX_ANIMAL_BEAR
	file_paths = list(
		'sound/effects/creatures/bear_loud_1.ogg',
		'sound/effects/creatures/bear_loud_2.ogg',
		'sound/effects/creatures/bear_loud_3.ogg',
		'sound/effects/creatures/bear_loud_4.ogg'
	)

/datum/sound_effect/robot_talk
	key = SFX_ROBOT_TALK
	file_paths = list(
		'sound/effects/creatures/robot_talk_1.ogg',
		'sound/effects/creatures/robot_talk_2.ogg'
	)
