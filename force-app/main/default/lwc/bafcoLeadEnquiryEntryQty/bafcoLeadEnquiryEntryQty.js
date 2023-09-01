import { LightningElement,api } from 'lwc';

export default class BafcoLeadEnquiryEntryQty extends LightningElement {
    @api index;
    @api containerType;
    @api quantity;
    @api contr;
    @api containerTypeName;
    @api containerTypeErrorClass = '';
    @api containerQuantityErrorClass = '';
    @api cameFromAddRate = false
    @api isEdit;
    connectedCallback(){
        if(this.cameFromAddRate == 'true' && this.containerType != ''){
            setTimeout(() => {
                let field = this.template.querySelector('c-b-a-f-c-o-custom-look-up-component');
                let Obj={Id:this.containerType,Name:this.containerTypeName,index:this.index}
                if(field != undefined) field.handleDefaultSelected(Obj);
            }, 100);
        }
        else if(this.isEdit =='true' && this.containerType !=''){
            setTimeout(() => {
                let field = this.template.querySelector('c-b-a-f-c-o-custom-look-up-component');
                let Obj={Id:this.containerType,Name:this.containerTypeName,index:this.index}
                if(field != undefined) field.handleDefaultSelected(Obj);
            }, 100);
        }
    }
    handleContainerTypeSelection(event){
        console.log('came '+JSON.stringify(event.detail))
        let index = event.detail.index;
        let containerTypeID = event.detail.Id;
        let containerTypeName = event.detail.Name;
        this.containerTypeErrorClass = '';
        let obj={
            'index':index,
            'containerTypeID':containerTypeID,
            'containerTypeName':containerTypeName
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('containertypeupdate', { detail: { dto: containerDto } }));
    }
    handleContainerTypeRemoved(e){
        let index = e.detail.index;
        let obj={
            'index':index,
            'containerTypeID':'',
            'containerTypeName':'',
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('containertypeupdate', { detail: { dto: containerDto } }));
    }
    handleQuantityChange(e){
        let index = e.target.dataset.recordId;
        this.containerQuantityErrorClass = '';
        let quantityValue = e.detail.value;
        let obj={
            'index':index,
            'quantity':quantityValue,
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('containerqtyupdate', { detail: { dto: containerDto } }));
    }
    handleRemoveContainer(e){
        let strIndex = e.target.dataset.recordId;
        this.dispatchEvent(new CustomEvent('removecontainertype', { detail:  strIndex}));
    }
    @api handleCopyData(containerRecord,i){
        console.log('# containerRecord' +JSON.stringify(containerRecord,null,2))
        let containerType = containerRecord.containerType;
        let quantity =  containerRecord.quantity;
        let containerTypeName =  containerRecord.containerTypeName;
        let initalIndex = containerRecord.index;
        let spitInitalIndex = initalIndex.split('.');
        let cameIndex = i;
        let finalIndex = cameIndex+'.'+spitInitalIndex[1]
        if(containerType != ''){
            let field = this.template.querySelector('c-b-a-f-c-o-custom-look-up-component');
            let Obj={Id:containerType,Name:containerTypeName,index:finalIndex}
            if(field != null) field.handleDefaultSelected(Obj);
        }
       let obj={
            'index':finalIndex,
            'quantity':quantity,
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('containerqtyupdate', { detail: { dto: containerDto } }));
        setTimeout(() => {
            let quantityField = this.template.querySelector("[data-field='quantityField']");
            quantityField.value = quantity
        }, 100);
    }
}