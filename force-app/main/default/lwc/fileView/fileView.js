import { LightningElement, api } from 'lwc';
import {NavigationMixin} from 'lightning/navigation'

export default class FileView extends  NavigationMixin(LightningElement){
    @api
        file;
        key;


        previewHandler(event){
            console.log(event.target.dataset.id)
            this[NavigationMixin.Navigate]({ 
                type:'standard__namedPage',
                attributes:{ 
                    pageName:'filePreview'
                },
                state:{ 
                    selectedRecordId: event.target.dataset.id
                }
            })
        }

        deleteDoc(event){
            let documentId = event.target.dataset.id; 
            this.disparaEvent(documentId);
        }

        disparaEvent(documentId){
            console.log('disparando o evento')
            const selectedEvent = new CustomEvent("deletedoc", {
                detail: documentId
            });
            this.dispatchEvent(selectedEvent);
        }

}