import { LightningElement,track,wire,api } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import DIRECTION_FIELD from '@salesforce/schema/Loading_Charge__c.Direction__c';
import RATE_TYPE_FIELD from '@salesforce/schema/RMS__c.Rate_Type__c';
import BUSINESS_TYPE_FIELD from '@salesforce/schema/RMS__c.Business_Type__c';
import submitRMS from '@salesforce/apex/BAFCOLeadDetailsController.submitRMS';
import getExchangeRate from '@salesforce/apex/BAFCOLRoutingDetailsController.getExchangeRate';
import getDefualtValueForRMS from '@salesforce/apex/BAFCOLRoutingDetailsController.getDefualtValueForRMS';
import copyExistingRMS from '@salesforce/apex/BAFCOLRoutingDetailsController.copyExistingRMS';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class BAFCORMSIntakeForm extends LightningElement {
    @api copyRmsId = '';
    @track shippTotalChanged = false; 
    @track shipp = {};
    @track incoCharges ={};
    @track DirectionOptions = [];
    @track directionValue = 'One Way';
    @track rateTypeOption = [];
    @track rateType = '';    
    @track rmsDetail ={};
    @track validity ='';
    @track seaFreight;
    @track businessTypeOption = [];
    @track businessType = '';
    @track incoChargeTotalChange = false;
    @track shippTotal = 0;
    @track incoTotal = 0;
    @track curencyCodeOption = [];
    @track allInRate = false;
    @track FOBAllIn = false;
    @track ExWorksIn = false;
    @track displayOriginCharge = true;
    @track displayShippingCharge = true;
    @track displayDestinCharge = true;
    @track FreeTime;
    @track FreeTimePOD;
    @track remarks = '';
    @track destinCharges ={};
    @track destinOffSet = 0;
    @track destinExchangeRate = 0;
    @track incoExchangeRate = 0;
    @track incoOffSet = 0;
    @track shippExchangeRate = 0;
    @track shippOffSet = 0;
    @track todaysDate = '';
    @track destinTotalChanged = false;
    @track disableShippOffSet = true;
    @track disableIncoOffSet = true;
    @track disableDestinOffSet = true;
    @track isLoading = false;
    @track displayAgentField = false;
    @track equipmentTypeOption =[];
    @track equipmentType = '';
    @track oceanfreightCheckbox = false;


    @track loadingPortError = '';
    @track loadingDischargeError = '';
    @track commodityError = '';
    @track shippingLineError = '';
    @track incoTermError = '';
    @track equipmentTypeError = '';
    @track equipmentTypeErrorMsg = '';
    @track rateTypeError = '';
    @track validityError = '';
    //@track seaFreightError = '';
    @track businessTypeError = '';
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
                console.log(` DIRECTION_FIELD values are `, data.values);
                this.DirectionOptions = data.values;
                this.directionValue = this.DirectionOptions[0].value;
                //this.getLoadingCharges();
                this.error = undefined;
            }
            if(error){
                console.log(` Error while fetching DIRECTION_FIELD Picklist values  ${error}`);
                this.error = error;
                this.DirectionOptions = undefined;
            }
    }
    @wire(getPicklistValues, {
        recordTypeId : '012000000000000AAA',
        fieldApiName : RATE_TYPE_FIELD
    })rateTypePropertyValue({ data, error }){
            if(data){
                console.log(`  rate type option `, data.values);
                this.rateTypeOption = data.values;
            }
            if(error){
                console.log(` Error while fetching Picklist values  ${error}`);
                this.rateTypeOption = undefined;
            }
    }

    @wire(getPicklistValues, {
        recordTypeId : '012000000000000AAA',
        fieldApiName : BUSINESS_TYPE_FIELD
    })wiredPickListValue({ data, error }){
            if(data){
                console.log(` Picklist values are `, data.values);
                this.businessTypeOption = data.values;
            }
            if(error){
                console.log(` Error while fetching Picklist values  ${error}`);
                this.businessTypeOption = undefined;
            }
    }

    closeModal(){
        this.dispatchEvent(new CustomEvent('close'));
    }
    connectedCallback(){
        this.getExchangeRate();
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
            'warRiskSurcharge':null
        }
        this.shipp = templist;

        let tempList2 = {             
            'bayan' : null,                
            'destinationCustomsClearance' : null, 
            'destinationLoadingCharges' : null,
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
            'lashingCharges':null        
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
            'currencyCode':'USD'
        }
        this.destinCharges = templist3;
        this.todaysDate = new Date().toISOString();
        if(this.copyRmsId != '') {
            let rmsDetail = {
                'rateType':'',
                'validity':'',
                'seaFreight':null,
                'loadingPortId':'',
                'loadingDestinationId':'',
                'commodityName':'',
                'shippingLineId':'',
                'equipmentId':'',
                'agentName':'',
                'businessType':this.businessType,
                'loadingPortName':'',
                'loadingDestinationName':'',
                'allInRate':false,
                'FOBAllIn':false,
                'ExWorksIn':false,
                'FreeTime':null,
                'FreeTimePOD':null,
                'remarks':'',
                'currencyCode':'',
                'customerName':'',
                'incoTermId':null,
                'oceanfreightCheckbox':false,
                'selectedEquip':[],
                'elem1Value':null,
                'elem2Value':null,
                'twoEquipSelected':false,
                'contractNumber':null,

            }
            this.rmsDetail = rmsDetail;
            setTimeout(() => {
                this.isLoading = true;
                this.handleCopyExistingRms();
            }, 500);
        }
        else{
            this.getDefualtValueForRMS();
        }
        
    }
    getDefualtValueForRMS(){
        this.isLoading = true
        getDefualtValueForRMS()
        .then(result=>{
            console.log('getDefualtValueForRMS result',JSON.stringify(result))
            if(result != null){
                if(result.commodityId != undefined){
                    let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[2];
                    let Obj={Id:result.commodityId,Name:result.commodityName}
                    setTimeout(() => {
                        field.handleDefaultSelected(Obj);
                    }, 100);
                    
                }
                if(result.businessType != undefined){
                    this.businessType = result.businessType != null ? result.businessType : '';
                    if(this.businessType == 'Import') this.displayAgentField = true;
                    else {
                        this.displayAgentField = false;
                        if(result.incoTermId != undefined && this.businessType == 'Export'){
                            let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[4];
                            let Obj={Id:result.incoTermId,Name:result.incoTermName}
                            setTimeout(() => {
                                field.handleDefaultSelected(Obj);
                            }, 100);
                        }
                        
                    }
                }
                if(result.polId != undefined){
                    if(result.polId != null){
                        let Obj={Id:result.polId,Name:result.polName}
                        let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[0];
                        if(result.businessType == 'Export') {
                            setTimeout(() => {
                                field.handleDefaultSelected(Obj);
                            }, 100);
                        }
                        let field2 = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[1];
                        if(result.businessType =='Import') {
                            setTimeout(() => {
                                field2.handleDefaultSelected(Obj);
                            }, 100);
                        }
                    }
                }
                if(result.equipmentList != null){
                    let templist = [];
                    result.equipmentList.forEach(elem=>{
                        templist.push({
                            label:elem.Name,
                            value:elem.Id
                        })
                    })
                    this.equipmentTypeOption = templist
                }
                let rmsDetail = {
                    'rateType':'',
                    'validity':'',
                    'seaFreight':null,
                    'loadingPortId':'',
                    'loadingDestinationId':'',
                    'commodityName':'',
                    'shippingLineId':'',
                    'equipmentId':'',
                    'agentName':'',
                    'businessType':this.businessType,
                    'loadingPortName':'',
                    'loadingDestinationName':'',
                    'allInRate':false,
                    'FOBAllIn':false,
                    'ExWorksIn':false,
                    'FreeTime':null,
                    'FreeTimePOD':null,
                    'remarks':'',
                    'currencyCode':'',
                    'customerName':'',
                    'incoTermId':null,
                    'oceanfreightCheckbox':false,
                    'selectedEquip':[],
                    'elem1Value':null,
                    'elem2Value':null,
                    'twoEquipSelected':false,
                    'contractNumber':null
                }
                this.rmsDetail = rmsDetail;
                this.validity = this.formatDate(this.todaysDate,0)
                this.rmsDetail.validity = this.validity;
                let index = this.equipmentTypeOption.findIndex((x) => x.label =='40HC')
                this.rmsDetail.equipmentId = this.equipmentTypeOption[index].value
                this.equipmentType = this.equipmentTypeOption[index].value;
                if(result.businessType == 'Export') {
                    this.rmsDetail.loadingPortId = result.polId != undefined ? result.polId : null;
                    this.rmsDetail.loadingPortName = result.polId != undefined ? result.polName : null;
                }
                if(result.businessType =='Import'){
                    this.rmsDetail.loadingDestinationId = result.polId != undefined ? result.polId : null;
                    this.rmsDetail.loadingDestinationName = result.polId != undefined ? result.polName : null;
                }
                this.isLoading = false
            }
        })
        .catch(error=>{
            this.isLoading = false
            console.log('getDefualtValueForRMS error',JSON.stringify(error))
        })
    }
    handleFreeTimeChange(e){
        this.FreeTime = e.target.value
        this.rmsDetail.FreeTime = this.FreeTime
    }
    handleFreeTimePODChange(e){
        this.FreeTimePOD = e.target.value
        this.rmsDetail.FreeTimePOD = this.FreeTimePOD
    }
    handleBusinessTypeChange(e){
        this.rmsDetail.businessType = e.target.value;
        if(this.rmsDetail.businessType =='Import') {
            this.displayAgentField = true;
            let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[4];
            field.handleRemovePill();
        }
        else this.displayAgentField = false;
        this.businessTypeError = '';
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
    updateShippingTotal(){
        let Total = 0 ;
        Total = Total + this.shipp.BAF;
        Total = Total +   this.shipp.BunkerSurcharge;
        Total = Total +   this.shipp. ISPS;
        Total = Total +   this.shipp.OTHC;
        Total = Total +   this.shipp.CMC;
        Total = Total +   this.shipp. EIC;
        Total = Total +   this.shipp.sealCharges;
        Total = Total +   this.shipp. DTHC;
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
        this.shippTotal = parseInt(Total);

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
        Total = Total +  this.incoCharges.inspection   ;   
        Total = Total +  this.incoCharges.liftOnLiftOff    ; 
        Total = Total +  this.incoCharges.originCustomsclearance   ;
        Total = Total +  this.incoCharges.originLoadingCharges    ; 
        Total = Total +  this.incoCharges.portShuttling  ;    
        Total = Total +   this.incoCharges.tabadul  ;  
        Total = Total +  this.incoCharges.xray ;
        Total = Total +  this.incoCharges.loadingCharge ;
        Total = Total +  this.incoCharges.bLFees ;
        Total = Total +  this.incoCharges.exportServiceFees ;
        Total = Total +  this.incoCharges.insuranceCharges ;
        Total = Total +  this.incoCharges.lashingCharges ;
        Total = Total +  this.incoCharges.originDetentionDemurrageCharges ;
        Total = Total +  this.incoCharges.OTHC ;
        Total = Total + this.incoCharges.fuelSurcharge;
        Total = Total +  this.incoCharges.pickupCharges ;
        Total = Total +  this.incoCharges.reeferPluginCharges ;
        Total = Total +  this.incoCharges.tarpaulinCharges ;
        Total = Total +  this.incoCharges.truckidlingCharges ;
        Total = Total +  this.incoCharges.vGM ;
        this.incoCharges.total = parseInt(Total);
        this.incoTotal = parseInt(Total);
    }
    submitDetails(){
        this.isLoading = true;
        let allValid = true;
        console.log('rms '+JSON.stringify(this.rmsDetail,null,2))
        console.log('selected '+JSON.stringify(this.selectedEquip,null,2));
        if(this.rmsDetail.loadingPortId == ''){
            allValid = false;
            this.loadingPortError = 'slds-has-error';
        }
        if(this.rmsDetail.loadingDestinationId == ''){
            allValid = false;
            this.loadingDischargeError = 'slds-has-error';
        }
        if(this.rmsDetail.commodityName == ''){
            allValid = false;
            this.commodityError = 'slds-has-error';
        }
        if(this.rmsDetail.shippingLineId == ''){
            allValid = false;
            this.shippingLineError = 'slds-has-error';
        }
        if(this.rmsDetail.incoTermId == ''){
            allValid = false;
            this.incoTermError = 'slds-has-error';
        }
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
        if(this.rmsDetail.rateType == ''){
            allValid = false;
            this.rateTypeError = 'slds-has-error';
        }
        if(this.rmsDetail.validity == null){
            allValid = false;
            this.validityError = 'slds-has-error';
        }
        /*if(this.rmsDetail.seaFreight <= 0){
            allValid = false;
            this.seaFreightError = 'slds-has-error';
        }*/
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
        if(this.rmsDetail.businessType == ''){
            allValid = false;
            this.businessTypeError = 'slds-has-error';
        }
        if(allValid){
            submitRMS({
                rmsDetail : this.rmsDetail,
                shippingChargeDto : this.shipp,
                incocharges : this.incoCharges,
                totalShippChanged : this.shippTotalChanged,
                totalIncoChanged : this.incoChargeTotalChange,
                destinTotalChanged : this.destinTotalChanged,
                destinCharges:this.destinCharges,
                selectedEquip:this.selectedEquip
            })
            .then(result =>{
                console.log('submitRMS result',JSON.stringify(result));
                this.isLoading = false;
            let disPatchObj = {
                    loadingPort : result.loadingPortName,
                    loadingDestination : result.loadingDestinationName,
                    validity : result.validity,
                    loadingPortId:result.loadingPortId,
                    loadingDestinationId : result.loadingDestinationId
                }
                const selectedEvent = new CustomEvent('success', { detail: {disPatchObj}});
                this.dispatchEvent(selectedEvent);

            })
            .catch(error=>{
                console.log('submitRMS ',JSON.stringify(error,null,2))
                this.isLoading = false;
                let err = error.body.pageErrors[0].message
                const evt = new ShowToastEvent({
                    title: 'Missing Field :',
                    message: err,
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            })
        }
        else{
            this.isLoading = false;
        }
    }
    handletotalChange(e){
        this.incoCharges.total = parseInt(e.target.value);
        if(!isNaN(this.incoCharges.total)) this.incoChargeTotalChange = true;
        else this.incoChargeTotalChange = false;
    }
    handleDirectionChange(event){
        this.directionValue  = event.target.value;
        //this.getLoadingCharges();
    }
    handleValidityChange(e){
        this.validity = e.target.value;
        this.rmsDetail.validity = this.validity;
        this.validityError = '';
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
       /* if(e.target.value != '') this.seaFreight = parseInt(e.target.value);
        else this.seaFreight = 0;
        this.rmsDetail.seaFreight = this.seaFreight;
        this.seaFreightError ='';*/
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
    handlePortSelection(e){
        this.rmsDetail.loadingPortId = e.detail.Id;
        this.rmsDetail.loadingPortName = e.detail.Name;
        this.loadingPortError = '';
    }
    handlePortRemoved(e){
        this.rmsDetail.loadingPortId = '';
        this.rmsDetail.loadingPortName = '';
    }
    handleDestinationSelection(e){
        this.rmsDetail.loadingDestinationId = e.detail.Id;
        this.rmsDetail.loadingDestinationName = e.detail.Name;
        this.loadingDischargeError = '';
    }
    handleDestinationRemoved(e){
        this.rmsDetail.loadingDestinationId = '';
        this.rmsDetail.loadingDestinationName = '';
    }
    handleCommoditySelection(e){
        this.rmsDetail.commodityName = e.detail.Id;
        this.commodityError = '';
    }
    handleCommodityRemoved(e){
        this.rmsDetail.commodityName = '';
    }
    handleShippingLineSelection(e){
        this.rmsDetail.shippingLineId = e.detail.Id;
        this.shippingLineError = '';
    }
    handleShippingRemoved(e){
        this.rmsDetail.shippingLineId = '';
    }
    handleEquipmentSelection(e){
        this.rmsDetail.equipmentId = e.detail.Id;
    }
    handleEquipmentChange(e){
        this.rmsDetail.equipmentId = e.target.value;
        this.equipmentType = e.target.value;
        this.equipmentTypeError = '';
        this.equipmentTypeErrorMsg = ''
    }
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
    handleEquipmentRemoved(e){
        this.rmsDetail.equipmentId = '';
    }
    handlecontractNumberChange(e){
        this.contractNumber = e.target.value;
        this.rmsDetail.contractNumber = this.contractNumber
    }
    handleAgentSelection(e){
        this.rmsDetail.agentName = e.detail.Id;
    }
    handleAgentRemoved(e){
        this.rmsDetail.agentName = '';
    }
    getExchangeRate(){
        getExchangeRate()
        .then(result=>{
            let templist = [];
            console.log('getExchangeRate res',JSON.stringify(result,null,2))
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
            this.shipp.currencyCode = 'USD';
            this.incoCharges.currencyCode = 'USD';
            this.destinCharges.currencyCode = 'USD';
        })
        .catch(error=>{
            console.log('getExchangeRate err',JSON.stringify(error,null,2))
        })
    }
    handleAllInRateChange(e){
        this.FOBAllIn = false;
        this.ExWorksIn = false;
        this.oceanfreightCheckbox = false
        this.allInRate = e.target.checked;
        this.updateRMSCheckBox();
    }
    handleFOBAllInChange(e){
        this.allInRate = false;
        this.ExWorksIn = false;
        this.oceanfreightCheckbox = false
        this.FOBAllIn = e.target.checked;
        this.updateRMSCheckBox();
    }
    handleoceanfreightCheckboxChange(e){
        this.oceanfreightCheckbox = e.target.checked;
        this.allInRate = false;
        this.ExWorksIn = false;
        this.FOBAllIn = false;
        console.log('this.oceanfreightCheckbox '+this.oceanfreightCheckbox)
        this.updateRMSCheckBox();
    }
    handleExWorksChange(e){
        this.FOBAllIn = false;
        this.allInRate = false;
        this.oceanfreightCheckbox = false
        this.ExWorksIn = e.target.checked;
        this.updateRMSCheckBox();
    }
    updateRMSCheckBox(){
        if(this.allInRate == true){
            this.FOBAllIn = false;
            this.ExWorksIn = false;
            this.oceanfreightCheckbox= false
            this.displayOriginCharge = false;
            this.displayShippingCharge = false;
            this.displayDestinCharge= true;
        }
        else if(this.FOBAllIn == true){
            this.allInRate = false;
            this.ExWorksIn = false;
            this.oceanfreightCheckbox= false
            this.displayShippingCharge = false;
            this.displayOriginCharge = false;
            this.displayDestinCharge= true;
        }
        else if(this.ExWorksIn == true){
            this.FOBAllIn = false;
            this.allInRate = false;
            this.oceanfreightCheckbox= false
            this.displayShippingCharge = false;
            this.displayOriginCharge = false;
            this.displayDestinCharge= true;
        }
        else if(this.oceanfreightCheckbox == true){
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
        console.log('rms  '+JSON.stringify(this.rmsDetail,null,2))
    }
    handleRemarksChange(e){
        this.remarks = e.target.value;
        this.rmsDetail.remarks = this.remarks
    }
    handleDestinCurrencyCodeSelection(e){
        this.destinCharges.currencyCode = e.target.value;
        this.curencyCodeOption.forEach(elem=>{
            if(elem.value == e.target.value){
                this.destinExchangeRate = elem.exchangeRate
                this.destinOffSet = elem.offSet
                this.destinCharges.offSet = elem.offSet;
            }
        })
        if(this.destinCharges.currencyCode == 'USD') {
            this.disableShippOffSet = true;
            this.destinCharges.offSet = 0;
        }
        else{
            this.disableShippOffSet = false;
        }
    }
    handleDestinOffSetChange(e){
        this.destinCharges.offSet = e.target.value;
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
   /* handleDestinDTHCChange(e){
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
       // Total = Total + (this.destinCharges.DTHC != null ? this.destinCharges.DTHC : 0)
        Total = Total + (this.destinCharges.doCharges != null ? this.destinCharges.doCharges : 0)
        Total = Total + (this.destinCharges.customClearance != null ? this.destinCharges.customClearance : 0)
        Total = Total + (this.destinCharges.bayanCharges != null ? this.destinCharges.bayanCharges : 0)
        this.destinCharges.total = parseInt( Total);

        console.log('this.destinCharges '+JSON.stringify(this.destinCharges,null,2))
    }
    handleINCOCurrencyCodeSelection(e){
        this.incoCharges.currencyCode = e.target.value;
        this.curencyCodeOption.forEach(elem=>{
            if(elem.value == e.target.value){
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
    handleShippCurrencyCodeSelection(e){
        this.shipp.currencyCode = e.target.value;
        this.curencyCodeOption.forEach(elem=>{
            if(elem.value == e.target.value){
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
    handleShippOffsetChange(e){
        this.shipp.offSet = e.target.value;
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
    handlecarriageCongestionSurchargChange(e){
        this.shipp.carriageCongestionSurcharg = parseInt(e.target.value);
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
    handlewarRiskSurchargeChange(e){
        this.shipp.warRiskSurcharge = parseInt(e.target.value);
        this.updateShippingTotal();
    }
    handleIncoTermSelection(e){
        this.rmsDetail.incoTermId = e.detail.Id;
        this.incoTermError = '';
    }
    handleIncoRemoved(e){
        this.rmsDetail.incoTermId = '';
    }
    handleCustomerSelection(e){
        this.rmsDetail.customerName = e.detail.Id;
    }
    handleCustomerRemoved(e){
        this.rmsDetail.customerName = '';
    }
    handleCopyExistingRms(){
        copyExistingRMS({rmsId : this.copyRmsId})
        .then(result=>{
            console.log('copyExistingRMS '+JSON.stringify(result,null,2))
            if(result != null){ 
                if(result.equipmentList != null){
                    let templist = [];
                    result.equipmentList.forEach(elem=>{
                        templist.push({
                            label:elem.Name,
                            value:elem.Id
                        })
                    })
                    this.equipmentTypeOption = templist
                }               
                if(result.rmsObj.Commodity__c != undefined){
                    this.rmsDetail.commodityName = result.rmsObj.Commodity__c;
                    let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[2];
                    let Obj={Id:result.rmsObj.Commodity__c,Name:result.rmsObj.Commodity__r.Name}
                    setTimeout(() => {
                        field.handleDefaultSelected(Obj);
                    }, 100);
                    
                }
                if(result.rmsObj.Business_Type__c != undefined){
                    this.businessType = result.rmsObj.Business_Type__c != null ? result.rmsObj.Business_Type__c : '';
                    this.rmsDetail.businessType = this.businessType;
                    if(this.businessType == 'Import') {
                        this.displayAgentField = true;
                        setTimeout(() => {
                            if(result.rmsObj.Agent__c != undefined){
                                if(result.rmsObj.Agent__c != null){
                                    this.rmsDetail.agentName = result.rmsObj.Agent__c;
                                    let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[5];
                                    let Obj={Id:result.rmsObj.Agent__c,Name:result.rmsObj.Agent__r.Name}
                                    setTimeout(() => {
                                        field.handleDefaultSelected(Obj);
                                    }, 100);
                                }
                            }
                        }, 300);
                    }
                    else this.displayAgentField = false;
                }
                if(result.rmsObj.INCO_Term__c != undefined){
                    this.rmsDetail.incoTermId = result.rmsObj.INCO_Term__c;
                    let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[4];
                    let Obj={Id:result.rmsObj.INCO_Term__c,Name:result.rmsObj.INCO_Term__r.Name}
                    setTimeout(() => {
                        field.handleDefaultSelected(Obj);
                    }, 100);
                }
                
                if(result.rmsObj.Port_Of_Loading__c != undefined){
                    if(result.rmsObj.Port_Of_Loading__c != null){
                        this.rmsDetail.loadingPortId = result.rmsObj.Port_Of_Loading__c;
                        let Obj={Id:result.rmsObj.Port_Of_Loading__c,Name:result.rmsObj.Port_Of_Loading__r.Name}
                        let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[0];
                            setTimeout(() => {
                                field.handleDefaultSelected(Obj);
                            }, 100);
                    }
                }
                if(result.rmsObj.Port_Of_Discharge__c != undefined){
                    if(result.rmsObj.Port_Of_Discharge__c != null){
                        this.rmsDetail.loadingDestinationId = result.rmsObj.Port_Of_Discharge__c;
                        let Obj={Id:result.rmsObj.Port_Of_Discharge__c,Name:result.rmsObj.Port_Of_Discharge__r.Name}
                        let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[1];
                            setTimeout(() => {
                                field.handleDefaultSelected(Obj);
                            }, 100);
                    }
                }
                if(result.rmsObj.Shipping_Line__c != undefined){
                    if(result.rmsObj.Shipping_Line__c != null){
                        this.rmsDetail.shippingLineId = result.rmsObj.Shipping_Line__c;
                        let Obj={Id:result.rmsObj.Shipping_Line__c,Name:result.rmsObj.Shipping_Line__r.Name}
                        let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[3];
                            setTimeout(() => {
                                field.handleDefaultSelected(Obj);
                            }, 100);
                    }
                }
                if(result.rmsObj.Equipment_Type__c != undefined){
                    this.equipmentType = result.rmsObj.Equipment_Type__c != null ? result.rmsObj.Equipment_Type__c : null;
                    this.rmsDetail.equipmentId = this.equipmentType;
                }
                if(result.rmsObj.Rate_Type__c != undefined){
                    this.rateType = result.rmsObj.Rate_Type__c != null ? result.rmsObj.Rate_Type__c : null;
                    this.rmsDetail.rateType = this.rateType;
                }
                if(result.rmsObj.Validity__c != undefined){
                    this.validity = result.rmsObj.Validity__c != null ? result.rmsObj.Validity__c : null;
                    this.rmsDetail.validity = this.validity;
                }
                if(result.rmsObj.Sea_Freight__c != undefined){
                    this.seaFreight = result.rmsObj.Sea_Freight__c != null ? result.rmsObj.Sea_Freight__c : null;
                    this.rmsDetail.seaFreight = this.seaFreight;
                }
                if(result.rmsObj.Business_Type__c != undefined){
                    this.businessType = result.rmsObj.Business_Type__c != null ? result.rmsObj.Business_Type__c : null;
                    this.rmsDetail.businessType = this.businessType;
                }
                if(result.rmsObj.Free_time__c != undefined){
                    this.FreeTime = result.rmsObj.Free_time__c != null ? result.rmsObj.Free_time__c : null;
                    this.rmsDetail.FreeTime = this.FreeTime;
                }
                if(result.rmsObj.Free_time_POD__c != undefined){
                    this.FreeTimePOD = result.rmsObj.Free_time_POD__c != null ? result.rmsObj.Free_time_POD__c : null;
                    this.rmsDetail.FreeTime = this.FreeTimePOD;
                }
                if(result.rmsObj.All_in_Rate__c != undefined){
                    this.allInRate = result.rmsObj.All_in_Rate__c;
                    this.rmsDetail.allInRate = this.allInRate;
                }
                if(result.rmsObj.Ex_Works_All_In__c != undefined){
                    this.ExWorksIn = result.rmsObj.Ex_Works_All_In__c;
                    this.rmsDetail.ExWorksIn = this.ExWorksIn;
                }
                if(result.rmsObj.FOB_All_In__c != undefined){
                    this.FOBAllIn = result.rmsObj.FOB_All_In__c;
                    this.rmsDetail.FOBAllIn = this.FOBAllIn;
                }
                this.updateRMSCheckBox();
                if(result.rmsObj.Remarks__c != undefined){
                    this.remarks = result.rmsObj.Remarks__c;
                    this.rmsDetail.remarks = this.remarks;
                }
                if(result.rmsObj.Shipping_Line_Charges__r != undefined && result.rmsObj.Shipping_Line_Charges__r.length > 0){
                    let tempObj = result.rmsObj.Shipping_Line_Charges__r[0];
                    this.shippTotalChanged = result.shippTotalChanged != null ? result.shippTotalChanged : false;
                    if(tempObj.BAF__c != undefined){
                        this.BAF = tempObj.BAF__c > 0 ? tempObj.BAF__c: null;
                        this.shipp.BAF = this.BAF;
                    }
                    if(tempObj.Bunker_surcharge__c != undefined){
                        this.BunkerSurcharge = tempObj.Bunker_surcharge__c > 0 ? tempObj.Bunker_surcharge__c: null;
                        this.shipp.BunkerSurcharge = this.BunkerSurcharge;
                    }
                    if(tempObj.CMC__c != undefined){
                        this.CMC = tempObj.CMC__c > 0 ? tempObj.CMC__c: null;
                        this.shipp.CMC = this.CMC;
                    }
                    if(tempObj.DTHC__c != undefined){
                        this.DTHC = tempObj.DTHC__c > 0 ? tempObj.DTHC__c: null;
                        this.shipp.DTHC = this.DTHC;
                    }
                    if(tempObj.EIC__c != undefined){
                        this.EIC = tempObj.EIC__c > 0 ? tempObj.EIC__c: null;
                        this.shipp.EIC = this.EIC;
                    }
                    if(tempObj.ISPS__c != undefined){
                        this.ISPS = tempObj.ISPS__c > 0 ? tempObj.ISPS__c: null;
                        this.shipp.ISPS = this.ISPS;
                    }
                    if(tempObj.OTHC__c != undefined){
                        this.shipp.OTHC = tempObj.OTHC__c > 0 ? tempObj.OTHC__c: null;
                    }
                    if(tempObj.Seal_Charges__c != undefined){
                        this.sealCharges = tempObj.Seal_Charges__c > 0 ? tempObj.Seal_Charges__c: null;
                        this.shipp.sealCharges = this.sealCharges;
                    }
                    if(tempObj.Carriage_Congestion_Surcharge__c != undefined){
                        this.shipp.carriageCongestionSurcharg = tempObj.Carriage_Congestion_Surcharge__c > 0 ? tempObj.Carriage_Congestion_Surcharge__c: null;
                    }
                    if(tempObj.Carrier_Security_Fees__c != undefined){
                        this.shipp.carrierSecurityFees = tempObj.Carrier_Security_Fees__c > 0 ? tempObj.Carrier_Security_Fees__c: null;
                    }
                    if(tempObj.Cleaning_Charges__c != undefined){
                        this.shipp.cleaningCharges = tempObj.Cleaning_Charges__c > 0 ? tempObj.Cleaning_Charges__c: null;
                    }
                    if(tempObj.DG_Surcharge__c != undefined){
                        this.shipp.DGSurcharge = tempObj.DG_Surcharge__c > 0 ? tempObj.DG_Surcharge__c: null;
                    }
                    if(tempObj.Inland_Handling_Fees__c != undefined){
                        this.shipp.inlandHandlingFees = tempObj.Inland_Handling_Fees__c > 0 ? tempObj.Inland_Handling_Fees__c: null;
                    }
                    if(tempObj.Inland_Fuel_Surcharge__c != undefined){
                        this.shipp.inlandFuelSurcharge = tempObj.Inland_Fuel_Surcharge__c > 0 ? tempObj.Inland_Fuel_Surcharge__c: null;
                    }
                    if(tempObj.Inland_haulage__c != undefined){
                        this.shipp.inlandhaulage = tempObj.Inland_haulage__c > 0 ? tempObj.Inland_haulage__c: null;
                    }
                    if(tempObj.Low_Sulphur_Surcharge__c != undefined){
                        this.shipp.lowSulphurSurcharge = tempObj.Low_Sulphur_Surcharge__c > 0 ? tempObj.Low_Sulphur_Surcharge__c: null;
                    }
                    if(tempObj.Operational_Recovery_Surcharge__c != undefined){
                        this.shipp.operationalRecoverySurcharge = tempObj.Operational_Recovery_Surcharge__c > 0 ? tempObj.Operational_Recovery_Surcharge__c: null;
                    }
                    if(tempObj.Overweight_surcharge__c != undefined){
                        this.shipp.overweightsurcharge = tempObj.Overweight_surcharge__c > 0 ? tempObj.Overweight_surcharge__c: null;
                    }
                    if(tempObj.War_Risk_Surcharge__c != undefined){
                        this.shipp.warRiskSurcharge = tempObj.War_Risk_Surcharge__c > 0 ? tempObj.War_Risk_Surcharge__c: null;
                    }
                    if(tempObj.Total__c != undefined){
                        this.shippTotal = tempObj.Total__c > 0 ? tempObj.Total__c: null;
                    }
                    if(tempObj.CurrencyIsoCode != undefined){
                        this.shipp.currencyCode = tempObj.CurrencyIsoCode;
                        if(this.curencyCodeOption.length > 0){
                            let index = this.curencyCodeOption.findIndex(x=>x.label == tempObj.CurrencyIsoCode);
                            if(index != -1){
                               this.shippExchangeRate = this.curencyCodeOption[index].exchangeRate
                            }
                        }
                        if(this.shipp.currencyCode == 'USD') {
                            this.disableShippOffSet = true;
                            this.shipp.offSet = 0;
                        }
                        else{
                            this.disableShippOffSet = false;
                        }
                    }
                    if(tempObj.Offset_Value__c != undefined){
                        this.shipp.offSet = tempObj.Offset_Value__c > 0 ? tempObj.Offset_Value__c: null;
                    }
                    this.updateShippingTotal();
                }
                if(result.rmsObj.INCO_Charges__r != undefined && result.rmsObj.INCO_Charges__r.length > 0){
                    let tempObj = result.rmsObj.INCO_Charges__r[0];
                    this.incoChargeTotalChange = result.incoChargeTotalChange != null ? result.incoChargeTotalChange : false;
                    if(tempObj.CurrencyIsoCode != undefined){
                        this.incoCharges.currencyCode = tempObj.CurrencyIsoCode;
                        if(this.curencyCodeOption.length > 0){
                            let index = this.curencyCodeOption.findIndex(x=>x.label == tempObj.CurrencyIsoCode);
                            if(index != -1){
                               this.incoExchangeRate = this.curencyCodeOption[index].exchangeRate
                            }
                        }
                        if(this.incoCharges.currencyCode == 'USD') {
                            this.disableIncoOffSet = true;
                            this.incoCharges.offSet = 0;
                        }
                        else{
                            this.disableIncoOffSet = false;
                        }
                    }
                    if(tempObj.Offset_Value__c != undefined){
                        this.incoCharges.offSet = tempObj.Offset_Value__c > 0 ? tempObj.Offset_Value__c: null;
                    }
                    if(tempObj.Bayan__c != undefined){
                        this.bayan = tempObj.Bayan__c > 0 ? tempObj.Bayan__c: null;
                        this.incoCharges.bayan= this.bayan;  
                    }
                    if(tempObj.Fasah_fee__c != undefined){
                        this.fasahFee = tempObj.Fasah_fee__c > 0 ? tempObj.Fasah_fee__c: null;
                        this.incoCharges.fasahFee= this.fasahFee;
                    }
                    if(tempObj.Inspection__c != undefined){
                        this.inspection = tempObj.Inspection__c > 0 ? tempObj.Inspection__c: null;
                        this.incoCharges.inspection= this.inspection;   
                    }
                    if(tempObj.Lift_on_Lift_off__c != undefined){
                        this.liftOnLiftOff = tempObj.Lift_on_Lift_off__c > 0 ? tempObj.Lift_on_Lift_off__c: null;
                        this.incoCharges.liftOnLiftOff= this.liftOnLiftOff;  
                    }
                    if(tempObj.Origin_Customs_clearance__c != undefined){
                        this.originCustomsclearance = tempObj.Origin_Customs_clearance__c > 0 ? tempObj.Origin_Customs_clearance__c: null;
                        this.incoCharges.originCustomsclearance= this.originCustomsclearance; 
                    }
                    if(tempObj.Origin_Loading_Charges__c != undefined){
                        this.originLoadingCharges = tempObj.Origin_Loading_Charges__c > 0 ? tempObj.Origin_Loading_Charges__c: null;
                        this.incoCharges.originLoadingCharges= this.originLoadingCharges;  
                    }
                    if(tempObj.Port_Shuttling__c != undefined){
                        this.portShuttling = tempObj.Port_Shuttling__c > 0 ? tempObj.Port_Shuttling__c: null;
                        this.incoCharges.portShuttling= this.portShuttling; 
                    }
                    if(tempObj.Tabadul__c != undefined){
                        this.tabadul = tempObj.Tabadul__c > 0 ? tempObj.Tabadul__c: null;
                        this.incoCharges.tabadul= this.tabadul;   
                    }
                    if(tempObj.Xray__c != undefined){
                        this.xray = tempObj.Xray__c > 0 ? tempObj.Xray__c: null;
                        this.incoCharges.xray= this.xray; 
                    }
                    if(tempObj.Loading_Charges__c != undefined){
                        this.loadingCharge = tempObj.Loading_Charges__c > 0 ? tempObj.Loading_Charges__c: null;
                        this.incoCharges.loadingCharge= this.loadingCharge;
                    }
                    if(tempObj.BL_Fees__c != undefined){
                        this.bLFees = tempObj.BL_Fees__c > 0 ? tempObj.BL_Fees__c: null;
                        this.incoCharges.bLFees= this.bLFees;
                    }
                    if(tempObj.Export_Service_Fees__c != undefined){
                        this.exportServiceFees = tempObj.Export_Service_Fees__c > 0 ? tempObj.Export_Service_Fees__c: null;
                        this.incoCharges.exportServiceFees= this.exportServiceFees;
                    }
                    if(tempObj.Fuel_Surcharge__c != undefined){
                        this.fuelSurcharge = tempObj.Fuel_Surcharge__c > 0 ? tempObj.Fuel_Surcharge__c: null;
                        this.incoCharges.fuelSurcharge= this.fuelSurcharge;
                    }
                    if(tempObj.Insurance_Charges__c != undefined){
                        this.insuranceCharges = tempObj.Insurance_Charges__c > 0 ? tempObj.Insurance_Charges__c: null;
                        this.incoCharges.insuranceCharges= this.insuranceCharges;
                    }
                    if(tempObj.Lashing_Charges__c != undefined){
                        this.lashingCharges = tempObj.Lashing_Charges__c > 0 ? tempObj.Lashing_Charges__c: null;
                        this.incoCharges.lashingCharges= this.lashingCharges;
                    }
                    if(tempObj.Origin_Detention_Demurrage_Charges__c != undefined){
                        this.originDetentionDemurrageCharges = tempObj.Origin_Detention_Demurrage_Charges__c > 0 ? tempObj.Origin_Detention_Demurrage_Charges__c: null;
                        this.incoCharges.originDetentionDemurrageCharges= this.originDetentionDemurrageCharges;
                    }
                    if(tempObj.OTHC__c != undefined){
                        this.OTHC = tempObj.OTHC__c > 0 ? tempObj.OTHC__c: null;
                        this.incoCharges.OTHC= this.OTHC;
                    }
                    if(tempObj.Pickup_Charges__c != undefined){
                        this.pickupCharges = tempObj.Pickup_Charges__c > 0 ? tempObj.Pickup_Charges__c: null;
                        this.incoCharges.pickupCharges= this.pickupCharges;
                    }
                    if(tempObj.Reefer_Plugin_Charges__c != undefined){
                        this.reeferPluginCharges = tempObj.Reefer_Plugin_Charges__c > 0 ? tempObj.Reefer_Plugin_Charges__c: null;
                        this.incoCharges.reeferPluginCharges= this.reeferPluginCharges;
                    }
                    if(tempObj.Tarpaulin_Charges__c != undefined){
                        this.tarpaulinCharges = tempObj.Tarpaulin_Charges__c > 0 ? tempObj.Tarpaulin_Charges__c: null;
                        this.incoCharges.tarpaulinCharges= this.tarpaulinCharges;
                    }
                    if(tempObj.Truck_idling_Charges__c != undefined){
                        this.truckidlingCharges = tempObj.Truck_idling_Charges__c > 0 ? tempObj.Truck_idling_Charges__c: null;
                        this.incoCharges.truckidlingCharges= this.truckidlingCharges;
                    }
                    if(tempObj.VGM__c != undefined){
                        this.vGM = tempObj.VGM__c > 0 ? tempObj.VGM__c: null;
                        this.incoCharges.vGM= this.vGM;
                    }
                    if(tempObj.Total__c != undefined){
                        this.incoTotal = tempObj.Total__c > 0 ? tempObj.Total__c: null;
                        this.incoCharges.total= this.incoTotal;
                    }
                    this.updaTeIncoChargeTotal();
                }
                if(result.rmsObj.Clearance_and_Delivery__r != undefined && result.rmsObj.Clearance_and_Delivery__r.length > 0){
                    let tempObj = result.rmsObj.Clearance_and_Delivery__r[0];
                    if(tempObj.CurrencyIsoCode != undefined){
                        this.destinCharges.currencyCode = tempObj.CurrencyIsoCode ;
                        this.destinTotalChanged = result.destinTotalChanged != null ? result.destinTotalChanged : false;
                        if(this.curencyCodeOption.length > 0){
                            let index = this.curencyCodeOption.findIndex(x=>x.label == tempObj.CurrencyIsoCode);
                            if(index != -1){
                               this.destinExchangeRate = this.curencyCodeOption[index].exchangeRate
                            }
                        }
                        if(this.destinCharges.currencyCode == 'USD') {
                            this.disableShippOffSet = true;
                            this.destinCharges.offSet = 0;
                        }
                        else{
                            this.disableShippOffSet = false;
                        }
                    }
                    if(tempObj.Offset_Value__c != undefined){
                        this.destinCharges.offSet = tempObj.Offset_Value__c > 0 ? tempObj.Offset_Value__c: null;
                    }
                    if(tempObj.Bayan_Charges__c != undefined){
                        this.destinCharges.bayanCharges = tempObj.Bayan_Charges__c > 0 ? tempObj.Bayan_Charges__c: null;
                    }
                    if(tempObj.Custom_Clearance__c != undefined){
                        this.destinCharges.customClearance = tempObj.Custom_Clearance__c > 0 ? tempObj.Custom_Clearance__c: null;
                    }
                    if(tempObj.DO_charges__c != undefined){
                        this.destinCharges.doCharges = tempObj.DO_charges__c > 0 ? tempObj.DO_charges__c: null;
                    }
                    if(tempObj.Fasah_Charges__c != undefined){
                        this.destinCharges.fasahCharges = tempObj.Fasah_Charges__c > 0 ? tempObj.Fasah_Charges__c: null;
                    }
                    if(tempObj.Gate_pass_charges__c != undefined){
                        this.destinCharges.gatePassCharges = tempObj.Gate_pass_charges__c > 0 ? tempObj.Gate_pass_charges__c: null;
                    }
                    if(tempObj.LOLO_Charges__c != undefined){
                        this.destinCharges.LOLOCharges = tempObj.LOLO_Charges__c > 0 ? tempObj.LOLO_Charges__c: null;
                    }
                    if(tempObj.Total__c != undefined){
                        this.destinCharges.total = tempObj.Total__c > 0 ? tempObj.Total__c: null;
                    }
                    if(tempObj.Transportation__c != undefined){
                        this.destinCharges.transportation = tempObj.Transportation__c > 0 ? tempObj.Transportation__c: null;
                    }
                }
                this.isLoading = false
            }
        })
        .catch(erro=>{
            this.isLoading = false
            console.log('copyExistingRMS error'+JSON.stringify(erro,null,2))
        })
    }
}