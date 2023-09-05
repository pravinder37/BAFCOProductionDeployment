import { LightningElement,api,wire,track } from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import getRouteRouteDetails from '@salesforce/apex/BAFCOOptyRateProcumentController.getRouteRouteDetails';
export default class BAFCOOptyRateProcument extends LightningElement {
    @api recordId = '';
    @track routeList = [];
    @track isLoading = false;
    @track showProcument = false;
    @track portLoading = '';
    @track commodity = '';
    @track shippingEquipTabSelected ='';
    @track portDestination = '';
    @track routeId = '';
    @track cameFromImport = 'false';
    @track hasRecord = false;
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
        }
    }
    connectedCallback(){
        console.log('record itd '+this.recordId);
        this.getRouteRouteDetails();
    }
    getRouteRouteDetails(){
        this.isLoading = true;
        getRouteRouteDetails({optyId : this.recordId})
        .then(result=>{
            console.log('getRouteRouteDetails '+JSON.stringify(result,null,2));
            this.routeList = result;
            if(this.routeList.length > 0) this.hasRecord = true;
            this.isLoading = false;
        })
        .catch(error=>{
            console.log('getRouteRouteDetails error'+JSON.stringify(error,null,2));
            this.isLoading = false;
        })
    }
    handleToggleSection(e){}
    handleQuickActionClicked(e){
        let routeId = e.currentTarget.dataset.id;
        let index = this.routeList.findIndex(x=>x.routeId == routeId)
        this.portLoading = this.routeList[index].portLoading;
        this.commodity = this.routeList[index].commodity;
        this.shippingEquipTabSelected = this.routeList[index].equipmentType;
        this.portDestination = this.routeList[index].portDischarge;
        this.quantity = this.routeList[index].quantity;
        this.routeId = routeId;
        this.cameFromImport = this.routeList[index].cameFromImport;
        console.log('routeId '+this.routeId);
        this.showProcument = true;
    }
    handleCloseProcurement(){
        this.showProcument = false;
    }
}