import { LightningElement,api,track } from 'lwc';
import getRMSDetails from '@salesforce/apex/BAFCOAirEnquiryController.getRMSDetails';
import genrateQuotation from '@salesforce/apex/BAFCOAirEnquiryController.genrateQuotation';
import updateValidityDate from '@salesforce/apex/BAFCOLRoutingDetailsController.updateValidityDate';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
export default class BAFCOAirExportQuoteIntakeForm extends NavigationMixin(LightningElement) {
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
    @track tempshippingTabSelected = '';
    @track transitTime = 0;

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
    @track isAirString = 'true';
    @track rmsId = '';
    @track addShippinglineModel = false;

    @track incoChargList = [];
    @track chargeableWeight = 0;

    @track showAdditionalChargeModal = false;
    @track additionalChargeList = [];
    @track additionalChargeIndex = 0;
    @track equipmentId ='';
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
    @track displayCargoDetails = false;



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
    @track buyingRateKg = 0;
    @track sellingRateKg = 0;
    @track rateType = '';
    @track airExport = true;
    connectedCallback(){
        this.getRMSDetails();
    }
    getRMSDetails(){
        getRMSDetails({ 
            portLoading : this.portLoading,
            portDestination: this.portDestination,
            commodity: this.commodity,
            routeId: this.routeId,
            optyId:this.optyId
         })
        .then(result =>{
            console.log('result '+JSON.stringify(result,null,2))
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
                this.routingList.push({value:conts[key], key:key});
                //this.quotationId = conts[key][0].quotationId
                let templist = [];
                for(let equip in conts[key]){
                    templist.push({
                        'equipment' : conts[key][equip].equipmentName,
                        'sellingRate': 0,
                        'similarEquipSubmitted':false,
                        'profit' : 0,
                        'margin':0,
                        'validity':conts[key][equip].validity,
                        'quantity':conts[key][equip].quantity,
                        'uniqueEquip':conts[key][equip].uniqueEquip,
                        'currencyCode':'USD',
                        'cssClass':'',
                        savedClicked:false

                    })
                }
            }
            //Loop to hold the update to be updated on Tab change
            let noRateElemFound = false;
                let tempList = [];
                for(let key in conts){
                    for(let equip in conts[key]){   
                        if(conts[key][equip].equipmentId == '') noRateElemFound = true;          
                        let dd = key+'-'+conts[key][equip].uniqueEquip
                        tempList.push({
                            key: dd,
                            value:[]
                        })
                    }                
                }
                if(noRateElemFound){
                    const evt = new ShowToastEvent({
                        title: 'Routes without rate found.',
                        message: 'This enquiry has routes for which buying rate is not available. Kindly add all buying rates before selecting any item for quotation.',
                        variant: 'info',
                        mode: 'sticky'
                    });
                    this.dispatchEvent(evt);
                }
                this.toHoldData = tempList;
        }).catch(error=>{
            console.log('error routing: ', JSON.stringify(error));
        });
    }
    
    handleAddShippingline(){
        this.addShippinglineModel = true;
    }
    handlecloseAddShippLine(){
        this.addShippinglineModel = false;
    }
    handleAddShipLine(e){
        console.log('came ');
        this.addShippinglineModel = false;
        let temp = e.detail;
        this.tempshippingTabSelected = temp ;
        this.airLine = temp
        this.showAddRatesModel = true;
    }
    handledAddRateSave(){
        this.showAddRatesModel = false;
        eval("$A.get('e.force:refreshView').fire();");
    }
    handleAddNewServiceCharge(){
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
        this.additionalChargeList.forEach(elem=>{
            if(elem.index == index) elem.value = parseInt(event.target.value);
        })
        this.updateTabsData();
        this.handleBuyingRate();
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
    showErrorToast(error) {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: error,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
    handleTransitTime(e){
        this.transitTime = e.target.value;
        this.updateTabsData();
    }
    updateTabsData(){
        this.handleBuyingRate();
        let keyName = this.shippingTabSelected+'-'+this.shippingEquipTabSelected;        
        this.toHoldData.forEach(elem => {
            if(elem.key == keyName){
                if(elem.value.length == 1){
                    elem.value[0].seaFreightSellRate = this.seaFreightSellRate;
                    elem.value[0].quotationItemId = this.quotationItemId;                    
                    elem.value[0].additionalChargeList = this.additionalChargeList;
                    elem.value[0].quantity=this.equipQuantity;
                    elem.value[0].addServiceCharge=this.addServiceCharge;
                    elem.value[0].addOriginCharge=this.addOriginCharge;
                    elem.value[0].addDestinCharge=this.addDestinCharge;
                    elem.value[0].addAdditionalCharge = this.addAdditionalCharge;
                    elem.value[0].exWorksObj = this.exWorksObj;
                    elem.value[0].addExWorksCharge = this.addExWorksCharge;
                    elem.value[0].displayExworks = this.displayExworks;
                    elem.value[0].exWorksTotal = this.exWorksTotal
                    elem.value[0].includeServiceCharge = this.includeServiceCharge
                    elem.value[0].includeOriginCharge = this.includeOriginCharge
                    elem.value[0].includeDestinCharge = this.includeDestinCharge
                    elem.value[0].includeAdditionalCharge = this.includeAdditionalCharge
                    elem.value[0].includeExWorksCharge = this.includeExWorksCharge
                    elem.value[0].quoteBuyingRate = this.buyingRate;
                    elem.value[0].currencyCode = this.currencyCode;
                    elem.value[0].transitTime = this.transitTime;
                }
            }
        });
    }
    assignTabsData(){
        let tempList3 = [];
        tempList3.push({
            'name':'Total Ex-Works Charges',
            'value':null,
            'index':this.additionalChargeIndex
        })
        this.additionalChargeIndex++;
        this.additionalChargeList = tempList3;
        this.displayAdditionalCharge = true
        let keyName = this.shippingTabSelected+'-'+this.shippingEquipTabSelected; 
        let seletedEquipName1 = '';
        let isFDAccount = false;
        let chargeableWeight = 0;
        let currencyCode = '';
        let tabView = '';
        let buyingRateInput =0;
        let dedicatedRoutingObj1 = this.routingListMap[this.shippingTabSelected];
        let elemIndex = dedicatedRoutingObj1.findIndex(x=>x.uniqueEquip == this.shippingEquipTabSelected);
        if(elemIndex != -1){
            seletedEquipName1 = dedicatedRoutingObj1[elemIndex].equipmentName;
            isFDAccount = dedicatedRoutingObj1[elemIndex].fdAccount;
            chargeableWeight = dedicatedRoutingObj1[elemIndex].chargeableWeight;
            this.chargeableWeight = chargeableWeight
            buyingRateInput = dedicatedRoutingObj1[elemIndex].seaFreight;
            currencyCode = dedicatedRoutingObj1[elemIndex].currencyCode;
            this.currencyCode = dedicatedRoutingObj1[elemIndex].currencyCode;
            tabView = dedicatedRoutingObj1[elemIndex].equipmentName;
        }
        if(isFDAccount == true){
            tempList3.push({
                'name':'Freight Difference(FD)',
                'value':null,
                'index':this.additionalChargeIndex
            })
            this.additionalChargeIndex++;
            this.additionalChargeList = tempList3;
            this.displayAdditionalCharge = true
        }
        this.toHoldData.forEach(elem => {
            if(elem.key == keyName){
                if(elem.value.length == 0){
                    let tempList = [];
                    tempList.push({
                        'seaFreightSellRate':0,
                        'quotationItemId':'',
                        'quoteBuyingRate':0,
                        'quantity':this.equipQuantity,
                        'addServiceCharge':true,
                        'addOriginCharge':true,
                        'addDestinCharge':true,
                        'addAdditionalCharge':true,
                        'addExWorksCharge':true,
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
                        'similarEquipSubmitted':false,
                        'selectedShippLine':this.shippingTabSelected,
                        'selectedEquipment':tabView,
                        'currencyCode':currencyCode,
                        'incoTermId':this.incoTermId,
                        'transitTime':0,
                        'chargeableWeight':chargeableWeight,
                        'buyingRateInput':buyingRateInput,
                        'portLoadingId':this.portLoadingId,
                        'portDestination':this.portDestination,
                        'portDestinationId':this.portDestinationId,
                    })
                    elem.value = tempList;
                }
                else if(elem.value.length > 0){
                     this.seaFreightSellRate = elem.value[0].seaFreightSellRate ;
                     this.equipQuantity = elem.value[0].quantity;
                     this.quotationItemId = elem.value[0].quotationItemId != undefined ? elem.value[0].quotationItemId : '';                     
                    if(elem.value[0].additionalChargeList.length > 0){
                        this.additionalChargeList = elem.value[0].additionalChargeList;
                        if(this.additionalChargeList.length > 0) this.displayAdditionalCharge = true
                        else this.displayAdditionalCharge = false
                    }
                    this.total = elem.value[0].total;
                    this.chargeableWeight = elem.value[0].chargeableWeight;
                    this.addServiceCharge = elem.value[0].addServiceCharge;
                    this.addOriginCharge = elem.value[0].addOriginCharge;
                    this.addDestinCharge = elem.value[0].addDestinCharge;
                    this.addAdditionalCharge = elem.value[0].addAdditionalCharge;
                    this.addExWorksCharge = elem.value[0].addExWorksCharge;
                    this.exWorksObj = elem.value[0].exWorksObj;
                    this.displayExworks = elem.value[0].displayExworks;
                    this.exWorksTotal = elem.value[0].exWorksTotal;
                    this.includeServiceCharge = elem.value[0].includeServiceCharge;
                    this.includeOriginCharge = elem.value[0].includeOriginCharge;
                    this.includeDestinCharge = elem.value[0].includeDestinCharge;
                    this.includeAdditionalCharge = elem.value[0].includeAdditionalCharge;
                    this.includeExWorksCharge = elem.value[0].includeExWorksCharge;
                    this.transitTime = elem.value[0].transitTime;
                    this.buyingRateInput = elem.value[0].buyingRateInput;
                    this.currencyCode = elem.value[0].currencyCode;
                }
            }
        });
        
       this.checkSaveQuoteClicked();  
        this.handleBuyingRate(); 
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
        this.handleBuyingRate();
        this.handleUpdateCalculation();
    }
    handleAddExWorks(e){
        this.displayExWorksModal = false;
        let selectedExWorks = e.detail.tempObj;
        this.displayExworks = true;
        this.exWorksObj= selectedExWorks;
        this.exWorksTotal = selectedExWorks.LoadCharge > 0 ? selectedExWorks.LoadCharge : 0;
        this.updateTabsData();
        this.handleBuyingRate();
        this.handleUpdateCalculation();
    }
    handleExWorksTotalChange(e){
        let value = parseInt(e.target.value)
        this.exWorksObj.LoadCharge = value
        this.exWorksTotal = value
        this.updateTabsData();
        this.handleBuyingRate();
        this.handleUpdateCalculation();
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
    handleCloseErrorPopup(){
        this.showErrorPopup = false;
    }
    handleRemarksChange(e){
        this.quoteRemarks = e.target.value;
    } 
    handleAddAdditionalCharge(e){
        this.showAdditionalChargeModal = true;
    }
    handleCloseAdditionalModal(){
        this.showAdditionalChargeModal = false;
    }
    handleQuickActionClicked(){
        this.showProcument = true;
    }
    handleCloseProcurement(){
        this.showProcument = false;
    }
    processData(){
        let dedicatedRoutingObj = this.routingListMap[this.shippingTabSelected];
        dedicatedRoutingObj.forEach(elem =>{
            if(elem.uniqueEquip == this.shippingEquipTabSelected){
                console.log('elem '+JSON.stringify(elem,null,2))
                if(elem.equipmentId != ''){
                    this.seaFreight = elem.seaFreight;
                    this.validity = elem.validity;
                    this.equipmentId = elem.equipmentId;
                    this.equipNotfound = false ;
                    this.quantity = elem.quantity;
                    this.quotationItemId =elem.quotationItemId;
                    this.rmsId = elem.rmsID
                    this.equipQuantity = elem.quantity
                    this.rateType = elem.rateType
                    this.rmsRemarks = elem.rmsRemarks
                }
                else{
                    //this.shippingEquipTabSelected = this.shippingEquipTabSelected;
                    this.equipNotfound = true ; 
                }
            }
        })
        //this.getIncoCharges();
        this.isLoading = true;
        this.getServiceCharges();
        this.assignTabsData();

        let keyName = this.shippingTabSelected+'-'+this.shippingEquipTabSelected;  
            this.toHoldData.forEach(elem => {
                if(elem.key == keyName){
                    if(elem.value[0].savedClicked  != undefined){
                        if(elem.value[0].savedClicked == true){
                            this.quotationSaved = true;
                        }
                        else{
                            this.quotationSaved = false;
                        }
                    }
                }
            });
            this.handleUpdateCalculation();
    }
    handleAddWorks(){
        this.displayExWorksModal = true;
    }
    handleCloseExworks(){
        this.displayExWorksModal = false;
    }
    handleaddServiceChargeChange(e){
        this.addServiceCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
        this.handleUpdateCalculation();
    }
    handleaddOriginChargeChange(e){
        this.addOriginCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
        this.handleUpdateCalculation();
    }
    handleaddDestinChange(e){
        this.addDestinCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
        this.handleUpdateCalculation();
    }
    handleaddAdditionalChange(e){
        this.addAdditionalCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
        this.handleUpdateCalculation();
    }
    handleaddExWorksChargeChange(e){
        this.addExWorksCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
        this.handleUpdateCalculation();
    }
    handleincludeServiceChargeChange(e){
        this.includeServiceCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
    }
    handleincludeOriginChargeChange(e){
        this.includeOriginCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
    }
    handleincludeDestinChargeChange(e){
        this.includeDestinCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
    }
    handleincludeAdditionalChargeChange(e){
        this.includeAdditionalCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
    }
    handleincludeExWorksChargeChange(e){
        this.includeExWorksCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
    }
    checkSaveQuoteClicked(){
        let dedicatedRoutingObj1 = this.routingListMap[this.shippingTabSelected];
        let foundTrue = false;
        let seletedEquipName1 = '';
        dedicatedRoutingObj1.forEach(elem =>{
            if(elem.uniqueEquip == this.shippingEquipTabSelected)
            seletedEquipName1 = elem.equipmentName;
        })
        let equipNameList = [];
        dedicatedRoutingObj1.forEach(elem =>{
            if(elem.equipmentName == seletedEquipName1){
                equipNameList.push(elem.uniqueEquip)
            }
        })
        if(equipNameList.length > 0){
            equipNameList.forEach(elem=>{
                let keyName = this.shippingTabSelected+'-'+elem;
                this.toHoldData.forEach(elem => {
                    if(elem.key == keyName){
                        if(elem.value.length > 0){
                            if(elem.value[0].similarEquipSubmitted == true) foundTrue = true;
                        }
                    }
                });

            })
            if(foundTrue){
                equipNameList.forEach(elem=>{
                    let keyName = this.shippingTabSelected+'-'+elem;
                    this.toHoldData.forEach(elem => {
                        if(elem.key == keyName){
                            if(elem.value.length > 0){
                                elem.value[0].similarEquipSubmitted = true;
                            }
                        }
                    });
    
                })
            }
        }
    }
    @api getValidityDate(){
        let ToReturnValidity = null;
        let dedicatedRoutingObj = this.routingListMap[this.shippingTabSelected];
        let index  = dedicatedRoutingObj.findIndex(x=>x.uniqueEquip == this.shippingEquipTabSelected);
        ToReturnValidity = dedicatedRoutingObj[index].buyingRateValidity;
        return ToReturnValidity;
    }
    handleBuyingRate(){
        let dtoTotal = 0;   
        let additonalChargeTotal = 0; 
        let keyName = this.shippingTabSelected+'-'+this.shippingEquipTabSelected;
        let index  = this.toHoldData.findIndex(x=>x.key == keyName);
        if(index != -1){
            if(this.toHoldData[index].value.length > 0){
                let dto = this.toHoldData[index].value[0];
                if(dto.buyingRateInput > 0 ) dtoTotal += parseInt(dto.buyingRateInput)
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
        //if(this.buyingRateInput > 0) dtoTotal = parseInt(dtoTotal) + parseInt(this.buyingRateInput);
        this.buyingRate = dtoTotal > 0 ? dtoTotal : 0;
    }
    handleUpdateCalculation(){
        let dtoTotal = 0;   
        let additonalChargeTotal = 0;  
        let chargeableWeight = 1;   
        let keyName = this.shippingTabSelected+'-'+this.shippingEquipTabSelected;     
            this.toHoldData.forEach(elem => {
                if(elem.key == keyName){
                    if(elem.value.length > 0){
                        let dto = elem.value[0];
                        dtoTotal = dtoTotal + dto.seaFreightSellRate;                        
                        dto.incoChargList.total = dtoTotal - dto.seaFreightSellRate;
                        // adding totala of AdditionalCharge 
                        if(dto.additionalChargeList.length > 0){
                            dto.additionalChargeList.forEach(addCha => {
                                if(addCha.value > 0){
                                    //dtoTotal = dtoTotal + addCha.value;
                                    additonalChargeTotal = additonalChargeTotal + addCha.value;
                                }
                            });
                        }
                        if(dto.addServiceCharge == false && this.totalSl > 0) dtoTotal = dtoTotal + this.totalSl       
                        
                        if(dto.addOriginCharge == false && this.TotalOrigincharges > 0) dtoTotal = dtoTotal + this.TotalOrigincharges   
                        if(dto.addDestinCharge == false && this.destinTotalCharges > 0) dtoTotal = dtoTotal + this.destinTotalCharges
                        if(dto.addExWorksCharge == false && this.exWorksTotal > 0) dtoTotal = dtoTotal + this.exWorksTotal
                        if(additonalChargeTotal > 0 ) {
                            if(dto.addAdditionalCharge == false) dtoTotal = dtoTotal + additonalChargeTotal;
                            this.additionalChargeTotal = additonalChargeTotal;
                        }
                        dto.total= dtoTotal;
                        chargeableWeight = dto.chargeableWeight;
                    }
                }
            });
            
            if(!isNaN(dtoTotal)){
            this.sellingRate = parseInt(dtoTotal);
            this.total = dtoTotal;
            }else{
                this.sellingRate = 0;
                this.total = 0;
            }

           
            let profit = 0;
            if(this.sellingRate > 0 && !isNaN(this.sellingRate)){
            profit = this.sellingRate - this.buyingRate;
             console.log('profit '+profit)
            let margin  = profit/this.sellingRate;
            this.margin = isNaN(margin) ? 0 : margin * 100;
            this.margin = this.margin.toFixed(2);
            profit = isNaN(profit) ? 0 : profit;
            }
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
            //}
        this.isLoading = false;
    }
    handleshippingLineActive(e){
        this.margin = 0;        
        this.resetCalculation();    
        this.shippingEquipTabSelected = '';    
        this.shippingTabSelected = e.target.value;   
        console.log('shippingTabSelected '+this.shippingTabSelected)
        this.tempshippingTabSelected =   e.target.value;   
        let dedicatedRoutingObj = this.routingListMap[this.shippingTabSelected]; 
        console.log('dedicatedRoutingObj '+JSON.stringify(dedicatedRoutingObj,null,2))
        let elem  = 0;
        this.shippingEquipTabSelected  = dedicatedRoutingObj[elem].uniqueEquip;
        this.processData();
    }
    handleEquipmentActive(e){
        this.resetCalculation();
        let profitButton =  this.template.querySelector('.profitButton');
        if(profitButton != undefined){
         profitButton.style = "background:#FF9800;height: 50px;border-radius: 4px;"
        }
        let tabSelected = e.target.value;
        this.shippingEquipTabSelected = tabSelected;
        this.processData();
    }
    handleShowServiceCharge(){
        this.showServiceChargeModal = true; 
    }
    handleCloseModal(){
        this.showServiceChargeModal = false; 
    }
    resetCalculation(){
        this.chargeableWeight = null
        this.buyingRate = 0;
        this.rateType ='';
        this.rmsRemarks = '';
        this.quantity=0;
        this.sellingRate = 0;
        this.seaFreightSellRate = 0;
        this.equipQuantity = 0;
        this.additionalChargeList = [];
        this.profitLabel = '$ Profit';
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
        this.transitTime = null;
    }
    processData(){
        let dedicatedRoutingObj = this.routingListMap[this.shippingTabSelected];
        dedicatedRoutingObj.forEach(elem =>{
            if(elem.uniqueEquip == this.shippingEquipTabSelected){
                console.log('elem '+JSON.stringify(elem,null,2))
                if(elem.equipmentId != ''){
                    this.seaFreight = elem.seaFreight;
                    this.validity = elem.validity;
                    this.equipmentId = elem.equipmentId;
                    this.equipNotfound = false ;
                    this.quantity = elem.quantity;
                    this.rmsId = elem.rmsID
                    this.rateType = elem.rateType
                }
                else{
                    this.equipNotfound = true ; 
                }
            }
        })
        //this.getIncoCharges();
        this.isLoading = true;
        this.assignTabsData();

        let keyName = this.shippingTabSelected+'-'+this.shippingEquipTabSelected;  
            this.toHoldData.forEach(elem => {
                if(elem.key == keyName){
                    if(elem.value[0].savedClicked  != undefined){
                        if(elem.value[0].savedClicked == true){
                            this.quotationSaved = true;
                        }
                        else{
                            this.quotationSaved = false;
                        }
                    }
                }
            });
            this.handleUpdateCalculation();
    }
    handleAddRates(){
        this.airLine = this.shippingTabSelected
        this.showAddRatesModel = true;
    }
    handleCloseAddRates(){
        this.showAddRatesModel = false;
    }
    handleSellRateChange(e){
        this.seaFreightSellRate = parseInt(e.target.value);  
        let sellingRateField = this.template.querySelector("[data-field='sellingRateField']");
            sellingRateField.setCustomValidity("");
            sellingRateField.reportValidity();      
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    handleGenerateQuotaion(){
        let keyName = this.shippingTabSelected+'-'+this.shippingEquipTabSelected;
        let allValid = true;
        let dto = {}; 
        this.toHoldData.forEach(elem => {
            if(elem.key == keyName){
                dto = elem.value[0]
            }
        });
        console.log('dto '+JSON.stringify(dto,null,2))
        if(dto.seaFreightSellRate == 0) {
            //this.showErrorPopup = true;
            let sellingRateField = this.template.querySelector("[data-field='sellingRateField']")
            sellingRateField.setCustomValidity("Selling rate should be greater then 0");
            sellingRateField.reportValidity();
            let error= 'Selling rate should be greater then 0.'
            //this.showErrorToast(error);
            allValid = false;
        }
        else if(dto.similarEquipSubmitted == true){
            allValid = false;
            let error = 'Similar equipment already submitted.'
            this.showErrorToast(error);
        }
        if(allValid){
            genrateQuotation({
                routeId: this.routeId,
                rmsId: this.rmsId,
                enquiryId : this.optyId,
                quotationId : this.quotationId,
                dto : dto,
                incoTerm : this.incoTerm,
                cameReviseCompt : this.cameReviseCompt,
                sameRoute:this.sameRoute,
                quoteRemarks: this.quoteRemarks,
                additionalChargeTotal : this.additionalChargeTotal,
                airLine : this.shippingTabSelected
            }).then(result =>{
                console.log('generate quote result : ', JSON.stringify(result,null,2));
                let keyName = this.shippingTabSelected+'-'+this.shippingEquipTabSelected;
                
                this.toHoldData.forEach(elem => {
                    if(elem.key == keyName){
                        elem.value[0].savedClicked = true;
                    }
                });
                // disabling generate quote for remaining similarEquip
                let seletedEquipName1 = '';
                let dedicatedRoutingObj1 = this.routingListMap[this.shippingTabSelected];
                dedicatedRoutingObj1.forEach(elem =>{
                    if(elem.uniqueEquip == this.shippingEquipTabSelected)
                    seletedEquipName1 = elem.equipmentName;
                })
                let equipNameList = [];
                dedicatedRoutingObj1.forEach(elem =>{
                    if(elem.equipmentName == seletedEquipName1){
                        equipNameList.push(elem.uniqueEquip)
                    }
                })
                if(equipNameList.length > 0){
                    equipNameList.forEach(elem=>{
                        let keyName = this.shippingTabSelected+'-'+elem;
                        this.toHoldData.forEach(elem => {
                            if(elem.key == keyName){
                                if(elem.value.length > 0){
                                    elem.value[0].similarEquipSubmitted = true;
                                }
                            }
                        });

                    })
                }
                this.quotationSaved = true;
                this.quotationId = result;
                this.dispatchEvent(new CustomEvent('showquotebtn',{ detail: {quoteId : this.quotationId}}));
            
            }).catch(error=>{
                console.log('generate quote error', JSON.stringify(error));
            })
        }
    }
    handleCloseCargoDetailsPopUp(){
        this.displayCargoDetails = false;
    }
    handleShowCargoDetails(){
        this.displayCargoDetails = true;
    }
}