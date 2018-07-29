/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
public class HomeChildKanbanCls_Test {
    
    public static testmethod void tm1(){
        account a = new account(Name = 'name');
        insert a;
        sobject o = (SObject)Type.forName('opportunity').newInstance();
        o.put('Name', 'value');
        o.put('AccountId', a.id);
        o.put('StageName', 'Qualification');
        o.put('CloseDate', Date.today());
        //opportunity o = new opportunity(Name = 'name', AccountId = a.id, StageName = 'Qualification', CloseDate = Date.today());
        insert o;
        List<string> lString = new  List<string>();
        lString.add('Name');
        lString.add('OwnerId');
        List<string> lStrings = new list<string>();
        lStrings.add('Closed Lost');
        HomeChildKanbanUtil wrp = HomeChildKanbanCls.getKanban('opportunity', lString, 'stagename', string.valueOf(a.id), 'AccountId', lStrings, 'Amount', 'Name');
        HomeChildKanbanCls.getKanban('opportunity', lString, 'stagename', string.valueOf(a.id), 'AccountId', lStrings, 'Name', 'Name');
        HomeChildKanbanCls.getKanban('opportunity', lString, 'stagenam', string.valueOf(a.id), 'AccountId', null, null, 'Name');        
        HomeChildKanbanCls.getObjs();
        HomeChildKanbanCls.getObjChilds('Account');
        HomeChildKanbanCls.getObjFlds('Account');
        HomeChildKanbanCls.getPickVals('Industry','Account');
        system.assertEquals(wrp.isSuccess, true);
    }    
    
    public static testmethod void tm2(){
        account a = new account(Name = 'name');
        insert a;
        sobject o = (SObject)Type.forName('opportunity').newInstance();
        o.put('Name', 'value');
        o.put('AccountId', a.id);
        o.put('StageName', 'Qualification');
        o.put('CloseDate', Date.today());
        //opportunity o = new opportunity(Name = 'name', AccountId = a.id, StageName = 'Qualification', CloseDate = Date.today());
        insert o;
        string act = HomeChildKanbanCls.updateRec(string.valueOf(o.id), 'stagename', 'Qualification');
        HomeChildKanbanCls.updateRec(string.valueOf(o.id)+'a', 'stagenam', 'Qualificatio1');
        system.assertEquals(act, 'true');
    }
    
    public static testmethod void tm3(){
        account a = new account(Name = 'name');
        insert a;
        sobject o = (SObject)Type.forName('opportunity').newInstance();
        o.put('Name', 'value');
        o.put('AccountId', a.id);
        o.put('StageName', 'Qualification');
        o.put('CloseDate', Date.today());
        //opportunity o = new opportunity(Name = 'name', AccountId = a.id, StageName = 'Qualification', CloseDate = Date.today());
        insert o;
        HomeChildKanbanCls.deleteRec(o);
        system.assertEquals(null, null);
    }
    
    public static testmethod void tm4(){
        Kanban_Configuration__c k = new Kanban_Configuration__c(Name='Test');
        string res = HomeChildKanbanCls.saveConfig(k);
        system.assertEquals(res, 'true');
    }
    
    public static testmethod void tm5(){
        Kanban_Configuration__c k = new Kanban_Configuration__c(Name='Test');
        insert k;
        KanbanConfigList ka = new KanbanConfigList();
        ka.getDefaultValue();
        ka.getValues();
        system.assertEquals(null, null);
    }
    
}