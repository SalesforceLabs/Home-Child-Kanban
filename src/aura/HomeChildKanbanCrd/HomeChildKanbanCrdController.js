
/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

({
    doInit : function(component, event, helper) {
        var lst = [];
        var rec = component.get('v.rec');
        var picklistVal = component.get('v.pval');
        var fieldList = component.get('v.fieldList').split(';');
        var fieldMap = component.get('v.fieldTypeMap');
        for(var i=0; i<fieldList.length; i++){
            var key = fieldList[i];
            if(key != 'Id' && key != picklistVal){
                var currentFieldMap = fieldMap[key];
                var currentFieldType = currentFieldMap.type;
                var currentValue = rec[key];
                if(!$A.util.isUndefinedOrNull(currentValue)){
                    if(currentFieldType == 'REFERENCE'){
                        var relInfo = currentFieldMap.relationName.split('~*!');
                        lst.push(rec[relInfo[0]][relInfo[1]]);
                    }else if(currentFieldType == 'CURRENCY'){
                        lst.push($A.localizationService.getDefaultCurrencyFormat().format(currentValue));
                    }else if(currentFieldType == 'PERCENT'){
                        lst.push(currentValue+'%');
                    }else if(currentFieldType == 'DATE'){
                        lst.push($A.localizationService.formatDate(currentValue));
                    }else if(currentFieldType == 'DATETIME'){
                        lst.push($A.localizationService.formatDate(currentValue, "MMM DD YYYY, hh:mm a"));
                    }else if(currentFieldType == 'BOOLEAN'){
                        lst.push(currentValue ? 'Yes' : 'No');
                    }else if(currentFieldType == 'DOUBLE'){
                        lst.push(currentValue.toString());
                    }else{
                        lst.push(currentValue);
                    }
                }
                
                if(key == "Name" || key == "CaseNumber"){
                    component.set('v.namePos', i);
                }
            }
        }
        //console.log(fieldMap);
        component.set('v.dList',lst);
    },
    navToRec : function(component, event, helper) {
        var recId = event.target.id;
        if(recId && recId != ''){
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": recId
            });
            navEvt.fire();
        }
    },
    recActionSelected : function(component, event, helper) {
        var label = event.getParam("value");
        var value = event.getSource().get('v.value');
        if(label == "Edit"){
            var editRecordEvent = $A.get("e.force:editRecord");
            editRecordEvent.setParams({
                "recordId": value
            });
            editRecordEvent.fire();
        }else if(label == "Delete"){
            var dObj = {};
            dObj.from = component.get('v.rec')[component.get('v.pval')];
            dObj.pos = parseInt(component.get('v.recPos'));
            var kcevt = component.getEvent('kanbanChildDelReq');
            kcevt.setParams({
                "KanbanChildDelete" : dObj
            });
            kcevt.fire();
        }
    }
})