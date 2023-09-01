import { LightningElement,api,track } from 'lwc';
import getImportRMSDetails from '@salesforce/apex/BAFCOImportQuoteController.getImportRMSDetails';
import getIncoCharges from '@salesforce/apex/BAFCOLRoutingDetailsController.getIncoCharges';
import getClassification from '@salesforce/apex/BAFCOshippingLineChargesController.getShippingCharges';
import genrateQuotation from '@salesforce/apex/BAFCOImportQuoteController.genrateQuotation';
import updateValidityDate from '@salesforce/apex/BAFCOLRoutingDetailsController.updateValidityDate';
import getDestintionCharges from '@salesforce/apex/BAFCOshippingLineChargesController.getDestintionCharges';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class BAFCOImportRouteDetails extends NavigationMixin(LightningElement) {
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
    @api acctName = '';
    @api cargoReadiness = '';

    @track addAgentModel = false;
    @track agentTabSelected = '';
    @track addShippinglineModel = false;
    @track shippingTabSelected = '';
    @track routingList = [];
    @track routingListMap=[];
    @track routlistNotfound = false;
    @track hideCalculationSection = false;
    @track agentObject;
    @track equipNotfound = false;
    @track seaFreight;
    @track seaFreightSellRate;
    @track equipQuantity = 0;
    @track shippingEquipTabSelected ='';
    @track validity;
    @track equipmentId;
    @track buyingRate;
    @track daysLeft;
    @track quantity;
    @track quotationItemId;
    @track toHoldData = [];
    @track quotationSaved;
    @track rmsId = '';
    @track isLoading=false;
    @track serviceChargeObj;
    @track sellingRate;
    @track total;
    @track margin;
    @track quotationMap=[];
    @track profitLabel = 'USD 0 Profit'
    @track showServiceChargeModal = false
    @track incoChargList = [];
    @track showAddRatesModel = false
    @track showAdditionalChargeModal = false;
    @track additionalChargeList=[];
    @track additionalChargeIndex = 0;
    @track showNewServiceCharge = false;
    @track serviceChargeList = {};
    @track rateType =''
    @track rmsRemarks = '';


    ///////////
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
    @track displayAdditionalTotal = false;


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
    @track sellingadditionalChargeTotal = 0;
    @track displayAdditionalCharge;
    @track showAdditionalChargetemplate = false;
    @track quoteRemarks = '';
    @track destinationChargeList = {}

    @track showProcument = false;
    @track tempShippingTab
    @track addServiceCharge=true;
    @track addOriginCharge = true;
    @track addDestinCharge=true;
    @track addAdditionalCharge = true;
    @track includeServiceCharge=false;
    @track includeOriginCharge = false;
    @track includeDestinCharge=false;
    @track includeAdditionalCharge = false;
    @track includeExWorksCharge = false;

    @track addExWorksCharge=true;
    @track displayExWorksModal = false;
    @track exWorksObj;
    @track exWorksTotal = 0;
    @track displayExworks = false;
    @track currencyCode = 'USD';


    // SELLING Variable ////
        ///////////
        @track sellingBAF ;
        @track sellingbunkerCharges;
        @track sellingcleaningCharges;
        @track sellingCMC;
        @track sellingcarriageCongestionSurcharge;
        @track sellingcarrierSecurityFees;
        @track sellingdgSurcharge;
        @track sellingDTHC;
        @track sellingequipmentImbalance;
        @track sellinginlandFuelCharges;
        @track sellinginlandHandlingfees;
        @track sellinginlandHaulage;
        @track sellingISPS;
        @track sellinglowerSulphurSurcharge;
        @track sellingoperationalRecovery;
        @track sellingOTHC;
        @track sellingoverWeightCharge;
        @track sellingsealCharges;
        @track sellingwarRiskSurcharges;
        @track sellingtotalSl;
        @track sellingexWorksTotal;
    
    
        //@
        @track sellingbayan;
        @track sellingblFees;
        @track sellingoriginCustomClearance;
        @track sellingexportServiceFees;
        @track sellingfasahFees;
        @track sellingfuelSurcharge;
        @track sellinginspection;
        @track sellinginsuranceCharges;
        @track sellingliftOnLiftOff;
        @track sellingOriginDetention;
        @track sellingOriginLoadingCharges;
        @track sellingpickUpCharges;
        @track sellingReeferControlPlugInCharge;
        @track sellingtabadul;
        @track sellingtrapulinCharges;
        @track sellingtruckIdlingCharges;
        @track sellingtransportationCharges;
        @track sellingvgm;
        @track sellinglashingCharges;
        @track sellingxray;
        @track sellingTotalOrigincharges;

        @track sellingdestinBayanCharges;
        @track sellingdestinCustomClearanceCharges;
        @track sellingdestinDOCharges;
        @track sellingdestinFasahCharges;
        @track sellingdestinGatePassCharges;
        @track sellingdestinLOLOCharges;
        @track sellingdestinTransPortationCharges;
        @track sellingdestinTotalCharges;
    // ****************////

    connectedCallback(){     
        if(this.routeId){
            this.getImportRMSDetails();
        }
        
    }
    
    getImportRMSDetails(){
        getImportRMSDetails({
            portLoading : this.portLoading,
            portDestination: this.portDestination,
            commodity: this.commodity,
            routeId: this.routeId,
            enquiryId:this.enquiryId
        })
        .then(result=>{
            //console.log('result ',JSON.stringify(result,null,2));
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
             let noRateElemFound = false;
             for(let key in conts){
                 for(let key2 in conts[key]){
                    for(let key3 in conts[key][key2]){
                        if(conts[key][key2][key3].equipmentId == '') noRateElemFound = true;  
                        let dd=key+'-'+key2+'-'+conts[key][key2][key3].uniqueEquip
                        holdtempList.push({
                            key: dd,
                            value:[]
                        }) 
                        /*templist.push({
                            'sellingRate': 0,
                            'profit' : 0,
                            'margin':0,
                            'similarEquipSubmitted':false,
                            'uniqueEquip':conts[key][key2][key3].uniqueEquip,
                            'validity':conts[key][key2][key3].validity,
                            'quantity':conts[key][key2][key3].quantity,
                            'quotationId':conts[key][key2][key3].quotationId,
                            'cssClass':'',
                            'currencyCode':'USD',
                            'equipment':conts[key][key2][key3].equipmentName,
                            savedClicked:false
                        })
                        let parentKey = key+'-'+key2+'-'+conts[key][key2][key3].equipmentName+'-'+this.routeName;
                        let existingIndex = this.quotationMap.findIndex(x=>x.key==parentKey);
                        console.log('*** routenae '+this.routeName)
                        console.log('*** inital '+JSON.stringify(this.quotationMap,null,2))
                        let newTempListIndex = templist.findIndex(x=>x.equipment==conts[key][key2][key3].equipmentName);
                        let NewTempList = [];
                        NewTempList.push(templist[newTempListIndex])
                        if(existingIndex == -1) this.quotationMap.push({value : NewTempList,key:parentKey})
                        console.log('*** final '+JSON.stringify(this.quotationMap,null,2))
                        let toBeSend = {
                            'routeName':this.routeName,
                            'quotationMap':this.quotationMap
                        }
                       this.dispatchEvent(new CustomEvent('updatecalculation', { detail: toBeSend })); */
                    }   
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
             this.toHoldData = holdtempList;
        })
        .catch(error=>{
            console.log('error ',JSON.stringify(error,null,2))
        })
    }
    resetCalculation(){
        console.log('reset call ')
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
        this.displayAdditionalTotal = false;
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
        this.serviceChargeList = {};
        this.displayAdditionalCharge = false;
        this.additionalChargeList= [];
        this.additionalChargeTotal = null;
        this.sellingadditionalChargeTotal = null;
        this.exWorksObj = {};
        this.displayExworks =false;
        this.exWorksTotal = null;
        this.currencyCode = '';
        this.sellingBAF = null;
        this.sellingbunkerCharges = null;
        this.sellingcleaningCharges = null;
        this.sellingCMC = null;
        this.sellingcarriageCongestionSurcharge = null;
        this.sellingcarrierSecurityFees = null;
        this.sellingdgSurcharge = null;
        this.sellingDTHC = null;
        this.sellingequipmentImbalance = null;
        this.sellinginlandFuelCharges = null;
        this.sellinginlandHandlingfees = null;
        this.sellinginlandHaulage = null;
        this.sellingISPS = null;
        this.sellinglowerSulphurSurcharge = null;
        this.sellingoperationalRecovery = null;
        this.sellingOTHC = null;
        this.sellingoverWeightCharge = null;
        this.sellingsealCharges = null;
        this.sellingwarRiskSurcharges = null;
        this.sellingtotalSl = null;
        this.sellingexWorksTotal = null;
    
    
        //@
        this.sellingbayan = null;
        this.sellingblFees = null;
        this.sellingoriginCustomClearance = null;
        this.sellingexportServiceFees = null;
        this.sellingfasahFees = null;
        this.sellingfuelSurcharge = null;
        this.sellinginspection = null;
        this.sellinginsuranceCharges = null;
        this.sellingliftOnLiftOff = null;
        this.sellingOriginDetention = null;
        this.sellingOriginLoadingCharges = null;
        this.sellingpickUpCharges = null;
        this.sellingReeferControlPlugInCharge = null;
        this.sellingtabadul = null;
        this.sellingtrapulinCharges = null;
        this.sellingtruckIdlingCharges = null;
        this.sellingtransportationCharges = null;
        this.sellingvgm = null;
        this.sellinglashingCharges = null;
        this.sellingxray = null;
        this.sellingTotalOrigincharges = null;

        this.sellingdestinBayanCharges = null;
        this.sellingdestinCustomClearanceCharges = null;
        this.sellingdestinDOCharges = null;
        this.sellingdestinFasahCharges = null;
        this.sellingdestinGatePassCharges = null;
        this.sellingdestinLOLOCharges = null;
        this.sellingdestinTransPortationCharges = null;
        this.sellingdestinTotalCharges = null;
    }
    
    @api handleShowaddAgentModel(){
        this.addAgentModel = true;
    }
    handleHideAgentModal(){
        this.addAgentModel = false;
    }
    handleAddAgentSelected(e){
        this.addAgentModel = false;
        this.agentObject = e.detail;
        this.agentTabSelected = this.agentObject.Name ;
        this.addShippinglineModel = true;
    }
    handlecloseAddShippLine(e){
        this.addShippinglineModel = false;
    }
    handleAddShipLine(e){
        this.addShippinglineModel = false;
        let temp = e.detail;
        //this.shippingTabSelected = temp ;
        this.tempShippingTab = temp;
        this.showAddRatesModel = true;
    }
    handleCloseAddRates(){
        this.showAddRatesModel = false;
    }
    handledAddRateSave(e){
        eval("$A.get('e.force:refreshView').fire();");
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
       this.processData();
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
        this.processData();
        
    }
    handleEquipmentNameActive(e){
        this.resetCalculation();
        let tabSelected = e.target.value;
        this.shippingEquipTabSelected = tabSelected;
        let profitButton =  this.template.querySelector('.profitButton');
       if(profitButton != undefined){
        profitButton.style = "background:#FF9800;height: 50px;border-radius: 4px;"
       }
       this.processData();
    }
    handleShowServiceCharge(){
        console.log('handleShowServiceCharge ',this.rmsId)
        this.showServiceChargeModal = true; 
    }
    closeServiceChargeModal(){
        this.showServiceChargeModal = false; 
    }
    assignTabsData(){
        let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected;
        let seletedEquipName = '';
        let isFDAccount = false;
        let currencyCode = 'USD';
        let dedicatedRoutingObj = this.routingListMap[this.agentTabSelected];
        let templist090 = [];
        let tankTempList =[];
        for(let key in dedicatedRoutingObj){
            templist090.push({key:key, data: dedicatedRoutingObj[key]})
        }
        let dataIndex = templist090.findIndex(x=>x.key == this.shippingTabSelected);
        if(dataIndex != -1){
            let data = templist090[dataIndex].data;
            if(data.length > 0){
                let elemIndex = data.findIndex(x=>x.uniqueEquip == this.shippingEquipTabSelected);
                if(elemIndex != -1){
                    seletedEquipName = data[elemIndex].equipmentName;
                    isFDAccount = data[elemIndex].fdAccount;
                    currencyCode = data[elemIndex].currencyCode;
                    console.log('data[elemIndex] '+JSON.stringify(data[elemIndex],null,2))
                    this.currencyCode = currencyCode
                }
            }
        }
        if(seletedEquipName == '20ISO'){
            tankTempList.push({
                'name':'Tank Rental Charges',
                'value':null,
                'index':this.additionalChargeIndex,
                'sellingCharge':null
            })
            this.additionalChargeIndex++;
            this.additionalChargeList = tankTempList;
            this.displayAdditionalCharge = true
        }
        if(isFDAccount == true){
            tankTempList.push({
                'name':'Freight Difference(FD)',
                'value':null,
                'index':this.additionalChargeIndex,
                'sellingCharge':null
            })
            this.additionalChargeIndex++;
            this.additionalChargeList = tankTempList;
            this.displayAdditionalCharge = true
        }
                
        this.toHoldData.forEach(elem => {
            if(elem.key == keyName){
                if(elem.value.length == 0){
                    let tempList = [];
                    tempList.push({
                        'seaFreightSellRate':0,
                        'quotationItemId':'',
                        'incoChargList':{},
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
                        'quantity':this.equipQuantity,
                        'additionalChargeList':tankTempList,
                        'serviceChargeList':{},
                        'savedClicked':false,
                        'currencyCode':currencyCode,
                        'offSet':0,
                        'total':0,
                        'pickupPlace' : this.pickupPlaceName,
                        'dischargePlace' : this.dischargePlaceName,
                        'quoteBuyingRate':0,
                        'similarEquipSubmitted':false,
                        'selectedShippLine':this.shippingTabSelected,
                        'selectedEquipment':this.shippingEquipTabSelected,
                        'agentTabSelected':this.agentTabSelected,
                        //'currencyCode':'USD',
                        'incoTermId':this.incoTermId,
                        'sellingBAF':null,
                        'sellingbunkerCharges':null,
                        'sellingcleaningCharges':null,
                        'sellingCMC':null,
                        'sellingcarriageCongestionSurcharge':null,
                        'sellingcarrierSecurityFees':null,
                        'sellingdgSurcharge':null,
                        'sellingDTHC':null,
                        'sellingequipmentImbalance':null,
                        'sellinginlandFuelCharges':null,
                        'sellinginlandHandlingfees':null,
                        'sellinginlandHaulage':null,
                        'sellingISPS':null,
                        'sellinglowerSulphurSurcharge':null,
                        'sellingoperationalRecovery':null,
                        'sellingOTHC':null,
                        'sellingoverWeightCharge':null,
                        'sellingsealCharges':null,
                        'sellingwarRiskSurcharges':null,
                        'sellingtotalSl':null,
                        'sellingexWorksTotal':null,
                    
                    
                        
                        'sellingbayan':null,
                        'sellingblFees':null,
                        'sellingoriginCustomClearance':null,
                        'sellingexportServiceFees':null,
                        'sellingfasahFees':null,
                        'sellingfuelSurcharge':null,
                        'sellinginspection':null,
                        'sellinginsuranceCharges':null,
                        'sellingliftOnLiftOff':null,
                        'sellingOriginDetention':null,
                        'sellingOriginLoadingCharges':null,
                        'sellingpickUpCharges':null,
                        'sellingReeferControlPlugInCharge':null,
                        'sellingtabadul':null,
                        'sellingtrapulinCharges':null,
                        'sellingtruckIdlingCharges':null,
                        'sellingtransportationCharges':null,
                        'sellingvgm':null,
                        'sellinglashingCharges':null,
                        'sellingxray':null,
                        'sellingTotalOrigincharges':null,
                
                        'sellingdestinBayanCharges':null,
                        'sellingdestinCustomClearanceCharges':null,
                        'sellingdestinDOCharges':null,
                        'sellingdestinFasahCharges':null,
                        'sellingdestinGatePassCharges':null,
                        'sellingdestinLOLOCharges':null,
                        'sellingdestinTransPortationCharges':null,
                        'sellingdestinTotalCharges':null,
                    })
                    elem.value = tempList;
                }
                else if(elem.value.length > 0){
                     this.seaFreightSellRate = elem.value[0].seaFreightSellRate ;
                     this.equipQuantity = elem.value[0].quantity;
                     this.quotationItemId = elem.value[0].quotationItemId != undefined ? elem.value[0].quotationItemId : '';
                     if(elem.value[0].additionalChargeList.length > 0){
                        this.additionalChargeList = elem.value[0].additionalChargeList;
                        if(this.additionalChargeList.length > 0 ) this.displayAdditionalCharge = true
                        else this.displayAdditionalCharge = false
                     }
                    this.total = elem.value[0].total;
                    this.serviceChargeList = elem.value[0].serviceChargeList;
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
                    this.sellingBAF = elem.value[0].sellingBAF
                    this.sellingbunkerCharges = elem.value[0].sellingbunkerCharges
                    this.sellingcleaningCharges = elem.value[0].sellingcleaningCharges
                    this.sellingCMC = elem.value[0].sellingCMC
                    this.sellingcarriageCongestionSurcharge = elem.value[0].sellingcarriageCongestionSurcharge
                    this.sellingcarrierSecurityFees = elem.value[0].sellingcarrierSecurityFees
                    this.sellingdgSurcharge = elem.value[0].sellingdgSurcharge
                    this.sellingDTHC = elem.value[0].sellingDTHC
                    this.sellingequipmentImbalance = elem.value[0].sellingequipmentImbalance
                    this.sellinginlandFuelCharges = elem.value[0].sellinginlandFuelCharges
                    this.sellinginlandHandlingfees = elem.value[0].sellinginlandHandlingfees
                    this.sellinginlandHaulage = elem.value[0].sellinginlandHaulage
                    this.sellingISPS = elem.value[0].sellingISPS
                    this.sellinglowerSulphurSurcharge = elem.value[0].sellinglowerSulphurSurcharge
                    this.sellingoperationalRecovery = elem.value[0].sellingoperationalRecovery
                    this.sellingOTHC = elem.value[0].sellingOTHC
                    this.sellingoverWeightCharge = elem.value[0].sellingoverWeightCharge
                    this.sellingsealCharges = elem.value[0].sellingsealCharges
                    this.sellingwarRiskSurcharges = elem.value[0].sellingwarRiskSurcharges
                    this.sellingtotalSl = elem.value[0].sellingtotalSl
                    this.sellingexWorksTotal = elem.value[0].sellingexWorksTotal
                    
                    this.sellingbayan = elem.value[0].sellingbayan
                    this.sellingblFees = elem.value[0].sellingblFees
                    this.sellingoriginCustomClearance = elem.value[0].sellingoriginCustomClearance
                    this.sellingexportServiceFees = elem.value[0].sellingexportServiceFees
                    this.sellingfasahFees = elem.value[0].sellingfasahFees
                    this.sellingfuelSurcharge = elem.value[0].sellingfuelSurcharge
                    this.sellinginspection = elem.value[0].sellinginspection
                    this.sellinginsuranceCharges = elem.value[0].sellinginsuranceCharges
                    this.sellingliftOnLiftOff = elem.value[0].sellingliftOnLiftOff
                    this.sellingOriginDetention = elem.value[0].sellingOriginDetention
                    this.sellingOriginLoadingCharges = elem.value[0].sellingOriginLoadingCharges
                    this.sellingpickUpCharges = elem.value[0].sellingpickUpCharges
                    this.sellingReeferControlPlugInCharge = elem.value[0].sellingReeferControlPlugInCharge
                    this.sellingtabadul = elem.value[0].sellingtabadul
                    this.sellingtrapulinCharges = elem.value[0].sellingtrapulinCharges
                    this.sellingtruckIdlingCharges = elem.value[0].sellingtruckIdlingCharges
                    this.sellingtransportationCharges = elem.value[0].sellingtransportationCharges
                    this.sellingvgm = elem.value[0].sellingvgm
                    this.sellinglashingCharges = elem.value[0].sellinglashingCharges
                    this.sellingxray = elem.value[0].sellingxray
                    this.sellingTotalOrigincharges = elem.value[0].sellingTotalOrigincharges
            
                    this.sellingdestinBayanCharges = elem.value[0].sellingdestinBayanCharges
                    this.sellingdestinCustomClearanceCharges = elem.value[0].sellingdestinCustomClearanceCharges
                    this.sellingdestinDOCharges = elem.value[0].sellingdestinDOCharges
                    this.sellingdestinFasahCharges = elem.value[0].sellingdestinFasahCharges
                    this.sellingdestinGatePassCharges = elem.value[0].sellingdestinGatePassCharges
                    this.sellingdestinLOLOCharges = elem.value[0].sellingdestinLOLOCharges
                    this.sellingdestinTransPortationCharges = elem.value[0].sellingdestinTransPortationCharges
                    this.sellingdestinTotalCharges = elem.value[0].sellingdestinTotalCharges
                    let allData = this.serviceChargeList;
                    if(allData.currencyCode != undefined) this.currencyCode = allData.currencyCode;
                }
            }
        });
        this.assignServiceChargesData();
        this.checkSaveQuoteClicked();
    }
    assignServiceChargesData(){
        if(Object.keys(this.serviceChargeList).length > 0){
            let allData = this.serviceChargeList;
            if(allData.currencyCode != undefined) this.currencyCode = allData.currencyCode;
            if(allData.offset != undefined) this.offSet = allData.offset;           
            if(allData.servichargesObj != undefined){
                let serviceChargeObj = allData.servichargesObj;
                if(serviceChargeObj.BAF != undefined && serviceChargeObj.BAF > 0 ) this.BAF = serviceChargeObj.BAF
                if(serviceChargeObj.bunkerCharges!= undefined && serviceChargeObj.bunkerCharges > 0 ) this.bunkerCharges = serviceChargeObj.bunkerCharges
                if(serviceChargeObj.cleaningCharges!= undefined && serviceChargeObj.cleaningCharges > 0 ) this.cleaningCharges = serviceChargeObj.cleaningCharges
                if(serviceChargeObj.CMC!= undefined && serviceChargeObj.CMC > 0 ) this.CMC = serviceChargeObj.CMC
                if(serviceChargeObj.carriageCongestionSurcharge!= undefined && serviceChargeObj.carriageCongestionSurcharge > 0 ) this.carriageCongestionSurcharge = serviceChargeObj.carriageCongestionSurcharge
                if(serviceChargeObj.carrierSecurityFees!= undefined && serviceChargeObj.carrierSecurityFees > 0 ) this.carrierSecurityFees = serviceChargeObj.carrierSecurityFees
                if(serviceChargeObj.dgSurcharge!= undefined && serviceChargeObj.dgSurcharge > 0 ) this.dgSurcharge = serviceChargeObj.dgSurcharge
                if(serviceChargeObj.DTHC!= undefined && serviceChargeObj.DTHC > 0 ) this.DTHC = serviceChargeObj.DTHC
                if(serviceChargeObj.equipmentImbalance!= undefined && serviceChargeObj.equipmentImbalance > 0 ) this.equipmentImbalance = serviceChargeObj.equipmentImbalance
                if(serviceChargeObj.inlandFuelCharges!= undefined && serviceChargeObj.inlandFuelCharges > 0 ) this.inlandFuelCharges = serviceChargeObj.inlandFuelCharges
                if(serviceChargeObj.inlandHandlingfees!= undefined && serviceChargeObj.inlandHandlingfees > 0 ) this.inlandHandlingfees = serviceChargeObj.inlandHandlingfees
                if(serviceChargeObj.inlandHaulage!= undefined && serviceChargeObj.inlandHaulage > 0 ) this.inlandHaulage = serviceChargeObj.inlandHaulage
                if(serviceChargeObj.ISPS!= undefined && serviceChargeObj.ISPS > 0 ) this.ISPS = serviceChargeObj.ISPS
                if(serviceChargeObj.lowerSulphurSurcharge!= undefined && serviceChargeObj.lowerSulphurSurcharge > 0 ) this.lowerSulphurSurcharge = serviceChargeObj.lowerSulphurSurcharge
                if(serviceChargeObj.operationalRecovery!= undefined && serviceChargeObj.operationalRecovery > 0 ) this.operationalRecovery = serviceChargeObj.operationalRecovery
                if(serviceChargeObj.OTHC!= undefined && serviceChargeObj.OTHC > 0 ) this.OTHC = serviceChargeObj.OTHC
                if(serviceChargeObj.overWeightCharge!= undefined && serviceChargeObj.overWeightCharge > 0 ) this.overWeightCharge = serviceChargeObj.overWeightCharge
                if(serviceChargeObj.sealCharges!= undefined && serviceChargeObj.sealCharges > 0 ) this.sealCharges = serviceChargeObj.sealCharges
                if(serviceChargeObj.warRiskSurcharges!= undefined && serviceChargeObj.warRiskSurcharges > 0 ) this.warRiskSurcharges = serviceChargeObj.warRiskSurcharges
                if(serviceChargeObj.totalSl!= undefined && serviceChargeObj.totalSl > 0 ) this.totalSl = serviceChargeObj.totalSl
                if(serviceChargeObj.shippTotalChanged!= undefined) this.shippTotalChanged = serviceChargeObj.shippTotalChanged
            }
            if(allData.originChargesObj != undefined){
                let originChargesObj = allData.originChargesObj;
                if(originChargesObj.bayan != undefined && originChargesObj.bayan > 0 ) this.bayan = originChargesObj.bayan;
                if(originChargesObj.blFees != undefined && originChargesObj.blFees > 0 ) this.blFees = originChargesObj.blFees;
                if(originChargesObj.originCustomClearance != undefined && originChargesObj.originCustomClearance > 0 ) this.originCustomClearance = originChargesObj.originCustomClearance;
                if(originChargesObj.exportServiceFees != undefined && originChargesObj.exportServiceFees > 0 ) this.exportServiceFees = originChargesObj.exportServiceFees;
                if(originChargesObj.fasahFees != undefined && originChargesObj.fasahFees > 0 ) this.fasahFees = originChargesObj.fasahFees;
                if(originChargesObj.fuelSurcharge != undefined && originChargesObj.fuelSurcharge > 0 ) this.fuelSurcharge = originChargesObj.fuelSurcharge;
                if(originChargesObj.inspection != undefined && originChargesObj.inspection > 0 ) this.inspection = originChargesObj.inspection;
                if(originChargesObj.insuranceCharges != undefined && originChargesObj.insuranceCharges > 0 ) this.insuranceCharges = originChargesObj.insuranceCharges;
                if(originChargesObj.liftOnLiftOff != undefined && originChargesObj.liftOnLiftOff > 0 ) this.liftOnLiftOff = originChargesObj.liftOnLiftOff;
                if(originChargesObj.OriginDetention != undefined && originChargesObj.OriginDetention > 0 ) this.OriginDetention = originChargesObj.OriginDetention;
                if(originChargesObj.OriginLoadingCharges != undefined && originChargesObj.OriginLoadingCharges > 0 ) this.OriginLoadingCharges = originChargesObj.OriginLoadingCharges;
                if(originChargesObj.pickUpCharges != undefined && originChargesObj.pickUpCharges > 0 ) this.pickUpCharges = originChargesObj.pickUpCharges;
                if(originChargesObj.ReeferControlPlugInCharge != undefined && originChargesObj.ReeferControlPlugInCharge > 0 ) this.ReeferControlPlugInCharge = originChargesObj.ReeferControlPlugInCharge;
                if(originChargesObj.tabadul != undefined && originChargesObj.tabadul > 0 ) this.tabadul = originChargesObj.tabadul;
                if(originChargesObj.trapulinCharges != undefined && originChargesObj.trapulinCharges > 0 ) this.trapulinCharges = originChargesObj.trapulinCharges;
                if(originChargesObj.truckIdlingCharges != undefined && originChargesObj.truckIdlingCharges > 0 ) this.truckIdlingCharges = originChargesObj.truckIdlingCharges;
                if(originChargesObj.transportationCharges != undefined && originChargesObj.transportationCharges > 0 ) this.transportationCharges = originChargesObj.transportationCharges;
                if(originChargesObj.vgm != undefined && originChargesObj.vgm > 0 ) this.vgm = originChargesObj.vgm;
                if(originChargesObj.lashingCharges != undefined && originChargesObj.lashingCharges > 0 ) this.lashingCharges = originChargesObj.lashingCharges;
                if(originChargesObj.xray != undefined && originChargesObj.xray > 0 ) this.xray = originChargesObj.xray;
                if(originChargesObj.TotalOrigincharges != undefined && originChargesObj.TotalOrigincharges > 0 ) this.TotalOrigincharges = originChargesObj.TotalOrigincharges;
                if(originChargesObj.directionValue != undefined) this.directionValue = originChargesObj.directionValue;
                if(originChargesObj.loadingChargeId != undefined && originChargesObj.loadingChargeId !='' ){
                    this.loadingChargeId = originChargesObj.loadingChargeId;
                    if(originChargesObj.loadingChargeName != '') this.loadingChargeName = originChargesObj.loadingChargeName;                    
                } 
                if(originChargesObj.originTotalChanged != undefined ) this.originTotalChanged = originChargesObj.originTotalChanged;
                
            }
            if(allData.destinChargeObj != undefined){
                let destinChargeObj = allData.destinChargeObj;
                if(destinChargeObj.destinBayanCharges != undefined && destinChargeObj.destinBayanCharges > 0) this.destinBayanCharges = destinChargeObj.destinBayanCharges; 
                if(destinChargeObj.destinCustomClearanceCharges != undefined && destinChargeObj.destinCustomClearanceCharges > 0) this.destinCustomClearanceCharges = destinChargeObj.destinCustomClearanceCharges; 
                if(destinChargeObj.destinDOCharges != undefined && destinChargeObj.destinDOCharges > 0) this.destinDOCharges = destinChargeObj.destinDOCharges; 
                if(destinChargeObj.destinFasahCharges != undefined && destinChargeObj.destinFasahCharges > 0) this.destinFasahCharges = destinChargeObj.destinFasahCharges; 
                if(destinChargeObj.destinGatePassCharges != undefined && destinChargeObj.destinGatePassCharges > 0) this.destinGatePassCharges = destinChargeObj.destinGatePassCharges; 
                if(destinChargeObj.destinLOLOCharges != undefined && destinChargeObj.destinLOLOCharges > 0) this.destinLOLOCharges = destinChargeObj.destinLOLOCharges; 
                if(destinChargeObj.destinTransPortationCharges != undefined && destinChargeObj.destinTransPortationCharges > 0) this.destinTransPortationCharges = destinChargeObj.destinTransPortationCharges; 
                if(destinChargeObj.destinTotalCharges != undefined && destinChargeObj.destinTotalCharges > 0) this.destinTotalCharges = destinChargeObj.destinTotalCharges; 
                if(destinChargeObj.DestinTotalChanged != undefined) this.DestinTotalChanged = destinChargeObj.DestinTotalChanged; 
                if(this.DestinTotalChanged == true) this.displayDestinCharges = true
            }
        }    
    }
    @api handleUpdateCalculation(){
        
        let dtoTotal = 0;  
        let additonalChargeTotal = 0; 
        let sellingAdditionalCharge = 0;     
        let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected;
        this.toHoldData.forEach(elem => {
                if(elem.key == keyName){
                    if(elem.value.length > 0){
                        let dto = elem.value[0];
                        dtoTotal = dtoTotal + dto.seaFreightSellRate;
                        dto.incoChargList.total = dtoTotal - dto.seaFreightSellRate;
                         //adding totala of AdditionalCharge 
                        if(dto.additionalChargeList.length > 0){
                            dto.additionalChargeList.forEach(addCha => {
                                if(addCha.value > 0){
                                    additonalChargeTotal = additonalChargeTotal + addCha.value;
                                    //dtoTotal = dtoTotal + addCha.value;
                                }
                                if(addCha.sellingCharge >0) sellingAdditionalCharge += addCha.sellingCharge
                            });
                        }
                        if(dto.addServiceCharge == false && this.totalSl > 0) dtoTotal = dtoTotal + this.totalSl       
                        
                        if(dto.addOriginCharge == false && this.TotalOrigincharges > 0) dtoTotal = dtoTotal + this.TotalOrigincharges   
                        if(dto.addDestinCharge == false && this.destinTotalCharges > 0) dtoTotal = dtoTotal + this.destinTotalCharges
                        if(additonalChargeTotal > 0 ) {
                            if(dto.addAdditionalCharge == false) dtoTotal = dtoTotal + additonalChargeTotal;
                            this.additionalChargeTotal = additonalChargeTotal;
                        }
                        if(dto.addExWorksCharge == false && this.exWorksTotal > 0) dtoTotal = dtoTotal + this.exWorksTotal;
                        if(this.sellingtotalSl > 0 ) dtoTotal = dtoTotal + this.sellingtotalSl;
                        if(this.sellingexWorksTotal > 0 ) dtoTotal = dtoTotal + this.sellingexWorksTotal;
                        if(this.sellingTotalOrigincharges > 0) dtoTotal = dtoTotal + this.sellingTotalOrigincharges;
                        if(this.sellingdestinTotalCharges > 0) dtoTotal = dtoTotal + this.sellingdestinTotalCharges;
                        if(sellingAdditionalCharge > 0) {
                            dtoTotal = dtoTotal + sellingAdditionalCharge;
                            this.sellingadditionalChargeTotal = sellingAdditionalCharge;
                        }
                        dto.total= dtoTotal;
                        
                    }
                }
            });
            if(sellingAdditionalCharge > 0 || additonalChargeTotal > 0 ) this.displayAdditionalTotal = true;
            else this.displayAdditionalTotal = false
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
                let margin  = profit/this.sellingRate;
                this.margin = isNaN(margin) ? 0 : margin * 100;
                this.margin = this.margin.toFixed(2);
                profit = isNaN(profit) ? 0 : profit;
                }
                else if(this.sellingRate <= 0){
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
            let seletedEquipName = '';
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
            data.forEach(elem =>{
                if(elem.uniqueEquip == this.shippingEquipTabSelected)
                seletedEquipName = elem.equipmentName;
             })
            /*tempMap.forEach(elem=>{
                if(elem.key == this.agentTabSelected+'-'+this.shippingTabSelected+'-'+seletedEquipName+'-'+this.routeName){
                    elem.value.forEach(el =>{
                        if(el.equipment == seletedEquipName){
                            el.sellingRate = parseInt(this.sellingRate) 
                            el.profit = parseInt(profit)
                            el.margin =  parseInt(this.margin)
                            el.validity = this.validity
                            el.quantity = this.quantity
                            el.currencyCode = this.currencyCode
                            if(el.savedClicked == true) el.cssClass = 'class2'
                            else el.cssClass = ''
                        }
                    })
                }
            })

           this.quotationMap = JSON.parse(JSON.stringify(tempMap));
           let toBeSend = {
            'routeName':this.routeName,
            'quotationMap':this.quotationMap
        }
        this.dispatchEvent(new CustomEvent('updatecalculation', { detail: toBeSend }));*/
        if(this.quotationMap.length == 0 ){
            let tempList = [];
            let value = [];
            value.push({
                key: this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected+'-'+this.routeName,
                sellingRate : parseInt(this.sellingRate) ,
                equipmentName: this.agentTabSelected+'-'+this.shippingTabSelected+'-'+seletedEquipName,
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
                let equipIndex = value.findIndex(x=>x.key == this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected+'-'+this.routeName);
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
                        key: this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected+'-'+this.routeName,
                        sellingRate : parseInt(this.sellingRate) ,
                        equipmentName: this.agentTabSelected+'-'+this.shippingTabSelected+'-'+seletedEquipName,
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
                    key: this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected+'-'+this.routeName,
                    sellingRate : parseInt(this.sellingRate) ,
                    equipmentName: this.agentTabSelected+'-'+this.shippingTabSelected+'-'+seletedEquipName,
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
    getServiceCharges(){        
        getClassification({rmsRecordId : this.rmsId})
            .then((result) => {
                this.serviceChargeObj = result;
                this.getIncoCharges();

            })
            .catch((error) => {
                console.error('getServiceCharges error', JSON.stringify(error));
            });
    }
    getIncoCharges(){
        let dedicatedRoutingObj = this.routingListMap[this.agentTabSelected];
        let templist =[];
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
            if(elem.uniqueEquip == this.shippingEquipTabSelected){
                this.rmsId = elem.rmsID;
            }
        })
        getIncoCharges({
            rmsId : this.rmsId,
            incoTerm : this.incoTerm
        }).then(result =>{
            this.incoChargList = result;
            this.getDestinationCharge();
            //console.log(' incoChargList charge: ', JSON.stringify(this.incoChargList));
            //this.handleBuyingRate();
        }).catch(error=>{
            console.log('error incoChargList charge: ', JSON.stringify(error));
        });
    }
    getDestinationCharge(){
        getDestintionCharges({rmsRecordId : this.rmsId})
        .then(result=>{
           // console.log('*** destinationCharges'+JSON.stringify(result,null,2))
            this.destinationChargeList = result;
            this.handleBuyingRate();
        })
        .catch(error=>{
            console.log('error ',error);
        })
    }
    handleBuyingRate(){
        this.buyingRate = 0 ;
        this.buyingRate = this.buyingRate + (this.incoChargList.total > 0 ? this.incoChargList.total:0) ;
        this.buyingRate = this.buyingRate + (this.serviceChargeObj.Total > 0 ? this.serviceChargeObj.Total:0);
        this.buyingRate = this.buyingRate + (this.destinationChargeList.total > 0 ? this.destinationChargeList.total:0);
        if(this.seaFreight != undefined && this.seaFreight > 0){
            this.buyingRate = this.buyingRate + this.seaFreight;
        }
        if(this.addServiceCharge == true && this.totalSl > 0 ) this.buyingRate = this.buyingRate + this.totalSl;
        if(this.addOriginCharge == true && this.TotalOrigincharges > 0 ) this.buyingRate = this.buyingRate + this.TotalOrigincharges;
        if(this.addDestinCharge == true && this.destinTotalCharges > 0 ) this.buyingRate = this.buyingRate + this.destinTotalCharges;
        if(this.addExWorksCharge == true && this.exWorksTotal > 0) this.buyingRate = this.buyingRate + this.exWorksTotal

        let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected;  
        let additionalChargeTotal = 0;   
        this.toHoldData.forEach(elem => {
            if(elem.key == keyName){
                if(elem.value.length > 0){
                    let dto = elem.value[0];
                    if(dto.additionalChargeList.length > 0){
                        dto.additionalChargeList.forEach(addCha => {
                            if(addCha.value > 0){
                                additionalChargeTotal = additionalChargeTotal + addCha.value;
                            }
                        });
                    }
                }
            }
        })
        this.additionalChargeTotal = additionalChargeTotal

        if(this.addAdditionalCharge == true && this.additionalChargeTotal > 0 ) this.buyingRate = this.buyingRate + this.additionalChargeTotal;
        this.handleUpdateCalculation();
        this.isLoading = false
    }
    handleSellRateChange(e){
        this.seaFreightSellRate = parseInt(e.target.value);  
        let sellingRateField = this.template.querySelector("[data-field='sellingRateField']");
            sellingRateField.setCustomValidity("");
            sellingRateField.reportValidity();    
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    updateTabsData(){
        this.handleBuyingRate();
        let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected;  
        this.toHoldData.forEach(elem => {
            if(elem.key == keyName){
                if(elem.value.length == 1){
                    elem.value[0].seaFreightSellRate = this.seaFreightSellRate;
                    elem.value[0].quotationItemId = this.quotationItemId;
                    elem.value[0].additionalChargeList = this.additionalChargeList;
                    elem.value[0].serviceChargeList = this.serviceChargeList;
                    elem.value[0].quantity = this.equipQuantity;
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

                    elem.value[0].sellingBAF = this.sellingBAF ;
                    elem.value[0].sellingbunkerCharges = this.sellingbunkerCharges;
                    elem.value[0].sellingcleaningCharges = this.sellingcleaningCharges;
                    elem.value[0].sellingCMC = this.sellingCMC;
                    elem.value[0].sellingcarriageCongestionSurcharge = this.sellingcarriageCongestionSurcharge;
                    elem.value[0].sellingcarrierSecurityFees = this.sellingcarrierSecurityFees;
                    elem.value[0].sellingdgSurcharge = this.sellingdgSurcharge;
                    elem.value[0].sellingDTHC = this.sellingDTHC;
                    elem.value[0].sellingequipmentImbalance = this.sellingequipmentImbalance;
                    elem.value[0].sellinginlandFuelCharges = this.sellinginlandFuelCharges;
                    elem.value[0].sellinginlandHandlingfees = this.sellinginlandHandlingfees;
                    elem.value[0].sellinginlandHaulage = this.sellinginlandHaulage;
                    elem.value[0].sellingISPS = this.sellingISPS;
                    elem.value[0].sellinglowerSulphurSurcharge = this.sellinglowerSulphurSurcharge;
                    elem.value[0].sellingoperationalRecovery = this.sellingoperationalRecovery;
                    elem.value[0].sellingOTHC = this.sellingOTHC;
                    elem.value[0].sellingoverWeightCharge = this.sellingoverWeightCharge;
                    elem.value[0].sellingsealCharges = this.sellingsealCharges;
                    elem.value[0].sellingwarRiskSurcharges = this.sellingwarRiskSurcharges;
                    elem.value[0].sellingtotalSl = this.sellingtotalSl;
                    elem.value[0].sellingexWorksTotal = this.sellingexWorksTotal;
                
                
                    
                    elem.value[0].sellingbayan = this.sellingbayan;
                    elem.value[0].sellingblFees = this.sellingblFees;
                    elem.value[0].sellingoriginCustomClearance = this.sellingoriginCustomClearance;
                    elem.value[0].sellingexportServiceFees = this.sellingexportServiceFees;
                    elem.value[0].sellingfasahFees = this.sellingfasahFees;
                    elem.value[0].sellingfuelSurcharge = this.sellingfuelSurcharge;
                    elem.value[0].sellinginspection = this.sellinginspection;
                    elem.value[0].sellinginsuranceCharges = this.sellinginsuranceCharges;
                    elem.value[0].sellingliftOnLiftOff = this.sellingliftOnLiftOff;
                    elem.value[0].sellingOriginDetention = this.sellingOriginDetention;
                    elem.value[0].sellingOriginLoadingCharges = this.sellingOriginLoadingCharges;
                    elem.value[0].sellingpickUpCharges = this.sellingpickUpCharges;
                    elem.value[0].sellingReeferControlPlugInCharge = this.sellingReeferControlPlugInCharge;
                    elem.value[0].sellingtabadul = this.sellingtabadul;
                    elem.value[0].sellingtrapulinCharges = this.sellingtrapulinCharges;
                    elem.value[0].sellingtruckIdlingCharges = this.sellingtruckIdlingCharges;
                    elem.value[0].sellingtransportationCharges = this.sellingtransportationCharges;
                    elem.value[0].sellingvgm = this.sellingvgm;
                    elem.value[0].sellinglashingCharges = this.sellinglashingCharges;
                    elem.value[0].sellingxray = this.sellingxray;
                    elem.value[0].sellingTotalOrigincharges = this.sellingTotalOrigincharges;

                    elem.value[0].sellingdestinBayanCharges = this.sellingdestinBayanCharges;
                    elem.value[0].sellingdestinCustomClearanceCharges = this.sellingdestinCustomClearanceCharges;
                    elem.value[0].sellingdestinDOCharges = this.sellingdestinDOCharges;
                    elem.value[0].sellingdestinFasahCharges = this.sellingdestinFasahCharges;
                    elem.value[0].sellingdestinGatePassCharges = this.sellingdestinGatePassCharges;
                    elem.value[0].sellingdestinLOLOCharges = this.sellingdestinLOLOCharges;
                    elem.value[0].sellingdestinTransPortationCharges = this.sellingdestinTransPortationCharges;
                    elem.value[0].sellingdestinTotalCharges = this.sellingdestinTotalCharges;
                }
            }
        });        
    }
    handleAddAdditionalCharge(e){
        this.showAdditionalChargeModal = true;
    }
    handleCloseAdditionalModal(){
        this.showAdditionalChargeModal = false;
    }
    showErrorToast() {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: 'Similar equipment already submitted.',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
    handleGenerateQuotaion(e){
        let allValid = true;
        let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected;
        let dto = {}; 
        console.log('data '+ JSON.stringify(this.toHoldData,null,2))
        this.toHoldData.forEach(elem => {
            if(elem.key == keyName){
                dto = elem.value[0]
            }
        });
         if(dto.seaFreightSellRate == 0) {
            //this.showErrorPopup = true;
            let sellingRateField = this.template.querySelector("[data-field='sellingRateField']");
            sellingRateField.setCustomValidity("Selling rate should be greater then 0");
            sellingRateField.reportValidity();
            allValid = false;
        }
        if(dto.similarEquipSubmitted == true){
            allValid = false;
            this.showErrorToast();
            console.log('@@@@ came here')
        }
        console.log('came here 1' );
        if(allValid){
            console.log('came here 2' );
        let sellingInputField = '';
        let InputField = '';
        if(this.sellingBAF > 0) sellingInputField += '\nBAF : '+this.sellingBAF;
        if(this.sellingbunkerCharges> 0) sellingInputField += '\nBunker Charges : '+this.sellingbunkerCharges
        if(this.sellingcleaningCharges> 0) sellingInputField += '\nCleaning Charges : '+this.sellingcleaningCharges
        if(this.sellingCMC> 0) sellingInputField += '\nContainer Maintenance Charges : '+this.sellingCMC
        if(this.sellingcarriageCongestionSurcharge> 0) sellingInputField += '\nCongestion Surcharge : '+this.sellingcarriageCongestionSurcharge
        if(this.sellingcarrierSecurityFees> 0) sellingInputField += '\ncarrier Security Fees : '+this.sellingcarrierSecurityFees
        if(this.sellingdgSurcharge> 0) sellingInputField += '\nDG Surcharge : '+this.sellingdgSurcharge
        if(this.sellingDTHC> 0) sellingInputField += '\nDTHC : '+this.sellingDTHC
        if(this.sellingequipmentImbalance> 0) sellingInputField += '\nEquipment Imbalance : '+this.sellingequipmentImbalance
        if(this.sellinginlandFuelCharges> 0) sellingInputField += '\nInLand FuelCharges : '+this.sellinginlandFuelCharges
        if(this.sellinginlandHandlingfees> 0) sellingInputField += '\nInLand Handling Fees : '+this.sellinginlandHandlingfees
        if(this.sellinginlandHaulage> 0) sellingInputField += '\nInLand Haulage : '+this.sellinginlandHaulage
        if(this.sellingISPS> 0) sellingInputField += '\nISPS : '+this.sellingISPS
        if(this.sellinglowerSulphurSurcharge> 0) sellingInputField += '\nLower Sulphur Surcharge : '+this.sellinglowerSulphurSurcharge
        if(this.sellingoperationalRecovery> 0) sellingInputField += '\nOperational Recovery : '+this.sellingoperationalRecovery
        if(this.sellingOTHC> 0) sellingInputField += '\nOTHC : '+this.sellingOTHC
        if(this.sellingoverWeightCharge> 0) sellingInputField += '\nOver Weight Charge : '+this.sellingoverWeightCharge
        if(this.sellingsealCharges> 0) sellingInputField += '\nSeal Charges : '+this.sellingsealCharges
        if(this.sellingwarRiskSurcharges> 0) sellingInputField += '\nWar Risk Charges : '+this.sellingwarRiskSurcharges
        if(this.sellingtotalSl> 0 && this.displayAllServiceChargeField == false) sellingInputField += '\nTotal Shipping Line Charge : '+this.sellingtotalSl
         //@
         console.log('came here 3' );
        if(this.sellingbayan> 0) sellingInputField += '\nBayan : '+this.sellingbayan
        if(this.sellingblFees> 0) sellingInputField += '\nBL Fees : '+this.sellingblFees
        if(this.sellingoriginCustomClearance> 0) sellingInputField += '\norigin Custom Clearance : '+this.sellingoriginCustomClearance
        if(this.sellingexportServiceFees> 0) sellingInputField += '\nExport Service Fees : '+this.sellingexportServiceFees
        if(this.sellingfasahFees> 0) sellingInputField += '\nFasah Fees : '+this.sellingfasahFees
        if(this.sellingfuelSurcharge> 0) sellingInputField += '\nFuel Surcharges : '+this.sellingfuelSurcharge
        if(this.sellinginspection> 0) sellingInputField += '\nInspection : '+this.sellinginspection
        if(this.sellinginsuranceCharges> 0) sellingInputField += '\nInsurance Charges : '+this.sellinginsuranceCharges
        if(this.sellingliftOnLiftOff> 0) sellingInputField += '\nLift On Lift Off : '+this.sellingliftOnLiftOff
        if(this.sellingOriginDetention> 0) sellingInputField += '\nOrigin Detention : '+this.sellingOriginDetention
        if(this.sellingOriginLoadingCharges> 0) sellingInputField += '\nOrigin Loading Charges : '+this.sellingOriginLoadingCharges
        if(this.sellingpickUpCharges> 0) sellingInputField += '\nPickUp Charges : '+this.sellingpickUpCharges
        if(this.sellingReeferControlPlugInCharge> 0) sellingInputField += '\nReefer Control Plug In Charge : '+this.sellingReeferControlPlugInCharge
        if(this.sellingtabadul> 0) sellingInputField += '\nTabadul : '+this.sellingtabadul
        if(this.sellingtrapulinCharges> 0) sellingInputField += '\nTarpulin Charges : '+this.sellingtrapulinCharges
        if(this.sellingtruckIdlingCharges> 0) sellingInputField += '\nTruck Idling Charges : '+this.sellingtruckIdlingCharges
        if(this.sellingtransportationCharges> 0) sellingInputField += '\nTransportation Charges : '+this.sellingtransportationCharges
        if(this.sellingvgm> 0) sellingInputField += '\nVGM : '+this.sellingvgm
        if(this.sellinglashingCharges> 0) sellingInputField += '\nLashing Charge : '+this.sellinglashingCharges
        if(this.sellingxray> 0) sellingInputField += '\nXray : '+this.sellingxray
        if(this.sellingTotalOrigincharges> 0 && this.displayOriginChargeCharge == false) sellingInputField += '\nTotal Origin Charges : '+this.sellingTotalOrigincharges
        console.log('came here 4' );
        if(this.sellingdestinBayanCharges> 0) sellingInputField += '\nBayan Charges : '+this.sellingdestinBayanCharges
        if(this.sellingdestinCustomClearanceCharges> 0) sellingInputField += '\nCustom Clearance Charges : '+this.sellingdestinCustomClearanceCharges
        if(this.sellingdestinDOCharges> 0) sellingInputField += '\n DO Charges : '+this.sellingdestinDOCharges
        if(this.sellingdestinFasahCharges> 0) sellingInputField += '\n Fasah Charges : '+this.sellingdestinFasahCharges
        if(this.sellingdestinGatePassCharges> 0) sellingInputField += '\n Gate Pass Charges : '+this.sellingdestinGatePassCharges
        if(this.sellingdestinLOLOCharges> 0) sellingInputField += '\n LOLO Charges : '+this.sellingdestinLOLOCharges
        if(this.sellingdestinTransPortationCharges> 0) sellingInputField += '\n Transportation Charges : '+this.sellingdestinTransPortationCharges
        if(this.sellingdestinTotalCharges> 0 && this.displayDestinCharges == false) sellingInputField += '\n Total Destination Charges : '+this.sellingdestinTotalCharges;

        console.log('came here 5' );
        //buuying Input Code 
        if(dto.serviceChargeList != null){
            console.log('came here 51' +JSON.stringify(dto.serviceChargeList.servichargesObj) );
            if(dto.serviceChargeList.servichargesObj != null || dto.serviceChargeList.servichargesObj != undefined){
                console.log('came here 52' );
                if(dto.serviceChargeList.servichargesObj.shippTotalChanged == false){
                    console.log('came here 53' );
                    console.log('came here1  '+InputField);
                    console.log('came here2  '+this.BAF);
                    if(this.BAF > 0) InputField += '\nBAF : '+this.BAF;
                    console.log('came here3  '+InputField);
                    if(this.bunkerCharges> 0) InputField += '\nBunker Charges : '+this.bunkerCharges
                    if(this.cleaningCharges> 0) InputField += '\nCleaning Charges : '+this.cleaningCharges
                    if(this.CMC> 0) InputField += '\nContainer Maintenance Charges : '+this.CMC
                    if(this.carriageCongestionSurcharge> 0) InputField += '\nCongestion Surcharge : '+this.carriageCongestionSurcharge
                    if(this.carrierSecurityFees> 0) InputField += '\ncarrier Security Fees : '+this.carrierSecurityFees
                    if(this.dgSurcharge> 0) InputField += '\nDG Surcharge : '+this.dgSurcharge
                    if(this.DTHC> 0) InputField += '\nDTHC : '+this.DTHC
                    if(this.equipmentImbalance> 0) InputField += '\nEquipment Imbalance : '+this.equipmentImbalance
                    if(this.inlandFuelCharges> 0) InputField += '\nInLand FuelCharges : '+this.inlandFuelCharges
                    if(this.inlandHandlingfees> 0) InputField += '\nInLand Handling Fees : '+this.inlandHandlingfees
                    if(this.inlandHaulage> 0) InputField += '\nInLand Haulage : '+this.inlandHaulage
                    if(this.ISPS> 0) InputField += '\nISPS : '+this.ISPS
                    if(this.lowerSulphurSurcharge> 0) InputField += '\nLower Sulphur Surcharge : '+this.lowerSulphurSurcharge
                    if(this.operationalRecovery> 0) InputField += '\nOperational Recovery : '+this.operationalRecovery
                    if(this.OTHC> 0) InputField += '\nOTHC : '+this.OTHC
                    if(this.overWeightCharge> 0) InputField += '\nOver Weight Charge : '+this.overWeightCharge
                    if(this.sealCharges> 0) InputField += '\nSeal Charges : '+this.sealCharges
                    if(this.warRiskSurcharges> 0) InputField += '\nWar Risk Charges : '+this.warRiskSurcharges
                }
                else if(this.totalSl > 0) InputField += '\nTotal ServiceCharge : '+this.totalSl
            }
            if(dto.serviceChargeList.originChargesObj != null || dto.serviceChargeList.originChargesObj != undefined){
                console.log('came here 55' );
                if(dto.serviceChargeList.originChargesObj.originTotalChanged == false){
                    if(this.bayan> 0) InputField += '\nBayan : '+this.bayan
                    if(this.blFees> 0) InputField += '\nBL Fees : '+this.blFees
                    if(this.originCustomClearance> 0) InputField += '\norigin Custom Clearance : '+this.originCustomClearance
                    if(this.exportServiceFees> 0) InputField += '\nExport Service Fees : '+this.exportServiceFees
                    if(this.fasahFees> 0) InputField += '\nFasah Fees : '+this.fasahFees
                    if(this.fuelSurcharge> 0) InputField += '\nFuel Surcharges : '+this.fuelSurcharge
                    if(this.inspection> 0) InputField += '\nInspection : '+this.inspection
                    if(this.insuranceCharges> 0) InputField += '\nInsurance Charges : '+this.insuranceCharges
                    if(this.liftOnLiftOff> 0) InputField += '\nLift On Lift Off : '+this.liftOnLiftOff
                    if(this.OriginDetention> 0) InputField += '\nOrigin Detention : '+this.OriginDetention
                    if(this.OriginLoadingCharges> 0) InputField += '\nOrigin Loading Charges : '+this.OriginLoadingCharges
                    if(this.pickUpCharges> 0) InputField += '\nPickUp Charges : '+this.pickUpCharges
                    if(this.ReeferControlPlugInCharge> 0) InputField += '\nReefer Control Plug In Charge : '+this.ReeferControlPlugInCharge
                    if(this.tabadul> 0) InputField += '\nTabadul : '+this.tabadul
                    if(this.trapulinCharges> 0) InputField += '\nTarpulin Charges : '+this.trapulinCharges
                    if(this.truckIdlingCharges> 0) InputField += '\nTruck Idling Charges : '+this.truckIdlingCharges
                    if(this.transportationCharges> 0) InputField += '\nTransportation Charges : '+this.transportationCharges
                    if(this.vgm> 0) InputField += '\nVGM : '+this.vgm
                    if(this.lashingCharges> 0) InputField += '\nLashing Charge : '+this.lashingCharges
                    if(this.xray> 0) InputField += '\nXray : '+this.xray
                     
                }
                else if(this.TotalOrigincharges > 0 ) InputField += '\nTotal Origin Charges : '+this.TotalOrigincharges
            }
            if(dto.serviceChargeList.destinChargeObj != null || dto.serviceChargeList.destinChargeObj != undefined){
                if(dto.serviceChargeList.destinChargeObj.DestinTotalChanged == false){
                    console.log('came here 56' );
                    if(this.destinBayanCharges> 0) InputField += '\nBayan Charges : '+this.destinBayanCharges
                    if(this.destinCustomClearanceCharges> 0) InputField += '\nCustom Clearance Charges : '+this.destinCustomClearanceCharges
                    if(this.destinDOCharges> 0) InputField += '\n DO Charges : '+this.destinDOCharges
                    if(this.destinFasahCharges> 0) InputField += '\n Fasah Charges : '+this.destinFasahCharges
                    if(this.destinGatePassCharges> 0) InputField += '\n Gate Pass Charges : '+this.destinGatePassCharges
                    if(this.destinLOLOCharges> 0) InputField += '\n LOLO Charges : '+this.destinLOLOCharges
                    if(this.destinTransPortationCharges> 0) InputField += '\n Transportation Charges : '+this.destinTransPortationCharges                
                }
                else if(this.destinTotalCharges> 0) InputField += '\n Total Destination Charges : '+this.destinTotalCharges;
            }
            
        }
        console.log('came here 6' );
        dto.additionalChargeList.forEach(elem=>{
            if(elem.sellingCharge > 0) sellingInputField += '\n '+elem.name+' : '+elem.sellingCharge
            if(elem.value > 0) InputField += '\n '+elem.name+' : '+elem.value
        })
        if(this.sellingexWorksTotal > 0)  sellingInputField += '\n'+dto.exWorksObj.Name+' : '+this.sellingexWorksTotal 
        if(this.exWorksTotal > 0)  InputField += '\n'+dto.exWorksObj.Name+' : '+this.exWorksTotal ;
        console.log('InputField '+InputField);
        let sellingFieldObj = {
            'sellingInputField' : sellingInputField,
            'InputField':InputField,
            'sellingdestinTotalCharges':this.sellingdestinTotalCharges > 0 ? this.sellingdestinTotalCharges : 0,
            'sellingTotalOrigincharges':this.sellingTotalOrigincharges > 0 ? this.sellingTotalOrigincharges :0,
            'sellingtotalSl': this.sellingtotalSl > 0? this.sellingtotalSl :0,
            'sellingexWorksTotal':this.sellingexWorksTotal > 0 ? this.sellingexWorksTotal : 0, 
            'sellingadditionalChargeTotal':this.sellingadditionalChargeTotal > 0 ? this.sellingadditionalChargeTotal :0
        }
        console.log('InputField '+JSON.stringify(sellingFieldObj,null,2))
        genrateQuotation({
                routeId: this.routeId,
                rmsId: this.rmsId,
                enquiryId : this.enquiryId,
                quotationId : this.quotationId,
                dto : dto,
                incoTerm : this.incoTerm,
                remarks : this.quoteRemarks,
                additionalChargeTotal : this.additionalChargeTotal,
                cameReviseCompt : this.cameReviseCompt,
                sameRoute:this.sameRoute,
                agentName:this.agentTabSelected,
                sellingFieldObj : sellingFieldObj
            }).then(result =>{
                console.log('generate quote result : ', JSON.stringify(result,null,2));
                let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected;

                this.toHoldData.forEach(elem => {
                    if(elem.key == keyName){
                        elem.value[0].savedClicked = true;
                    }
                });
                this.quotationSaved = true;
                // disabling remaining similar equip
                let seletedEquipName = '';
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
                data.forEach(elem =>{
                    if(elem.uniqueEquip == this.shippingEquipTabSelected)
                    seletedEquipName = elem.equipmentName;
                })
                let equipNameList = [];
                data.forEach(elem =>{
                    if(elem.equipmentName == seletedEquipName){
                        equipNameList.push(elem.uniqueEquip)
                    }
                })
                if(equipNameList.length > 0){
                    equipNameList.forEach(elem=>{
                        let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+elem;
                        this.toHoldData.forEach(elem => {
                            if(elem.key == keyName){
                                if(elem.value.length > 0) elem.value[0].similarEquipSubmitted = true;
                            }
                        });
                    })
                }
                this.quotationId = result;
                this.dispatchEvent(new CustomEvent('showquotebtn',{ detail: {quoteId : this.quotationId}}));


                /*let tempMap = this.quotationMap;
                console.log('TempMap '+JSON.stringify(tempMap,null,2))
                
                tempMap.forEach(elem=>{
                    if(elem.key == this.agentTabSelected+'-'+this.shippingTabSelected+'-'+seletedEquipName+'-'+this.routeName){
                        elem.value.forEach(el =>{
                            el.cssClass = 'class2'
                        })
                    }
                })
                this.quotationMap = tempMap;
                let toBeSend = {
                    'routeName':this.routeName,
                    'quotationMap':this.quotationMap
                }
                this.dispatchEvent(new CustomEvent('updatecalculation', { detail: toBeSend }));*/
                let tempMap = JSON.parse(JSON.stringify(this.quotationMap));
                let index = tempMap.findIndex(x=>x.key == this.routeName);
                if(index != -1){
                    let value = tempMap[index].value;
                    let equipIndex = value.findIndex(x=>x.key == this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected+'-'+this.routeName);
                    if(equipIndex != -1){
                        value[equipIndex].cssClass = 'class2'
                    }
                    tempMap[index].value = value;
                    this.quotationMap = JSON.parse(JSON.stringify(tempMap));
                    this.dispatchEvent(new CustomEvent('updatecalculation', { detail: this.quotationMap }));
                }
                
            
            }).catch(error=>{
                console.log('generate quote error', JSON.stringify(error));
            })
        }
    }
    handleTemplateView(e){
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
                'index':this.additionalChargeIndex,
                'sellingCharge':null
            })
            this.additionalChargeIndex++;
        });
        this.additionalChargeList = tempList2;
        if(tempList2.length > 0) this.displayAdditionalCharge = true;
        else this.displayAdditionalCharge = false;
        this.updateTabsData();
        this.handleBuyingRate();
        this.handleUpdateCalculation();
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
                'index':this.additionalChargeIndex,
                'sellingCharge':null
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
    handleSellingAdditionalChange(event){
        let index = event.target.dataset.recordId;
        this.additionalChargeList.forEach(elem=>{
            if(elem.index == index) elem.sellingCharge = parseInt(event.target.value);
        })
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    removeAdditionalCharge(event){
        let index = event.target.dataset.recordId;
        let arrindex = -1;
        for(let i = 0; i < this.additionalChargeList.length ;  i++) {
            if (this.additionalChargeList[i].index == index) {
                arrindex = i;
                break;
            }
        }
        if(arrindex != -1){
            this.additionalChargeList.splice(arrindex, 1);
        }
        if( this.additionalChargeList.length > 0) this.displayAdditionalCharge = true;
        else this.displayAdditionalCharge = false;
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    handleNewServiceCharge(){
        this.showNewServiceCharge = true;
    }
    handleCloseNewServiceCharge(){
        this.showNewServiceCharge = false;
    }    
    updateServiceCharges(e){       
        let dto = e.detail
        console.log('dto* ',JSON.stringify(dto,null,2))
        if(dto.servichargesObj.shippTotalChanged == true) {
            this.displayAllServiceChargeField = false;
            this.totalSl = dto.servichargesObj.totalSl;
        }
        else {
            console.log('came here ' + this.warRiskSurcharges)
            this.displayAllServiceChargeField = true;
            this.BAF = dto.servichargesObj.BAF;
            this.bunkerCharges = dto.servichargesObj.bunkerCharges;
            this.cleaningCharges  = dto.servichargesObj.cleaningCharges;
            this.CMC =  dto.servichargesObj.CMC;
            this.carriageCongestionSurcharge =  dto.servichargesObj.carriageCongestionSurcharge;
            this.carrierSecurityFees =  dto.servichargesObj.carrierSecurityFees;
            this.dgSurcharge =  dto.servichargesObj.dgSurcharge;
            this.equipmentImbalance =  dto.servichargesObj.equipmentImbalance;
            this.inlandFuelCharges =  dto.servichargesObj.inlandFuelCharges;
            this.inlandHandlingfees =  dto.servichargesObj.inlandHandlingfees;
            this.inlandHaulage =  dto.servichargesObj.inlandHaulage;
            this.lowerSulphurSurcharge =  dto.servichargesObj.lowerSulphurSurcharge;
            this.operationalRecovery =  dto.servichargesObj.operationalRecovery;
            this.overWeightCharge =  dto.servichargesObj.overWeightCharge;
            this.sealCharges =  dto.servichargesObj.sealCharges;
            this.OTHC = dto.servichargesObj.OTHC;
            this.DTHC =  dto.servichargesObj.DTHC;
            this.ISPS = dto.servichargesObj.ISPS;
            this.warRiskSurcharges = dto.servichargesObj.warRiskSurcharges;
            console.log('*88 : '+this.warRiskSurcharges)
        }        
        this.totalSl = dto.servichargesObj.totalSl;
        if(dto.originChargesObj.originTotalChanged == true) {
            this.displayOriginChargeCharge = false;
            this.TotalOrigincharges = dto.originChargesObj.TotalOrigincharges;
        }
        else{
            this.displayOriginChargeCharge = true;
            this.bayan =  dto.originChargesObj.bayan; 
            this.blFees = dto.originChargesObj.blFees; 
            this.originCustomClearance = dto.originChargesObj.originCustomClearance; 
            this.exportServiceFees = dto.originChargesObj.exportServiceFees; 
            this.fasahFees = dto.originChargesObj.fasahFees; 
            this.fuelSurcharge = dto.originChargesObj.fuelSurcharge; 
            this.inspection = dto.originChargesObj.inspection; 
            this.insuranceCharges = dto.originChargesObj.insuranceCharges; 
            this.liftOnLiftOff = dto.originChargesObj.liftOnLiftOff; 
            this.OriginDetention = dto.originChargesObj.OriginDetention; 
            this.OriginLoadingCharges = dto.originChargesObj.OriginLoadingCharges; 
            this.pickUpCharges = dto.originChargesObj.pickUpCharges; 
            this.ReeferControlPlugInCharge = dto.originChargesObj.ReeferControlPlugInCharge; 
            this.tabadul = dto.originChargesObj.tabadul; 
            this.trapulinCharges = dto.originChargesObj.trapulinCharges; 
            this.truckIdlingCharges = dto.originChargesObj.truckIdlingCharges; 
            this.transportationCharges = dto.originChargesObj.transportationCharges; 
            this.vgm = dto.originChargesObj.vgm; 
            this.lashingCharges = dto.originChargesObj.lashingCharges; 
            this.xray = dto.originChargesObj.xray; 
        }
        this.TotalOrigincharges = dto.originChargesObj.TotalOrigincharges;

        if(dto.destinChargeObj.DestinTotalChanged == true) {
            this.displayDestinCharges = false
            this.destinTotalCharges = dto.destinChargeObj.destinTotalCharges;
        }
        else{
            this.displayDestinCharges = true;
            this.destinBayanCharges = dto.destinChargeObj.destinBayanCharges;
            this.destinCustomClearanceCharges = dto.destinChargeObj.destinCustomClearanceCharges;
            this.destinDOCharges = dto.destinChargeObj.destinDOCharges;
            this.destinFasahCharges = dto.destinChargeObj.destinFasahCharges;
            this.destinGatePassCharges = dto.destinChargeObj.destinGatePassCharges;
            this.destinLOLOCharges = dto.destinChargeObj.destinLOLOCharges;
            this.destinTransPortationCharges = dto.destinChargeObj.destinTransPortationCharges;            
        }
        this.destinTotalCharges = dto.destinChargeObj.destinTotalCharges;
        let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected;  
        this.toHoldData.forEach(elem => {
            if(elem.key == keyName){
                if(elem.value.length == 1){                    
                    elem.value[0].serviceChargeList = dto;
                    elem.value[0].currencyCode = dto.currencyCode;
                    elem.value[0].offSet = dto.offset;
                    this.currencyCode = dto.currencyCode;
                }
            }
        });
        this.showNewServiceCharge = false;
        this.serviceChargeList = dto;
        if(this.displayAllServiceChargeField == true) this.updateSLTotal();
        if(this.displayDestinCharges == true) this.updateDestinChargeTotal();
        if(this.displayOriginChargeCharge == true) this.updateOriginChargesTotal();
        console.log('warRiskSurcharges ',this.warRiskSurcharges)
        this.handleBuyingRate();
    }
    
    handleBAFChange(e){
        this.BAF = e.target.value;
        this.serviceChargeList.servichargesObj.BAF = this.BAF;
        this.updateSLTotal();
    }
    handleBunkerChargesChange(e){
        this.bunkerCharges = e.target.value;
        this.serviceChargeList.servichargesObj.bunkerCharges = this.bunkerCharges;
        this.updateSLTotal();
    }
    handleCleaningChargesChange(e){
        this.cleaningCharges = e.target.value;
        this.serviceChargeList.servichargesObj.cleaningCharges = this.cleaningCharges;
        this.updateSLTotal();
    }
    handleCMCChange(e){
        this.CMC = e.target.value;
        this.serviceChargeList.servichargesObj.CMC = this.CMC;
        this.updateSLTotal();
    }
    handleCarriageCongestionChange(e){
        this.carriageCongestionSurcharge = e.target.value;
        this.serviceChargeList.servichargesObj.carriageCongestionSurcharge = this.carriageCongestionSurcharge;
        this.updateSLTotal();
    }
    handleSecurityFeeChange(e){
        this.carrierSecurityFees = e.target.value;
        this.serviceChargeList.servichargesObj.carrierSecurityFees = this.carrierSecurityFees;
        this.updateSLTotal();
    }
    handleDGSurchargeChange(e){
        this.dgSurcharge = e.target.value;
        this.serviceChargeList.servichargesObj.dgSurcharge = this.dgSurcharge;
        this.updateSLTotal();
    }
    handleInlandFuelChange(e){
        this.inlandFuelCharges = e.target.value;
        this.serviceChargeList.servichargesObj.inlandFuelCharges = this.inlandFuelCharges;
        this.updateSLTotal();
    }
    handleDTHCChange(e){
        this.DTHC = e.target.value;
        this.serviceChargeList.servichargesObj.DTHC = this.DTHC;
        this.updateSLTotal();
    }
    handleequipmentImblanceChange(e){
        this.equipmentImbalance = e.target.value;
        this.serviceChargeList.servichargesObj.equipmentImbalance = this.equipmentImbalance;
        this.updateSLTotal();
    }
    handleInlandFuelChange(e){
        this.inlandFuelCharges = e.target.value;
        this.serviceChargeList.servichargesObj.inlandFuelCharges = this.inlandFuelCharges;
        this.updateSLTotal();
    }
    handleInlandHandlingfeesChange(e){
        this.inlandHandlingfees = e.target.value;
        this.serviceChargeList.servichargesObj.inlandHandlingfees = this.inlandHandlingfees;
        this.updateSLTotal();
    }
    handleInlandHaulageChange(e){
        this.inlandHaulage = e.target.value;
        this.serviceChargeList.servichargesObj.inlandHaulage = this.inlandHaulage;
        this.updateSLTotal();
    }
    handleISPSChange(e){
        this.ISPS = e.target.value;
        this.serviceChargeList.servichargesObj.ISPS = this.ISPS;
        this.updateSLTotal();
    }
    handleLowerSulpherChange(e){
        this.lowerSulphurSurcharge = e.target.value;
        this.serviceChargeList.servichargesObj.lowerSulphurSurcharge = this.lowerSulphurSurcharge;
        this.updateSLTotal();
    }
    handleOperationalRecoveryChange(e){
        this.operationalRecovery = e.target.value;
        this.serviceChargeList.servichargesObj.operationalRecovery = this.operationalRecovery;
        this.updateSLTotal();
    }
    handleOTHCChange(e){
        this.OTHC = e.target.value;
        this.serviceChargeList.servichargesObj.BAF = this.OTHC;
        this.updateSLTotal();
    }
    handleOverWeightChange(e){
        this.overWeightCharge = e.target.value;
        this.serviceChargeList.servichargesObj.BAF = this.overWeightCharge;
        this.updateSLTotal();
    }
    handleSealChargesChange(e){
        this.sealCharges = e.target.value;
        this.serviceChargeList.servichargesObj.sealCharges = this.sealCharges;
        this.updateSLTotal();
    }
    handleWarRiskSurchgesChange(e){
        this.warRiskSurcharges = e.target.value;
        this.serviceChargeList.servichargesObj.warRiskSurcharges = this.warRiskSurcharges;
        this.updateSLTotal();
    }
    handleTotalSLChange(e){        
        this.totalSl = e.target.value;
        this.serviceChargeList.servichargesObj.totalSl = this.totalSl;
        if(this.totalSl != '') {
            this.shippTotalChanged = true;
        }
        else this.shippTotalChanged = false
        this.serviceChargeList.servichargesObj.shippTotalChanged = this.shippTotalChanged;
    }
    updateSLTotal(){
        let Total = 0;
        Total = Total + (this.BAF > 0 ? parseInt(this.BAF) : 0) ;
        Total = Total + (this.bunkerCharges > 0 ? parseInt(this.bunkerCharges) : 0);
        Total = Total + (this.cleaningCharges > 0 ? parseInt(this.cleaningCharges) : 0);
        Total = Total + (this.CMC > 0 ? parseInt(this.CMC) : 0);
        Total = Total + (this.carriageCongestionSurcharge > 0 ? parseInt(this.carriageCongestionSurcharge) : 0);
        Total = Total + (this.carrierSecurityFees > 0 ? parseInt(this.carrierSecurityFees) : 0);
        Total = Total + (this.dgSurcharge > 0 ? parseInt(this.dgSurcharge) : 0);
        Total = Total + (this.DTHC > 0 ? parseInt(this.DTHC) : 0);
        Total = Total + (this.equipmentImbalance > 0 ? parseInt(this.equipmentImbalance) : 0);
        Total = Total + (this.inlandFuelCharges > 0 ? parseInt(this.inlandFuelCharges) : 0);
        Total = Total + (this.inlandHandlingfees > 0 ? parseInt(this.inlandHandlingfees) : 0);
        Total = Total + (this.inlandHaulage > 0 ? parseInt(this.inlandHaulage) : 0);
        Total = Total + (this.ISPS > 0 ? parseInt(this.ISPS) : 0);
        Total = Total + (this.lowerSulphurSurcharge > 0 ? parseInt(this.lowerSulphurSurcharge) : 0);
        Total = Total + (this.operationalRecovery > 0 ? parseInt(this.operationalRecovery) : 0);
        Total = Total + (this.OTHC > 0 ? parseInt(this.OTHC) : 0);
        Total = Total + (this.overWeightCharge > 0 ? parseInt(this.overWeightCharge) : 0);
        Total = Total + (this.sealCharges > 0 ? parseInt(this.sealCharges) : 0);
        Total = Total + (this.warRiskSurcharges > 0 ? parseInt(this.warRiskSurcharges) : 0);
        this.totalSl = Total;
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    
    handleBayanChange(e){
        this.bayan = e.target.value;
        this.serviceChargeList.originChargesObj.bayan = this.bayan;
        this.updateOriginChargesTotal();
    }
    handleBLFeesChange(e){
        this.blFees = e.target.value
        this.serviceChargeList.originChargesObj.blFees = this.blFees;
        this.updateOriginChargesTotal();
    }
    handleoriginCustomClerancehange(e){
        this.originCustomClearance = e.target.value
        this.serviceChargeList.originChargesObj.originCustomClearance = this.originCustomClearance;
        this.updateOriginChargesTotal();
    }
    handleExportServicehange(e){
        this.exportServiceFees = e.target.value
        this.serviceChargeList.originChargesObj.exportServiceFees = this.exportServiceFees;
        this.updateOriginChargesTotal();
    }
    handleFasahFeeChange(e){
        this.fasahFees = e.target.value
        this.serviceChargeList.originChargesObj.fasahFees = this.fasahFees;
        this.updateOriginChargesTotal();
    }
    handleFuelsurchargeChange(e){
        this.fuelSurcharge = e.target.value
        this.serviceChargeList.originChargesObj.fuelSurcharge = this.fuelSurcharge;
        this.updateOriginChargesTotal();
    }
    handleInspectionChange(e){
        this.inspection = e.target.value
        this.serviceChargeList.originChargesObj.inspection = this.inspection;
        this.updateOriginChargesTotal();
    }
    handleinsuranceChargeChange(e){
        this.insuranceCharges = e.target.value
        this.serviceChargeList.originChargesObj.insuranceCharges = this.insuranceCharges;
        this.updateOriginChargesTotal();
    }
    handleLiftOnOffChange(e){
        this.liftOnLiftOff = e.target.value
        this.serviceChargeList.originChargesObj.liftOnLiftOff = this.liftOnLiftOff;
        this.updateOriginChargesTotal();
    }
    handleOriginDetentionChange(e){
        this.OriginDetention = e.target.value
        this.serviceChargeList.originChargesObj.OriginDetention = this.OriginDetention;
        this.updateOriginChargesTotal();
    }
    handleOriginLoadingChargesChange(e){
        this.OriginLoadingCharges = e.target.value
        this.serviceChargeList.originChargesObj.OriginLoadingCharges = this.OriginLoadingCharges;
        this.updateOriginChargesTotal();
    }
    handlePickUpChargeChange(e){
        this.pickUpCharges = e.target.value
        this.serviceChargeList.originChargesObj.pickUpCharges = this.pickUpCharges;
        this.updateOriginChargesTotal();
    }
    handleReferPlugInChange(e){
        this.ReeferControlPlugInCharge = e.target.value
        this.serviceChargeList.originChargesObj.ReeferControlPlugInCharge = this.ReeferControlPlugInCharge;
        this.updateOriginChargesTotal();
    }
    handletabadulChange(e){
        this.tabadul = e.target.value
        this.serviceChargeList.originChargesObj.tabadul = this.tabadul;
        this.updateOriginChargesTotal();
    }
    handleTrapulinChargesChange(e){
        this.trapulinCharges = e.target.value
        this.serviceChargeList.originChargesObj.trapulinCharges = this.trapulinCharges;
        this.updateOriginChargesTotal();
    }
    handleTruckIdlingChange(e){
        this.truckIdlingCharges = e.target.value
        this.serviceChargeList.originChargesObj.truckIdlingCharges = this.truckIdlingCharges;
        this.updateOriginChargesTotal();
    }
    handleTransPortationChange(e){
        this.transportationCharges = e.target.value
        this.serviceChargeList.originChargesObj.transportationCharges = this.transportationCharges;
        this.updateOriginChargesTotal();
    }
    handleVGMChange(e){
        this.vgm = e.target.value
        this.serviceChargeList.originChargesObj.vgm = this.vgm;
        this.updateOriginChargesTotal();
    }
    handlelashingChargesChange(e){
        this.lashingCharges = e.target.value
        this.serviceChargeList.originChargesObj.lashingCharges = this.lashingCharges;
        this.updateOriginChargesTotal();
    }
    handlexrayChange(e){
        this.xray = e.target.value
        this.serviceChargeList.originChargesObj.xray = this.xray;
        this.updateOriginChargesTotal();
    }
    handletotalOriginChange(e){
        this.TotalOrigincharges = e.target.value
        this.serviceChargeList.originChargesObj.TotalOrigincharges = this.TotalOrigincharges;
        if(this.TotalOrigincharges != ''){
            this.originTotalChanged = true;           
        }
        else{
            this.originTotalChanged = false;
        }
        this.serviceChargeList.originChargesObj.originTotalChanged = this.originTotalChanged;
    }
    handleDirectionChange(e){
        this.directionValue = e.target.value
    }
    updateOriginChargesTotal(){
        let total = 0;
        total = total + (this.bayan > 0 ? parseInt(this.bayan) : 0)
            total = total + (this.blFees > 0 ? parseInt(this.blFees) : 0)
            total = total + (this.originCustomClearance > 0 ? parseInt(this.originCustomClearance) : 0)
            total = total + (this.exportServiceFees > 0 ? parseInt(this.exportServiceFees) : 0)
            total = total + (this.fasahFees > 0 ? parseInt(this.fasahFees) : 0)
            total = total + (this.fuelSurcharge > 0 ? parseInt(this.fuelSurcharge) : 0)
            total = total + (this.inspection > 0 ? parseInt(this.inspection) : 0)
            total = total + (this.insuranceCharges > 0 ? parseInt(this.insuranceCharges) : 0)
            total = total + (this.liftOnLiftOff > 0 ? parseInt(this.liftOnLiftOff) : 0)
            total = total + (this.OriginDetention > 0 ? parseInt(this.OriginDetention) : 0)
            total = total + (this.OriginLoadingCharges > 0 ? parseInt(this.OriginLoadingCharges) : 0)
            total = total + (this.pickUpCharges > 0 ? parseInt(this.pickUpCharges) : 0)
            total = total + (this.ReeferControlPlugInCharge > 0 ? parseInt(this.ReeferControlPlugInCharge) : 0)
            total = total + (this.tabadul > 0 ? parseInt(this.tabadul) : 0)
            total = total + (this.trapulinCharges > 0 ? parseInt(this.trapulinCharges) : 0)
            total = total + (this.truckIdlingCharges > 0 ? parseInt(this.truckIdlingCharges) : 0)
            total = total + (this.transportationCharges > 0 ? parseInt(this.transportationCharges) : 0)
            total = total + (this.vgm > 0 ? parseInt(this.vgm) : 0)
            total = total + (this.lashingCharges > 0 ? parseInt(this.lashingCharges) : 0)
            total = total + (this.xray > 0 ? parseInt(this.xray) : 0)
            this.TotalOrigincharges = total;
            this.updateTabsData();
            this.handleUpdateCalculation();
    }

    handleDestinBayanChargeChange(e){
        this.destinBayanCharges = e.detail;
        this.serviceChargeList.destinChargeObj.destinBayanCharges = this.destinBayanCharges;
        this.updateDestinChargeTotal();
    }
    handleDestinCustomClearanceChargeChange(e){
        this.destinCustomClearanceCharges = e.detail;
        this.serviceChargeList.destinChargeObj.destinCustomClearanceCharges = this.destinCustomClearanceCharges;
        this.updateDestinChargeTotal();
    }
    handleDestinDOChargeChange(e){
        this.destinDOCharges = e.detail;
        this.serviceChargeList.destinChargeObj.destinDOCharges = this.destinDOCharges;
        this.updateDestinChargeTotal();
    }    
    handleDestinFasahChargeChange(e){
        this.destinFasahCharges = e.detail;
        this.serviceChargeList.destinChargeObj.destinFasahCharges = this.destinFasahCharges;
        this.updateDestinChargeTotal();
    }
    handleDestinGatePassChange(e){
        this.destinGatePassCharges = e.detail;
        this.serviceChargeList.destinChargeObj.destinGatePassCharges = this.destinGatePassCharges;
        this.updateDestinChargeTotal();
    }
    handleDestinLOLOChargeChange(e){
        this.destinLOLOCharges = e.detail;
        this.serviceChargeList.destinChargeObj.destinLOLOCharges = this.destinLOLOCharges;
        this.updateDestinChargeTotal();
    }
    handleDestinTansPortationChange(e){
        this.destinTransPortationCharges = e.detail;
        this.serviceChargeList.destinChargeObj.destinTransPortationCharges = this.destinTransPortationCharges;
        this.updateDestinChargeTotal();
    }
    handleDestinTotalChange(e){
        this.destinTotalCharges = e.target.value;
        if(this.destinTotalCharges != '') this.DestinTotalChanged = true
        else this.DestinTotalChanged = false        
        this.serviceChargeList.destinChargeObj.destinTotalCharges = this.destinTotalCharges;
        this.serviceChargeList.destinChargeObj.DestinTotalChanged = this.DestinTotalChanged;
    }
    updateDestinChargeTotal(){
        let total = 0;
        total = total +(this.destinBayanCharges > 0 ? parseInt(this.destinBayanCharges) : 0);
        total = total +(this.destinCustomClearanceCharges > 0 ? parseInt(this.destinCustomClearanceCharges) : 0);
        total = total +(this.destinDOCharges > 0 ? parseInt(this.destinDOCharges) : 0);
        total = total +(this. destinFasahCharges > 0 ? parseInt(this.destinFasahCharges) : 0);
        total = total +(this. destinGatePassCharges > 0 ? parseInt(this.destinGatePassCharges) : 0);
        total = total +(this. destinLOLOCharges > 0 ? parseInt(this.destinLOLOCharges) : 0);
        total = total +(this. destinTransPortationCharges > 0 ? parseInt(this.destinTransPortationCharges) : 0);
        this.destinTotalCharges = total;
        this.updateTabsData();
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
    handleRemarksChange(e){
        this.quoteRemarks = e.target.value;
        console.log('quoteRemarks ',this.quoteRemarks)
    }
    handleQuickActionClicked(){
        this.showProcument = true;
    }
    handleCloseProcurement(){
        this.showProcument = false;
    }
    processData(){
        let dedicatedRoutingObj = this.routingListMap[this.agentTabSelected];
        let templist =[];
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
            if(elem.uniqueEquip == this.shippingEquipTabSelected){
                if(elem.equipmentId != ''){
                    this.seaFreight = elem.seaFreight;
                    this.validity = elem.validity;
                    this.equipmentId = elem.equipmentId;
                    this.equipNotfound = false ;
                    this.quantity = elem.quantity;
                    this.quotationItemId =elem.quotationItemId;
                    this.rmsId = elem.rmsID;
                    this.equipQuantity = elem.quantity
                    this.rateType = elem.rateType
                    this.rmsRemarks = elem.rmsRemarks
                }
                else{
                    this.equipNotfound = true ; 
                }
            }
        })
        this.isLoading = true;
        this.getServiceCharges();
        this.assignTabsData();

         let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+this.shippingEquipTabSelected;  
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
    handleaddServiceChargeChange(e){
        this.addServiceCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
    }
    handleaddOriginChargeChange(e){
        this.addOriginCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
    }
    handleaddDestinChange(e){
        this.addDestinCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
    }
    handleaddAdditionalChange(e){
        this.addAdditionalCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
    }
    handleaddExWorksChargeChange(e){
        this.addExWorksCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
    }
    handleAddRates(){
        let dedicatedRoutingObj = this.routingListMap[this.agentTabSelected];
        let templist =[];
        let agentId = '';
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
            if(elem.agentName == this.agentTabSelected) agentId = elem.agentId;
        })
        this.tempShippingTab = this.shippingTabSelected;
        let obj={Id:agentId,Name:this.agentTabSelected}
        this.agentObject = obj
        this.showAddRatesModel = true;
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
    handleAddWorks(){
        this.displayExWorksModal = true;
    }
    handleCloseExworks(){
        this.displayExWorksModal = false;
    }
    handleExWorksTotalChange(e){
        let value = parseInt(e.target.value)
        this.exWorksObj.LoadCharge = value
        this.exWorksTotal = value
        this.updateTabsData();
        this.handleBuyingRate();
        this.handleUpdateCalculation();
    }
    handleincludeServiceChargeChange(e){
        this.includeServiceCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
        this.handleUpdateCalculation();
    }
    handleincludeOriginChargeChange(e){
        this.includeOriginCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
        this.handleUpdateCalculation();
    }
    handleincludeDestinChargeChange(e){
        this.includeDestinCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
        this.handleUpdateCalculation();
    }
    handleincludeAdditionalChargeChange(e){
        this.includeAdditionalCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
        this.handleUpdateCalculation();
    }
    handleincludeExWorksChargeChange(e){
        this.includeExWorksCharge = e.target.checked;
        this.updateTabsData();
        this.handleBuyingRate();
        this.handleUpdateCalculation();
    }
    checkSaveQuoteClicked(){
        //console.log('**^ '+JSON.stringify(this.routingListMap,null,2))
        //console.log('**^^ '+JSON.stringify(this.toHoldData,null,2))
        let seletedEquipName = '';
        let foundTrue = false;
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
        data.forEach(elem =>{
            if(elem.uniqueEquip == this.shippingEquipTabSelected)
            seletedEquipName = elem.equipmentName;
        })
        let equipNameList = [];
        data.forEach(elem =>{
            if(elem.equipmentName == seletedEquipName){
                equipNameList.push(elem.uniqueEquip)
            }
        })
        console.log('## equipNameList '+JSON.stringify(equipNameList,null,2))
        if(equipNameList.length > 0){
            equipNameList.forEach(elem=>{
                let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+elem;
                console.log('## keyName '+keyName)
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
                    let keyName = this.agentTabSelected+'-'+this.shippingTabSelected+'-'+elem;
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
        let dedicatedRoutingObj = this.routingListMap[this.agentTabSelected];
        let templist = [];
        for(let key in dedicatedRoutingObj){
            templist.push({key:key, data: dedicatedRoutingObj[key]})
        }
        let data = [];
        let index = templist.findIndex(x=>x.key == this.shippingTabSelected);
        data = templist[index].data;
        let index2 = data.findIndex(x=>x.uniqueEquip == this.shippingEquipTabSelected);
        ToReturnValidity = data[index2].buyingRateValidity;
        return ToReturnValidity;
    }
    handlesellingBAFBAFChange(e){
        this.sellingBAF = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingBunkerChargesChange(e){
        this.sellingbunkerCharges = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingCleaningChargesChange(e){
        this.sellingcleaningCharges = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handlesellingCMCChange(e){
        this.sellingCMC = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingCarriageCongestionChange(e){
        this.sellingcarriageCongestionSurcharge = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingSecurityFeeChange(e){
        this.sellingcarrierSecurityFees = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingDGSurchargeChange(e){
        this.sellingdgSurcharge = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingDTHCChange(e){
        this.sellingDTHC = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingequipmentImblanceChange(e){
        this.sellingequipmentImbalance = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingInlandFuelChange(e){
        this.sellinginlandFuelCharges= parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingInlandHandlingfeesChange(e){
        this.sellinginlandHandlingfees = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingInlandHaulageChange(e){
        this.sellinginlandHaulage = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingISPSChange(e){
        this.sellingISPS = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingLowerSulpherChange(e){
        this.sellinglowerSulphurSurcharge = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingOperationalRecoveryChange(e){
        this.sellingoperationalRecovery = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    andleSellingOTHCChange(e){
        this.sellingOTHC = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingOverWeightChange(e){
        this.sellingoverWeightCharge = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingSealChargesChange(e){
        this.sellingsealCharges = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingWarRiskSurchgesChange(e){
        this.sellingwarRiskSurcharges = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    handleSellingOTHCChange(e){
        this.sellingOTHC = parseInt(e.target.value);
        this.updateTotalSellingSL();
    }
    updateTotalSellingSL(){
        let Total = 0;
        Total = Total + (this.sellingBAF > 0 ? parseInt(this.sellingBAF) : 0) ;
        Total = Total + (this.sellingbunkerCharges > 0 ? parseInt(this.sellingbunkerCharges) : 0);
        Total = Total + (this.sellingcleaningCharges > 0 ? parseInt(this.sellingcleaningCharges) : 0);
        Total = Total + (this.sellingCMC > 0 ? parseInt(this.sellingCMC) : 0);
        Total = Total + (this.sellingcarriageCongestionSurcharge > 0 ? parseInt(this.sellingcarriageCongestionSurcharge) : 0);
        Total = Total + (this.sellingcarrierSecurityFees > 0 ? parseInt(this.sellingcarrierSecurityFees) : 0);
        Total = Total + (this.sellingdgSurcharge > 0 ? parseInt(this.sellingdgSurcharge) : 0);
        Total = Total + (this.sellingDTHC > 0 ? parseInt(this.sellingDTHC) : 0);
        Total = Total + (this.sellingequipmentImbalance > 0 ? parseInt(this.sellingequipmentImbalance) : 0);
        Total = Total + (this.sellinginlandFuelCharges > 0 ? parseInt(this.sellinginlandFuelCharges) : 0);
        Total = Total + (this.sellinginlandHandlingfees > 0 ? parseInt(this.sellinginlandHandlingfees) : 0);
        Total = Total + (this.sellinginlandHaulage > 0 ? parseInt(this.sellinginlandHaulage) : 0);
        Total = Total + (this.sellingISPS > 0 ? parseInt(this.sellingISPS) : 0);
        Total = Total + (this.sellinglowerSulphurSurcharge > 0 ? parseInt(this.sellinglowerSulphurSurcharge) : 0);
        Total = Total + (this.sellingoperationalRecovery > 0 ? parseInt(this.sellingoperationalRecovery) : 0);
        Total = Total + (this.sellingOTHC > 0 ? parseInt(this.sellingOTHC) : 0);
        Total = Total + (this.sellingoverWeightCharge > 0 ? parseInt(this.sellingoverWeightCharge) : 0);
        Total = Total + (this.sellingsealCharges > 0 ? parseInt(this.sellingsealCharges) : 0);
        Total = Total + (this.sellingwarRiskSurcharges > 0 ? parseInt(this.sellingwarRiskSurcharges) : 0);
        this.sellingtotalSl = Total;
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    handleSellingBayanChange(e){
        this.sellingbayan = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingBLFeesChange(e){
        this.sellingblFees = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingoriginCustomClerancehange(e){
        this.sellingoriginCustomClearance = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingExportServicehange(e){
        this.sellingexportServiceFees = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingFasahFeeChange(e){
        this.sellingfasahFees = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingFuelsurchargeChange(e){
        this.sellingfuelSurcharge = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingInspectionChange(e){
        this.sellinginspection = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellinginsuranceChargeChange(e){
        this.sellinginsuranceCharges = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingLiftOnOffChange(e){
        this.sellingliftOnLiftOff = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingOriginDetentionChange(e){
        this.sellingOriginDetention = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingOriginLoadingChargesChange(e){
        this.sellingOriginLoadingCharges = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingPickUpChargeChange(e){
        this.sellingpickUpCharges = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingReferPlugInChange(e){
        this.sellingReeferControlPlugInCharge = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingtabadulChange(e){
        this.sellingtabadul = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingTrapulinChargesChange(e){
        this.sellingtrapulinCharges = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingTruckIdlingChange(e){
        this.sellingtruckIdlingCharges = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingTransPortationChange(e){
        this.sellingtransportationCharges = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingVGMChange(e){
        this.sellingvgm = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellinglashingChargesChange(e){
        this.sellinglashingCharges = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    handleSellingxrayChange(e){
        this.sellingxray = parseInt(e.target.value);
        this.updateSellingOriginTotal();
    }
    updateSellingOriginTotal(){
        let total = 0;
        console.log('total ' +total)
        total = total + (this.sellingbayan > 0 ? parseInt(this.sellingbayan) : 0)
            total = total + (this.sellingblFees > 0 ? parseInt(this.sellingblFees) : 0)
            total = total + (this.sellingoriginCustomClearance > 0 ? parseInt(this.sellingoriginCustomClearance) : 0)
            total = total + (this.sellingexportServiceFees > 0 ? parseInt(this.sellingexportServiceFees) : 0)
            total = total + (this.sellingfasahFees > 0 ? parseInt(this.sellingfasahFees) : 0)
            total = total + (this.sellingfuelSurcharge > 0 ? parseInt(this.sellingfuelSurcharge) : 0)
            total = total + (this.sellinginspection > 0 ? parseInt(this.sellinginspection) : 0)
            total = total + (this.sellinginsuranceCharges > 0 ? parseInt(this.sellinginsuranceCharges) : 0)
            total = total + (this.sellingliftOnLiftOff > 0 ? parseInt(this.sellingliftOnLiftOff) : 0)
            total = total + (this.sellingOriginDetention > 0 ? parseInt(this.sellingOriginDetention) : 0)
            total = total + (this.sellingOriginLoadingCharges > 0 ? parseInt(this.sellingOriginLoadingCharges) : 0)
            total = total + (this.sellingpickUpCharges > 0 ? parseInt(this.sellingpickUpCharges) : 0)
            total = total + (this.sellingReeferControlPlugInCharge > 0 ? parseInt(this.sellingReeferControlPlugInCharge) : 0)
            total = total + (this.sellingtabadul > 0 ? parseInt(this.sellingtabadul) : 0)
            total = total + (this.sellingtrapulinCharges > 0 ? parseInt(this.sellingtrapulinCharges) : 0)
            total = total + (this.sellingtruckIdlingCharges > 0 ? parseInt(this.sellingtruckIdlingCharges) : 0)
            total = total + (this.sellingtransportationCharges > 0 ? parseInt(this.sellingtransportationCharges) : 0)
            total = total + (this.sellingvgm > 0 ? parseInt(this.sellingvgm) : 0)
            total = total + (this.sellinglashingCharges > 0 ? parseInt(this.sellinglashingCharges) : 0)
            total = total + (this.sellingxray > 0 ? parseInt(this.sellingxray) : 0)
            console.log('total ' +total)
            this.sellingTotalOrigincharges = total;
            this.updateTabsData();
            this.handleUpdateCalculation();
    }
    handleDestinSellingBayanChargeChange(e){
        this.sellingdestinBayanCharges = parseInt(e.detail);
        this.updateSellingDestinChargeTotal();
    }
    handleDestinSellingCustomClearanceChargeChange(e){
        this.sellingdestinCustomClearanceCharges = parseInt(e.detail);
        this.updateSellingDestinChargeTotal();
    }
    handleDestinSellingDOChargeChange(e){
        this.sellingdestinDOCharges = parseInt(e.detail);
        this.updateSellingDestinChargeTotal();
    }
    handleSellingDestinFasahChargeChange(e){
        this.sellingdestinFasahCharges = parseInt(e.detail);
        this.updateSellingDestinChargeTotal();
    }
    handleSellingDestinGatePassChange(e){
        this.sellingdestinGatePassCharges = parseInt(e.detail);
        this.updateSellingDestinChargeTotal();
    }
    handleSellingDestinLOLOChargeChange(e){
        this.sellingdestinLOLOCharges = parseInt(e.detail);
        this.updateSellingDestinChargeTotal();
    }
    handleSellingDestinTansPortationChange(e){
        this.sellingdestinTransPortationCharges = parseInt(e.detail);
        this.updateSellingDestinChargeTotal();
    }
    handleSellingDestinTotalChange(e){
        this.sellingdestinBayanCharges = parseInt(e.detail);
    }
    updateSellingDestinChargeTotal(){
        let total = 0;
        total = total +(this.sellingdestinBayanCharges > 0 ? parseInt(this.sellingdestinBayanCharges) : 0);
        total = total +(this.sellingdestinCustomClearanceCharges > 0 ? parseInt(this.sellingdestinCustomClearanceCharges) : 0);
        total = total +(this.sellingdestinDOCharges > 0 ? parseInt(this.sellingdestinDOCharges) : 0);
        total = total +(this.sellingdestinFasahCharges > 0 ? parseInt(this.sellingdestinFasahCharges) : 0);
        total = total +(this.sellingdestinGatePassCharges > 0 ? parseInt(this.sellingdestinGatePassCharges) : 0);
        total = total +(this.sellingdestinLOLOCharges > 0 ? parseInt(this.sellingdestinLOLOCharges) : 0);
        total = total +(this.sellingdestinTransPortationCharges > 0 ? parseInt(this.sellingdestinTransPortationCharges) : 0);
        this.sellingdestinTotalCharges = total;
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    handletotalSellingOriginChange(e){
        this.sellingTotalOrigincharges = parseInt(e.target.value);
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    handleSellingtotalDestinChange(e){
        this.sellingdestinTotalCharges = parseInt(e.target.value);
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    handleSellingtotalSlChange(e){
        this.sellingtotalSl = parseInt(e.target.value);
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
    handleSellingExWorksTotalChange(e){
        this.sellingexWorksTotal = parseInt(e.target.value);
        this.updateTabsData();
        this.handleUpdateCalculation();
    }
}