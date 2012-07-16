backend nginx {
    .host = "127.0.0.1";
    .port = "8080";
}
backend codesearch {
    .host = "127.0.0.1";
    .port = "8910";
}
sub vcl_pipe {
    if (req.http.upgrade) {
        set bereq.http.upgrade = req.http.upgrade;
    }
}
sub vcl_recv {
    if (req.http.Upgrade ~ "(?i)websocket") {
        set req.backend = codesearch;
        return (pipe);
    } else {
        set req.backend = codesearch;
    }
}
