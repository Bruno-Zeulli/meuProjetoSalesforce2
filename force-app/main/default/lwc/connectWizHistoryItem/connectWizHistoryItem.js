import { LightningElement, api } from 'lwc';

export default class ConnectWizHistoryItem extends LightningElement {
    @api contentDetails;
    task = this.contentDetails;
    isOpen=false;
    description;
    type;
    subject;
    containsDescription;

    connectedCallback(){
        this.task = this.contentDetails;
        this.description = this.task.Description;
        if(this.description == null || this.description == ''){
            this.containsDescription = false;
        }else{
            this.containsDescription =true;
        }
        this.type = this.task.Type
        this.subject = this.task.Subject

    }

    handleAccordionClick(event){
        // console.log('clicou no accordion ' + JSON.stringify(event.detail));
        this.isOpen = !this.isOpen;
    }

    // @api reRender(){
    //     setTimeout(() => {
    //         console.log('Dentro do reload')
    //             eval("$A.get('e.force:refreshView').fire();");
    //     }, 1000);
    // }
}