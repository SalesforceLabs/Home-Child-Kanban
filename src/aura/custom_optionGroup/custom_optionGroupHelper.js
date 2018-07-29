/*
Strike by Appiphony
Version: 1.0.0
Website: http://www.lightningstrike.io
GitHub: https://github.com/appiphony/Strike-Components
License: BSD 3-Clause License
*/
({
	filterBy : function(component, event, helper, currentComponent) {
        var body = currentComponent.get('v.body');
        var searchTerm = event.getParam('arguments');

        body.forEach(function(child) {
            if (child.strike_filterBy) {
                child.strike_filterBy(searchTerm[0]);
                component.set('v.hidden', component.get('v.hidden') && child.get('v.hidden'));
            } else {
                helper.filterBy(component, event, helper, child);
            }
        });
	}
})