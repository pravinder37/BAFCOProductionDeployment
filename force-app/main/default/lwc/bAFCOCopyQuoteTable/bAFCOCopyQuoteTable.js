import { LightningElement,api,track } from 'lwc';
import getQuoteDataOnLoad from '@salesforce/apex/BAFCOQuoteCopyContentController.getQuoteDataOnLoad';
export default class BAFCOCopyQuoteTable extends LightningElement {
    @api recordId = '';
    @track tableData =[];
    @track isExport = false;
    @track isImport = false;
    @track Header = '';
    @track HeaderList = [];
    @track inclHeader = '';
    @track inclHeaderList = [];
    @track havePickupPlace = false;
    @track haveDischargePlace = false;
    connectedCallback(){
        this.getQuoteDataOnLoad();
    }
    getQuoteDataOnLoad(){
        getQuoteDataOnLoad({quoteId : this.recordId})
        .then(result=>{
            console.log('getQuoteDataOnLoad result ** 48 '+JSON.stringify(result,null,2));
            this.tableData = result;
            let recordtype = result[0].recordtypeName;
            this.tableData.forEach(elem=>{
                if(elem.placeOfPickup != '-') this.havePickupPlace = true;
                if(elem.placeOfDischarge != '-') this.haveDischargePlace = true;
            })
            if(recordtype == 'Export'){ 
                this.isExport = true;
                this.Header = result[0].exportHeader;
                this.HeaderList = result[0].exportHeaderList;
                this.inclHeader = result[0].header;
                this.inclHeaderList = result[0].headerList;
            }
            else if(recordtype == 'Import'){
                 this.isImport = true;
                 this.header = result[0].header;
                 this.headerList = result[0].headerList;
            }
        })
        .catch(error=>{
            console.log('getQuoteDataOnLoad error'+JSON.stringify(error,null,2))
        })
    }
}