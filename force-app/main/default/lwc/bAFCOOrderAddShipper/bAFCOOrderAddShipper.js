import { LightningElement,track,api } from 'lwc';
import insertAccountDetails from '@salesforce/apex/BAFCOLeadDetailsController.insertAccountDetails';	
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class BAFCOOrderAddShipper extends LightningElement {
    @track shipperList = [];
    @track shipperIndex = 0;
    @api parentShipperList = [];
    @track displayAccId = '';
    @track dispalayAccountDetails = false;
    @track displayAccInsertPopup = false;
    isLoading = false;
    @track accountName = '';
    @track contName = '';
    @track mobile ='';
    @track contEmail = '';
    @track isLoading2 = false;
    connectedCallback(){
        if(this.parentShipperList.length > 0){
            this.isLoading = true;
            this.shipperList = JSON.parse(JSON.stringify(this.parentShipperList))
            console.log('this.shipperList** '+JSON.stringify(this.shipperList,null,2))
            setTimeout(() => {
                for(let i = 0; i<this.shipperList.length; i++){
                    let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[i];
                    if(this.shipperList[i].shipperId != null){
                        let Obj = {Id:this.shipperList[i].shipperId,Name:this.shipperList[i].shipperName}
                        if(field != undefined) field.handleDefaultSelected(Obj)
                    }
                }
                this.isLoading = false;
            }, 100);
        }
        else{
            this.shipperIndex =  0
            this.addShipper();
        }
    }
    addShipper(){
        this.isLoading = true;
        console.log('this.shipperIndex '+this.shipperIndex);
        let increasedIndex = this.shipperIndex + 1;
        this.shipperIndex = increasedIndex;
        console.log('this.increasedIndex '+increasedIndex);
        let shipperObj = {
            'shipperId':null,
            'shipperName':null,
            'index':increasedIndex
        }
        if(this.shipperList.length < 3)
        this.shipperList.push(shipperObj);
        this.dispatchUpdate();
        this.displayAccInsertPopup = true;
        this.accountName = '';
        this.contEmail ='';
        this.contName = '';
        this.mobile = null;
        this.isLoading = false;
    }
    handleShipperSelection(e){
        let index  = e.detail.index;
        let shipperIndex = this.shipperList.findIndex(x=>x.index == index)
        if(shipperIndex != -1){
            this.shipperList[shipperIndex].shipperId = e.detail.Id;
            this.shipperList[shipperIndex].shipperName = e.detail.Name;
        }
        this.dispatchUpdate();
    }
    handleShipperRemoved(e){
        let index  = e.detail.index;
        let shipperIndex = this.shipperList.findIndex(x=>x.index == index)
        if(shipperIndex != -1){
            console.log('shipperIndex '+shipperIndex)
            this.shipperList[shipperIndex].shipperId = null;
            this.shipperList[shipperIndex].shipperName = null;
        }
        this.dispatchUpdate();
    }
    handleRemoveShipper(e){
        let index = e.target.dataset.recordId;
        let shipperIndex = this.shipperList.findIndex(x=>x.index == index)
        if(shipperIndex != -1){
            this.shipperList.splice(shipperIndex,1)
        }
        this.assignDefault();
        this.dispatchUpdate();
    }
    dispatchUpdate(){
        let shipperList = JSON.parse(JSON.stringify(this.shipperList));
        this.dispatchEvent(new CustomEvent('shipperupdate', { detail: shipperList }));
    }
    assignDefault(){
        this.isLoading = true
        setTimeout(() => {
            for(let i = 0; i<this.shipperList.length; i++){
                let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[i];
                if(this.shipperList[i].shipperId != null){
                    let Obj = {Id:this.shipperList[i].shipperId,Name:this.shipperList[i].shipperName}
                    if(field != undefined) field.handleDefaultSelected(Obj)
                }
            }
        }, 100);
        this.isLoading = false
    }
    handleDisplayAccountDetails(e){
        let index  = e.target.dataset.recordId;
        let shipperIndex = this.shipperList.findIndex(x=>x.index == index);
        if(shipperIndex != -1){
            this.displayAccId = this.shipperList[shipperIndex].shipperId;
            this.dispalayAccountDetails = true;
        }
    }
    handleHideAccountDetails(){
        this.displayAccId = '';
        this.dispalayAccountDetails = false;
    }
    closeModal(){
        this.displayAccInsertPopup = false;
    }
    submitDetails(){
        this.isLoading2 = true;
        let validEmail = true;
        const allValid = [
            ...this.template.querySelectorAll('lightning-input'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        if(this.contEmail != ''){
            const emailRegex=/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            let email=this.template.querySelector(".email");
            let emailVal=email.value;
            if(emailVal.match(emailRegex)){
                email.setCustomValidity("");

            }else{
                validEmail = false;
                email.setCustomValidity("Please enter valid email");
            }
            email.reportValidity();
        }
        if (allValid && validEmail) {
            insertAccountDetails({
                accountName : this.accountName,
                contName : this.contName,
                mobile : this.mobile,
                contEmail : this.contEmail
            })
            .then(result=>{
                let lastIndex = this.shipperList.length - 1;
                console.log('this.shipperList '+JSON.stringify(this.shipperList,null,2))
                this.shipperList[lastIndex].shipperId = result;
                this.shipperList[lastIndex].shipperName = this.accountName;
                this.dispatchUpdate();
                let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[lastIndex];
                let Obj = {Id:this.shipperList[lastIndex].shipperId,Name:this.shipperList[lastIndex].shipperName}
                if(field != undefined) field.handleDefaultSelected(Obj)
                this.displayAccInsertPopup = false;
                this.isLoading2 = false;
                console.log('this.shipperList '+JSON.stringify(this.shipperList,null,2))
            })
            .catch(error=>{
                this.isLoading2 = false;
                console.log('error '+JSON.stringify(error,null,2))
                let pagError = error.body.pageErrors[0].statusCode;
                console.log('statusCode '+JSON.stringify(pagError));
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: pagError,
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.isLoading2 = false;
            })
        }
        else this.isLoading2 = false;
    }
    handleAccountChange(e){
        this.accountName = e.target.value
    }
    handleContactNameChange(e){
        this.contName = e.target.value
    }
    handleContMobileChange(e){
        this.mobile = e.target.value
    }
    handleContactEmailChange(e){
        this.contEmail = e.target.value;
        let email=this.template.querySelector(".email");
        email.setCustomValidity("");
        email.reportValidity();
    }
}