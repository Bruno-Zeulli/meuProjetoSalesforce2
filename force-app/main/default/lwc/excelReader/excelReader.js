import { LightningElement } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader'
import excelFileReader from '@salesforce/resourceUrl/ExcelReaderPlugin'

let XLS = {};

export default class ExcelReader extends LightningElement {

    strAcceptedFormats = [".xls", ".xlsx"];
    strUploadFileName; //Store the name of the selected file.
    objExcelToJSON; //Javascript object to store the content of the file

    connectedCallback(){

        Promise.all([loadScript(this, excelFileReader)])
        .then(() => {
            XLS = XLSX;
        })
        .catch((error) => {
            console.log("An error occurred while processing the file");
        });
    }

    handleUploadFinished(event){
        const strUploadedFile = event.detail.files;
        if(strUploadedFile.length && strUploadedFile != ""){
            this.strUploadFileName = strUploadedFile[0].name;
            console.log('File name => ', this.strUploadFileName)
            this.handleProcessExcelFile(strUploadedFile[0]);
        }
    }

    handleProcessExcelFile(file){
        let objFileReader = new FileReader();
        console.log('Estou no processo')
        objFileReader.onload = (event) => {
            let objFiledata = event.target.result;
            let objFileWorkbook = XLS.read(objFiledata, {type: "binary"});
            this.objExcelToJSON = XLS.utils.sheet_to_row_object_array(objFileWorkbook.Sheets["Sheet1"]);


            console.log('objFiledata',objFiledata)
            console.log('objFileWorkbook',objFileWorkbook)
            console.log('objExcelToJSON',objExcelToJSON)

            //Verify if the file content is not blank



            if(this.objExcelToJSON.length === 0){
                this.strUploadFileName = "";
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error",
                        message: "Kindly upload the file with data",
                        variant: "error"
                        })
                    );
                }

            if(this.objExcelToJSON.length > 0){
                //Remove the whitespaces from the javascript object
                Object.keys(this.objExcelToJSON).forEach((key) => {
                    const replacedKey = key.trim().toUpperCase().replace(/\s\s+/g, "_");
                    if(key !== replacedKey){
                        this.objExcelToJSON[replacedKey] = this.objExcelToJSON[key];
                        delete this.objExcelToJSON[key];
                    }
                });
                console.log('objExcelToJSON'+objExcelToJSON);
            }
            console.log('objExcelToJSON'+objExcelToJSON);
        };

        objFileReader.onerror = function (error){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error while reading the file",
                    message: error.message,
                    variant: "error"
                })
            );
        };
        objFileReader.readAsBinaryString(file);
    }
}