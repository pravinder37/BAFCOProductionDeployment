import { LightningElement,track } from 'lwc';
//import getAgentsRecords from '@salesforce/apex/BAFCOImportQuoteController.getAgentsRecords';
export default class BAFCOImportAddAgent extends LightningElement {

    selectedAgent='';
    selectedAgentName='';
    selectedAgentError ='';
    @track agentOption= [];
    @track agentOption2 =[];
    @track totalList = [];
    closeModal(){
        this.dispatchEvent(new CustomEvent('close'));
    }
    addAgent(){
        if(this.selectedAgent){
            let obj={
                'Name':this.selectedAgentName,
                'Id':this.selectedAgent
            }
            this.dispatchEvent(new CustomEvent('addagent', { detail: obj }));
        }else{
            this.selectedAgentError = 'slds-has-error'
        }
    }
    handleAgentSelection(e){
        this.selectedAgent = e.detail.Id;
        this.selectedAgentName = e.detail.Name;
        this.selectedAgentError = ''
    }
    handleAgentRemoved(e){
        this.selectedAgent = '';
        this.selectedAgentName = '';
        this.selectedAgentError = 'slds-has-error'
    }
}