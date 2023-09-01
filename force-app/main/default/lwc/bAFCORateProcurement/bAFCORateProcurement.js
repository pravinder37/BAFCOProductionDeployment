import { LightningElement,api,track} from 'lwc';
import createRateProcument from '@salesforce/apex/BAFCOLRoutingDetailsController.createRateProcument';
import getRouteEquipType from '@salesforce/apex/BAFCOLRoutingDetailsController.getRouteEquipType';
export default class BAFCORateProcurement extends LightningElement {
    disableWhatsApp = false;
    disableFollowUp = true;
    @api portLoading = '';
    @api commodity ='';
    //@api shippingLine = '';
    @api portDischarge='';
    @api quantity = '';
    @api routeId;
    @api enquiryId;
    @api cameFromImport = false;
    @track agentName = '';
    @track procurementShippingLine = '';
    @track equipmentType = '';
    @track pickListvalues=[];
    hideModalBox(){
        this.dispatchEvent(new CustomEvent('close'));
    }
  handleprocurementShippingLineChange(e){
      this.procurementShippingLine = e.detail.Id;
      this.disableFollowUp = false;
  }
  handleShippRemoved(e){
    this.procurementShippingLine = '';
    this.disableFollowUp = true;
  }
    handleCopyClicked(){
       this.getRouteEquipType();
    }
    handleCreateFollowUpClicked(){
      //  this.disableFollowUp = true;
      console.log('agentName '+this.agentName)
      console.log('this.procurementShippingLine '+this.procurementShippingLine)
      createRateProcument({
        portLoading: this.portLoading,
        commodity : this.commodity,
        shippingLine : this.procurementShippingLine,
        portDischarge: this.portDischarge,
        quantity: this.quantity,
        enquiryId:this.enquiryId,
        routeId:this.routeId,
        agentName:this.agentName
       })
       .then(result=>{
        this.disableFollowUp = true;
        console.log('result',result)
       })
       .catch(error=>{
        console.log('error ',JSON.stringify(error))
       })
    }
    getRouteEquipType(){
        getRouteEquipType({routeId : this.routeId})
        .then(result =>{
            //console.log('getRouteEquipType '+JSON.stringify(result,null,2));
            let temp = [];
            result.forEach(element => {
                temp.push({
                    label : element.Equipment_Type__r.Name,
                    value:element.Equipment_Type__r.Name
                })
            });
            this.pickListvalues = temp;
            this.equipmentType = temp[0].value;

            let content = 'Greetings from BAFCO International,\n\nPlease provide ocean rates for below:\n\n';
            content=content+'Port Of Loading: '+this.portLoading;
            content=content+'\nPort Of Discharge: '+this.portDischarge;
            content=content+'\nEquipment: '+this.equipmentType;
            content=content+'\nCommodity: '+this.commodity;
            content=content+'\nVolume: '+(this.quantity > 0 ? this.quantity : '');
            content=content+'\n\nYour earliest response is highly appreciated.';
            
            if (navigator.clipboard && window.isSecureContext) {
             return navigator.clipboard.writeText(content);
             } else {
                 let textArea = document.createElement("textarea");
                 textArea.value = content;
                 textArea.style.position = "fixed";
                 textArea.style.left = "-999999px";
                 textArea.style.top = "-999999px";
                 document.body.appendChild(textArea);
                 textArea.focus();
                 textArea.select();
                 return new Promise((res, rej) => {
                 document.execCommand("copy") ? res() : rej();
                 textArea.remove();
                 this.disableWhatsApp = true;
                 });
             }


        })
        .catch(error =>{
            console.log('get equip Error '+JSON.stringify(error))
        })
    }
    handleAgentChange(e){
        this.agentName = e.detail.Id
    }
    handleAgentRemoved(e){
        this.agentName = '';
    }
}