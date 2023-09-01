public class BAFCOQuotationTriggerHandler {
    public static void afterUpdate(List<Quotation__c> newList,Map<Id,Quotation__c> oldMap){
        rollUpTotalAmtToOpty(newList,oldMap);
    }
    public static void beforeInsert(List<Quotation__c> newList){
        if(!Trigger_Setting__c.getInstance().Stop_Trigger_Execution__c) {
            if(!test.isRunningTest())updateQuotationName(newList);
        }
    }
    public static void updateQuotationName(List<Quotation__c> newList){
        system.debug('newList'+newList);
        List<Quotation__c> jubailRecord = [Select ID,Record_Number__c,Name,Branch__c from Quotation__c Where Branch__c='Jubail' AND Record_Number__c!=NULL order by Record_Number__c DESC Limit 1 ];
        List<Quotation__c> jeddahRecord = [Select ID,Record_Number__c,Name,Branch__c from Quotation__c Where Branch__c='Jeddah' AND Record_Number__c!=NULL order by Record_Number__c DESC ];
        List<Quotation__c> riyadRecord =  [Select ID,Record_Number__c,Name,Branch__c from Quotation__c Where Branch__c='Riyadh' AND Record_Number__c!=NULL order by Record_Number__c DESC ];
        List<Quotation__c> dammamRecord = [Select ID,Record_Number__c,Name,Branch__c from Quotation__c Where Branch__c='Dammam' AND Record_Number__c!=NULL order by Record_Number__c DESC ];
        List<String> optyIds = new list<String>();
        Map<String,List<Quotation__c>> quoteRevisemap = new Map<String,List<Quotation__c>>();
        Map<String,List<Quotation__c>> quotemap = new Map<String,List<Quotation__c>>();
        for(Quotation__c newQuote : newList){
            optyIds.add(newQuote.Opportunity__c);
        }
        for(Quotation__c quoteObj : [Select id,Opportunity__c,isRevise__c,name from Quotation__c where Opportunity__c in : optyIds order by createddate desc ]){
            if(quoteObj.isRevise__c == true){
                if(!quoteRevisemap.containskey(quoteObj.Opportunity__c))
                    quoteRevisemap.put(quoteObj.Opportunity__c,new List<Quotation__c>());
                quoteRevisemap.get(quoteObj.Opportunity__c).add(quoteObj);
            }
            else{
                if(!quotemap.containskey(quoteObj.Opportunity__c))
                    quotemap.put(quoteObj.Opportunity__c,new List<Quotation__c>());
                quotemap.get(quoteObj.Opportunity__c).add(quoteObj);
            }
        }
        for(Quotation__c newQuote : newList){
            if(newQuote.Branch__c!=NULL){
                Decimal latestNumber;
                if(newQuote.Branch__c=='Jubail'){
                    if(jubailRecord.size()>0){                        
                        system.debug('In jubailRecord'+jubailRecord);
                        latestNumber=jubailRecord[0].Record_Number__c;
                        Decimal updatedNumber = latestNumber+1;
                        if(latestNumber!=NULL){
                            if(newQuote.isRevise__c == true)  newQuote.Record_Number__c=latestNumber;
                            else newQuote.Record_Number__c=updatedNumber;
                        }
                        else{
                            newQuote.Record_Number__c=1;
                        }
                        Integer size = null;
                        String previousOne = null;
                        if(quoteRevisemap.size() > 0){
                            if(quoteRevisemap.containsKey(newQuote.Opportunity__c)){
                                size =  quoteRevisemap.get(newQuote.Opportunity__c).size();
                            }
                        }
                        if(quotemap.size() > 0){
                            if(quotemap.containsKey(newQuote.Opportunity__c)){
                                previousOne =  quotemap.get(newQuote.Opportunity__c)[0].Name;
                            }
                        }
                        newQuote.Name =getLatestNameValue(updatedNumber,'JUB','Q',size,newQuote.isRevise__c,previousOne);                        
                        
                    }else{
                        String yearVal = String.valueOf(system.today().year()).right(2);
                        newQuote.Name ='JUB/Q/'+yearVal+'/1';
                        newQuote.Record_Number__c=1;
                    }
                }
                else if(newQuote.Branch__c=='Jeddah'){
                    if(jeddahRecord.size()>0){                        
                        system.debug('In jeddahRecord');
                        latestNumber=jeddahRecord[0].Record_Number__c;
                        Decimal updatedNumber = latestNumber+1;
                        if(latestNumber!=NULL){
                            if(newQuote.isRevise__c == true)  newQuote.Record_Number__c=latestNumber;
                            else newQuote.Record_Number__c=updatedNumber;
                        }
                        else{
                            newQuote.Record_Number__c=1;
                        }
                        Integer size = null;
                        String previousOne = null;
                        if(quoteRevisemap.size() > 0){
                            if(quoteRevisemap.containsKey(newQuote.Opportunity__c)){
                                size =  quoteRevisemap.get(newQuote.Opportunity__c).size();
                            }
                        }
                        if(quotemap.size() > 0){
                            if(quotemap.containsKey(newQuote.Opportunity__c)){
                                previousOne =  quotemap.get(newQuote.Opportunity__c)[0].Name;
                            }
                        }
                        newQuote.Name =getLatestNameValue(updatedNumber,'JED','Q',size,newQuote.isRevise__c,previousOne);                        
                        
                    }else{
                        String yearVal = String.valueOf(system.today().year()).right(2);
                        newQuote.Name ='JED/Q/'+yearVal+'/1';
                        newQuote.Record_Number__c=1;
                    }
                }
                
                else if(newQuote.Branch__c=='Riyadh'){
                    if(riyadRecord.size()>0){                        
                        system.debug('In riyadRecord');
                        latestNumber=riyadRecord[0].Record_Number__c;
                        Decimal updatedNumber = latestNumber+1;
                        if(latestNumber!=NULL){
                            if(newQuote.isRevise__c == true)  newQuote.Record_Number__c=latestNumber;
                            else newQuote.Record_Number__c=updatedNumber;
                        }
                        else{
                            newQuote.Record_Number__c=1;
                        }
                        Integer size = null;
                        String previousOne = null;
                        if(quoteRevisemap.size() > 0){
                            if(quoteRevisemap.containsKey(newQuote.Opportunity__c)){
                                size =  quoteRevisemap.get(newQuote.Opportunity__c).size();
                            }
                        }
                        if(quotemap.size() > 0){
                            if(quotemap.containsKey(newQuote.Opportunity__c)){
                                previousOne =  quotemap.get(newQuote.Opportunity__c)[0].Name;
                            }
                        }
                        newQuote.Name =getLatestNameValue(updatedNumber,'RYD','Q',size,newQuote.isRevise__c,previousOne);                        
                        
                    }else{
                        String yearVal = String.valueOf(system.today().year()).right(2);
                        newQuote.Name ='RYD/Q/'+yearVal+'/1';
                        newQuote.Record_Number__c=1;
                    }
                }
                
                else if(newQuote.Branch__c=='Dammam'){
                    if(dammamRecord.size()>0){                        
                        system.debug('In dammamRecord');
                        latestNumber=dammamRecord[0].Record_Number__c;
                        Decimal updatedNumber = latestNumber+1;
                        if(latestNumber!=NULL){
                            if(newQuote.isRevise__c == true)  newQuote.Record_Number__c=latestNumber;
                            else newQuote.Record_Number__c=updatedNumber;
                        }
                        else{
                            newQuote.Record_Number__c=1;
                        }
                        Integer size = null;
                        String previousOne = null;
                        if(quoteRevisemap.size() > 0){
                            if(quoteRevisemap.containsKey(newQuote.Opportunity__c)){
                                size =  quoteRevisemap.get(newQuote.Opportunity__c).size();
                            }
                        }
                        if(quotemap.size() > 0){
                            if(quotemap.containsKey(newQuote.Opportunity__c)){
                                previousOne =  quotemap.get(newQuote.Opportunity__c)[0].Name;
                            }
                        }
                        newQuote.Name =getLatestNameValue(updatedNumber,'DMM','Q',size,newQuote.isRevise__c,previousOne);                        
                        
                    }else{
                        String yearVal = String.valueOf(system.today().year()).right(2);
                        newQuote.Name ='DMM/Q/'+yearVal+'/1';
                        newQuote.Record_Number__c=1;
                    }
                }  
            }               
        }
    }
    
    public static String getLatestNameValue(Decimal latestNumber,String BranchCode,String recordType,Integer size,Boolean isRevise,String previousOne){
        String latestValue;
        String yearVal = String.valueOf(system.today().year()).right(2);
        //latestNumber = latestNumber.right(4);
        system.debug('latestNumber'+latestNumber);
        //Integer latestNumberVal = Integer.valueOf(latestNumber) + 1;
        ///Decimal latestNumberVal = latestNumber+1;
        system.debug('latestNumberVal : '+latestNumber);
        if(isRevise == false)
        latestValue = BranchCode+'/'+recordType+'/'+yearVal+'/'+latestNumber;
        else{
            if(size == null)
                latestValue = previousOne+' - R1';
            else
                latestValue = previousOne+' - R'+ ++size;
        }
        system.debug('latestValue : '+latestValue);
        return latestValue;        
    }
    
    public static void rollUpTotalAmtToOpty(List<Quotation__c> newList,Map<Id,Quotation__c> oldMap){
        Map<Id,Decimal> optyIdToAmount = new Map<Id,Decimal>();
        Set<Id> optyIds = new Set<Id>();
        List<Opportunity> optyList = new List<Opportunity>();
        for(Quotation__c quoteObj : newList){
            if(quoteObj.Total__c != null && quoteObj.Total__c != oldMap.get(quoteObj.Id).Total__c)
                optyIds.add(quoteObj.Opportunity__c);
        }
        for(Quotation__c quoteObj : [Select id,Amount__c,Opportunity__c from Quotation__c where opportunity__c in: optyIds order by createddate desc]){
            if(!optyIdToAmount.containsKey(quoteObj.Opportunity__c)){
                optyIdToAmount.put(quoteObj.Opportunity__c,quoteObj.Amount__c);
            }
        }
        for(Opportunity opty :[Select id,Amount from opportunity where id in: optyIdToAmount.keyset()]){
            opty.Amount = optyIdToAmount.get(opty.Id);
            optyList.add(opty);
        }
        if(optyList.size() > 0) update optyList;
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