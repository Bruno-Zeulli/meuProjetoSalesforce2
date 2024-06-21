import { LightningElement, track } from 'lwc';
import getApolice from '@salesforce/apex/B2U_BuscarApoliceController.getApolice';
import getCompanies from '@salesforce/apex/B2U_BuscarApoliceController.getCompanies';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BuscarApolice extends NavigationMixin(LightningElement){
    @track identificador = '';
    @track tipoBusca = 'BOOK';
    @track identificadores = [];
    @track loader = false;
    @track companies = [];
    @track company = '';

    connectedCallback(){
        this.getCompanies();
    }

    tipoBusca_OnChange(event){
        this.tipoBusca = event.target.value;
    }

    get disableCompanies(){
        return this.tipoBusca != 'BOOKSEMFORMATACAO' ? false : true;
    }

    companyChange(e){
        this.company = e.target.value;
        console.log('test', e.target.value);
    }


    getCompanies(){
        getCompanies({})
            .then((result) => {
                console.log(result);
                let companies = [];

                result.forEach(element => {
                    companies.push({ name: element, value: element })
                });

                this.company = companies[0].value;
                this.companies = companies;

            })
            .catch((error) => {
                console.log(`ERROR: ==> ${error}`)
                throw new Error(error);
            });
    }

    genericOnChange(event){
        this.identificador = event.target.value;
    }

    genericKeyUp(event){
        if(event.keyCode == 13){
            this.getApolice();
        }
    }

    clear(){
        this.identificador = '';
        this.alterarLoader();
    }

    validarIdentificadorInvalido(){
        return this.identificador == null || this.identificador == '';
    }


    alterarLoader(){
        this.loader = !this.loader;
    }

    getApolice(){
        this.alterarLoader();
        console.log(`Tipo Busca => ${ this.tipoBusca}, Tipo identificador => ${ this.identificador}`)

        if(this.validarIdentificadorInvalido()){
            this.showToast('Busca Apólice', 'Necessário inserir um valor válido!', 'error')
            this.alterarLoader();
            return;
        }


        if(this.tipoBusca != 'BOOKSEMFORMATACAO'){
            this.identificador = this.removerCaracteresEspeciais(this.identificador.trim())
        }


        getApolice({
                searchParam: this.tipoBusca,
                value: this.identificador,
                company: this.company
            })
            .then((result) => {
                console.log('Resultado ==', JSON.stringify(result));

                if(result.length > 0){
                    this.navigateToOrder(result[0].Id);
                    this.clear();
                } else{
                    this.showToast('Busca Apólice', 'Apólice não localizada!', 'error');
                    this.clear();
                }
            })
            .catch((error) => {
                this.alterarLoader();
                console.log(`ERROR: ==> ${error}`)
                throw new Error(error);
            });
    }

    removerCaracteresEspeciais(stringToReplace){
        var specialChars = '!@#$^&%*()+=-[]/{}|;"_:<>?,.\r\n|\n|\r';

        for(let i = 0; i < specialChars.length; i++){
            stringToReplace = stringToReplace.replace(new RegExp("\\" + specialChars[i], "gi"), '');
        }
        return stringToReplace;
    }

    navigateToOrder(Id){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: Id,
                actionName: 'view',
            },
        });
    }

    showToast(title, message, variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });

        this.dispatchEvent(evt);
    }

}