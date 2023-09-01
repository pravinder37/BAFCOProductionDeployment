public with Sharing class BAFCOMeetingController {
    @AuraEnabled
    public static List<EventList> getMeetingsRecords(String filteredDate){
        Id currentUserId = UserInfo.getUserId();
        Date filterDateTime = filteredDate != null ? Date.valueOf(filteredDate) : system.today();
        List<EventList> eventList = new List<EventList>();
        for(Event ev : [Select id, Who.name,What.Name,StartDateTime, Purpose_of_Visit__c,Minutes_of_Meeting__c from Event where Start_Date__c =: filterDateTime AND createdbyId =:currentUserId  order by StartDateTime ]){
            EventList evobj = new EventList();
            evobj.recordId = ev.id;
            evobj.accountName =  ev.WhatId != null ? ev.What.Name : (ev.WhoId != null ? ev.Who.name : '-');
            evobj.startDate = ev.StartDateTime != null ? String.valueOf(date.valueof(ev.StartDateTime)) : '-';
            evobj.startTime = ev.StartDateTime != null ? String.valueOf(ev.StartDateTime.format('h:mm a'))  : '-';
            evObj.visitfor = ev.Purpose_of_Visit__c != null ? ev.Purpose_of_Visit__c : '-';
            evObj.meetingMinute = ev.Minutes_of_Meeting__c != null ? ev.Minutes_of_Meeting__c : '-';
            eventList.add(evobj);                
        }
        return eventList;
    }
    @AuraEnabled
    public static string submitMeetingsRecords(
    	String whatId,
        String whatIdName,
        String startDate,
        String startTime,
        String visitFor 
    ){
        system.debug('whatId'+whatId);
        List<String> dateList = startDate.split('-');
        List<String> timeList = startTime.split(':');
        Date myDate = Date.newInstance(integer.valueOf(dateList[0]), integer.valueOf(dateList[1]), integer.valueOf(dateList[2]));
		Time myTime = Time.newInstance(integer.valueOf(timeList[0]), integer.valueOf(timeList[1]),0,0);
        Datetime startDate3 = Datetime.newInstanceGmt(myDate,myTime);
        String startDate2 = startDate3.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss') + '+00:00';	        
        Event ev =new Event();
        if(whatId.startsWith('00Q')){
            ev.WhoID = whatId;
        }
        else{
            ev.WhatId = whatId;
        }
        ev.StartDateTime = DateTime.valueOf(startDate2.replace('T', ' '));
        ev.Purpose_of_Visit__c = visitFor;
        ev.Subject = visitFor;
        ev.DurationInMinutes = 60;
        ev.Start_Date__c = Date.valueOf(startDate);
        //ev.Checkin_Location__Latitude__s = lat != '' ? Decimal.valueOf(lat) : null;
        //ev.Checkin_Location__Longitude__s = longi !='' ?  Decimal.valueOf(longi) : null;
        insert ev;
        return ev.id;
    }
    @AuraEnabled
    public static EventRecord getIntakeMeetingObj(String eventId){
        EventRecord dto = new EventRecord();
        String objectName = '';
        Event ev = [Select Purpose_of_Visit__c, who.Name,Related_Enquiry__r.Name,id,whatId,what.Name,Start_Date__c,StartDateTime,End_Date__c,EndDateTime,Minutes_of_Meeting__c from event where id =: eventId];       	
        if(ev.WhatId != null){
            dto.objectName = getObjectNameFromId(ev.WhatId);
            dto.whatName = ev.what.Name;
            dto.whatId = ev.WhatId;
        }
        else if(ev.WhoId != null){
            dto.whatName = ev.who.Name;
            dto.whatId = ev.WhoId;
        }
        dto.recordId = ev.Id;
        dto.startDate = String.valueOf(ev.Start_Date__c);
        dto.startTime = string.valueOf(ev.StartDateTime);
        dto.endDate = String.valueOf(ev.EndDateTime);
        dto.endTime = String.valueOf(ev.EndDateTime);
        dto.meetingMinute = ev.Minutes_of_Meeting__c;
        dto.relatedEnquiryId = ev.Related_Enquiry__c;
        dto.relatedEnquiryName = ev.Related_Enquiry__r.Name;
        dto.visitForUpdate = ev.Purpose_of_Visit__c;
        return dto;
    }
    public static String getObjectNameFromId(String recordId){
        String objectAPIName = '';
        String keyPrefix = recordId.substring(0,3);
        for( Schema.SObjectType obj : Schema.getGlobalDescribe().Values() ){
            String prefix = obj.getDescribe().getKeyPrefix();
            if(prefix == keyPrefix){
                objectAPIName = obj.getDescribe().getName();
                break;
            }
        }
        
        return objectAPIName;
    }
    @AuraEnabled
    public static string updateEventObject(
        string recordId,
        String enquiryId,
        String startDate,
        String startTime,
        String meetingMinute,
        String lati,
        String longi,
        String visitForUpdate
    ){
        system.debug('enquiryId : '+enquiryId);
        List<String> dateList = startDate.split('-');
        List<String> timeList = startTime.split(':');
        Date myDate = Date.newInstance(integer.valueOf(dateList[0]), integer.valueOf(dateList[1]), integer.valueOf(dateList[2]));
		Time myTime = Time.newInstance(integer.valueOf(timeList[0]), integer.valueOf(timeList[1]),0,0);
        Datetime startDate3 = Datetime.newInstanceGmt(myDate,myTime);
        String startDate2 = startDate3.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss') + '+00:00';	   
        Event ev =new Event();
        ev.Id = recordId;
        ev.Related_Enquiry__c = enquiryId != '' ? enquiryId : null;
        ev.StartDateTime = DateTime.valueOf(startDate2.replace('T', ' '));
       // ev.EndDateTime = DateTime.valueOf(endDate2.replace('T', ' '));
        ev.EndDateTime = ev.StartDateTime.addHours(1);
        ev.Start_Date__c = Date.valueOf(startDate);
        ev.End_Date__c = Date.valueOf(startDate);
        ev.Checkin_Location__Latitude__s = lati != '' ? Decimal.valueOf(lati) : null;
        ev.Checkin_Location__Longitude__s = longi !='' ?  Decimal.valueOf(longi) : null;
        ev.Minutes_of_Meeting__c = meetingMinute;
        ev.Purpose_of_Visit__c = visitForUpdate;
        update ev;
        return ev.id;
    }
    @AuraEnabled(cacheable=true)
    public static List<sObject> search(String searchTerm, string myObject, String filter, Boolean cameFromDisplayMeeting) {
        String myQuery = null;
        if(filter != null && filter != ''){
            if(cameFromDisplayMeeting == true && myObject == 'Lead'){
                myQuery = 'Select Id, Search__c from '+myObject+' Where Search__c Like  \'%' + searchTerm + '%\' AND '+filter+' LIMIT  5';
            }
            else{
                myQuery = 'Select Id, Search__c from '+myObject+' Where Search__c Like  \'%' + searchTerm + '%\' AND '+filter+' LIMIT  5';
            }
        }
        else {
            if(searchTerm == null || searchTerm == ''){
                myQuery = 'Select Id, Search__c from '+myObject+' Where LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT  5';
            }
            else {
                if(cameFromDisplayMeeting == true && myObject == 'Lead'){
                    myQuery = 'Select Id, Search__c from '+myObject+' Where Search__c Like  \'%' + searchTerm + '%\' LIMIT  5';
                }
            }
        }
        system.debug('myQuery '+myQuery);
        List<sObject> lookUpList = database.query(myQuery);
        return lookUpList;
    }
    @AuraEnabled(cacheable=true)
    public static List<sObject> accountSearch(String searchTerm, string myObject, String filter) {
        String myQuery = null;
        if(filter != null && filter != ''){
            myQuery = 'Select Id, Name from '+myObject+' Where recordtype.name =\'Default\' AND Name Like  \'%' + searchTerm + '%\' AND '+filter+' LIMIT  5';
        }
        else {
            if(searchTerm == null || searchTerm == ''){
                myQuery = 'Select Id, Name from '+myObject+' Where recordtype.name =\'Default\' AND LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT  5';
            }
            else {
                myQuery = 'Select Id, Name from '+myObject+' Where recordtype.name =\'Default\' AND Name Like  \'%' + searchTerm + '%\' LIMIT  5';
            }
        }
        system.debug('myQuery '+myQuery);
        List<sObject> lookUpList = database.query(myQuery);
        return lookUpList;
    }
    public class EventList{
        @AuraEnabled 
        public string recordId{get;set;}
        @AuraEnabled 
        public string accountName{get;set;}
        @AuraEnabled 
        public String startDate{get;set;}
        @AuraEnabled 
        public String startTime{get;set;}
        @AuraEnabled 
        public String visitFor{get;set;}
        @AuraEnabled 
        public String meetingMinute{get;set;}
    }
    public class EventRecord{
        @AuraEnabled 
        public string recordId{get;set;}
        @AuraEnabled 
        public string whatName{get;set;}
        @AuraEnabled 
        public string whatId{get;set;}
        @AuraEnabled 
        public String startDate{get;set;}
        @AuraEnabled 
        public String startTime{get;set;}
        @AuraEnabled 
        public String endDate{get;set;}
        @AuraEnabled 
        public String endTime{get;set;}
        @AuraEnabled 
        public String meetingMinute{get;set;}
        @AuraEnabled 
        public String objectName{get;set;}
        @AuraEnabled 
        public String relatedEnquiryId{get;set;}
        @AuraEnabled 
        public String relatedEnquiryName{get;set;}
        @AuraEnabled 
        public String visitForUpdate{get;set;}
    }
}