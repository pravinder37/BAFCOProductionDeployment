import { LightningElement,api } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor';
export default class BAFCOAirFreightEnquiryParent extends LightningElement {
    @api quoteID;
    @api optyId='';
    @api isEdit;
    @api isAir;
    hideLeadDetails = false;
    connectedCallback(){
        console.log('quoteID',this.quoteID);
        console.log('isEdit',this.isAir);
        document.title ='Create Enquiry';
        console.log('FORM_FACTOR '+FORM_FACTOR);
        if(FORM_FACTOR == 'Small') this.hideLeadDetails = true;
        else this.hideLeadDetails = false;
    }
    

}