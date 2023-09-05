({
    openVFPage : function(component, event, helper) {
        let recordId = component.get("v.recordId");
        var action = component.get("c.getQuoteDetail");
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let selected = component.get("v.value");
                console.log(JSON.stringify(selected));
                let device = $A.get("$Browser.formFactor");
                component.set("v.device", device);
                let showCharges = false;
                let showShippLine = false;
                if(selected.includes('showShippLine')) showShippLine = true;
                if(selected.includes('showCharges')) showCharges = true;
                let isAir = false;
                let quoteObj = response.getReturnValue();
                if(quoteObj.Quotation_Type__c == 'Air Export' || quoteObj.Quotation_Type__c == 'Air Import') isAir = true;
                if(isAir == true){
                    let urlEvent = $A.get("e.force:navigateToURL");
                    if(device == 'PHONE'){
                        urlEvent.setParams({
                            "url":"/apex/BAFCOQuotePDFMobile?showShippLine="+showShippLine+'&showCharges='+showCharges+'&recordId='+recordId+'&device='+device
                        });
                    }
                    else{
                        urlEvent.setParams({
                            "url":"/apex/BAFCOAirQuotePDF?showShippLine="+showShippLine+'&showCharges='+showCharges+'&recordId='+recordId+'&device='+device
                        });
                    }
                    urlEvent.fire(); 
                }
                else{
                    let urlEvent = $A.get("e.force:navigateToURL");
                    if(device == 'PHONE'){
                        urlEvent.setParams({
                            "url":"/apex/BAFCOQuotePDFMobile?showShippLine="+showShippLine+'&showCharges='+showCharges+'&recordId='+recordId+'&device='+device
                        });
                    }
                    else{
                        urlEvent.setParams({
                            "url":"/apex/BAFCOGeneratePdf?showShippLine="+showShippLine+'&showCharges='+showCharges+'&recordId='+recordId+'&device='+device
                        });
                    }
                    urlEvent.fire(); 
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})