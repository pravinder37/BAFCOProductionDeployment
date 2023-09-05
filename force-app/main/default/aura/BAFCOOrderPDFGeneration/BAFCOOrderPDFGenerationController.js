({
    openVFPage : function(component, event, helper) {
        let recordId = component.get("v.recordId");
        let selected = component.get("v.value");
        var action = component.get("c.getOrderRecordType");
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let device = $A.get("$Browser.formFactor");
                let showCharges = false;
                let showShippLine = false;
                if(selected.includes('showShippLine')) showShippLine = true;
                if(selected.includes('showCharges')) showCharges = true;
                let orderObj = response.getReturnValue();
                console.log('orderObj '+JSON.stringify(orderObj,null,2));
                let recordType = orderObj.RecordType.Name;
                let isAir = false;
                if(orderObj.Order_Type__c == 'Air Export' || orderObj.Order_Type__c == 'Air Import') isAir = true;
                if(isAir == true){
                    let urlEvent = $A.get("e.force:navigateToURL");
                    if(device == 'PHONE'){
                        urlEvent.setParams({
                            "url":"/apex/BAFCOOrderPDFMobile?showShippLine="+showShippLine+'&showCharges='+showCharges+'&recordId='+recordId+'&device='+device+'&recordType='+recordType
                        });
                    }
                    else{
                        urlEvent.setParams({
                            "url":"/apex/BAFCOAirOrderPDFPage?showShippLine="+showShippLine+'&showCharges='+showCharges+'&recordId='+recordId
                        });
                    }
                    urlEvent.fire();  
                }
                else{
                    let urlEvent = $A.get("e.force:navigateToURL");
                    if(device == 'PHONE'){
                        urlEvent.setParams({
                            "url":"/apex/BAFCOOrderPDFMobile?showShippLine="+showShippLine+'&showCharges='+showCharges+'&recordId='+recordId+'&device='+device+'&recordType='+recordType
                        });
                    }
                    else{
                        if(recordType == 'Export'){
                            urlEvent.setParams({
                                "url":"/apex/BAFCOOrderPDFPage?showShippLine="+showShippLine+'&showCharges='+showCharges+'&recordId='+recordId
                            });
                        }
                        else if(recordType == 'Import'){
                            urlEvent.setParams({
                                "url":"/apex/BAFCOOrderImportPDFPage?showShippLine="+showShippLine+'&showCharges='+showCharges+'&recordId='+recordId
                            });
                        }
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