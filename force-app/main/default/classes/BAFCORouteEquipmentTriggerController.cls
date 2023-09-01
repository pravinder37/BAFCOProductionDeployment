public class BAFCORouteEquipmentTriggerController {
    public static final Id RMS_EXPORT_RECORDTYPE_Id = Schema.SObjectType.RMS__c.getRecordTypeInfosByName()
        .get('Export')
        .getRecordTypeId();
    public static final Id RMS_IMPORT_RECORDTYPE_Id = Schema.SObjectType.RMS__c.getRecordTypeInfosByName()
        .get('Import')
        .getRecordTypeId();
    public static void insertRouteProcumnet(List<Route_Equipment__c> newList){
        Set<Id> routeIds = new Set<Id>();
        Set<Id> loadingPortIds = new Set<Id>();
        Set<Id> destinationPortIds = new Set<Id>();
        Set<Id> shippingLineIds = new Set<Id>();
        Set<Id> equipmentIds = new Set<Id>();
        List<Rate_Procurement__c> ratePocumentList = new List<Rate_Procurement__c>();
        for(Route_Equipment__c routequip: newList){
            if(routequip.Equipment_Type__c != null) {
                routeIds.add(routequip.Route__c);
                if(routequip.Equipment_Type__c != null ) equipmentIds.add(routequip.Equipment_Type__c);
            }
        }
        for(Route__c routeObj : [Select id, Port_of_Destination__c,Port_of_loading__c,Shipping_Line__c from Route__c where id in : routeIds]){
            if(routeObj.Port_of_loading__c != null ) loadingPortIds.add(routeObj.Port_of_loading__c);
            if(routeObj.Port_of_Destination__c != null ) destinationPortIds.add(routeObj.Port_of_Destination__c);
            if(routeObj.Shipping_Line__c != null ) shippingLineIds.add(routeObj.Shipping_Line__c);
        }
        for(Rms__c rmsobj : [Select Agent__c,id,RecordTypeId,Port_Of_Loading__c,Port_Of_Discharge__c,Shipping_Line__c,Equipment_Type__c from Rms__c 
                             where Port_Of_Loading__c in : loadingPortIds AND Port_Of_Discharge__c in :  destinationPortIds
                             AND Shipping_Line__c in : shippingLineIds and Equipment_Type__c in : equipmentIds
                            ]){
                                List<Rate_Procurement__c> procumentList  = new  List<Rate_Procurement__c>();
                                if(rmsObj.RecordTypeId == RMS_EXPORT_RECORDTYPE_Id){
                                    procumentList = [Select id from Rate_Procurement__c where 
                                                     Port_of_Loading__c =:rmsobj.Port_Of_Loading__c AND 
                                                     Port_of_Discharge__c =:rmsObj.Port_Of_Discharge__c AND 
                                                     Shipping_Line__c =: rmsObj.Shipping_Line__c AND 
                                                     Equipment_Type__c =: rmsObj.Equipment_Type__c limit 1];
                                }
                                else if(rmsObj.RecordTypeId == RMS_IMPORT_RECORDTYPE_Id){
                                    procumentList = [Select id from Rate_Procurement__c where 
                                                     Port_of_Loading__c =:rmsobj.Port_Of_Loading__c AND 
                                                     Port_of_Discharge__c =:rmsObj.Port_Of_Discharge__c AND 
                                                     Shipping_Line__c =: rmsObj.Shipping_Line__c AND 
                                                     Agent__c =:rmsObj.Agent__c AND 
                                                     Equipment_Type__c =: rmsObj.Equipment_Type__c limit 1];
                                }
                                if(procumentList.size() > 0){
                                    Id ReceivedRecordtypeId = Schema.SObjectType.Rate_Procurement__c.getRecordTypeInfosByName()
                                        .get('Received')
                                        .getRecordTypeId();
                                    Rate_Procurement__c proobj = procumentList[0];
                                    proobj.RMS__c = rmsObj.id;
                                    proobj.RecordTypeId = ReceivedRecordtypeId;
                                    ratePocumentList.add(proobj);
                                }
                            }
        if(ratePocumentList.size()>0) update ratePocumentList;
    }
    public static void onbeforeInsert(List<Route_Equipment__c> newList){
        updateTeus(newList);
    }
    public static void onbeforeUpdate(Map<Id,Route_Equipment__c> oldMap,List<Route_Equipment__c> newList){
        List<Route_Equipment__c> routeEquipMentList = new List<Route_Equipment__c>();
        for(Route_Equipment__c rEquip : newList){
            if(rEquip.Name != oldMap.get(rEquip.id).Name || rEquip.Quantity__c != oldMap.get(rEquip.id).Quantity__c ){
                routeEquipMentList.add(rEquip);
            }
        }
        if(routeEquipMentList.size() > 0 ) updateTeus(routeEquipMentList);
    }
    public static void updateTeus(List<Route_Equipment__c> newList){
        List<Id> routeIds = new List<Id>();
        Map<Id,Route__c> routeIdMap = new Map<Id,Route__c>();
        for(Route_Equipment__c rEquip : newList){
            routeIds.add(rEquip.Route__c);
        }
        for(Route__c routeObj : [Select id,Service_Type__c,Total_Gross_Weight_KGs__c,Total_CBM__c,Total_Volumetric_Weight__c from Route__c where id  in : routeIds]){
            routeIdMap.put(routeObj.id, routeObj);
        }
        for(Route_Equipment__c item : newList){
            if(routeIdMap.get(item.Route__c).Service_Type__c == 'Sea Export' || routeIdMap.get(item.Route__c).Service_Type__c == 'Sea Import' ||routeIdMap.get(item.Route__c).Service_Type__c == 'ISO Export' ||routeIdMap.get(item.Route__c).Service_Type__c == 'ISO Import'){
                if(item.Name.contains('40') == true){
                    item.Teusnew__c = 2 * (item.Quantity__c != null ? item.Quantity__c : 1);
                }
                if(item.Name.contains('20') == true){
                    item.Teusnew__c = 1 * (item.Quantity__c != null ? item.Quantity__c : 1);
                }
            }
            else if(routeIdMap.get(item.Route__c).Service_Type__c == 'Local Operation Export' || routeIdMap.get(item.Route__c).Service_Type__c == 'Local Operation Import'){
                if(item.Name.contains('40') == true){
                    item.Teusnew__c = item.Quantity__c > 0 ? item.Quantity__c/2 : 0;
                }
                if(item.Name.contains('20') == true){
                    item.Teusnew__c = item.Quantity__c > 0 ? item.Quantity__c/4 : 0;
                }
            }
            else if(routeIdMap.get(item.Route__c).Service_Type__c == 'LCL Export' || routeIdMap.get(item.Route__c).Service_Type__c == 'LCL Import'){
                Route__c routeObj = routeIdMap.get(item.Route__c);
                Decimal largest = 0;
                if(routeObj.Total_CBM__c >= routeObj.Total_Gross_Weight_KGs__c && routeObj.Total_CBM__c >= routeObj.Total_Volumetric_Weight__c){
                    largest = routeObj.Total_CBM__c ;
                }
                else if(routeObj.Total_Gross_Weight_KGs__c >= routeObj.Total_CBM__c && routeObj.Total_Gross_Weight_KGs__c >= routeObj.Total_Volumetric_Weight__c){
                    largest = routeObj.Total_Gross_Weight_KGs__c ;
                }
                else{
                    largest =  routeObj.Total_Volumetric_Weight__c;
                }
                item.Teusnew__c = largest > 0 ? largest / 250 : 0;
                /*if(routeEquipIdMap.containsKey(item.Tab_View__c)){
                    item.Teusnew__c = routeEquipIdMap.get(item.Tab_View__c) / 250;
                }*/
            }
            else if(routeIdMap.get(item.Route__c).Service_Type__c == 'Air Export' || routeIdMap.get(item.Route__c).Service_Type__c == 'Air Import'){
                item.Teusnew__c = (routeIdMap.get(item.Route__c).Chargeable_Weight__c)/250;
            }
        }
    }
}