import { LightningElement,api,track } from 'lwc';
import getEnqueryDetails from '@salesforce/apex/BAFCOLRoutingDetailsController.getEnqueryDetails';
import VECTOR from '@salesforce/resourceUrl/Vector';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class BAFCOImportQuoteParent extends LightningElement {
    @api enquiryId;
    @track routingDetailsList = [];
    @api cameReviseCompt=false;
    @track leadId;
    @track accountAvgMargin = 0;
    @track accountBestMargin = 0;
    @track accountAvgCreditDays = 0;
    @track section = ''
    @track showQuoteButton = false;
    @track validityDate = '';
    @track quoteId = '';
    @track routeCustomerAvgMargin = 0;
    @track routeAvgMargin = 0;
    minTodaysDate =''
    vectorPng = VECTOR;
    @track displayQuotationlist =[];

    connectedCallback(){
        document.title = 'Create Import Quote'
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
        getEnqueryDetails({enquiryID : this.enquiryId})
        .then(result =>{
            this.routingDetailsList = result;
            this.leadId = this.routingDetailsList[0].leadId;
            //this.accountAvgMargin = this.routingDetailsList[0].accountAvgMargin;
            this.accountBestMargin = this.routingDetailsList[0].accountBestMargin;
            this.accountAvgCreditDays = this.routingDetailsList[0].accountAvgCreditDays;
        }).catch(error=>{
            console.log('error lead: ', JSON.stringify(error));
        });
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
    handleGotoQuote(e){}
    handleSectionToggle(event){
        let section = event.detail.openSections;
        this.section = section
        let index = -1;
        for(let i = 0 ; i< this.routingDetailsList.length ; i++){
            if(this.routingDetailsList[i].routeName == section)
            index = i;
        }
        if(index != -1){
            this.accountAvgMargin = this.routingDetailsList[index].accountAvgMargin;
            this.routeCustomerAvgMargin = this.routingDetailsList[index].routeCustomerAvgMargin;
            this.routeAvgMargin = this.routingDetailsList[index].routeAvgMargin;
            setTimeout(() => {
                this.template.querySelectorAll("c-b-a-f-c-o-import-route-details")[index].handleUpdateCalculation();
            }, 200);
            
        }
    }
    handleUpdateCalculation(e){
        console.log('data ** '+JSON.stringify(e.detail));
        this.displayQuotationlist = JSON.parse(JSON.stringify(e.detail))
        /*let templist = [];
        let tempList2 = [];
        e.detail.quotationMap.forEach(elem =>{
            tempList2.push({value:elem.key,data:elem.value})
        })
        templist.push({key:e.detail.routeName,value:tempList2})        
        this.displayQuotationlist = templist;
        console.log('map '+JSON.stringify(this.displayQuotationlist,null,2))*/
    }
    addNewShippingline(){}
    handleGotoQuote(e){
        console.log('Section '+this.section)
        console.log('this.validityDate'+this.validityDate)
        if(this.validityDate == '' || this.validityDate == null){
            let dateField = this.template.querySelector("[data-field='dateField']");
            dateField.setCustomValidity("Complete this field.");
            dateField.reportValidity();
        }
        else{
            let index = -1;
            for(let i = 0 ; i< this.routingDetailsList.length ; i++){
                if(this.routingDetailsList[i].routeName == this.section)
                index = i;
            }
            if(index != -1){
                setTimeout(() => {
                    let validityDateRms = this.template.querySelectorAll("c-b-a-f-c-o-import-route-details")[index].getValidityDate();
                   if(this.validityDate > validityDateRms){
                        const evt = new ShowToastEvent({
                            title: 'Error',
                            message: 'Buying rate is only valid until '+validityDateRms,
                            variant: 'error',
                            mode: 'dismissable'
                        });
                        this.dispatchEvent(evt);
                        allValid = false
                    }
                    else if(this.validityDate < this.minTodaysDate){
                        const evt = new ShowToastEvent({
                            title: 'Error',
                            message: 'Value must be '+this.validityDate+' or later.',
                            variant: 'error',
                            mode: 'dismissable'
                        });
                        this.dispatchEvent(evt);
                    }
                    else{
                        console.log('OK')
                        this.template.querySelectorAll("c-b-a-f-c-o-import-route-details")[index].handleGotoQuotation(this.validityDate);
                    }
                }, 200);
                
            }
        }
    }
    handleShowquoteBtn(e){
        this.quoteId = e.detail.quoteId;
        console.log('thise quoteID '+this.quoteId);
        this.showQuoteButton = true;
    }
}