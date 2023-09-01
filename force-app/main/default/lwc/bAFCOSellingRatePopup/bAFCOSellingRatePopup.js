import { LightningElement,api } from 'lwc';

export default class BAFCOSellingRatePopup extends LightningElement {
    @api itemId = '';
    @api buyingChargesIncluded ='';
    @api sellingChargesIncluded = '';
    hideModalBox(){
        this.dispatchEvent(new CustomEvent('close'));
    }
}