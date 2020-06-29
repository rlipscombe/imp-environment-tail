#require "APDS9007.class.nut:1.0.0"
#require "LPS25H.class.nut:2.0.0"
#require "Si702x.class.nut:1.0.0"

// Light Sensor
local lightOutputPin = hardware.pin5;
lightOutputPin.configure(ANALOG_IN);

local lightEnablePin = hardware.pin7;
lightEnablePin.configure(DIGITAL_OUT, 1);

local lightSensor = APDS9007(lightOutputPin, 47000, lightEnablePin);

function onLightSensorRead() {
    local value = lightSensor.read();
    server.log("Light Sensor: " + value + " lux");
    imp.wakeup(10.0, onLightSensorRead);
}

// reading the light sensor is kinda expensive: it can take 4-5 seconds.
//onLightSensorRead();

// Pressure Sensor
hardware.i2c89.configure(CLOCK_SPEED_400_KHZ);
local pressureSensor = LPS25H(hardware.i2c89);

function onPressureRead(table) {
    foreach (k, v in table) {
        server.log(k + ": " + v);
    }
    
    agent.send("pressure", table);
    
    imp.wakeup(10.0, function() {
        pressureSensor.read(onPressureRead);
    });
}

pressureSensor.enable(true);
pressureSensor.read(onPressureRead);

// Temperature/Humidity Sensor
local tempHumidSensor = Si702x(hardware.i2c89);

function onTempHumidRead(table) {
    foreach (k, v in table) {
        server.log(k + ": " + v);
    }

    agent.send("tempHumid", table);
    
    imp.wakeup(10.0, function() {
        tempHumidSensor.read(onTempHumidRead);
    });
}

tempHumidSensor.read(onTempHumidRead);

LED <- 0;

function flashLed() {
    hardware.pin2.write(LED);
    LED = 1 - LED;
    
    imp.wakeup(0.5, flashLed)
}

hardware.pin2.configure(DIGITAL_OUT);
hardware.pin2.write(0);     // initially off
//flashLed();
