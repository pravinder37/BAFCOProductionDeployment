public class BAFCOOptyRateProcumentController {
    @AuraEnabled
    public static List<RouteList> getRouteRouteDetails(String optyId){
        List<RouteList> dtoList = new List<RouteList>();
        Opportunity opty = [Select id,Business_Type__c,Service_Type__c from Opportunity where id =: optyId];
        if(opty.Service_Type__c == 'Sea Export' || opty.Service_Type__c == 'Sea Import' || opty.Service_Type__c == 'ISO Export' || opty.Service_Type__c == 'ISO Import'){
            List<Route__c> routeList =  [Select Name,id,Opportunity_Enquiry__r.Branch__c,Port_of_Destination__r.name,Port_of_loading__r.name,Commodity__r.name from route__c where Opportunity_Enquiry__c =: optyId];
            Map<Id,Route__c> routeMap = new Map<Id,Route__c>();
            for(Route__c routeObj : routeList){
                routeMap.put(routeObj.id,routeObj);
            }
            for(Route_Equipment__c equipObj : [Select Quantity__c,id,Route__c, Equipment_Type__r.name from Route_Equipment__c where Route__c in : routeMap.keySet()]){
                RouteList dto = new RouteList();
                Route__c routeObj = routeMap.get(equipObj.Route__c);
                dto.routeName = routeObj.Name;
                dto.routeId = equipObj.Route__c;
                dto.portLoading = routeObj.Port_of_loading__r.name;
                dto.portDischarge = routeObj.Port_of_Destination__r.name;
                dto.commodity = routeObj.Commodity__r.name;
                dto.enquiryId = optyId;
                dto.cameFromImport = opty.Business_Type__c == 'Export' ? 'false' : 'true';
                dto.equipmentType = equipObj.Equipment_Type__r.name;
                dto.quantity = equipObj.Quantity__c;
                dtoList.add(dto);
            }
        }
        return dtoList;
    }
    public class RouteList{
        @AuraEnabled public String routeName{get;set;}
        @AuraEnabled public String routeId{get;set;}
        @AuraEnabled public String portLoading{get;set;}
        @AuraEnabled public String commodity{get;set;}
        @AuraEnabled public String portDischarge{get;set;}
        @AuraEnabled public String enquiryId{get;set;}
        @AuraEnabled public String cameFromImport{get;set;}
        @AuraEnabled public String equipmentType{get;set;}
        @AuraEnabled public Decimal quantity{get;set;}
    }
}