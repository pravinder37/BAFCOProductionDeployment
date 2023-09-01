import { LightningElement,api,wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import {CurrentPageReference} from 'lightning/navigation';
import cloneOrder from '@salesforce/apex/BAFCOSalesOrderController.cloneOrder';
import { NavigationMixin } from 'lightning/navigation';
export default class BAFCOCloneOrder extends NavigationMixin(LightningElement) {
    @api recordId;
    isLoading = false;
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
        }
    }
    handleNoClicked(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    handleYesClicked(){
        this.isLoading = true;
        console.log('came here '+this.recordId)
        cloneOrder({recordId : this.recordId})
        .then(result=>{
            console.log('cloneOrder '+result)
            this.isLoading = false;
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: result,
                    objectApiName: 'Order__c',
                    actionName: 'view'
                }
            });
        })
        .catch(error=>{
            console.log('error '+JSON.stringify(error))
            this.isLoading = false;
        })
    }
}