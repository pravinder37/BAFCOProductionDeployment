import { LightningElement,api,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import VECTOR from '@salesforce/resourceUrl/Vector';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getquoteList from '@salesforce/apex/BAFCOQuotationReviseController.getquoteList';
import getquoteDetails from '@salesforce/apex/BAFCOQuotationReviseController.getquoteDetails';
import getQuoteLineItemRoute from '@salesforce/apex/BAFCOAirEnquiryController.getQuoteLineItemRoute';
import getEnqueryDetails from '@salesforce/apex/BAFCOLRoutingDetailsController.getEnqueryDetails';
export default class BAFCOAirExportReviseParent extends NavigationMixin(LightningElement) {
    @api quoteID ='';
    @api leadId = '';
    @track quoteObj = {};
    @track quoteList;
    vectorPng = VECTOR;
    @track activeTab ='';
    @track routingDetailsList;
    @track activeQuoteId = '';
    @track displayQuotationlist= [];
    @track enquiryList = [];
    @track enquiryId = '';
    @track cameReviseCompt = true;
    @track sameRoute = true;
    @track  showQuoteButton = false;
    @track section = 'Route 1';
    @track recordtypeName = '';
    @track validityDate = '';
    minTodaysDate ='';
    connectedCallback(){
        console.log('quotation id '+this.quoteID);
        console.log('leadId id '+this.leadId);
        document.title = 'Revise Export Quote';
        this.section = 'Route 1'
        let d = new Date().toISOString();  
        this.minTodaysDate = this.formatDate(d);
        let ddd = new Date();
        let year = ddd.getFullYear();
        let month = ddd.getMonth();
        let lastdate = new Date(year, month +1, 0);
        this.validityDate = this.formatDate(lastdate)
        this.getquoteDetails();
    }
    getquoteDetails(){
        getquoteDetails({quoteId : this.quoteID}).then(result =>{
            console.log('getquoteDetails  result : ', JSON.stringify(result,null,2));
            if(result != null){
                this.quoteObj= result;
                this.getquoteList();
            }            
        }).catch(error=>{
            console.log('getquoteDetails lead: ', JSON.stringify(error));
        });
    }
    formatDate(date) {
        let d = new Date(date),
            month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();
    
        if (month.length < 2) 
            month = '0' + month;
        if (day.length < 2) 
            day = '0' + day;
    
        return [year, month, day].join('-');
    }
    getquoteList(){
        getquoteList({quoteId : this.quoteID}).then(result =>{
            console.log('getquoteList  result : ', JSON.stringify(result,null,2));
            if(result != null){
                this.quoteList=result;
                this.activeTab = result[0].Id;
                this.recordtypeName = result.RecordType.Name;
            }            
        }).catch(error=>{
            console.log('getquoteList lead: ', JSON.stringify(error));
        });
    }
    handleQuoteActive(event){
            let quoteId = event.target.value;
            this.activeQuoteId = quoteId;
            console.log('this.activeQuoteId '+this.activeQuoteId);
            this.getQuoteLineItemRoute();
    }
    getQuoteLineItemRoute(){
        getQuoteLineItemRoute({quoteId : this.activeQuoteId})
        .then(result =>{
            console.log('getQuoteLineItemRoute result: ', JSON.stringify(result,null,2));
            if(result.length > 0){
                this.routingDetailsList = result;
                this.enquiryId = result[0].enquiryId;
                this.section = result[0].routeName;
                this.getEnqueryDetails(); // new qoute generation
            }
            
        })
        .catch(error=>{
            console.log('getQuoteLineItemRoute error: ', JSON.stringify(error));
        });
    }
    handleUpdateCalculation(e){
        this.displayQuotationlist = JSON.parse(JSON.stringify(e.detail));
    }
    getEnqueryDetails(){
        getEnqueryDetails({enquiryID : this.enquiryId})
        .then(result =>{
            this.enquiryList = result; 
            console.log('enquiry  result : ', JSON.stringify(this.enquiryList,null,2)); 
        }).catch(error=>{
            console.log('error lead: ', JSON.stringify(error));
        });
    }
    handleSectionToggle(event){
        let section = event.detail.openSections;
        this.section = section
        let index = -1;
        index = this.routingDetailsList.findIndex(x=>x.routeName == this.section);
        if(index != -1){
            setTimeout(() => {
              //  this.template.querySelectorAll("c-b-a-f-c-o-routing-details-intake-form")[index].handleUpdateCalculation();
            }, 200);
            
        }
    }
    handleSectionToggle01(event){
        let section = event.detail.openSections;
        this.section = section
        let index = -1;
        index = this.routingDetailsList.findIndex(x=>x.routeName == this.section);
        if(index != -1){
            setTimeout(() => {
              //  this.template.querySelectorAll("c-b-a-f-c-o-quote-line-item-revise-detail")[index].handleUpdateCalculation();
            }, 200);
            
        }
    }
    handleShowquoteBtn(e){
        this.quoteID = e.detail.quoteId;
        this.sameRoute = false;
        this.showQuoteButton = true;
    }
    handleNewQuoteActive(){
        this.quoteID = '';
    }
    handleGotoQuote(){
        console.log('Section '+this.section)
        let allValid = true;
        if(this.validityDate == '' || this.validityDate == null){
            let dateField = this.template.querySelector("[data-field='dateField']");
            dateField.setCustomValidity("Complete this field.");
            dateField.reportValidity();
            allValid = false
        }
        else{
            let index = -1;
            for(let i = 0 ; i< this.enquiryList.length ; i++){
                if(this.enquiryList[i].routeName == this.section)
                index = i;
            }
            if(index != -1){
                if(this.validityDate < this.minTodaysDate){
                    allValid = false
                    const evt = new ShowToastEvent({
                        title: 'Error',
                        message: 'Value must be '+this.validityDate+' or later.',
                        variant: 'error',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                }
                setTimeout(() => {
                    if(allValid){
                        this.template.querySelectorAll("c-b-a-f-c-o-air-export-quote-intake-form")[index].handleGotoQuotation(this.validityDate);
                    }
                }, 200);
                
            }
        }
    }
    handleValidityChange(e){
        this.validityDate = e.target.value;
        let dateField = this.template.querySelector("[data-field='dateField']");
        if(this.validityDate == ''){            
            dateField.setCustomValidity("Complete this field.");            
        }
        else{
            dateField.setCustomValidity("");  
        }
        dateField.reportValidity();
    }
}