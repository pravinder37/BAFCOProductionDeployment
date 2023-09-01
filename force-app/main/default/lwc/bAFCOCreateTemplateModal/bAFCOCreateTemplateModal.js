import { LightningElement,track } from 'lwc';
import submitTemplatesData from '@salesforce/apex/BAFCOLRoutingDetailsController.submitTemplatesData';
export default class BAFCOCreateTemplateModal extends LightningElement {
    @track templateObj = {};
    @track field1Value = 0;
    @track field2Value = 0;
    @track field3Value = 0;
    @track field4Value = 0;
    @track field5Value = 0;
    @track field6Value = 0;
    @track field7Value = 0;
    @track field8Value = 0;
    @track field9Value = 0;
    @track field10Value = 0;
    @track name ='';
    connectedCallback(){
     this.templateObj={
            'Name':'',
            'Field1_Name__c':'',
            'Field1_Value__c':0,
            'Field2_Name__c':'',
            'Field2_Value__c':0,
            'Field3_Name__c':'',
            'Field3_Value__c':0,
            'Field4_Name__c':'',
            'Field4_Value__c':0,
            'Field5_Name__c':'',
            'Field5_Value__c':0,
            'Field6_Name__c':'',
            'Field6_Value__c':0,
            'Field7_Name__c':'',
            'Field7_Value__c':0,
            'Field8_Name__c':'',
            'Field8_Value__c':0,
            'Field9_Name__c':'',
            'Field9_Value__c':0,
            'Field10_Name__c':'',
            'Field10_Value__c':0,
        }
       // this.templateObj.push(templateObj);
    }
    closeModal(){
        this.dispatchEvent(new CustomEvent('close'));
    }
    handleField1Selection(event){
        this.templateObj.Field1_Name__c = event.detail.Name;        
    }
    handleField1Removed(){
        this.templateObj.Field1_Name__c = '';
    }
    handleField1ValueChange(event){
        this.field1Value = event.target.value;
        this.templateObj.Field1_Value__c = this.field1Value

    }
    handleField2Selection(event){
        this.templateObj.Field2_Name__c = event.detail.Name;        
    }
    handleField2Removed(){
        this.templateObj.Field2_Name__c = '';
    }
    handleField2ValueChange(event){
        this.field2Value = event.target.value;
        this.templateObj.Field2_Value__c = this.field2Value

    }
    handleField3Selection(event){
        this.templateObj.Field3_Name__c = event.detail.Name;        
    }
    handleField3Removed(){
        this.templateObj.Field3_Name__c = '';
    }
    handleField3ValueChange(event){
        this.field3Value = event.target.value;
        this.templateObj.Field3_Value__c = this.field3Value

    }
    handleField4Selection(event){
        this.templateObj.Field4_Name__c = event.detail.Name;        
    }
    handleField4Removed(){
        this.templateObj.Field4_Name__c = '';
    }
    handleField4ValueChange(event){
        this.field4Value = event.target.value;
        this.templateObj.Field4_Value__c = this.field4Value

    }
    handleField5Selection(event){
        this.templateObj.Field5_Name__c = event.detail.Name;        
    }
    handleField5Removed(){
        this.templateObj.Field5_Name__c = '';
    }
    handleField5ValueChange(event){
        this.field5Value = event.target.value;
        this.templateObj.Field5_Value__c = this.field5Value

    }
    handleField6Selection(event){
        this.templateObj.Field6_Name__c = event.detail.Name;        
    }
    handleField6Removed(){
        this.templateObj.Field6_Name__c = '';
    }
    handleField6ValueChange(event){
        this.field6Value = event.target.value;
        this.templateObj.Field6_Value__c = this.field6Value

    }
    handleField7Selection(event){
        this.templateObj.Field7_Name__c = event.detail.Name;        
    }
    handleField7Removed(){
        this.templateObj.Field7_Name__c = '';
    }
    handleField7ValueChange(event){
        this.field7Value = event.target.value;
        this.templateObj.Field7_Value__c = this.field7Value

    }
    handleField8Selection(event){
        this.templateObj.Field8_Name__c = event.detail.Name;
    }
    handleField8Removed(){
        this.templateObj.Field8_Name__c = '';
    }
    handleField8ValueChange(event){
        this.field8Value = event.target.value;
        this.templateObj.Field8_Value__c = this.field8Value

    }
    handleField9Selection(event){
        this.templateObj.Field9_Name__c = event.detail.Name;        
    }
    handleField9Removed(){
        this.templateObj.Field9_Name__c = '';
    }
    handleField9ValueChange(event){
        this.field9Value = event.target.value;
        this.templateObj.Field9_Value__c = this.field9Value

    }
    handleField10Selection(event){
        this.templateObj.Field10_Name__c = event.detail.Name;        
    }
    handleField10Removed(){
        this.templateObj.Field10_Name__c = '';
    }
    handleField10ValueChange(event){
        this.field10Value = event.target.value;
        this.templateObj.Field10_Value__c = this.field10Value

    }
    handleTemplateNameChange(event){
        this.name = event.target.value;
        this.templateObj.Name = this.name
    }
    submitDetails(){
        submitTemplatesData({templateObj : this.templateObj})
        .then(result =>{
            this.dispatchEvent(new CustomEvent('save'));
        })
        .catch(error => {'submitTemplatesData error '+JSON.stringify(error)})
    }
}