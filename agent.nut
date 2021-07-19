#require "Rocky.agent.lib.nut:3.0.0"

local LATEST = {
    tempHumid = {},
    pressure = {}
};

local HISTORY = server.load();

device.on("tempHumid", function(table) {
    LATEST.tempHumid <- table;
    local h = { ts = time(), temp = table.temperature, humid = table.humidity };

    // Once a minute => 48 hours.
    while (HISTORY.h.len() >= 2880) {
        HISTORY.h.remove(0);
    }

    HISTORY.h.push(h);

    server.save(HISTORY, 2);
});

device.on("pressure", function(table) {
    LATEST.pressure <- table;
});

local settings = { "strictRouting": true, "sigCaseSensitive": true };
app <- Rocky.init(settings);
app.get("/latest.json", function(context) {
    context.send(200, LATEST);
});

app.get("/history.json", function(context) {
    context.send(200, HISTORY);
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
