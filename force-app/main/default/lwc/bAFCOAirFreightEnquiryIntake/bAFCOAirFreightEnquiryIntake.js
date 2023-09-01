import { LightningElement,api,track,wire } from 'lwc';
import ROUTE_OBJECT from '@salesforce/schema/Route__c';
import ROUTE_EQUIPMENT_OBJECT from '@salesforce/schema/Route_Equipment__c';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import CONTAINER_PNG from '@salesforce/resourceUrl/AddContainer';
import getAllRegularRoute from '@salesforce/apex/BAFCOLRoutingDetailsController.getAllRegularRoute';
import getRegularRouteData from '@salesforce/apex/BAFCOLRoutingDetailsController.getRegularRouteData';
import getDefualtValueForEnquiry from '@salesforce/apex/BAFCOLRoutingDetailsController.getDefualtValueForEnquiry';
export default class BAFCOAirFreightEnquiryIntake extends LightningElement {
    @api routeName;
    @api routingRegular;
    @api shipmentKind;
    @api serviceType;
    @api incoTerm;
    @api incoTermName;
    @api portLoading;
    @api portLoadingName;
    @api portDestination;
    @api portDestinationName;
    @api shippingLine;
    @api shippingLineName;
    @api placeOfPickup;
    @api placeOfDischarge;
    @api commodity;
    @api commodityName;
    @api cargoWeights;
    @api dangerousGoods;
    @api remarks;
    @api dgClass;
    @api leadIndex;
    @api containerRecord = [];
    @api showDGClassField;
    @api showPickupPlaceField;
    @api showDischargePlaceField;
    @api copyFromAbove;
    @api placeOfDischargeName = '';
    @api placeOfPickupName = '';
    @api shipmentKindClass='';
    @api serviceTypeClass='';
    @api incoTermClass='';
    @api portOfLoadingClass='';
    @api portOfDestinationClass='';
    @api commodityClass='';
    @api cargoweightClass='';
    @api pickupPlaceClass='';
    @api dischargePlaceClass='';
    @track regularRouteOption=[];
    @track kindOfShipmentOption =[];
    @track serviceTypeOption=[];
    @track dgClassOption=[];
    @api leadEnquiryList = [];
    @api disableAddRoute = false;
    AddContainerPNG = CONTAINER_PNG;
    @api accountId = '';
    @track isAccountObject = false;
    @track isLoading = false;
    @track disableIncoField =  false; 
    @track hidePOL = false;
    @track hidePOD = false;
    @api businessType= '';
    @track hideShippingLine = false;
    @track disableServiceType = false;
    @api isEdit;
    @api isAir;
    @track portObject = 'Port__c';
    @track loadigPortLabel = 'Port of Loading';
    @track destinationPortLabel = 'Port of Destination';
    @api cargoReadiness = '';
    @track isImport = false;
    @api minDate = '';
    @track shippLineObject = 'Shipping_Line__c';
    @track shippLinePlaceHolder = 'Search Shipping Line';
    @track shippLinePlaceLabel = 'Shipping Line';
    @track displayAddPackage = true;
    @api palletized = false;
    @api stackable = false;
    @track isLCL = false;
    @track UOMOption = [];
    @track isAirEnquiry = false;
    @api palletizedParent = false;
    @api stackableParent = false;


    @track width;

    @wire(getPicklistValuesByRecordType, { objectApiName: ROUTE_OBJECT, recordTypeId: '012000000000000AAA' })
    routeObjectData({ data, error }) {
        if(data){
            console.log('****** '+JSON.stringify(data.picklistFieldValues,null,2))
            this.kindOfShipmentOption = data.picklistFieldValues.Kind_Of_Shipment__c.values;
            this.serviceTypeOption = data.picklistFieldValues.Service_Type__c.values;
            this.dgClassOption = data.picklistFieldValues.DG_Class__c.values;
            this.updateEnquiryList();
        }
        else if(error){
            console.log(' Route Object data error', JSON.stringify(error, null, 2));
        }
    }
    @wire(getPicklistValuesByRecordType, { objectApiName: ROUTE_EQUIPMENT_OBJECT, recordTypeId: '012000000000000AAA' })
    routeEQuipObjectData({ data, error }) {
        if(data){
            //console.log('data.picklistFieldValues '+JSON.stringify(data.picklistFieldValues,null,2))
            this.UOMOption = data.picklistFieldValues.UOM__c.values;
        }
        else if(error){
            console.log(' Route Equipment Object data error', JSON.stringify(error, null, 2));
        }
    }

