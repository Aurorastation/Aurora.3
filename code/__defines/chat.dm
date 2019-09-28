#define DIRECT_OUTPUT(A, B) A << B

//#define to_chat(target, message)                            target << message
//#define to_world(message)                                   world << message
#define to_world(message)                                   to_chat(world, message)
#define sound_to(target, sound)                             DIRECT_OUTPUT(target, sound)
#define to_file(file_entry, file_content)                   file_entry << file_content
#define show_browser(target, browser_content, browser_name) target << browse(browser_content, browser_name)
#define send_rsc(target, rsc_content, rsc_name)             target << browse_rsc(rsc_content, rsc_name)
#define send_rsc_auto(target, rsc_content)             target << browse_rsc(rsc_content)
#define send_output(target, msg, control)                   target << output(msg, control)
#define send_link(target, url)                              target << link(url)

#define hicon(icon) icon2base64html(icon)