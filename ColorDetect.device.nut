// create a global variabled called led, 
// and assign pin9 to it
_button <- hardware.pin1;
_colorSensorLed <- hardware.pin2;
_vRed <- hardware.pin9;
_vGreen <- hardware.pin8;
_vBlue <- hardware.pin7;
_ledState <- 1;
 
// configure pins
_colorSensorLed.configure(DIGITAL_OUT);
_vRed.configure(ANALOG_IN);
_vGreen.configure(ANALOG_IN);
_vBlue.configure(ANALOG_IN);

function doWork()
{
  local state = _button.read();
  if (state == 0) {
    server.log("===============Starting Color Detection===============")
    _colorSensorLed.write(1);
    imp.sleep(1);
    readColor();
    _colorSensorLed.write(0);
  }
}

function readColor()
{
  local voltage = hardware.voltage();
  local vRed =   ( (_vRed.read()  / 65536.0) * voltage );
  
  voltage = hardware.voltage();
  local vGreen = ( (_vGreen.read()/ 65536.0) * voltage );
  
  voltage = hardware.voltage();
  local vBlue =  ( (_vBlue.read() / 65536.0) * voltage );
  
  //vColor * relative responsivity * voltage/irradiance
  //See page 7 & 8 of https://dlnmh9ip6v2uc.cloudfront.net/datasheets/Sensors/LightImaging/HDJD-S822-QR999.pdf
  //Blue had to be boosted a lot to get accurate results (200% instead of 140 and 25 instead of 29)
  //Other Colors are following the charts in the datasheet
  local redValue =   (( vRed    * 100)  / 16);
  local greenValue = (( vGreen  * 130 ) / 22);
  local blueValue =  (( vBlue   * 200 ) / 25); 
  
  if (redValue > greenValue && redValue > blueValue)
  {
    if (greenValue > 2.6) server.log("Object is Orange.");
    else server.log("Object is Red.");
  }
  else if (greenValue > blueValue && greenValue > redValue)
  {
    if (redValue > 2) server.log("Object is Yellow.");
    else server.log("Object is Green.");
  }
  else 
  {
    if (redValue > 2) server.log("Object is Purple.");
    else server.log("Object is Blue.");
  }
  
  server.log("Red  : " + vRed + "v. Value: " + redValue);
  server.log("Green: " + vGreen + "v. Value: " + greenValue);
  server.log("Blue : " + vBlue + "v. Value: "+ blueValue);
}

_button.configure(DIGITAL_IN_PULLUP, doWork);