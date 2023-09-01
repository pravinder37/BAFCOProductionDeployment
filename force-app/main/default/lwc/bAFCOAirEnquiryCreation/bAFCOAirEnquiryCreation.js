import { LightningElement,track,api,wire } from 'lwc';
import { getPicklistValues,getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import getLeadDetails from '@salesforce/apex/BAFCOLeadDetailsController.getLeadDetails';
import BUSINESS_TYPE_FIELD from '@salesforce/schema/Opportunity.Business_Type__c';
import { NavigationMixin } from 'lightning/navigation';
import ROUTE_OBJECT from '@salesforce/schema/Route__c';
import CONTAINER_PNG from '@salesforce/resourceUrl/AddContainer';
import getAllRegularRoute from '@salesforce/apex/BAFCOLRoutingDetailsController.getAllRegularRoute';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCommercialUserOnLoad from '@salesforce/apex/BAFCOLRoutingDetailsController.getCommercialUserOnLoad';
import getEditOptyDetail from '@salesforce/apex/BAFCOEditOpportunityController.getEditOptyDetail';
import submitRoutingList from '@salesforce/apex/BAFCOAirEnquiryController.submitRoutingList';
export default class BAFCOAirEnquiryCreation extends NavigationMixin(LightningElement) {
    @track minDate = '';
    @api quoteId;
    @api optyId;
    @api isEdit;
    @api isAir;
    @track entryIntVar = 1;
    @track contractVar = 1;
    @track commercialUserId = '';
    @track commercialUserName = '';
    @track pickListvalues =[];
    @track kindOfShipmentOption = [];
    @track serviceTypeOption = [];
    @track dgClassOption = [];
    @track businessTypeSelected = 'Export';
    @track leadEnquiryList = [];
    @track containerRemoveList = [];
    @track routeRemoveList = [];
    quoteTypeErrorClass ='';
    quoteTypeErrorMsg ='';
    customerErrorClass ='';
    @track closeDate = '';
    @track disableAddRoute = false
    @track isLoading = false;
    @track totalGross = null;
    @track totalCBM = null;
    @track totalVolumeWeight = null;
    @track airEnquiry = false;
    @wire(getPicklistValues, {
        recordTypeId : '012000000000000AAA',
        fieldApiName : BUSINESS_TYPE_FIELD
    })wiredPickListValue({ data, error }){
            if(data){
                console.log(` Picklist values are `, data.values);
                this.pickListvalues = data.values;
                this.error = undefined;
            }
            if(error){
                console.log('Error while fetching Picklist values ' +JSON.stringify(error));
                this.error = error;
                this.pickListvalues = undefined;
            }
    }
    @wire(getPicklistValuesByRecordType, { objectApiName: ROUTE_OBJECT, recordTypeId: '012000000000000AAA' })
    routeObjectData({ data, error }) {
        if(data){
            this.kindOfShipmentOption = data.picklistFieldValues.Kind_Of_Shipment__c.values;
            this.serviceTypeOption = data.picklistFieldValues.Service_Type__c.values;
            this.dgClassOption = data.picklistFieldValues.DG_Class__c.values;
        }
        else if(error){
            console.log(' Route Object data error', JSON.stringify(error, null, 2));
        }
    }
    connectedCallback(){
        let todaysDate = new Date();
        this.minDate = this.formatDate(todaysDate);
        if(this.isEdit == 'true'){
            this.getEditOptyDetail();
        }else{
            this.getCommercialUserOnLoad();
            this.addRouteEnquiry();            
            this.getDefaultBusinessType();
        }
        if(this.isAir == 'true') {
            this.dontShowAddNewRoute = true;
            this.airEnquiry = true;
        }
    }
    formatDate(date) {
        let d = new Date(date),
            month = '' + (d.getMonth() + 1),
            day = '' + (d.getDate()),
            year = d.getFullYear();
    
        if (month.length < 2) 
            month = '0' + month;
        if (day.length < 2) 
            day = '0' + day;
    
        return [year, month, day].join('-');
    }
    getCommercialUserOnLoad(){
        getCommercialUserOnLoad({AccountId : this.quoteId})
        .then(result=>{
            if(result != null){
                let commercialUserId = result[0].Commercial_User__c;
                let commercialUserName = result[0].Commercial_User__r.Name;
                let field = this.template.querySelector('c-b-a-f-c-o-custom-look-up-component');
                let Obj={Id:commercialUserId,Name:commercialUserName}
                field.handleDefaultSelected(Obj);
            }

        })
        .catch(error=>{
            console.log('getCommercialUserOnLoad error'+error);
        })
    }
    handleCommercialUserSelection(e){
        this.commercialUserId = e.detail.Id;
        this.commercialUserName = e.detail.Name;
        this.customerErrorClass ='';
    }
    handleCommercialUserRemoved(e){
        this.commercialUserId = '';
        this.commercialUserName = '';
        this.customerErrorClass ='slds-has-error';
    }
    getDefaultBusinessType(){
        getLeadDetails({leadId : this.quoteId})
        .then(result =>{
            console.log('getLeadDetails resu '+JSON.stringify(result,null,2))
            this.businessTypeSelected = result.businessType;
        }).catch(error=>{
            console.log('error lead: ', JSON.stringify(error));
        });
    }
    addRouteEnquiry(){
        let containerRecord = {
            'length':null,
            'width':null,
            'height':null,
            'CBM':null,
            'Weight':null,
            "volumeWeight":null,            
            'index' : this.entryIntVar +'.'+ this.contractVar,
            'id':'',
            'uomValue':'CM',
            'UOMErrorClass':'',
            'lengthErrorClass':'',
            'widthErrorClass':'',
            'heightErrorClass':'',
            'CBMErrorClass':'',
            'WeightErrorClass':'',
            'unitsErrorClass':'',
            'stackable':false,
            'palletized':false,
            'units':1,
            'cargoDetails':'',
            'cargoDetailsError':'',
            'disableCBM':false,
            'CBMChanged':false
        }
        let contrTempList  = [];
        contrTempList.push(containerRecord);
        let leadEnqObj ={
            'routeName':'Route '+this.entryIntVar,
            'routingRegular':'',
            'shipmentKind':'',
            'incoTerm':'',
            'incoTermName':'',
            'portLoading':'',
            'portLoadingName':'',
            'portDestination':'',
            'portDestinationName':'',
            'shippingLine':'',
            'shippingLineName':'',
            'placeOfPickup':'',
            'placeOfDischarge':'',
            'commodity':'',
            'commodityName':'',
            'dangerousGoods':false,
            'remarks':'',
            'dgClass':'',
            'leadIndex':this.entryIntVar,
            'containerRecord': contrTempList,
            'showDGClassField':false,
            'showPickupPlaceField':false,
            'showDischargePlaceField':false,
            'incoTermField':this.entryIntVar+'incoTermField',
            'copyFromAbove':this.entryIntVar > 1 ? true : false,
            'placeOfPickupName':'',
            'placeOfDischargeName':'',
            'parentId':this.quoteId,
            'shipmentKindClass':'',
            'serviceTypeClass':'',
            'incoTermClass':'',
            'portOfLoadingClass':'',
            'portOfDestinationClass':'',
            'commodityClass':'',
            'dischargePlaceClass':'',
            'pickupPlaceClass':'',
            'disableAddRoute':false,
            'isAir':this.isAir,
            'cargoReadiness':'',
            'stackableParent':false,
            'palletizedParent':false,
            'routeId':''
        }
        this.entryIntVar++;
       if(this.leadEnquiryList.length <= 4 ){
            this.leadEnquiryList.push(leadEnqObj); 
        }
        else{
            this.dontShowAddNewRoute = true;
        }
        if(this.leadEnquiryList.length == 5){
            this.dontShowAddNewRoute = true;
        }
        //console.log('Lead List '+JSON.stringify(this.leadEnquiryList,null,2));
    }
    getEditOptyDetail(){
        getEditOptyDetail({optyId:this.optyId})
        .then(result=>{
            console.log('getEditOptyDetail result'+JSON.stringify(result,null,2));
            if(result != null){
                this.businessTypeSelected = result.businessType;
                this.closeDate = result.closeDate;
                let commercialUserId = result.commercialUserId;
                let commercialUserName = result.commercialUserName;
                let field = this.template.querySelector('c-b-a-f-c-o-custom-look-up-component');
                let Obj={Id:commercialUserId,Name:commercialUserName}
                field.handleDefaultSelected(Obj);
                let tempList =[];
                if(result.routingList.length > 0){
                    result.routingList.forEach(elem => {
                        let leadEnqObj ={
                            'routeName':elem.routeName,
                            'routingRegular':elem.routingRegular,
                            'serviceType':elem.serviceType,
                            'incoTerm':elem.incoTerm,
                            'incoTermName':elem.incoTermName,
                            'portLoading':elem.portLoadingId != undefined ? elem.portLoadingId :'',
                            'portLoadingName':elem.portLoadingId != undefined ? elem.portLoading :'',
                            'portDestination':elem.portDestinationId != undefined ? elem.portDestinationId :'',
                            'portDestinationName':elem.portDestinationId != undefined ? elem.portDestination :'',
                            'shippingLine':elem.shippingLine != undefined ? elem.shippingLine :'',
                            'shippingLineName':elem.shippingLine != undefined ? elem.shippingLineName :'',
                            'placeOfPickup':elem.placeOfPickup,
                            'placeOfDischarge':elem.placeOfDischarge,
                            'commodity':elem.commodity != undefined ? elem.commodity :'',
                            'commodityName':elem.commodity != undefined ? elem.commodityName :'',
                            'cargoWeights':elem.cargoWeights,
                            'dangerousGoods':elem.dangerousGoods,
                            'remarks':elem.remarks,
                            'dgClass':elem.dgClass,
                            'cargoReadiness':elem.cargoReadiness != undefined ? elem.cargoReadiness : '',
                            'leadIndex':parseInt(elem.leadIndex),
                            'containerRecord': elem.containerRecord,
                            'showDGClassField':elem.dangerousGoods,
                            'isAir':elem.isAir != undefined ? elem.isAir : false,
                            'showPickupPlaceField':false,
                            'showDischargePlaceField':false,
                            'incoTermField':parseInt(elem.leadIndex)+'incoTermField',
                            'copyFromAbove':parseInt(elem.leadIndex) > 1 ? true : false,
                            'parentId':this.quoteId,
                            'serviceTypeClass':'',
                            'incoTermClass':'',
                            'portOfLoadingClass':'',
                            'portOfDestinationClass':'',
                            'commodityClass':'',
                            'cargoweightClass':'',
                            'dischargePlaceClass':'',
                            'pickupPlaceClass':'',
                            'stackableParent':elem.stackableParent,
                            'palletizedParent':elem.palletizedParent,
                            'disableAddRoute':false,
                            'routeId':elem.routeId,
                        }
                        tempList.push(leadEnqObj);
                    });
                }
                this.leadEnquiryList = tempList
                let totalRecords = this.leadEnquiryList.length
                this.entryIntVar = totalRecords+1;
                console.log('leadEnquiryList $ '+JSON.stringify(this.leadEnquiryList,null,2))
            }
        })
        .catch(error=>{
            console.log('getEditOptyDetail error'+JSON.stringify(error,null,2));
        })
    }
    handleBusinessTypeChange(event){
        this.businessTypeSelected = event.target.value
        this.quoteTypeErrorClass ='';
        this.quoteTypeErrorMsg ='';
        this.disableAddRoute = false;
        if(this.businessTypeSelected == 'Import' ) {
            if(this.isAir == 'true') {
                let templist1 = this.leadEnquiryList;
                this.leadEnquiryList.forEach(elem=>{
                    elem.containerRecord = [];
                })
                let tempList = []
                let containerRecord = {
                    'length':null,
                    'width':null,
                    'height':null,
                    'CBM':null,
                    'Weight':null,
                    'volumeWeight':null,
                    'index' : '1.1',
                    'id':'',
                    'lengthErrorClass':'',
                    'widthErrorClass':'',
                    'heightErrorClass':'',
                    'CBMErrorClass':'',
                    'WeightErrorClass':'',
                    'unitsErrorClass':'',
                    'stackable':false,
                    'palletized':false,
                    'units':1,
                    'cargoDetails':'',
                    'cargoDetailsError':'',
                    'uomValue':'CM',
                    'UOMErrorClass':'',
                    'disableCBM':false,
                    'CBMChanged':false
                }
                tempList.push(containerRecord)
                templist1[0].containerRecord = tempList;
                this.leadEnquiryList = JSON.parse( JSON.stringify( templist1 ) );
            }
        }
        let ChildList = this.template.querySelectorAll('c-b-a-f-c-o-air-freight-enquiry-intake');
        if(ChildList.length > 0){
            ChildList.forEach(elem=>{
                if(this.businessTypeSelected == 'Import' ) {
                    elem.removeDefaultOnImport();
                }
                else if(this.businessTypeSelected == 'Export'){
                    this.dontShowAddNewRoute= true;
                    elem.getDefualtValueForEnquiry();
                }
            })
        }
        this.totalCBM = null;
        this.totalGross = null;
        this.totalVolumeWeight = null;
    }
    handleEnquiryListUpdate(event){
        let prdDto = JSON.parse(JSON.stringify(event.detail.dto));
        console.log('prdDto '+JSON.stringify(prdDto,null,2))
        this.leadEnquiryList.forEach(elem => {
            if(elem.leadIndex == prdDto.leadIndex) {
                elem.serviceType = prdDto.serviceType;
                elem.incoTerm = prdDto.incoTerm;
                elem.routingRegular = prdDto.routingRegular;
                elem.portLoading = prdDto.portLoading;
                elem.portDestination = prdDto.portDestination;
                elem.shippingLine = prdDto.shippingLine;
                elem.showPickupPlaceField = prdDto.showPickupPlaceField;
                elem.showDischargePlaceField = prdDto.showDischargePlaceField;
                elem.placeOfPickup = prdDto.placeOfPickup;
                elem.placeOfDischarge = prdDto.placeOfDischarge;
                elem.commodity = prdDto.commodity;
                elem.remarks = prdDto.remarks;
                elem.dgClass = prdDto.dgClass;
                elem.dangerousGoods = prdDto.dangerousGoods;
                elem.showDGClassField = prdDto.showDGClassField;
                elem.incoTermName = prdDto.incoTermName;
                elem.portLoadingName = prdDto.portLoadingName;
                elem.portDestinationName = prdDto.portDestinationName;
                elem.shippingLineName = prdDto.shippingLineName;
                elem.commodityName = prdDto.commodityName;
                elem.placeOfPickupName = prdDto.placeOfPickupName;
                elem.placeOfDischargeName = prdDto.placeOfDischargeName;
                elem.containerRecords = prdDto.containerRecords;
                elem.shipmentKindClass = prdDto.shipmentKindClass
                elem.serviceTypeClass = prdDto.serviceTypeClass
                elem.incoTermClass = prdDto.incoTermClass
                elem.portOfLoadingClass = prdDto.portOfLoadingClass
                elem.portOfDestinationClass = prdDto.portOfDestinationClass
                elem.commodityClass = prdDto.commodityClass
                elem.dischargePlaceClass = prdDto.dischargePlaceClass
                elem.pickupPlaceClass = prdDto.pickupPlaceClass
                elem.disableAddRoute = prdDto.disableAddRoute
                elem.cargoReadiness = prdDto.cargoReadiness
                elem.stackableParent = prdDto.stackableParent
                elem.palletizedParent = prdDto.palletizedParent
                if(elem.disableAddRoute == true) this.disableAddRoute = true
            }
        })
    }
    handleSubmit(){
        let allValid = true;
        let errorList = [];
        console.log('dto '+JSON.stringify(this.leadEnquiryList,null,2))
        if(this.businessTypeSelected == '' || this.businessTypeSelected == undefined){
            this.quoteTypeErrorClass = 'slds-has-error';
            this.quoteTypeErrorMsg  = 'Complete this field.';
            allValid  = false;
        }
        if(this.closeDate == '' || this.closeDate == null){
            let closeDateField = this.template.querySelector("[data-field='closeDateField']");
            closeDateField.setCustomValidity("Complete this field");
            closeDateField.reportValidity();
            allValid  = false;
        }
        else if(this.closeDate < this.minDate){
            let closeDateField = this.template.querySelector("[data-field='closeDateField']");
            closeDateField.setCustomValidity("Date should be greater than today.");
            closeDateField.reportValidity();
            allValid  = false;
        }
        if(this.commercialUserId == ''){
            allValid = false;
            this.customerErrorClass = 'slds-has-error'
        }
        this.leadEnquiryList.forEach(elem=>{
            let tempErrorList = [];
            console.log('elem '+JSON.stringify(elem,null,2))
            if(elem.serviceType == '') {
                tempErrorList.push('Please fill Service Type')
                elem.serviceTypeClass = 'slds-has-error';
            }
            if(elem.incoTerm == '') {
                if(elem.serviceType != 'Ex-Works'){
                    tempErrorList.push('Please fill Inco term')
                    elem.incoTermClass = 'slds-has-error';
                }
            }
            if(elem.portLoading == '') {
                tempErrorList.push('Please fill Port of Loading')
                elem.portOfLoadingClass = 'slds-has-error';
            }
            if(elem.portDestination == '') {
                tempErrorList.push('Please fill Port of Destination')
                elem.portOfDestinationClass = 'slds-has-error';
            }
            if(elem.commodity == '') {
                tempErrorList.push('Please fill commodity')
                elem.commodityClass = 'slds-has-error';
            }
            if(elem.serviceType == 'D2P' && elem.placeOfPickup == ''){
                tempErrorList.push('Please fill Place of Pickup')
                elem.pickupPlaceClass = 'slds-has-error';
            }
            if(elem.serviceType == 'D2D' && elem.placeOfDischarge == ''){
                tempErrorList.push('Please fill place of discharge')
                elem.dischargePlaceClass = 'slds-has-error';
            }
            elem.containerRecord.forEach(elem2=>{
                if(this.isAir == 'true'){
                    if(elem2.length <= 0 && elem2.CBMChanged == false){
                        elem2.lengthErrorClass = 'slds-has-error';
                        allValid = false
                    }
                    if(elem2.width <= 0 && elem2.CBMChanged == false){
                        elem2.widthErrorClass = 'slds-has-error';
                        allValid = false
                    }
                    if(elem2.height <= 0 && elem2.CBMChanged == false){
                        elem2.heightErrorClass = 'slds-has-error';
                        allValid = false
                    }
                    if(elem2.uomValue == ''){
                        elem2.UOMErrorClass = 'slds-has-error';
                        allValid = false
                    }
                }
                if(elem2.CBM <= 0){
                    elem2.CBMErrorClass = 'slds-has-error';
                    allValid = false
                }
                if(elem2.Weight <= 0){
                    elem2.WeightErrorClass = 'slds-has-error';
                    allValid = false
                }
                if(elem2.units <= 0){
                    elem2.unitsErrorClass = 'slds-has-error';
                    allValid = false
                }
                /*if(elem2.cargoDetails == ''){
                    elem2.cargoDetailsError = 'slds-has-error';
                    allValid = false
                }*/
            })
            if(tempErrorList.length > 0){
               allValid  = false;
               errorList.push(elem.routeName);
            }
        })
        if(allValid){
            this.isLoading = true
            submitRoutingList({ 
                routingList : this.leadEnquiryList,
                businessType : this.businessTypeSelected,
                quoteId : this.quoteId,
                closeDate : this.closeDate,
                commercialUserId : this.commercialUserId,
                isEdit:this.isEdit,
                containerRemoveList:this.containerRemoveList,
                routeRemoveList:this.routeRemoveList,
                optyId:this.optyId,
                totalCBM : this.totalCBM,
                totalGross : this.totalGross,
                totalVolumeWeight : this.totalVolumeWeight,
            })
            .then(result =>{
                this.isLoading = false
                console.log('routing submit  result : ', JSON.stringify(result,null,2));
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: result,
                        objectApiName: 'Opportunity',
                        actionName: 'view'
                    }
                });
            })
            .catch(error=>{
                console.log('routing submit error lead: ', JSON.stringify(error));
                this.isLoading = false
            });
        }
        else{
            const evt = new ShowToastEvent({
                title: 'Missing Field',
                message: 'Complete the missing field.',
                variant: 'Error',
            });
            this.dispatchEvent(evt);
        }
    }
    handelCloseDate(e){
        this.closeDate =e.target.value
        let closeDateField = this.template.querySelector("[data-field='closeDateField']");
        if(this.closeDate == null){
            closeDateField.setCustomValidity("Complete this field");
        }
        else{
            closeDateField.setCustomValidity("");
        }        
        closeDateField.reportValidity();
    }
    handleRemoveRouteOption(e){
        let index = e.target.value;
        if(index != 1){
            let indexTobeRemoved = this.leadEnquiryList.findIndex(x => x.leadIndex == index );
            if(indexTobeRemoved != -1) {
                if(this.leadEnquiryList[indexTobeRemoved].routeId != '') this.routeRemoveList.push(this.leadEnquiryList[indexTobeRemoved].routeId)
                this.leadEnquiryList.splice( indexTobeRemoved, 1 );
            }
        }
        if(this.leadEnquiryList.length <= 5){
            this.dontShowAddNewRoute = false
        }
        else{
            this.dontShowAddNewRoute = true
        }
    }
    handleLenghtUpdate(e){
        let prdDto = JSON.parse(JSON.stringify(e.detail.dto));
        let index = prdDto.index;
        let splitIndex = index.split('.');
        let indexOfLeadEnquiry = this.leadEnquiryList.findIndex(x => x.leadIndex == splitIndex[0] );
        let childContainerIndex = this.leadEnquiryList[indexOfLeadEnquiry].containerRecord.findIndex(x => x.index == index );
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].length = prdDto.length;
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].disableCBM = true;
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].lengthErrorClass = '';
        if(this.isAir == 'true'){
            this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].CBMErrorClass = '';
        }
    }
    handleWidthUpdate(e){
        let prdDto = JSON.parse(JSON.stringify(e.detail.dto));
        let index = prdDto.index;
        let splitIndex = index.split('.');
        let indexOfLeadEnquiry = this.leadEnquiryList.findIndex(x => x.leadIndex == splitIndex[0] );
        let childContainerIndex = this.leadEnquiryList[indexOfLeadEnquiry].containerRecord.findIndex(x => x.index == index );
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].width = prdDto.width;
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].disableCBM = true;
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].widthErrorClass = '';
        if(this.isAir == 'true'){
            this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].CBMErrorClass = '';
        }
    }
    handleheightupdate(e){
        let prdDto = JSON.parse(JSON.stringify(e.detail.dto));
        let index = prdDto.index;
        let splitIndex = index.split('.');
        let indexOfLeadEnquiry = this.leadEnquiryList.findIndex(x => x.leadIndex == splitIndex[0] );
        let childContainerIndex = this.leadEnquiryList[indexOfLeadEnquiry].containerRecord.findIndex(x => x.index == index );
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].height = prdDto.height;
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].disableCBM = true;
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].heightErrorClass = '';
        if(this.isAir == 'true'){
            this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].CBMErrorClass = '';
        }
    }
    handlecbmupdate(e){
        let prdDto = JSON.parse(JSON.stringify(e.detail.dto));
        console.log('prdDto '+JSON.stringify(prdDto,null,2))
        let index = prdDto.index;
        let splitIndex = index.split('.');
        let indexOfLeadEnquiry = this.leadEnquiryList.findIndex(x => x.leadIndex == splitIndex[0] );
        let childContainerIndex = this.leadEnquiryList[indexOfLeadEnquiry].containerRecord.findIndex(x => x.index == index );
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].CBM = prdDto.cbm;
        if(prdDto.userChanged == true)
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].CBMChanged = true;
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].CBMErrorClass = '';
        if(this.isAir == 'true'){
            this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].heightErrorClass = '';
            this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].widthErrorClass = '';
            this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].lengthErrorClass = '';
        }
        if(prdDto.allNull == true)
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].disableCBM = false;
        if(!prdDto.cbm > 0)
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].CBMChanged = false;
        this.handleTotalField();
    }
    handlevolumeWeightupdate(e){
        let prdDto = JSON.parse(JSON.stringify(e.detail.dto));
        let index = prdDto.index;
        let splitIndex = index.split('.');
        let indexOfLeadEnquiry = this.leadEnquiryList.findIndex(x => x.leadIndex == splitIndex[0] );
        let childContainerIndex = this.leadEnquiryList[indexOfLeadEnquiry].containerRecord.findIndex(x => x.index == index );
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].volumeWeight = prdDto.volumeWeight;
        this.handleTotalField();
    }
    handleUOMUpdate(e){
        let prdDto = JSON.parse(JSON.stringify(e.detail.dto));
        let index = prdDto.index;
        let splitIndex = index.split('.');
        let indexOfLeadEnquiry = this.leadEnquiryList.findIndex(x => x.leadIndex == splitIndex[0] );
        let childContainerIndex = this.leadEnquiryList[indexOfLeadEnquiry].containerRecord.findIndex(x => x.index == index );
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].uomValue = prdDto.uom;
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].UOMErrorClass = '';
    }
    handleweightupdate(e){
        let prdDto = JSON.parse(JSON.stringify(e.detail.dto));
        let index = prdDto.index;
        let splitIndex = index.split('.');
        let indexOfLeadEnquiry = this.leadEnquiryList.findIndex(x => x.leadIndex == splitIndex[0] );
        let childContainerIndex = this.leadEnquiryList[indexOfLeadEnquiry].containerRecord.findIndex(x => x.index == index );
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].Weight = prdDto.weight;
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].WeightErrorClass = '';
        this.handleTotalField();
    }
    handleStackableUpdate(e){
        let prdDto = JSON.parse(JSON.stringify(e.detail.dto));
        let index = prdDto.index;
        let splitIndex = index.split('.');
        let indexOfLeadEnquiry = this.leadEnquiryList.findIndex(x => x.leadIndex == splitIndex[0] );
        let childContainerIndex = this.leadEnquiryList[indexOfLeadEnquiry].containerRecord.findIndex(x => x.index == index );
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].stackable = prdDto.stackable;
    }
    handlePalletizedUpdate(e){
        let prdDto = JSON.parse(JSON.stringify(e.detail.dto));
        let index = prdDto.index;
        let splitIndex = index.split('.');
        let indexOfLeadEnquiry = this.leadEnquiryList.findIndex(x => x.leadIndex == splitIndex[0] );
        let childContainerIndex = this.leadEnquiryList[indexOfLeadEnquiry].containerRecord.findIndex(x => x.index == index );
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].palletized = prdDto.palletized;
    }
    handleUnitsUpdate(e){
        let prdDto = JSON.parse(JSON.stringify(e.detail.dto));
        let index = prdDto.index;
        let splitIndex = index.split('.');
        let indexOfLeadEnquiry = this.leadEnquiryList.findIndex(x => x.leadIndex == splitIndex[0] );
        let childContainerIndex = this.leadEnquiryList[indexOfLeadEnquiry].containerRecord.findIndex(x => x.index == index );
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].units = prdDto.units;
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].unitsErrorClass = '';
        this.handleTotalField();
    }
    handleCargoDetailsUpdate(e){
        let prdDto = JSON.parse(JSON.stringify(e.detail.dto));
        let index = prdDto.index;
        let splitIndex = index.split('.');
        let indexOfLeadEnquiry = this.leadEnquiryList.findIndex(x => x.leadIndex == splitIndex[0] );
        let childContainerIndex = this.leadEnquiryList[indexOfLeadEnquiry].containerRecord.findIndex(x => x.index == index );
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].cargoDetails = prdDto.cargoDetails;
        this.leadEnquiryList[indexOfLeadEnquiry].containerRecord[childContainerIndex].cargoDetailsError = '';
    }
    handleAddContainer(e){
        let strIndex = e.detail;
        let tempList = this.leadEnquiryList;       
        let lastcontainer = tempList[strIndex - 1].containerRecord.length;
        let indexOfPreviousRecord = tempList[strIndex - 1].containerRecord[lastcontainer - 1].index.split('.');
        let newContainerIndex = indexOfPreviousRecord[1];
        newContainerIndex++;
        let lastContainerRecord = tempList[strIndex - 1].containerRecord;
        let previousRecord = lastContainerRecord[0];
        let containerRecord = {
            'length':previousRecord.length,
            'width':previousRecord.width,
            'height':previousRecord.height,
            'CBM':previousRecord.CBM,
            'Weight':previousRecord.Weight,
            'volumeWeight':previousRecord.volumeWeight,
            'index' : strIndex +'.'+ newContainerIndex,
            'id':'',
            'lengthErrorClass':'',
            'widthErrorClass':'',
            'heightErrorClass':'',
            'CBMErrorClass':'',
            'WeightErrorClass':'',
            'unitsErrorClass':'',
            'stackable':previousRecord.stackable,
            'palletized':previousRecord.palletized,
            'units':previousRecord.units,
            'cargoDetails':previousRecord.cargoDetails,
            'cargoDetailsError':'',
            'UOMErrorClass':'',
            'uomValue':previousRecord.uomValue,
            'disableCBM':previousRecord.disableCBM,
            'CBMChanged':previousRecord.CBMChanged
        }
        lastContainerRecord.push(containerRecord);
        tempList[strIndex - 1].containerRecord = lastContainerRecord;
        this.leadEnquiryList = JSON.parse( JSON.stringify( tempList ) );
        this.handleTotalField();
    }
    handleEmptyContainer(e){
        let cData = e.detail;
        let cameIndex = cData.index
        let tempList1 = this.leadEnquiryList;
        let strIndex = this.leadEnquiryList.findIndex(x => x.leadIndex == cameIndex );
        tempList1[strIndex].containerRecord = [];
        this.leadEnquiryList = JSON.parse( JSON.stringify( tempList1 ) );
        for(let i = 0 ;i<cData.size; i++ ){  
            let tempList = this.leadEnquiryList;  
            let newContainerIndex= i+1 
            let lastContainerRecord = tempList[strIndex].containerRecord;
            let containerRecord = {
                'length':null,
                'width':null,
                'height':null,
                'CBM':null,
                'Weight':null,
                'volumeWeight':null,
                'index' : cameIndex +'.'+ newContainerIndex,
                'id':'',
                'lengthErrorClass':'',
                'widthErrorClass':'',
                'heightErrorClass':'',
                'CBMErrorClass':'',
                'WeightErrorClass':'',
                'unitsErrorClass':'',
                'stackable':false,
                'palletized':false,
                'units':1,
                'cargoDetails':'',
                'cargoDetailsError':'',
                'uomValue':'CM',
                'UOMErrorClass':'',
                'disableCBM':false,
                'CBMChanged':false
            }
            lastContainerRecord.push(containerRecord);
            tempList[strIndex].containerRecord = lastContainerRecord;
            this.leadEnquiryList = JSON.parse( JSON.stringify( tempList ) );
        }
    }
    handleRemoveContainerType(e){
        let index = e.detail
        let tempLeadList = this.leadEnquiryList;
        let indexofBothList = index.split('.');
        let LeadIndex = indexofBothList[0] - 1;
        let indexOfRemoved = indexofBothList[1] - 1;
        let containerRecords = tempLeadList[LeadIndex].containerRecord;
        if(containerRecords.length != 1){
            let remIndex = containerRecords.findIndex(x=>x.index == index)
            if(remIndex != -1){
                if(containerRecords[remIndex].id != '')  this.containerRemoveList.push(containerRecords[remIndex].id)
                containerRecords.splice( remIndex, 1 );
            }
        }
    }
    handleTotalField(){
        let totalCBM = 0;
        let totalGross = 0;
        let totalVolumeWeight = 0;
        this.leadEnquiryList.forEach(elem=>{
            elem.containerRecord.forEach(elem2=>{
                let units = elem2.units > 0 ? elem2.units : 1;
                if(elem2.Weight > 0){
                    totalGross = parseFloat(parseFloat(totalGross) + (parseFloat(elem2.Weight) * units))
                }
                if(elem2.CBM > 0){
                    totalCBM = parseFloat(parseFloat(totalCBM) + (parseFloat(elem2.CBM)* units))
                }
                if(elem2.volumeWeight > 0){
                    totalVolumeWeight = parseFloat(parseFloat(totalVolumeWeight) + (parseFloat(elem2.volumeWeight)* units))
                }
            })
        })
        this.totalCBM = totalCBM > 0 ? totalCBM.toFixed(3) : null;
        this.totalGross = totalGross > 0 ? totalGross.toFixed(2) : null;
        this.totalVolumeWeight = totalVolumeWeight > 0 ? totalVolumeWeight.toFixed(2) : null;
    }
}