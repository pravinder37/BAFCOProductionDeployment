import { LightningElement } from 'lwc';

export default class BAFCOUnableToSubmit extends LightningElement {
    stopPropagation(e) {
        e.stopPropagation();
    }
    handleModalClose() {
        this.dispatchEvent(new CustomEvent('close'));
    }
}