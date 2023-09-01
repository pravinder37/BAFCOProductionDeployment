import { LightningElement,api,wire,track } from 'lwc';
import getQuoteDataOnLoad from '@salesforce/apex/BAFCOQuoteCopyContentController.getQuoteDataOnLoad';
import sendEmail from '@salesforce/apex/BAFCOQuoteCopyContentController.sendEmail';
import { CloseActionScreenEvent } from 'lightning/actions';
import {CurrentPageReference} from 'lightning/navigation';
import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import userEmailFIELD from '@salesforce/schema/User.Email';
import TO_ADDRESS from '@salesforce/label/c.BAFCOSendNominationToAddress';
export default class BAFCOQuotationSendEmail extends LightningElement {
    @api recordId;
    @track toSend = '';
    @track toCCSend = '';
    @track toBCCSend = '';
    @track subject = '';
    @track body ='';
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
        }
        console.log('recordId && '+this.recordId)
    }
    @wire(getRecord, { recordId: Id, fields: [userEmailFIELD]}) 
    currentUserInfo({error, data}) {
        if (data) {
            this.toCCSend = data.fields.Email.value;
        } else if (error) {
            this.error = error ;
        }
    }
    connectedCallback(){
        if(this.recordId != undefined) this.getQuoteDataOnLoad();
        this.toSend = TO_ADDRESS;
    }
    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    getQuoteDataOnLoad(){
        this.isLoading = true;
        getQuoteDataOnLoad({quoteId : this.recordId})
        .then(result=>{
            this.isLoading = false
            console.log('getQuoteDataOnLoad result @@ '+JSON.stringify(result,null,2))
            if(result != null){
                let content = 'Dear Team,\n\nPlease take note of the following and process the booking.';
                content +='\n\nPlease find below the details:\n';

                if(result.length > 0){
                    this.subject = 'Branch - ';
                    this.subject += result[0].customerName != undefined ? result[0].customerName+'-' : 'Branch - ';
                    this.subject += result[0].subjectLine;
                    console.log('subject '+this.subject)
                    result.forEach(elem => {
                        content += '\nQuotation Name: '+elem.quoteName;
                        content +='\nSalesman: '+elem.saleman;
                        content += '\nPort of Loading: '+elem.loadingPort;
                        content += '\nPort of Discharge: '+elem.dischargePort;
                        content += '\nEquipment Type: '+elem.equipmentType;  
                        content += '\nCommodity: '+elem.commodity;                      
                        content += '\nQuantity: '+elem.quantity;
                        content += '\nCargo Weight: '+elem.cargoWeight;
                        content += '\nShipping Line: '+elem.shippingLine;
                        content +='\nContract Number: ';
                        content += '\nCustomer reference number: '+elem.customerRefNo;
                        content += '\nCustomer PO number: '+elem.customerPONo;
                        content += '\n\n';
                    });
                    this.body = content;
                }
            }
        })
        .catch(error=>{
            this.isLoading = false
            console.log('getQuoteDataOnLoad error @@ '+JSON.stringify(error,null,2))
        })
    }
    handletoSend(e){
        this.toSend = e.target.value;
        let toSendField =  this.template.querySelector("[data-field='toSendField']")
        toSendField.setCustomValidity('')
        toSendField.reportValidity();
    }
    handletoCCSend(e){
        this.toCCSend = e.target.value;
        let toCCSendField =  this.template.querySelector("[data-field='toCCSendField']")
        toCCSendField.setCustomValidity('')
        toCCSendField.reportValidity();
    }
    handletoBCCSend(e){
        this.toBCCSend = e.target.value;
        let toBCCField =  this.template.querySelector("[data-field='toBCCField']")
        toBCCField.setCustomValidity('')
        toBCCField.reportValidity();
    }
    handlesubject(e){
        this.subject = e.target.value;
        let subjectField =  this.template.querySelector("[data-field='subjectField']")
        subjectField.setCustomValidity('')
        subjectField.reportValidity();
    }
    handleBodychange(e){
        this.body = e.target.value;
        let bodyField =  this.template.querySelector("[data-field='bodyField']")
        bodyField.setCustomValidity('')
        bodyField.reportValidity();
    }
    sendEmailClicked(){
        let allValid = true;
        this.isLoading = true;
        let toSendField =  this.template.querySelector("[data-field='toSendField']")
        let subjectField =  this.template.querySelector("[data-field='subjectField']")
        let bodyField =  this.template.querySelector("[data-field='bodyField']")
        if(this.toSend == ''){
            allValid = false;
            toSendField.setCustomValidity('Complete this field.')
            toSendField.reportValidity();
        }
        if(this.subject == ''){
            allValid = false;
            subjectField.setCustomValidity('Complete this field.')
            subjectField.reportValidity();
        }
        if(this.body == ''){
            allValid = false;
            bodyField.setCustomValidity('Complete this field.')
            bodyField.reportValidity();
        }
        const allValid2 = [
            ...this.template.querySelectorAll('lightning-input'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        let stringAsHtml =this.body.replace(/\n/g, "<br />\r\n");
        if(allValid && allValid2){
            sendEmail({
                toSend : this.toSend,
                toCCSend : this.toCCSend,
                toBCCSend : this.toBCCSend,
                subject : this.subject,
                body : stringAsHtml,
                quoteId : this.recordId,
            }).then(result=>{
                console.log('sendEmail result '+result)
                this.isLoading = false
                this.dispatchEvent(new CloseActionScreenEvent());
            })
            .catch(error=>{
                this.isLoading = false
                console.log('sendEmail error '+JSON.stringify(error,null,2))
            })
        }
        else{
            this.isLoading = false
        }
    }
    
}