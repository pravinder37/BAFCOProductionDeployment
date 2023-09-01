import { LightningElement,track,api } from 'lwc';
import getLeadDetails from '@salesforce/apex/BAFCOLeadDetailsController.getLeadDetails';
export default class BAFCOLeadDetailsComponent extends LightningElement {
    @track leadDetails ={};
    @api leadId = '';
    
    connectedCallback(){
        setTimeout(() => {
        this.getLeadDetails();
        },1000);
    }
    getLeadDetails(){
        console.log('LeadId '+this.leadId)
        getLeadDetails({leadId : this.leadId})
        .then(result =>{
            console.log('lead result : ', JSON.stringify(result,null,2));
            this.leadDetails = result;
        }).catch(error=>{
            console.log('error lead: ', JSON.stringify(error));
        });
    }
}