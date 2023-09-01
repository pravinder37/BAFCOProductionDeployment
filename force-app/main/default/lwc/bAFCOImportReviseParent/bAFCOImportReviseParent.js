import { LightningElement,api,track } from 'lwc';
import getquoteDetails from '@salesforce/apex/BAFCOQuotationReviseController.getquoteDetails';
import getquoteList from '@salesforce/apex/BAFCOImportQuotationReviseController.getquoteList';
import getQuoteLineItemRoute from '@salesforce/apex/BAFCOQuotationReviseController.getQuoteLineItemRoute';
import getEnqueryDetails from '@salesforce/apex/BAFCOLRoutingDetailsController.getEnqueryDetails';
import VECTOR from '@salesforce/resourceUrl/Vector';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class BAFCOImportReviseParent extends LightningElement {
    @api quoteID
    @api leadId
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
    @track section = '';
    @track recordtypeName = '';
    @track validityDate = '';
    minTodaysDate = '';
    @track routeCustomerAvgMargin = 0;
    @track routeAvgMargin = 0;
    @track accountAvgMargin = 0;
    connectedCallback(){
        document.title = 'Revise Import Quote';
        this.getquoteDetails();
        let d = new Date().toISOString();  
        this.minTodaysDate = this.formatDate(d);
        let ddd = new Date();
        let year = ddd.getFullYear();
        let month = ddd.getMonth();
        let lastdate = new Date(year, month +1, 0);
        this.validityDate = this.formatDate(lastdate)
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
        this.getQuoteLineItemRoute();
    }
    getQuoteLineItemRoute(){
        getQuoteLineItemRoute({quoteId : this.activeQuoteId})
        .then(result =>{
            console.log('getQuoteLineItemRoute result: ', JSON.stringify(result,null,2));
            if(result.length > 0){
                this.routingDetailsList = result;
                this.enquiryId = result[0].enquiryId;
                this.getEnqueryDetails(); // new qoute generation
            }
            
        })
        .catch(error=>{
            console.log('getQuoteLineItemRoute error: ', JSON.stringify(error));
        });
    }
    handleSectionToggle01(event){
        let section = event.detail.openSections;
        this.section = section
        let index = this.routingDetailsList.findIndex(x=>x.routeName == section);
        if(index != -1){
            setTimeout(() => {
                this.template.querySelectorAll("c-b-a-f-c-o-import-quote-line-item-revise-detail")[index].handleUpdateCalculation();
            }, 200);
        }
    }
    handleUpdateCalculation(e){
        this.displayQuotationlist = JSON.parse(JSON.stringify(e.detail))
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
        let index = this.routingDetailsList.findIndex(x=>x.routeName == section);
        if(index != -1){
            this.accountAvgMargin = this.routingDetailsList[index].accountAvgMargin;
            this.routeCustomerAvgMargin = this.routingDetailsList[index].routeCustomerAvgMargin;
            this.routeAvgMargin = this.routingDetailsList[index].routeAvgMargin;
            setTimeout(() => {
                this.template.querySelectorAll("c-b-a-f-c-o-import-route-details")[index].handleUpdateCalculation();
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
        console.log('validityDate '+this.validityDate)
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
            setTimeout(() => {
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
                if(allValid){
                    this.template.querySelectorAll("c-b-a-f-c-o-import-route-details")[index].handleGotoQuotation(this.validityDate);
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