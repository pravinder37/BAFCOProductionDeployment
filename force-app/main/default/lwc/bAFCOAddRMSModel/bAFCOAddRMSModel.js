import { LightningElement ,api,track,wire} from 'lwc';
import RATE_TYPE_FIELD from '@salesforce/schema/RMS__c.Rate_Type__c';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import addRates from '@salesforce/apex/BAFCOLRoutingDetailsController.addRates';
import getRouteEquipType from '@salesforce/apex/BAFCOLRoutingDetailsController.getRouteEquipType';
import getLoadingCharges from '@salesforce/apex/BAFCOLRoutingDetailsController.getLoadingCharges';
import getExchangeRate from '@salesforce/apex/BAFCOLRoutingDetailsController.getExchangeRate';
import DIRECTION_FIELD from '@salesforce/schema/Loading_Charge__c.Direction__c';
import BUSINESS_TYPE_FIELD from '@salesforce/schema/RMS__c.Business_Type__c';
import getDefualtValueForRMS from '@salesforce/apex/BAFCOLRoutingDetailsController.getDefualtValueForRMS';
import getDefaultImportAddRate from '@salesforce/apex/BAFCOLRoutingDetailsController.getDefaultImportAddRate';
import addRouteEquipment from '@salesforce/apex/BAFCOLRoutingDetailsController.addRouteEquipment';
import getAirRouteEquipment from '@salesforce/apex/BAFCOAirEnquiryController.getAirRouteEquipment';
import addRatesAir from '@salesforce/apex/BAFCOAirEnquiryController.addRatesAir';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class BAFCOAddRMSModel
 extends LightningElement {
    @api portLoading ='';
    @api portDestination ='';
    @api airline='';
    @api isAir = false;
    @track commodity = '';
    @api shippingLine ='';
    @api equipmentType = '';
    @api routeId ='';
    @api leadId = '';
    @api acctName = '';
    @api pickupPlace ='';
    @api dischargePlace = '';
    @api portLoadingId='';
    @api incoTerm = '';
    @track incoTermId = '';
    @api agentObject;
    @api cameFromImport = false;
    @api airExport = false;
    @track airequipmentTypeError = '';

    @track validity = '';
    @track rateType = '';
    @track rateTypeOption =[];
    @track seaFreight = '';
    @track emptyEquipType = true;
    @track pickListvalues =[];
    @api businessType = '';
    @track todaysDate = '';
    @track allInRate = false;
    @track FOBAllIn = false;
    @track ExWorksIn = false;
    @track oceanfreightCheckbox = false;
    @track displayOriginCharge = true;
    @track displayShippingCharge = true;
    @track displayDestinCharge = true;
    @track FreeTime = 0;
    @track FreeTimePOD = 0;
    @track remarks ='';
    @track curencyCodeOption = [];
    @track shippExchangeRate = '';
    @track shippOffSet = '';
    @track incoExchangeRate = '';
    @track incoOffSet = '';
    @track destinExchangeRate = '';
    @track destinOffSet = '';
    @track isLoading = false;
    @track customerId = '';
    @track customerOption = [];
    @track loadigPortLabel = 'Port of Loading';
    @track destinationPortLabel = 'Port of Destination';
    @track rateKgs = null;
    @track airTabViewList =[];
    @track selectedRouteEquip = '';
    @track rateKgsError = '';
    @track isAirExport = false;
    bayan = null;                
    destinationCustomsClearance = null; 
    destinationLoadingCharges = null; 
    fasahFee = null; 
    inspection = null;              
    liftOnLiftOff = null;                  
    originCustomsclearance = null;               
    originLoadingCharges = null;              
    portShuttling = null;                    
    tabadul = null;                 
    xray = null;               
    total = null;
    @track incoTotal = null ;
    loadingCharge = null;
    
    BAF = null;
    BunkerSurcharge = null;
    ISPS = null;
    OTHC = null;
    CMC = null;
    EIC = null;
    sealCharges = null;
    DTHC = null;
    Total = null;
    shippTotal =null;

    @track shipp = {};
    @track incoCharges ={};
    @track destinCharges ={};
    @track rmsDetail ={};
    @track pickListvaluesBusinessType = [];

    @track incoChargeTotalChange = false; 
    @track shippTotalChanged = false; 
    @track DirectionOptions = [];
    @track directionValue = '';
    @track destinTotalChanged = false;
    @track disableShippOffSet = true;
    @track disableIncoOffSet = true;
    @track disableDestinOffSet = true;
    @track agentName ='';

    //Container Var
    @track displayAddRouteEquip = false;
    @track containerRecord = [];
    @track contrIndex = 0;
    @track noRecord = false;
    @track toDeleteRecord = [];
    @track rmscurrencyCode = 'USD';


    @track commodityError = '';
    @track incoTermError = '';
    @track equipmentTypeError = '';
    @track rateTypeError = '';
    @track validityError = '';
    @track seaFreightError = '';

    @track selectedEquip = [];
    @track twoEquipSelected = false;
    @track elem1Label = 'Sea Freight';
    @track elem2Label = '';
    @track displayElem1 = true;
    @track displayElem2 = false;
    @track elem1Value = null;
    @track elem2Value = null;
    @track displayContractNumber = false;
    @track contractNumber = null;

    @wire(getPicklistValues, {
        recordTypeId : '012000000000000AAA',
        fieldApiName : DIRECTION_FIELD
    })directionPickListValue({ data, error }){
            if(data){
                //console.log(` DIRECTION_FIELD values are `, data.values);
                this.DirectionOptions = data.values;
                this.directionValue = this.DirectionOptions[0].value;
                this.getLoadingCharges();
                this.error = undefined;
            }
            if(error){
                console.log(` Error while fetching DIRECTION_FIELD Picklist values  ${error}`);
                this.error = error;
                this.DirectionOptions = undefined;
            }
    }

    connectedCallback(){
        console.log('airExport '+this.airExport)
        if(this.isAir == true){
            this.loadigPortLabel = 'Airport of Loading';
            this.destinationPortLabel = 'Airport of Destination';
            this.displayShippingCharge = false;
            this.displayOriginCharge = false;
            this.displayDestinCharge = false;
            this.displayElem1 = false;
            this.displayElem2 = false;
            this.getAirRouteEquipment();
            if(this.businessType == 'Export' ) this.isAirExport = true;
        }
        else{
            this.loadigPortLabel = 'Port of Loading';
            this.destinationPortLabel = 'Port of Destination';
        }
       if(this.leadId != ''){
            this.customerOption.push({label:this.acctName,value:this.leadId})
        }
        if(!this.isAir) this.getRouteEquipType();
        this.getExchangeRate();
        this.getDefualtValueForRMS();
        let templist = {
            'BAF':null,
            'BunkerSurcharge':null,
            'ISPS':null,
            'OTHC':null,
            'CMC':null,
            'EIC':null,
            'sealCharges':null,
            'DTHC':null,
            'Total':null,
            'currencyCode':'USD',
            'carriageCongestionSurcharg':null,
            'carrierSecurityFees':null,
            'cleaningCharges':null,
            'DGSurcharge':null,
            'inlandFuelSurcharge':null,
            'inlandHandlingFees':null,
            'inlandhaulage':null,
            'lowSulphurSurcharge':null,
            'operationalRecoverySurcharge':null,
            'overweightsurcharge':null,
            'warRiskSurcharge':null,
            'offSet':null   
        }
        this.shipp = templist;

        let tempList2 = {             
            'bayan' : null,           
            'fasahFee' : null,
            'inspection' : null,                
            'liftOnLiftOff' : null,                    
            'originCustomsclearance' : null,                
            'originLoadingCharges' : null,                
            'portShuttling' : null,                    
            'tabadul' : null,                
            'xray' : null,                
            'total' : null,
            'loadingCharge':null,
            'loadingChargeId':'',
            'currencyCode':'USD',
            'bLFees':null,
            'exportServiceFees':null,
            'fuelSurcharge':null,
            'insuranceCharges':null,
            'originDetentionDemurrageCharges':null,
            'OTHC':null,
            'pickupCharges':null,
            'reeferPluginCharges':null,
            'tarpaulinCharges':null,
            'truckidlingCharges':null,
            'vGM':null,
            'lashingCharges':null,
            'offSet':null        
        }
        this.incoCharges = tempList2;

        let templist3 = {
            'bayanCharges':null,
            'customClearance':null,
            'doCharges':null,
            'DTHC':null,
            'fasahCharges':null,
            'gatePassCharges':null,
            'LOLOCharges':null,
            'total':null,
            'transportation':null,
            'currencyCode':'USD',
            'offSet':null   
        }
        this.destinCharges = templist3;

    }

    @wire(getPicklistValues, {
        recordTypeId : '012000000000000AAA',
        fieldApiName : RATE_TYPE_FIELD
    })wiredPickListValue({ data, error }){
            if(data){
                //console.log(` Picklist values are `, data.values);
                this.rateTypeOption = data.values;
                if(this.airExport) {
                    this.rateType = 'Spot';
                    this.rmsDetail.rateType = this.rateType;
                    this.validity = this.formatDate(this.todaysDate,15);
                    this.rmsDetail.validity = this.validity;
                    this.validityError = '';
                    this.rmscurrencyCode = 'SAR';
                }
            }
            if(error){
                console.log(` Error while fetching Picklist values  ${error}`);
                this.rateTypeOption = undefined;
            }
        }

      
        @wire(getPicklistValues, {
            recordTypeId : '012000000000000AAA',
            fieldApiName : BUSINESS_TYPE_FIELD
        })wiredBussinessPickListValue({ data, error }){
                if(data){
                    //console.log(` business Picklist values are `, data.values);
                    this.pickListvaluesBusinessType = data.values;
                }
                if(error){
                    console.log(` Error business while fetching Picklist values  ${error}`);
                    this.pickListvaluesBusinessType = undefined;
                }
            }
    
    
    closeModal(){
        this.dispatchEvent(new CustomEvent('close'));
    }
    handleValidityChange(e){
        this.validity = e.target.value;
        this.rmsDetail.validity = this.validity;
        this.validityError = '';
    }    
    handleShippCurrencyCodeSelection(currency){
        console.log('handleShippCurrencyCodeSelection came'+currency);
        this.shipp.currencyCode = currency;
        this.curencyCodeOption.forEach(elem=>{
            if(elem.value == currency){
                this.shippExchangeRate = elem.exchangeRate
                this.shippOffSet = elem.offSet
                this.shipp.offSet = elem.offSet
            }
        })
        if(this.shipp.currencyCode == 'USD') {
            this.disableShippOffSet = true;
            this.shipp.offSet = 0;
        }
        else{
            this.disableShippOffSet = false;
        }
        
    }
    handleShippOffestChange(e){
        this.shipp.offSet = e.target.value;
    }
    handleINCOCurrencyCodeSelection(currency){
        console.log('handleINCOCurrencyCodeSelection '+currency)
        this.incoCharges.currencyCode = currency;
        this.curencyCodeOption.forEach(elem=>{
            if(elem.value == currency){
                this.incoExchangeRate = elem.exchangeRate
                this.incoOffSet = elem.offSet
                this.incoCharges.offSet = elem.offSet
            }
        })
        if(this.incoCharges.currencyCode == 'USD') {
            this.disableIncoOffSet = true;
            this.incoCharges.offSet = 0;
        }
        else{
            this.disableIncoOffSet = false;
        }
    }
    handleIncoOffsetChange(e){
        this.incoCharges.offSet = e.target.value;
    }
    handleDestinCurrencyCodeSelection(currency){
        console.log('handleDestinCurrencyCodeSelection '+currency)
        this.destinCharges.currencyCode = currency;
        this.curencyCodeOption.forEach(elem=>{
            if(elem.value == currency){
                this.destinExchangeRate = elem.exchangeRate
                this.destinOffSet = elem.offSet
                this.destinCharges.offSet = elem.offSet
            }
        })
        if(this.destinCharges.currencyCode == 'USD') {
            this.disableDestinOffSet = true;
            this.destinCharges.offSet = 0;
        }
        else{
            this.disableDestinOffSet = false;
        }
    }
    handleDestinOffSetChange(e){
        this.destinCharges.offSet = e.target.value;
    }
    handleAllInRateChange(e){
        this.FOBAllIn = false;
        this.ExWorksIn = false;
        this.oceanfreightCheckbox = false;
        this.allInRate = e.target.checked;
        this.updateRMSCheckBox();
    }
    handleFOBAllInChange(e){
        this.allInRate = false;
        this.ExWorksIn = false;
        this.oceanfreightCheckbox = false;
        this.FOBAllIn = e.target.checked;
        this.updateRMSCheckBox();
    }
    handleExWorksChange(e){
        this.FOBAllIn = false;
        this.allInRate = false;
        this.oceanfreightCheckbox = false;
        this.ExWorksIn = e.target.checked;
        this.updateRMSCheckBox();
    }
    handleoceanfreightCheckboxChange(e){
        this.FOBAllIn = false;
        this.allInRate = false;
        this.ExWorksIn = false;
        this.oceanfreightCheckbox = e.target.checked;
        this.updateRMSCheckBox();
    }
    updateRMSCheckBox(){
        if(this.allInRate == true){
            this.FOBAllIn = false;
            this.ExWorksIn = false;
            this.oceanfreightCheckbox = false;
            this.displayOriginCharge = false;
            this.displayShippingCharge = false;
            this.displayDestinCharge= true;
        }
        else if(this.FOBAllIn == true){
            this.allInRate = false;
            this.ExWorksIn = false;
            this.oceanfreightCheckbox = false;
            this.displayShippingCharge = false;
            this.displayOriginCharge = false;
            this.displayDestinCharge= true;
        }
        else if(this.ExWorksIn == true){
            this.FOBAllIn = false;
            this.allInRate = false;
            this.oceanfreightCheckbox = false;
            this.displayShippingCharge = false;
            this.displayOriginCharge = false;
            this.displayDestinCharge= true;
        }else if(this.oceanfreightCheckbox == true){
            this.FOBAllIn = false;
            this.allInRate = false;
            this.displayShippingCharge = true;
            this.displayOriginCharge = false;
            this.displayDestinCharge= false;
        }
        else if(this.allInRate == false &&  this.FOBAllIn == false && this.ExWorksIn == false && this.oceanfreightCheckbox == false){
            this.displayShippingCharge = true;
            this.displayOriginCharge = true;
            this.displayDestinCharge= true;
        }
        this.rmsDetail.allInRate = this.allInRate;
        this.rmsDetail.FOBAllIn = this.FOBAllIn;
        this.rmsDetail.ExWorksIn = this.ExWorksIn;
        this.rmsDetail.oceanfreightCheckbox = this.oceanfreightCheckbox;
        //console.log('rms  '+JSON.stringify(this.rmsDetail,null,2))
    }
    handleRemarksChange(e){
        this.remarks = e.target.value;
        this.rmsDetail.remarks = this.remarks
    }
    handleFreeTimeChange(e){
        this.FreeTime = e.target.value
        this.rmsDetail.FreeTime = this.FreeTime
    }
    handleFreeTimePODChange(e){
        this.FreeTimePOD = e.target.value
        this.rmsDetail.FreeTimePOD = this.FreeTimePOD
    }
    handleRateTypeChange(e){
        this.rateType = e.target.value;
        this.rmsDetail.rateType = this.rateType;
        if(this.rateType == 'Spot'){
            this.validity = this.formatDate(this.todaysDate,0)
            this.contractNumber = null;
            this.displayContractNumber = false;
            this.rmsDetail.contractNumber= null;
        }
        else if(this.rateType == 'Contract'){
            this.contractNumber = null;
            this.displayContractNumber = true;
            this.rmsDetail.contractNumber= null;
            let ddd = new Date();
            let year = ddd.getFullYear();
            let month = ddd.getMonth();
            let lastdate = new Date(year, month +1, 0);
            this.validity = this.formatDate(lastdate,0)
        }
        this.rmsDetail.validity = this.validity 
        this.rateTypeError = '';
        this.validityError = '';
    }
    formatDate(date,days) {
        let date1 = new Date(date);
        date1.setDate(date1.getDate() + days)
        let d = new Date(date1),
            month = '' + (d.getMonth() + 1),
            day = '' + (d.getDate()),
            year = d.getFullYear();
    
        if (month.length < 2) 
            month = '0' + month;
        if (day.length < 2) 
            day = '0' + day;
    
        return [year, month, day].join('-');
    }
    handleSeaFreightChange(e){
        if(e.target.value != '') this.seaFreight = parseInt(e.target.value);
        else this.seaFreight = 0;
        this.rmsDetail.seaFreight = this.seaFreight;
        this.seaFreightError = '';
    }
    handleBusinessTypeChange(e){
        this.businessType = e.target.value;
        this.rmsDetail.businessType = this.businessType;
    }
    handletotalChange(e){
        this.incoCharges.total = parseInt(e.target.value);
        if(!isNaN(this.incoCharges.total)) this.incoChargeTotalChange = true;
        else this.incoChargeTotalChange = false;
    }
    submitDetails(){
        this.isLoading = true
        let allValid = true;
        if(this.rmsDetail.commodity == ''){
            allValid = false;
            this.commodityError = 'slds-has-error';
        }
        if(this.rmsDetail.incoTermId == ''){
            allValid = false;
            this.incoTermError = 'slds-has-error';
        }
        if(this.rmsDetail.equipmentId == ''){
            allValid = false;
            this.equipmentTypeError = 'slds-has-error';
        }
        if(this.rmsDetail.rateType == ''){
            allValid = false;
            this.rateTypeError = 'slds-has-error';
        }
        if(this.rmsDetail.validity == null){
            allValid = false;
            this.validityError = 'slds-has-error';
        }
        /*if(this.rmsDetail.seaFreight == null || this.rmsDetail.seaFreight <= 0 ){
            allValid = false;
            this.seaFreightError = 'slds-has-error';
        }*/
        if(this.isAir == false){
            if(this.rmsDetail.selectedEquip.length == 0){
                allValid = false;
                this.equipmentTypeError = 'slds-has-error';
                this.equipmentTypeErrorMsg = 'Complete this field.'
            }
            else if(this.rmsDetail.selectedEquip.length > 2){
                allValid = false;
                this.equipmentTypeError = 'slds-has-error';
                this.equipmentTypeErrorMsg = 'Max 2 can be selected at a time.'
            }
            if(this.rmsDetail.elem1Value <= 0){
                allValid = false;
                this.elem1seaFreightError = 'slds-has-error';
            }
            if(this.displayElem2){
                if(this.rmsDetail.elem2Value <= 0){
                    allValid = false;
                    this.elem2seaFreightError = 'slds-has-error';
                }
            }
        }
        if(this.isAir == true){
            if(this.selectedRouteEquip == '') {
                this.airequipmentTypeError= 'slds-has-error';
                allValid = false;
            }
            if(!this.rateKgs > 0){
                this.rateKgsError= 'slds-has-error';
                allValid = false;
            }
        }
        
        console.log('rms '+JSON.stringify(this.rmsDetail,null,2))
        if(allValid){
            if(this.isAir){
                addRatesAir({
                    rmsDetail: this.rmsDetail,
                    routeId : this.routeId,
                    airline : this.airline,
                    rateKgs: this.rateKgs,
                    selectedRouteEquip : this.selectedRouteEquip,
                    rmscurrencyCode  :this.rmscurrencyCode,
                    businessType : this.businessType,
                })
            .then(result =>{
                this.isLoading = false
                console.log('result  '+JSON.stringify(result))
                this.dispatchEvent(new CustomEvent('success'));
            }).catch(error=>{
                this.isLoading = false
                console.log('error add rate : ', JSON.stringify(error));
            });
            }
            else{
                addRates({
                    rmsDetail: this.rmsDetail,
                    routeId : this.routeId,
                    shippingChargeDto : this.shipp,
                    incocharges : this.incoCharges,
                    totalShippChanged : this.shippTotalChanged,
                    totalIncoChanged : this.incoChargeTotalChange,
                    equipmentType : this.equipmentType,
                    shippingLine : this.shippingLine,
                    leadId : this.leadId,
                    destinTotalChanged : this.destinTotalChanged,
                    destinCharges:this.destinCharges,
                    selectedEquip:this.selectedEquip,
                    rmscurrencyCode:this.rmscurrencyCode
        
                }).then(result =>{
                    this.isLoading = false
                    console.log('result  '+JSON.stringify(result))
                    this.dispatchEvent(new CustomEvent('success'));
                }).catch(error=>{
                    this.isLoading = false
                    console.log('error add rate : ', JSON.stringify(error));
                });
            }
    }
    else{
        this.isLoading = false
    }
    }
    handleBAFChange(e){
        this.shipp.BAF = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handleBunkerSurchargeChange(e){
        this.shipp.BunkerSurcharge = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handleISPSChange(e){
        this.shipp.ISPS = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handleOTHCChange(e){
        this.shipp.OTHC = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handleCMCChange(e){
        this.shipp.CMC = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handleEICChange(e){
        this.shipp.EIC = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handlesealChargesChange(e){
        this.shipp.sealCharges = parseInt(e.target.value);
        this.updateShippingTotal();
    }    
    handleshippTotalChange(e){
        this.shipp.Total = e.target.value;
        if(!this.shipp.Total == '') this.shippTotalChanged = true;
        else this.shippTotalChanged = false;
    }
    handleDTHCChange(e){
        this.shipp.DTHC = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handlebayanChange(e){
        this.incoCharges.bayan = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handlefasahFeeChange(e){
        this.incoCharges.fasahFee = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handleinspectionChange(e){
        this.incoCharges.inspection = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handleliftOnLiftOffChange(e){
        this.incoCharges.liftOnLiftOff = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handleoriginCustomsclearanceChange(e){
        this.incoCharges.originCustomsclearance = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handleoriginLoadingChargesChange(e){
        this.incoCharges.originLoadingCharges = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handleportShuttlingChange(e){
        this.incoCharges.portShuttling = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handletabadulChange(e){
        this.incoCharges.tabadul = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handlexrayChange(e){
        this.incoCharges.xray = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handleLoadingChargeChange(e){
        this.incoCharges.loadingCharge = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    updaTeIncoChargeTotal(){
        let Total = 0 ;
        Total = Total + this.incoCharges.bayan  ;    
        Total = Total + this.incoCharges.fasahFee ;
        Total = Total + this.incoCharges.inspection   ;        
        Total = Total + this.incoCharges.liftOnLiftOff    ;           
        Total = Total +  this.incoCharges.originCustomsclearance   ;         
        Total = Total +  this.incoCharges.originLoadingCharges    ; 
        Total = Total +  this.incoCharges.portShuttling  ;                 
        Total = Total +  this.incoCharges.tabadul  ;               
        Total = Total +  this.incoCharges.xray ;
        //Total = Total +  this.incoCharges.loadingCharge ;
        Total = Total +  this.incoCharges.bLFees ;
        Total = Total + this.incoCharges.fuelSurcharge;
        Total = Total +  this.incoCharges.exportServiceFees ;
        Total = Total +  this.incoCharges.insuranceCharges ;
        Total = Total +  this.incoCharges.lashingCharges ;
        Total = Total +  this.incoCharges.originDetentionDemurrageCharges ;
        Total = Total +  this.incoCharges.OTHC ;
        Total = Total +  this.incoCharges.pickupCharges ;
        Total = Total +  this.incoCharges.reeferPluginCharges ;
        Total = Total +  this.incoCharges.tarpaulinCharges ;
        Total = Total +  this.incoCharges.truckidlingCharges ;
        Total = Total +  this.incoCharges.vGM ;
        this.incoCharges.total = parseInt(Total);
        this.incoTotal = parseInt(Total);
    }
    updateShippingTotal(){
        let Total = 0 ;
        Total = Total + this.shipp.BAF;
        Total = Total +   this.shipp.BunkerSurcharge;
        Total = Total +   this.shipp.ISPS;
        Total = Total +   this.shipp.OTHC;
        Total = Total +   this.shipp.CMC;
        Total = Total +   this.shipp.EIC;
        Total = Total +   this.shipp.sealCharges;
        Total = Total +   this.shipp.DTHC;
        Total = Total +   this.shipp.carriageCongestionSurcharg;
        Total = Total +   this.shipp.carrierSecurityFees;
        Total = Total +   this.shipp.cleaningCharges;
        Total = Total +   this.shipp.DGSurcharge;
        Total = Total +   this.shipp.inlandFuelSurcharge;
        Total = Total +   this.shipp.inlandHandlingFees;
        Total = Total +   this.shipp.inlandhaulage;
        Total = Total +   this.shipp.lowSulphurSurcharge;
        Total = Total +   this.shipp.operationalRecoverySurcharge;
        Total = Total +   this.shipp.overweightsurcharge;
        Total = Total +   this.shipp.warRiskSurcharge;

        this.shipp.total = parseInt( Total);
        this.shippTotal = parseInt(Total)

    }
    getRouteEquipType(){
        getRouteEquipType({routeId : this.routeId})
        .then(result =>{
            //console.log('getRouteEquipType '+JSON.stringify(result,null,2));
            let temp = [];
            let tempList =[];
            this.contrIndex = 0;
            result.forEach(element => {
                temp.push({
                    label : element.Equipment_Type__r.Name,
                    value:element.Equipment_Type__c
                })
                let obj={
                    'index':this.contrIndex++,
                    'containerType':element.Equipment_Type__c,
                    'containerTypeName':element.Equipment_Type__r.Name,
                    'containerTypeErrorClass':'',
                    'containerQuantityErrorClass':'',
                    'id':element.Id,
                    'quantity':element.Quantity__c
                }
                tempList.push(obj);
            });
            this.pickListvalues = temp;
            this.equipmentType = this.pickListvalues[0].value;
            this.containerRecord = tempList;
            if(this.containerRecord.length > 0) this.noRecord = false 
            else this.noRecord = true 
        })
        .catch(error =>{
            console.log('get equip Error '+JSON.stringify(error))
        })
    }
    /*handleEquipSelection(e){
        this.equipmentType = e.detail.value;
        this.equipmentTypeError = '';
    }*/
    handleEquipChange(e){
        this.equipmentTypeError = '';
        this.equipmentTypeErrorMsg = '';
        this.elem1Label = '';
        this.elem2Label = '';
        this.elem1Value = null;
        this.elem2Value = null;
        this.rmsDetail.elem1Value = null;
        this.rmsDetail.elem2Value = null;
        let selectedEquip = e.detail;
        if(selectedEquip.length > 0){
            this.elem1Label = selectedEquip[0].label +' Sea Freight';
            this.displayElem1 = true;
            if(selectedEquip.length > 2){
                this.twoEquipSelected = true;
                this.equipmentTypeError = 'slds-has-error';
                this.equipmentTypeErrorMsg = 'Max 2 can be selected at a time.';
                this.displayShippingCharge = false;
                this.displayOriginCharge = false;
                this.displayDestinCharge = false;
                this.elem2Label = selectedEquip[1].label +' Sea Freight';
                this.displayElem2 = true;
            }
            else if(selectedEquip.length == 2){
                this.twoEquipSelected = true;
                this.displayShippingCharge = false;
                this.displayOriginCharge = false;
                this.displayDestinCharge = false;
                this.elem2Label = selectedEquip[1].label+' Sea Freight';
                this.displayElem2 = true;
            }
            else{
                this.displayElem2 = false;
                this.elem2Label = '';
                this.twoEquipSelected = false;
                this.displayShippingCharge = true;
                this.displayOriginCharge = true;
                this.displayDestinCharge = true;
            }
        }
        else{
            this.displayElem2 = false;
            this.elem2Label = '';
            this.displayElem1 = false;
            this.elem1Label = '';
            this.displayShippingCharge = true;
            this.displayOriginCharge = true;
            this.displayDestinCharge = true;
            this.twoEquipSelected = false;
        }
        this.selectedEquip = selectedEquip;
        this.rmsDetail.selectedEquip = selectedEquip;
        this.rmsDetail.twoEquipSelected = this.twoEquipSelected;
    }
    handleDirectionChange(event){
        this.directionValue  = event.target.value;
        if(!this.isAir )this.getLoadingCharges();
    }
    getLoadingCharges(){
        if(this.pickupPlace != undefined && this.portLoadingId != undefined && this.directionValue != undefined){
            getLoadingCharges({
                pickupPlace:this.pickupPlace,
                portLoading:this.portLoadingId,
                directionValue:this.directionValue
            })
            .then(result =>{
               console.log('result '+JSON.stringify(result));
               this.incoCharges.loadingCharge = result[0].Loading_Charge__c;
               //this.loadingCharge = result[0].Loading_Charge__c;
               this.incoCharges.loadingChargeId = result[0].Id;
               this.updaTeIncoChargeTotal();
            })
            .catch(error =>{
                console.log('get equip Error '+JSON.stringify(error))
            })
        }
    }
    handleDestinbayanChargesChange(e){
        this.destinCharges.bayanCharges = parseInt(e.target.value);
        this.updaTeDetinChargesChargeTotal();
    }
    handleDestincustomClearanceChange(e){
        this.destinCharges.customClearance = parseInt(e.target.value);
        this.updaTeDetinChargesChargeTotal();
    }
    handleDestindoChargesChange(e){
        this.destinCharges.doCharges = parseInt(e.target.value);
        this.updaTeDetinChargesChargeTotal();
    }
    /*handleDestinDTHCChange(e){
        this.destinCharges.DTHC = parseInt(e.target.value);
        this.updaTeDetinChargesChargeTotal();
    }*/
    handleDestinfasahChargesChange(e){
        this.destinCharges.fasahCharges = parseInt(e.target.value);
        this.updaTeDetinChargesChargeTotal();
    }
    handleDestingatePassChargesChange(e){
        this.destinCharges.gatePassCharges = parseInt(e.target.value);
        this.updaTeDetinChargesChargeTotal();
    }
    handleDestinLOLOChargesChange(e){
        this.destinCharges.LOLOCharges = parseInt(e.target.value);
        this.updaTeDetinChargesChargeTotal();
    }
    handleDestintransportationChange(e){
        this.destinCharges.transportation = parseInt(e.target.value);
        this.updaTeDetinChargesChargeTotal();
    }
    handleDestitotalChange(e){
        this.destinCharges.total = parseInt(e.target.value);
        if(!isNaN(this.destinCharges.total)) this.destinTotalChanged = true;
        else this.destinTotalChanged =false;
    }
    updaTeDetinChargesChargeTotal(){
        let Total = 0;
        Total = Total + (this.destinCharges.transportation != null ? this.destinCharges.transportation : 0);
        Total = Total + (this.destinCharges.LOLOCharges != null ? this.destinCharges.LOLOCharges : 0)
        Total = Total + (this.destinCharges.gatePassCharges != null ? this.destinCharges.gatePassCharges : 0)
        Total = Total + (this.destinCharges.fasahCharges != null ? this.destinCharges.fasahCharges : 0)
        Total = Total + (this.destinCharges.doCharges != null ? this.destinCharges.doCharges : 0)
        Total = Total + (this.destinCharges.customClearance != null ? this.destinCharges.customClearance : 0)
        Total = Total + (this.destinCharges.bayanCharges != null ? this.destinCharges.bayanCharges : 0)
        this.destinCharges.total = parseInt( Total);

        console.log('this.destinCharges '+JSON.stringify(this.destinCharges,null,2))
    }
    getExchangeRate(){
        getExchangeRate()
        .then(result=>{
            let templist = [];
            //console.log('getExchangeRate res',JSON.stringify(result,null,2))
            if(result != null){
                result.forEach(elem => {
                    templist.push({
                        label:elem.Currency_Code__c,
                        value:elem.Currency_Code__c,
                        exchangeRate:elem.Final_Rate__c,
                        offSet:elem.Offset_Value__c != undefined ? elem.Offset_Value__c : 0
                    })
                });
            }
            this.curencyCodeOption = templist;
        })
        .catch(error=>{
            console.log('getExchangeRate err',JSON.stringify(error,null,2))
        })
    }
    handleAgentSelection(e){
        this.rmsDetail.agentName = e.detail.Id;
    }
    handleAgentRemoved(e){
        this.rmsDetail.agentName = '';
    }
    handlecarriageCongestionSurchargChange(e){
        this.shipp.carriageCongestionSurcharg = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handlewarRiskSurchargeChange(e){
        this.shipp.warRiskSurcharge = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handlecarrierSecurityFeesChange(e){
        this.shipp.carrierSecurityFees = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handleDGSurchargehange(e){
        this.shipp.DGSurcharge = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handleinlandFuelSurchargeChange(e){
        this.shipp.inlandFuelSurcharge = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handleinlandHandlingFeesChange(e){
        this.shipp.inlandHandlingFees = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handleinlandhaulageChange(e){
        this.shipp.inlandhaulage = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handleLSSChange(e){
        this.shipp.lowSulphurSurcharge = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handleORSChange(e){
        this.shipp.operationalRecoverySurcharge = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handleoverweightsurchargeChange(e){
        this.shipp.overweightsurcharge = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handlecleaningChargesChange(e){
        this.shipp.cleaningCharges = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handlebLFeesChange(e){
        this.incoCharges.bLFees = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handleexportServiceFeesChange(e){
        this.incoCharges.exportServiceFees = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handlefuelSurchargeChange(e){
        this.incoCharges.fuelSurcharge = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handleinsuranceChargesChange(e){
        this.incoCharges.insuranceCharges = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handlelashingChargesChange(e){
        this.incoCharges.lashingCharges = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handleoriginDetentionDemurrageChargesChange(e){
        this.incoCharges.originDetentionDemurrageCharges = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handleOTHChange(e){
        this.incoCharges.OTHC = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handlepickupChargesChange(e){
        this.incoCharges.pickupCharges = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handlereeferPluginChargesChange(e){
        this.incoCharges.reeferPluginCharges = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handletarpaulinChargesChange(e){
        this.incoCharges.tarpaulinCharges = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handletruckidlingChargesChange(e){
        this.incoCharges.truckidlingCharges = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handlevGMChange(e){
        this.incoCharges.vGM = parseInt(e.target.value);
        this.updaTeIncoChargeTotal();
    }
    handleCommoditySelection(e){
        this.rmsDetail.commodity =e.detail.Id
        this.commodityError = '';
    }
    handleCommodityRemoved(e){
        this.rmsDetail.commodity = ''
    }
    handleIncoTermSelection(e){
        this.rmsDetail.incoTermId =e.detail.Id
        this.incoTermError = '';
    }
    handleIncoRemoved(e){
        this.rmsDetail.incoTermId = ''
    }
    getDefualtValueForRMS(){
        this.isLoading =true;
        let rmsDetail = {
            'rateType':'',
            'validity':'',
            'businessType':this.businessType,
            'seaFreight':0,
            'allInRate':false,
            'FOBAllIn':false,
            'ExWorksIn':false,
            'oceanfreightCheckbox':false,
            'remarks':'',
            'agentName':'',
            'incoTermId':'',
            'customerId':'',
            'commodity':'',
            'selectedEquip':[],
            'elem1Value':null,
            'elem2Value':null,
            'twoEquipSelected':false,
            'contractNumber':null,
        }
        this.rmsDetail = rmsDetail;
        this.todaysDate = new Date().toISOString();
        this.validity = this.formatDate(this.todaysDate,0)
        this.rmsDetail.validity = this.validity;
        if(this.cameFromImport == 'true'){
            this.agentName = this.agentObject.Name;
            this.rmsDetail.agentName = this.agentObject.Id;
            this.getDefaultImportAddRate();
        }
        getDefualtValueForRMS()
        .then(result=>{
            console.log('getDefualtValueForRMS result',JSON.stringify(result))
            if(result != null){
                if(result.commodityId != undefined){
                    let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[0];
                    let Obj={Id:result.commodityId,Name:result.commodityName}
                    field.handleDefaultSelected(Obj);
                }
                if(this.airExport ){
                    if(result.airIncoId != undefined){
                        let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[1];
                        let Obj={Id:result.airIncoId,Name:result.airincoTermName}
                        field.handleDefaultSelected(Obj);
                    }
                }else{
                    if(result.incoTermId != undefined && this.cameFromImport != 'true'){
                        let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[1];
                        let Obj={Id:result.incoTermId,Name:result.incoTermName}
                        field.handleDefaultSelected(Obj);
                    }
                }
            }
            this.isLoading = false
        })
        .catch(error=>{
            this.isLoading = false
            console.log('getDefualtValueForRMS error',JSON.stringify(error))
        })
    }
    getDefaultImportAddRate(){
        getDefaultImportAddRate({routeId : this.routeId})
        .then(result=>{
            console.log('getDefaultImportAddRate result',JSON.stringify(result))
            if(result != null){
                if(result.incoTermId != undefined){
                    let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[1];
                    let Obj={Id:result.incoTermId,Name:result.incoTermName}
                    field.handleDefaultSelected(Obj);
                }
            }
        })
        .catch(error=>{
            console.log('getDefaultImportAddRate error',JSON.stringify(error))
        })
    }
    handleAddRouteEuip(){
        this.displayAddRouteEquip = true;
    }
    hideModalBox(){
        this.getRouteEquipType();
        this.displayAddRouteEquip = false;
    }
    hideAddRoute(){
        let allValid = true;
        console.log('toDelete '+JSON.stringify(this.toDeleteRecord,null,2));
        console.log('containerRecord '+JSON.stringify(this.containerRecord,null,2));
        if(this.containerRecord.length > 0){
            this.containerRecord.forEach(elem2=>{
                if(elem2.containerType == '' ){
                    elem2.containerTypeErrorClass = 'slds-has-error';
                    allValid = false
                }
                if(elem2.quantity <= 0){
                    elem2.containerQuantityErrorClass = 'slds-has-error';
                    allValid = false
                }
            })
        }
        else{
            allValid = false
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Please add route equipment.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        }
        if(allValid){
            addRouteEquipment({
                containerList : this.containerRecord,
                toDeleteRecord : this.toDeleteRecord,
                routeId : this.routeId
            })
            .then(result=>{
                console.log('addRouteEquipment result '+result)
                this.getRouteEquipType();
                this.displayAddRouteEquip = false;
            })
            .catch(error=>{
                console.log('addRouteEquipment error '+JSON.stringify(error,null,2))
            })
        }
    }
    handleContainerTypeSelection(e){
        let dto = JSON.parse(JSON.stringify(e.detail.dto))
        let index = this.containerRecord.findIndex(x=>x.index == dto.index)
        if(index != -1){
            this.containerRecord[index].containerType = dto.containerTypeID
            this.containerRecord[index].containerTypeName = dto.containerTypeName
        }
    }
    handleQuantityChange(e){
        let dto = JSON.parse(JSON.stringify(e.detail.dto))
        let index = this.containerRecord.findIndex(x=>x.index == dto.index)
        if(index != -1){
            this.containerRecord[index].quantity = dto.quantity
        }
    }
    handleRemoveContainer(e){
        let index = JSON.parse(JSON.stringify(e.detail))
        let removeIndex = this.containerRecord.findIndex(x=>x.index == index)
        if(index != -1){
            if(this.containerRecord[removeIndex].id != ''){
                this.toDeleteRecord.push(this.containerRecord[removeIndex].id);
            }
            this.containerRecord.splice(removeIndex,1)
            if(this.containerRecord.length == 0) this.noRecord = true
        }
    }
    handleAddRouteClicked(){
        let tempList = JSON.parse(JSON.stringify(this.containerRecord))
        let obj={
            'index':this.contrIndex++,
            'containerType':'',
            'containerTypeName':'',
            'containerTypeErrorClass':'',
            'containerQuantityErrorClass':'',
            'quantity':null,
            'id':''
        }
        tempList.push(obj);
        this.containerRecord = JSON.parse(JSON.stringify(tempList));
        this.noRecord = false
    }
    handleCustomerChange(e){
        this.customerId = e.target.value;
        this.rmsDetail.customerId = this.customerId;
    }
    handlecontractNumberChange(e){
        this.contractNumber = e.target.value;
        this.rmsDetail.contractNumber = this.contractNumber
    }
    handleElem2SeaFreightChange(e){
        if(e.target.value != '') this.elem2Value = parseInt(e.target.value);
       else this.elem2Value = 0;
       this.rmsDetail.elem2Value = this.elem2Value;
       this.elem2seaFreightError ='';
       let equipName = this.elem2Label.split(' ')[0];
       let index = this.selectedEquip.findIndex(x=>x.label == equipName);
       if(index != -1){
           this.selectedEquip[index].seaFreight = this.elem2Value;
           this.rmsDetail.selectedEquip = this.selectedEquip;
       }
   }
   handleElem1SeaFreightChange(e){
       if(e.target.value != '') this.elem1Value = parseInt(e.target.value);
       else this.elem1Value = 0;
       this.rmsDetail.elem1Value = this.elem1Value;
       this.elem1seaFreightError ='';
       let equipName = this.elem1Label.split(' ')[0];
       let index = this.selectedEquip.findIndex(x=>x.label == equipName);
       if(index != -1){
           this.selectedEquip[index].seaFreight = this.elem1Value;
           this.rmsDetail.selectedEquip = this.selectedEquip;
       }
   }   
   handleRateKgsChange(e){
    this.rateKgs = e.target.value;
    this.rateKgsError = '';
   } 
   getAirRouteEquipment(){
    getAirRouteEquipment({routeId:this.routeId})
    .then(result=>{
        console.log('getAirRouteEquipment result = >'+JSON.stringify(result))
        let tempList =[];
        /*result.forEach(element => {
            tempList.push({
            label : element.Tab_View__c,
            value:element.Id
            })
        })*/
        let totalGross = 0;
        let totalCBM = 0;
        let totalVolumeWeigh = 0;
        if(result.Total_Gross_Weight_KGs__c > 0 ) totalGross = result.Total_Gross_Weight_KGs__c;
        if(result.Total_CBM__c > 0 ) totalCBM = result.Total_CBM__c;
        if(result.Total_Volumetric_Weight__c > 0 ) totalVolumeWeigh = result.Total_Volumetric_Weight__c;
        let label = 'Total Volumetric Weight : '+totalCBM+' | Total Gross Weight :'+totalGross+' | Total Volumetric Weight :'+totalVolumeWeigh;
        tempList.push({
            label : label,
            value:result.Id
        })
        this.airTabViewList = tempList;
        this.selectedRouteEquip = tempList[0].value;
    })
    .catch(error=>{
        console.log('getAirRouteEquipment result = >'+JSON.stringify(error))
    })
   }
   handleAirEquipChange(e){
    this.selectedRouteEquip = e.target.value;
    this.airequipmentTypeError= '';
   }
   handleRMSCurrencyCodeSelection(e){
    this.rmscurrencyCode=e.target.value;
    console.log(e.target.value)
    this.handleShippCurrencyCodeSelection(e.target.value);
    this.handleINCOCurrencyCodeSelection(e.target.value);
    this.handleDestinCurrencyCodeSelection(e.target.value)
   }
}