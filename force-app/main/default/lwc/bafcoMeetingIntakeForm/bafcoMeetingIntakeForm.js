import { LightningElement,api,track } from 'lwc';
import getIntakeMeetingObj from '@salesforce/apex/BAFCOMeetingController.getIntakeMeetingObj';
import updateEventObject from '@salesforce/apex/BAFCOMeetingController.updateEventObject';
export default class BafcoMeetingIntakeForm extends LightningElement {
    @api eventId = '';
    @track startDate ='';
    @track startTime ='';
    @track endDate='';
    @track endTime ='';
    @track meetinginute ='';
    @track isLoading = false;
    @track fetchedRecorrd = false;
    @track lati ='';
    @track longi ='';
    @track whatName = '';
    @track filter =  null;
    @track enquiryId = '';
    connectedCallback(){
        this.getIntakeMeetingObj();
        this.handleGetCurrentLocationClick();
    }
    hideModalBox(){
        this.dispatchEvent(new CustomEvent('close'));
    }
    getIntakeMeetingObj(){
        this.isLoading = true;
        getIntakeMeetingObj({eventId : this.eventId})
        .then(result=>{
            console.log('getIntakeMeetingObj result',result)
            if(result != null){
                this.fetchedRecorrd = true;
                this.whatName = result.whatName
                this.startDate = result.startDate
                this.startTime = this.formatTime(result.startTime)
                this.endDate = result.endDate
                this.endTime = this.formatTime(result.endTime)
                this.meetinginute = result.meetingMinute  
                if(result.objectName == 'Lead__c') this.filter = 'Lead__c = \''+result.whatId+'\'';
                else if(result.objectName == 'Account') this.filter = 'Account__c = \''+result.whatId+'\'';
            }
            this.isLoading = false;
        })
        .catch(error=>{
            console.log('getIntakeMeetingObj err',error)
            this.isLoading = false;
        })
    }    
    handleStartDateChange(e){
        this.startDate = e.detail.value
        let startDateField = this.template.querySelector("[data-field='startDate']");
        startDateField.setCustomValidity(''); 
        startDateField.reportValidity();
    }
    handleStarttimeChange(e){
        this.startTime = e.detail.value
        let Field = this.template.querySelector("[data-field='startTime']");
        Field.setCustomValidity(''); 
        Field.reportValidity();
    }
    handleEndDateChange(e){
        this.endDate = e.detail.value
        let Field = this.template.querySelector("[data-field='endDate']");
        Field.setCustomValidity(''); 
        Field.reportValidity();
    }
    handleEndtimeChange(e){
        this.endTime = e.detail.value
        let Field = this.template.querySelector("[data-field='endTime']");
        Field.setCustomValidity(''); 
        Field.reportValidity();
    } 
    handleMeetingMinuteChange(e){
        this.meetinginute = e.detail.value
        let Field = this.template.querySelector("[data-field='meetingMinute']");
        Field.setCustomValidity(''); 
        Field.reportValidity();
    }
    formatTime(date){
        let t = new Date(date),
            hour = '' +(t.getHours()),
            minute = ''+t.getMinutes() == 0 ? '00': (Math.round(t.getMinutes()/15) * 15) % 60 == 0 ? '00' : (Math.round(t.getMinutes()/15) * 15) % 60;
        return [hour, minute].join(':');
    }
    SaveDataBox(){
        let allValid = true;
        if(this.startDate == null ){
            let startDateField = this.template.querySelector("[data-field='startDate']");
            startDateField.setCustomValidity('Complete this field.'); 
            startDateField.reportValidity();
            allValid = false;
        }
        if(this.startTime == null){
            let startTimeField = this.template.querySelector("[data-field='startTime']");
            startTimeField.setCustomValidity('Complete this field.'); 
            startTimeField.reportValidity();
            allValid = false;
        }
        if(this.endDate == null ){
            let endDateField = this.template.querySelector("[data-field='endDate']");
            endDateField.setCustomValidity('Complete this field.'); 
            endDateField.reportValidity();
            allValid = false;
        }
        if(this.endTime == null){
            let endTimeField = this.template.querySelector("[data-field='endTime']");
            endTimeField.setCustomValidity('Complete this field.'); 
            endTimeField.reportValidity();
            allValid = false;
        }
        if(this.meetinginute == '' || this.meetinginute == undefined || this.meetinginute == ''){
            let meetingMinuteField = this.template.querySelector("[data-field='meetingMinute']");
            meetingMinuteField.setCustomValidity('Complete this field.'); 
            meetingMinuteField.reportValidity();
            allValid = false;
        }
        if(allValid){
            this.isLoading = true
            updateEventObject({
                recordId: this.eventId,
                enquiryId:this.enquiryId,
                startDate:this.startDate,
                startTime:this.startTime,
                endDate:this.endDate,
                endTime:this.endTime,
                meetingMinute:this.meetinginute,
                lati:this.lati,
                longi:this.longi
            })
            .then(result=>{
                console.log('result ',result)
                this.isLoading = false
                this.dispatchEvent(new CustomEvent('update',{detail:this.eventId}));
            })
            .catch(error=>{
                console.log('error ',error)
                this.isLoading = false
            })
        }
    }
    handleGetCurrentLocationClick(){
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(position => {
                 this.lati = position.coords.latitude;
                this.longi = position.coords.longitude;
            })
        }
    }
    handleEnquirySelection(e){
        this.enquiryId = e.detail.Id;
    }
    handleEnquiryRemoved(e){
        this.enquiryId = '';
    }
}