/*
Strike by Appiphony
Version: 1.0.0
Website: http://www.lightningstrike.io
GitHub: https://github.com/appiphony/Strike-Components
License: BSD 3-Clause License
*/
({
    onInit: function(component, event, helper) {
        component.set('v.hidden', $A.util.isEmpty(component.get('v.label')));
    },
    filterBy: function(component, event, helper) {
        component.set('v.hidden', true);
        helper.filterBy(component, event, helper, component);
        component.set('v.hidden', $A.util.isEmpty(component.get('v.label')) || component.get('v.hidden'));
    }
})