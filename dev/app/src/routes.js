"use strict";

var appRouter = function (app) {
    app.get("/", function (req, res) {
        
        var os = require("os");
        res.send({"text" : "Hello World from " + os.hostname() });
    });
};
 
module.exports = appRouter;