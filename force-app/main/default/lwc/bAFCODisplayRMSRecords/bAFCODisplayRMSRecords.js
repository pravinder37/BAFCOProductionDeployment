import { LightningElement,track,wire } from 'lwc';
import getRMSRecords from '@salesforce/apex/BAFCOLeadDetailsController.getRMSRecords';
import { NavigationMixin } from 'lightning/navigation';
export default class BAFCODisplayRMSRecords extends NavigationMixin(LightningElement) {
    @track loadingPort = '';
    @track destinationPort = '';
    @track validity = '';
    @track totalRMSRecords =[];
    @track displayRMSRecords = [];
    @track showServiceChargeModal = false;
    @track rmsId = '';
    @track hasRecord  = false; 
    isLoading = false;
    @track showAddRatesModel = false;
    @track SearchClicked = false

    connectedCallback(){
       document.title='Search Rates'
    }    
    handleValidityChange(e){
        this.validity = e.detail.value;
        let validityField = this.template.querySelector("[data-field='validityField']");
        validityField.setCustomValidity("");
        validityField.reportValidity();
    }
    handleSearchClick(){
        this.isLoading=true;
        this.SearchClicked = true;
        this.getRMSRecords();
    }
    getRMSRecords(){
        this.isLoading = true;
        this.displayRMSRecords = [];
        getRMSRecords({
            loadingPort: this.loadingPort,
            destinationPort:this.destinationPort,
            validity:this.validity
        })
        .then(result=>{
            this.displayRMSRecords = result;            
            if(this.displayRMSRecords.length > 0) this.hasRecord = true;
            else this.hasRecord = false;
            this.isLoading=false;
        })
        .catch(error=>{
            console.log('Error '+JSON.stringify(error))
            this.isLoading=false;
        })
    }
    handleShowServiceCharge(e){
        this.rmsId = e.target.dataset.rmsid;
        this.showServiceChargeModal = true; 
    }
    handleCloseModal(){
        this.rmsId = '';
        this.showServiceChargeModal = false; 
    }
    navigateToRms(e){
        let rmsId = e.target.dataset.rmsid;
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: rmsId,
                actionName: 'view'
            },
        }).then(url => { window.open(url) });
    }
    handleRefreshClick(){
        this.loadingPort = '';
        this.destinationPort = '';
        this.validity = '';
        this.SearchClicked = false
    }
    handleAddRateClicked(){
        this.showAddRatesModel = true;
    }
    handlePortSelection(e){
        console.log('event '+JSON.stringify(e.detail))
        this.loadingPort = e.detail.Name;
    }
    handlePortRemoved(e){
        this.loadingPort = '';
    }
    handleCloseAddRates(){
        this.rmsId = '';
        this.showAddRatesModel = false
    }
    handleDestinationSelection(e){
        this.destinationPort = e.detail.Name;
    }
    handleDestinationRemoved(e){
        this.destinationPort = ''
    }
    handleSuccessAddRate(e){
        console.log('event '+JSON.stringify(e.detail.disPatchObj,null,2))
        this.showAddRatesModel = false;
        this.SearchClicked = true;
        let successData = e.detail.disPatchObj;        
        this.loadingPort = successData.loadingPort;
        this.destinationPort = successData.loadingDestination;
        this.validity = successData.validity;
        let defaulLoadingPort = {Id:successData.loadingPortId,Name:this.loadingPort}
        let defaultLoadingDestination = {Id:successData.loadingDestinationId,Name:this.destinationPort}
       if(successData.loadingPortId != ''){
            let laodingPortField = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[0]
            if(laodingPortField != null || laodingPortField != undefined) laodingPortField.handleDefaultSelected(defaulLoadingPort); 
        }        
        if(successData.loadingDestinationId != ''){
            let defaultLoadingDestinationField = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[1]
            if(defaultLoadingDestinationField != null || defaultLoadingDestinationField != undefined) defaultLoadingDestinationField.handleDefaultSelected(defaultLoadingDestination);
        } 
        this.getRMSRecords();
    }
    refreshClicked(){
        this.SearchClicked = false;
        let laodingPortField = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[0]
        laodingPortField.handleRemovePill(); 
        let defaultLoadingDestinationField = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[1]
        defaultLoadingDestinationField.handleRemovePill();
        this.validity = '';
    }
    CopyRms(e){
        this.rmsId = e.target.dataset.rmsid;
        console.log('** this.rmsId '+this.rmsId)
        this.showAddRatesModel = true;
    }
    resetClicked(){
        location.reload();
    }
}