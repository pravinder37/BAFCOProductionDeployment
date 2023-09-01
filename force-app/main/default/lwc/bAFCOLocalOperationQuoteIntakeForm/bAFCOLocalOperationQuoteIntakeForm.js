import { LightningElement,api,track } from 'lwc';
import getRouteListOnload from '@salesforce/apex/BAFCOLocalOperationQuoteController.getRouteListOnload';
import genrateQuotation from '@salesforce/apex/BAFCOLocalOperationQuoteController.genrateQuotation';
import updateValidityDate from '@salesforce/apex/BAFCOLRoutingDetailsController.updateValidityDate';
import { NavigationMixin } from 'lightning/navigation';
export default class BAFCOLocalOperationQuoteIntakeForm extends NavigationMixin(LightningElement) {
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
    @api incoTerm;
    @api incoTermId;
    @api optyId;
    @api quotationList;
    @api accountId;
    @api acctName = '';
    @api pickupPlace ='';
    @api dischargePlace = '';
    @api portLoadingId='';
    @api cameReviseCompt=false;
    @api sameRoute = false;
    @api businessType = '';
    @api pickupPlaceName = '';
    @api dischargePlaceName = '';
    @api equipmentType =''
    @api portDestinationId =''

    @track displayPOL =  false;
    @track displayPOD = false;
    @track displayPlOP = false;
    @track displayPlOD = false;
    @track toHoldData = [];
    @track allRouteList = [];

    @track totalRate = 0;
    @track shippingEquipTabSelected = '';

    @track buyingRate = 0;
    @track sellingRate = 0;
    @track profitLabel = 'USD 0 Profit'
    @track shippingTabSelected = '';
    @track shippingEquipTabSelected = '';
    @track seaFreight = '';
    @track seaFreightSellRate = 0;
    @track equipQuantity = 0;
    @track showServiceChargeModal = false ; 
    @track validity = ''
    @track margin = 0;
    @track daysLeft = 0;
    @track quotationItemId = '';

    @track incoChargList = [];

    @track showAdditionalChargeModal = false;
    @track additionalChargeList = [];
    @track additionalChargeIndex = 0;
    @track equipmentId ='';
    @api quotationId = '';
    @track serviceChargeObj;

    @track quantity = 0; 
    @track quotationSaved = false;
    @track showAdditionalChargetemplate = false;
    @track isLoading = false;
    @track rmsRemarks =''

    @track displayAllServiceChargeField = true;
    @track BAF ;
    @track bunkerCharges;
    @track cleaningCharges;
    @track CMC;
    @track carriageCongestionSurcharge;
    @track carrierSecurityFees;
    @track dgSurcharge;
    @track DTHC;
    @track equipmentImbalance;
    @track inlandFuelCharges;
    @track inlandHandlingfees;
    @track inlandHaulage;
    @track ISPS;
    @track lowerSulphurSurcharge;
    @track operationalRecovery;
    @track OTHC;
    @track overWeightCharge;
    @track sealCharges;
    @track warRiskSurcharges;
    @track totalSl;
    @track shippTotalChanged =false;


    //@
    @track displayOriginChargeCharge = true;
    @track bayan;
    @track blFees;
    @track originCustomClearance;
    @track exportServiceFees;
    @track fasahFees;
    @track fuelSurcharge;
    @track inspection;
    @track insuranceCharges;
    @track liftOnLiftOff;
    @track OriginDetention;
    @track OriginLoadingCharges;
    @track pickUpCharges;
    @track ReeferControlPlugInCharge;
    @track tabadul;
    @track trapulinCharges;
    @track truckIdlingCharges;
    @track transportationCharges;
    @track vgm;
    @track lashingCharges;
    @track xray;
    @track TotalOrigincharges;
    @track directionValue;
    @track loadingChargeId;
    @track originTotalChanged = false;
    @track loadingChargeName;



