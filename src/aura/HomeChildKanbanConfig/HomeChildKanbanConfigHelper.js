
/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

({
    spinnerHelper : function(component, tf){
        var spinner = component.find('spinner');
        if(tf){
            $A.util.removeClass(spinner,'slds-hide');
        }else{
            $A.util.addClass(spinner,'slds-hide');
        }
    },
    validateForm : function(component, helper){
        var ObjectName = component.get('v.ObjectName');
        var cardFields = component.get('v.cardFields');
        var grpFldName = component.get('v.grpFldName');
        var sumFldName = component.get('v.sumFldName');
        var pickExclVals = component.get('v.pickExclVals');
        var configName = component.get('v.configName');
        var childObjectName = component.get('v.childObjectName');
        console.clear();
        var isFormValid = true;
        if(helper.iUorN(ObjectName)){
            helper.errorHelper(component, 'ObjectName', 'Please Select An Object', true);
            isFormValid = false;
        }else{
            helper.errorHelper(component, 'ObjectName', null, false);
        }
        if(helper.iUorN(cardFields)){
            helper.errorHelper(component, 'cardFields', 'Please select atleast one field to show on the kanban tile', true);
        	isFormValid = false;
        }else{
            helper.errorHelper(component, 'cardFields', null, false);
        }
        if(helper.iUorN(grpFldName)){
            helper.errorHelper(component, 'grpFldName', 'Please Select A Field To Group By', true);
            isFormValid = false;
        }else{
            helper.errorHelper(component, 'grpFldName', null, false);
        }
        if(helper.iUorN(childObjectName) && component.get('v.kanbanFor') == 'Child'){
            helper.errorHelper(component, 'childObjectName', 'Please Select A Field To Group By', true);
            isFormValid = false;
        }else{
            helper.errorHelper(component, 'childObjectName', null, false);
        }
        if(helper.iUorN(configName)){
          	component.find('configName').showHelpMessageIfInvalid();
            isFormValid = false;
        }else{
            //something
        }
        console.log('5 '+ isFormValid);
        //alert(isFormValid);
        if(isFormValid){
            var kf = component.get('v.kanbanFor');
            var sObj = {};
            var recId = component.get('v.recordId');
            if(recId){
                sObj.Id = recId;
            }
            sObj.sobjectType = 'kanbanDev__Kanban_Configuration__c';
            sObj.Name = configName;
            sObj.kanbanDev__For_Object__c = ObjectName;
            if(kf != 'Home'){
                sObj.kanbanDev__Child_Object__c = childObjectName.split('~;')[0];
                sObj.kanbanDev__Relation_Field__c = childObjectName.split('~;')[1];
            }else{
                sObj.kanbanDev__Child_Object__c = ObjectName;
            }
            sObj.kanbanDev__Kanban_For__c = kf;
            sObj.kanbanDev__Summarize_By__c = sumFldName;
            sObj.kanbanDev__Group_By__c = grpFldName;
            sObj.kanbanDev__Fields_To_Show__c = cardFields;
            sObj.kanbanDev__Exclude_From_Group_By__c = pickExclVals;
            var action = component.get('c.saveConfig');
            action.setParams({
                'obj': sObj
            });
            var toastEvent = $A.get("e.force:showToast");
            action.setCallback(this, function(res){
                var state = res.getState();                
                if(state === 'SUCCESS'){
                    var rVal = res.getReturnValue();
                    if(rVal == 'true'){
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "The confuguration has been saved successfully.",
                            "type" : "success"
                        });
                        var homeEvent = $A.get("e.force:navigateToObjectHome");
                            homeEvent.setParams({
                                "scope": "kanbanDev__Kanban_Configuration__c"
                            });
                        homeEvent.fire();
                    }else{
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "There was an error while saving the confuguration.",
                            "type" : "error"
                        });
                    }
                    toastEvent.fire();
                }else{
                    toastEvent.setParams({
                            "title": "Error!",
                            "message": "There was an error while saving the confuguration.",
                            "type" : "error"
                        });
                    //console.log(res.getError());
                    console.log(state);
                }
            });
            $A.enqueueAction(action);
        }
    },
    iUorN : function(par){
        if($A.util.isUndefinedOrNull(par)){
            return true;
        }else{
            return false;
        }
    },
    errorHelper : function(component, elem, message, tf){
        var el = component.find(elem);
        if(tf){
            el.showError(message);
        }else{
            el.hideError();
        }
    },
    getFields : function(component, event, helper, val){
        var action = component.get('c.getObjFlds');
        action.setParams({
            'objName' : val
        });
        action.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                var rVal = res.getReturnValue();
                console.log(rVal);
                component.set('v.allFieldsList', rVal);
                //component.find('fldsToShow').externalValueChange('Amount');
            }else{
                console.log(res);
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    }
})