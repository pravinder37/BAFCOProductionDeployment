import { LightningElement,api,track } from 'lwc';
import VECTOR from '@salesforce/resourceUrl/Vector';
import getEnqueryDetails from '@salesforce/apex/BAFCOLRoutingDetailsController.getEnqueryDetails';
export default class BAFCOAirExportQuoteParent extends LightningElement {
    @api optyId = '';
    @api businessType = '';
    @track routingDetailsList = [];
    @track accountId;
    @track accountAvgMargin = 0;
    @track accountBestMargin = 0;
    @track accountAvgCreditDays = 0;
    @track section = ''
    @track showQuoteButton = false;
    @track validityDate = '';
    @track quoteId = '';
    vectorPng = VECTOR;
    minTodaysDate = '';
    connectedCallback(){
        this.getEnqueryDetailsOnInit();
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
    getEnqueryDetailsOnInit(){
        getEnqueryDetails({enquiryID : this.optyId})
        .then(result =>{
            console.log('enquery  result : ', JSON.stringify(result,null,2));
            this.routingDetailsList = result;
            this.accountId = this.routingDetailsList[0].leadId;
            this.accountAvgMargin = this.routingDetailsList[0].accountAvgMargin;
            this.accountBestMargin = this.routingDetailsList[0].accountBestMargin;
            this.accountAvgCreditDays = this.routingDetailsList[0].accountAvgCreditDays;
        }).catch(error=>{
            console.log('error lead: ', JSON.stringify(error));
        });
    }
    handleShowquoteBtn(e){
        this.quoteId = e.detail.quoteId;
        this.showQuoteButton = true;
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
    handleSectionToggle(event){
        let section = event.detail.openSections;
        this.section = section
        let index = -1;
        for(let i = 0 ; i< this.routingDetailsList.length ; i++){
            if(this.routingDetailsList[i].routeName == section)
            index = i;
        }
        if(index != -1){
            setTimeout(() => {
                this.template.querySelectorAll("c-b-a-f-c-o-air-export-quote-intake-form")[index].handleUpdateCalculation();
            }, 200);
            
        }
    }
    handleGotoQuote(e){
        let allValid = true
        if(this.validityDate == '' || this.validityDate == null){
            let dateField = this.template.querySelector("[data-field='dateField']");
            dateField.setCustomValidity("Complete this field.");
            dateField.reportValidity();
            allValid = false
        }
        else{
            let index = -1;
            for(let i = 0 ; i< this.routingDetailsList.length ; i++){
                if(this.routingDetailsList[i].routeName == this.section)
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
                if(allValid){
                    this.template.querySelectorAll("c-b-a-f-c-o-air-export-quote-intake-form")[index].handleGotoQuotation(this.validityDate);
                }
            }
        }
    }
}