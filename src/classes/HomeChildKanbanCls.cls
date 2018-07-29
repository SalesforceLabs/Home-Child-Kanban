/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
public with sharing class HomeChildKanbanCls {
    
    @AuraEnabled
    public static string saveConfig(Kanban_Configuration__c obj){
        try{
            if(obj.kanbanDev__Kanban_For__c == 'Child'){
                obj.kanbanDev__Name_Field__c = HomeChildKanbanUtil.getNameField(obj.kanbanDev__Child_Object__c);
            }else if(obj.kanbanDev__Kanban_For__c == 'Home'){
                obj.kanbanDev__Name_Field__c = HomeChildKanbanUtil.getNameField(obj.kanbanDev__For_Object__c);
            }
            upsert obj;
            return 'true';
        }catch(exception e){
            return e.getMessage();
        }
    }
    
    @AuraEnabled
    public static Map<string, List<HomeChildKanbanObjUtil>> getObjs(){
        Map<string, List<HomeChildKanbanObjUtil>> objmap = new Map<string, List<HomeChildKanbanObjUtil>>();
        
        List<Schema.SObjectType> objs = Schema.getGlobalDescribe().values();
        
        List<HomeChildKanbanObjUtil> sList = new List<HomeChildKanbanObjUtil>();
        List<HomeChildKanbanObjUtil> cList = new List<HomeChildKanbanObjUtil>();
        
        for(Schema.SObjectType s : objs){
            Schema.DescribeSObjectResult ds = s.getDescribe();
            if(ds.isAccessible() && ds.isQueryable()){
                HomeChildKanbanObjUtil hcu = new HomeChildKanbanObjUtil(ds.getName(), ds.getLabel());
                if(ds.isCustom()){
                    cList.add(hcu);
                }else{
                    sList.add(hcu);
                }
            }
        }
        objmap.put('standard', sList);
        objmap.put('custom', cList);
        
        return objmap;
    }
    
    @AuraEnabled
    public static Map<string, List<HomeChildKanbanCObjUtil>> getObjChilds(string objName){
        Map<string, List<HomeChildKanbanCObjUtil>> objmap = new Map<string, List<HomeChildKanbanCObjUtil>>();
        List<HomeChildKanbanCObjUtil> sList = new List<HomeChildKanbanCObjUtil>();
        List<HomeChildKanbanCObjUtil> cList = new List<HomeChildKanbanCObjUtil>();
        List<Schema.ChildRelationship> cObjs = Schema.getGlobalDescribe().get(objName).getDescribe().getChildRelationships();
        for(Schema.ChildRelationship s : cObjs){
            Schema.DescribeSObjectResult sObj = s.getChildSObject().getDescribe();
            Schema.DescribeFieldResult sFld = s.getField().getDescribe();
            if(sObj.isDeprecatedAndHidden() != true && sObj.isAccessible() && sObj.isCreateable() && sObj.isUpdateable() && sObj.isQueryable() && sFld.isFilterable() && sFld.isAccessible()){
                HomeChildKanbanCObjUtil hcu = new HomeChildKanbanCObjUtil(sObj.getName()+'~;'+sFld.getName(), sObj.getLabel()+' ('+sFld.getName()+')', sFld.getName());
                if(sObj.isCustom()){
                    cList.add(hcu);
                }else{
                    sList.add(hcu);
                }
            }
        }
        objmap.put('standard', sList);
        objmap.put('custom', cList);
        return objmap;
    }
    
    @AuraEnabled
    public static Map<string, List<HomeChildKanbanObjUtil>> getObjFlds(string objName){
        Map<string, List<HomeChildKanbanObjUtil>> objFldmap = new Map<string, List<HomeChildKanbanObjUtil>>();
        Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
        
        List<HomeChildKanbanObjUtil> aList = new List<HomeChildKanbanObjUtil>();
        List<HomeChildKanbanObjUtil> gList = new List<HomeChildKanbanObjUtil>();
        List<HomeChildKanbanObjUtil> sList = new List<HomeChildKanbanObjUtil>();
        
        for(Schema.SObjectField sfield : fieldMap.Values())
        {
            schema.describefieldresult dfield = sfield.getDescribe();
            if(dfield.isAccessible() && dfield.isDeprecatedAndHidden() != true){
                string fldType = string.valueOf(dfield.getType());
                HomeChildKanbanObjUtil hcu = new HomeChildKanbanObjUtil(dfield.getName(), dfield.getLabel());
                aList.add(hcu);
                if(dfield.isGroupable() && dfield.isUpdateable() && fldType == 'PICKLIST'){
                    gList.add(hcu);
                }
                if(fldType == 'Double' || fldType == 'Integer' || fldType == 'Currency'){
                    sList.add(hcu);
                }
            }
        }
        objFldmap.put('all', aList);
        objFldmap.put('groupBy', gList);
        objFldmap.put('sumBy', sList);
        return objFldmap;
    }
    
    @AuraEnabled
    public static List<HomeChildKanbanObjUtil> getPickVals(String FldName, String objName){
        List<HomeChildKanbanObjUtil> plist = new List<HomeChildKanbanObjUtil>();
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(FldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            plist.add(new HomeChildKanbanObjUtil(f.getLabel(), f.getValue()));
        }       	
        return plist;
    }
    
    @AuraEnabled
    public static HomeChildKanbanUtil getKanban(String objName, List<String> objFields, String kabnanField, String ParentRecId, String relField, List<string> ExcVal, String summField, String KbObjNameField){
        //system.debug(objFields);
        if(summField != null){
            objFields.add(summField);
        }
        if(KbObjNameField != null && KbObjNameField != 'false'){
            if(Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(KbObjNameField) != null){
                objFields.add(KbObjNameField);
            }
        }
        objFields.add(kabnanField);
        Set<string> obFields = new Set<string>(objFields);
        obFields.remove('Id');
        /*Checks if all the requested fields are accessible*/
        if(HomeChildKanbanUtil.checkAccessibleFLS(obFields, objName)){
            Set<string> kfldCheck = new Set<string>();
            kfldCheck.add(kabnanField);
            /*Checks if the Group By Field is Updatable*/
            if(HomeChildKanbanUtil.checkAccessibleFLS(kfldCheck, objName)){
                boolean ispdatable = HomeChildKanbanUtil.checkUpdateableFLS(kfldCheck, objName);
                try{
                    Schema.DescribeSObjectResult actdsc = Schema.getGlobalDescribe().get(objName).getDescribe();
                    Map<String, Schema.SObjectField> allFieldMap = actdsc.fields.getMap();
                    string agrFldName = null;
                    string sFldIsCurrency = null;
                    Map<string, decimal> aggQMap;
                    List<AggregateResult> sumQuery;
                    if(summField != null){
                        Schema.DescribeFieldResult ads = allFieldMap.get(summField).getDescribe();
                        string aftype = string.valueOf(ads.getType());
                        if(aftype == 'Double' || aftype == 'Integer' || aftype == 'Currency'){
                            agrFldName = ads.getLabel();
                            sFldIsCurrency = aftype;
                            aggQMap = new Map<string, decimal>(); 
                        }else{
                            return new HomeChildKanbanUtil(null, null, false, 'The field '+summField+' cannot be summarized.', null, null, null, null, null, null, null, null, null);   
                        }  
                    }
                    
                    List<string> Pickvalslst = new List<String>();
                    Set<string> ExcVals = new Set<string>(ExcVal);
                    Map<string, list<sobject>> recMaps = new Map<string, list<sobject>>();
                    
                    for(Schema.PicklistEntry s: allFieldMap.get(kabnanField).getDescribe().getpicklistValues()){
                        if(!ExcVals.contains(s.getValue()) && s.isActive()){
                            Pickvalslst.add(s.getValue());
                            recMaps.put(s.getValue(), new List<sobject>());
                            if(summField != null){
                                aggQMap.put(s.getValue(), 0);    
                            }
                        }
                    }
                    
                    string cObName = actdsc.getLabel();
                    Schema.DescribeFieldResult utilResult = allFieldMap.get(kabnanField).getDescribe();
                    string gFldName = utilResult.getLabel();
                    boolean gFldEditable = utilResult.isUpdateable();
                    boolean isObjDeletable = actdsc.isDeletable();
                    boolean isObjectCreateable = actdsc.isCreateable();
                    
                    //For Getting a Map of field name and its type
                    Map<String, Map<String, String>> fieldTypeMap = new Map<String, Map<String, String>>();
                 
                    String qry = 'Select Id, ';
                    for(String s: obFields){
                        Schema.DescribeFieldResult currentFieldResult = allFieldMap.get(s).getDescribe();
                        string currentFieldType = string.valueOf(currentFieldResult.getType());
                        Map<String, String> currentMap = new Map<String, String>();
                        currentMap.put('type', currentFieldType);
                        if(currentFieldType == 'REFERENCE'){
                            string currentRelationName = currentFieldResult.getRelationshipName();
                            string refObjName;
                            if(currentFieldResult.isNamePointing()){
                                for(Schema.SObjectType reference : currentFieldResult.getReferenceTo()) {
                                    Schema.DescribeSObjectResult dsr = reference.getDescribe();
                                    if(dsr.isAccessible()){
                                        refObjName = dsr.getName();
                                        break;
                                    }
                                }
                                if(refObjName == null){
                                    return new HomeChildKanbanUtil(null, null, false, 'You do not have access to relational object. Please contact your administrator.', null, null, null, null, null, null, null, null, null);
                                }
                            }else{
                                refObjName = currentFieldResult.getReferenceTo()[0].getDescribe().getName();
                            }
                            string fName = HomeChildKanbanUtil.getNameField(refObjName);
                            if(fName != 'false'){
                             	qry += currentRelationName+'.'+fName+' ,';
                            }else{
                                return new HomeChildKanbanUtil(null, null, false, 'You do not have access to relation object '+refObjName+'. Please contact your administrator.', null, null, null, null, null, null, null, null, null);
                            }
                            currentMap.put('relationName', currentRelationName+'~*!'+fName);
                        }
                        qry += s+' ,';
                        fieldTypeMap.put(s, currentMap);
                    }
                    qry = qry.removeEnd(',');
                    
                    qry += ' From '+objName+' where '+kabnanField+' in :Pickvalslst';
                    
                    if(ParentRecId != '' && ParentRecId != null && relField != '' && relField != null){
                        qry += ' and '+relField+'=\''+ParentRecId+'\'';
                    }
                    
                    //system.debug('genquery '+ qry);   
                    
                    for(sobject s: database.query(qry)){
                        recMaps.get(string.valueOf(s.get(kabnanField))).add(s);
                        if(summField != null){
                            decimal sVal = (Decimal)s.get(summField);
                            if(sVal != null){
                                aggQMap.put(string.valueOf(s.get(kabnanField)), (Decimal)s.get(summField) + (Decimal)aggQMap.get(string.valueOf(s.get(kabnanField))) );       
                            }
                        }
                    }
                    //system.debug(recMaps);
                    return new HomeChildKanbanUtil(recMaps, Pickvalslst, true, null, gFldName, cObName, agrFldName, sFldIsCurrency, aggQMap, gFldEditable, isObjDeletable, fieldTypeMap, isObjectCreateable);
                }catch (exception e){
                    return new HomeChildKanbanUtil(null, null, false, e.getMessage(), null, null, null, null, null, null, null, null, null);
                }
            }else{
                return new HomeChildKanbanUtil(null, null, false, 'You do not have access to the specified Group By field. Please contact your administrator.', null, null, null, null, null, null, null, null, null);   
            }
        }else{
            return new HomeChildKanbanUtil(null, null, false, 'You do not have access to the requested fields. Please contact your administrator.', null, null, null, null, null, null, null, null, null);   
        }
        
    }
    
    @AuraEnabled
    public static string updateRec(string recId, string recField, string recVal){
        try{
            Schema.DescribeSObjectResult sObjRes = Id.valueOf(recId).getSObjectType().getDescribe();
            Schema.DescribeFieldResult fldRes = sObjRes.fields.getMap().get(recField).getDescribe();
            if(sObjRes.isAccessible() && sObjRes.isUpdateable() && fldRes.isUpdateable()){
                String sObjName = sObjRes.getName();
                sObject s = Schema.getGlobalDescribe().get(sObjName).newSObject() ;
                s.Id = recId;
                s.put(recField, recVal);
                update s;
                return 'true';
            }else{
                return 'You do not have update access to object. Please contact your administrator.';
            }
            
        }
        catch(exception e){
            return e.getMessage();
        }
    }
    
    @AuraEnabled
    public static string deleteRec(sobject obj){
        Schema.DescribeSObjectResult sObjRes = Id.valueOf(obj.Id).getSObjectType().getDescribe();
        if(sObjRes.isDeletable()){
            try{
            	delete obj;
                return 'true';
            }catch(exception e){
                return e.getMessage();
            }
        }else{
            return 'You do not have permissions to delete the record. Please contact your administrator.';
        }
    }
    
    
}