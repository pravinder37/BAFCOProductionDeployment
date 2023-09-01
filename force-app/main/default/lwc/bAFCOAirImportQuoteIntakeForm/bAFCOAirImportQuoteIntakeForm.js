import { LightningElement,api,track } from 'lwc';
import getRouteListAirImport from '@salesforce/apex/BAFCOAirEnquiryController.getRouteListAirImport';
import updateValidityDate from '@salesforce/apex/BAFCOLRoutingDetailsController.updateValidityDate';
import genrateAirImportQuotation from '@salesforce/apex/BAFCOLocalOperationQuoteController.genrateAirImportQuotation';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class BAFCOAirImportQuoteIntakeForm extends NavigationMixin(LightningElement) {
    @api routeName;
    @api routingRegular;
    @api shipmentKind;
    @api serviceType;
    @api portLoading;
    @api portDestination;
    @api portDestinationId;
    @api shippingLine;
    @api commodity;
    @api cargoWeights;
    @api optyId;
    @api dangerousGoods;
    @api remarks;
    @api routeId;
    @api incoTerm;
    @api incoTermId;
    @api enquiryId;
    @api quotationList;
    @api leadId;
    @api pickupPlace ='';
    @api dischargePlace = '';
    @api portLoadingId='';
    @api cameReviseCompt=false;
    @api sameRoute ;
    @api businessType = '';
    @api pickupPlaceName = '';
    @api dischargePlaceName = '';
    @api quotationId = '';
    @api equipmentType = ''
    @api cargoDetails='';
    @api acctName = '';
    @api cargoReadiness = '';  
    @track totalRate = 0;
    @track shippingEquipTabSelected = '';

    @track buyingRate = 0;
    @track sellingRate = 0;
    @track profitLabel = 'USD 0 Profit'
    @track shippingTabSelected = '';
    @track seaFreight = '';
    @track seaFreightSellRate = 0;
    @track equipQuantity = 0;
    @track showServiceChargeModal = false ; 
    @track validity = ''
    @track margin = 0;
    @track daysLeft = 0;
    @track quotationItemId = '';
    @track buyingRateInput ;
    @track isAir = true;
    @track rmsId = '';

    @track incoChargList = [];
    @track chargeableWeight = null;

    @track showAdditionalChargeModal = false;
    @track additionalChargeList = [];
    @track additionalChargeIndex = 0;
    @track equipmentId ='';
    @track serviceChargeObj;
    displayCargoDetails = false;

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
    @track displayAddAgent = false;
    @track agentObject ;
    @track addAirlineModel = false;
    @track airLine;
    @track showAddRatesModel = false;
    @track addExWorksCharge = true;
    @track addAdditionalCharge = true;
    @track addDestinCharge = true;
    @track addOriginCharge = true;
    @track addServiceCharge = true;
    @track disableBuyingRate = false;
    @track rmsNotFound = false; 
    @track routingListMap;
    @track routlistNotfound = false;
    @track hideCalculationSection = false;
    @track toHoldData = [];
    @track routingList = []; 
    @track agentTabSelected ='';
    @track transitTime = null;
    @track buyingRateKg = 0;
    @track sellingRateKg = 0;
    @track rateType = '';

    connectedCallback(){
        this.getRouteListOnload();
    }
    getRouteListOnload(){
        getRouteListAirImport({routeId :this.routeId})
        .then(result=>{
            console.log('Route on load result : ',JSON.stringify(result,null,2));
            this.routingListMap = result;
            if(Object.keys(result).length == 0){
                this.routlistNotfound = true;
                this.hideCalculationSection = true;
            }
            else{
                this.routlistNotfound = false;
                this.hideCalculationSection = false;
            }
            let conts = result;
            for(let key in conts){
                let tempList = [];
                for(let key2 in conts[key]){
                    tempList.push({
                        key2:key2,
                        value2: conts[key][key2]})
                }
                this.routingList.push({value:tempList, key:key});
            }
            let holdtempList = [];
             for(let key in conts){
                 for(let key2 in conts[key]){
                    for(let key3 in conts[key][key2]){ 
                        let dd=key+'-'+key2+'-'+conts[key][key2][key3].uniqueEquip
                        holdtempList.push({
                            key: dd,
                            value:[]
                        }) 
                    }   
                 }                
              }
             this.toHoldData = holdtempList;
        })
        .catch(error=>{
            console.log('Route on load error : ',JSON.stringify(error,null,2))
        })
    }
    handleAddAgent(){
        this.displayAddAgent = true;
    }
    handleHideAgentModal(){
        this.displayAddAgent = false;
    }
    handleAddAgentSelected(e){
        console.log('Add Agent : '+JSON.stringify(e.detail,null,2));
        this.agentObject = e.detail;
        this.displayAddAgent = false;
        this.addAirlineModel = true;
    }
    handlecloseAddShippLine(){
        this.addAirlineModel = false;
    }
    handleAddShipLine(e){
        console.log('Add Airline : '+JSON.stringify(e.detail,null,2));
        this.addAirlineModel = false;
        this.airLine = e.detail;
        this.showAddRatesModel = true;
    }
    handleCloseAddRates(){
        this.showAddRatesModel = false;
    }
    handledAddRateSave(e){
        eval("$A.get('e.force:refreshView').fire();");
    }
    resetCalculation(){
        console.log('reset call ');
        this.transitTime = null;
        this.chargeableWeight = null;
        this.buyingRate = 0;
        this.quantity=0;
        this.rateType = '';
        this.rmsRemarks ='';
        this.sellingRate = 0;
        this.seaFreightSellRate = 0;
        this.equipQuantity = 0;
        this.additionalChargeList = [];
        this.profitLabel = '$ Profit';
        this.total = 0;
        this.rateType = '';
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
        this.displayAdditionalCharge = false;
        this.additionalChargeList= [];
        this.additionalChargeTotal = null;
        this.exWorksObj = {};
        this.displayExworks =false;
        this.exWorksTotal = null;
        this.currencyCode = 'USD';
        this.rmsId = '';
        this.buyingRateKg = 0;
        this.sellingRateKg = 0;
    }
    handleAgentActive(e){
        this.resetCalculation();
        this.shippingEquipTabSelected = '';
        this.shippingTabSelected = '';
        this.agentTabSelected = e.target.value;
        let dedicatedRoutingObj = this.routingListMap[this.agentTabSelected];
        let templist = [];
        for(let key in dedicatedRoutingObj){
            templist.push({key:key, data: dedicatedRoutingObj[key]})
        }
        let elem = 0;
        this.shippingTabSelected = templist[elem].key;
        let data =templist[elem].data;
        this.shippingEquipTabSelected = data[elem].uniqueEquip;
        this.assignTabsData();
        this.handleUpdateCalculation();
    }
    handleShipLineActive(e){   
        this.resetCalculation();     
        this.shippingTabSelected = e.target.value;
        let dedicatedRoutingObj = this.routingListMap[this.agentTabSelected];
        let templist = [];
        for(let key in dedicatedRoutingObj){
            templist.push({key:key, data: dedicatedRoutingObj[key]})
        }
        let data = [];
        templist.forEach(elem=>{
            if(elem.key == this.shippingTabSelected){
                data= elem.data
            }
        })
        let elem  = 0;
        this.shippingEquipTabSelected  =  data[elem].uniqueEquip;
        this.resetCalculation();
        this.assignTabsData();
        this.handleUpdateCalculation();
        
    }
    handleEquipmentNameActive(e){
        this.resetCalculation();
        let tabSelected = e.target.value;
        this.shippingEquipTabSelected = tabSelected;
        let profitButton =  this.template.querySelector('.profitButton');
       if(profitButton != undefined){
        profitButton.style = "background:#FF9800;height: 50px;border-radius: 4px;"
       }
       this.assignTabsData();
      this.handleUpdateCalculation();
    }
    assignTabsData(){
        let tempList3 = [];
        let rmsId = '';
        let currencyCode ='';
        let rateKgs =null;
        let chargeableWeight = null;
        tempList3.push({
            'name':'Total Ex-Works Charges',
            'value':null,
            'index':this.additionalChargeIndex
        })
        this.additionalChargeIndex++;
        this.additionalChargeList = tempList3;
        this.displayAdditionalCharge = true
        let dedicatedRoutingObj = this.routingListMap[this.agentTabSelected];
        let templist =[];
        let tabView = '';
        for(let key in dedicatedRoutingObj){
            templist.push({key:key, data: dedicatedRoutingObj[key]})
        }
        let data = [];
        templist.forEach(elem=>{
            if(elem.key == this.shippingTabSelected){
                data= elem.data
            }
        })
        data.forEach(elem =>{
            if(elem.uniqueEquip == this.shippingEquipTabSelected)  {
                tabView = elem.equipmentName;
                this.chargeableWeight = elem.chargeableWeight;
                this.buyingRateInput = (parseFloat(elem.chargeableWeight) * parseFloat(elem.rateKgs)).toFixed(2);
                if(elem.isFDAccount == true){
                    tempList3.push({
                        'name':'Freight Difference(FD)',
                        'value':null,
                        'index':this.additionalChargeIndex
                    })
                    this.additionalChargeIndex++;
                    this.additionalChargeList = tempList3;
                    this.displayAdditionalCharge = true
                }
                rmsId = elem.rmsID;
                this.rmsId = elem.rmsID;
                rateKgs = elem.rateKgs;
                this.rateType = elem.rateType;
                currencyCode = elem.currencyCode;
                this.currencyCode = elem.currencyCode;
                chargeableWeight = elem.chargeableWeight;
            }
        })
        let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected;
         let index  = this.toHoldData.findIndex(x=>x.key == keyName);
        if(this.toHoldData[index].value.length == 0){
            let tempList = [];
            tempList.push({
                'totalRate':0,
                'isLCL': false,
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
                'selectedEquipment':tabView,
                'currencyCode':currencyCode,
                'portLoadingId':this.portLoadingId,
                'portDestinationId':this.portDestinationId,
                'incoTermId':this.incoTermId,
                'buyingRateInput':this.buyingRateInput,
                'airShippline':'',
                'airShipplineName':'',
                'isAir':this.isAir,
                'addServiceCharge':true,
                'addOriginCharge':true,
                'addDestinCharge':true,
                'addAdditionalCharge':true,
                'addExWorksCharge':true,
                'rmsId': rmsId,
                'transitTime':null,
                'rateKg':rateKgs,
                'chargeableWeight':chargeableWeight
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
            this.currencyCode = this.toHoldData[index].value[0].currencyCode;
            this.exWorksObj = this.toHoldData[index].value[0].exWorksObj;
            this.displayExworks = this.toHoldData[index].value[0].displayExworks;
            this.exWorksTotal = this.toHoldData[index].value[0].exWorksTotal;
            this.includeServiceCharge = this.toHoldData[index].value[0].includeServiceCharge;
            this.includeOriginCharge = this.toHoldData[index].value[0].includeOriginCharge;
            this.includeDestinCharge = this.toHoldData[index].value[0].includeDestinCharge;
            this.includeAdditionalCharge = this.toHoldData[index].value[0].includeAdditionalCharge;
            this.includeExWorksCharge = this.toHoldData[index].value[0].includeExWorksCharge;
            this.savedClicked = this.toHoldData[index].value[0].savedClicked;
            this.quotationSaved = this.toHoldData[index].value[0].savedClicked;
            this.buyingRate = this.toHoldData[index].value[0].quoteBuyingRate;
            this.buyingRateInput = this.toHoldData[index].value[0].buyingRateInput;
            this.airShippline = this.toHoldData[index].value[0].airShippline;
            this.airShipplineName = this.toHoldData[index].value[0].airShipplineName;
            this.addServiceCharge = this.toHoldData[index].value[0].addServiceCharge;
            this.addOriginCharge = this.toHoldData[index].value[0].addOriginCharge;
            this.addDestinCharge = this.toHoldData[index].value[0].addDestinCharge;
            this.addAdditionalCharge = this.toHoldData[index].value[0].addAdditionalCharge;
            this.addExWorksCharge = this.toHoldData[index].value[0].addExWorksCharge;
            this.transitTime = this.toHoldData[index].value[0].transitTime;
            this.rmsId = this.toHoldData[index].value[0].rmsId
            
        }
        this.updateBuyingRate();
    }
    handleTransitTime(e){
        this.transitTime = e.target.value;
        this.updateTabsData();
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
        let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected;
        let index  = this.toHoldData.findIndex(x=>x.key == keyName);
        if(index != -1){
            if(this.toHoldData[index].value.length == 1){
                this.toHoldData[index].value[0].totalRate = parseInt(this.totalRate);
                this.toHoldData[index].value[0].quoteBuyingRate = this.buyingRate;
                this.toHoldData[index].value[0].quotationItemId = this.quotationItemId;                    
                this.toHoldData[index].value[0].additionalChargeList = this.additionalChargeList;
                //this.toHoldData[index].value[0].quantity=this.equipQuantity;
                this.toHoldData[index].value[0].addServiceCharge=this.addServiceCharge;
                this.toHoldData[index].value[0].addOriginCharge=this.addOriginCharge;
                this.toHoldData[index].value[0].addDestinCharge=this.addDestinCharge;
                this.toHoldData[index].value[0].addAdditionalCharge = this.addAdditionalCharge;
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
                this.toHoldData[index].value[0].buyingRateInput = this.buyingRateInput;
                this.toHoldData[index].value[0].transitTime = this.transitTime;
            }
        }
    }
    updateBuyingRate(){
        let dtoTotal = 0;   
        let additonalChargeTotal = 0; 
        let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected;
        let index  = this.toHoldData.findIndex(x=>x.key == keyName);
        if(index != -1){
            if(this.toHoldData[index].value.length > 0){
                let dto = this.toHoldData[index].value[0];
                if(this.addServiceCharge == true && this.totalSl > 0) dtoTotal +=  parseInt(this.totalSl);
                if(this.addOriginCharge == true && this.TotalOrigincharges > 0) dtoTotal += parseInt(this.TotalOrigincharges );  
                if(this.addDestinCharge == true && this.destinTotalCharges > 0) dtoTotal +=  parseInt(this.destinTotalCharges);
                if(this.addExWorksCharge == true && this.exWorksTotal > 0) dtoTotal += parseInt(this.exWorksTotal);
                if(dto.additionalChargeList.length > 0){
                    dto.additionalChargeList.forEach(addCha => {
                        if(addCha.value > 0){
                            additonalChargeTotal = additonalChargeTotal + addCha.value;
                        }
                    });
                }
                if(additonalChargeTotal > 0 ) {
                    this.additionalChargeTotal = parseInt(additonalChargeTotal);
                    if(this.addAdditionalCharge == true ) dtoTotal = dtoTotal + parseInt(additonalChargeTotal);
                }
            }
        }
        if(this.buyingRateInput > 0) dtoTotal = (parseFloat(dtoTotal) + parseFloat(this.buyingRateInput)).toFixed(2);
        this.buyingRate = dtoTotal > 0 ? dtoTotal : 0;
    }
    @api handleUpdateCalculation(){
        let dtoTotal = 0;   
        let chargeableWeight = 1;
        let additonalChargeTotal = 0; 
        let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected;  
        let index  = this.toHoldData.findIndex(x=>x.key == keyName);
        if(index != -1){
            if(this.toHoldData[index].value.length > 0){
                let dto = this.toHoldData[index].value[0];
                console.log('dto '+JSON.stringify(dto,null,2))
                if(dto.totalRate > 0) dtoTotal +=  parseInt(dto.totalRate);  
                if(dto.addServiceCharge == false && this.totalSl > 0) dtoTotal +=  parseInt(this.totalSl);
                if(dto.addOriginCharge == false && this.TotalOrigincharges > 0) dtoTotal += parseInt(this.TotalOrigincharges );  
                if(dto.addDestinCharge == false && this.destinTotalCharges > 0) dtoTotal +=  parseInt(this.destinTotalCharges);
                if(dto.addExWorksCharge == false && this.exWorksTotal > 0) dtoTotal += parseInt(this.exWorksTotal);
                if(dto.additionalChargeList.length > 0){
                    dto.additionalChargeList.forEach(addCha => {
                        if(addCha.value > 0){
                            additonalChargeTotal = additonalChargeTotal + addCha.value;
                        }
                    });
                }
                if(additonalChargeTotal > 0 ) {
                    this.additionalChargeTotal = parseInt(additonalChargeTotal);
                    if(dto.addAdditionalCharge == false )dtoTotal = dtoTotal + parseInt(additonalChargeTotal);
                }
                dto.total= dtoTotal;
                chargeableWeight = dto.chargeableWeight;
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
            profit = isNaN(profit) ? 0 : profit;        }
        else if(this.sellingRate <= 0 && isNaN(this.sellingRate)){
            this.margin = 0;
            profit = 0;
        }
        this.buyingRateKg = (parseInt(this.buyingRate)/parseInt(chargeableWeight)).toFixed(2);
        this.sellingRateKg = (parseInt(this.sellingRate)/parseInt(chargeableWeight)).toFixed(2);
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
    handleNewServiceCharge(){
        this.showNewServiceCharge = true;
    }
    handleCloseNewServiceCharge(){
        this.showNewServiceCharge = false;
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
    handlebuyingRateChange(e){
        this.buyingRateInput = parseFloat(e.target.value);
        let BuyingRateField = this.template.querySelector("[data-field='BuyingRateField']")
            BuyingRateField.setCustomValidity("");
            BuyingRateField.reportValidity();
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    handleExWorksTotalChange(e){
        let value = parseInt(e.target.value)
        this.exWorksObj.LoadCharge = value
        this.exWorksTotal = value
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    handleaddServiceChargeChange(e){
        this.addServiceCharge = e.target.checked;
        this.updateTabsData();
        this.updateBuyingRate();
        this.handleUpdateCalculation();
    }
    handleaddOriginChargeChange(e){
        this.addOriginCharge = e.target.checked;
        this.updateTabsData();
        this.updateBuyingRate();
        this.handleUpdateCalculation();
    }
    handleaddDestinChange(e){
        this.addDestinCharge = e.target.checked;
        this.updateTabsData();
        this.updateBuyingRate();
        this.handleUpdateCalculation();
    }
    handleaddAdditionalChange(e){
        this.addAdditionalCharge = e.target.checked;
        this.updateTabsData();
        this.updateBuyingRate();
        this.handleUpdateCalculation();
    }
    handleaddExWorksChargeChange(e){
        this.addExWorksCharge = e.target.checked;
        this.updateTabsData();
        this.updateBuyingRate();
        this.handleUpdateCalculation();
    }
    handleGenerateQuotaion(){
        let allValid = true;
        let dto = {}; 
        let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected;
        let index = this.toHoldData.findIndex(x=>x.key == keyName)
        if(index != -1){
            dto = this.toHoldData[index].value[0];
        }
        console.log('dto '+JSON.stringify(dto,null,2))
        console.log('optyId '+JSON.stringify(this.optyId,null,2))
        if(!dto.totalRate > 0) {
            let totalRateField = this.template.querySelector("[data-field='totalRateField']")
            totalRateField.setCustomValidity("Selling rate should be greater then 0");
            totalRateField.reportValidity();
            allValid = false;
        }
        if(!dto.buyingRateInput > 0){
            let totalRateField = this.template.querySelector("[data-field='BuyingRateField']")
            totalRateField.setCustomValidity("Buying rate should be greater then 0");
            totalRateField.reportValidity();
            allValid = false;
        }
        if(allValid){
            genrateAirImportQuotation({
                routeId: this.routeId,
                optyId : this.optyId,
                quotationId : this.quotationId,
                dto : dto,
                quoteRemarks: this.quoteRemarks,
                additionalChargeTotal : this.additionalChargeTotal,
                cameReviseCompt : this.cameReviseCompt,
                sameRoute:this.sameRoute,
                agentName : this.agentTabSelected,
                airLine : this.shippingTabSelected
            }).then(result =>{
                console.log('generate quote result : ', JSON.stringify(result,null,2));
                if(result != null){
                    this.quotationSaved = true;
                    this.quotationId = result;
                   let index  = this.toHoldData.findIndex(x=>x.key == keyName);
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
        else{
            const evt = new ShowToastEvent({
                title: 'Missing Field',
                message: 'Buying/Selling rate must be greater then 0.',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }
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