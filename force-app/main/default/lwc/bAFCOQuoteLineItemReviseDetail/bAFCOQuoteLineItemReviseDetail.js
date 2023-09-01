import { LightningElement,api,track } from 'lwc';
import getQuoteLineItemDetails from '@salesforce/apex/BAFCOQuotationReviseController.getQuoteLineItemDetails';
export default class BAFCOQuoteLineItemReviseDetail extends LightningElement {
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
    @track quotationDate = '';
    @api equipmentType =''
    @track currencyCode='USD'


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
            console.log('getQuoteLineItemDetail result',JSON.stringify(result,null,2));
            this.quoteLineItemMap = result;
            if(Object.keys(result).length == 0){
                this.routlistNotfound = true;
            }
            else{
                this.routlistNotfound = false;
                let conts = result;
                for(let key in conts){
                    if(conts[key].length > 0){
                        this.quoteLineItemList.push({value:conts[key], key:key});
                        
                    }
                }
                console.log(' ** quoteLineItemMap '+JSON.stringify(this.quoteLineItemMap,null,2));
                this.shippingEquipTabSelected = this.quoteLineItemList[0].value[0].equipmentName;
            }
        })
        .catch(error=>{
            console.log('getQuoteLineItemDetail error',JSON.stringify(error))
        })
    }

    handleshippingLineActive(e){
        this.shippingTabSelected = e.target.value;
        let dedicatedObj = this.quoteLineItemMap[this.shippingTabSelected];
        let elem  = 0;
        this.shippingEquipTabSelected = dedicatedObj[elem].equipmentName; 
        this.buyingRate = dedicatedObj[elem].totalBuyingRate;
        this.currencyCode = dedicatedObj[elem].currencyCode;
        this.quotationDate = dedicatedObj[elem].quotationDate;
        if(dedicatedObj[elem].totalSellingRate > 0) this.sellingRate = dedicatedObj[elem].totalSellingRate;
        this.handleUpdateCalculation();
    }
    handleEquipmentActive(e){
        let profitButton =  this.template.querySelector('.profitButton');
        if(profitButton != undefined){
            profitButton.style = "background:#FF9800;height: 50px;border-radius: 4px;"
        }
        this.shippingEquipTabSelected = e.target.value;
        let dedicatedRoutingObj = this.quoteLineItemMap[this.shippingTabSelected];
        let index = dedicatedRoutingObj.findIndex(x=>x.equipmentName == this.shippingEquipTabSelected);
        if(index != -1){
            this.rmsId = dedicatedRoutingObj[index].rmsId;
            this.buyingRate = dedicatedRoutingObj[index].totalBuyingRate;
            this.currencyCode = dedicatedRoutingObj[index].currencyCode
            this.quotationDate = dedicatedRoutingObj[index].quotationDate;
            if(dedicatedRoutingObj[index].totalSellingRate > 0) this.sellingRate = dedicatedRoutingObj[index].totalSellingRate;
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
                key: this.shippingTabSelected+'-'+this.shippingEquipTabSelected+'-'+this.routeName,
                sellingRate : parseInt(this.sellingRate) ,
                equipmentName: this.shippingTabSelected+'-'+this.shippingEquipTabSelected,
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
        }
        else{
            let quoteMap = JSON.parse(JSON.stringify(this.quotationMap));
            let index = quoteMap.findIndex(x=>x.key == this.routeName);
            if(index != -1){
                let value =  quoteMap[index].value;
                let equipIndex = value.findIndex(x=>x.key == this.shippingTabSelected+'-'+this.shippingEquipTabSelected+'-'+this.routeName);
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
                        key: this.shippingTabSelected+'-'+this.shippingEquipTabSelected+'-'+this.routeName,
                        sellingRate : parseInt(this.sellingRate) ,
                        equipmentName: this.shippingTabSelected+'-'+this.shippingEquipTabSelected,
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
                    key: this.shippingTabSelected+'-'+this.shippingEquipTabSelected+'-'+this.routeName,
                    sellingRate : parseInt(this.sellingRate) ,
                    equipmentName: this.shippingTabSelected+'-'+seletedEquipName,
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
        console.log('quotationMap '+JSON.stringify(this.quotationMap,null,2))
        this.dispatchEvent(new CustomEvent('updatecalculation', { detail: this.quotationMap }));
    }
}