import { LightningElement,api,track } from 'lwc';
import getQuoteLineItem from '@salesforce/apex/BAFCOLocalOperationQuoteController.getQuoteLineItem';
export default class BAFCOLclReviseQuoteItem extends LightningElement {
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
    connectedCallback(){
        this.getQuoteLineItemDetails();
    }
    getQuoteLineItemDetails(){
        getQuoteLineItem({
            quoteId : this.activeQuoteId,
        }).then(result=>{
            console.log('getQuoteLineItemDetail result',JSON.stringify(result,null,2));
            this.quoteLineItemList = result;
        }).catch(error=>{
            console.log('getQuoteLineItemDetail error',JSON.stringify(error))
        })
    }
    handleEquipActive(e){
        let profitButton =  this.template.querySelector('.profitButton');
        if(profitButton != undefined){
            profitButton.style = "background:#FF9800;height: 50px;border-radius: 4px;"
        }
        this.shippingEquipTabSelected = e.target.value;
        let index = this.quoteLineItemList.findIndex(x=>x.equipmentId == this.shippingEquipTabSelected);
        if(index != -1){
            this.buyingRate = this.quoteLineItemList[index].totalBuyingRate;
            this.currencyCode = this.quoteLineItemList[index].currencyCode
            this.quotationDate = this.quoteLineItemList[index].quotationDate;
            if(this.quoteLineItemList[index].totalSellingRate > 0) this.sellingRate = this.quoteLineItemList[index].totalSellingRate;
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
}