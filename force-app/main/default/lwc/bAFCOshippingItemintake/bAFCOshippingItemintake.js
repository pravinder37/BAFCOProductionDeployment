import { LightningElement,api } from 'lwc';

export default class BAFCOshippingItemintake extends LightningElement {
    @api seaFreightBuying;
    @api containerCollectionBuying;
    @api liftOnOffBuying;
    @api loadingTransportationBuying;
    @api customClearanceBuying;
    @api portShuttlingBuying;
    @api seaFreightSelling;
    @api containerCollectionSelling;
    @api liftOnOffSelling;
    @api loadingTransportationSelling;
    @api customClearanceSelling;
    @api portShuttlingSelling;
    @api shippingList;
    @api indexVar;

    handleSeaFreightBuy(e){
        this.seaFreightBuying = e.target.value;
        this.updateDto();
    }
    handleSeaFreightSell(e){
        this.seaFreightSelling = e.target.value;
        this.updateDto();
    }
    handlecontainerBuy(e){
        this.containerCollectionBuying = e.target.value;
        this.updateDto();
    }
    handlecontainerSell(e){
        this.containerCollectionSelling = e.target.value;
        this.updateDto();
    }
    handleLiftBuy(e){
        this.liftOnOffBuying = e.target.value;
        this.updateDto();
    }
    handleLiftSell(e){
        this.liftOnOffSelling = e.target.value;
        this.updateDto();
    }
    handletransportBuy(e){
        this.loadingTransportationBuying = e.target.value;
        this.updateDto();
    }
    handletransportSell(e){
        this.loadingTransportationSelling = e.target.value;
        this.updateDto();
    }
    handleCustomBuy(e){
        this.customClearanceBuying = e.target.value;
        this.updateDto();
    }
    handleCustomSell(e){
        this.customClearanceSelling = e.target.value;
        this.updateDto();
    }
    handlePortBuy(e){
        this.portShuttlingBuying = e.target.value;
        this.updateDto();
    }
    handlePortSell(e){
        this.portShuttlingSelling = e.target.value;
        this.updateDto();
    }
    updateDto(){
        this.shippingList = {
            ...this.shippingList,
            'seaFreightBuying':this.seaFreightBuying,
            'containerCollectionBuying':this.containerCollectionBuying,
            'liftOnOffBuying':this.liftOnOffBuying,
            'loadingTransportationBuying':this.loadingTransportationBuying,
            'customClearanceBuying':this.customClearanceBuying,
            'portShuttlingBuying':this.portShuttlingBuying,
            'seaFreightSelling':this.seaFreightSelling,
            'containerCollectionSelling':this.containerCollectionSelling,
            'liftOnOffSelling':this.liftOnOffSelling,
            'loadingTransportationSelling':this.loadingTransportationSelling,
            'customClearanceSelling':this.customClearanceSelling,
            'portShuttlingSelling':this.portShuttlingSelling

        };
        let shippingEntry = JSON.parse(JSON.stringify(this.shippingList));
        this.dispatchEvent(new CustomEvent('update', { detail: { shippingList: shippingEntry } }));
    }

}