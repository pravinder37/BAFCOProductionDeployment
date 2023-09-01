import { LightningElement,track,api,wire} from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import DIRECTION_FIELD from '@salesforce/schema/Loading_Charge__c.Direction__c';
import getExchangeRate from '@salesforce/apex/BAFCOLRoutingDetailsController.getExchangeRate';
import UserPreferencesHideS1BrowserUI from '@salesforce/schema/User.UserPreferencesHideS1BrowserUI';
export default class BAFCOImportAddServiceCharge extends LightningElement {
    @track curencyCodeOption = [];
    @track ExchangeRate;
    @track currencyCode = '';
    @track offSet ;
    @track disableIncoOffSet = true;
    @api serviceChargeList;
    @api defaultCurrencyCode ='';

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
    @track shippTotalChanged = false;
    @track DirectionOptions =[];


    ///
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
    @track xray;
    @track lashingCharges;
    @track TotalOrigincharges;
    @track directionValue;
    @track loadingChargeId;
    @track originTotalChanged = false;
    @track loadingChargeName;


    ///
    @track destinBayanCharges;
    @track destinCustomClearanceCharges;
    @track destinDOCharges;
    @track destinFasahCharges;
    @track destinGatePassCharges;
    @track destinLOLOCharges;
    @track destinTransPortationCharges;
    @track destinTotalCharges;
    @track DestinTotalChanged= false;

    @wire(getPicklistValues, {
        recordTypeId : '012000000000000AAA',
        fieldApiName : DIRECTION_FIELD
    })directionPickListValue({ data, error }){
            if(data){
                //console.log(` DIRECTION_FIELD values are `, data.values);
                this.DirectionOptions = data.values;
                this.directionValue = this.DirectionOptions[0].value;
                this.error = undefined;
            }
            if(error){
                console.log(` Error while fetching DIRECTION_FIELD Picklist values  ${error}`);
                this.error = error;
                this.DirectionOptions = undefined;
            }
    }

