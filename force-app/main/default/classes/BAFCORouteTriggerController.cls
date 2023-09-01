public class BAFCORouteTriggerController {
    public static void updateNameOnOpty(List<Route__c> routeList){
        Set<Id> optyId = new Set<Id>();
        Map<Id,String> optyIdToRouteName = new Map<Id,String>();
        for(Route__c routeObj : routeList){
            optyId.add(routeObj.Opportunity_Enquiry__c);
        }
        system.debug('optyId '+optyId);
        system.debug('routeList '+routeList);
        if(optyId.size() > 0){
            List<Opportunity> optyList = new List<Opportunity>();
            for(Route__c routeObj : [Select id,name,Opportunity_Enquiry__c from Route__c where Opportunity_Enquiry__c in :optyId ]){
                system.debug('routeObj '+routeObj);
                String details = '';
                if(!optyIdToRouteName.containsKey(routeObj.Opportunity_Enquiry__c)){
                    details += routeObj.Name ;
                }
                else{
                    details = optyIdToRouteName.get(routeObj.Opportunity_Enquiry__c);
                    details += '\n'+ routeObj.Name ;
                }
                system.debug('details '+details);
                optyIdToRouteName.put(routeObj.Opportunity_Enquiry__c,details);
            }
            system.debug('optyIdToRouteName '+optyIdToRouteName);
            for(Opportunity opty : [Select id from Opportunity where id in:optyIdToRouteName.keySet()]){
                Opportunity obj = new Opportunity();
                Obj.Id = opty.id;
                obj.routes__c = optyIdToRouteName.get(opty.id);
                optyList.add(obj);
            }
            update optyList;
        }
    }
}