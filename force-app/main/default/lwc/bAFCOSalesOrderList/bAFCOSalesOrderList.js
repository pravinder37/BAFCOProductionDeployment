import { LightningElement,api,track } from 'lwc';
import createOrder from '@salesforce/apex/BAFCOSalesOrderController.createOrder';
import { NavigationMixin } from 'lightning/navigation';	
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class BAFCOSalesOrderList extends NavigationMixin(LightningElement) {
    @api displaySelectedQuoteItem = [];
    @api activeSection;
    @api quantityData = [];
    @api displayShipConsignee = false
    @api customerAccount ;
    custRefNumber = ''
    isLoading = false;
    validityDate = '';
    errorMsg = '';
    minDate = '';
    bookRefNumber ='';
    bbmsJobNumber = null;
    displayAddConsigneeModal = false;
    @track consigneeList = [];
    @track shipperList = [];
    @track OperationExec = null;
    //@track agentProfitShare = null;
    connectedCallback(){
        let todaysDate = new Date();
        this.minDate = this.formatDate(todaysDate);
        let ddd = new Date();
        let year = ddd.getFullYear();
        let month = ddd.getMonth();
        let lastdate = new Date(year, month +1, 0);
        this.validityDate = this.formatDate(lastdate)
        setTimeout(() => {
            if(this.customerAccount != null){
                let consigneeObj = {
                    'consigneeId':this.customerAccount.accountId,
                    'consigneeName':this.customerAccount.accountName,
                    'index':0
                }
                this.consigneeList.push(consigneeObj);
                let shipperObj = {
                    'shipperId':this.customerAccount.accountId,
                    'shipperName':this.customerAccount.accountName,
                    'index':0
                }
                //this.shipperList.push(shipperObj);
            }
        }, 1000);
        
    }
    formatDate(date) {
        let d = new Date(date),
            month = '' + (d.getMonth() + 1),
            day = '' + (d.getDate()),
            year = d.getFullYear();
    
        if (month.length < 2) 
            month = '0' + month;
        if (day.length < 2) 
            day = '0' + day;
    
        return [year, month, day].join('-');
    }
    hideCreateOrder(){
        this.isLoading = true;
        let allValid = true;
        let validQty = true;
       if(this.validityDate == '' || this.validityDate == null){
            let dateField = this.template.querySelector("[data-field='dateField']");
            dateField.setCustomValidity("Complete this field.");
            dateField.reportValidity();
            this.isLoading = false
        }
        else if(this.validityDate < this.minDate){
            let dateField = this.template.querySelector("[data-field='dateField']");
            dateField.setCustomValidity('Value must be '+this.minDate+' or later.');
            dateField.reportValidity();
            this.isLoading = false
        }
        else{
            let hasValue = false;
            this.displaySelectedQuoteItem.forEach(ele=>{
                if(ele.equipment.length > 0) {
                    hasValue = true;
                    ele.equipment.forEach(ele2=>{
                        ele2.value.forEach(ele3=>{
                            console.log('ele3.checkBoxSelected '+ele3.checkBoxSelected);
                            console.log('ele3.checkBoxSelected '+ele3.Qty);
                            if(ele3.checkBoxSelected == undefined){
                                allValid = false;
                                console.log('came here 2')
                            }                            
                            else if(ele3.checkBoxSelected == true && (ele3.Qty == undefined || ele3.Qty <= 0)){
                                validQty = false;
                                allValid = false;
                                console.log('came here 3')
                            }
                        })
                    })
                } 
            });
            console.log('hasValue ',hasValue)
            console.log('validQty ',validQty)
            console.log('allValid ',allValid)
            if(!hasValue){
                this.isLoading = false
                this.errorMsg='Please select atleast one item to create order';
            }
            if(!validQty){
                this.isLoading = false;
                const evt = new ShowToastEvent({
                    title: 'Required field missing.',
                    message: 'Please provide quantity for every selected item.',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);

            }
            if(allValid && hasValue){
                this.isLoading = true;
                let saveDto = [];
                saveDto = JSON.parse(JSON.stringify(this.displaySelectedQuoteItem))   
                console.log('saveDto ',JSON.stringify(saveDto,null,2))      
                console.log('shipperList '+JSON.stringify(this.shipperList,null,2));       
                createOrder({
                        orderCreationList : saveDto,
                        validityDate : this.validityDate,
                        custRefNumber : this.custRefNumber,
                        bookRefNumber : this.bookRefNumber,
                        bbmsJobNumber : this.bbmsJobNumber,
                        consigneeList : this.consigneeList,
                        shipperList : this.shipperList,
                        OperationExec : this.OperationExec
                    })
                .then(result=>{
                    console.log('createOrder result',JSON.stringify(result,null,2))
                    this.isLoading = false;
                    if(result != null ){
                        this[NavigationMixin.Navigate]({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: result.Id,
                                actionName: 'view'
                            }
                        });
                    }
                })
                .catch(error=>{
                    this.isLoading = false;
                    console.log('createOrder error',JSON.stringify(error,null,2))
                })
            }
            else this.isLoading = false;
        }
    }
    handleValidityChange(e){
        this.validityDate = e.target.value;
        let dateField = this.template.querySelector("[data-field='dateField']");
        if(this.validityDate == ''){            
            dateField.setCustomValidity("Complete this field.");            
        }
        else{
            if(this.validityDate < this.minDate){
                dateField.setCustomValidity("Please select date later than today.");
            }
            else dateField.setCustomValidity("");  
        }
        dateField.reportValidity();
    }
    handleCustomerNumberChange(e){
        this.custRefNumber = e.target.value;
    }
    handleBookingNumberChange(e){
        this.bookRefNumber = e.target.value;
    }
    @api
    handlecheckBoxSelected(){
        this.errorMsg = '';
    }
    handleAddShipperConsignee(){
        this.displayAddConsigneeModal = true;
        if(this.shipperList.length > 0){
            this.shipperList.forEach()
        }
    }
    hideModalCancelBox(){
        this.displayAddConsigneeModal = false;
        this.consigneeList = [];
        this.shipperList = [];
    }
    hideModalDoneBox(){
        this.displayAddConsigneeModal = false;
    }
    handleConsigneeUpdate(e){
        this.consigneeList = e.detail
    }
    handleShipperUpdate(e){
        this.shipperList = e.detail
        console.log('shipperList '+JSON.stringify(this.shipperList,null,2));
    }
    handleBBMSChange(e){
        this.bbmsJobNumber = e.detail.value
    }
    /*handleAgentProfitShareChange(e){
        this.agentProfitShare = e.detail.value;
    }*/
    handleOperationExecSelection(e){
        this.OperationExec = e.detail.Id
    }
    handleOperationExecRemoved(e){
        this.OperationExec = null
    }
}