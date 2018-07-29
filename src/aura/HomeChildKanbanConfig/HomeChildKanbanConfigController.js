
/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

({
    doInit : function(component, event, helper) {
        
        var action = component.get('c.getObjs');
        action.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                var rVal = res.getReturnValue();
                component.set('v.objectList', rVal);
            }else{
                console.log(res);
                console.log(state);
            }
        });
        $A.enqueueAction(action);
        
    },
    objChanged : function(component, event, helper) {
        var action = component.get('c.getObjChilds');
        var val = component.get('v.kanbanFor');
        if(val == 'Home'){
            helper.getFields(component, event, helper, component.get('v.ObjectName'));
        }
        action.setParams({
            'objName' : component.get('v.ObjectName')
        });
        action.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                var rVal = res.getReturnValue();
                console.log(rVal);
                component.set('v.childObjectList', rVal);
                component.set('v.childObjectName', null);
                component.set('v.grpFldName', null);
                component.set('v.sumFldName', null);
                component.find('cardFields').externalValueChange('');
                component.find('pickExclVals').externalValueChange('');
            }else{
                console.log(res);
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    },
    childObjChanged : function(component, event, helper) {
        if(!$A.util.isUndefinedOrNull(event.getParams().value)){
        	helper.getFields(component, event, helper, event.getParams().value.split('~;')[0]);    
        }
    },
    grpFldChanged : function(component, event, helper) {
        if(!$A.util.isUndefinedOrNull(event.getParams().value)){
            var action = component.get('c.getPickVals');
            var val = component.get('v.kanbanFor');
            var aval;
            if(val == 'Child'){
                aval = component.get('v.childObjectName').split('~;')[0];
            }else if(val == 'Home'){
                aval = component.get('v.ObjectName')
            }
            action.setParams({
                'FldName' : event.getParams().value,
                'objName' : aval
            });
            action.setCallback(this, function(res){
                var state = res.getState();
                if(state === 'SUCCESS'){
                    var rVal = res.getReturnValue();
                    console.log(rVal);
                    component.set('v.allPickValList', rVal);
                }else{
                    console.log(res);
                    console.log(state);
                }
            });
            $A.enqueueAction(action);
        }
    },
    showSpinner : function (component, event, helper) {
        helper.spinnerHelper(component, true);   
    },
    hideSpinner : function (component, event, helper) {
        helper.spinnerHelper(component, false); 
    },
    saveConfigur : function(component, event, helper) {
        helper.validateForm(component, helper); 
    },
    CheckChild : function(component, event, helper) {
        var val = event.getSource().get('v.value');  
        var divele = component.find('forChild').getElement();
        if(val == 'Home'){
            $A.util.addClass(divele, 'slds-hide');            
        }else if(val == 'Child'){
            $A.util.removeClass(divele, 'slds-hide');
        }
    }
})