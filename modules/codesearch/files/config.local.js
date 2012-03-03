var path = require('path');

var linux = '/home/nelhage/linux/';

module.exports.SEARCH_REPO = linux;
module.exports.SEARCH_ARGS = ["--load_index", path.join(linux, "codesearch.idx"),
                              '--threads=16'];
module.exports.SEARCH_REF  = "v3.0";
module.exports.BACKEND_CONNECTIONS = 8;
module.exports.LOG4JS_CONFIG = path.join(__dirname, "log4js.codesearch.json");
