import { LightningElement, api, track } from 'lwc';

export default class QuestionnaireTable extends LightningElement {
    @api questionId;
    @api label;
    @api allowComment;
    @api comment;
    @api readOnly = false;

    @api options;
    @api answer;

    commentValue = this.comment;
    typingTimer;
    
//-----TABLE VARIABLES-----//
    data; //answerValue
    columns; //options
//-----------------------//

    connectedCallback() {
        if (this.options) {
            const columnLabels = this.options.split(';'); // Divide a string em um array de labels

            // Cria as colunas da tabela dinamicamente
            this.columns = columnLabels.map(label => {
                return {
                    label: label.trim(), // Remove espaços em branco em volta do label
                    fieldName: this.removeAccents(label.trim().toLowerCase().replace(/\s/g, '')), // Converte para lowercase e retira os espaços e acentos
                    type: 'text',
                    editable: true,
                };
            });
            
            this.columns.push({
                type: 'button-icon',
                initialWidth: 5,
                typeAttributes: { 
                    iconName: 'utility:delete',
                    title: 'Excluir',
                    variant: 'bare',
                    name: 'delete'
                }
            });
        }

        if(this.answer) {
            let content = JSON.parse(this.answer);
            for (let i in content){
                content[i].rowIndex = i;
            }
            this.data = content;
        }

        console.log(this.data);
    }

    handleInLineEdit(event) {
        let draftValues = event.detail.draftValues;
        let propChanged = Object.keys(draftValues[0]).find(key => key !== 'id');
        let rowIndex = parseInt(event.detail.draftValues[0].id.replace('row-', ''), 10);
        console.log(draftValues);
        console.log('ROW:' ,rowIndex);

        this.updateAnswerValue(draftValues, this.data[rowIndex], propChanged);
    }


    updateAnswerValue(draftValues, answerValue, propChanged) {
        const newAnsw = draftValues[0][propChanged];
        answerValue[propChanged] = newAnsw;
       
        this.updateEvent();
    }

    handleCommentChange(event) {
        this.commentValue = event.target.value;
        this.updateEvent();
    }


    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        const rowIndex = this.data.findIndex(item => item.rowIndex === row.rowIndex);

        switch (action.name) {
            case 'delete':
                this.removeRow(rowIndex);
                break;
            default:
                break;
        }
    }

    addRow() {
        const newRow = {};
        this.columns.forEach(column => {
            newRow[column.fieldName] = ''; // Inicializa os valores das novas colunas com string vazia
        });

        // Adiciona a nova linha aos dados da tabela
        this.data = [...this.data,newRow];
        
        //Reatribuí os rowIndex corretamente
        this.updateRowIndexes();

        console.log('ALL DATA: ', this.data);
    }

    removeRow(rowIndex) {
        try {
            this.data.splice(rowIndex, 1);
            this.template.querySelector('lightning-datatable').draftValues = [];
        } catch(err) {

        } finally {
            this.data = [...this.data];
            this.updateRowIndexes();
            this.updateEvent();
        }
        console.log('DATA: ', this.data);
    }
    

    removeAccents(str) {
        return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    }

    updateRowIndexes() {
        for(let i in this.data) {
            this.data[i].rowIndex = i;
        }
    }

    updateEvent() {
        window.clearTimeout(this.typingTimer);
        this.typingTimer = setTimeout(() => {
            const evt = new CustomEvent("answerchange", {
                detail: {
                    id: this.questionId,
                    answer: this.data,
                    comment: this.commentValue
                }
            });
            this.dispatchEvent(evt);
        }, 500);
        
    }

}