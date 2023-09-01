import { LightningElement,api } from 'lwc';

export default class BAFCODestinChargeSection extends LightningElement {
    @api sellingdestinBayanCharges;
    @api sellingdestinCustomClearanceCharges;
    @api sellingdestinDOCharges;
    @api sellingdestinFasahCharges;
    @api sellingdestinGatePassCharges;
    @api sellingdestinLOLOCharges;
    @api sellingdestinTransPortationCharges;
    @api sellingdestinTotalCharges;
    @api destinBayanCharges;
    @api destinCustomClearanceCharges;
    @api destinDOCharges;
    @api destinFasahCharges;
    @api destinGatePassCharges;
    @api destinLOLOCharges;
    @api destinTransPortationCharges;
    @api destinTotalCharges;
    @api DestinTotalChanged= false;
    @api displayDestinCharges = false;

    handleDestinBayanChargeChange(e){
        this.destinBayanCharges = e.target.value;
        const selectedEvent = new CustomEvent('handledestinbayanchargechange', { detail: this.destinBayanCharges });
        this.dispatchEvent(selectedEvent);
    }
    handleDestinSellingBayanChargeChange(e){
        this.sellingdestinBayanCharges = e.target.value;
        const selectedEvent = new CustomEvent('handledestinsellingbayanchargechange', { detail: this.sellingdestinBayanCharges });
        this.dispatchEvent(selectedEvent);
    }
    handleDestinCustomClearanceChargeChange(e){
        this.destinCustomClearanceCharges = e.target.value;
        const selectedEvent = new CustomEvent('handledestincustomclearancechargechange', { detail: this.destinCustomClearanceCharges });
        this.dispatchEvent(selectedEvent);
    }
    handleDestinSellingCustomClearanceChargeChange(e){
        this.sellingdestinCustomClearanceCharges = e.target.value;
        const selectedEvent = new CustomEvent('handledestinsellingcustomclearancechargechange', { detail: this.sellingdestinCustomClearanceCharges });
        this.dispatchEvent(selectedEvent);
    }
    handleDestinDOChargeChange(e){
        this.destinDOCharges = e.target.value;
        const selectedEvent = new CustomEvent('handledestindochargechange', { detail: this.destinDOCharges });
        this.dispatchEvent(selectedEvent);
    }
    handleDestinSellingDOChargeChange(e){
        this.sellingdestinDOCharges = e.target.value;
        const selectedEvent = new CustomEvent('handledestinsellingdochargechange', { detail: this.sellingdestinDOCharges });
        this.dispatchEvent(selectedEvent);
    }
    handleDestinFasahChargeChange(e){
        this.destinFasahCharges = e.target.value;
        const selectedEvent = new CustomEvent('handledestinfasahchargechange', { detail: this.destinFasahCharges });
        this.dispatchEvent(selectedEvent);
    }
    handleSellingDestinFasahChargeChange(e){
        this.sellingdestinFasahCharges = e.target.value;
        const selectedEvent = new CustomEvent('handlesellingdestinfasahchargechange', { detail: this.sellingdestinFasahCharges });
        this.dispatchEvent(selectedEvent);
    }
    handleDestinGatePassChange(e){
        this.destinGatePassCharges = e.target.value;
        const selectedEvent = new CustomEvent('handledestingatepasschange', { detail: this.destinGatePassCharges });
        this.dispatchEvent(selectedEvent);
    }
    handleSellingDestinGatePassChange(e){
        this.sellingdestinGatePassCharges = e.target.value;
        const selectedEvent = new CustomEvent('handlesellingdestingatepasschange', { detail: this.sellingdestinGatePassCharges });
        this.dispatchEvent(selectedEvent);
    }
    handleDestinLOLOChargeChange(e){
        this.destinLOLOCharges = e.target.value;
        const selectedEvent = new CustomEvent('handledestinlolochargechange', { detail: this.destinBayanCharges });
        this.dispatchEvent(selectedEvent);
    }
    handleSellingDestinLOLOChargeChange(e){
        this.sellingdestinLOLOCharges = e.target.value;
        const selectedEvent = new CustomEvent('handlesellingdestinlolochargechange', { detail: this.sellingdestinLOLOCharges });
        this.dispatchEvent(selectedEvent);
    }
    handleDestinTansPortationChange(e){
        this.destinTransPortationCharges = e.target.value;
        const selectedEvent = new CustomEvent('handledestintansportationchange', { detail: this.destinTransPortationCharges });
        this.dispatchEvent(selectedEvent);
    }
    handleSellingDestinTansPortationChange(e){
        this.sellingdestinTransPortationCharges = e.target.value;
        const selectedEvent = new CustomEvent('handlesellingdestintansportationchange', { detail: this.sellingdestinTransPortationCharges });
        this.dispatchEvent(selectedEvent);
    }
    handleSellingDestinTotalChange(e){
        this.sellingdestinTotalCharges = e.target.value;
        const selectedEvent = new CustomEvent('handlesellingdestintotalchange', { detail: this.sellingdestinTotalCharges });
        this.dispatchEvent(selectedEvent);
    }
}