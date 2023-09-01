import { LightningElement,api,track } from 'lwc';
import getQuoteExportLineItemDetails from '@salesforce/apex/BAFCOAirEnquiryController.getQuoteExportLineItemDetails';
export default class BAFCOAirExportReviseDetail extends LightningElement {
    @api routeName;
    @api routingRegular;
    @api shipmentKind;
    @api serviceType;
    @api portLoading;
    @api portDestination;
    @api shippingLine;
    @api commodity;
    @api cargoDetails;
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
    @track currencyCode='USD';
    @track buyingRatekg='';
    @track sellingRatekg='';
    displayCargoDetails = false;

    connectedCallback(){
        console.log('getQuoteExportLineItemDetails ')
        this.getQuoteLineItemDetails();
    }
    getQuoteLineItemDetails(){
        getQuoteExportLineItemDetails({
            quoteId : this.activeQuoteId,
            portLoading : this.portLoading,
            portDestination : this.portDestination,
            commodity : this.commodity,
            routeId : this.routeId
        })
        .then(result=>{
            console.log('getQuoteExportLineItemDetails result',JSON.stringify(result,null,2));
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
        this.buyingRatekg = dedicatedObj[elem].buyingRatekg;
        this.sellingRatekg = dedicatedObj[elem].sellingRatekg;
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
            this.buyingRatekg = dedicatedRoutingObj[index].buyingRatekg;
            this.sellingRatekg = dedicatedRoutingObj[index].sellingRatekg;
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
        let margin  = (profit/this.sellingRate);
        this.margin = isNaN(margin) ? 0 : margin * 100;
        this.margin = this.margin.toFixed(2);
        profit = isNaN(profit) ? 0 : profit.toFixed(2);
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
    handleCloseCargoDetailsPopUp(){
        this.displayCargoDetails = false;
    }
    handleShowCargoDetails(){
        this.displayCargoDetails = true;
    }
}