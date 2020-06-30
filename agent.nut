#require "Rocky.agent.lib.nut:3.0.0"

local LATEST = {
    tempHumid = {},
    pressure = {}
};

device.on("tempHumid", function(table) {
    LATEST.tempHumid <- table;
});

device.on("pressure", function(table) {
    LATEST.pressure <- table;
});

local settings = { "strictRouting": true, "sigCaseSensitive": true };
app <- Rocky.init(settings);
app.get("/latest.json", function(context) {
    context.send(200, LATEST);
});

app.get("/", function(context) {
    context.send(200, LATEST);
});

app.get("/index.html", function(context) {
    context.send(200, "@{include('html/index.html') | escape}");
});

app.get("/js/index.js", function(context) {
    context.send(200, "@{include('js/index.js') | escape}");
});
