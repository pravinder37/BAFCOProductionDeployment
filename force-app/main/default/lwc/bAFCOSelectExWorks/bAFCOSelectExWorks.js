import { LightningElement,track } from 'lwc';
import getExWorksOnLoad from '@salesforce/apex/BAFCOLRoutingDetailsController.getExWorksOnLoad';
export default class BAFCOSelectExWorks extends LightningElement {
    @track exWorksList =[];
    noRecordFound = false;
    errorClass = 'slds-accordion'
    noneSelected = false
    exWorksSearchTerm = '';
    totalRecords = [];
    connectedCallback(){
        this.getExWorksOnLoad();
    }
    hideModalBox(){
        this.dispatchEvent(new CustomEvent('close'));
    }
    getExWorksOnLoad(){
        getExWorksOnLoad()
        .then(result=>{
            console.log('getExWorksOnLoad result'+JSON.stringify(result,null,2));
            if(result != null) {
                this.exWorksList = result;
                this.totalRecords = result;
                let tempvar = JSON.parse(JSON.stringify(this.exWorksList));
                this.exWorksList = tempvar.map(row => ({
                    ...row,
                    displayRow:false,
                    selected:false
                }));
            }
            else this.noRecordFound = true;
        })
        .catch(error=>{
            consol.log('getExWorksOnLoad error'+JSON.stringify(error,null,2));
            this.noRecordFound = true;
        })
    }
    handleDisplayRow(event){
        let id  = event.currentTarget.dataset.id;
        this.exWorksList.forEach(elem =>{
            if(elem.Id == id){
                elem.displayRow = !elem.displayRow;
            }
        })
    }
    handleCheckboxClicked(event){
        this.noneSelected = false;
        this.errorClass = 'slds-accordion'
        let dataId = event.target.value;
        let checked = event.target.checked;
        this.exWorksList.forEach(elem =>{
            if(elem.Id == dataId){
                elem.selected = checked;
            }
            else{
                elem.selected = false
            }
        })
    }

    AddSelectedExWorks(){
        let index = this.exWorksList.findIndex(e=>e.selected == true);
        if(index != -1){
            let tempObj={
                'Name':this.exWorksList[index].Name,
                'Id':this.exWorksList[index].Id,
                'LoadCharge':this.exWorksList[index].Loading_Charge__c,
                'pickup':this.exWorksList[index].Place_of_Pickup__c,
                'LoadingPort':this.exWorksList[index].Port_of_Loading__c,
            }
            const selectedEvent = new CustomEvent('addselected', { detail: {tempObj}});
            this.dispatchEvent(selectedEvent);
        }
        else{
            this.noneSelected = true;
            this.errorClass = 'slds-accordion slds-has-error'
        }
    }
    handleExWorksChange(e){
        this.exWorksSearchTerm = e.target.value;
        if(this.exWorksSearchTerm != '') this.handleSearchClicked();
        else this.handleResetClicked();
    }
    handleResetClicked(){
        this.exWorksSearchTerm = '';
        if(this.totalRecords.length > 0){
            let tempvar = JSON.parse(JSON.stringify(this.totalRecords));
            this.exWorksList = tempvar.map(row => ({
                ...row,
                displayRow:false,
                selected:false
            }));
            this.noRecordFound = false;
        }
        else this.noRecordFound = true;
    }
    handleSearchClicked(){
        if(this.exWorksSearchTerm != '' && this.totalRecords.length > 0){
            let tempList = this.totalRecords.filter(x=>x.Name.toLowerCase().includes(this.exWorksSearchTerm.toLowerCase()))
            if(tempList.length > 0){
                this.exWorksList = tempList.map(row => ({
                    ...row,
                    displayRow:false,
                    selected:false
                }));
                this.noRecordFound = false;
            }else this.noRecordFound = true;
        }else this.noRecordFound = true;
    }
}