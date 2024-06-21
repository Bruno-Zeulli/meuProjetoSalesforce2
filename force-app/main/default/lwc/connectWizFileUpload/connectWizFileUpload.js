import { LightningElement,api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { isNarrow, proto, isBase } from './fileUploadUtil';
import { showToast } from 'c/util';
import { uploadFiles, formatosAceitos, sendData, verifyExceedLimitSizeFiles, sendDocumentForAPI } from 'c/fileUtil';

export default class ConnectWizFileUpload extends LightningElement {
    @api recordId; //get the recordId for which files will be attached
    @api labelName;
    @api tipoDocumento;

    @track selectedFilesToUpload = []; //store selected files
    @track privateVariant = 'base';

    filesList = [];
    isIntegrationDirectByJs = true;
    dragZoneActive = false;
    eventListenersAdded;
    isLoading = false;

    constructor(){
        super();
    }

    async renderedCallback(){
        this.handleLoading(true);
         if(this.eventListenersAdded){
            this.handleLoading(false);
            return;
        }

        this.eventListenersAdded = true;
        this.registerEvents();
        this.handleLoading(false);
    }

    get dropZoneContextClass(){
        return this.dragZoneActive ? 'active' : 'inactive';
    }

    get computedWrapperClassNames(){

        var config = 'slds-card';
        if(typeof config === 'string'){
            const key = config;
            config = {};
            config[key] = true;
        }
        var obj = Object.assign(Object.create(proto), config);
        obj.add({
            'slds-card_narrow': isNarrow(this.privateVariant)
        });
    };

    handleOpenDialog = (event) => {
        this.template.querySelector('[data-id="ChooseFiles"]').click();
    }

    // get the file name from the user's selection
    handleSelectedFiles = (event) => {
        let files = this.template.querySelector('[data-id="ChooseFiles"]').files;
        this.processAllFiles(files);
    };

    registerEvents = () => {

        console.log('Passou registerEvents')
        const dropArea = this.template.querySelector('[data-id="droparea"]');

        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, this.preventDefaults)
        });

        ['dragenter', 'dragover'].forEach(eventName => {
            dropArea.addEventListener(eventName, this.highlight);
        });

        ['dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, this.unhighlight);
        });

        dropArea.addEventListener('drop', this.handleDrop);

    };

    highlight = (e) => {
        this.dragZoneActive = true;
    };

    unhighlight = (e) => {
        this.dragZoneActive = false;
    };

    handleDrop = (e) => {
        let dt = e.dataTransfer;
        this.processAllFiles(dt.files);
    };

    preventDefaults = (e) => {
        e.preventDefault();
        e.stopPropagation();
    };

    processAllFiles = (files) => {
        let fileBuffer = [];
        Array.prototype.push.apply(fileBuffer, files);
        console.log('esse cara aqui é o arquivo: ',files);
        fileBuffer.forEach(item => {
            let file = item;
            this.selectedFilesToUpload.push(file);
        });
        console.log('isLoading', this.isLoading);
        this.sendDocumentForAPI(files);
    };

    sendDocumentForAPI(files){
        this.handleLoading(true);
        this.alternarLoader();
        sendDocumentForAPI(files, this.recordId, this)
            .then(async data => {
                try{
                    this.filesList = JSON.parse(JSON.stringify(this.filesList));
                    let arquivo = await this.renderFile(data);
                    this.updateRenderComponent();
                    this.handleShowUploadFile();
                    this.onRefresh();
                    this.handleRefresh();
                    console.log('isLoading false ===>>>', this.isLoading);
                    this.handleLoading(false);
                   /*  this.template.querySelector('c-required-files').filterChecklistByDelete(arquivo.type, this.filesList); */
                }catch(error){
                    console.log(error)
                    showToast('Erro', 'Erro para exibir arquivo, porem foi adicionado.', 'error', this);
                    this.handleLoading(false);
                    return false;
                }
            })
            .catch(error => {
                this.handleLoading(false);
                return false;
            })
        this.handleLoading(false);
        return true;
    }

    handleShowUploadFile(){
        const selectedEvent = new CustomEvent("handleshowuploadfile", {
            detail: false
        });
        this.dispatchEvent(selectedEvent);

        const eventV2 = new CustomEvent("finish", {
            detail: {
                parentId: this.recordId
            }
        });
        this.dispatchEvent(eventV2);
    }



   /*  async handleUploadFinishedOffline(event){
        const uploadedFiles = event.detail.files;
        let verifyExceedLimitSizeFilesBool = await verifyExceedLimitSizeFiles(uploadedFiles, this);

        if(!verifyExceedLimitSizeFilesBool){
            uploadFiles(uploadedFiles, this.recordId, this)
        }else{
            showToast('Erro', 'Os arquivo(s) não podem exceder o tamanho de 2.5MB offline!', 'error', this);
        }
    }
 */
    async renderFile(data){
        this.handleLoading(true);
        let arquivo = this.createFile(data);
        this.pushFileForList(arquivo);
        this.onRefresh();
        this.handleRefresh();
        this.handleLoading(false);
        return arquivo;
    }

    pushFileForList(arquivo){
         this.filesList = JSON.parse(JSON.stringify(this.filesList));
         this.filesList.push(arquivo);
    }

    createFile(data){
        let fields = data.fields;
        let file = {
            id: data.id,
            type: fields.DocumentType__r.displayValue,
            name: fields.Name.value,
            status: fields.Status__c.value,
            url: fields.ExternalUrl__c.value,
            hasPreview: false,
            dataCriacao: fields.CreatedDate.displayValue,
            isIntegrated: true
        }
        return file;
    }

    ajustarRetornoDocs(data){
        this.filesList = Object.keys(data).map((item) => JSON.parse(data[item]));
    }

    getDocumentList(event){
        let documento = JSON.parse(JSON.stringify(event.detail));
        this.renderFile(documento);
    }

    alternarLoader(){
        this.loader = !this.loader;
    }

    handleLoading(event){
        this.isLoading = event;
    }

    handleChange(event){
        this.tipoDocumento = event.detail.value;
    }

    get acceptedFormats(){
        formatosAceitos();
    }

    updateRenderComponent(){
       setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
            this.handleLoading(false);
       }, 5000);
    }

    onRefresh(){
        const selectedEvent = new CustomEvent("refresh", {
            bubbles: true
        });
        this.dispatchEvent(selectedEvent);
    }

    handleRefresh(){
        this.onRefresh();
        const selectedEvent = new CustomEvent("refresh");
        console.log('Passou no pai')
        this.dispatchEvent(selectedEvent);
    }
}