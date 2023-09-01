import { LightningElement,track } from 'lwc';
import getImportItem from '@salesforce/apex/BAFCOImportSearchController.getImportItem';
import updateQuoteItem from '@salesforce/apex/BAFCOImportSearchController.updateQuoteItem';
import getImportItemOnLoad from '@salesforce/apex/BAFCOImportSearchController.getImportItemOnLoad';
import { NavigationMixin } from 'lightning/navigation';
export default class BAFCOImportSearchScreen extends NavigationMixin(LightningElement) {
    isLoading = false;
    selectedAgentError = '';
    agentId = null;
    noRecord = true;
    @track quoteList = [];
    @track quoteItemId = '';
    @track buyingRate ;
    @track totalSellingRate ;
    displayModal = false;
    //@track fromVesselETD = null;
    //@track toVesselETD = null;
    @track orderNumber = null;
    @track destinationPortId = null;
    @track loadingPortId = null;
    @track shippingLineId = '';
    @track shippingLineName = '';
    @track selectedShippLineError = '';
    @track isLoading2 = false;
    @track quotationValidity ='';
    connectedCallback(){
        this.getImportItemOnLoad();
    }
    getImportItemOnLoad(){
        this.isLoading = true;
        getImportItemOnLoad()
        .then(result=>{
            console.log('getImportItemOnLoad result',JSON.stringify(result,null,2));
            this.isLoading = false;
            this.quoteList = result;
            if(this.quoteList.length > 0) this.noRecord = false
            else this.noRecord = true
        })
        .catch(error=>{
            console.log('getImportItemOnLoad error',JSON.stringify(error,null,2));
            this.isLoading = false;
        })
    }
    handleAgentSelection(e){
        console.log('inside')
        this.agentId = e.detail.Id;
        this.selectedAgentError = '';
        this.removeError();
    }
    handleSearchItem(){
        this.isLoading = true;
        /*let allValid = false;
        if(this.agentId != '' || (this.fromVesselETD != null && this.toVesselETD != null)){
            allValid = true;
        }*/
        //if(allValid){
            if(this.orderNumber == '') this.orderNumber = null;
            getImportItem({
                agentId :this.agentId,
                orderNumber : this.orderNumber,
                loadingPortId : this.loadingPortId,
                destinationPortId : this.destinationPortId,
            })
            .then(result=>{
                console.log('result '+JSON.stringify(result,null,2));
                this.quoteList = result;
                if(this.quoteList.length > 0) this.noRecord = false
                else this.noRecord = true
                this.isLoading = false;
            })
            .catch(error=>{
                console.log('error '+JSON.stringify(error,null,2));
                this.isLoading = false;
            })
       // }
        /*else{
            if(this.agentId == ''){
                this.selectedAgentError = 'slds-has-error'
            }
            if(this.fromVesselETD == null){
                let fromVesselETD = this.template.querySelector("[data-field='fromVesselETD']");
                fromVesselETD.setCustomValidity("Complete this field.");
                fromVesselETD.reportValidity();
            }
            if(this.toVesselETD == null){
                let toVesselETD = this.template.querySelector("[data-field='toVesselETD']");
                toVesselETD.setCustomValidity("Complete this field.");
                toVesselETD.reportValidity();
            }
            this.isLoading = false;
        }*/
    }
    handleAgentRemoved(e){
        this.agentId = null;
    }
    handleEditItem(e){
        this.isLoading = true;
       this.quoteItemId = e.target.value;
       let item = this.quoteList.filter(x=>x.Id == this.quoteItemId);
       this.buyingRate = item[0].Buying_Rate__c;
       this.totalSellingRate = item[0].Total_Order__c;
       if(item[0].Order__r.Quotation__r.Quotation_Validity__c != undefined){
        this.quotationValidity = item[0].Order__r.Quotation__r.Quotation_Validity__c
       }
       if(item[0].Shipping_Line__c != undefined){        
        setTimeout(() => {
            this.isLoading = true;
            this.shippingLineId = item[0].Shipping_Line__c;
            this.shippingLineName = item[0].Shipping_Line__r.Name;
            let shippLineField = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[3];
            if(shippLineField != null){
                let obj = {Id:this.shippingLineId,Name:this.shippingLineName};
                shippLineField.handleDefaultSelected(obj);
            }
            this.isLoading = false;
        }, 300);
       }

       this.displayModal = true;
       this.isLoading = false;
    }
    handleNewQuote(e){
        this.isLoading =true
        let quoteId = e.target.value;
        let item = this.quoteList.filter(x=>x.Order__r.Quotation__c == quoteId);
        let accId = item[0].Order__r.Account_Order__c;
        this[NavigationMixin.Navigate]({
            type: "standard__component",
            attributes: {
                componentName: "c__ImportReviseQuoteTab"
            },
            state: {
                c__refRecordId: quoteId,
                c__leadId: accId
            }
        });
    }
    hideModalBox(){
        this.displayModal= false;
    }
    handleBuyingRateChange(e){
        this.buyingRate = e.target.value;
        let buyingRateField = this.template.querySelector("[data-field='buyingRateField']");
        buyingRateField.setCustomValidity("");
        buyingRateField.reportValidity();  
    }
    handleSellingTotalChange(e){
        this.totalSellingRate = e.target.value;
        let totalRateField = this.template.querySelector("[data-field='totalRateField']");
        totalRateField.setCustomValidity("");
        totalRateField.reportValidity();  
    }
    handleUpdateItemClicked(){
        this.isLoading2 = true;
        let allValid = true;
        if(this.buyingRate <= 0) {
            allValid = false
            let buyingRateField = this.template.querySelector("[data-field='buyingRateField']");
            buyingRateField.setCustomValidity("Buying Rate must be greater than 0.");
            buyingRateField.reportValidity();
            this.isLoading2 = false;
        }
        if(this.totalSellingRate <= 0){
            allValid = false
            let totalRateField = this.template.querySelector("[data-field='totalRateField']");
            totalRateField.setCustomValidity("Total must be greater than 0.");
            totalRateField.reportValidity();
            this.isLoading2 = false;  
        }
        if(this.shippingLineId == ''){
            allValid = false;
            this.selectedShippLineError = 'slds-has-error';
            this.isLoading2 = false;
        }
        if(allValid){
            updateQuoteItem({
                buyingRate : this.buyingRate,
                sellingRate: this.totalSellingRate,
                recordId : this.quoteItemId,
                shippingLineId : this.shippingLineId,
                quotationValidity : this.quotationValidity
            }).then(result=>{
                this.quoteList = [];
                console.log('result '+result);
                this.displayModal= false;
                this.isLoading2 = false;
                this.getImportItemOnLoad();
            })
            .catch(error=>{console.log('error '+JSON.stringify(error));this.isLoading2 = false;})
        }
    }
    handleOrderItemClicked(e){
        let Id = e.target.dataset.value
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: Id,
                actionName: 'view'
            },
        }).then(url => { window.open(url,'_blank') });
    }
    handleQuotationClicked(e){
        let Id = e.target.dataset.value
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: Id,
                actionName: 'view'
            },
        }).then(url => { window.open(url,'_blank') });
    }
    /*handleFromVesselETDChange(e){
        this.fromVesselETD = e.target.value
        this.removeError();
    }
    handleToVesselETDChange(e){
        this.toVesselETD = e.target.value
        this.removeError();
    }*/
    removeError(){
        this.selectedAgentError = ''
        /*let fromVesselETD = this.template.querySelector("[data-field='fromVesselETD']");
        fromVesselETD.setCustomValidity("");
        fromVesselETD.reportValidity();
        let toVesselETD = this.template.querySelector("[data-field='toVesselETD']");
        toVesselETD.setCustomValidity("");
        toVesselETD.reportValidity();*/
    }
    handleShippingLineSelection(e){
        this.shippingLineId = e.detail.Id;
        this.shippingLineName = e.detail.Name;
        this.selectedShippLineError = '';
    }
    handleShippingLineRemoved(e){
        this.shippingLineId = '';
        this.shippingLineName = '';
        this.selectedShippLineError = 'slds-has-error';
    }
    handleQuotationValidityChange(e){
        this.quotationValidity = e.target.value;
    }
    handleOrderNumberChange(e){
        this.orderNumber = e.target.value;
    }
    handleLoadingPortSelection(e){
        this.loadingPortId = e.detail.Id;
    }
    handleLoadingPortRemoved(e){
        this.loadingPortId = null;
    }
    handleDestinationPortSelection(e){
        this.destinationPortId = e.detail.Id;
    }
    handleDestinationPortRemoved(e){
        this.destinationPortId = null;
        
    }
}