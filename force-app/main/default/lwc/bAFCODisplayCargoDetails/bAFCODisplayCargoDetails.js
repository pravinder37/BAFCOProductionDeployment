import { LightningElement,api,wire,track } from 'lwc';
import getRouteEquipmentDetails from '@salesforce/apex/BAFCOLeadDetailsController.getRouteEquipmentDetails';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import ROUTE_EQUIPMENT_OBJECT from '@salesforce/schema/Route_Equipment__c';
import updateRouteEquipmentDetails from '@salesforce/apex/BAFCOLeadDetailsController.updateRouteEquipmentDetails';
export default class BAFCODisplayCargoDetails extends LightningElement {
    @api routeId = '';
    @api isOrder = false;
    @track routeEquipList =[];
    isLoading = false;
    totalCBM = null;
    totalGross = null;
    totalVolumeWeight = null;
    isShowModal = false;
    @track UOMOption = [];
    @track containerRemoveList = [];
    totalCBMUpdate = null
    totalGrossUpdate = null
    totalVolumeWeightUpdate = null

    @wire(getPicklistValuesByRecordType, { objectApiName: ROUTE_EQUIPMENT_OBJECT, recordTypeId: '012000000000000AAA' })
    routeEQuipObjectData({ data, error }) {
        if(data){
           this.UOMOption = data.picklistFieldValues.UOM__c.values;
        }
        else if(error){
            console.log(' Route Equipment Object data error', JSON.stringify(error, null, 2));
        }
    }
    connectedCallback(){
        if(this.routeId != '') this.getRouteEquipmentDetails();
    }
    hideModalBox(){
        this.dispatchEvent(new CustomEvent('close'));
    }
    getRouteEquipmentDetails(){
        this.isLoading = true;
        getRouteEquipmentDetails({routeId : this.routeId})
        .then(result=>{
            console.log('getRouteEquipmentDetails result , '+JSON.stringify(result,null,2))
            this.routeEquipList = result;
            let tempvar = this.routeEquipList;
            let index = 1;
            this.routeEquipList = tempvar.map(row => ({
                ...row,
                index:index++,
                UOMErrorClass:'',
                CBMChanged:false,
                disableCBM:false,
                lengthErrorClass:'',
                widthErrorClass:'',
                heightErrorClass:'',
                CBMErrorClass:'',
                WeightErrorClass:'',
                unitsErrorClass:'',
               }));
               this.totalCBM = this.routeEquipList[0].Route__r.Total_CBM__c > 0 ? this.routeEquipList[0].Route__r.Total_CBM__c.toFixed(3) : 0;
               this.totalGross = this.routeEquipList[0].Route__r.Total_Gross_Weight_KGs__c > 0 ? this.routeEquipList[0].Route__r.Total_Gross_Weight_KGs__c : 0;
               this.totalVolumeWeight = this.routeEquipList[0].Route__r.Total_Volumetric_Weight__c > 0 ? this.routeEquipList[0].Route__r.Total_Volumetric_Weight__c : 0;
               this.handleTotalField();
            this.isLoading = false;
        })
        .catch(error=>{
            console.log('getRouteEquipmentDetails error , '+JSON.stringify(error,null,2))
            this.isLoading = false;
        })
    }
    hideEditClicked(){
        this.isShowModal = true;
    }
    hideModalBox2(){
        this.isShowModal = false;
    }
    handleUOMChange(e){
        let index = e.target.dataset.recordId;
        let contrIndex =this.routeEquipList.findIndex(x=>x.index == index);
        this.routeEquipList[contrIndex].UOM__c = e.target.value;
        this.handleCBMUpdate(index);
    }
    handlelengthChange(e){
        let index = e.target.dataset.recordId;
        console.log('index '+index)
        let contrIndex =this.routeEquipList.findIndex(x=>x.index == index);
        this.routeEquipList[contrIndex].Length__c = e.target.value;
        this.handleCBMUpdate(index);
    }    
    handleWidthChange(e){
        let index = e.target.dataset.recordId;
        let contrIndex =this.routeEquipList.findIndex(x=>x.index == index);
        this.routeEquipList[contrIndex].Width__c = e.target.value;
        this.handleCBMUpdate(index);
    }
    handleHeightChange(e){
        let index = e.target.dataset.recordId;
        let contrIndex =this.routeEquipList.findIndex(x=>x.index == index);
        this.routeEquipList[contrIndex].Height__c = e.target.value;
        this.handleCBMUpdate(index);
    }
    handleCBMChange(e){
        let index = e.target.dataset.recordId;
        let contrIndex =this.routeEquipList.findIndex(x=>x.index == index);
        this.routeEquipList[contrIndex].CBM__c = e.target.value;
        if(e.target.value > 0) {
            this.routeEquipList[contrIndex].CBMChanged = true;
            this.handleVolumeWeight(index,e.target.value);
        }
        else this.routeEquipList[contrIndex].CBMChanged = false;
    }
    handleWeightChange(e){
        let index = e.target.dataset.recordId;
        let contrIndex =this.routeEquipList.findIndex(x=>x.index == index);
        this.routeEquipList[contrIndex].Weight_Kgs__c = e.target.value;
        this.handleTotalField();
    }
    handleUnitsChange(e){
        let index = e.target.dataset.recordId;
        let contrIndex =this.routeEquipList.findIndex(x=>x.index == index);
        this.routeEquipList[contrIndex].Units__c = e.target.value;
        this.handleTotalField();
    }
    handleRemoveContainer(e){
        let index = e.target.dataset.recordId;
        console.log('index '+index)
        let remIndex = this.routeEquipList.findIndex(x=>x.index == index)
        console.log('remIndex '+remIndex)
        if(remIndex != -1){
            if(this.routeEquipList[remIndex].Id != '')  this.containerRemoveList.push(this.routeEquipList[remIndex].Id)
            this.routeEquipList.splice( remIndex, 1 );
        }
        
    }
    updateDataClicked(){
        updateRouteEquipmentDetails({
            routeEquipList : this.routeEquipList,
            containerRemoveList : this.containerRemoveList,
            totalCBMUpdate : this.totalCBMUpdate,
            totalGrossUpdate : this.totalGrossUpdate,
            totalVolumeWeightUpdate : this.totalVolumeWeightUpdate,
            routeId : this.routeId
        })
        .then(result=>{
            this.isShowModal = false;
            this.getRouteEquipmentDetails();
        })
        .catch(error=>{
            console.log('ccccc '+JSON.stringify(error,null,2))
        })
    }
    handleAddContainer() {
        let index = 0;
        if(this.routeEquipList.length > 0 ){
        let lastElem = this.routeEquipList.length - 1;
            index = this.routeEquipList[lastElem].index;
            index = index+1;
        }
        let myNewElement = {
            UOM__c: "CM",
            Length__c: null,
            Width__c: null,
            Height__c: null,
            CBM__c: null,
            Weight_Kgs__c: null,
            Units__c: 1,
            Volumetric_weight_Kgs__c:null,
            Route__c:this.routeId,
            index:index,
            UOMErrorClass:'',
            CBMChanged:false,
            disableCBM:false,
            lengthErrorClass:'',
            widthErrorClass:'',
            heightErrorClass:'',
            CBMErrorClass:'',
            WeightErrorClass:'',
            unitsErrorClass:'',
            };
        this.routeEquipList = [...this.routeEquipList, myNewElement];
        console.log('routeEquipList '+JSON.stringify(this.routeEquipList,null,2))
    }
    handleCBMUpdate(index){
        let containerIndex = this.routeEquipList.findIndex(elem=>elem.index == index);
        let ccRecord = this.routeEquipList[containerIndex];
        let lenght = null;
        let width = null;
        let height = null;
        let cbm = null;
        if(ccRecord.Length__c > 0 || ccRecord.Width__c > 0 || ccRecord.Height__c){
            lenght  = ccRecord.Length__c > 0 ? ccRecord.Length__c : 1;
            width  = ccRecord.Width__c > 0 ? ccRecord.Width__c : 1;
            height  = ccRecord.Height__c > 0 ? ccRecord.Height__c : 1;
        
        cbm =  lenght * width * height;
        console.log('uomValue'+ccRecord.uomValue);
        console.log('uomValue 2'+ccRecord.UOM__c);
        if(ccRecord.UOM__c == 'CM')  cbm = cbm/1000000;
        else if(ccRecord.UOM__c == 'Inch') cbm = cbm/61023;
        console.log('cbm Before'+cbm);
        cbm = cbm.toFixed(2);
        console.log('cbm After'+cbm);
        this.routeEquipList[containerIndex].CBM__c = cbm;
        this.routeEquipList[containerIndex].disableCBM = true;
        this.handleVolumeWeight(index,cbm);
        }
        if(lenght == null && width == null && height == null){
            this.routeEquipList[containerIndex].disableCBM = false;
        }
    }
    handleVolumeWeight(index,cbm){
        let containerIndex = this.routeEquipList.findIndex(elem=>elem.index == index);
        this.routeEquipList[containerIndex].Volumetric_weight_Kgs__c = cbm * 167;
        this.handleTotalField();
    }
    handleTotalField(){
        let totalCBM = 0;
        let totalGross = 0;
        let totalVolumeWeight = 0;
        this.routeEquipList.forEach(elem2=>{
            console.log('elem '+JSON.stringify(elem2,null,2))
            let units = elem2.Units__c > 0 ? elem2.Units__c : 1;
            if(elem2.Weight_Kgs__c > 0){
                totalGross = parseFloat(parseFloat(totalGross) + (parseFloat(elem2.Weight_Kgs__c) * units))
            }
            if(elem2.CBM__c > 0){
                totalCBM = parseFloat(parseFloat(totalCBM) + (parseFloat(elem2.CBM__c)* units))
            }
            if(elem2.Volumetric_weight_Kgs__c > 0){
                totalVolumeWeight = parseFloat(parseFloat(totalVolumeWeight) + (parseFloat(elem2.Volumetric_weight_Kgs__c)* units))
            }
        })
        this.totalCBMUpdate = totalCBM > 0 ? totalCBM.toFixed(3) : null;
        this.totalGrossUpdate = totalGross > 0 ? totalGross.toFixed(2) : null;
        this.totalVolumeWeightUpdate = totalVolumeWeight > 0 ? totalVolumeWeight.toFixed(2) : null;
    }
}