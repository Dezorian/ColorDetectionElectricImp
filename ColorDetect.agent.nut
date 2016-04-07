// Log the URLs we need
server.log("Turn LED On: " + http.agenturl() + "?led=1");
server.log("Turn LED Off: " + http.agenturl() + "?led=0");
 
function requestHandler(request, response) {
  try {
    local ledState = 0;
    // check if the user sent led as a query parameter
    if ("led" in request.query) {
      
      // if they did, and led=1.. set our variable to 1
      if (request.query.led == "1" || request.query.led == "0") {
        // convert the led query parameter to an integer
        ledState = request.query.led.tointeger();
 
        // send "led" message to device, and send ledState as the data
        device.send("led", ledState); 
      }
    }
    
    // send a response back saying everything was OK.
    if (ledState == 1) response.send(200, "I live!");
    else if (ledState == 0) response.send(200, "I'm afraid I can't do that, or can I?");
  } catch (ex) {
    response.send(500, "Darnit, a server error occured: " + ex);
  }
}
 
// register the HTTP handler
http.onrequest(requestHandler);