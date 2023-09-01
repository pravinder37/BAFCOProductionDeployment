import { LightningElement,api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class BAFCOOrderAddConsignee extends NavigationMixin(LightningElement) {
    @track consigneeList=[];
    consigneeIndex =0
    @api parentConsigneeList = [];
    @track consigneeDisplayName = '';
    @track consigneeId = '';
    @track dispalayAccountDetails = false;
    connectedCallback(){
        if(this.parentConsigneeList.length > 0){
            this.consigneeList = JSON.parse(JSON.stringify(this.parentConsigneeList))
            //this.assignDefault();
            if(this.consigneeList[0].consigneeId != null){
                this.consigneeDisplayName = this.consigneeList[0].consigneeName;
                this.consigneeId = this.consigneeList[0].consigneeId
            }
        }
        /*else{
            this.consigneeIndex =  0
            this.addConsignee();
        }*/
    }
   /* addConsignee(){
        let consigneeObj = {
            'consigneeId':null,
            'consigneeName':null,
            'index':this.consigneeIndex++
        }
        if(this.consigneeList.length < 3)
        this.consigneeList.push(consigneeObj);
        this.dispatchUpdate();
    }
    handleConsigneeSelection(e){
        let index  = e.detail.index;
        let consigneeIndex = this.consigneeList.findIndex(x=>x.index == index)
        if(consigneeIndex != -1){
            this.consigneeList[consigneeIndex].consigneeId = e.detail.Id;
            this.consigneeList[consigneeIndex].consigneeName = e.detail.Name;
        }
        this.dispatchUpdate();
    }
    handleConsigneeRemoved(e){
        let index  = e.detail.index;
        let consigneeIndex = this.consigneeList.findIndex(x=>x.index == index)
        if(consigneeIndex != -1){
            this.consigneeList[consigneeIndex].consigneeId = null;
            this.consigneeList[consigneeIndex].consigneeName = null;
        }
        this.dispatchUpdate();
    }
    handleRemoveConsignee(e){
        let index = e.target.dataset.recordId;
        let consigneeIndex = this.consigneeList.findIndex(x=>x.index == index)
        if(consigneeIndex != -1){
            this.consigneeList.splice(consigneeIndex,1)
        }
        this.assignDefault();
        this.dispatchUpdate();
    }
    dispatchUpdate(){
        let consigneeList = JSON.parse(JSON.stringify(this.consigneeList));
        this.dispatchEvent(new CustomEvent('consigneeupdate', { detail: consigneeList }));
    }
    assignDefault(){
        setTimeout(() => {
            for(let i = 0; i<this.consigneeList.length; i++){
                let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[i];
                if(this.consigneeList[i].consigneeId != null){
                    let Obj = {Id:this.consigneeList[i].consigneeId,Name:this.consigneeList[i].consigneeName}
                    if(field != undefined) field.handleDefaultSelected(Obj)
                }
            }
        }, 100);
    }*/
    handleNameClicked(){
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.consigneeId,
                actionName: 'view'
            },
        }).then(url => { window.open(url) });
    }
    handleDisplayAccountDetails(){
        this.dispalayAccountDetails = true;
    }
    handleHideAccountDetails(){
        this.dispalayAccountDetails = false;
    }
}