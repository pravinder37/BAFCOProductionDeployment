public class BAFCOAccountTriggerHandler {
    public static void onBeforeInsert(List<Account> acclist){
        checkForLeadRoute(acclist);
    }
    public static void checkForLeadRoute(List<Account> acclist){
        List<String> accNameList = new List<String>();
        List<String> leadNameList = new List<String>();
        for(Account acc : acclist){
            accNameList.add(acc.Name);
        }
        for(Lead ldObj : [Select id,company from lead where Company in : accNameList]){
            leadNameList.add(ldObj.Company);
        }
        if(leadNameList.size() > 0){
            for(Account acc :  accList){
                if(leadNameList.contains(acc.Name)) 
                acc.Is_Similar_to_Lead__c = true;
            }
        }
    }
}