#require "Rocky.agent.lib.nut:3.0.0"

local LATEST = {
    tempHumid = {},
    pressure = {}
};

local HISTORY = server.load();

device.on("tempHumid", function(table) {
    LATEST.tempHumid <- table;
    local h = [ time(), table.temperature, table.humidity ];

    // Once every 2 minutes => 48 hours.
    while (HISTORY.h.len() >= 1440) {
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
    // TODO: if we want to display the index, we need to redirect, otherwise relative URLs are broken.
    context.send(200, LATEST);
});

app.get("/index.html", function(context) {
    context.send(200, "@{include('html/index.html') | escape}");
});

app.get("/js/index.js", function(context) {
    context.send(200, "@{include('js/index.js') | escape}");
});

app.post("/clear", function(context) {
    server.save({h = []});
    HISTORY = server.load();
    context.send(200, "OK");
});

app.get("/metrics", function(context) {
    // Unix epoch, seconds.
    local t = time();
    // Multiplying by 1000 overflows, so just jam some zeroes on the end in the string format.
    context.send(200, format("temperature %f %d000\nhumidity %f %d000\npressure %f %d000\n",
        LATEST.tempHumid.temperature, t,
        LATEST.tempHumid.humidity, t,
        LATEST.pressure.pressure, t));
});
