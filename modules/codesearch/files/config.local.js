var path = require('path');

var linux = '/home/nelhage/linux/';

module.exports.SEARCH_REPO = linux;
module.exports.SEARCH_ARGS = ["--load_index", path.join(linux, "codesearch.idx")];
module.exports.SEARCH_REF  = "v3.0";
module.exports.BACKEND_CONNECTIONS = 12;
