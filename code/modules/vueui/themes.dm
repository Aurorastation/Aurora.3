/*
 * Global helper for managing UI themes
 */
#define THEME_TYPE_DARK 1
#define THEME_TYPE_LIGHT 0

/var/available_html_themes = list(
    "Nano" = list(
        "name" = "Nano Dark",
        "class" = "theme-nano",
        "type" = THEME_TYPE_DARK
    ),
    "Nano Light" = list(
        "name" = "Nano Light",
        "class" = "theme-nano-light",
        "type" = THEME_TYPE_LIGHT
    )
)

/proc/get_html_theme_class(var/mob/user)
    if(user.client)
        var/style = user.client.prefs.html_UI_style
        if(!(style in available_html_themes))
            style = "Nano"
        var/list/theme = available_html_themes[style]
        var/class = ""
        if(theme["type"] == THEME_TYPE_DARK)
            class += "dark-theme"
        class += " [theme["class"]]"
        return class
    return ""

/proc/send_theme_resources(var/mob/user)
    if(user.client)
        var/datum/asset/assets = get_asset_datum(/datum/asset/simple/vueui_theming)
        assets.send(user.client)