    connectedCallback(){
        if(this.businessType == 'Import') this.isImport = true;
        if(this.isAir == 'true'){
            this.portObject = 'Airport__c';
            this.loadigPortLabel = 'Airport of Loading';
            this.destinationPortLabel = 'Airport of Destination';
            this.shippLineObject = 'Airline__c';
            this.shippLinePlaceHolder = 'Search Airline Line';
            this.shippLinePlaceLabel = 'Airline';
           if(this.businessType == 'Import') this.displayAddPackage = false;
           this.isAirEnquiry  = true;
        }
        else{
            this.portObject = 'Port__c';
            this.loadigPortLabel = 'Port of Loading';
            this.destinationPortLabel = 'Port of Destination';
            this.shippLineObject = 'Shipping_Line__c';
            this.shippLinePlaceHolder = 'Search Shipping Line';
            this.shippLinePlaceLabel = 'Shipping Line';
            this.displayAddPackage = true;
            this.isLCL = true;
            this.isAirEnquiry  = false;
        }
        if(this.accountId.startsWith('001')){
            this.isAccountObject = true;
            this.getAllRegularRoute();
        }
        if(this.isEdit == 'true'){
            this.routeDefaultValueAssignment();
        }
        else{
            this.getDefualtValueForEnquiry();
        }
    }
    routeDefaultValueAssignment(){
        console.log('lewelew '+this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component').length)
        setTimeout(() => {
            if(this.incoTerm!= undefined){
                let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[0];
                let Obj={Id:this.incoTerm,Name:this.incoTermName}
                if(field != null || field != undefined) field.handleDefaultSelected(Obj);
            }
            //if(this.incoTermName == 'Local Operation') this.handleLocalInco();
            if(this.isAirEnquiry == true){
                if(this.hidePOL == false && this.portLoading != ''){
                    let field = this.template.querySelectorAll('c-b-a-f-c-o-airport-custom-lookup')[0];
                    let Obj={Id:this.portLoading,Name:this.portLoadingName,index:this.leadIndex}
                    field.handleDefaultSelected(Obj);
                }
                if(this.hidePOD == false && this.portDestination != ''){
                    let field = this.template.querySelectorAll('c-b-a-f-c-o-airport-custom-lookup')[1];
                    let Obj={Id:this.portDestination,Name:this.portDestinationName,index:this.leadIndex}
                    field.handleDefaultSelected(Obj);
                }
                if(this.hideShippingLine == false && this.shippingLine != ''){
                    let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[1];
                    let Obj={Id:this.shippingLine,Name:this.shippingLineName,index:this.leadIndex}
                    field.handleDefaultSelected(Obj);
                }
                if(this.commodity != ''){
                    let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[2];
                    let Obj={Id:this.commodity,Name:this.commodityName}
                    if(field != null || field != undefined) field.handleDefaultSelected(Obj);
                }
            }
            else{
                if(this.hidePOL == false && this.portLoading != ''){
                    let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[1];
                    let Obj={Id:this.portLoading,Name:this.portLoadingName,index:this.leadIndex}
                    field.handleDefaultSelected(Obj);
                }
                if(this.hidePOD == false && this.portDestination != ''){
                    let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[2];
                    let Obj={Id:this.portDestination,Name:this.portDestinationName,index:this.leadIndex}
                    field.handleDefaultSelected(Obj);
                }
                if(this.hideShippingLine == false && this.shippingLine != ''){
                    let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[3];
                    let Obj={Id:this.shippingLine,Name:this.shippingLineName,index:this.leadIndex}
                    field.handleDefaultSelected(Obj);
                }
                if(this.commodity != ''){
                    let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[4];
                    let Obj={Id:this.commodity,Name:this.commodityName}
                    if(field != null || field != undefined) field.handleDefaultSelected(Obj);
                }
            }
            if(this.serviceType != ''){
                if(this.serviceType == 'Ex-Works'){
                    this.showPickupPlaceField = true;
                    this.showDischargePlaceField = true;
                    let field2 = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[0];
                    field2.handleRemovePill();
                    this.incoTerm = '';
                    this.incoTermName = '';
                }
                else{
                    this.showPickupPlaceField = true;
                    this.showDischargePlaceField = true;                
                    if(this.serviceType == 'D2P' || this.serviceType ==  'D2D'){
                        this.showPickupPlaceField = true;
                    }
                    else{
                        this.showPickupPlaceField = false;
                    }
                    if(this.serviceType == 'P2D' || this.serviceType ==  'D2D'){
                        this.showDischargePlaceField = true;
                    }
                    else{
                        this.showDischargePlaceField = false;
                    }
                }
            }
        }, 100);
    }
    @api getDefualtValueForEnquiry(){
        this.isLoading = true 
        this.isImport = false;
        this.cargoReadiness = '';
        getDefualtValueForEnquiry()
        .then(result=>{
            console.log(' getDefualtValueForEnquiry result', JSON.stringify(result, null, 2));
            if(result != null){
                //this.displayIncoChanges();   
                setTimeout(() => {
                    this.serviceType = '';
                    if(result.commodityId != undefined){
                        let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[4];
                        let Obj={Id:result.commodityId,Name:result.commodityName}
                        if(field != null || field != undefined) field.handleDefaultSelected(Obj);
                    }
                    /*if(result.incoTermId != undefined){
                        let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[0];
                        let Obj={Id:result.incoTermId,Name:result.incoTermName}
                        if(field != null || field != undefined) field.handleDefaultSelected(Obj);
                    }*/
                    //if(this.incoTermName == 'Clearance and Delivery' || this.incoTermName == 'Local Operation') this.handleLocalInco();
                }, 200);
                this.disableAddRoute = false;
                this.disableIncoField = false;
                this.displayAddPackage = true;
            }
            this.updateEnquiryList();
            this.isLoading = false;
        })
        .catch(error=>{
            console.log(' getDefualtValueForEnquiry error', JSON.stringify(error, null, 2));
            this.isLoading = false;
        })
    }

    getAllRegularRoute(){
        getAllRegularRoute({AccountId : this.accountId})
        .then(result=>{
            let templist = [];
            templist.push({
                label:'-None-',
                value:''
            })
            result.forEach(elem=>{
                templist.push({
                    label:elem.Name,
                    value:elem.Id
                })
            })
            this.regularRouteOption = templist;
        })
        .catch(error=>{
            console.log('getAllRegularRoute error: ',error)
        })
    }
    handleRegularRouteChange(event){
        let index = event.target.dataset.recordId;
        let regularValue = event.target.value;
        this.routingRegular = regularValue;
        this.getRegularRouteData(index,regularValue);
        this.updateEnquiryList();
    }
    getRegularRouteData(index,rgID){
        getRegularRouteData({rgID:rgID})
        .then(result=>{
            console.log('rsult ',JSON.stringify(result,null,2))
           this.serviceType = result.Service_Type__c != undefined ? result.Service_Type__c : '';
            this.incoTerm = result.INCO_Term__c != undefined ? result.INCO_Term__c : '';
            this.portLoading = result.Port_of_Loading__c != undefined ? result.Port_of_Loading__c : '';
            this.portDestination = result.Port_of_Destination__c != undefined ? result.Port_of_Destination__c : '';
            this.shippingLine = result.Shipping_Line__c != undefined ? result.Shipping_Line__c : '';
            this.commodity = result.Commodity__c != undefined ? result.Commodity__c : '';
            this.dangerousGoods = result.Dangerous_Goods__c != undefined ? result.Dangerous_Goods__c : '';
            this.shipmentKind = 'FCL';
            this.placeOfPickup = result.Pickup_Place__c != undefined ? result.Pickup_Place__c : '';
            this.placeOfDischarge = result.Discharge_Place__c != undefined ? result.Discharge_Place__c : '';
            let incoTermfield = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[0];
            let polfield = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[1];
            let podfield = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[2];
            let shipfield = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[3];
            let commodityfield = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[4];
            if(result.Dangerous_Goods__c == true){
                this.showDGClassField = true;
                this.dgClass = result.DG_Class__c != undefined ? result.DG_Class__c : '';
            }
            if(this.incoTerm != ''){
                let Obj={Id:result.INCO_Term__c,Name:result.INCO_Term__r.Name}
                if(incoTermfield != null) incoTermfield.handleDefaultSelected(Obj);
            }
            else{
                if(incoTermfield != null) incoTermfield.handleRemovePill();
            }
            if(result.Port_of_Loading__c != undefined){
                let Obj={Id:result.Port_of_Loading__c,Name:result.Port_of_Loading__r.Name,index:index}
                polfield.handleDefaultSelected(Obj);
            }
            else{
                polfield.handleRemovePill();
            }
            if(result.Port_of_Destination__c != undefined){                
                let Obj={Id:result.Port_of_Destination__c,Name:result.Port_of_Destination__r.Name,index:index}
                podfield.handleDefaultSelected(Obj);
            }
            else{
                podfield.handleRemovePill();
            }
            if(result.Shipping_Line__c != undefined){                
                let Obj={Id:result.Shipping_Line__c,Name:result.Shipping_Line__r.Name,index:index}
                shipfield.handleDefaultSelected(Obj);
            }
            else{
                shipfield.handleRemovePill();
            }
            if(result.Commodity__c != undefined){                
                let Obj={Id:result.Commodity__c,Name:result.Commodity__r.Name,index:index}
                commodityfield.handleDefaultSelected(Obj);
            }
            else{
                commodityfield.handleRemovePill();
            }
            if(this.serviceType  == 'D2P' || this.serviceType  == 'D2D'){
                this.showPickupPlaceField = true;    
            }
            if(this.serviceType  == 'P2D' || this.serviceType  == 'D2D'){
                this.showDischargePlaceField = true;
            }

            setTimeout(() => {
                this.shipmentKindClass = '';
                this.serviceTypeClass = '';
                this.incoTermClass = '';
                this.portOfLoadingClass = '';
                this.portOfDestinationClass = '';
                this.commodityClass = '';
                this.dischargePlaceClass = '';
                this.pickupPlaceClass = '';
                this.updateEnquiryList();
            }, 500);
        
        })
        .catch(error=>{
            console.log('error '+error)
        })
    }
    @api updateEnquiryList(){
        let leadEntryDto = {
             'shipmentKind':this.shipmentKind,
             'serviceType':this.serviceType,
             'incoTerm':this.incoTerm,
             'leadIndex':this.leadIndex,
             'routingRegular':this.routingRegular,
             'portLoading':this.portLoading,
             'portDestination':this.portDestination,
             'shippingLine':this.shippingLine,
             'showPickupPlaceField':this.showPickupPlaceField,
             'showDischargePlaceField':this.showDischargePlaceField,
             'placeOfPickup':this.placeOfPickup,
             'placeOfDischarge':this.placeOfDischarge,
             'commodity':this.commodity,
             'cargoWeights':this.cargoWeights,
             'remarks':this.remarks,
             'dgClass':this.dgClass,
             'dangerousGoods':this.dangerousGoods,
             'showDGClassField':this.showDGClassField,
             'incoTermName':this.incoTermName,
             'portLoadingName':this.portLoadingName,
             'portDestinationName':this.portDestinationName,
             'shippingLineName':this.shippingLineName,
             'commodityName':this.commodityName,
             'placeOfPickupName':this.placeOfPickupName,
             'placeOfDischargeName':this.placeOfDischargeName,
             'containerRecord':this.containerRecord,
             'shipmentKindClass':this.shipmentKindClass,
             'serviceTypeClass':this.serviceTypeClass,
             'incoTermClass':this.incoTermClass,
             'portOfLoadingClass':this.portOfLoadingClass,
             'portOfDestinationClass':this.portOfDestinationClass,
             'commodityClass':this.commodityClass,
             'cargoweightClass':this.cargoweightClass,
             'dischargePlaceClass':this.dischargePlaceClass,
             'pickupPlaceClass':this.pickupPlaceClass,
             'disableAddRoute':this.disableAddRoute,
             'cargoReadiness':this.cargoReadiness,
             'stackableParent':this.stackableParent,
             'palletizedParent':this.palletizedParent
         }
         let updateleadEntryDto = JSON.parse(JSON.stringify(leadEntryDto));
         console.log('updateleadEntryDto '+JSON.stringify(updateleadEntryDto,null,2))
         this.dispatchEvent(new CustomEvent('update', { detail: { dto: updateleadEntryDto } }));
     }
     handleIncoTermSelection(e){
        let incoTermID = e.detail.Id;
        this.incoTerm = incoTermID;
        this.incoTermName = e.detail.Name        
        this.incoTermClass ='';
        this.updateEnquiryList();
    }
    handleIncoTermRemoved(e){
        this.incoTerm = '';
        this.incoTermName = '';
        this.updateEnquiryList();
    }
    handleServiceType(e){
        let serviceType = e.target.value;
        this.serviceType = serviceType;
        if(serviceType == 'D2P' || serviceType ==  'D2D'){
            this.showPickupPlaceField = true;
        }
        else{
            this.showPickupPlaceField = false;
        }
        if(serviceType == 'P2D' || serviceType ==  'D2D'){
            this.showDischargePlaceField = true;
        }
        else{
           this.showDischargePlaceField = false;
        }
        this.placeOfPickup = '';
        this.placeOfDischarge = '';
        this.serviceTypeClass ='';
        this.updateEnquiryList();
    }
    handleLoadingPortSelectedSelection(e){
        let portLoading = e.detail.Id;
        this.portLoading = portLoading;
        this.portLoadingName = e.detail.Name
        this.portOfLoadingClass ='';
        this.updateEnquiryList();
    }
    handleLoadingPortRemoved(e){
        this.portLoading = '';
        this.portLoadingName = '';
        this.updateEnquiryList();
    }
    handleDestinationPortSelectedSelection(e){
        let portDestination = e.detail.Id;
        this.portDestination = portDestination;
        this.portDestinationName = e.detail.Name
        this.portOfDestinationClass ='';
        this.updateEnquiryList();
    }
    handleDestinationPortRemoved(e){
        this.portDestination = '';
        this.portDestinationName = '';
        this.updateEnquiryList();
    }
    handleShippingLineSelection(e){
        let shippingLine = e.detail.Id;
        this.shippingLine = shippingLine;
        this.shippingLineName = e.detail.Name
        this.updateEnquiryList();
    }
    handleShippingLineRemoved(e){
        this.shippingLine = '';
        this.shippingLineName ='';
        this.updateEnquiryList();
    }
    handleCommoditySelection(e){
        let commodity = e.detail.Id;
        this.commodity = commodity;
        this.commodityName = e.detail.Name
        this.commodityClass ='';
        this.updateEnquiryList();
    }
    handleCommodityRemoved(e){
        this.commodity = '';
        this.commodityName = '';
        this.updateEnquiryList();
    }
    handleDischargePlaceInputchange(e){
        this.placeOfDischarge = e.target.value
        this.dischargePlaceClass ='';
        this.updateEnquiryList();
    }
    handlePickupPlaceInputchange(e){
        this.placeOfPickup = e.target.value;
        this.pickupPlaceClass = '';
        this.updateEnquiryList();
    }
    handleDangeorusGood(e){
        let value = e.target.checked;
        this.dangerousGoods = value;
        if(value){
            this.showDGClassField = true;
        }
        else{
            this.showDGClassField = false;
        }
        this.dgClass = '';
    }
    handleDGClass(e){
        let dgClass = e.target.value;
        this.dgClass = dgClass;
        this.updateEnquiryList();
    }

    handleRemarkChange(e){
        let remarks = e.target.value;
        this.remarks = remarks;
        this.updateEnquiryList();
    }
    @api removeDefaultOnImport(){
        this.isLoading = true;      
        this.isImport = true;
        this.displayAddPackage =false;  
        let index = this.leadIndex+'.'+'1';
        let obj={
            "length": null,
            "width": null,
            "height": null,
            "CBM": null,
            "Weight": null,
            "volumeWeight":null,
            "index": index,
            "id": "",
            "lengthErrorClass": "",
            "widthErrorClass": "",
            "heightErrorClass": "",
            "CBMErrorClass": "",
            "WeightErrorClass": "",
            "unitsErrorClass": "",
            "units": "",
            "cargoDetails": "",
            "cargoDetailsError": "",
            'uomValue':'CM',
            'UOMErrorClass':'',
            'disableCBM':false,
            'CBMChanged':false
          }
          this.containerRecord = [];
          this.containerRecord.push(obj);
          //console.log('this.containerRecord '+JSON.stringify(this.containerRecord,null,2))
        setTimeout(() => {
            if(this.incoTermName != 'Clearance and Delivery' && this.incoTermName != 'Local Operation'){   
                let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[4];
                field.handleRemovePill();
                let field2 = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[0];
                field2.handleRemovePill();
            }
        }, 200); 
        this.shipmentKind = '';
        this.updateEnquiryList();
        this.isLoading = false;
    }
    handleCopyFromAbove(e){
        let index = e.target.dataset.recordId;
        if(this.businessType == 'Import') this.isImport = true;
        else this.isImport = false;
        this.leadEnquiryList.forEach(elem => {
            if(elem.leadIndex == 1) {
                this.shipmentKind = elem.shipmentKind;
                this.serviceType = elem.serviceType;
                this.incoTerm = elem.incoTerm;
                this.routingRegular = elem.routingRegular;
                this.portLoading = elem.portLoading;
                this.portDestination = elem.portDestination;
                this.shippingLine = elem.shippingLine;
                this.showPickupPlaceField = elem.showPickupPlaceField;
                this.showDischargePlaceField = elem.showDischargePlaceField;
                this.placeOfPickup = elem.placeOfPickup;
                this.placeOfDischarge = elem.placeOfDischarge;
                this.commodity = elem.commodity;
                this.cargoWeights = elem.cargoWeights;
                this.remarks = elem.remarks;
                this.dgClass = elem.dgClass;
                this.dangerousGoods = elem.dangerousGoods;
                this.showDGClassField = elem.showDGClassField;
                this.incoTermName = elem.incoTermName;
                this.portLoadingName = elem.portLoadingName;
                this.portDestinationName = elem.portDestinationName;
                this.shippingLineName = elem.shippingLineName;
                this.commodityName = elem.commodityName;
                this.placeOfPickupName = elem.placeOfPickupName;
                this.placeOfDischargeName = elem.placeOfDischargeName;
                this.cargoReadiness = elem.cargoReadiness;
            }
        })

        if(this.incoTerm != ''){
            let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[0];
            let Obj={Id:this.incoTerm,Name:this.incoTermName}
            if(field != null) field.handleDefaultSelected(Obj);
        }
        if(this.portLoading != ''){
            let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[1];
            let Obj={Id:this.portLoading,Name:this.portLoadingName}
            field.handleDefaultSelected(Obj);
        }
        if(this.portDestination != ''){
            let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[2];
            let Obj={Id:this.portDestination,Name:this.portDestinationName}
            field.handleDefaultSelected(Obj);
        }
        if(this.shippingLine != ''){
            let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[3];
            let Obj={Id:this.shippingLine,Name:this.shippingLineName}
            field.handleDefaultSelected(Obj);
        }
        if(this.commodity != ''){
            let field = this.template.querySelectorAll('c-b-a-f-c-o-custom-look-up-component')[4];
            let Obj={Id:this.commodity,Name:this.commodityName}
            field.handleDefaultSelected(Obj);
        }
        if(this.serviceType  == 'D2P' || this.serviceType  == 'D2D'){
            this.showPickupPlaceField = true;
        }
        if(this.serviceType  == 'P2D' || this.serviceType  == 'D2D'){
            this.showDischargePlaceField = true;
        }
        let containerData = this.leadEnquiryList[0].containerRecord;
       let copyCObj={
        'index':index,
        'size': containerData.length
       }
       this.dispatchEvent(new CustomEvent('addemptycontainertype', { detail:  copyCObj}));
       for(let i=0 ;i<containerData.length;i++){
        setTimeout(() => {
            this.handleCopyData(containerData[i],index);
        }, 500);
       }
        setTimeout(() => {
            this.shipmentKindClass = '';
            this.serviceTypeClass = '';
            this.incoTermClass = '';
            this.portOfLoadingClass = '';
            this.portOfDestinationClass = '';
            this.commodityClass = '';
            this.dischargePlaceClass = '';
            this.pickupPlaceClass = '';
            this.updateEnquiryList();
        }, 2000);
    }
    handleCopyData(containerRecord,i){
        //console.log('# containerRecord' +JSON.stringify(containerRecord,null,2))
        let initalIndex = containerRecord.index;
        let spitInitalIndex = initalIndex.split('.');
        let cameIndex = i;
        let finalIndex = cameIndex+'.'+spitInitalIndex[1]        
        let obj={
                'index':finalIndex,
                'length':containerRecord.length,
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('lengthupdate', { detail: { dto: containerDto } }));
        let obj2={
            'index':finalIndex,
            'width':containerRecord.width,
        }
        let containerDto2 = JSON.parse(JSON.stringify(obj2));
        this.dispatchEvent(new CustomEvent('widthupdate', { detail: { dto: containerDto2 } })); 
        let obj3={
            'index':finalIndex,
            'height':containerRecord.height,
        }
        let containerDto3 = JSON.parse(JSON.stringify(obj3));
        this.dispatchEvent(new CustomEvent('heightupdate', { detail: { dto: containerDto3 } })); 
        let obj4={
            'index':finalIndex,
            'cbm':containerRecord.CBM,
        }
        let containerDto4 = JSON.parse(JSON.stringify(obj4));
        this.dispatchEvent(new CustomEvent('cbmupdate', { detail: { dto: containerDto4 } })); 
        let obj5={
            'index':finalIndex,
            'weight':containerRecord.Weight,
        }
        let containerDto5 = JSON.parse(JSON.stringify(obj5));
        this.dispatchEvent(new CustomEvent('weightupdate', { detail: { dto: containerDto5 } })); 
        let obj8={
            'index':finalIndex,
            'units':containerRecord.units,
        }
        let containerDto8 = JSON.parse(JSON.stringify(obj8));
        this.dispatchEvent(new CustomEvent('unitsupdate', { detail: { dto: containerDto8 } })); 
        let obj9={
            'index':finalIndex,
            'cargoDetails':containerRecord.cargoDetails,
        }
        let containerDto9 = JSON.parse(JSON.stringify(obj9));
        this.dispatchEvent(new CustomEvent('cargodetailsupdate', { detail: { dto: containerDto9 } })); 
        let obj10={
            'index':finalIndex,
            'uom':containerRecord.uomValue,
        }
        let containerDto10 = JSON.parse(JSON.stringify(obj10));
        this.dispatchEvent(new CustomEvent('uomupdate', { detail: { dto: containerDto10 } }));
        let obj11={
            'index':finalIndex,
            'uom':containerRecord.volumeWeight,
        }
        let containerDto11 = JSON.parse(JSON.stringify(obj11));
        this.dispatchEvent(new CustomEvent('volumeweightupdate', { detail: { dto: containerDto11 } }));
    }
    handlelengthChange(e){
        let index = e.target.dataset.recordId;
        let value = e.target.value;
        let obj={
            'index':index,
            'length':value,
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('lengthupdate', { detail: { dto: containerDto } }));     
        this.handleCBMUpdate(index); 
    }
    handleWidthChange(e){
        let index = e.target.dataset.recordId;
        let value = e.target.value;
        let obj={
            'index':index,
            'width':value,
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('widthupdate', { detail: { dto: containerDto } })); 
        this.handleCBMUpdate(index);
    }
    handleHeightChange(e){
        let index = e.target.dataset.recordId;
        let value = e.target.value;
        let obj={
            'index':index,
            'height':value,
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('heightupdate', { detail: { dto: containerDto } })); 
        this.handleCBMUpdate(index);
    }
    handleCBMChange(e){
        let index = e.target.dataset.recordId;
        let value = e.target.value;
        let obj={
            'index':index,
            'cbm':value,
            'userChanged':true
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('cbmupdate', { detail: { dto: containerDto } })); 
        this.handleVolumeWeight(index,value);
    }
    handleUOMChange(e){
        let index = e.target.dataset.recordId;
        let value = e.target.value;
        let obj={
            'index':index,
            'uom':value,
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('uomupdate', { detail: { dto: containerDto } })); 
        this.handleCBMUpdate(index);
    }
    handleCBMUpdate(index){
        let containerIndex = this.containerRecord.findIndex(elem=>elem.index == index);
        let ccRecord = this.containerRecord[containerIndex];
        let lenght = null;
        let width = null;
        let height = null;
        let cbm = null;
        if(ccRecord.length > 0 || ccRecord.width > 0 || ccRecord.height){
            console.log('came here 1')
            lenght  = ccRecord.length > 0 ? ccRecord.length : 1;
            width  = ccRecord.width > 0 ? ccRecord.width : 1;
            height  = ccRecord.height > 0 ? ccRecord.height : 1;
        }
        cbm =  lenght * width * height;
        if(ccRecord.uomValue == 'CM')  cbm = cbm/1000000;
        else if(ccRecord.uomValue == 'Inch') cbm = cbm/61023;
        cbm = cbm.toFixed(2);
        let allNull = false;
        console.log('lenght'+lenght)
        console.log('width'+width)
        console.log('height'+height)

        if(lenght == null && width == null && height == null){allNull = true}
        let obj={
            'index':index,
            'cbm':cbm,
            'allNull':allNull
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('cbmupdate', { detail: { dto: containerDto } })); 
        this.handleVolumeWeight(index,cbm);
    }
    handleVolumeWeight(index,cbm){
        let volumeWeight = cbm * 167;
        let obj={
            'index':index,
            'volumeWeight':volumeWeight,
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('volumeweightupdate', { detail: { dto: containerDto } })); 
    }
    handleWeightChange(e){
        let index = e.target.dataset.recordId;
        let value = e.target.value;
        let obj={
            'index':index,
            'weight':value,
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('weightupdate', { detail: { dto: containerDto } })); 
    }
    handleStackableChange(e){
        let index = e.target.dataset.recordId;
        let value = e.target.checked;
        let obj={
            'index':index,
            'stackable':value,
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('stackableupdate', { detail: { dto: containerDto } }));
    }
    handlePalletizedChange(e){
        let index = e.target.dataset.recordId;
        let value = e.target.checked;
        let obj={
            'index':index,
            'palletized':value,
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('palletizedupdate', { detail: { dto: containerDto } }));
    }
    handleUnitsChange(e){
        let index = e.target.dataset.recordId;
        let value = e.target.value;
        let obj={
            'index':index,
            'units':value,
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('unitsupdate', { detail: { dto: containerDto } })); 
    }
    handleCargoDetailsChange(e){
        let index = e.target.dataset.recordId;
        let value = e.target.value;
        let obj={
            'index':index,
            'cargoDetails':value,
        }
        let containerDto = JSON.parse(JSON.stringify(obj));
        this.dispatchEvent(new CustomEvent('cargodetailsupdate', { detail: { dto: containerDto } }));
    }
    handleAddContainer(e){
        let strIndex = e.target.dataset.recordId;
        this.dispatchEvent(new CustomEvent('addcontainertype', { detail:  strIndex}));
    }
    handleRemoveContainer(e){
        let strIndex = e.target.dataset.recordId;
        this.dispatchEvent(new CustomEvent('removecontainertype', { detail:  strIndex}));
    }
    handelCargoReadinessDate(e){
        this.cargoReadiness = e.target.value;
        this.updateEnquiryList();
    }
    handleStackableParentChange(e){
        console.log('came  '+e.target.checked)
        this.stackableParent = e.target.checked;
        console.log('this.stackable  '+this.stackableParent)
        this.updateEnquiryList();
    }
    handlePalletizedParentChange(e){
        console.log('came  '+e.target.checked)
        this.palletizedParent = e.target.checked;
        console.log('this.palletized  '+this.palletizedParent)
        this.updateEnquiryList();
    }
}