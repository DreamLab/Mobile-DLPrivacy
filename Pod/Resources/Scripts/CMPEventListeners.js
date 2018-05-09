// Events from JS Consent Management Platform

try {

    window.__cmp('addEventListener', 'isLoaded', function(result) {
        webkit.messageHandlers.cmpEvents.postMessage(result);
    });

    window.__cmp('addEventListener', 'cmpReady', function(result) {
        webkit.messageHandlers.cmpEvents.postMessage(result);
    });

    window.__cmp('addEventListener', 'onSubmit', function(result) {
        webkit.messageHandlers.cmpEvents.postMessage(result);
    });

} catch (error) {
    webkit.messageHandlers.cmpEvents.postMessage({"event": "cmpError"});
}
