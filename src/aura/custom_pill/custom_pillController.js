/*Strike by Appiphony
Version: 0.9.0
Website: http://www.lightningstrike.io
GitHub: https://github.com/appiphony/Strike-Components
License: BSD 3-Clause License*/
({
    destroyPill: function (component, event, helper) {
    	// Check to see if this component is in Strike Fiddler so we stop user from removing it
    	if (component.get('v.destroyable')) {
            helper.notifyParent(component);
            helper.destroyComponent(component);
        }
    }
})