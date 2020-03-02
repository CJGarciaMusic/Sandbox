function exec(cmd, handler = function(error, stdout, stderr){console.log(stdout);if(error !== null){console.log(stderr)}})
{
    const childfork = require('child_process');
    return childfork.exec(cmd, handler);
}