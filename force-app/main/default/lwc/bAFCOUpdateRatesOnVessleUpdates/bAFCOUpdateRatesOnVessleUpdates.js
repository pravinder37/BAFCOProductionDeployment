import { LightningElement,api,track } from 'lwc';
import getOrderItem from '@salesforce/apex/BAFCOImportSearchController.getOrderItemValue';
import updateOrderItem from '@salesforce/apex/BAFCOImportSearchController.updateOrderItemValue';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class BAFCOUpdateRatesOnVessleUpdates extends LightningElement {
    @api recordId;
    isLoading2 = false;
    @track buyingRate ;
    @track totalSellingRate ;
    @track shippingLineId = null;
    @track shippingLineName = '';
    @track quotationValidity;
    orderItemRecordDetails;

    connectedCallback(){
        console.log('recordId'+this.recordId);
        this.getOrderItemOnLoad();
    }

    getOrderItemOnLoad(){
        this.isLoading2 = true;
        getOrderItem({orderItemID :this.recordId})
        .then(result=>{
            this.isLoading2 = false;
            this.orderItemRecordDetails = result;
            console.log('this.orderItemRecordDetails',this.orderItemRecordDetails);
            console.log('this.orderItemRecordDetails.buyingRate'+this.orderItemRecordDetails.Buying_Rate__c);
            console.log('this.orderItemRecordDetails.Shipping_Line__c'+this.orderItemRecordDetails.Shipping_Line__c);
            this.buyingRate=this.orderItemRecordDetails.Buying_Rate__c != undefined ? this.orderItemRecordDetails.Buying_Rate__c : null;
            if(result.Shipping_Line__c != undefined){
                this.shippingLineId = result.Shipping_Line__c ;
                this.shippingLineName = result.Shipping_Line__r.Name ;
            }
            else{
                this.shippingLineId = null;
                this.shippingLineName = null;
            }
            
            this.totalSellingRate = result.Total_Order__c != undefined ? result.Total_Order__c : null;
            this.quotationValidity = result.Order__r.Quotation__r.Quotation_Validity__c != undefined ? result.Order__r.Quotation__r.Quotation_Validity__c : null;
            if(this.shippingLineId != null){
                let obj={Id: this.shippingLineId,Name: this.shippingLineName}
                let ChildObj = this.template.querySelector('c-b-a-f-c-o-custom-look-up-component');
                ChildObj.handleDefaultSelected(obj);
            }
        })
        .catch(error=>{
            console.log('getOrderItemOnLoad error',JSON.stringify(error,null,2));
            this.isLoading2 = false;
        })
    }

    handleShippingLineSelection(e){
        this.shippingLineId = e.detail.Id;
        this.shippingLineName = e.detail.Name;
        this.selectedShippLineError = '';
    }

    handleShippingLineRemoved(e){
        this.shippingLineId = null;
        this.shippingLineName = '';
        this.selectedShippLineError = 'slds-has-error';
    }

    handleBuyingRateChange(e){
        if(e.target.value != '') this.buyingRate = e.target.value;
        else this.buyingRate = null;
        let buyingRateField = this.template.querySelector("[data-field='buyingRateField']");
        buyingRateField.setCustomValidity("");
        buyingRateField.reportValidity();  
    }

    handleSellingTotalChange(e){
        if(e.target.value != '') this.totalSellingRate = e.target.value;
        else this.totalSellingRate = null;
        let totalRateField = this.template.querySelector("[data-field='totalRateField']");
        totalRateField.setCustomValidity("");
        totalRateField.reportValidity();  
    }

    handleQuotationValidityChange(e){
        this.quotationValidity = e.target.value;
        let quotationValidityField = this.template.querySelector("[data-field='quotationValidityField']");
        quotationValidityField.setCustomValidity("");
        quotationValidityField.reportValidity();  
    }

    handleUpdateItemClicked(){
        this.isLoading2 = true;
        let allValid = true;
        /*if(this.buyingRate <= 0) {
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
        }*/
        if(allValid){
            console.log('this.shippingLineId'+this.shippingLineId);
            updateOrderItem({
                buyingRate : this.buyingRate,
                sellingRate: this.totalSellingRate,
                shippingLineId : this.shippingLineId,
                quotationValidity : this.quotationValidity,
                orderItemID :this.recordId
            }).then(result=>{
                this.quoteList = [];
                console.log('result '+result);
                const evt = new ShowToastEvent({
                    title: 'Updated Successfully',
                    message: 'Order item is updated successfully.',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.isLoading2 = false;
                this.dispatchEvent(new CustomEvent('close'));
                location.reload();
                //this.getImportItemOnLoad();
            })
            .catch(error=>{console.log('error '+JSON.stringify(error));this.isLoading2 = false;})
        }
    }

    hideModalBox(){
        this.dispatchEvent(new CustomEvent('close'));
    }


}