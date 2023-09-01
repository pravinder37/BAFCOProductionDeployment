import { LightningElement,api,track } from 'lwc';
import getQuoteLineItemDetails from '@salesforce/apex/BAFCOAirEnquiryController.getQuoteLineItemDetails';
export default class BAFCOAirImportReviseDetail extends LightningElement {
    @api routeName;
    @api routingRegular;
    @api shipmentKind;
    @api serviceType;
    @api portLoading;
    @api portDestination;
    @api shippingLine;
    @api commodity;
    @api portLoadingId ;
    @api portDestinationId ;
    @api cargoWeights;
    @api dangerousGoods;
    @api remarks;
    @api routeId;
    @api cargoReadiness = '';
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
    @track currencyCode='USD';
    @api isAir;
    @api cargoDetails ='';
    @track buyingRateKg = 0.00;
    @track sellingRatekg ;
    @track displayCargoDetails = false;
    connectedCallback(){
        this.getQuoteLineItemDetails();
    }
    getQuoteLineItemDetails(){
        getQuoteLineItemDetails({quoteId : this.activeQuoteId,routeId : this.routeId})
        .then(result=>{
            console.log('result => : ',JSON.stringify(result,null,2))
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
            console.log('error => : ',JSON.stringify(error,null,2))
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
        this.buyingRateKg = data[elem].buyingRatekg;
        this.sellingRatekg = data[elem].sellingRatekg;
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
        this.currencyCode = data[elem].currencyCode;
        this.buyingRateKg = data[elem].buyingRatekg;
        this.sellingRatekg = data[elem].sellingRatekg;
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
        console.log('data '+JSON.stringify(data,null,2))
        let equipIndex = data.findIndex(x=>x.equipmentName == this.shippingEquipTabSelected)
        if(equipIndex != -1){
            let totalSelling = 0;
            if(data[equipIndex].totalSellingRate > 0) totalSelling = totalSelling + data[equipIndex].totalSellingRate;
            this.buyingRate = data[equipIndex].totalBuyingRate;
            this.quotationDate = data[equipIndex].quotationDate;
            this.sellingRate =totalSelling;
            this.rmsId = data[equipIndex].rmsId;
            this.buyingRateKg = data[equipIndex].buyingRatekg;
            this.sellingRatekg = data[equipIndex].sellingRatekg;
            this.currencyCode = data[equipIndex].currencyCode;
        }
        this.handleUpdateCalculation();
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
    }
    handleShowServiceCharge(){
        this.showServiceChargeModal = true; 
    }
    handleCloseModal(){
        this.showServiceChargeModal = false; 
    }
    handleCloseCargoDetailsPopUp(){
        this.displayCargoDetails = false;
    }
    handleShowCargoDetails(){
        this.displayCargoDetails = true;
    }
}