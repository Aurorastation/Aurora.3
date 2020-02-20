// rust_g.dm - DM API for rust_g extension library
#define RUST_G "rust_g"
#define WRITE_LOG(log, text) call(RUST_G, "log_write")(log, text) // Using Rust g dll to log faster with less CPU usage.

#define RUSTG_JOB_NO_RESULTS_YET "NO RESULTS YET"
#define RUSTG_JOB_NO_SUCH_JOB "NO SUCH JOB"
#define RUSTG_JOB_ERROR "JOB PANICKED"

#define rustg_udp_shipper_send(addr, text) call(RUST_G, "udp_shipper_send")(addr, text)

#define RUSTG_HTTP_METHOD_GET "get"
#define RUSTG_HTTP_METHOD_POST "post"
#define RUSTG_HTTP_METHOD_PUT "put"
#define RUSTG_HTTP_METHOD_DELETE "delete"
#define RUSTG_HTTP_METHOD_PATCH "patch"
#define RUSTG_HTTP_METHOD_HEAD "head"

#define rustg_http_request_blocking(method, url, body, headers) call(RUST_G, "http_request_blocking")(method, url, body, headers)
#define rustg_http_request_async(method, url, body, headers) call(RUST_G, "http_request_async")(method, url, body, headers)
#define rustg_http_check_request(req_id) call(RUST_G, "http_check_request")(req_id)
