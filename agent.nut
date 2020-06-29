local STATUS = {
    tempHumid = {},
    pressure = {}
};

device.on("tempHumid", function(table) {
    STATUS.tempHumid <- table;
});

device.on("pressure", function(table) {
    STATUS.pressure <- table;
});

http.onrequest(function(req, res) {
    res.send(200, http.jsonencode(STATUS));
});
