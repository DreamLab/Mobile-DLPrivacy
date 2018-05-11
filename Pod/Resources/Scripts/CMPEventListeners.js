// Events from JS Consent Management Platform

// Handler for function timer
var cmpInterval;

// Function adding event listeners to CMP
function addCMPListeners() {

    // If we have CMP object -> add handlers
    if (window.__cmp != undefined) {

        // Add listeners
        try {

            window.__cmp('addEventListener', 'isLoaded', function(result) {
                webkit.messageHandlers.cmpEvents.postMessage({"event": "isLoaded"});
            });

            window.__cmp('addEventListener', 'cmpReady', function(result) {
                webkit.messageHandlers.cmpEvents.postMessage({"event": "cmpReady"});
            });

            window.__cmp('addEventListener', 'onSubmit', function(result) {
                webkit.messageHandlers.cmpEvents.postMessage({"event": "onSubmit"});
            });

            // Stop our function timer after adding event listeners
            clearInterval(cmpInterval);

        } catch (error) {
            webkit.messageHandlers.cmpEvents.postMessage({"event": error});
        }
    }
}

// Start our function timer when window loads
window.onload = function() {
    cmpInterval = setInterval(addCMPListeners, 100);
};
