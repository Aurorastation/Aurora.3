	spellbook_type = /datum/spellbook/student

	if(user.is_wizard(TRUE))
		user <<"<span class='warning'>This books is written for students, not for a true wizard like yourself!</span>"
		return
		
	..()

/datum/spellbook/student
	name = "\improper student's spellbook"
	feedback = "ST"
	desc = "This spell book has a sticker on it that says, 'certified for children 5 and older'."
	book_desc = "This spellbook is dedicated to teaching neophytes in the ways of magic."
	title = "Book of Spells and Education"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = 0
	max_uses = 3

	spells = list(/spell/aoe_turf/knock = 						1,
				/spell/targeted/ethereal_jaunt = 			1,
				/spell/targeted/projectile/magic_missile = 		1,
					)
