/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
public with sharing class HomeChildKanbanUtil {

        @AuraEnabled
        public List<String> pickVals {get; set;}
        @AuraEnabled
        public Map<string, list<sobject>> records {get; set;}
        @AuraEnabled
        public Map<string, decimal> rollupData {get; set;}
        @AuraEnabled
        public boolean isSuccess {get; set;}
        @AuraEnabled
        public string errorMessage {get; set;}
        @AuraEnabled
        public string gFieldName {get; set;}
        @AuraEnabled
        public string cObjName {get; set;}
        @AuraEnabled
        public string sumField {get; set;}
        @AuraEnabled
        public string sFldType {get; set;}
    	@AuraEnabled
        public boolean isEditable {get; set;}
    	@AuraEnabled
        public boolean isDeletable {get; set;}
    	@AuraEnabled
    	public Map<String, Map<String, String>> fieldTypeMap{get; set;}
    	@AuraEnabled
        public boolean isCreatable {get; set;}
        
        public HomeChildKanbanUtil(Map<string, list<sobject>> recs, List<string> pickValstr, Boolean iscs, String errorMessage, String gFldName, String cObName, String sFldName, string sFldIsCurrency, Map<string, decimal> rollupData, Boolean isEditable, Boolean isDeletable, Map<String, Map<String, String>> fieldTypeMap, Boolean isCreatable){
            this.records = recs;
            this.pickVals = pickValstr;
            this.isSuccess = iscs;
            this.errorMessage = errorMessage;
            this.gFieldName = gFldName;
            this.cObjName = cObName;
            this.sumField = sFldName;
            this.sFldType = sFldIsCurrency;
            this.rollupData = rollupData;
            this.isEditable = isEditable;
            this.isDeletable = isDeletable;
            this.fieldTypeMap = fieldTypeMap;
            this.isCreatable = isCreatable;
        }
    
    /* This method ensures the fields are Accessible. Ensuring FLS. */
    public static boolean checkAccessibleFLS(Set<String> fieldNames, String objName){
        boolean isSafe = false;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType myObj = schemaMap.get(objName);
        if(myObj.getDescribe().isAccessible()){ 
            for(String fldName: fieldNames){
                SObjectField myField = myObj.getDescribe().fields.getMap().get(fldName);
                if(myField != null && myField.getDescribe().isAccessible()){
                    isSafe = true;
                }else{
                    isSafe = false;
                    break;
                }    
            }
        }else{
            isSafe = false;
        }
        return isSafe;
    }
    
    /* This method ensures the fields are Createable. Ensuring FLS. 
    public static boolean checkCreateableFLS(Set<String> fieldNames, String objName){
        boolean isSafe = false;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType myObj = schemaMap.get(objName);
        if(myObj.getDescribe().isAccessible()){ 
            for(String fldName: fieldNames){
                SObjectField myField = myObj.getDescribe().fields.getMap().get(fldName);
                if(myField != null && myField.getDescribe().isAccessible() && myField.getDescribe().isCreateable()){
                    isSafe = true;
                }else{
                    system.debug('fldName : '+fldName);
                    isSafe = false;
                    break;
                }    
            }
        }else{
            isSafe = false;
        }
        return isSafe;
    }
*/
    
    /* This method ensures the fields are Createable and Updateable. Ensuring FLS. && myField.getDescribe().isCreateable() &&*/
    public static boolean checkUpdateableFLS(Set<String> fieldNames, String objName){
        boolean isSafe = false;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType myObj = schemaMap.get(objName);
        if(myObj.getDescribe().isAccessible()){ 
            for(String fldName: fieldNames){
                SObjectField myField = myObj.getDescribe().fields.getMap().get(fldName);
                if(myField != null && myField.getDescribe().isAccessible() && myField.getDescribe().isUpdateable()){
                    isSafe = true;
                }else{
                    isSafe = false;
                    break;
                }    
            }
        }else{
            isSafe = false;
        }
        return isSafe;
    }
    
    public static String getNameField(String sObjectName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType myObj = schemaMap.get(sObjectName);
        DescribeSobjectResult dsr = myObj.getDescribe();
        String fName = 'false';
        if(dsr.isAccessible()){
            Map<String, SObjectField> fields = dsr.fields.getMap();
            if ((!fields.containsKey('Name'))){
                for(sObjectField s : fields.values()){
                    Schema.DescribeFieldResult t = s.getDescribe();
                    if(t.isAccessible() && t.isNameField()){
                        fName = t.getName();    
                        break;
                    }
                }
                return fName;
            }else{
                if(fields.get('Name').getDescribe().isNameField() && fields.get('Name').getDescribe().isAccessible()){
                    return 'Name';
                }else{
                    return 'false';
                }
            }
        }else{
        	return 'false';    
        }
    }
}