
/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

({
	updateChildHelper : function(component, recId, recField, data) {
	},
     modalHelper : function(component, modal, backdrop, tf) {
        var mdl = component.find(modal).getElement();
        var bkdrp = component.find(backdrop).getElement();
        if(tf){
            $A.util.addClass(mdl, 'slds-fade-in-open');
            $A.util.addClass(bkdrp, 'slds-backdrop_open');
        }else{
            $A.util.removeClass(mdl, 'slds-fade-in-open');
            $A.util.removeClass(bkdrp, 'slds-backdrop_open');
        }
    },
    spinnerHelper : function(component, tf){
        var spinner = component.find('spinner');
        if(tf){
            $A.util.removeClass(spinner,'slds-hide');
        }else{
            $A.util.addClass(spinner,'slds-hide');
        }
    }
})