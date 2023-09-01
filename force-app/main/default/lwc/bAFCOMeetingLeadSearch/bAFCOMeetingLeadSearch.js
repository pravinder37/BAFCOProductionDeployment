import { LightningElement,api,wire,track } from 'lwc';
import lookUp from '@salesforce/apex/BAFCOMeetingController.search';
export default class BAFCOMeetingLeadSearch extends LightningElement {
    @api objName;
    @api iconName;
    @api filter = '';
    @api searchPlaceholder='Search';
    @api index;
    @track selectedName;
    @track records;
    @track isValueSelected;
    @track blurTimeout;
    @api cameFromDisplayMeeting = false
    searchTerm;
    //css
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    @track inputClass = '';
    @wire(lookUp, {searchTerm : '$searchTerm', myObject : '$objName', filter : '$filter',cameFromDisplayMeeting : '$cameFromDisplayMeeting'})
    wiredRecords({ error, data }) {
        if (data) {
            this.error = undefined;
            this.records = data;
        } else if (error) {
            this.error = error;
            this.records = undefined;
        }
    }
    handleClick() {
        this.searchTerm = '';
        this.inputClass = 'slds-has-focus';
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
    }
    onBlur() {
        this.blurTimeout = setTimeout(() =>  {this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus'}, 300);
    }
    onSelect(event) {
        let selectedId = event.currentTarget.dataset.id;
        let selectedName = event.currentTarget.dataset.name;
        let SelectedObj = {Id:selectedId, index:this.index,Name:selectedName};
        const valueSelectedEvent = new CustomEvent('lookupselected', {detail:  SelectedObj });
        this.dispatchEvent(valueSelectedEvent);
        this.isValueSelected = true;
        this.selectedName = selectedName;
        if(this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    }

    @api handleRemovePill() {
        this.isValueSelected = false;
        this.searchTerm = ''
        let SelectedObj = {Id:'', index:this.index};
        const valueUnSelectedEvent = new CustomEvent('lookupremoved', {detail: SelectedObj });
        this.dispatchEvent(valueUnSelectedEvent);
        let input = this.template.querySelector("lightning-input");
        if(input != undefined) input.value = ''
    }

    onChange(event) {
        this.searchTerm = event.target.value;
    }
    @api handleDefaultSelected(requestorObj){
        this.isValueSelected = true;
        let selectedId = requestorObj.Id;
        let selectedName = requestorObj.Name;
        let index = requestorObj.index;
        this.selectedName = selectedName;
        let SelectedObj  = {Id:selectedId, Name:selectedName,index:index};        
        const valueSelectedEvent = new CustomEvent('lookupselected', {detail:  SelectedObj });
        this.dispatchEvent(valueSelectedEvent);
        if(this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    }
}