import { LightningElement,api,track,wire } from 'lwc';
import getOrderItem from '@salesforce/apex/BAFCOImportSearchController.getOrderItemValue';
import updateOrderItem from '@salesforce/apex/BAFCOImportSearchController.updateOrderItemValue';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ORDER from '@salesforce/schema/Order__c';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
export default class BAFCOUpdateRatesOnVessleUpdates extends LightningElement {
    @api recordId;
    isLoading2 = false;
    @track buyingRate ;
    @track totalSellingRate ;
    @track shippingLineId = null;
    @track shippingLineName = '';
    @track quotationValidity;
    @track opeExecId = null;
    @track opeExecName = null;
    @track status = null;
    @track qty = null;
    orderItemRecordDetails;
    @track statusOption = [];
    @track orderId = null;
    @track remark = null;
    @track remarkLabel = 'Remark';

    @wire(getPicklistValuesByRecordType, { objectApiName: ORDER, recordTypeId: '012000000000000AAA' })
    OrderObjectData({ data, error }) {
        if(data){
            this.statusOption = data.picklistFieldValues.Status__c.values;
        }
        else if(error){
            console.log(' order Object data error', JSON.stringify(error, null, 2));
        }
    }

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
            if(result.Order__c != null){
                this.orderId = result.Order__c;
                if(result.Order__r.Operations_Executive__c != undefined){
                    this.opeExecId = result.Order__r.Operations_Executive__c;
                    this.opeExecName = result.Order__r.Operations_Executive__r.Name;
                }
                else{
                    this.opeExecId = null;
                    this.opeExecName = null;
                }
                if(result.Order__r.Status__c != undefined){
                    this.status = result.Order__r.Status__c;
                    if(this.status == 'Cancelled'){
                        this.remark = result.Order__r.Cancelled_Remarks__c != undefined ? result.Order__r.Cancelled_Remarks__c : null;
                        this.remarkLabel = 'Cancelled Remarks';
                    }
                    else if(this.status == 'CRO Amendment Awaited'){
                        this.remark = result.Order__r.Amendment_Remarks__c != undefined ? result.Order__r.Amendment_Remarks__c : null;
                        this.remarkLabel = 'Amendment Remarks';
                    }
                    else{
                        this.remark = result.Order__r.Remarks__c != undefined ? result.Order__r.Remarks__c : null;
                        this.remarkLabel = 'Remarks';
                    }
                }
                 
            }
            this.qty = result.Quantity__c != undefined ? result.Quantity__c : null;
            this.totalSellingRate = result.Total_Order__c != undefined ? result.Total_Order__c : null;
            this.quotationValidity = result.Order__r.Quotation__r.Quotation_Validity__c != undefined ? result.Order__r.Quotation__r.Quotation_Validity__c : null;
            if(this.shippingLineId != null){
                let obj={Id: this.shippingLineId,Name: this.shippingLineName}
                let ChildObj = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[0];
                ChildObj.handleDefaultSelected(obj);
            }
            if(this.opeExecId != null){
                let obj={Id: this.opeExecId,Name: this.opeExecName}
                let ChildObj = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[1];
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
                orderItemID :this.recordId,
                orderId : this.orderId,
                opeExecId : this.opeExecId,
                status : this.status,
                qty : this.qty,
                remarks : this.remark

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
            .catch(error=>{
                console.log('error '+JSON.stringify(error,null,2));
                this.isLoading2 = false;
                const evt = new ShowToastEvent({
                    title: 'Update failed',
                    message: error.body.pageErrors[0].message,
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            })
        }
    }

    hideModalBox(){
        this.dispatchEvent(new CustomEvent('close'));
    }
    handleOpEXSelection(e){
        this.opeExecId = e.detail.Id;
        this.opeExecName = e.detail.Name;
    }
    handleOpExRemoved(e){
        this.opeExecId = null;
        this.opeExecName = null;
    }
    handleQtyChange(e){
        this.qty = e.target.value != '' ? parseInt(e.target.value) : null;
    }
    handleStatusChange(e){
        this.status = e.target.value;
        if(this.status == 'Cancelled'){
            this.remarkLabel = 'Cancelled Remarks';
        }
        else if(this.status == 'CRO Amendment Awaited'){
            this.remarkLabel = 'Amendment Remarks';
        }
        else{
            this.remarkLabel = 'Remarks';
        }
    }
    handleRemarkChange(e){
        this.remark = e.target.value;
    }
}