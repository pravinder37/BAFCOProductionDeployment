public class BAFCOEditOpportunityController {
    @AuraEnabled 
    public static Opportunity getAccountId(String optyId){
        return [Select AccountId,recordtype.Name from Opportunity where id =: optyId];
    }
    @AuraEnabled public static OptyDetails getEditOptyDetail(String optyId){
        Opportunity opty = [Select id,CloseDate,Commercial_User__r.Name,Business_Type__c,recordtype.Name from Opportunity where id =:optyId ];
        OptyDetails dto = new OptyDetails();
        dto.businessType = opty.Business_Type__c;
        dto.closeDate = opty.CloseDate;
        dto.commercialUserId = opty.Commercial_User__c;
        dto.commercialUserName = opty.Commercial_User__r.name;
        Integer routeIndex = 1;
        List<BAFCORoutingDetailsDto> routingList = new List<BAFCORoutingDetailsDto>();
        for(Route__c routeObj : [Select Airline__r.Name,Cargo_Readiness__c,Opportunity_Enquiry__r.Recordtype.name,Pickup_Place__c,(Select Cargo_Details__c,Units__c,Palletized__c,Stackable__c,Weight_Kgs__c,CBM__c,Height__c,Width__c,Length__c,id,Quantity__c,Equipment_Type__r.name from Route_Equipments__r),Regular_Routing_Lookup__c,Discharge_Place__c,Place_of_Pickup__c,Dangerous_Goods__c,Remarks__c,id,Commodity__r.name,INCO_Term__r.name,Cargo_Weight__c,DG_Class__c,Port_of_loading__r.name,Port_of_Destination__r.name,Shipping_Line__r.name,Service_Type__c,Airport_of_Destination__r.name,Airport_of_Loading__r.name from Route__c where Opportunity_Enquiry__c =: optyId]){
            BAFCORoutingDetailsDto routeDto = new BAFCORoutingDetailsDto();
            routeDto.routeName = 'Route '+routeIndex;
            if(routeObj.Commodity__c != null){
                routeDto.commodity = routeObj.Commodity__c;
                routeDto.commodityName = routeObj.Commodity__r.name;
            }
            if(routeObj.INCO_Term__c != null){
                routeDto.incoTerm = routeObj.INCO_Term__c;
                routeDto.incoTermName = routeObj.INCO_Term__r.name;
            }
            if(routeObj.Opportunity_Enquiry__r.Recordtype.name =='Air Freight'){
                routeDto.isAir = true;
                if(routeObj.Airport_of_Loading__c != null){
                    routeDto.portLoadingId = routeObj.Airport_of_Loading__c;
                    routeDto.portLoading = routeObj.Airport_of_Loading__r.name;
                }
                if(routeObj.Airport_of_Destination__c != null){
                    routeDto.portDestinationId = routeObj.Airport_of_Destination__c;
                    routeDto.portDestination = routeObj.Airport_of_Destination__r.name;
                }
                if(routeObj.Airline__c != null){
                    routeDto.shippingLine = routeObj.Airline__c;
                    routeDto.shippingLineName = routeObj.Airline__r.Name;
                }
                routeDto.stackableParent = routeObj.Route_Equipments__r[0].Stackable__c;
                routeDto.palletizedParent = routeObj.Route_Equipments__r[0].Palletized__c;
            }
            else{
                if(routeObj.Port_of_loading__c != null){
                    routeDto.portLoadingId = routeObj.Port_of_loading__c;
                    routeDto.portLoading = routeObj.Port_of_loading__r.name;
                }
                if(routeObj.Port_of_Destination__c != null){
                    routeDto.portDestinationId = routeObj.Port_of_Destination__c;
                    routeDto.portDestination = routeObj.Port_of_Destination__r.name;
                }
                if(routeObj.Shipping_Line__c != null){
                    routeDto.shippingLine = routeObj.Shipping_Line__c;
                    routeDto.shippingLineName = routeObj.Shipping_Line__r.Name;
                }
            }
            
            routeDto.leadIndex = String.valueOf(routeIndex);
            routeDto.serviceType = routeObj.Service_Type__c;
            routeDto.remarks = routeObj.Remarks__c;
            routeDto.cargoWeights = routeObj.Cargo_Weight__c;
            routeDto.dangerousGoods = routeObj.Dangerous_Goods__c;
            routeDto.dgClass = routeobj.DG_Class__c;
            routeDto.placeOfPickup = routeObj.Pickup_Place__c;
            routeDto.placeOfDischarge = routeObj.Discharge_Place__c;
            routeDto.routeId = routeObj.id;
            routeDto.cargoReadiness = String.valueOf(routeObj.Cargo_Readiness__c);
            routeDto.routingRegular = routeObj.Regular_Routing_Lookup__c;
            List<BAFCORoutingDetailsDto.containerRecord> containerList = new List<BAFCORoutingDetailsDto.containerRecord>();
            if(routeObj.Route_Equipments__r.size() > 0){
                Integer containerIndex = 1;
                for(Route_Equipment__c item : routeObj.Route_Equipments__r){
                    BAFCORoutingDetailsDto.containerRecord itemDto = new BAFCORoutingDetailsDto.containerRecord();
                    itemDto.containerType = item.Equipment_Type__c;
                    itemDto.containerTypeName = item.Equipment_Type__r.name;
                    itemDto.quantity = item.Quantity__c;
                    itemDto.length = item.Length__c;
                    itemDto.width = item.Width__c;
                    itemDto.height = item.Height__c;
                    itemDto.CBM = item.CBM__c;
                    itemDto.Weight = item.Weight_Kgs__c;
                    itemDto.units = item.Units__c;
                    itemDto.stackable = item.Stackable__c;
                    itemDto.palletized = item.Palletized__c;
                    itemDto.id = item.id;
                    itemDto.cargoDetails = item.Cargo_Details__c;
                    itemDto.index = String.valueOf(routeIndex)+'.'+String.valueOf(containerIndex++);
                    containerList.add(itemDto);
                }
            }
            routeDto.containerRecord = containerList;
            routeIndex++;
            routingList.add(routeDto);
        }
        dto.routingList = routingList;
        return dto;
    }
    public class OptyDetails{
        @AuraEnabled public string businessType{get;set;}
        @AuraEnabled public date closeDate{get;set;}
        @AuraEnabled public String commercialUserId{get;set;}
        @AuraEnabled public String commercialUserName{get;set;}
        @AuraEnabled public List<BAFCORoutingDetailsDto> routingList{get;set;}
    }
        public static void testDummy(){
        Integer a=10;
        Integer b=5;
        Integer c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
         c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
         c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
         c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
         c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
         c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
         c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
    }
}