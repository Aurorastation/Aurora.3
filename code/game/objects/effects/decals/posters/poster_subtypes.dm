// Random Subtypes //
// Selects a design based on defined categories
// name and icon_state updated on mapload

/// Spawns a random poster. Use `random_type` for specification instead of usual methods
/obj/random/poster
	icon_state = "poster"
	/// This is what is primarily used to pick random posters.
	/// Set this to a `/obj/structure/sign/poster/...` to specify subtype
	var/random_type = /obj/structure/sign/poster

/obj/random/poster/spawn_item()
	var/obj/structure/sign/poster/P = pick(subtypesof(random_type))
	. = new P(loc)

/// Spawns a random rolled-up poster. Use `random_type` for specification instead of usual methods
/obj/random/poster_roll
	icon_state = "rolled_poster"
	/// This is what is primarily used to pick random posters.
	/// Set this to a `/obj/item/contraband/poster/...` to specify subtype
	var/random_type = /obj/item/contraband/poster

/obj/random/poster_roll/spawn_item()
	var/obj/item/contraband/poster/P = pick(subtypesof(random_type))
	. = new P(loc)


/obj/random/poster/civilian
	random_type = /obj/structure/sign/poster/civilian

/obj/random/poster_roll/civilian
	random_type = /obj/item/contraband/poster/civilian


/obj/random/poster/pinup
	random_type = /obj/structure/sign/poster/pinup

/obj/random/poster_roll/pinup
	random_type = /obj/item/contraband/poster/pinup


/obj/random/poster/command
	random_type = /obj/structure/sign/poster/command

/obj/random/poster_roll/command
	random_type = /obj/item/contraband/poster/command


/obj/random/poster/security
	random_type = /obj/structure/sign/poster/security

/obj/random/poster_roll/security
	random_type = /obj/item/contraband/poster/security


/obj/random/poster/medical
	random_type = /obj/item/contraband/poster/medical

/obj/random/poster_roll/medical
	random_type = /obj/item/contraband/poster/medical


/obj/random/poster/engineering
	random_type = /obj/structure/sign/poster/engineering

/obj/random/poster_roll/engineering
	random_type = /obj/item/contraband/poster/engineering

/// It is not recommended to use this as this may result in picking posters that do not match the setting
/obj/random/poster/lore
	random_type = /obj/structure/sign/poster/lore

/// It is not recommended to use this as this may result in picking posters that do not match the setting
/obj/random/poster_roll/lore
	random_type = /obj/item/contraband/poster/lore

// Poster Subtypes //

/obj/structure/sign/poster/civilian/bay_1
	icon_state = "bsposter1"
	poster_type = /singleton/poster_design/civilian/bay_1

/obj/item/contraband/poster/civilian/bay_1
	poster_type = /singleton/poster_design/civilian/bay_1


/obj/structure/sign/poster/pinup/bay_8
	icon_state = "bsposter8"
	poster_type = /singleton/poster_design/pinup/bay_8

/obj/item/contraband/poster/pinup/bay_8
	poster_type = /singleton/poster_design/pinup/bay_8


/obj/structure/sign/poster/pinup/bay_9
	icon_state = "bsposter9"
	poster_type = /singleton/poster_design/pinup/bay_8

/obj/item/contraband/poster/pinup/bay_9
	poster_type = /singleton/poster_design/pinup/bay_9


/obj/structure/sign/poster/civilian/bay_16
	icon_state = "bsposter16"
	poster_type = /singleton/poster_design/civilian/bay_16

/obj/item/contraband/poster/civilian/bay_16
	poster_type = /singleton/poster_design/civilian/bay_16


/obj/structure/sign/poster/pinup/bay_17
	icon_state = "bsposter17"
	poster_type = /singleton/poster_design/pinup/bay_17

/obj/item/contraband/poster/pinup/bay_17
	poster_type = /singleton/poster_design/pinup/bay_17


/obj/structure/sign/poster/civilian/bay_19
	icon_state = "bsposter19"
	poster_type = /singleton/poster_design/civilian/bay_19

/obj/item/contraband/poster/civilian/bay_19
	poster_type = /singleton/poster_design/civilian/bay_19


