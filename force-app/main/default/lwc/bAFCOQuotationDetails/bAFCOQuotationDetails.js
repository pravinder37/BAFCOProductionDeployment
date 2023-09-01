import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class BAFCOQuotationDetails extends NavigationMixin(LightningElement) {
    @api quotationList = [];
}