    ///
    @track destinBayanCharges;
    @track destinCustomClearanceCharges;
    @track destinDOCharges;
    @track  destinFasahCharges;
    @track  destinGatePassCharges;
    @track  destinLOLOCharges;
    @track  destinTransPortationCharges;
    @track destinTotalCharges;
    @track DestinTotalChanged= false;
    @track displayDestinCharges = true;

    @track additionalChargeTotal = 0;
    @track displayAdditionalCharge;
    @track quoteRemarks = '';
    @track showNewServiceCharge = false;
 
    @track showProcument = false;
    @track destinationChargeList={};
    @track includeServiceCharge=false;
    @track includeOriginCharge = false;
    @track includeDestinCharge=false;
    @track includeAdditionalCharge = false;
    @track includeExWorksCharge=false;
    @track displayExWorksModal = false;
    @track exWorksObj;
    @track exWorksTotal = 0;
    @track displayExworks = false;
    @track currencyCode = 'USD';

    connectedCallback(){
        if(this.businessType == 'Export'){
            this.displayPOL = true;
            this.displayPlOP = true;
        }
        else if(this.businessType == 'Import'){
            this.displayPOD = true;
            this.displayPlOD = true;
        }
        this.getRouteListOnload();
    }
    getRouteListOnload(){
        getRouteListOnload({routeId : this.routeId})
        .then(result=>{
            console.log('getRouteListOnload result : ',JSON.stringify(result,null,2))
            this.allRouteList = result
            let tempList = [];
            if(result != null){
                result.forEach(elem=>{
                    tempList.push({key:elem.Equipment_Type__c,value:[]})
                })
            }
            this.toHoldData = tempList;
        })
        .catch(error=>{
            console.log('getRouteListOnload error : ',JSON.stringify(error,null,2))
        })
    }
    handleEquipMentActive(e){
        this.shippingEquipTabSelected = e.target.value;
        this.resetCalculation();
        this.assignTabsData();
        this.handleUpdateCalculation();
    }
    resetCalculation(){
        this.totalRate = 0;
        this.buyingRate = 0;
        this.rmsRemarks = '';
        this.quantity=0;
        this.sellingRate = 0;
        this.seaFreightSellRate = 0;
        this.equipQuantity = 0;
        this.additionalChargeList = [];
        this.profitLabel = 'USD 0 Profit';
        this.displayAdditionalCharge = false;
        this.displayAllServiceChargeField = true;
        this.BAF = '';
        this.bunkerCharges = '';
        this.cleaningCharges = '';
        this.CMC = '';
        this.carriageCongestionSurcharge = '';
        this.carrierSecurityFees = '';
        this.dgSurcharge = '';
        this.DTHC = '';
        this.equipmentImbalance = '';
        this.inlandFuelCharges = '';
        this.inlandHandlingfees = '';
        this.inlandHaulage = '';
        this.ISPS = '';
        this.lowerSulphurSurcharge = '';
        this.operationalRecovery = '';
        this.OTHC = '';
        this.overWeightCharge = '';
        this.sealCharges = '';
        this.warRiskSurcharges = '';
        this.totalSl = '';
        this.shippTotalChanged = false;
        this.bayan = '';
        this.blFees = '';
        this.originCustomClearance = '';
        this.exportServiceFees = '';
        this.fasahFees = '';
        this.fuelSurcharge = '';
        this.inspection = '';
        this.insuranceCharges = '';
        this.liftOnLiftOff = '';
        this.OriginDetention = '';
        this.OriginLoadingCharges = '';
        this.pickUpCharges = '';
        this.ReeferControlPlugInCharge = '';
        this.tabadul = '';
        this.trapulinCharges = '';
        this.truckIdlingCharges = '';
        this.transportationCharges = '';
        this.vgm = '';
        this.lashingCharges = '';
        this.xray = '';
        this.TotalOrigincharges = '';
        this.originTotalChanged = false;
        this.destinBayanCharges= '';
        this.destinCustomClearanceCharges= '';
        this.destinDOCharges= '';
        this.destinFasahCharges= '';
        this.destinGatePassCharges= '';
        this.destinLOLOCharges= '';
        this.destinTransPortationCharges= '';
        this.destinTotalCharges= '';
        this.DestinTotalChanged= false;
        this.displayDestinCharges = true;
        this.total = 0;
        this.displayAdditionalCharge = false
        this.additionalChargeTotal = null;
        this.exWorksObj = {};
        this.displayExworks =false;
        this.exWorksTotal = null;
        this.includeServiceCharge=false
        this.includeOriginCharge=false
        this.includeDestinCharge=false
        this.includeAdditionalCharge=false
        this.includeExWorksCharge=false
        this.currencyCode = 'USD';
        this.quotationSaved = false;
    }
    handleTotalRateChange(e){
        this.totalRate = e.target.value;
        let totalRateField = this.template.querySelector("[data-field='totalRateField']");
        totalRateField.setCustomValidity("");
        totalRateField.reportValidity();   
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    updateTabsData(){
        this.updateBuyingRate();
        let index  = this.toHoldData.findIndex(x=>x.key == this.shippingEquipTabSelected);
        if(index != -1){
            if(this.toHoldData[index].value.length == 1){
                this.toHoldData[index].value[0].totalRate = parseInt(this.totalRate);
                this.toHoldData[index].value[0].quoteBuyingRate = this.buyingRate;
                this.toHoldData[index].value[0].quotationItemId = this.quotationItemId;                    
                this.toHoldData[index].value[0].additionalChargeList = this.additionalChargeList;
                //this.toHoldData[index].value[0].quantity=this.equipQuantity;
                this.toHoldData[index].value[0].exWorksObj = this.exWorksObj;
                this.toHoldData[index].value[0].addExWorksCharge = this.addExWorksCharge;
                this.toHoldData[index].value[0].displayExworks = this.displayExworks;
                this.toHoldData[index].value[0].exWorksTotal = this.exWorksTotal
                this.toHoldData[index].value[0].includeServiceCharge = this.includeServiceCharge
                this.toHoldData[index].value[0].includeOriginCharge = this.includeOriginCharge
                this.toHoldData[index].value[0].includeDestinCharge = this.includeDestinCharge
                this.toHoldData[index].value[0].includeAdditionalCharge = this.includeAdditionalCharge
                this.toHoldData[index].value[0].includeExWorksCharge = this.includeExWorksCharge
                this.toHoldData[index].value[0].currencyCode = this.currencyCode
            }
        }
        console.log('to hold '+JSON.stringify(this.toHoldData,null,2))
    }
    updateBuyingRate(){
        let dtoTotal = 0;   
        let additonalChargeTotal = 0; 
        let index  = this.toHoldData.findIndex(x=>x.key == this.shippingEquipTabSelected);
        if(index != -1){
            if(this.toHoldData[index].value.length > 0){
                let dto = this.toHoldData[index].value[0];
            if(this.totalSl > 0) dtoTotal +=  parseInt(this.totalSl);
            if(this.TotalOrigincharges > 0) dtoTotal += parseInt(this.TotalOrigincharges );  
            if(this.destinTotalCharges > 0) dtoTotal +=  parseInt(this.destinTotalCharges);
            if(this.exWorksTotal > 0) dtoTotal += parseInt(this.exWorksTotal);
            if(dto.additionalChargeList.length > 0){
                dto.additionalChargeList.forEach(addCha => {
                    if(addCha.value > 0){
                        additonalChargeTotal = additonalChargeTotal + addCha.value;
                    }
                });
            }
                if(additonalChargeTotal > 0 ) {
                    this.additionalChargeTotal = parseInt(additonalChargeTotal);
                    dtoTotal = dtoTotal + parseInt(additonalChargeTotal);
                }
            }
        }
        this.buyingRate = dtoTotal > 0 ? dtoTotal : 0;
    }
    @api handleUpdateCalculation(){
        let dtoTotal = 0;   
        let additonalChargeTotal = 0;   
        let index  = this.toHoldData.findIndex(x=>x.key == this.shippingEquipTabSelected);
        if(index != -1){
            if(this.toHoldData[index].value.length > 0){
                let dto = this.toHoldData[index].value[0];
                if(dto.totalRate > 0) dtoTotal +=  parseInt(dto.totalRate);  
                dto.total= dtoTotal;
            }
        }
        if(!isNaN(dtoTotal)){
            this.sellingRate = parseInt(dtoTotal);
            this.total = dtoTotal;
        }
        else{
                this.sellingRate = 0;
                this.total = 0;
        }
        let profit = 0;
        if(this.sellingRate > 0 && !isNaN(this.sellingRate)){
            let dto = this.toHoldData[index].value[0];

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
        this.profitLabel = this.currencyCode+' '+profit +' Profit.';
    }
    assignTabsData(){
        let tempList3 = [];
        let quantity=0;
        let index = this.toHoldData.findIndex(x=>x.key == this.shippingEquipTabSelected);
        let index2  = this.allRouteList.findIndex(x=>x.Equipment_Type__c == this.shippingEquipTabSelected);
        let seletedEquipName1 = this.allRouteList[index2].Equipment_Type__r.Name;
        let isFdAccount = false;
        isFdAccount = this.allRouteList[index2].Route__r.Opportunity_Enquiry__r.Account.FD__c;
        console.log('this.allRouteList[index2] '+JSON.stringify(this.allRouteList[index2],null,2))
        quantity = this.allRouteList[index2].Quantity__c != undefined ? this.allRouteList[index2].Quantity__c : 0;
        if(seletedEquipName1 == '20ISO'){
            tempList3.push({
                'name':'Tank Rental Charges',
                'value':null,
                'index':this.additionalChargeIndex
            })
            this.additionalChargeIndex++;
            this.additionalChargeList = tempList3;
            this.displayAdditionalCharge = true
        }
        if(isFdAccount == true){
            tempList3.push({
                'name':'Freight Difference(FD)',
                'value':null,
                'index':this.additionalChargeIndex
            })
            this.additionalChargeIndex++;
            this.additionalChargeList = tempList3;
            this.displayAdditionalCharge = true
        }
        if(this.toHoldData[index].value.length == 0){
            let tempList = [];
            tempList.push({
                'totalRate':0,
                'quotationItemId':'',
                'displayExworks':false,
                'includeServiceCharge':false,
                'includeOriginCharge':false,
                'includeDestinCharge':false,
                'includeAdditionalCharge':false,
                'includeExWorksCharge':false,
                'exWorksObj':{},
                'exWorksTotal':null,
                'incoChargList':{},
                'additionalChargeList' : tempList3,
                'savedClicked':false,
                'pickupPlaceName':this.pickupPlaceName,
                'dischargePlaceName':this.dischargePlaceName,
                'total':0,
                'quoteBuyingRate ':0,
                'selectedEquipment':this.shippingEquipTabSelected,
                'currencyCode':'USD',
                'portLoadingId':this.portLoadingId,
                'portDestinationId':this.portDestinationId,
                'incoTermId':this.incoTermId,
                'quantity':quantity,
            })
            this.toHoldData[index].value = JSON.parse(JSON.stringify(tempList));
        }
        else{
            this.totalRate = this.toHoldData[index].value[0].totalRate ;
            this.quotationItemId = this.toHoldData[index].value[0].quotationItemId != undefined ? this.toHoldData[index].value[0].quotationItemId : '';                     
            if(this.toHoldData[index].value[0].additionalChargeList.length > 0){
                this.additionalChargeList = this.toHoldData[index].value[0].additionalChargeList;
                if(this.additionalChargeList.length > 0) this.displayAdditionalCharge = true
                else this.displayAdditionalCharge = false
            }
            this.total = this.toHoldData[index].value[0].total;
            this.exWorksObj = this.toHoldData[index].value[0].exWorksObj;
            this.displayExworks = this.toHoldData[index].value[0].displayExworks;
            this.exWorksTotal = this.toHoldData[index].value[0].exWorksTotal;
            this.includeServiceCharge = this.toHoldData[index].value[0].includeServiceCharge;
            this.includeOriginCharge = this.toHoldData[index].value[0].includeOriginCharge;
            this.includeDestinCharge = this.toHoldData[index].value[0].includeDestinCharge;
            this.includeAdditionalCharge = this.toHoldData[index].value[0].includeAdditionalCharge;
            this.includeExWorksCharge = this.toHoldData[index].value[0].includeExWorksCharge;
            this.savedClicked = this.toHoldData[index].value[0].savedClicked;
            this.buyingRate = this.toHoldData[index].value[0].quoteBuyingRate;
            
        }
        this.updateBuyingRate();
    }
    handleincludeServiceChargeChange(e){
        this.includeServiceCharge = e.target.checked;
        this.updateTabsData();
    }
    handleincludeOriginChargeChange(e){
        this.includeOriginCharge = e.target.checked;
        this.updateTabsData();
    }
    handleincludeDestinChargeChange(e){
        this.includeDestinCharge = e.target.checked;
        this.updateTabsData();
    }
    handleincludeAdditionalChargeChange(e){
        this.includeAdditionalCharge = e.target.checked;
        this.updateTabsData();
    }
    handleincludeExWorksChargeChange(e){
        this.includeExWorksCharge = e.target.checked;
        this.updateTabsData();
    }
    handleAddAdditionalCharge(e){
        this.showAdditionalChargeModal = true;
    }
    handleCloseAdditionalModal(){
        this.showAdditionalChargeModal = false;
    }
    handleAddSelected(event){
        this.showAdditionalChargeModal = false;
        let selectedAdditional = event.detail.selRecords;  
        let tempList2 = this.additionalChargeList;

        //Removing Duplicate from selected List 
        selectedAdditional = Array.from(new Set(selectedAdditional.map(a => a.recName)))
            .map(recName => {
            return selectedAdditional.find(a => a.recName === recName)
            })

        //Removing Duplicate from current and previous list
        tempList2.forEach(elem=>{
            selectedAdditional.forEach(elem2 => {
                if(elem2.recName == elem.name){
                    const index = selectedAdditional.indexOf(elem2);
                    selectedAdditional.splice(index, 1);
                }
            });
        })

        selectedAdditional.forEach(elem =>{            
            tempList2.push({
                'name':elem.recName,
                'value':0,
                'index':this.additionalChargeIndex
            })
            this.additionalChargeIndex++;
        });
        this.additionalChargeList = tempList2;
        if(tempList2.length > 0) this.displayAdditionalCharge = true;
        else this.displayAdditionalCharge = false;
        this.updateTabsData();
    }
    handleAdditionalChange(event){
        let index = event.target.dataset.recordId;
        let indexA = this.additionalChargeList.findIndex(x=>x.index == index);
        this.additionalChargeList[indexA].value = parseInt(event.target.value);
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    removeAdditionalCharge(event){
        let index = event.target.dataset.recordId;
        let arrindex = -1;
        arrindex = this.additionalChargeList.findIndex((x) => x.index == index);
        if(arrindex != -1){
            this.additionalChargeList.splice(arrindex, 1);
        }
        if(this.additionalChargeList.length > 0) this.displayAdditionalCharge = true;
        else this.displayAdditionalCharge = false;
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    handleRemarksChange(e){
        this.quoteRemarks = e.target.value;
    }
    handleTemplateView(){
        this.showAdditionalChargetemplate = true;
    }
    handleCloseTemplatePopup(){
        this.showAdditionalChargetemplate = false;
    }
    handleTemplateSelected(event){
        this.showAdditionalChargetemplate = false;       
        let selectedAdditional = event.detail.uniqueElem;
        let tempList2 = this.additionalChargeList; 
        //Removing Duplicate
        tempList2.forEach(elem=>{
            selectedAdditional.forEach(elem2 => {
                if(elem2.Name == elem.name){
                    const index = selectedAdditional.indexOf(elem2);
                    selectedAdditional.splice(index, 1);
                }
            });
        })
        selectedAdditional.forEach(elem =>{            
            tempList2.push({
                'name':elem.Name,
                'value':elem.value,
                'index':this.additionalChargeIndex
            })
            this.additionalChargeIndex++;
        });
        this.additionalChargeList = tempList2;
        if(this.additionalChargeList.length > 0) this.displayAdditionalCharge = true;
        else this.displayAdditionalCharge = false;
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    handleAddExWorks(e){
        this.displayExWorksModal = false;
        let selectedExWorks = e.detail.tempObj;
        this.displayExworks = true;
        this.exWorksObj= selectedExWorks;
        this.exWorksTotal = selectedExWorks.LoadCharge > 0 ? selectedExWorks.LoadCharge : 0;
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    handleAddWorks(){
        this.displayExWorksModal = true;
    }
    handleCloseExworks(){
        this.displayExWorksModal = false;
    }
    handleGenerateQuotaion(){
        let allValid = true;
        let dto = {}; 
        let index = this.toHoldData.findIndex(x=>x.key == this.shippingEquipTabSelected)
        if(index != -1){
            dto = this.toHoldData[index].value[0];
        }
        console.log('dto '+JSON.stringify(dto,null,2))
        if(!dto.totalRate > 0) {
            let totalRateField = this.template.querySelector("[data-field='totalRateField']")
            totalRateField.setCustomValidity("Selling rate should be greater then 0");
            totalRateField.reportValidity();
            allValid = false;
        }
        if(allValid){
            genrateQuotation({
                routeId: this.routeId,
                optyId : this.optyId,
                quotationId : this.quotationId,
                dto : dto,
                quoteRemarks: this.quoteRemarks,
                additionalChargeTotal : this.additionalChargeTotal,
                cameReviseCompt : this.cameReviseCompt,
                sameRoute:this.sameRoute,
            }).then(result =>{
                console.log('generate quote result : ', JSON.stringify(result,null,2));
                if(result != null){
                    this.quotationSaved = true;
                    this.quotationId = result;
                    let index  = this.toHoldData.findIndex(x=>x.key == this.shippingEquipTabSelected);
                    if(index != -1){
                        this.toHoldData[index].value[0].savedClicked = true;
                    }
                    this.dispatchEvent(new CustomEvent('showquotebtn',{ detail: {quoteId : this.quotationId}}));
                }
            })
            .catch(error=>{
                console.log('generate quote error', JSON.stringify(error));
            })
        }
    }
    @api handleGotoQuotation(validityDate){        
        if(this.quotationId != ''){
            this.isLoading = true;
            updateValidityDate({quoteId : this.quotationId,validityDate:validityDate})
            .then(result=>{
                this.isLoading = false
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.quotationId,
                        objectApiName: 'Quotation__c',
                        actionName: 'view'
                    }
                });
            })
            .catch(error=>{
                this.isLoading = false;
                console.log('error ',error)
            })
        }
    }
    /*handlebuyingRateChange(e){
        this.buyingRate = e.target.value;
        console.log('this.buyingRate '+this.buyingRate)
        let BuyingRateField = this.template.querySelector("[data-field='BuyingRateField']")
            BuyingRateField.setCustomValidity("");
            BuyingRateField.reportValidity();
        this.updateTabsData();
        this.handleUpdateCalculation();
    }*/
    handleExWorksTotalChange(e){
        let value = parseInt(e.target.value)
        this.exWorksObj.LoadCharge = value
        this.exWorksTotal = value
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    
}