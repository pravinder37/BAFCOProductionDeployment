import { LightningElement,track } from 'lwc';
import getTemplatesData from '@salesforce/apex/BAFCOLRoutingDetailsController.getTemplatesData';
export default class BAFCOAdditionalChargeTemplate extends LightningElement {
    @track totalTemplateData = [];
    @track noRecordFound = false;
    @track showCreateModal = false;
    @track hoverClass = 'slds-theme_shade';
    @track selectedId = [];
    @track noneSelected = false;
    @track errorClass = 'slds-accordion';

    connectedCallback(){
        this.getTemplatesData();
    }
    getTemplatesData(){
        getTemplatesData()
        .then(result =>{
            console.log('getTemplatesData result: '+JSON.stringify(result,null,2));
            this.totalTemplateData = result;
            if(this.totalTemplateData.length == 0){
                this.noRecordFound = true;
            }
            else{
                this.noRecordFound = false;
                let tempvar = this.totalTemplateData;
                this.totalTemplateData = tempvar.map(row => ({
                    ...row,
                    displayRow:false
                }));
                console.log('this.totalTemplateData '+JSON.stringify(this.totalTemplateData,null,2))
            }
        }).catch(error=>{
            console.log('error add rate : ', JSON.stringify(error));
        });
    }
    closeModal(){
        this.dispatchEvent(new CustomEvent('close'));
    }    
    createTemplate(){
        this.showCreateModal = true;
    }
    hanleCloseCreateTemplate(){
        this.showCreateModal = false;
    }
    handleAccordianClicked(event){
      
    }
    handleSaveTemplate(){
        this.getTemplatesData();
        this.showCreateModal = false;
    }
    handleMousHover(event){
        /*let selectedTemplateId = event.currentTarget.dataset.id;
        let target = this.template.querySelector(`[data-id="${selectedTemplateId}"]`);
        target.style="background:#FFFDD0;";*/
    }
    handleMouseOut(event){
       /* let selectedTemplateId = event.currentTarget.dataset.id;
        let target = this.template.querySelector(`[data-id="${selectedTemplateId}"]`);
        target.style="background:white";*/
    }
    handleDisplayRow(event){
        let id  = event.currentTarget.dataset.id;
        this.totalTemplateData.forEach(elem =>{
            if(elem.Id == id){
                elem.displayRow = !elem.displayRow;
            }
        })
    }
    handleCheckboxClicked(event){
        this.noneSelected = false;
        this.errorClass = 'slds-accordion'
        let dataId = event.target.value;
        let checked = event.target.checked;
        if(checked){
            this.selectedId.push(dataId);
        }
        else{
            let index = this.selectedId.indexOf(dataId);
            if (index !== -1) {
                this.selectedId.splice(index, 1);
            }
        }
    }
    handleAddSelected(){
        let templist = [];
        this.selectedId.forEach(sss =>{
            this.totalTemplateData.forEach(elem => {
                if(elem.Id == sss){
                    if(elem.Field1_Name__c != undefined){
                        templist.push({
                            'Name':elem.Field1_Name__c,
                            'value':elem.Field1_Value__c,
                        })
                    }
                    if(elem.Field2_Name__c != undefined){
                        templist.push({
                            'Name':elem.Field2_Name__c,
                            'value':elem.Field2_Value__c,
                        })
                    }                
                    if(elem.Field3_Name__c != undefined){
                        templist.push({
                            'Name':elem.Field3_Name__c,
                            'value':elem.Field3_Value__c,
                        })
                    }
                    if(elem.Field4_Name__c != undefined){
                        templist.push({
                            'Name':elem.Field4_Name__c,
                            'value':elem.Field4_Value__c,
                        })
                    }
                    if(elem.Field5_Name__c != undefined){
                        templist.push({
                            'Name':elem.Field5_Name__c,
                            'value':elem.Field5_Value__c,
                        })
                    }
                    if(elem.Field6_Name__c != undefined){
                        templist.push({
                            'Name':elem.Field6_Name__c,
                            'value':elem.Field6_Value__c,
                        })
                    }
                    if(elem.Field7_Name__c != undefined){
                        templist.push({
                            'Name':elem.Field7_Name__c,
                            'value':elem.Field7_Value__c,
                        })
                    }
                    if(elem.Field8_Name__c != undefined){
                        templist.push({
                            'Name':elem.Field8_Name__c,
                            'value':elem.Field8_Value__c,
                        })
                    }
                    if(elem.Field9_Name__c != undefined){
                        templist.push({
                            'Name':elem.Field9_Name__c,
                            'value':elem.Field9_Value__c,
                        })
                    }
                    if(elem.Field10_Name__c != undefined){
                        templist.push({
                            'Name':elem.Field10_Name__c,
                            'value':elem.Field10_Value__c,
                        })
                    }
                }
            });
        })
       let uniqueElem = [];
        templist.map(x => uniqueElem.filter(a => a.Name == x.Name).length > 0 ? null : uniqueElem.push(x));
        if(uniqueElem.length > 0){
            const selectedEvent = new CustomEvent('addselected', { detail: {uniqueElem}});
            this.dispatchEvent(selectedEvent);
        }
        else{
            this.noneSelected = true;
            this.errorClass = 'slds-accordion slds-has-error'
        }
    }
}