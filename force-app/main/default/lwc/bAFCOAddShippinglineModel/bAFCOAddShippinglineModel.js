import { LightningElement,track,api } from 'lwc';
import getShipline from '@salesforce/apex/BAFCOLRoutingDetailsController.getShipline';
import getAirLine from '@salesforce/apex/BAFCOAirEnquiryController.getAirLine';
export default class BAFCOAddShippinglineModel extends LightningElement {
    @track shiplineOption = [];
    @track shiplineOption2 = [];
    @track selectedShippLine = '';
    @api isAir;
    @track submitBtnLabel = 'Add Shippline';
    @track airPopup = false;
    closeModal(){
        this.dispatchEvent(new CustomEvent('close'));
    }
    connectedCallback(){
        if(this.isAir =='true') {
            this.airPopup = true;
            this.getAirLine();
            this.submitBtnLabel = 'Add Airline';
        }
        else {
            this.airPopup = false;
            this.getShipline();
            this.submitBtnLabel = 'Add Shippline';
        }
    }
    getShipline(){
        getShipline()
        .then(result =>{
            //this.shiplineOption = result;            
            let templist = [];
           result.forEach(m => {
            templist.push({
                label: m.Name, value: m.Name
            })
           });
            //this.shiplineOption = templist;
            //console.log('res '+JSON.stringify(this.shiplineOption))
            let middleIndex = Math.ceil(templist.length / 2);
            let firstHalf = templist.splice(0, middleIndex);   
            let secondHalf = templist.splice(-middleIndex);
            this.shiplineOption = firstHalf;
            this.shiplineOption2 = secondHalf;

        })
        .catch(error =>{
            console.log('get shippLine Error '+JSON.stringify(error,null,2))
        });
    }
    handleSelectedShippline(e){
        this.selectedShippLine = e.target.value;
    }
    addShippLine(){
        this.dispatchEvent(new CustomEvent('addshippline', { detail: this.selectedShippLine }));
    }
    getAirLine(){
        getAirLine()
        .then(result =>{
            //this.shiplineOption = result;            
            let templist = [];
           result.forEach(m => {
            templist.push({
                label: m.Name, value: m.Name
            })
           });
            //this.shiplineOption = templist;
            //console.log('res '+JSON.stringify(this.shiplineOption))
            let middleIndex = Math.ceil(templist.length / 2);
            let firstHalf = templist.splice(0, middleIndex);   
            let secondHalf = templist.splice(-middleIndex);
            this.shiplineOption = firstHalf;
            this.shiplineOption2 = secondHalf;

        })
        .catch(error =>{
            console.log('get airline Error '+JSON.stringify(error,null,2))
        });
    }
}