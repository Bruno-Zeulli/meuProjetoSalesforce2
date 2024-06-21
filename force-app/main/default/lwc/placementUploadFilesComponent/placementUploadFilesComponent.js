import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateDocument from '@salesforce/apex/PlacementFollowUpController.updateDocument';

export default class PlacementUploadFilesComponent extends LightningElement {
    @api addFiles = []; //RECEBE DOCUMENTOS DA OPP
    @api addFilesEmission = [];
    @api addFilesApoliceBoletos = [];
    @api hasApolicesAndBoletos;
    
    @api objectToSave; //RECEBE NOME DO OBJETO QUE SERÁ SALVO O DOCUMENTO

    @track addFilesCopy = [];
    @track addFilesEmissionCopy = [];
    @track addFilesApoliceBoletosCopy = [];

    @track selectedFiles = [];
    @track error = false;
    @api showFooterButtons;
    @api filesTitle;
    @api dropZoneTitle;

    @api dropZoneClass;

    @api filesTitleClass;
    @api dropZoneTitleClass

    @api oppSession;
    @api emissionSession;
    @api emissionSessionBoletos;
    @api showDropZone;

    @api fileItemEmissionClass;

    loadedFile = true;

    connectedCallback() {

        if(this.addFiles.length > 0) {
            for (let i in this.addFiles) {
                let needsApproval;
                let formattedStatus;
                let formattedCreatedDate;
                
                if (this.addFiles[i].Status__c != 'Accepted' && this.addFiles[i].Status__c != 'Refused'){
                    needsApproval = true;
                } else {
                    needsApproval = false;
                }
    
                if(this.addFiles[i].Status__c == 'Accepted'){
                    formattedStatus = 'Documento aprovado';
                } else if (this.addFiles[i].Status__c == 'Refused'){
                    formattedStatus = 'Documento reprovado';
                } else {
                    formattedStatus = 'Documento em análise';
                }
    
                formattedCreatedDate = this.formatDate(this.addFiles[i].CreatedDate);
    
                this.addFilesCopy.push(
                    {
                        Id: this.addFiles[i].Id, 
                        Name: this.addFiles[i].Name, 
                        DocumentType__c: this.addFiles[i].DocumentType__c, 
                        ExternalUrl__c: this.addFiles[i].ExternalUrl__c,
                        IdObjeto__c: this.addFiles[i].IdObjeto__c,
                        Objects__c: this.addFiles[i].Objects__c,
                        OwnerId: this.addFiles[i].OwnerId,
                        Status__c: this.addFiles[i].Status__c,
                        CreatedDate: this.addFiles[i].CreatedDate,
                        NeedsApproval: needsApproval,
                        FormattedStatus: formattedStatus,
                        FormattedCreatedDate: formattedCreatedDate
                    })
            }
            console.log('ADD FILES:', this.addFilesCopy);
        }

        if(this.addFilesEmission.length > 0) {
            for (let i in this.addFilesEmission) {
                let formattedCreatedDate;
    
                formattedCreatedDate = this.formatDate(this.addFilesEmission[i].CreatedDate);
    
                this.addFilesEmissionCopy.push(
                    {
                        Id: this.addFilesEmission[i].Id, 
                        Name: this.addFilesEmission[i].Name, 
                        DocumentType__c: this.addFilesEmission[i].DocumentType__c, 
                        ExternalUrl__c: this.addFilesEmission[i].ExternalUrl__c,
                        IdObjeto__c: this.addFilesEmission[i].IdObjeto__c,
                        Objects__c: this.addFilesEmission[i].Objects__c,
                        OwnerId: this.addFilesEmission[i].OwnerId,
                        Status__c: this.addFilesEmission[i].Status__c,
                        CreatedDate: this.addFilesEmission[i].CreatedDate,
                        FormattedCreatedDate: formattedCreatedDate
                    })
            }
            console.log('ADD EMISSION FILES:', this.addFilesEmission);
        }

        if(this.addFilesApoliceBoletos.length > 0) {
            for (let i in this.addFilesApoliceBoletos) {
                let formattedCreatedDate;
    
                formattedCreatedDate = this.formatDate(this.addFilesApoliceBoletos[i].CreatedDate);
    
                this.addFilesApoliceBoletosCopy.push(
                    {
                        Id: this.addFilesApoliceBoletos[i].Id, 
                        Name: this.addFilesApoliceBoletos[i].Name, 
                        DocumentType__c: this.addFilesApoliceBoletos[i].DocumentType__c, 
                        ExternalUrl__c: this.addFilesApoliceBoletos[i].ExternalUrl__c,
                        IdObjeto__c: this.addFilesApoliceBoletos[i].IdObjeto__c,
                        Objects__c: this.addFilesApoliceBoletos[i].Objects__c,
                        OwnerId: this.addFilesApoliceBoletos[i].OwnerId,
                        Status__c: this.addFilesApoliceBoletos[i].Status__c,
                        CreatedDate: this.addFilesApoliceBoletos[i].CreatedDate,
                        FormattedCreatedDate: formattedCreatedDate
                    })
            }
            console.log('ADD EMISSION APOLICE E BOLETOS FILES:', this.addFilesApoliceBoletos);
            console.log('COPY APOLICE E BOLETOS FILES:', this.addFilesApoliceBoletosCopy);
        }

    }


