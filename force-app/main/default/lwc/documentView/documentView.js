/**
 * @description       :
 * @author            : Italo Ramillys
 * @group             :
 * @last modified on  : 02-29-2024
 * @last modified by  : Italo Ramillys
 * Modifications Log
 * Ver   Date         Author       Modification
 * 1.0   02-29-2024   Italo Ramillys   Initial Version
 **/

import { LightningElement, track, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDocuments from '@salesforce/apex/DocumentUploadDAO.getDocumentUploadComponentBySObjectId';
import updateStatus from '@salesforce/apex/DocumentUploadService.updateStatus';
import { NavigationMixin } from "lightning/navigation";
import getFilesByObject from '@salesforce/apex/UploadDocumentController.getFilesByObject'
import getFileURL from '@salesforce/apex/UploadDocumentController.getFileURL';
import { getRecord } from 'lightning/uiRecordApi';
const FIELDS = ['Opportunity.RecordTypeId'];

const statusMap = new Map([
    ['', { status: 'Pendente', class: '' }],
    ['Pending', { status: 'Pendente', class: '' }],
    ['Accepted', { status: 'Aceito', class: 'Aceito' }],
    ['Refused', { status: 'Recusado', class: 'Recusado' }],
    ['UnderReview', { status: 'Em Análise', class: 'EmAnalise' }]
]);

export default class DocumentView extends NavigationMixin(LightningElement) {

    @api recordId;

    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;

    @track statusTrack = [];
    docs = [];
    baseURL = '';
    docCount;
    AttachementIds = '';
    hasFile = false;
    urlFileLink = '';
    loader = false;
    rtConsorcio = false;

    @api
    get docCount() {
        return this.docs.length;
    }

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS, modes: ['View', 'Edit', 'Create'] })
    wiredRecord({ error, data }) {
        if (data) {
            this.data = data;
            this.rtConsorcio = data.recordTypeInfo.name == 'Consórcio';
            console.log('RecordType da Opp: ', data.recordTypeInfo.name);
        } else if (error) {
            console.log(error);
            this.error = error;
        }
    }

    connectedCallback() {
        this.getFileURL();
        this.getDocumentsFunction(this.recordId);
        this.updateList();
    }

    getFileURL() {
        console.log('@retrievedFiles');
        return new Promise((resolve, reject) => {
            getFileURL({})
                .then(async (url) => {
                    this.urlFileLink = url;
                    console.log('@getFileURL - this.urlFileLink ==> ', this.urlFileLink);
                    resolve(url);
                    return false
                })
                .catch(error => reject(error))
        })
    }

    getDocumentsFunction(recordIdParam) {
        getDocuments({ recordId: recordIdParam }).then((data) => {
            const statusTrack = new Map();
            console.log('@getFiles');
            console.log(data);
            if (data) {
                let myArr = [];
                let arq;

                this.hasFile = data.length > 0;

                data.forEach(function (item) {
                    arq = {};
                    arq.name = item.Name;
                    arq.id = item.Id;
                    arq.status = statusMap.get(item.Status__c == null ? '' : item.Status__c).status;
                    arq.class = statusMap.get(item.Status__c == null ? '' : item.Status__c).class;
                    arq.reason = item.ReasonRefusal__c == null ? '' : item.ReasonRefusal__c;
                    arq.reasonVisible = item.ReasonRefusal__c != null;
                    arq.identifierDoc = item.IdentificadorDocumento__c;
                    arq.url = item.ExternalUrl__c;
                    myArr.push(arq);

                    statusTrack.set(item.Id, { status: item.Status__c, reason: arq.reason, docIdentifier: item.IdentificadorDocumento__c });
                });

                this.statusTrack = statusTrack;
                this.docs = myArr;

                let wizProIndexURL = window.location.href.indexOf('/wizpro/');

                if (wizProIndexURL > 0) {
                    this.baseURL = window.location.href.substring(0, wizProIndexURL) + '/wizpro';
                }
            } else if (error) {
                this.error = error;

                console.log('Erro getFiles');
                console.log(JSON.stringify(this.error));
            }
        }).catch(e => {
            console.log('Error: ', e);
        });
    }

    downloadBase64File(contentType, base64Data, fileName) {
        const linkSource = `data:${contentType};base64,${base64Data}`;
        const downloadLink = document.createElement("a");
        downloadLink.href = linkSource;
        downloadLink.download = fileName;
        downloadLink.click();
    }

    async getFileBase64WithName(url, filename) {
        return new Promise((resolve, reject) => {
            console.log('url ==>', this.urlFileLink);
            let _data = {
                "url": url,
                "name": filename
            }
            fetch(this.urlFileLink, {
                method: "POST",
                body: JSON.stringify(_data),
                headers: { "Content-type": "application/json; charset=UTF-8" }
            })
                .then(response => response.json())
                .then(json => resolve(json));
        })
    }

    updateList() {
        console.log('@updateList')
        getFilesByObject({
            recordId: this.recordId
        })
            .then((data) => {
                console.log(data)
                this.ajustarRetornoDocs(data);
            })
            .catch(error => console.log(error));
    }

    ajustarRetornoDocs(data) {
        this.fileslist = [];

        let fileslist = Object.keys(data).map(item => (JSON.parse(data[item])));

        for (let file of fileslist) {
            file.isIntegrated = true;
        }
        this.fileslist = fileslist;
    }

    saveStatus() {
        console.log('@saveStatus');
        console.log(this.statusTrack);
        const objFromMap = Object.fromEntries(this.statusTrack);
        console.log(JSON.stringify(objFromMap));

        this.isModalOpen = false;
        this.loader = true;
        updateStatus({
            docUploadJSON: JSON.stringify(objFromMap)
        }).then(() => {
            console.log('@updateStatus');
            let newDoc = [];
            console.log(newDoc);
            console.log(this.statusTrack);
            console.log(this.statusTrack.keys());
            this.statusTrack.keys().forEach(e => {
                let curFile = this.docs.find(function (file) {
                    return file.id === e;
                });
                curFile.status = statusMap.get(this.statusTrack.get(e).status).status;
                curFile.class = statusMap.get(this.statusTrack.get(e).status).class;
                curFile.reason = this.statusTrack.get(e).reason;

                curFile.reasonVisible = curFile.reason != null && curFile.reason != '';

                newDoc.push(curFile);
            });
            console.log(newDoc);
            this.docs = newDoc;
            this.showToast('Sucesso', 'Status atualizados', 'success');
        }).catch(error => {
            this.showToast('Erro', 'Ocorreu um erro na atualização dos status', 'error');
            console.log('Error::: ' + JSON.stringify(error));
        })
        this.loader = false;
    }

    @api downloadAllFiles() {
        console.log('@downloadAllFiles');
        let attachDocs = '';

        for (let it of this.statusTrack.keys()) {
            console.log(it)
            console.log(this.statusTrack.get(it))
            attachDocs += '/' + this.statusTrack.get(it).docIdentifier;
        }

        const config = {
            type: 'standard__webPage',
            attributes: {
                url: this.baseURL + '/sfc/servlet.shepherd/document/download/' + attachDocs
            }
        };
        this[NavigationMixin.Navigate](config).then(url => {
            window.open(url);
        });
    }

    accepted(event) {
        try {

            console.log('@accepted');
            let docId = event.currentTarget.dataset.id;
            let docIdent = this.statusTrack.get(docId).docIdentifier;

            this.statusTrack.set(docId, { status: 'Accepted', reason: '', docIdentifier: docIdent });

            const el = this.template.querySelector(`[data-row-status="${docId}"]`);
            el.className = 'Aceito';
            el.innerHTML = 'Aceito';

            event.currentTarget.className = 'actionButton btn-selected';
            event.currentTarget.nextSibling.className = 'actionButton';

            this.template.querySelector(`[data-reason="${docId}"]`).value = '';

            console.log(this.statusTrack);
        } catch (e) {
            console.log('Erro: ', e);
        }
    }

    refused(event) {
        console.log('@refuse');

        console.log(event.currentTarget);

        let docId = '';
        if (event.currentTarget.dataset.id != null) {
            docId = event.currentTarget.dataset.id;
        } else if (event.currentTarget.dataset.reason != null) {
            docId = event.currentTarget.dataset.reason;
        }
        let reason = this.template.querySelector(`[data-reason="${docId}"]`).value;

        console.log(event.currentTarget.tagName);

        if (event.currentTarget.tagName == 'INPUT' && (reason == '' || reason == null)){
            return;
        }

        let docIdent = this.statusTrack.get(docId).docIdentifier;


        this.statusTrack.set(docId, { status: 'Refused', reason: reason, docIdentifier: docIdent });

        const el = this.template.querySelector(`[data-row-status="${docId}"]`);
        el.className = 'Recusado';
        el.innerHTML = 'Recusado';

        if (event.currentTarget.tagName == 'BUTTON') {
            event.currentTarget.className = 'actionButton btn-selected';
            event.currentTarget.previousSibling.className = 'actionButton';
        }

        this.template.querySelectorAll(`.actionButton[data-id="${docId}"]`)[1].className = 'actionButton btn-selected';
        console.log(this.statusTrack);
    }

    async downloadFile(event) {

        console.log('@downloadFile');
        this.loader = true;
        try {
            event.preventDefault();
            let files = JSON.parse(JSON.stringify(this.fileslist));
            let originalURL = event.currentTarget.dataset.name;
            console.log(files);
            let specifiedFile = files.find(file => file.url == originalURL);
            console.log(specifiedFile);
            let filename = specifiedFile.name;
            let contentType = specifiedFile.contentType;
            let data = await this.getFileBase64WithName(originalURL, filename);

            if (data.fileContents != null && contentType != null) {
                await this.downloadBase64File(contentType, data.fileContents, filename);
            } else {
                await this.saveContent(originalURL, filename);
            }

            this.loader = false;

        } catch (e) {
            console.log(e);
            this.loader = false;
        }
    };

    saveContent(fileContents, fileName) {
        console.log('@saveContent');
        const link = document.createElement('a');
        link.download = fileName;
        link.href = fileContents;
        console.log('Download URL: ', fileContents)
        link.click();
    }

    async getFileBase64WithName(url, filename) {
        return new Promise((resolve, reject) => {
            console.log('url ==>', this.urlFileLink);
            let _data = {
                "url": url,
                "name": filename
            }
            fetch(this.urlFileLink, {
                method: "POST",
                body: JSON.stringify(_data),
                headers: { "Content-type": "application/json; charset=UTF-8" }
            })
                .then(response => response.json())
                .then(json => resolve(json));
        })
    }

    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toastEvent);
    }

    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
}