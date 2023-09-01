import { LightningElement,api,wire, track } from 'lwc';
import getQuoteDataOnLoad from '@salesforce/apex/BAFCOQuoteCopyContentController.getQuoteDataOnLoad';
import {CurrentPageReference} from 'lightning/navigation';
export default class BAFCOCopyQuoteItem extends LightningElement {
    @api recordId;
    @track tableData =[];
    @track isExport = false;
    @track isImport = false;
    @track Header = '';
    @track HeaderList = [];
    @track inclHeader = '';
    @track inclHeaderList = [];
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
        }
    }
    @api invoke() {
        this.getQuoteDataOnLoad();
      }
    getQuoteDataOnLoad(){
        getQuoteDataOnLoad({quoteId : this.recordId})
        .then(result=>{
            console.log('getQuoteDataOnLoad result ** 48 '+JSON.stringify(result,null,2));
            this.tableData = result;
            let recordtype = result[0].recordtypeName;
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
            console.log('isExport '+this.isExport)
            console.log('isImport '+this.isImport)
            let urlField = this.template.querySelector("[data-field='sellingRateField']");
            let range = document.createRange();
            range.selectNode(urlField)
            window.getSelection().addRange(range) 
            document.execCommand('copy')
            /*if(result != null){
                let content = 'Dear Valued Client,\n\nThank you for giving Bafco International the opportunity to quote for your order.';
                content +='\n\nPlease find below the details:\n';

                content +='Port of loading    Port of Discharge   Equiment type   Service Type  Inco Term   Total'
                if(result.length > 0){
                    result.forEach(elem => {
                        content += 'Port of Loading: '+elem.loadingPort;
                        content += '\nPort of Discharge: '+elem.dischargePort;
                        content += '\nEquipment Type: '+elem.equipmentType;
                        content += '\nService Type: '+elem.serviceType;
                        content += '\nINCO Term: '+elem.incoterm;
                        content += '\nFreetime at POD: '+elem.freeTimePOD;
                        content += '\nFreetime at POL: '+elem.freeTimePOL;
                        content += '\nTotal: '+elem.currencyCode+' '+elem.total;
                        content += '\n\n';
                        content += elem.loadingPort+'              '+ elem.dischargePort+'              '+ elem.equipmentType+'           '+ elem.serviceType+'         '+ elem.incoterm+'         '+ elem.currencyCode+' '+elem.total;
                    });
                    content +='\nWe look forward to a positive response from your end.';
                    let recordtype = result[0].recordtypeName;
                    if(recordtype == 'Export'){
                        content +='\n\nExclusions:\n\n'
                        content += result[0].exportHeader+':\n';
                        content +=result[0].exportHeaderList
                        content +='\n\nInclusions:\n\n'
                        content +=result[0].header+':\n';
                        content +=result[0].headerList
                    }
                    else if(recordtype == 'Import'){
                        content +='\n\nTerms & Conditions:\n\n';
                        if(result[0].header != undefined) content +=result[0].header+':\n';
                        if(result[0].headerList != undefined)  content +=result[0].headerList;
                    }
                    content += '\n\nNote:';
                    content +=' \n1. Subject to equipment & vessel space availability while placing booking';
                    content +=' \n2. Cargo insurance not covered in BAFCO scope.'
                    content +=' \n3. Subject to war risk surcharge if any applied by line'
                    content +=' \n4. Standard free time at POD unless specified above.'
                    content +=' \n5. ACID Number, Importer VAT ID, Exporter VAT ID mandatory to proceed with shipment for Egypt.'
                }
                if (navigator.clipboard && window.isSecureContext) {
                    return navigator.clipboard.writeText(content);
                    } else {
                        let textArea = document.createElement("textarea");
                        textArea.value = content;
                        textArea.style.position = "fixed";
                        textArea.style.left = "-999999px";
                        textArea.style.top = "-999999px";
                        document.body.appendChild(textArea);
                        textArea.focus();
                        textArea.select();
                        return new Promise((res, rej) => {
                        document.execCommand("copy") ? res() : rej();
                        textArea.remove();
                        this.disableWhatsApp = true;
                        });
                    }
            }*/
        })
        .catch(error=>{
            console.log('getQuoteDataOnLoad error'+JSON.stringify(error,null,2))
        })
    }
}