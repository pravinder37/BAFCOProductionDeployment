public class QuotationItemTriggerHandler {
    public static void updateChargesIncluded(List<Quotation_Item__c> quoteItemList){
        for(Quotation_Item__c quote:quoteItemList){
            String chargesIncluded = '';
            //Shipping Line Charges Computation
            if(quote.BAF__c!=0.0 && quote.BAF__c!=NULL){
                chargesIncluded +='BAF : '+quote.BAF__c + quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Bunker_surcharge__c!=0.0 && quote.Bunker_surcharge__c!=NULL){
                chargesIncluded +='Bunker surcharge : '+quote.Bunker_surcharge__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Cleaning_charges__c!=0.0 && quote.Cleaning_charges__c	!=NULL){
                chargesIncluded +='Cleaning Charges : '+quote.Cleaning_charges__c	 +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.CMC__c!=0.0 && quote.CMC__c!=null){
                chargesIncluded +='Container Maintenance Charge : '+quote.CMC__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Carriage_Congestion_Surcharge__c!=0.0 && quote.Carriage_Congestion_Surcharge__c!=NULL){
                chargesIncluded +='Carriage Congestion Surcharge : '+quote.Carriage_Congestion_Surcharge__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Carrier_Security_Fees__c	!=0.0 && quote.Carrier_Security_Fees__c	!=NULL){
                chargesIncluded +='Carrier Security Fees : '+quote.Carrier_Security_Fees__c	 +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.DG_Surcharge__c!=0.0 && quote.DG_Surcharge__c!=NULL){
                chargesIncluded +='DG Surcharge : '+quote.DG_Surcharge__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.DTHC__c!=0.0 && quote.DTHC__c!=NULL){
                chargesIncluded +='DTHC : '+quote.DTHC__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.EIC__c!=0.0 && quote.EIC__c!=NULL){
                chargesIncluded +='Equipment Imbalance Charge : '+quote.EIC__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Inland_Fuel_Surcharge__c!=0.0 && quote.Inland_Fuel_Surcharge__c!=NULL){
                chargesIncluded +='Inland Fuel Surcharge : '+quote.Inland_Fuel_Surcharge__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Inland_Handling_Fees__c!=0.0 && quote.Inland_Handling_Fees__c!=NULL){
                chargesIncluded +='Inland Handling Fees : '+quote.Inland_Handling_Fees__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Inland_haulage__c!=0.0 && quote.Inland_haulage__c!=NULL){
                chargesIncluded +='Inland haulage : '+quote.Inland_haulage__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.ISPS__c!=0.0 && quote.ISPS__c!=NULL){
                chargesIncluded +='ISPS : '+quote.ISPS__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Low_Sulphur_Surcharge__c!=0.0 && quote.Low_Sulphur_Surcharge__c!=NULL){
                chargesIncluded +='Low Sulphur Surcharge : '+quote.Low_Sulphur_Surcharge__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Operational_Recovery_Surcharge__c!=0.0 && quote.Operational_Recovery_Surcharge__c!=NULL){
                chargesIncluded +='Operational Recovery Surcharge : '+quote.Operational_Recovery_Surcharge__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.OTHC__c!=0.0 && quote.OTHC__c!=NULL){
                chargesIncluded +='OTHC : '+quote.OTHC__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Overweight_surcharge__c!=0.0 && quote.Overweight_surcharge__c!=NULL){
                chargesIncluded +='Overweight/Overheight surcharge : '+quote.Overweight_surcharge__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Seal_Charges__c!=0.0 && quote.Seal_Charges__c!=NULL){
                chargesIncluded +='Seal Charges : '+quote.Seal_Charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.War_Risk_Surcharge__c!=0.0 && quote.War_Risk_Surcharge__c!=NULL){
                chargesIncluded +='War Risk Surcharge : '+quote.War_Risk_Surcharge__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            
            //Origin Charges Computation
            if(quote.BAF__c!=0.0 && quote.BAF__c!=NULL){
                chargesIncluded +='BAF : '+quote.BAF__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.BL_Fees__c!=0.0 && quote.BL_Fees__c!=NULL){
                chargesIncluded +='BL Fees : '+quote.BL_Fees__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Origin_Customs_clearance__c!=0.0 && quote.Origin_Customs_clearance__c!=NULL){
                chargesIncluded +='Origin Customs clearance : '+quote.Origin_Customs_clearance__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Export_Service_Fees__c!=0.0 && quote.Export_Service_Fees__c!=NULL){
                chargesIncluded +='Export Service Fees : '+quote.Export_Service_Fees__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Fasah_fee__c!=0.0 && quote.Fasah_fee__c!=NULL){
                chargesIncluded +='Fasah Fee : '+quote.Fasah_fee__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Fuel_Surcharge__c	!=0.0 && quote.Fuel_Surcharge__c	!=NULL){
                chargesIncluded +='Fuel Surcharge : '+quote.Fuel_Surcharge__c	 +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Inspection__c!=0.0 && quote.Inspection__c!=NULL){
                chargesIncluded +='Inspection : '+quote.Inspection__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Insurance_charges__c!=0.0 && quote.Insurance_charges__c!=NULL){
                chargesIncluded +='Insurance charges : '+quote.Insurance_charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Lashing_Charges__c!=0.0 && quote.Lashing_Charges__c!=NULL){
                chargesIncluded +='Lashing Charges : '+quote.Lashing_Charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Lift_on_Lift_off__c!=0.0 && quote.Lift_on_Lift_off__c!=NULL){
                chargesIncluded +='Lift on-Lift off : '+quote.Lift_on_Lift_off__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Origin_Detention_Demurrage_Charges__c!=0.0 && quote.Origin_Detention_Demurrage_Charges__c!=NULL){
                chargesIncluded +='Origin Detention/Demurrage Charges : '+quote.Origin_Detention_Demurrage_Charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Origin_Loading_Charges__c!=0.0 && quote.Origin_Loading_Charges__c!=NULL){
                chargesIncluded +='Origin Loading Charges (Dock Stuffing) : '+quote.Origin_Loading_Charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Pickup_Charges__c!=0.0 && quote.Pickup_Charges__c!=NULL){
                chargesIncluded +='Pickup Charges(Transportation) : '+quote.Pickup_Charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Reefer_cntr_plug_in_charges__c!=0.0 && quote.Reefer_cntr_plug_in_charges__c!=NULL){
                chargesIncluded +='Reefer Plugin Charges : '+quote.Reefer_cntr_plug_in_charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Tabadul__c!=0.0 && quote.Tabadul__c!=NULL){
                chargesIncluded +='Tabadul : '+quote.Tabadul__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Tarpauline_charge__c!=0.0 && quote.Tarpauline_charge__c!=NULL){
                chargesIncluded +='Tarpauline charge : '+quote.Tarpauline_charge__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Truck_idling_charges__c!=0.0 && quote.Truck_idling_charges__c!=NULL){
                chargesIncluded +='Truck idling charges : '+quote.Truck_idling_charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.VGM__c!=0.0 && quote.VGM__c!=NULL){
                chargesIncluded +='VGM : '+quote.VGM__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Xray__c!=0.0 && quote.Xray__c!=NULL){
                chargesIncluded +='Xray : '+quote.Xray__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            
            //Destination Charges Computation
            if(quote.Bayan_Charges__c!=0.0 && quote.Bayan_Charges__c!=NULL){
                chargesIncluded +='Bayan Charges : '+quote.Bayan_Charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Destination_Customs_Clearance__c!=0.0 && quote.Destination_Customs_Clearance__c!=NULL){
                chargesIncluded +='Destination Customs Clearance : '+quote.Destination_Customs_Clearance__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Destination_Loading_Charges__c!=0.0 && quote.Destination_Loading_Charges__c!=NULL){
                chargesIncluded +='Destination Loading Charges : '+quote.Destination_Loading_Charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.DO_charges__c!=0.0 && quote.DO_charges__c!=NULL){
                chargesIncluded +='DO charges : '+quote.DO_charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Fasah_Charges__c!=0.0 && quote.Fasah_Charges__c!=NULL){
                chargesIncluded +='Fasah Charges : '+quote.Fasah_Charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Gate_pass_charges__c	!=0.0 && quote.Gate_pass_charges__c	!=NULL){
                chargesIncluded +='Gate pass charges : '+quote.Gate_pass_charges__c	 +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.LOLO_Charges__c!=0.0 && quote.LOLO_Charges__c!=NULL){
                chargesIncluded +='LOLO Charges : '+quote.LOLO_Charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            
            //Additional Charges Computation
            if(quote.Bayan_cancellation_charge__c!=0.0 && quote.Bayan_cancellation_charge__c!=NULL){
                chargesIncluded +='Bayan cancellation charge : '+quote.Bayan_cancellation_charge__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            /*if(quote.Container_Lashing_Charges__c!=0.0 && quote.Container_Lashing_Charges__c!=NULL){
chargesIncluded +='Container Lashing Charges : '+quote.Container_Lashing_Charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
}*/
            if(quote.Container_movement_charges__c!=0.0 && quote.Container_movement_charges__c!=NULL){
                chargesIncluded +='Container movement charges : '+quote.Container_movement_charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Container_stripping__c!=0.0 && quote.Container_stripping__c!=NULL){
                chargesIncluded +='Container stripping : '+quote.Container_stripping__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Free_time_certificate_charges__c!=0.0 && quote.Free_time_certificate_charges__c!=NULL){
                chargesIncluded +='Free time certificate charges : '+quote.Free_time_certificate_charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Fumigation__c!=0.0 && quote.Fumigation__c!=NULL){
                chargesIncluded +='Fumigation : '+quote.Fumigation__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Ministry_clearnce_charge_for_OOG_cargo__c!=0.0 && quote.Ministry_clearnce_charge_for_OOG_cargo__c!=NULL){
                chargesIncluded +='Ministry clearnce charge for OOG cargo : '+quote.Ministry_clearnce_charge_for_OOG_cargo__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Miscellaneous__c!=0.0 && quote.Miscellaneous__c!=NULL){
                chargesIncluded +='Miscellaneous : '+quote.Miscellaneous__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.MOT_fine_charges__c!=0.0 && quote.MOT_fine_charges__c!=NULL){
                chargesIncluded +='MOT fine charges : '+quote.MOT_fine_charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Non_Palletized_Surcharge__c!=0.0 && quote.Non_Palletized_Surcharge__c!=NULL){
                chargesIncluded +='Non Palletized Surcharge : '+quote.Non_Palletized_Surcharge__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Pest_control__c!=0.0 && quote.Pest_control__c!=NULL){
                chargesIncluded +='Pest control : '+quote.Pest_control__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Reefer_PTI_charges__c!=0.0 && quote.Reefer_PTI_charges__c!=NULL){
                chargesIncluded +='Reefer PTI charges : '+quote.Reefer_PTI_charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Reefer_steam_wash__c!=0.0 && quote.Reefer_steam_wash__c!=NULL){
                chargesIncluded +='Reefer steam wash : '+quote.Reefer_steam_wash__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Re_palletization__c!=0.0 && quote.Re_palletization__c!=NULL){
                chargesIncluded +='Re palletization : '+quote.Re_palletization__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Stuffing_Charges__c!=0.0 && quote.Stuffing_Charges__c!=NULL){
                chargesIncluded +='Stuffing Charges : '+quote.Stuffing_Charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.SweepingCleaning__c!=0.0 && quote.SweepingCleaning__c!=NULL){
                chargesIncluded +='Sweeping/Cleaning : '+quote.SweepingCleaning__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Truck_Head_charges__c!=0.0 && quote.Truck_Head_charges__c!=NULL){
                chargesIncluded +='Truck Head charges : '+quote.Truck_Head_charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Vessel_certificate_charges__c	!=0.0 && quote.Vessel_certificate_charges__c	!=NULL){
                chargesIncluded +='Vessel certificate charges : '+quote.Vessel_certificate_charges__c	 +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Wrappingpacking_charges__c!=0.0 && quote.Wrappingpacking_charges__c!=NULL){
                chargesIncluded +='Wrapping/packing charges : '+quote.Wrappingpacking_charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Alternate_depot_release_charges__c!=0.0 && quote.Alternate_depot_release_charges__c!=NULL){
                chargesIncluded +='Alternate Depot Release Charges : '+quote.Alternate_depot_release_charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Freight_Difference_FD__c!=0.0 && quote.Freight_Difference_FD__c!=NULL){
                chargesIncluded +='Freight Difference (FD) : '+quote.Freight_Difference_FD__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Carrier_container_repositioning_charges__c!=0.0 && quote.Carrier_container_repositioning_charges__c!=NULL){
                chargesIncluded +='Carrier container repositioning charges : '+quote.Carrier_container_repositioning_charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Tank_Rental_Charges__c!=0.0 && quote.Tank_Rental_Charges__c!=NULL){
                chargesIncluded +='Tank Rental Charges : '+quote.Tank_Rental_Charges__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            
            //Ex Works Charges Computation
            /*if(quote.Place_of_Pickup__c!=0.0 && quote.Place_of_Pickup__c!=NULL){
chargesIncluded +='Place of Pickup : '+quote.Place_of_Pickup__c +' '+ quote.Place_of_Pickup__c + '\r\n';
}
if(quote.Place_of_Discharge__c!=0.0 && quote.Place_of_Discharge__c!=NULL){
chargesIncluded +='Place of Discharge : '+quote.Place_of_Discharge__c +' '+ quote.CurrencyIsoCode + '\r\n';
}*/
            if(quote.Ex_Works_Charge__c!=0.0 && quote.Ex_Works_Charge__c!=NULL){
                chargesIncluded +='Ex Works Charge : '+quote.Ex_Works_Charge__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            
            //Total Values Charges Computation
            if(quote.Total_Dest__c!=0.0 && quote.Total_Dest__c!=NULL){
                chargesIncluded +='Total Destination: '+quote.Total_Dest__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Total_INCO__c!=0.0 && quote.Total_INCO__c!=NULL){
                chargesIncluded +='Total Origin : '+quote.Total_INCO__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Total_SL__c	!=0.0 && quote.Total_SL__c	!=NULL){
                chargesIncluded +='Total SL : '+quote.Total_SL__c	 +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            if(quote.Total_Additional__c!=0.0 && quote.Total_Additional__c!=NULL){
                chargesIncluded +='Total Additional : '+quote.Total_Additional__c +' '+ quote.CurrencyIsoCode + '\r\n';
            }
            
            quote.Charges_Included__c = chargesIncluded;
            system.debug('chargesIncluded'+chargesIncluded);
            
        }
        
    }
    public static void onBeforeUpdate(Map<Id,Quotation_Item__c> oldMap , List<Quotation_Item__c> quoteItemList){
        List<Quotation_Item__c> newItemList = new List<Quotation_Item__c>();
        for(Quotation_Item__c item  : quoteItemList){
            if(item.Quantity__c != oldMap.get(item.id).Quantity__c || item.Equipment_Type__c != oldMap.get(item.id).Equipment_Type__c){
                newItemList.add(item);
            }
        }
        if(newItemList.size() > 0) updateTeusValue(newItemList);
    }
    public static void afterUpdate(Map<Id,Quotation_Item__c> oldMap , List<Quotation_Item__c> quoteItemList){
        List<Quotation_Item__c> newItemList = new List<Quotation_Item__c>();
        for(Quotation_Item__c item : quoteItemList){
            if(item.Total__c != oldMap.get(item.id).Total__c) newItemList.add(item);
        }
        if(newItemList.size() > 0) updateQuotationDetails(newItemList);
    }
    public static void updateQuotationDetails(List<Quotation_Item__c> quoteItemList){
        List<Quotation__c> quoteList = new List<Quotation__c>();
        set<Id> routeId = new set<Id>();
        set<Id> quoteId = new set<Id>();
        for(Quotation_Item__c item : quoteItemList){
            if(item.Route__c != null) routeId.add(item.Route__c);
            if(item.Quotation__c != null) quoteId.add(item.Quotation__c);
        }
        if(quoteId.size()>0){
            Map<Id,String> quoteIdToDetails = new Map<Id,String>();
            for(Quotation_Item__c item : [Select id,Shipping_Linee__r.name,Equipment_Type__r.name,Quotation__c,Route__r.name,Total__c from Quotation_Item__c where Quotation__c in :quoteId ]){
                if(item.Route__c != null){
                    String details = '';
                    if(!quoteIdToDetails.containsKey(item.Quotation__c)){
                        details = item.Route__r.Name+' - '+item.Equipment_Type__r.name;
                        if(item.Shipping_Linee__c != null){
                            details += ' - '+item.Shipping_Linee__r.name+' - '+item.Total__c; 
                        }else{
                            details += ' - '+item.Total__c;
                        }
                    }
                    else{
                        details = quoteIdToDetails.get(item.Quotation__c);
                        details += '\n'+item.Route__r.Name+' - '+item.Equipment_Type__r.name;
                        if(item.Shipping_Linee__c != null){
                            details += ' - '+item.Shipping_Linee__r.name+' - '+item.Total__c; 
                        }else{
                            details += ' - '+item.Total__c;
                        }
                    }
                    quoteIdToDetails.put(item.Quotation__c,details);
                }
            }
            for(Quotation__c obj : [Select id,Details__c from Quotation__c where id in : quoteId]){
                Quotation__c o =new Quotation__c();
                o.id = obj.id;
                o.Details__c = quoteIdToDetails.get(obj.id);
                quoteList.add(o);
            }
            update quoteList;
        }
    }
    public static void updateTeusValue(List<Quotation_Item__c> quoteItemList){
        List<Id> quoteIds = new List<Id>();
        List<Id> equipIds = new List<Id>();
        List<Id> routeIds = new List<Id>();
        Map<Id,String> quoteIdMap = new Map<Id,String>();
        Map<String,Decimal> routeEquipIdMap = new Map<string,Decimal>();
        Map<String,Decimal> routeIdMap = new Map<string,Decimal>();
        Map<Id,String> equipIdMap = new Map<Id,String>();
        for(Quotation_Item__c item : quoteItemList){
            quoteIds.add(item.Quotation__c);
            if(item.Equipment_Type__c != null) equipIds.add(item.Equipment_Type__c);
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
        for(Quotation__c quoteObj : [Select id,Quotation_Type__c from Quotation__c where id  in : quoteIds]){
            quoteIdMap.put(quoteObj.id, quoteObj.Quotation_Type__c );
        }
        for(Route__c routeObj : [Select id, Chargeable_Weight__c from Route__c where id in : routeIds ]){
            routeIdMap.put(routeObj.id,routeObj.Chargeable_Weight__c);
        }
        for(Quotation_Item__c item : quoteItemList){
            if(quoteIdMap.get(item.Quotation__c) == 'Sea Export' || quoteIdMap.get(item.Quotation__c) == 'Sea Import' ||quoteIdMap.get(item.Quotation__c) == 'ISO Export' ||quoteIdMap.get(item.Quotation__c) == 'ISO Import'){
                if(item.Equipment_Type__c != null && equipIdMap.get(item.Equipment_Type__c).contains('40') == true){
                    item.Teusnew__c = 2 * (item.Quantity__c != null ? item.Quantity__c : 1);
                }
                if(item.Equipment_Type__c != null && equipIdMap.get(item.Equipment_Type__c).contains('20') == true){
                    item.Teusnew__c = 1 * (item.Quantity__c != null ? item.Quantity__c : 1);
                }
                if(item.Equipment_Type__c != null && equipIdMap.get(item.Equipment_Type__c).contains('45') == true){
                    item.Teusnew__c = 2 * (item.Quantity__c != null ? item.Quantity__c : 1);
                }
            }
            else if(quoteIdMap.get(item.Quotation__c) == 'Local Operation Export' || quoteIdMap.get(item.Quotation__c) == 'Local Operation Import'){
                if(item.Equipment_Type__c != null && equipIdMap.get(item.Equipment_Type__c).contains('40') == true){
                    item.Teusnew__c = item.Quantity__c != null ? item.Quantity__c/2 : 0;
                }
                if(item.Equipment_Type__c != null && equipIdMap.get(item.Equipment_Type__c).contains('20') == true){
                    item.Teusnew__c = item.Quantity__c != null ? item.Quantity__c/4 : 0;
                }
                if(item.Equipment_Type__c != null && equipIdMap.get(item.Equipment_Type__c).contains('45') == true){
                    item.Teusnew__c = 2 * (item.Quantity__c != null ? item.Quantity__c : 1);
                }
            }
            else if(quoteIdMap.get(item.Quotation__c) == 'LCL Export' || quoteIdMap.get(item.Quotation__c) == 'LCL Import'){
                if(routeEquipIdMap.containsKey(item.Tab_View__c)){
                    item.Teusnew__c = routeEquipIdMap.get(item.Tab_View__c) / 250;
                }
            }
            else if(quoteIdMap.get(item.Quotation__c) == 'Air Export' || quoteIdMap.get(item.Quotation__c) == 'Air Import'){
                if(routeIdMap.containsKey(item.Route__c)){
                    item.Teusnew__c = routeIdMap.get(item.Route__c)/250;
                }
            }
        }
    }
}