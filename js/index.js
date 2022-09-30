function render(h) {
    opts = {
        xaxis: { mode: "time", timeBase: "milliseconds", timeformat: "%H:%M:%S" },
        yaxis: { position: "right" },
    }

    var data = [
        { label: "Temperature", color: "orange", lines: { show: true, fill: false }, points: { show: true }, data: h.map(r => [r[0] * 1000, r[1]]) },
    ];
    $.plot("#temperature", data, opts);

    var data = [
        { label: "Humidity", color: "cyan", lines: { show: true, fill: false }, points: { show: true }, data: h.map(r => [r[0] * 1000, r[2]]) },
    ];
    $.plot("#humidity", data, opts);
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
