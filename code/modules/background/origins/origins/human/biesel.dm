#define RELIGIONS_BIESEL list(RELIGION_NONE, RELIGION_CHRISTIANITY, RELIGION_ISLAM, RELIGION_BUDDHISM, RELIGION_HINDU, RELIGION_TAOISM, RELIGION_JUDAISM, RELIGION_OTHER, RELIGION_TRINARY)
#define CITIZENSHIPS_BIESEL list(CITIZENSHIP_BIESEL, CITIZENSHIP_ERIDANI, CITIZENSHIP_COALITION)


/decl/origin_item/culture/biesel
    name = "Biesellite"
    desc = "How about you pick a better planet?"
    possible_origins = list(
        /decl/origin_item/origin/mendell_city
    )


/decl/origin_item/origin/mendell_city
    name = "Mendell City"
    desc = "You didn't even change the default origin, you uncreative loony."
    possible_accents = list(ACCENT_CETI, ACCENT_GIBSON)
    possible_citizenships = list(CITIZENSHIP_BIESEL)
    possible_religions = RELIGIONS_BIESEL
