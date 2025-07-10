/*
#####################
		Spans
#####################
*/

#define span(class, str) ("<span class='[class]'>" + str + "</span>")
#define SPAN_NOTICE(str) ("<span class='notice'>" + str + "</span>")
#define SPAN_WARNING(str) ("<span class='warning'>" + str + "</span>")
#define SPAN_DANGER(str) ("<span class='danger'>" + str + "</span>")
#define SPAN_CULT(str) ("<span class='cult'>" + str + "</span>")
#define SPAN_GOOD(str) ("<span class='good'>" + str + "</span>")
#define SPAN_BAD(str) ("<span class='bad'>" + str + "</span>")
#define SPAN_ALIEN(X) ("<span class='alium'>" + X + "</span>")
#define SPAN_ALERT(str) ("<span class='alert'>" + str + "</span>")
#define SPAN_INFO(str) ("<span class='info'>" + str + "</span>")
#define SPAN_ITALIC(str) ("<span class='italic'>" + str + "</span>")
#define SPAN_BOLD(str) ("<span class='bold'>" + str + "</span>")
#define SPAN_SUBTLE(str) ("<span class='subtle'>" + str + "</span>")
#define SPAN_SOGHUN(str) ("<span class='soghun'>" + str + "</span>")
#define SPAN_VOTE(str) ("<span class='vote'>" + str + "</span>")
#define SPAN_HEAR(str) ("<span class='hear'>" + str + "</span>")
#define SPAN_STYLE(style, str) "<span style=\"[style]\">[str]</span>"
#define SPAN_COLOR(color, str) SPAN_STYLE("color: [color]", "[str]")
#define SPAN_CAUTION(str) ("<span class='caution'>" + str + "</span>")
#define SPAN_STORYTELLER(str) ("<span class='storyteller'>" + str + "</span>")

#define SPAN_RED(str) "<span style='color:[COLOR_RED]'>[str]</span>"
#define SPAN_YELLOW(str) "<span style='color:[COLOR_YELLOW]'>[str]</span>"
#define SPAN_GREEN(str) "<span style='color:[COLOR_GREEN]'>[str]</span>"

#define SPAN_SIZE(size, text) ("<span style=\"font-size: [size]\">" + text + "</span>")

#define SPAN_HIGHDANGER(str) (FONT_LARGE(SPAN_DANGER(str)))

#define SPAN_LANGCHAT(X) "<span class='langchat'>[X]</span>"

/*
#####################
	Font sizes
#####################
*/

#define FONT_SIZE_SMALL "10px"
#define FONT_SIZE_NORMAL "13px"
#define FONT_SIZE_LARGE "16px"
#define FONT_SIZE_HUGE "18px"
#define FONT_SIZE_GIANT "24px"

#define FONT_SMALL(str) SPAN_SIZE(FONT_SIZE_SMALL, str)
#define FONT_NORMAL(str) SPAN_SIZE(FONT_SIZE_NORMAL, str)
#define FONT_LARGE(str) SPAN_SIZE(FONT_SIZE_LARGE, str)
#define FONT_HUGE(str) SPAN_SIZE(FONT_SIZE_HUGE, str)
#define FONT_GIANT(str) SPAN_SIZE(FONT_SIZE_GIANT, str)
