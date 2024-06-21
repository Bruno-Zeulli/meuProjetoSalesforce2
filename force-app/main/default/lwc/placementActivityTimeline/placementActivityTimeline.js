import { LightningElement, track, wire, api } from 'lwc';
import getCaseHistoryByIds from '@salesforce/apex/PlacementController.getCaseHistoryByIds';

export default class PlacementActivityTimeline extends LightningElement {

    @track activities = [];
    caseId;
    opportunityId;

    @api historyClass;

    connectedCallback() {
        this.caseId = this.extractCaseIdFromUrl(window.location.href);
        this.opportunityId = this.extractOpportunityIdFromUrl(window.location.href);
        this.loadActivities();
    }

    loadActivities() {
        getCaseHistoryByIds({ caseId: this.caseId, opportunityId: this.opportunityId })
            .then(result => {
                this.activities = JSON.parse(result);
                this.activities.sort((a, b) => new Date(b.dateTimeValueOrigin) - new Date(a.dateTimeValueOrigin));
                console.log(this.activities);
            })
            .catch(error => {
                console.error('Error fetching activities:', error);
            });
    }

    extractCaseIdFromUrl(url) {
        // Procurar por 'caseId=' seguido por qualquer número de caracteres que não sejam '&', e terminar em '&'
        const regex = /caseId=([^&]+)&/;
        const match = url.match(regex);
        // Se encontrar uma correspondência, retornar o valor capturado
        if (match && match[1]) {
            return match[1];
        }
        // Se não encontrar uma correspondência, retornar 'home'
        return 'home';
    }

    extractOpportunityIdFromUrl(url) {
        // Procurar por 'opportunityId=' seguido por qualquer número de caracteres que não sejam '&', ou até o final da string
        const regex = /opportunityId=([^&]+)/;
        const match = url.match(regex);
        // Se encontrar uma correspondência, retornar o valor capturado
        if (match && match[1]) {
            return match[1];
        }
        // Se não encontrar uma correspondência, retornar 'erro'
        return 'erro';
    }
}