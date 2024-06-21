import { LightningElement,track,api } from 'lwc';
import {exportCSVFile} from 'c/utils'

export default class ConnectWizExportData extends LightningElement {

    @api fileType;
    @api csvData;
    @api csvHeaders;
    @api fileTitle;

    downloadOpportunityDetails(){
        console.log("download triggered.")
        if(this.fileType == "CSV"){
            exportCSVFile(this.csvHeaders, this.csvData, "Oportunidades");
        }
    }
}