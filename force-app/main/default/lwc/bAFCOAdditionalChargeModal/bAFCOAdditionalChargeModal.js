import { LightningElement, track, wire } from 'lwc';
export default class BAFCOAdditionalChargeModal extends LightningElement {
    @track selectedCharges ;
    closeModal(){
        this.dispatchEvent(new CustomEvent('close'));
    }
    selectedRecords(event){
        console.log('event.detail '+JSON.stringify(event.detail))
        this.selectedCharges = event.detail.selRecords
    }
    handleAddSelected(){
        let selRecords = this.selectedCharges;
        const selectedEvent = new CustomEvent('addselected', { detail: {selRecords}});
        this.dispatchEvent(selectedEvent);
    }
}