    handleUploadClick() {
        const fileInput = this.template.querySelector('.file-input');
        fileInput.click();
    }


    checkSizeFiles(listFiles) {
        const files = listFiles;
        const maxFileSizeInMB = 5; // Define o tamanho máximo total dos arquivos em MB
        const maxSizeInBytes = maxFileSizeInMB * 1024 * 1024; // Converte para bytes
        let totalSize = 0;

        // Calcula o tamanho total dos arquivos selecionados
        for (let i = 0; i < files.length; i++) {
            totalSize += files[i].size;
        }

        // Verifica se o tamanho total dos arquivos excede o limite
        if (totalSize > maxSizeInBytes) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: `O tamanho total dos arquivos excede o limite de ${maxFileSizeInMB} MB.`,
                    variant: 'error',
                })
            );
            this.error = true;
        } else {
            this.error = false;
        }

        return this.error;
    }

    handleFileUpload(event) {
        const files = event.target.files;
        let result = this.checkSizeFiles(files);

        if(result == false) {
            this.uploadFiles(files);
        }
    }

    clearFiles() {
        this.selectedFiles = [];
    }
    
    uploadFiles(files) {
        for (let i = 0; i < files.length; i++) {
            const file = files[i];
            file.id = file.name + file.size + i;

            let currentDateTime = new Date();
            let formattedCurrentDateTime = this.formatDate(currentDateTime);
        
            file.createdDate = formattedCurrentDateTime;
            this.selectedFiles.push(file);

            const event = new CustomEvent('selectedfiles', {
                detail: { files: this.selectedFiles, objectToSave : this.objectToSave }
            });
            
            this.dispatchEvent(event);

            console.log('Arquivo:', file);
            console.log('Nome Do Arquivo:', file.name);
            console.log('Tipo:', file.type);
            console.log('Tamanho:', file.size);
            console.log('Created Date:', file.createdDate);
        }
    }

    handleDragOver(event) {
        event.preventDefault();
        this.addHighlight();

        event.dataTransfer.dropEffect = 'copy';
    }

    handleDragLeave(event) {
        event.preventDefault();
        this.removeHighlight();
    }

    handleDrop(event) {
        event.preventDefault();
        this.removeHighlight();

        const files = event.dataTransfer.files;
        this.uploadFiles(files);
    }

    addHighlight() {
        const dropZone = this.template.querySelector('.' + this.dropZoneClass);
        dropZone.classList.add('highlighted');
    }

    removeHighlight() {
        const dropZone = this.template.querySelector('.' + this.dropZoneClass);
        dropZone.classList.remove('highlighted');
    }


    handlePreviewFile(event) {
        const fileId = event.target.dataset.fileid;

        let file;
        let fileAddFromOpp;
        let fileSusep382;
        let fileApoliceBoletos;

        if (this.selectedFiles.length > 0) {
            file = this.selectedFiles.find(file => file.id === fileId);
        }

        if (this.addFiles.length > 0) {
            fileAddFromOpp = this.addFiles.find(file => file.Id === fileId);
        }

        if (this.addFilesEmission.length > 0) {
            fileSusep382 = this.addFilesEmission.find(file => file.Id === fileId);
        }

        if(this.addFilesApoliceBoletos.length > 0) {
            fileApoliceBoletos = this.addFilesApoliceBoletos.find(file => file.Id === fileId);
        }


        if(file){
            // Verifica se o navegador suporta a visualização do tipo de arquivo
            if (this.isPreviewSupported(file.type)) {
                // Cria uma URL para o arquivo
                const fileURL = URL.createObjectURL(file);
          
                // Cria um link temporário
                const tempLink = document.createElement('a');
                tempLink.href = fileURL;
                tempLink.target = '_blank'; // Abre o link em uma nova guia do navegador
                tempLink.click();
    
                // Libera a URL criada
                console.log('FILE URL: ', fileURL);
                URL.revokeObjectURL(fileURL, '_blank');
    
            } else {
                // Exibe uma mensagem de erro se o tipo de arquivo não for suportado
                console.error('Visualização não suportada para este tipo de arquivo.');

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: `Visualização não suportada para este tipo de arquivo.`,
                        variant: 'error',
                    })
                );
            }
        }

        if(fileAddFromOpp) {
            if(fileAddFromOpp.ExternalUrl__c != null){
                this.downloadAndViewFile(fileAddFromOpp.ExternalUrl__c);
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: `Esse arquivo não possui referência no blob.`,
                        variant: 'error',
                    })
                );
            }
        }

        if(fileSusep382) {
            if(fileSusep382.ExternalUrl__c != null){
                this.downloadAndViewFile(fileSusep382.ExternalUrl__c);
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: `Esse arquivo não possui referência no blob.`,
                        variant: 'error',
                    })
                );
            }
        }

        if(fileApoliceBoletos) {
            if(fileApoliceBoletos.ExternalUrl__c != null){
                this.downloadAndViewFile(fileApoliceBoletos.ExternalUrl__c);
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: `Esse arquivo não possui referência no blob.`,
                        variant: 'error',
                    })
                );
            }
        }

    }


    handleDownloadFile(event) {
        const fileId = event.target.dataset.fileid;
        let file;
        let fileAddFromOpp;
        let fileSusep382;
        let fileApoliceBoletos;

        if (this.selectedFiles.length > 0) {
            file = this.selectedFiles.find(file => file.id === fileId);
        }

        if (this.addFiles.length > 0) {
            fileAddFromOpp = this.addFiles.find(file => file.Id === fileId);
        }

        if (this.addFilesEmission.length > 0) {
            fileSusep382 = this.addFilesEmission.find(file => file.Id === fileId);
        }

        if(this.addFilesApoliceBoletos.length > 0) {
            fileApoliceBoletos = this.addFilesApoliceBoletos.find(file => file.Id === fileId);
        }

        if(file){
            // Cria uma URL para o arquivo
            const fileURL = URL.createObjectURL(file);

            // Cria um link temporário
            const tempLink = document.createElement('a');
            tempLink.href = fileURL;
            tempLink.setAttribute('download', file.name); // Define o atributo de download para o nome do arquivo
            tempLink.click();

            // Libera a URL criada
            URL.revokeObjectURL(fileURL);
        }
        if(fileAddFromOpp) {
            if(fileAddFromOpp.ExternalUrl__c != null){
                window.open(fileAddFromOpp.ExternalUrl__c, '_blank');
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: `Esse arquivo não possui referência no blob.`,
                        variant: 'error',
                    })
                );
            }
        }

        if(fileSusep382) {
            if(fileSusep382.ExternalUrl__c != null){
                window.open(fileSusep382.ExternalUrl__c, '_blank');
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: `Esse arquivo não possui referência no blob.`,
                        variant: 'error',
                    })
                );
            }
        }

        if(fileApoliceBoletos) {
            if(fileApoliceBoletos.ExternalUrl__c != null){
                window.open(fileApoliceBoletos.ExternalUrl__c, '_blank');
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: `Esse arquivo não possui referência no blob.`,
                        variant: 'error',
                    })
                );
            }
        }
    }


    isPreviewSupported(fileType) {
        // Verifica se o tipo de arquivo é suportado para visualização
        return fileType.startsWith('image/') || fileType === 'application/pdf';
    }

    handleDeleteFile(event) {
        const fileId = event.target.dataset.fileid;
        const index = this.selectedFiles.findIndex(file => file.id === fileId);

        if (index != -1) {
            this.selectedFiles.splice(index, 1);
            this.checkSizeFiles(this.selectedFiles);
        }
    }

    /*
    saveDataModal() {
        const event = new CustomEvent('savefiles', {
            detail: { files: this.selectedFiles }
        });
        this.dispatchEvent(event);
    }

    deleteDataModal() {
        this.selectedFiles = [];

        const event = new CustomEvent('deletefiles', {
            detail: { files: this.selectedFiles }
        });
        this.dispatchEvent(event);
    }
    */

    async handleRejectFile(event) {
        this.loadedFile = false;

        const fileId = event.target.dataset.fileid;
        const fileAddFromOpp = this.addFiles.find(file => file.Id === fileId);
        let fileAddFromOppToUpdt;

        if(fileAddFromOpp){
            fileAddFromOppToUpdt = {
                Id: fileAddFromOpp.Id, 
                Status__c: 'Refused'
            };
        }

        console.log('FILE ADD FROM OPP TO UPDT:', fileAddFromOppToUpdt);

        
        try{
            const document = await updateDocument ({document: fileAddFromOppToUpdt});
            if(document){
                console.log('DOCUMENTO ATUALIZADO: ', document);

                let docUpdatedInAddFiles = this.addFilesCopy.find(file => file.Id === document.Id);
                let docIndexInAddFiles = this.addFilesCopy.indexOf(docUpdatedInAddFiles);

                this.addFilesCopy[docIndexInAddFiles].Status__c = 'Refused';
                this.addFilesCopy[docIndexInAddFiles].NeedsApproval = false;
                this.addFilesCopy[docIndexInAddFiles].FormattedStatus = 'Documento reprovado';

                this.loadedFile = true;

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: `Status de documento atualizado.`,
                        variant: 'success',
                    })
                );

            }
        } catch (error) {

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: `Erro ao atualizar status de documento. ${error.message}`,
                    variant: 'error',
                })
            );
            this.loadedFile = true;
        }

        console.log('ID EVENT REJECT FILE: ' + fileId);
        console.log('FILE REJECTED: ', fileAddFromOpp);
    }

    async handleApproveFile(event) {
        this.loadedFile = false;

        const fileId = event.target.dataset.fileid;
        const fileAddFromOpp = this.addFiles.find(file => file.Id === fileId);
        let fileAddFromOppToUpdt;

        if(fileAddFromOpp){
            fileAddFromOppToUpdt = {
                Id: fileAddFromOpp.Id, 
                Status__c: 'Accepted'
            };
        }

        console.log('FILE ADD FROM OPP TO UPDT:', fileAddFromOppToUpdt);

        
        try{
            const document = await updateDocument ({document: fileAddFromOppToUpdt});
            if(document){
                console.log('DOCUMENTO ATUALIZADO: ', document);

                let docUpdatedInAddFiles = this.addFilesCopy.find(file => file.Id === document.Id);
                let docIndexInAddFiles = this.addFilesCopy.indexOf(docUpdatedInAddFiles);

                this.addFilesCopy[docIndexInAddFiles].Status__c = 'Accepted';
                this.addFilesCopy[docIndexInAddFiles].NeedsApproval = false;
                this.addFilesCopy[docIndexInAddFiles].FormattedStatus = 'Documento aprovado';

                this.loadedFile = true;

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: `Status de documento atualizado.`,
                        variant: 'success',
                    })
                );

            }
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: `Erro ao atualizar status de documento. ${error.message}`,
                    variant: 'error',
                })
            );
            this.loadedFile = true;
        }

        console.log('ID EVENT ACCEPTED FILE: ' + fileId);
        console.log('FILE ACCEPTED: ', fileAddFromOpp);
    }

    formatDate(dataString) {
        let date = new Date(dataString);

        let hora = date.getHours();
        let minutes = date.getMinutes();
        let ampm = hora >= 12 ? 'pm' : 'am';
        
        hora = hora % 12;
        hora = hora ? hora : 12;
        minutes = minutes < 10 ? '0' + minutes : minutes;

        let day = date.getDate();
        let month = date.getMonth() + 1;
        let year = date.getFullYear();

        let formattedDate = hora + ':' + minutes + ampm + ' | ' + (day < 10 ? '0' : '') + day + '/' + (month < 10 ? '0' : '') + month + '/' + year;

        return formattedDate;
    }

    
    async downloadAndViewFile(downloadURL) {

        const type = downloadURL.split('.').pop();
        console.log(type);

        if(type === 'pdf'){
            try {
                let blob = new Blob([await fetch(downloadURL).then(response => response.blob())],{type: 'application/pdf'});
                let url = URL.createObjectURL(blob)
                window.open(url, '_blank');
    
            } catch(error) {
                console.error('Erro ao baixar arquivo:', error);
            }
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: `Esse arquivo não possui a visualização habilitada, realize o download para acessá-lo.`,
                    variant: 'error',
                })
            ); 
        }

    }
    
}