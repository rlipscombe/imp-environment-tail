function render(h) {
    opts = {
        xaxis: { mode: "time", timeBase: "milliseconds", timeformat: "%H:%M:%S" },
        yaxis: {},
        y2axis: { position: "right" },
    }

    var data = [
        { label: "Temperature", lines: { show: true, fill: false }, points: { show: false }, data: [] },
        { label: "Humidity", yaxis: 2, lines: { show: true, fill: false }, points: { show: false }, data: [] }
    ];
    h.forEach(x => {
        data[0].data.push([x.ts * 1000, x.temp]);
        data[1].data.push([x.ts * 1000, x.humid]);
    });

    $.plot("#placeholder", data, opts);
}

function update() {
    console.log("update");
    $.getJSON("history.json").done(function(data) {
        render(data.h);
    }).fail(function(xhr, status, error) {
        console.log(status + ", " + error);
    });
}

function ready() {
    update();
    setInterval(update, 30000);
}

$(document).ready(ready);