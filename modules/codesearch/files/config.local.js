var path = require('path'),
    fs   = require('fs');

var linux = '/home/nelhage/linux/';

module.exports.BACKENDS = {
 linux: {
    host: "localhost",
    port: 0xC5EA,
    connections: 8,
    index: path.join(__dirname, "../../linux/codesearch.idx"),
    name: "linux",
    pretty_name: "Linux v3.7",
    repos: [
      {
        path: path.join(__dirname, "../../linux"),
        name: "",
        refs: ["v3.7"],
        github: "torvalds/linux",
      }
    ],
    sort: 'include kernel mm fs arch'.split(/\s+/),
 },
 aosp: {
    host: "localhost",
    port: 0xC5EB,
    connections: 8,
    index: path.join(__dirname, "../../aosp/aosp.idx"),
    name: "aosp",
    pretty_name: "AOSP v4.2.1",
     repos: JSON.parse(fs.readFileSync(path.join(__dirname, "aosp.json"))),
    sort: [],
    search_args: [ '--timeout=3000' ]
  }
}

module.exports.LOG4JS_CONFIG = path.join(__dirname, "log4js.codesearch.json");
module.exports.SLOW_THRESHOLD = 200;
try {
    var pass = fs.readFileSync(path.join(__dirname, "smtp-password"), 'utf8').trim();
    module.exports.SMTP_CONFIG = {
        host: 'smtp.gmail.com',
        user: 'mailer@livegrep.com',
        ssl:   true,
        password: pass,
    };
} catch (e) {
    console.warn("Unable to read SMTP password: %j", e);
}
