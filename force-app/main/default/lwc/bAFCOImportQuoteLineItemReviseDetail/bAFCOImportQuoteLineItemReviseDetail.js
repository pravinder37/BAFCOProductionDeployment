import { LightningElement,api,track } from 'lwc';
import getQuoteLineItemDetails from '@salesforce/apex/BAFCOImportQuotationReviseController.getQuoteLineItemDetails';
export default class BAFCOImportQuoteLineItemReviseDetail extends LightningElement {
    @api routeName;
    @api routingRegular;
    @api shipmentKind;
    @api serviceType;
    @api portLoading;
    @api portDestination;
    @api shippingLine;
    @api commodity;
    @api cargoWeights;
    @api dangerousGoods;
    @api remarks;
    @api routeId;
    @api pickupPlaceName = '';
    @api dischargePlaceName = '';
    @track quoteLineItemList = [];
    @track quoteLineItemMap = [];
    @api activeQuoteId = '';
    @track routlistNotfound = false;
    @track shippingEquipTabSelected = '';
    @track shippingTabSelected ='';
    @track buyingRate ;
    @track sellingRate;
    @track profitLabel;
    @track margin;
    @track quotationMap=[];
    @track showServiceChargeModal = false;
    @track rmsId = '';
    @track agentName = '';
    @track quotationDate ='';
    @api equipmentType ='';
    @api cargoReadiness = '';
    @track currencyCode='USD';
    @track displaycheckRate = false;
    @track itemId = '';
    @track buyingChargesIncluded ='';
    @track sellingChargesIncluded = '';
    connectedCallback(){
        this.getQuoteLineItemDetails();
    }
    getQuoteLineItemDetails(){
        getQuoteLineItemDetails({
            quoteId : this.activeQuoteId,
            portLoading : this.portLoading,
            portDestination : this.portDestination,
            commodity : this.commodity,
            routeId : this.routeId
        })
        .then(result=>{
            if(Object.keys(result).length == 0){
                this.routlistNotfound = true;
            }
            else{
                this.routlistNotfound = false;
                let conts = result;
                this.quoteLineItemMap = result;
                for(let key in conts){
                    let tempList = [];
                    for(let key2 in conts[key]){
                        tempList.push({
                            key2:key2,
                            value2: conts[key][key2]})
                    }
                    this.quoteLineItemList.push({value:tempList, key:key});
                }
                this.shippingEquipTabSelected = this.quoteLineItemList[0].value[0].value2[0].equipmentName;
                this.shippingTabSelected = this.quoteLineItemList[0].value[0].key2;
            }
        })
        .catch(error=>{
            console.log('getQuoteLineItemDetail error',JSON.stringify(error))
            
        })
    }
    handleAgentActive(e){
        this.agentName = e.target.value
        let dedicatedObj = this.quoteLineItemMap[this.agentName];
        let templist = [];
        for(let key in dedicatedObj){
            templist.push({key:key, data: dedicatedObj[key]})
        }
        let elem = 0;
        this.shippingTabSelected = templist[elem].key;
        let data =templist[elem].data;
        this.shippingEquipTabSelected = data[elem].equipmentName; 
        let totalSelling = 0;
        if(data[elem].totalSellingRate > 0) totalSelling=totalSelling+data[elem].totalSellingRate;
        this.buyingRate = data[elem].totalBuyingRate;
        this.sellingRate = totalSelling;
        this.quotationDate = data[elem].quotationDate;
        this.currencyCode = data[elem].currencyCode;
        this.handleUpdateCalculation();
    }
    handleshippingLineActive(e){
        this.shippingTabSelected = e.target.value
        let dedicatedObj = this.quoteLineItemMap[this.agentName];
        let templist = [];
        for(let key in dedicatedObj){
            templist.push({key:key, data: dedicatedObj[key]})
        }
        let data = [];
        templist.forEach(elem=>{
            if(elem.key == this.shippingTabSelected){
                data= elem.data
            }
        })
        let elem  = 0;
        this.shippingEquipTabSelected  =  data[elem].equipmentName;
        let totalSelling = 0;
        if(data[elem].totalSellingRate > 0) totalSelling=totalSelling+data[elem].totalSellingRate;
        this.buyingRate = data[elem].totalBuyingRate;
        this.quotationDate = data[elem].quotationDate;
        this.currencyCode = data[elem].currencyCode
        this.sellingRate = totalSelling;
        this.handleUpdateCalculation();
    }
    handleEquipmentActive(e){
        let profitButton =  this.template.querySelector('.profitButton');
        if(profitButton != undefined){
            profitButton.style = "background:#FF9800;height: 50px;border-radius: 4px;"
        }
        this.shippingEquipTabSelected = e.target.value
        let dedicatedObj = this.quoteLineItemMap[this.agentName];
        console.log('dedicatedObj '+JSON.stringify(dedicatedObj,null,2))
        let templist = [];
        for(let key in dedicatedObj){
            templist.push({key:key, data: dedicatedObj[key]})
        }
        let data = [];
        templist.forEach(elem=>{
            if(elem.key == this.shippingTabSelected){
                data= elem.data
            }
        })
        let equipIndex = data.findIndex(x=>x.equipmentName == this.shippingEquipTabSelected)
        if(equipIndex != -1){
            let totalSelling = 0;
            if(data[equipIndex].totalSellingRate > 0) totalSelling = totalSelling + data[equipIndex].totalSellingRate;
            this.buyingRate = data[equipIndex].totalBuyingRate;
            this.quotationDate = data[equipIndex].quotationDate;
            this.sellingRate =totalSelling;
            this.rmsId = data[equipIndex].rmsId;
            this.currencyCode = data[equipIndex].currencyCode;
        }
        this.handleUpdateCalculation();
    }
    handleShowServiceCharge(){
        this.showServiceChargeModal = true; 
    }
    handleCloseModal(){
        this.showServiceChargeModal = false; 
    }
    @api handleUpdateCalculation(){
        let profit = 0;
        if(this.sellingRate > 0 && !isNaN(this.sellingRate)){
        profit = this.sellingRate - this.buyingRate;
        let margin  = profit/this.sellingRate;
        this.margin = isNaN(margin) ? 0 : margin * 100;
        this.margin = this.margin.toFixed(2);
        profit = isNaN(profit) ? 0 : profit;
        }
        else if(this.sellingRate <= 0 && isNaN(this.sellingRate)){
            this.margin = 0;
            profit = 0;
        }
        this.profitLabel = this.currencyCode+' '+profit +' Profit.';
        setTimeout(() => {
            let profitButton =  this.template.querySelector('.profitButton');
            if(profitButton != undefined){
                if(profit > 0){
                    profitButton.style = "background:#4CAF50;height: 50px;border-radius: 4px;"
                }
                else{
                    profitButton.style = "background:#FF9800;height: 50px;border-radius: 4px;"
                }
            }
        }, 100);
        if(this.quotationMap.length == 0 ){
            let tempList = [];
            let value = [];
            value.push({
                key: this.agentName+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected+'-'+this.routeName,
                sellingRate : parseInt(this.sellingRate) ,
                equipmentName: this.agentName+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected,
                profit : parseInt(profit),
                margin :  parseInt(this.margin),
                validity : this.validity,
                quantity : this.quantity,
                currencyCode : this.currencyCode,
                cssClass :'',
                displayeEquip : this.sellingRate > 0 ? true:false
            })
            tempList.push({key:this.routeName,value:value})
            this.quotationMap = JSON.parse(JSON.stringify(tempList)); 
        }else{
            let quoteMap = JSON.parse(JSON.stringify(this.quotationMap));
            let index = quoteMap.findIndex(x=>x.key == this.routeName);
            if(index != -1){
                let value =  quoteMap[index].value;
                let equipIndex = value.findIndex(x=>x.key == this.agentName+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected+'-'+this.routeName);
                if(equipIndex != -1){
                    value[equipIndex].sellingRate = parseInt(this.sellingRate) 
                    value[equipIndex].profit = parseInt(profit)
                    value[equipIndex].margin =  parseInt(this.margin)
                    value[equipIndex].validity = this.validity
                    value[equipIndex].quantity = this.quantity
                    value[equipIndex].currencyCode = this.currencyCode
                    value[equipIndex].displayeEquip = this.sellingRate > 0 ? true:false
                    if(value[equipIndex].savedClicked == true) el.cssClass = 'class2'
                    else value[equipIndex].cssClass = '';
                }
                else{
                    value.push({
                        key: this.agentName+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected+'-'+this.routeName,
                        sellingRate : parseInt(this.sellingRate) ,
                        equipmentName: this.agentName+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected,
                        profit : parseInt(profit),
                        margin :  parseInt(this.margin),
                        validity : this.validity,
                        quantity : this.quantity,
                        currencyCode : this.currencyCode,
                        cssClass :'',
                        displayeEquip : this.sellingRate > 0 ? true:false
                    })
                }
                quoteMap[index].value = value;
            }
            else{
                let value = [];
                value.push({
                    key: this.agentName+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected+'-'+this.routeName,
                    sellingRate : parseInt(this.sellingRate) ,
                    equipmentName: this.agentName+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected,
                    profit : parseInt(profit),
                    margin :  parseInt(this.margin),
                    validity : this.validity,
                    quantity : this.quantity,
                    currencyCode : this.currencyCode,
                    cssClass :'',
                    displayeEquip : this.sellingRate > 0 ? true:false
                })
                quoteMap.push({key:this.routeName,value:value})
            }
            this.quotationMap = JSON.parse(JSON.stringify(quoteMap));
        } 
        this.dispatchEvent(new CustomEvent('updatecalculation', { detail: this.quotationMap })); 
    }
    handleCheckRate(event){
        this.itemId = event.currentTarget.dataset.recordid;
        this.buyingChargesIncluded = event.currentTarget.dataset.buyingcharges;
        this.sellingChargesIncluded = event.currentTarget.dataset.sellingcharges;
        this.displaycheckRate = true; 
    }
    handleCloseCheckRate(){
        this.itemId = '';
        this.buyingChargesIncluded =  '';
        this.sellingChargesIncluded = '';
        this.displaycheckRate = false; 
    }
}