import { LightningElement, track, api } from 'lwc';
import uploadDocuments from '@salesforce/apex/UploadDocumentController.uploadDocuments';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class UploadFileDynamic extends LightningElement {
    @api
        value;
        recordid;
        teste;

    get acceptedFormats(){
        return ['.pdf', '.png'];
    }

    connectedCallback(){
        console.log('Record Id Dynamic ==>'+this.recordid);
        console.log('Record Id Dynamic ==>'+this.teste);
    }

    @track  
        loader = false;

    handleUploadFinished(event){
        this.alternarLoader();
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;

        console.log(`FILES ==> ${JSON.stringify(uploadedFiles)}`)
        this.uploadDocuments(uploadedFiles);
    }

    uploadDocuments(uploadedFiles){
        console.log(` Recordid => ${this.recordid}, value => ${this.value}`);
        uploadDocuments({
            lstDocumentos : JSON.stringify(uploadedFiles),
            IdObjeto: this.recordid,
            tipoDocumento: this.value
        })
            .then((data) => {
                //this.ajustarRetornoDocs(data);
                this.showToast('Sucesso', 'Arquivo(s) inserido(s) com sucesso!', 'success');
                this.alternarLoader();
                console.log('SUCESSO');
               
            })
            .catch((error) => {
                console.log(`ERROR: ==> ${error}`)
                this.showToast('Erro', 'Ocorreu um erro ao inserir o(s) arquivo(s)!', 'error');
                this.alternarLoader();
                throw new Error(error);
            });
    }


    showToast(title, message, variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    
    alternarLoader(){
        this.loader = !this.loader;
    }

}