var path = require('path');

var linux = '/home/nelhage/linux/';

module.exports.SEARCH_REPO = linux;
module.exports.SEARCH_ARGS = ["--load_index", path.join(linux, "codesearch.idx"),
                              '--threads=4'];
module.exports.SEARCH_REF  = "refs/tags/v3.4";
module.exports.BACKEND_CONNECTIONS = 8;
module.exports.LOG4JS_CONFIG = path.join(__dirname, "log4js.codesearch.json");
module.exports.SLOW_THRESHOLD = 200;
module.exports.SMTP_CONFIG = {
  host: 'smtp.gmail.com',
  user: 'mailer@livegrep.com',
  ssl:   true,
  password: '1fMq4aheht6U'
};
