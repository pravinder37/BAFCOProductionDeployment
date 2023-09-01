global class BAFCOExchangeRateScheduler implements schedulable {    
    global void execute(SchedulableContext sc){
        BAFCOExchangeRateBatchClass b = new BAFCOExchangeRateBatchClass();
        database.executebatch(b);
    }
}