    connectedCallback(){
        console.log('serviceChargeList ',JSON.stringify(this.serviceChargeList,null,2)) 
        console.log('defaultCurrencyCode ',JSON.stringify(this.defaultCurrencyCode,null,2))
        if(this.defaultCurrencyCode != ''){
            console.log('came here ')
            this.currencyCode = this.defaultCurrencyCode;
        }
        else  
        if(Object.keys(this.serviceChargeList).length > 0){
            let allData = this.serviceChargeList;
            if(allData.currencyCode != undefined) {
                console.log('came here 2 ')
                this.currencyCode = allData.currencyCode;
            }
            if(allData.offset != undefined) this.offSet = allData.offset;
            if(this.currencyCode == 'USD') {
                this.disableIncoOffSet = true;
                this.offSet = 0;
            }
            else{
                this.disableIncoOffSet = false;
            }
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
                    let DefaultObj = {Id:this.loadingChargeId,Name:this.loadingChargeName}
                    setTimeout(() => {
                        let lookupField = this.template.querySelector('c-b-a-f-c-o-custom-look-up-component');
                        lookupField.handleDefaultSelected(DefaultObj);
                    }, 1);
                    
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
            }
        }    
        this.getExchangeRate();
    }
    handleIncoOffsetChange(e){
        this.offSet = e.target.value;
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
            console.log('this.currencyCode',this.currencyCode)
            if(this.currencyCode == '') this.currencyCode = 'USD';
        })
        .catch(error=>{
            console.log('getExchangeRate err',JSON.stringify(error,null,2))
        })
    }
    handleINCOCurrencyCodeSelection(e){
        this.currencyCode = e.target.value;
        this.curencyCodeOption.forEach(elem=>{
            if(elem.value == e.target.value){
                this.ExchangeRate = elem.exchangeRate
                this.incoOffSet = elem.offSet
                this.offSet = elem.offSet
            }
        })
        if(this.currencyCode == 'USD') {
            this.disableIncoOffSet = true;
            this.offSet = 0;
        }
        else{
            this.disableIncoOffSet = false;
        }
    }
    closeModal(){
        this.dispatchEvent(new CustomEvent('close'));
    }
    handleBAFChange(e){
        this.BAF = e.target.value;
        this.updateSLTotal();
    }
    handleBunkerChargesChange(e){
        this.bunkerCharges = e.target.value;
        this.updateSLTotal();
    }
    handleCleaningChargesChange(e){
        this.cleaningCharges = e.target.value;
        this.updateSLTotal();
    }
    handleCMCChange(e){
        this.CMC = e.target.value;
        this.updateSLTotal();
    }
    handleCarriageCongestionChange(e){
        this.carriageCongestionSurcharge = e.target.value;
        this.updateSLTotal();
    }
    handleSecurityFeeChange(e){
        this.carrierSecurityFees = e.target.value;
        this.updateSLTotal();
    }
    handleDGSurchargeChange(e){
        this.dgSurcharge = e.target.value;
        this.updateSLTotal();
    }
    handleInlandFuelChange(e){
        this.inlandFuelCharges = e.target.value;
        this.updateSLTotal();
    }
    handleDTHCChange(e){
        this.DTHC = e.target.value;
        this.updateSLTotal();
    }
    handleequipmentImblanceChange(e){
        this.equipmentImbalance = e.target.value;
        this.updateSLTotal();
    }
    handleInlandFuelChange(e){
        this.inlandFuelCharges = e.target.value;
        this.updateSLTotal();
    }
    handleInlandHandlingfeesChange(e){
        this.inlandHandlingfees = e.target.value;
        this.updateSLTotal();
    }
    handleInlandHaulageChange(e){
        this.inlandHaulage = e.target.value;
        this.updateSLTotal();
    }
    handleISPSChange(e){
        this.ISPS = e.target.value;
        this.updateSLTotal();
    }
    handleLowerSulpherChange(e){
        this.lowerSulphurSurcharge = e.target.value;
        this.updateSLTotal();
    }
    handleOperationalRecoveryChange(e){
        this.operationalRecovery = e.target.value;
        this.updateSLTotal();
    }
    handleOTHCChange(e){
        this.OTHC = e.target.value;
        this.updateSLTotal();
    }
    handleOverWeightChange(e){
        this.overWeightCharge = e.target.value;
        this.updateSLTotal();
    }
    handleSealChargesChange(e){
        this.sealCharges = e.target.value;
        this.updateSLTotal();
    }
    handleWarRiskSurchgesChange(e){
        this.warRiskSurcharges = e.target.value;
        this.updateSLTotal();
    }
    handleTotalSLChange(e){        
        this.totalSl = parseInt(e.target.value);
        if(this.totalSl != '') {
            this.shippTotalChanged = true;
        }
        else this.shippTotalChanged = false
    }
    submitDetails(){
        let servichargesObj= {
            'BAF': this.BAF,
            'bunkerCharges': this.bunkerCharges,
            'cleaningCharges':this.cleaningCharges,
            'CMC': this.CMC,
            'carriageCongestionSurcharge': this.carriageCongestionSurcharge,
            'carrierSecurityFees': this.carrierSecurityFees,
            'dgSurcharge': this.dgSurcharge,
            'DTHC': this.DTHC,
            'equipmentImbalance': this.equipmentImbalance,
            'inlandFuelCharges': this.inlandFuelCharges,
            'inlandHandlingfees': this.inlandHandlingfees,
            'inlandHaulage': this.inlandHaulage,
            'ISPS': this.ISPS,
            'lowerSulphurSurcharge': this.lowerSulphurSurcharge,
            'operationalRecovery': this.operationalRecovery,
            'OTHC': this.OTHC,
            'overWeightCharge': this.overWeightCharge,
            'sealCharges': this.sealCharges,
            'warRiskSurcharges': this.warRiskSurcharges,
            'totalSl': this.totalSl,
            'shippTotalChanged':this.shippTotalChanged
        }
        let originChargesObj = {
            'bayan':this.bayan,
            'blFees':this.blFees,
            'originCustomClearance':this.originCustomClearance,
            'exportServiceFees':this.exportServiceFees,
            'fasahFees':this.fasahFees,
            'fuelSurcharge':this.fuelSurcharge,
            'inspection':this.inspection,
            'insuranceCharges':this.insuranceCharges,
            'liftOnLiftOff':this.liftOnLiftOff,
            'OriginDetention':this.OriginDetention,
            'OriginLoadingCharges':this.OriginLoadingCharges,
            'pickUpCharges':this.pickUpCharges,
            'ReeferControlPlugInCharge':this.ReeferControlPlugInCharge,
            'tabadul':this.tabadul,
            'trapulinCharges':this.trapulinCharges,
            'truckIdlingCharges':this.truckIdlingCharges,
            'transportationCharges':this.transportationCharges,
            'vgm':this.vgm,
            'lashingCharges':this.lashingCharges,
            'xray':this.xray,
            'TotalOrigincharges':this.TotalOrigincharges,
            'directionValue':this.directionValue,
            'loadingChargeId':this.loadingChargeId,
            'originTotalChanged':this.originTotalChanged,
            'loadingChargeName':this.loadingChargeName
        }
        let destinChargeObj = {
            'destinBayanCharges' : this.destinBayanCharges,
            'destinCustomClearanceCharges' : this.destinCustomClearanceCharges,
            'destinDOCharges' : this.destinDOCharges,
            'destinFasahCharges' : this.destinFasahCharges,
            'destinGatePassCharges' : this.destinGatePassCharges,
            'destinLOLOCharges' : this.destinLOLOCharges,
            'destinTransPortationCharges' : this.destinTransPortationCharges,
            'destinTotalCharges' : this.destinTotalCharges,
            'DestinTotalChanged' : this.DestinTotalChanged,
        }
        let tempObj={
            'currencyCode':this.currencyCode,
            'offset':this.offSet,
            'servichargesObj':servichargesObj,
            'originChargesObj':originChargesObj,
            'destinChargeObj':destinChargeObj,
        }
        let toDeployEntry = JSON.parse(JSON.stringify(tempObj))
        this.dispatchEvent(new CustomEvent('update',{ detail: toDeployEntry }));
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
    }
    
    handleTransportaitonSelection(e){
        this.loadingChargeId = e.detail.Id;
        this.loadingChargeName = e.detail.Name;
    }
    handleTransportationRemoved(e){
        this.loadingChargeId = '';
        this.loadingChargeName = '';
    }
    handleBayanChange(e){
        this.bayan = e.target.value;
        this.updateOriginChargesTotal();
    }
    handleBLFeesChange(e){
        this.blFees = e.target.value
        this.updateOriginChargesTotal();
    }
    handleoriginCustomClerancehange(e){
        this.originCustomClearance = e.target.value
        this.updateOriginChargesTotal();
    }
    handleExportServicehange(e){
        this.exportServiceFees = e.target.value
        this.updateOriginChargesTotal();
    }
    handleFasahFeeChange(e){
        this.fasahFees = e.target.value
        this.updateOriginChargesTotal();
    }
    handleFuelsurchargeChange(e){
        this.fuelSurcharge = e.target.value
        this.updateOriginChargesTotal();
    }
    handleInspectionChange(e){
        this.inspection = e.target.value
        this.updateOriginChargesTotal();
    }
    handleinsuranceChargeChange(e){
        this.insuranceCharges = e.target.value
        this.updateOriginChargesTotal();
    }
    handleLiftOnOffChange(e){
        this.liftOnLiftOff = e.target.value
        this.updateOriginChargesTotal();
    }
    handleOriginDetentionChange(e){
        this.OriginDetention = e.target.value
        this.updateOriginChargesTotal();
    }
    handleOriginLoadingChargesChange(e){
        this.OriginLoadingCharges = e.target.value
        this.updateOriginChargesTotal();
    }
    handlePickUpChargeChange(e){
        this.pickUpCharges = e.target.value
        this.updateOriginChargesTotal();
    }
    handleReferPlugInChange(e){
        this.ReeferControlPlugInCharge = e.target.value
        this.updateOriginChargesTotal();
    }
    handletabadulChange(e){
        this.tabadul = e.target.value
        this.updateOriginChargesTotal();
    }
    handleTrapulinChargesChange(e){
        this.trapulinCharges = e.target.value
        this.updateOriginChargesTotal();
    }
    handleTruckIdlingChange(e){
        this.truckIdlingCharges = e.target.value
        this.updateOriginChargesTotal();
    }
    handleTransPortationChange(e){
        this.transportationCharges = e.target.value
        this.updateOriginChargesTotal();
    }
    handleVGMChange(e){
        this.vgm = e.target.value
        this.updateOriginChargesTotal();
    }
    handleLashingCharge(e){
        this.lashingCharges = e.target.value;
        this.updateOriginChargesTotal();
    }
    handlexrayChange(e){
        this.xray = e.target.value
        this.updateOriginChargesTotal();
    }
    handletotalOriginChange(e){
        this.TotalOrigincharges = parseInt(e.target.value)
        if(this.TotalOrigincharges != ''){
            this.originTotalChanged = true;
        }
        else{
            this.originTotalChanged = false;
        }
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
    }

    handleDestinBayanChargeChange(e){
        this.destinBayanCharges = e.target.value;
        this.updateDestinChargeTotal();
    }
    handleDestinCustomClearanceChargeChange(e){
        this.destinCustomClearanceCharges = e.target.value;
        this.updateDestinChargeTotal();
    }
    handleDestinDOChargeChange(e){
        this.destinDOCharges = e.target.value;
        this.updateDestinChargeTotal();
    }
    handleDestinFasahChargeChange(e){
        this.destinFasahCharges = e.target.value;
        this.updateDestinChargeTotal();
    }
    handleDestinGatePassChange(e){
        this.destinGatePassCharges = e.target.value;
        this.updateDestinChargeTotal();
    }
    handleDestinLOLOChargeChange(e){
        this.destinLOLOCharges = e.target.value;
        this.updateDestinChargeTotal();
    }
    handleDestinTansPortationChange(e){
        this.destinTransPortationCharges = e.target.value;
        this.updateDestinChargeTotal();
    }
    handleDestinTotalChange(e){
        this.destinTotalCharges = parseInt(e.target.value);
        if(this.destinTotalCharges != '') this.DestinTotalChanged = true
        else this.DestinTotalChanged = false
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
    }
}