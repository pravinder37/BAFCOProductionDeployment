import { LightningElement,api,track } from 'lwc';
import getRMSDetail from '@salesforce/apex/BAFCOshippingLineChargesController.getRMSDetail';
import { NavigationMixin } from 'lightning/navigation';
export default class BAFCOServiceChargesHelpComponent extends NavigationMixin(LightningElement) {
    @api rmsId;
    @track shippingChargesData = [];
    @track incoChargesList = [];
    @track destinationChargesList = [];
    @track rmsName = '';
    @track seaFreight;
    @api isAir ;
    BAFValue;
    BunkerSurchargeValue;
    ISPSValue;
    OTHCValue;
    SealChargesValue;
    CMCValue;
    EICValue;
    DTHCValue;
    TotalValue;
     
    @track  isLoading= false;
    @track shipLine = {};
    @track shippingLineName = '';
    @track airLineName = '';
    @track rateKg ;

    connectedCallback(){
        console.log('rmsId',this.rmsId);
        //this.getShippingCharges();
        //this.getIncoCharges(); 
       // this.getDestintionCharges();
        this.getRMSDetail();       
    }
    getRMSDetail(){
        this.isLoading = true;
        getRMSDetail({rmsRecordId : this.rmsId})
        .then(result=>{
            //console.log('getRMSDetail result', JSON.stringify(result,null,2));
            this.BAFValue=result.shipCharges.BAF;
            this.BunkerSurchargeValue=result.shipCharges.BunkerSurcharge;
            this.ISPSValue=result.shipCharges.ISPS;
            this.OTHCValue=result.shipCharges.OTHC;
            this.SealChargesValue=result.shipCharges.sealCharges;
            this.CMCValue=result.shipCharges.CMC;
            this.EICValue=result.shipCharges.EIC;
            this.DTHCValue=result.shipCharges.DTHC;
            this.TotalValue=result.shipCharges.Total;
            this.shipLine = result.shipCharges;
            this.incoChargesList = result.originCharge;
            this.destinationChargesList = result.destinationCharge;
            this.rmsName = result.rmsName;
            this.seaFreight = result.seaFreight;
            this.shippingLineName = result.shippingLineName
            this.rateKg = result.rateKg;
            this.airLineName = result.airLine
            this.isLoading = false;
        })
        .catch(error=>{
            this.isLoading = false;
            console.error('getRMSDetail error', JSON.stringify(error));
        })
    }

    /*getShippingCharges(){
        this.isLoading = true;
        getClassification({rmsRecordId : this.rmsId})
            .then((result) => {
                console.log('result',result.BAF);
                this.BAFValue=result.BAF;
                this.BunkerSurchargeValue=result.BunkerSurcharge;
                this.ISPSValue=result.ISPS;
                this.OTHCValue=result.OTHC;
                this.SealChargesValue=result.sealCharges;
                this.CMCValue=result.CMC;
                this.EICValue=result.EIC;
                this.DTHCValue=result.DTHC;
                this.TotalValue=result.Total;
                this.shipLine = result;
                this.isLoading = false;

            })
            .catch((error) => {
                this.isLoading = false;
                console.error('getShippingCharges in BAFCOServiceChargesHelpComponent error', JSON.stringify(error));
            });
    }*/
    /*getIncoCharges(){
        this.isLoading = true;
        getIncoCharges({rmsRecordId : this.rmsId})
        .then((result) => {
            console.log('result inco '+JSON.stringify(result,null,2))
            this.isLoading = false;
            this.incoChargesList = result;
        })
        .catch((error) => {
            this.isLoading = false;
            console.error('getShippingCharges ', JSON.stringify(error));
        });
    }*/
    /*getDestintionCharges(){
        this.isLoading = true;
        getDestintionCharges({rmsRecordId : this.rmsId})
        .then((result) => {
            console.log('result getDestintionCharges '+JSON.stringify(result,null,2))
            this.isLoading = false;
            this.destinationChargesList = result;
        })
        .catch((error) => {
            this.isLoading = false;
            console.error('getDestintionCharges ', JSON.stringify(error));
        });
    }*/

    handleModalClose() {
        this.dispatchEvent(new CustomEvent('close'));
    }
    handleRmsNameClicked(){
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.rmsId,
                actionName: 'view'
            },
        }).then(url => { window.open(url) });
    }
}