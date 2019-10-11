const path = require('path');
const cwd = process.cwd();

module.exports = {
    data: "@import 'variables'",
    includePaths: [
        path.resolve(cwd, 'styles')
    ]
};