/obj/structure/sign/poster/civilian/bay_20
	icon_state = "bsposter20"
	poster_type = /singleton/poster_design/civilian/bay_20

/obj/item/contraband/poster/civilian/bay_20
	poster_type = /singleton/poster_design/civilian/bay_20


/obj/structure/sign/poster/security/bay_21
	icon_state = "bsposter21"
	poster_type = /singleton/poster_design/security/bay_21

/obj/item/contraband/poster/security/bay_21
	poster_type = /singleton/poster_design/security/bay_21


/obj/structure/sign/poster/science/bay_22
	icon_state = "bsposter22"
	poster_type = /singleton/poster_design/science/bay_22

/obj/item/contraband/poster/science/bay_22
	poster_type = /singleton/poster_design/science/bay_22


/obj/structure/sign/poster/engineering/bay_23
	icon_state = "bsposter23"
	poster_type = /singleton/poster_design/engineering/bay_23

/obj/item/contraband/poster/engineering/bay_23
	poster_type = /singleton/poster_design/engineering/bay_23


/obj/structure/sign/poster/medical/bay_24
	icon_state = "bsposter24"
	poster_type = /singleton/poster_design/medical/bay_24

/obj/item/contraband/poster/medical/bay_24
	poster_type = /singleton/poster_design/medical/bay_24


/obj/structure/sign/poster/medical/bay_25
	icon_state = "bsposter25"
	poster_type = /singleton/poster_design/medical/bay_25

/obj/item/contraband/poster/medical/bay_25
	poster_type = /singleton/poster_design/medical/bay_25


/obj/structure/sign/poster/civilian/bay_26
	icon_state = "bsposter26"
	poster_type = /singleton/poster_design/civilian/bay_26

/obj/item/contraband/poster/civilian/bay_26
	poster_type = /singleton/poster_design/civilian/bay_26


/obj/structure/sign/poster/civilian/bay_27
	icon_state = "bsposter27"
	poster_type = /singleton/poster_design/civilian/bay_27

/obj/item/contraband/poster/civilian/bay_27
	poster_type = /singleton/poster_design/civilian/bay_27


/obj/structure/sign/poster/civilian/bay_28
	icon_state = "bsposter28"
	poster_type = /singleton/poster_design/civilian/bay_28

/obj/item/contraband/poster/civilian/bay_28
	poster_type = /singleton/poster_design/civilian/bay_28


/obj/structure/sign/poster/civilian/bay_30
	icon_state = "bsposter30"
	poster_type = /singleton/poster_design/civilian/bay_30

/obj/item/contraband/poster/civilian/bay_30
	poster_type = /singleton/poster_design/civilian/bay_30


/obj/structure/sign/poster/civilian/bay_31
	icon_state = "bsposter31"
	poster_type = /singleton/poster_design/civilian/bay_31

/obj/item/contraband/poster/civilian/bay_31
	poster_type = /singleton/poster_design/civilian/bay_31


/obj/structure/sign/poster/civilian/bay_32
	icon_state = "bsposter32"
	poster_type = /singleton/poster_design/civilian/bay_32

/obj/item/contraband/poster/civilian/bay_32
	poster_type = /singleton/poster_design/civilian/bay_32


/obj/structure/sign/poster/engineering/bay_33
	icon_state = "bsposter33"
	poster_type = /singleton/poster_design/engineering/bay_33

/obj/item/contraband/poster/engineering/bay_33
	poster_type = /singleton/poster_design/engineering/bay_33


/obj/structure/sign/poster/engineering/bay_34
	icon_state = "bsposter34"
	poster_type = /singleton/poster_design/engineering/bay_34

/obj/item/contraband/poster/engineering/bay_34
	poster_type = /singleton/poster_design/engineering/bay_34


/obj/structure/sign/poster/civilian/bay_36
	icon_state = "bsposter36"
	poster_type = /singleton/poster_design/civilian/bay_36

/obj/item/contraband/poster/civilian/bay_36
	poster_type = /singleton/poster_design/civilian/bay_36


