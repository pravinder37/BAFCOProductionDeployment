import { LightningElement,api } from 'lwc';
import getLeadDetails from '@salesforce/apex/BAFCOLeadDetailsController.getLeadDetails';
import { NavigationMixin } from 'lightning/navigation';
export default class BAFCODisplayAccountDetails extends NavigationMixin(LightningElement) {
    closeModal(){
        this.dispatchEvent( new CustomEvent('close'));
    }
    @api accId= '';
    @api headerTitle = '';
    @api accountDetails = {};
    isLoading = false;
    connectedCallback(){
        console.log('accid '+this.accId);
        if(this.accId) this.getAccountDetails();
    }
    getAccountDetails(){
        this.isLoading = true;
        getLeadDetails({leadId : this.accId})
        .then(result=>{
            console.log('rsult '+JSON.stringify(result,null,2))
            this.accountDetails = result;
            this.isLoading = false;
        })
        .catch(error=>{
            console.log('error '+JSON.stringify(error,null,2))
            this.isLoading = false;
        });
    }
    handleDisplayAccountDetails(){
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.accId,
                actionName: 'view'
            },
        }).then(url => { window.open(url) });
    }
}