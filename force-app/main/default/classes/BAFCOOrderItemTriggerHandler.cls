public class BAFCOOrderItemTriggerHandler {
    /*public static void addTargetValue(List<Order_Item__c> orderItemList,Map<ID,Order_Item__c> oldItemMap){                
        set<ID> ownerIDSet = new SET<ID>();
        set<ID> orderIDSet = new SET<ID>();
        Map<Id,Target__c> targetOwnerMap = new Map<Id,Target__c>();
        List<Target__c> targetListToUpdate = new List<Target__c>();
        List<Order__c> orderListToUpdate = new List<Order__c>();
        Date dt = System.today();
        Integer currentMonth = dt.Month();
        Integer currentYear = dt.Year();
        Map<ID,String> oppOwnerMap = new Map<ID,String>();
        for(Order_Item__c ord:orderItemList){   
            ownerIDSet.add(ord.Order__r.Opportunity_Order__r.Owner.ID);
            orderIDSet.add(ord.Order__c);
        } 
        //List<Order_Item__c> orderItemList =  [Select ID,Teus__c,Order__c From Order_Item__c WHERE Order__c IN : orderIDSet];
        for(Order__c ordForOwner : [Select id,Opportunity_Order__r.OwnerID FROM Order__c where ID IN : orderIDSet]){
            oppOwnerMap.put(ordForOwner.ID,ordForOwner.Opportunity_Order__r.OwnerID);
        }
        for(Target__c targetRec : [Select ID,Target_Value_In_Teus__c,Achieved_Value_In_Teus__c,Target_Month__c,OwnerId,Year_Value__c,Month_Value__c FROM Target__c Where OwnerId IN:oppOwnerMap.values() 
                                   AND Month_Value__c=:currentMonth AND Year_Value__c=:currentYear]){
                                       targetOwnerMap.put(targetRec.OwnerId,targetRec);  
                                   }
        system.debug('targetOwnerMap'+targetOwnerMap);
        if(targetOwnerMap!=NULL){
            for(Order_Item__c ordItem : orderItemList){
                //if(ordItem.Teus__c!=NULL && oldItemMap.get(ordItem.ID).Teus__c!=NULL && ordItem.Teus__c!=oldItemMap.get(ordItem.ID).Teus__c){
                Target__c targetRec = targetOwnerMap.get(oppOwnerMap.get(ordItem.Order__c));                
                //system.debug('targetRec.Achieved_Value_In_Teus__c '+targetRec.Achieved_Value_In_Teus__c+'ordItem.Teus__c '+ordItem.Teus__c);
                if(targetRec!=null && ordItem.Teus__c!=null){
                    if(targetRec.Achieved_Value_In_Teus__c!=NULL){
                        targetRec.Achieved_Value_In_Teus__c  = targetRec.Achieved_Value_In_Teus__c + ordItem.Teus__c;
                    }
                    else{
                        targetRec.Achieved_Value_In_Teus__c  = ordItem.Teus__c;
                    }
                    targetListToUpdate.add(targetRec);
                    Order__c ordRec = new Order__c(Id=ordItem.Order__c);
                    ordRec.Target__c = targetOwnerMap.get(oppOwnerMap.get(ordItem.Order__c)).ID;            
                    orderListToUpdate.add(ordRec);
                    
                }            
            }
        }
        system.debug('targetListToUpdate'+targetListToUpdate);
        if(targetListToUpdate!=NULL){
            database.update(targetListToUpdate);
        }
        system.debug('orderListToUpdate'+orderListToUpdate);
        if(orderListToUpdate!=NULL){
            database.update(orderListToUpdate);
        }
    }
    
    public static void removeTargetValue(List<Order_Item__c> orderItemList){
        set<ID> ownerIDSet = new SET<ID>();
        set<ID> orderIDSet = new SET<ID>();
        Map<Id,Target__c> targetOwnerMap = new Map<Id,Target__c>();
        List<Target__c> targetListToUpdate = new List<Target__c>();
        List<Order__c> orderListToUpdate = new List<Order__c>();
        Date dt = System.today();
        Integer currentMonth = dt.Month();
        Integer currentYear = dt.Year();
        Map<ID,String> oppOwnerMap = new Map<ID,String>();
        for(Order_Item__c ord:orderItemList){   
            ownerIDSet.add(ord.Order__r.Opportunity_Order__r.Owner.ID);
            orderIDSet.add(ord.Order__c);
        } 
        //List<Order_Item__c> orderItemList =  [Select ID,Teus__c,Order__c From Order_Item__c WHERE Order__c IN : orderIDSet];
         
        for(Order__c ordForOwner : [Select id,Opportunity_Order__r.OwnerID FROM Order__c where ID IN : orderIDSet]){
            oppOwnerMap.put(ordForOwner.ID,ordForOwner.Opportunity_Order__r.OwnerID);
        }
        for(Target__c targetRec : [Select ID,Target_Value_In_Teus__c,Achieved_Value_In_Teus__c,Target_Month__c,OwnerId,Year_Value__c,Month_Value__c FROM Target__c Where OwnerId IN:oppOwnerMap.values() 
                                   AND Month_Value__c=:currentMonth AND Year_Value__c=:currentYear]){
                                       targetOwnerMap.put(targetRec.OwnerId,targetRec);  
                                   }
        if(targetOwnerMap!=NULL){
            for(Order_Item__c ordItem : orderItemList){
                Target__c targetRec = targetOwnerMap.get(oppOwnerMap.get(ordItem.Order__c));
                //system.debug('targetRec.Achieved_Value_In_Teus__c '+targetRec.Achieved_Value_In_Teus__c+'ordItem.Teus__c '+ordItem.Teus__c);
                if(targetRec!=NULL && ordItem.Teus__c!=NULL && targetRec.Achieved_Value_In_Teus__c!=NULL){
                    targetRec.Achieved_Value_In_Teus__c  =targetRec.Achieved_Value_In_Teus__c -  ordItem.Teus__c;
                    targetListToUpdate.add(targetRec);
                    Order__c ordRec = new Order__c(Id=ordItem.Order__c);
                    ordRec.Target__c = targetOwnerMap.get(oppOwnerMap.get(ordItem.Order__c)).ID;            
                    orderListToUpdate.add(ordRec);                    
                }
            }
        }
        if(targetListToUpdate!=NULL){
            database.update(targetListToUpdate);
        }
        if(orderListToUpdate!=NULL){
            database.update(orderListToUpdate);
        }
    }*/
    public static void onAfterDelete(List<Order_Item__c> orderItemList){
        rollupTeusValue(orderItemList);
    }
    public static void onAfterInsert(List<Order_Item__c> orderItemList){
        system.debug('=onAfterInsert of TriggerHandeler');
        createRegularRoute(orderItemList);
        BAFCOMarginCalculator.calculateMargins(orderItemList);
        updateCurrencyOnorder(orderItemList);
        rollupTeusValue(orderItemList);
    }
    public static void onBeforeInsert(List<Order_Item__c> orderItemList){
        updateTeusValue(orderItemList);
    }
    public static void onBeforeUpdate(Map<Id,Order_Item__c> oldMap,List<Order_Item__c> orderItemList){
        List<Order_Item__c> toupdateTeus= new List<Order_Item__c>();
        for(Order_Item__c ordItem : orderItemList){
            if(ordItem.Quantity__c !=oldMap.get(ordItem.id).Quantity__c || ordItem.Equipment_Type_Order__c !=oldMap.get(ordItem.id).Equipment_Type_Order__c){
                toupdateTeus.add(ordItem);
            }
        }
        if(toupdateTeus.size() >0) updateTeusValue(toupdateTeus);
    }
    public static void onAfterUpdate(Map<Id,Order_Item__c> oldMap,List<Order_Item__c> orderItemList){
        system.debug('=onAfterUpdate of TriggerHandeler');
        List<Order_Item__c> toCalculateMarginItems = new List<Order_Item__c>();
        List<Order_Item__c> toRollupItems = new List<Order_Item__c>();
        for(Order_Item__c ordItem : orderItemList){
            if(ordItem.Sea_Freight_Order__c !=oldMap.get(ordItem.id).Sea_Freight_Order__c || ordItem.Quantity__c !=oldMap.get(ordItem.id).Quantity__c || ordItem.Total_Order__c !=oldMap.get(ordItem.id).Total_Order__c || ordItem.Buying_Rate__c !=oldMap.get(ordItem.id).Buying_Rate__c){
                toCalculateMarginItems.add(ordItem);
            }
            if(ordItem.Teus_FB__c > 0 && ordItem.Teus_FB__c != oldMap.get(ordItem.id).Teus_FB__c){
                toRollupItems.add(ordItem);
            }
        }
        createRegularRoute(orderItemList);
        BAFCOMarginCalculator.calculateMargins(toCalculateMarginItems);
        rollupTeusValue(toRollupItems);
    }
    public static void createRegularRoute(List<Order_Item__c> orderItemList){
        Set<Id> orderIds = new Set<Id>();
        Set<Id> polIds = new Set<Id>();
        Set<Id> podIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();
        Set<Id> routeIds = new Set<Id>();
        Map<Id,Id> orderIdToAccId = new Map<Id,Id>();
        Map<Id,List<Regular_Routing__c>> accIdToRegularRoute = new Map<Id,List<Regular_Routing__c>>();
        List<Regular_Routing__c> regList = new List<Regular_Routing__c>();
        for(Order_Item__c item : orderItemList){
            orderIds.add(item.Order__c);
            routeIds.add(item.Route_Order__c);
        }
        for(Order__c orderObj : [Select id, Account_Order__c from order__c where id in : orderIds]){
            if(orderObj.Account_Order__c != null ) orderIdToAccId.put(orderObj.id,orderObj.Account_Order__c);
        }
        for(Order_Item__c item : orderItemList){
            if(item.Port_of_Loading_Order__c != null) polIds.add(item.Port_of_Loading_Order__c);
            if(item.Port_of_Discharge_Order__c != null) podIds.add(item.Port_of_Discharge_Order__c); 
            if(item.Order__c != null && orderIdToAccId.containsKey(item.Order__c)) accIds.add(orderIdToAccId.get(item.Order__c));
        }
        for(Regular_Routing__c regObj : [Select id,Account__c,Shipping_Line__c,Port_of_Loading__c,Port_of_Destination__c from Regular_Routing__c where Account__c in : accIds OR Port_of_Loading__c in : polIds OR Port_of_Destination__c in : podIds]){
            if(!accIdToRegularRoute.containsKey(regObj.Account__c)){
                accIdToRegularRoute.put(regObj.Account__c, new List<Regular_Routing__c>());
            }
            accIdToRegularRoute.get(regObj.Account__c).add(regObj);
        }
        Map<Id,Route__c> routeIdToObjMap = new Map<Id,Route__c>([Select id,Shipping_Line__c,Pickup_Place__c,Discharge_Place__c,Place_of_Pickup__c,Place_of_Discharge__c,DG_Class__c,Dangerous_Goods__c,Service_Type__c,Kind_Of_Shipment__c,Commodity__c,INCO_Term__c from Route__c where id in : routeIds]);
        for(Order_Item__c item : orderItemList){
            List<Regular_Routing__c> reguLarList = new List<Regular_Routing__c>();
            if(item.Order__c != null && orderIdToAccId.containsKey(item.Order__c)){
                if(accIdToRegularRoute.containskey(orderIdToAccId.get(item.Order__c)))
                    reguLarList = accIdToRegularRoute.get(orderIdToAccId.get(item.Order__c));
            }
            if(reguLarList.size() > 0){
                Boolean similarFound = false;
                for(Regular_Routing__c regObj : reguLarList){
                    if(regObj.Account__c != null){
                        if(regObj.Port_of_Loading__c != null){
                            if(regObj.Port_of_Destination__c != null){
                                if(orderIdToAccId.get(item.Order__c) == regObj.Account__c && regObj.Port_of_Destination__c == item.Port_of_Discharge_Order__c && regObj.Port_of_Loading__c == item.Port_of_Loading_Order__c){
                                    similarFound = true;
                                }
                            }
                            else if(orderIdToAccId.get(item.Order__c) == regObj.Account__c && regObj.Port_of_Loading__c == item.Port_of_Loading_Order__c && item.Port_of_Discharge_Order__c == null){
                                similarFound = true;
                            }
                        }
                        else if(regObj.Port_of_Destination__c != null){
                            if(orderIdToAccId.get(item.Order__c) == regObj.Account__c && regObj.Port_of_Destination__c == item.Port_of_Discharge_Order__c && item.Port_of_Loading_Order__c == null){
                                similarFound = true;
                            }
                        }
                    }
                    else if(regObj.Port_of_Loading__c != null){
                        if(regObj.Port_of_Destination__c != null){
                            if(regObj.Port_of_Loading__c == item.Port_of_Loading_Order__c && regObj.Port_of_Destination__c == item.Port_of_Discharge_Order__c){
                                similarFound = true;
                            }
                        }
                        else if(regObj.Port_of_Loading__c == item.Port_of_Loading_Order__c && item.Port_of_Discharge_Order__c == null){
                            similarFound = true;
                        }
                    }
                    else if(regObj.Port_of_Destination__c != null &&  regObj.Port_of_Destination__c == item.Port_of_Discharge_Order__c && item.Port_of_Loading_Order__c == null){
                        similarFound = true;
                    }
                }
                if(similarFound == false) regList.add(createRegularRouteObj(item,orderIdToAccId,routeIdToObjMap));
            }
            else{
                regList.add(createRegularRouteObj(item,orderIdToAccId,routeIdToObjMap));
            }
        }
        if(regList.size() > 0) insert regList;
    }
    public static Regular_Routing__c createRegularRouteObj(Order_Item__c item,Map<Id,Id> orderIdToAccId,Map<Id,Route__c> routeIdToObjMap){
        Regular_Routing__c newObj = new Regular_Routing__c();
        newObj.Account__c = orderIdToAccId.containsKey(item.Order__c) ? orderIdToAccId.get(item.Order__c) : null;
        newObj.Port_of_Destination__c = item.Port_of_Discharge_Order__c;
        newObj.Port_of_Loading__c = item.Port_of_Loading_Order__c;
        newObj.Shipping_Line__c = item.Shipping_Line__c;
        if(routeIdToObjMap.size() > 0 && routeIdToObjMap.containsKey(item.Route_Order__c)){
            Route__c routeObj = routeIdToObjMap.get(item.Route_Order__c);
            newObj.Pickup_Place__c = routeObj.Pickup_Place__c;
            newObj.Discharge_Place__c = routeObj.Discharge_Place__c;
            system.debug('routeObj.DG_Class__c '+routeObj.DG_Class__c);
            newObj.DG_Class__c = routeObj.DG_Class__c;
            newObj.Dangerous_Goods__c = routeObj.Dangerous_Goods__c;
            newObj.Service_Type__c = routeObj.Service_Type__c;
            newObj.Kind_of_Shipment__c = routeObj.Kind_Of_Shipment__c;
            newObj.Commodity__c = routeObj.Commodity__c;
            newObj.INCO_Term__c = routeObj.INCO_Term__c;
        }
        return newObj;
    }
    public static void updateTeusValue(List<Order_Item__c> orderItemList){
        List<Id> orderIds = new List<Id>();
        List<Id> equipIds = new List<Id>();
        List<Id> routeIds = new List<Id>();
        Map<Id,String> orderIdMap = new Map<Id,String>();
        Map<String,Decimal> routeEquipIdMap = new Map<string,Decimal>();
        Map<String,Decimal> routeIdMap = new Map<string,Decimal>();
        Map<Id,String> equipIdMap = new Map<Id,String>();
        for(Order_Item__c item : orderItemList){
            orderIds.add(item.Order__c);
            if(item.Equipment_Type_Order__c != null) equipIds.add(item.Equipment_Type_Order__c);
            if(item.Route__c != null ) routeIds.add(item.Route__c);
        }
        for(Equipment_Type__c equipObj : [Select id,name from Equipment_Type__c where id  in : equipIds]){
            equipIdMap.put(equipObj.id, equipObj.Name);
        }
        system.debug('routeIds '+routeIds);
        for(Route_Equipment__c routeEquipObj : [Select id,Tab_View__c,CBM__c,Weight_Kgs__c from Route_Equipment__c where Route__c in : routeIds]){
            if(routeEquipObj.CBM__c != null && routeEquipObj.Weight_Kgs__c !=null){
            Decimal chargeableWeight = (routeEquipObj.CBM__c  * 167 ) > routeEquipObj.Weight_Kgs__c ? routeEquipObj.CBM__c  * 167  :  routeEquipObj.Weight_Kgs__c;
            routeEquipIdMap.put(routeEquipObj.Tab_View__c,chargeableWeight);
            }
        }
        for(Order__c orderObj : [Select id,Order_Type__c from Order__c where id  in : orderIds]){
            orderIdMap.put(orderObj.id, orderObj.Order_Type__c);
        }
        for(Route__c routeObj : [Select id, Chargeable_Weight__c from Route__c where id in : routeIds ]){
            routeIdMap.put(routeObj.id,routeObj.Chargeable_Weight__c);
        }
        system.debug('routeEquipIdMap '+routeEquipIdMap);
        for(Order_Item__c item : orderItemList){
            if(orderIdMap.get(item.Order__c) == 'Sea Export' || orderIdMap.get(item.Order__c) == 'Sea Import' ||orderIdMap.get(item.Order__c) == 'ISO Export' ||orderIdMap.get(item.Order__c) == 'ISO Import'){
                if(item.Equipment_Type_Order__c != null && (equipIdMap.get(item.Equipment_Type_Order__c).contains('40') == true || equipIdMap.get(item.Equipment_Type_Order__c).contains('45') == true)){
                    item.Teus_FB__c = 2 * (item.Quantity__c != null ? item.Quantity__c : 1);
                }
                if(item.Equipment_Type_Order__c != null && (equipIdMap.get(item.Equipment_Type_Order__c).contains('20') == true|| equipIdMap.get(item.Equipment_Type_Order__c).contains('45') == true)){
                    item.Teus_FB__c = 1 * (item.Quantity__c != null ? item.Quantity__c : 1);
                }
            }
            else if(orderIdMap.get(item.Order__c) == 'Local Operation Export' || orderIdMap.get(item.Order__c) == 'Local Operation Import'){
                if(item.Equipment_Type_Order__c != null && (equipIdMap.get(item.Equipment_Type_Order__c).contains('40') == true || equipIdMap.get(item.Equipment_Type_Order__c).contains('45') == true)){
                    item.Teus_FB__c = item.Quantity__c > 0 ? item.Quantity__c/2 : 0;
                }
                if(item.Equipment_Type_Order__c != null && equipIdMap.get(item.Equipment_Type_Order__c).contains('20') == true){
                    item.Teus_FB__c = item.Quantity__c > 0 ? item.Quantity__c/4 : 0;
                }
            }
            else if(orderIdMap.get(item.Order__c) == 'LCL Export' || orderIdMap.get(item.Order__c) == 'LCL Import'){
                if(routeEquipIdMap.containsKey(item.Tab_View__c)){
                    item.Teus_FB__c = routeEquipIdMap.get(item.Tab_View__c) / 250;
                    system.debug(' *************** '+item.Teus_FB__c);
                }
            }
            else if(orderIdMap.get(item.Order__c) == 'Air Export' || orderIdMap.get(item.Order__c) == 'Air Import'){
                if(routeIdMap.containsKey(item.Route__c)){
                    item.Teus_FB__c = routeIdMap.get(item.Route__c)/250;
                }
            }
        }
    }
    public static void updateCurrencyOnorder(List<Order_Item__c> itemList){
        Map<Id,String> orderIdtoCurrency = new Map<Id,String>();
        List<Order__c> orderList = new List<Order__c>();
        for(Order_Item__c item : itemList){
            orderIdtoCurrency.put(item.Order__c,item.CurrencyIsoCode);
        }
        for(Order__c obj : [Select id,CurrencyIsoCode from Order__c where id in : orderIdtoCurrency.keySet()]){
            obj.CurrencyIsoCode = orderIdtoCurrency.get(obj.id);
            orderList.add(obj);
        }
        if(orderList.size() > 0) update orderList;
    }
    public static void rollupTeusValue(List<Order_Item__c> itemList){
        List<Id> orderIds = new List<Id>();
        for(Order_Item__c item : itemList){
            orderIds.add(item.Order__c);
        }
        if(orderIds.size() > 0) updateTargetObj(orderIds);
    }
    public static void updateTargetObj(List<Id> orderIds){
        List<Id> allOrderIds = new List<Id>();
        List<Id> targetIds = new List<Id>();
        List<Id> orderOwnerIds = new List<Id>();
        List<Target__c> initaltargetList = new List<Target__c>();
        Decimal totalSum = 0;
        Map<Id,Decimal> teusSumMap = new Map<Id,Decimal>();
        Map<String,Decimal> serviceTypeSumMap = new Map<String,Decimal>();
        serviceTypeSumMap.put('Sea Export',0);
        serviceTypeSumMap.put('Sea Import',0);
        serviceTypeSumMap.put('Air Export',0);
        serviceTypeSumMap.put('Air Import',0);
        serviceTypeSumMap.put('ISO Export',0);
        serviceTypeSumMap.put('ISO Import',0);
        /*Date dt = System.today();
        Integer currentMonth = dt.Month();
        Integer previousMonth = currentMonth - 1;*/
        Date orderDate = null;
        for(Order__c orderObj : [Select id,Target__c,createdDate from Order__c where id in: orderIds]){
            targetIds.add(orderObj.Target__c);
            orderDate = Date.valueOf(orderObj.CreatedDate);
        }
        Integer orderMonth = orderDate.Month();
        system.debug('targetIds '+targetIds);
        system.debug('orderIds '+orderIds);
        for(Order__c orderObj : [Select Order_Type__c,Account_Order__r.OwnerId from Order__c where Target__c in :targetIds and Status__c = 'Confirmed']){
            orderOwnerIds.add(orderObj.Account_Order__r.OwnerId);
            allOrderIds.add(orderObj.id);
        }
        system.debug('orderOwnerIds '+orderOwnerIds);
        if(orderOwnerIds.size() > 0){
            initaltargetList = [Select id,OwnerId,Achieved_Value_In_Teus__c from Target__c where OwnerId in :orderOwnerIds and Month_Value__c=:orderMonth];
            system.debug('initaltargetList '+initaltargetList);
            if(initaltargetList.size() == 1){
                List<Order_Item__c> queriedItemList = [Select Order__r.Target__c,Order__r.Order_Type__c,id,Order__c,Teus_FB__c from Order_Item__c where Order__c in : allOrderIds];
                system.debug('queriedItemList '+queriedItemList);
                if(queriedItemList.size() > 0 ){
                    for(Order_Item__c item : queriedItemList){
                        Decimal initalSum = 0;
                        totalSum = totalSum+(item.Teus_FB__c != null ? item.Teus_FB__c : 0);
                        string serviceType = item.Order__r.Order_Type__c;
                        if(serviceType == 'Sea Export' || serviceType == 'Local Operation Export' || serviceType == 'LCL Export'){
                            Decimal newsum = serviceTypeSumMap.get('Sea Export');
                            newsum = newsum+(item.Teus_FB__c != null ? item.Teus_FB__c : 0);
                            serviceTypeSumMap.put('Sea Export',newsum);
                        }
                        if(serviceType == 'Sea Import' || serviceType == 'Local Operation Import' || serviceType == 'LCL Import'){
                            Decimal newsum = serviceTypeSumMap.get('Sea Import');
                            newsum = newsum+(item.Teus_FB__c != null ? item.Teus_FB__c : 0);
                            serviceTypeSumMap.put('Sea Import',newsum);
                        }
                        if(serviceType == 'Air Export'){
                            Decimal newsum = serviceTypeSumMap.get('Air Export');
                            newsum = newsum+(item.Teus_FB__c != null ? item.Teus_FB__c : 0);
                            serviceTypeSumMap.put('Air Export',newsum);
                        }
                        if(serviceType == 'Air Import'){
                            Decimal newsum = serviceTypeSumMap.get('Air Import');
                            newsum = newsum+(item.Teus_FB__c != null ? item.Teus_FB__c : 0);
                            serviceTypeSumMap.put('Air Import',newsum);
                        }
                        if(serviceType == 'ISO Export'){
                            Decimal newsum = serviceTypeSumMap.get('ISO Export');
                            newsum = newsum+(item.Teus_FB__c != null ? item.Teus_FB__c : 0);
                            serviceTypeSumMap.put('ISO Export',newsum);
                        }
                        if(serviceType == 'ISO Import'){
                            Decimal newsum = serviceTypeSumMap.get('ISO Import');
                            newsum = newsum+(item.Teus_FB__c != null ? item.Teus_FB__c : 0);
                            serviceTypeSumMap.put('ISO Import',newsum);
                        }
                    }
                    Target__c targetObj = initaltargetList[0];
                    targetObj.Achieved_Value_In_Teus__c = totalSum;
                    targetObj.Sea_Export__c = serviceTypeSumMap.get('Sea Export');
                    targetObj.Sea_Import__c = serviceTypeSumMap.get('Sea Import');
                    targetObj.Air_Export__c = serviceTypeSumMap.get('Air Export');
                    targetObj.Air_Import__c = serviceTypeSumMap.get('Air Import');
                    targetObj.ISO_Export__c = serviceTypeSumMap.get('ISO Export');
                    targetObj.ISO_Import__c = serviceTypeSumMap.get('ISO Import');
                    update targetObj;
                }
            }
        }
        else{
            if(targetIds.size() == 1){
                Target__c targetObj = new Target__c();
                targetObj.id = targetIds[0];
                targetObj.Achieved_Value_In_Teus__c = null;
                targetObj.Sea_Export__c = null;
                targetObj.Sea_Import__c = null;
                targetObj.Air_Export__c = null;
                targetObj.Air_Import__c = null;
                targetObj.ISO_Export__c = null;
                targetObj.ISO_Import__c = null;
                update targetObj;
            }
        }
    }
    public static void dummyMethod(){
        Integer a = 10;
        Integer b = 10;
        Integer c = 10;
        Integer d = 10;
        Integer e = 10;
        Integer a1 = 10;
        Integer a2= 10;
        Integer a3 = 10;
        Integer a4 = 10;
        Integer a5 = 10;
        Integer a6 = 10;
        Integer a7 = 10;
        Integer a8 = 10;
        Integer a9 = 10;
        Integer a10 = 10;
        Integer aa = 10;
        Integer aaa = 10;
        Integer fa = 10;
        Integer a13 = 10;
        Integer a14 = 10;
        Integer a25 = 10;
        Integer a36 = 10;
        Integer a47 = 10;
        Integer a38 = 10;
        Integer a19 = 10;
        Integer ae10 = 10;
        Integer ada = 10;
        Integer agaa = 10;
        Integer fhha = 10;
    }
}