/obj/structure/sign/poster/civilian/bay_37
	icon_state = "bsposter37"
	poster_type = /singleton/poster_design/civilian/bay_37

/obj/item/contraband/poster/civilian/bay_37
	poster_type = /singleton/poster_design/civilian/bay_37


/obj/structure/sign/poster/civilian/bay_38
	icon_state = "bsposter38"
	poster_type = /singleton/poster_design/civilian/bay_38

/obj/item/contraband/poster/civilian/bay_38
	poster_type = /singleton/poster_design/civilian/bay_38


/obj/structure/sign/poster/medical/bay_39
	icon_state = "bsposter39"
	poster_type = /singleton/poster_design/medical/bay_39

/obj/item/contraband/poster/medical/bay_39
	poster_type = /singleton/poster_design/medical/bay_39


/obj/structure/sign/poster/command/bay_40
	icon_state = "bsposter40"
	poster_type = /singleton/poster_design/command/bay_40

/obj/item/contraband/poster/command/bay_40
	poster_type = /singleton/poster_design/command/bay_40


/obj/structure/sign/poster/command/bay_41
	icon_state = "bsposter41"
	poster_type = /singleton/poster_design/command/bay_41

/obj/item/contraband/poster/command/bay_41
	poster_type = /singleton/poster_design/command/bay_41


/obj/structure/sign/poster/pinup/bay_42
	icon_state = "bsposter42"
	poster_type = /singleton/poster_design/pinup/bay_42

/obj/item/contraband/poster/pinup/bay_42
	poster_type = /singleton/poster_design/pinup/bay_42


/obj/structure/sign/poster/medical/bay_43
	icon_state = "bsposter43"
	poster_type = /singleton/poster_design/medical/bay_43

/obj/item/contraband/poster/medical/bay_43
	poster_type = /singleton/poster_design/medical/bay_43


/obj/structure/sign/poster/civilian/bay_44
	icon_state = "bsposter44"
	poster_type = /singleton/poster_design/civilian/bay_44

/obj/item/contraband/poster/civilian/bay_44
	poster_type = /singleton/poster_design/civilian/bay_44


/obj/structure/sign/poster/engineering/bay_45
	icon_state = "bsposter45"
	poster_type = /singleton/poster_design/engineering/bay_45

/obj/item/contraband/poster/engineering/bay_45
	poster_type = /singleton/poster_design/engineering/bay_45


/obj/structure/sign/poster/pinup/bay_47
	icon_state = "bsposter47"
	poster_type = /singleton/poster_design/pinup/bay_47

/obj/item/contraband/poster/pinup/bay_47
	poster_type = /singleton/poster_design/pinup/bay_47


/obj/structure/sign/poster/pinup/bay_48
	icon_state = "bsposter48"
	poster_type = /singleton/poster_design/pinup/bay_48

/obj/item/contraband/poster/pinup/bay_48
	poster_type = /singleton/poster_design/pinup/bay_48

/obj/structure/sign/poster/engineering/bay_49
	icon_state = "bsposter49"
	poster_type = /singleton/poster_design/engineering/bay_49

/obj/item/contraband/poster/engineering/bay_49
	poster_type = /singleton/poster_design/engineering/bay_49


/obj/structure/sign/poster/civilian/bay_51
	icon_state = "bsposter51"
	poster_type = /singleton/poster_design/civilian/bay_51

/obj/item/contraband/poster/civilian/bay_51
	poster_type = /singleton/poster_design/civilian/bay_51


/obj/structure/sign/poster/engineering/bay_52
	icon_state = "bsposter52"
	poster_type = /singleton/poster_design/engineering/bay_52

/obj/item/contraband/poster/engineering/bay_52
	poster_type = /singleton/poster_design/engineering/bay_52


/obj/structure/sign/poster/engineering/bay_53
	icon_state = "bsposter53"
	poster_type = /singleton/poster_design/engineering/bay_53

/obj/item/contraband/poster/engineering/bay_53
	poster_type = /singleton/poster_design/engineering/bay_53


/obj/structure/sign/poster/engineering/bay_54
	icon_state = "bsposter54"
	poster_type = /singleton/poster_design/engineering/bay_54

