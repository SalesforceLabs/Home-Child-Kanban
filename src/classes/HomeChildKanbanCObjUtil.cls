/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
public with sharing class HomeChildKanbanCObjUtil{
	 @AuraEnabled
    public string objName {get; set;}
    
    @AuraEnabled
    public string objLabel {get; set;}
    
    @AuraEnabled
    public string objRelField {get; set;}
    
    public HomeChildKanbanCObjUtil(string oName, string oLabel, string relFld){
        this.objName = oName;
        this.objLabel = oLabel;
        this.objRelField = relFld;
    } 
}