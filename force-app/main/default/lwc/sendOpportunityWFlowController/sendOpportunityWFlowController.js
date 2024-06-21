import { LightningElement, api, track } from 'lwc';
import sendOpportunity from '@salesforce/apex/Corporate_SendOpportunityWFlowController.sendOpportunity';
import { showToast } from 'c/util';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';

export default class SendOpportunityWFlowController extends LightningElement {
    @track
    isLoading = false;

    toggleLoader(){
        this.isLoading = !this.isLoading;
        console.log('isLoaded Mudou para ==> ', this.isLoading);
    }

    @api recordId;
    @api async invoke(){
        this.toggleLoader();
        console.log('recordId ==> ', this.recordId);
        sendOpportunity({ recordId: this.recordId })
            .then((data) => {
                console.log('DATA ==> ', data);
                this.toggleLoader();
                if(data == true){
                    showToast('Solicitação de cotação enviada ao WFlow', 'Em breve você receberá um retorno da Célula Técnica!', 'success', this);
                    getRecordNotifyChange([{ recordId: this.recordId }]);
                }
                if(data == false){
                    showToast('Cotação não solicitada', 'Existem documentos obrigatórios não anexados.', 'warning', this);
                }
                if(data == 'Deo'){
                    showToast('Cotação não solicitada', 'Não é possível enviar oportunidade de D&O para o WFlow. Utilize o botão "Solicitar Cotação ao Placement" para enviar ao Connect@Wiz', 'warning', this);
                }
                if(data == 'Mcmv'){
                    showToast('Cotação não solicitada', 'Não é possível enviar oportunidade de MCMV para o WFlow. Utilize o botão "Solicitar Cotação ao Placement" para enviar ao Connect@Wiz', 'warning', this);
                }
            })
            .catch((error) => {
                this.toggleLoader();
                console.log(`ERROR: ==> ${error}`);
                showToast('Erro', 'Ocorreu um erro ao solicitar a cotação ao WFlow!', 'error', this);
                throw new Error(error);
            });
    }
}