/obj/item/contraband/poster/engineering/bay_54
	poster_type = /singleton/poster_design/engineering/bay_54


/obj/structure/sign/poster/civilian/bay_55
	icon_state = "bsposter55"
	poster_type = /singleton/poster_design/civilian/bay_55

/obj/item/contraband/poster/civilian/bay_55
	poster_type = /singleton/poster_design/civilian/bay_55


/obj/structure/sign/poster/civilian/bay_56
	icon_state = "bsposter56"
	poster_type = /singleton/poster_design/civilian/bay_56

/obj/item/contraband/poster/civilian/bay_56
	poster_type = /singleton/poster_design/civilian/bay_56


/obj/structure/sign/poster/civilian/bay_57
	icon_state = "bsposter57"
	poster_type = /singleton/poster_design/civilian/bay_57

/obj/item/contraband/poster/civilian/bay_57
	poster_type = /singleton/poster_design/civilian/bay_57


/obj/structure/sign/poster/civilian/bay_58
	icon_state = "bsposter58"
	poster_type = /singleton/poster_design/civilian/bay_58

/obj/item/contraband/poster/civilian/bay_58
	poster_type = /singleton/poster_design/civilian/bay_58


/obj/structure/sign/poster/civilian/bay_60
	icon_state = "bsposter60"
	poster_type = /singleton/poster_design/civilian/bay_60

/obj/item/contraband/poster/civilian/bay_60
	poster_type = /singleton/poster_design/civilian/bay_60


/obj/structure/sign/poster/science/bay_61
	icon_state = "bsposter61"
	poster_type = /singleton/poster_design/science/bay_61

/obj/item/contraband/poster/science/bay_61
	poster_type = /singleton/poster_design/science/bay_61


/obj/structure/sign/poster/science/bay_62
	icon_state = "bsposter62"
	poster_type = /singleton/poster_design/science/bay_62

/obj/item/contraband/poster/science/bay_62
	poster_type = /singleton/poster_design/science/bay_62


/obj/structure/sign/poster/medical/bay_63
	icon_state = "bsposter63"
	poster_type = /singleton/poster_design/medical/bay_63

/obj/item/contraband/poster/medical/bay_63
	poster_type = /singleton/poster_design/medical/bay_63


/obj/structure/sign/poster/civilian/bay_64
	icon_state = "bsposter64"
	poster_type = /singleton/poster_design/civilian/bay_64

/obj/item/contraband/poster/civilian/bay_64
	poster_type = /singleton/poster_design/civilian/bay_64


/obj/structure/sign/poster/engineering/bay_65
	icon_state = "bsposter65"
	poster_type = /singleton/poster_design/engineering/bay_65

/obj/item/contraband/poster/engineering/bay_65
	poster_type = /singleton/poster_design/engineering/bay_65


/obj/structure/sign/poster/lore/tcaf
	icon_state = "tcflposter"
	poster_type = /singleton/poster_design/lore/tcaf

/obj/item/contraband/poster/lore/tcaf
	poster_type = /singleton/poster_design/lore/tcaf


/obj/structure/sign/poster/lore/tcaf2
	icon_state = "tcflposter2"
	poster_type = /singleton/poster_design/lore/tcaf2

/obj/item/contraband/poster/lore/tcaf2
	poster_type = /singleton/poster_design/lore/tcaf2


/obj/structure/sign/poster/security/tg_5
	icon_state = "poster5"
	poster_type = /singleton/poster_design/security/tg_5

/obj/item/contraband/poster/security/tg_5
	poster_type = /singleton/poster_design/security/tg_5


/obj/structure/sign/poster/civilian/tg_7
	icon_state = "poster7"
	poster_type = /singleton/poster_design/civilian/tg_7

/obj/item/contraband/poster/civilian/tg_7
	poster_type = /singleton/poster_design/civilian/tg_7


/obj/structure/sign/poster/engineering/tg_10
	icon_state = "poster10"
	poster_type = /singleton/poster_design/engineering/tg_10

/obj/item/contraband/poster/engineering/tg_10
	poster_type = /singleton/poster_design/engineering/tg_10


