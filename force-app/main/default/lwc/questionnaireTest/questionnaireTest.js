import { LightningElement, wire, api, track} from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import getAnswers from '@salesforce/apex/QuestionnaireTestController.getAnswers';
import JSPDF from '@salesforce/resourceUrl/jspdf';

export default class QuestionnaireTest extends LightningElement {
    @api recordId;
    error;
    rawRecords = [];
    @track groupedRecords = [];

    pdfData = [];
    loaded = false;

    renderedCallback() {
        Promise.all([
            loadScript(this, JSPDF)
        ]);
    }

    @wire(getAnswers, { questionnaireId: '$recordId' })
    listInfo({ error, data }) {
        if (data) {
            this.rawRecords = data;
            this.pdfData = JSON.parse(JSON.stringify(data));
            console.log('PDF DATA:', this.pdfData);
            this.groupRecords();
            this.loaded = true;
            this.error = undefined;
        } else if (error) {
            this.loaded = true;
            this.error = error;
            this.rawRecords = undefined;
        }
    }

    groupRecords() {
        const sessionMap = new Map();
        this.rawRecords.forEach(record => {
            const sessionName = record.Questionnaire_Question__r.Session_Name__c;
            if (!sessionMap.has(sessionName)) {
                sessionMap.set(sessionName, []);
            }
            sessionMap.get(sessionName).push(record);
        });
        this.groupedRecords = Array.from(sessionMap, ([sessionName, questions]) => ({
            sessionName,
            questions: questions.map((question, index) => ({
                ...question,
            }))
        }));
    }

    handleAnswerChange(event) {
        const data = JSON.parse(JSON.stringify(event.detail));
        console.log('answer change', data);

        let questionChanged = this.pdfData.find(question => question.Id === data.id)
        let indexQuestionChanged = this.pdfData.indexOf(questionChanged);

        this.pdfData[indexQuestionChanged].Answer__c = data.answer;

        console.log('PDF DATA UPDATED:', this.pdfData);
    }

    exportQuestionnaireAsPDF() {
        try{
            this.generatePdf();
        } catch(e){
            console.log(e)
        }
        
    }

    generatePdf() {
        const { jsPDF } = window.jspdf;
        const sessions = {};
        let sessionCount = 1;

        let numberOfPages;

        let questionnaireName = this.pdfData.length > 0 ? this.pdfData[0].Questionnaire__r.Name : '';
        questionnaireName = questionnaireName.toUpperCase();

        let pdfName = questionnaireName.toLowerCase();

        //Header message
        const message = "Prezados,\n\nAs questões abaixo são de suma importância para enquadramento do risco e nos ajudam junto às seguradoras na obtenção de uma proposta e possivelmente melhores custos. É imprescindível que todas as questões sejam respondidas.";

        //Footer Message
        let declarationMessage;

        // Agrupar as perguntas por Session_Name__c
        this.pdfData.forEach(obj => {
            const sessionName = obj.Questionnaire_Question__r.Session_Name__c;
            if (!sessions[sessionName]) {
                sessions[sessionName] = [];
            }
            sessions[sessionName].push(obj);
        });
    
        // Criar o documento PDF
        const doc = new jsPDF();
        let yPos = 15;

        // Adicionar o nome do questionário como cabeçalho
        doc.setFontSize(12);
        doc.text(15, yPos, questionnaireName);
        yPos += 15; // Ajustar a posição Y

        const messageLines = doc.splitTextToSize(message, 180); // 180 é a largura máxima do texto
        messageLines.forEach(line => {
            doc.setFontSize(10);
            doc.text(15, yPos, line);
            yPos += 7; // Ajustar a posição Y para a próxima linha
        });
        yPos += 10; // Adicionar espaço após a mensagem

    
        // Iterar sobre as sessões e adicionar o conteúdo ao PDF
        for (const sessionName in sessions) {
            if (sessions.hasOwnProperty(sessionName)) {
                // Adicionar o nome da sessão como cabeçalho
                doc.setFontSize(12);
                doc.text(15, yPos, sessionCount + '. ' + sessionName);
                doc.setFontSize(10);
                yPos += 15; // Ajustar a posição Y
                sessionCount++;
    
                const questions = sessions[sessionName];
                questions.forEach(question => {
                    const label = question.Question_Label__c;
                    let answer;

                    if(question.Answer__c != undefined) {
                        answer = question.Answer__c;
                    } else {
                        answer = '';
                    }
                    
                    // Exibir a pergunta em negrito
                    doc.setFont('helvetica', 'bold');
                    doc.text(20, yPos, "Pergunta: ");
                    doc.setFont('helvetica', 'normal');
                    yPos += 7; // Ajustar a posição Y para a próxima linha

                    // Quebrar o conteúdo da pergunta em várias linhas, se necessário
                    const questionLines = doc.splitTextToSize(label, 180); // 180 é a largura máxima do texto
                    questionLines.forEach(line => {
                        doc.text(20, yPos, line);
                        yPos += 7; // Ajustar a posição Y para a próxima linha
                    });

                    // Exibir a resposta
                    yPos += 5; // Adicionar um espaço entre a pergunta e a resposta
                    doc.setFont('helvetica');
                    doc.text(20, yPos, "Resposta: ");
                    doc.setFont('helvetica', 'normal');
                    yPos += 7; // Ajustar a posição Y para a próxima linha

                    if(question.Question_Type__c === "Tabela") {
                        if(typeof answer === 'string') {
                            answer = JSON.parse(answer);
                        }

                        let headers = this.createHeaders(Object.keys(answer[0]));
                        const data = answer;

                        // Calcular a altura da tabela
                        const tableHeight = this.calculateTableHeight(data, headers, doc, headers.length);

                        // Adicionar a tabela ao PDF
                        doc.table(20, yPos, data, headers, { fontSize: 10 });

                        // Atualizar a posição Y após a tabela
                        yPos += tableHeight + 10;

                    } else if(question.Question_Type__c === "Sim/Não") {

                        const checkboxSize = 5;
                        let xPosFirstCheckbox = 20;

                        const yesLabel = "Sim";
                        const noLabel = "Não";

                        if(answer == 'true') {
                            const xCheckmark = xPosFirstCheckbox + 0.5 * checkboxSize - 0.5; // Ajuste de 0.5 para centralizar horizontalmente
                            const yCheckmark = yPos + 2 + 0.5 * checkboxSize + 0.5; // Ajuste de 0.5 para centralizar verticalmente

                            doc.text(xPosFirstCheckbox, yPos, yesLabel);
                            doc.rect(xPosFirstCheckbox, yPos + 2, checkboxSize, checkboxSize);
                            doc.text('x', xCheckmark, yCheckmark);

                            doc.text(xPosFirstCheckbox + 20, yPos, noLabel);
                            doc.rect(xPosFirstCheckbox + 20, yPos + 2, checkboxSize, checkboxSize);
                            
                        } else {
                            const xCheckmark = xPosFirstCheckbox + 20 + 0.5 * checkboxSize - 0.5; // Ajuste de 0.5 para centralizar horizontalmente
                            const yCheckmark = yPos + 2 + 0.5 * checkboxSize + 0.5; // Ajuste de 0.5 para centralizar verticalmente

                            doc.text(xPosFirstCheckbox, yPos, yesLabel);
                            doc.rect(xPosFirstCheckbox, yPos + 2, checkboxSize, checkboxSize);
                            
                            doc.text(xPosFirstCheckbox + 20, yPos, noLabel);
                            doc.rect(xPosFirstCheckbox + 20, yPos + 2, checkboxSize, checkboxSize);
                            doc.text('x', xCheckmark, yCheckmark);
                        }

                        yPos += 15;

                    } else if(question.Question_Type__c === "Checkbox") {

                        const checkboxSize = 5;
                        let xPosFirstCheckbox = 20;
                        let yPosCheckbox = yPos; // Posição inicial da checkbox

                        let numOptions = 1;
                        
                        // Verificar se Options__c está definido
                        if (question.Questionnaire_Question__r.Options__c) {
                            const options = question.Questionnaire_Question__r.Options__c.split(';').map(option => option.trim());
                            numOptions = options.length;
                            const answers = answer.split(';').map(answer => answer.trim());
                    
                            options.forEach(option => {
                                const xCheckmark = xPosFirstCheckbox + 0.5 * checkboxSize - 0.5; // Ajuste de 0.5 para centralizar horizontalmente
                                const yCheckmark = yPosCheckbox + 0.5 * checkboxSize + 0.5; // Ajuste de 0.5 para centralizar verticalmente

                                if(answers.includes(option.trim())) {
                                    doc.rect(xPosFirstCheckbox, yPosCheckbox, checkboxSize, checkboxSize);
                                    doc.text('x', xCheckmark, yCheckmark);
                                    doc.text(xPosFirstCheckbox + 10, yPosCheckbox + 4, option);
                                } else {
                                    doc.rect(xPosFirstCheckbox, yPosCheckbox, checkboxSize, checkboxSize);
                                    doc.text(xPosFirstCheckbox + 10, yPosCheckbox + 4, option);
                                }
                    
                                yPosCheckbox += 10; // Incrementar a posição Y para a próxima linha
                            });
                            
                        } 

                        yPos += (numOptions * 10);
                    }else {
                        // Quebrar o conteúdo da resposta em várias linhas, se necessário
                        const answerLines = doc.splitTextToSize(answer, 180); // 180 é a largura máxima do texto
                        answerLines.forEach(line => {
                            doc.text(20, yPos, line);
                            yPos += 7; // Ajustar a posição Y para a próxima linha
                        });
                    }
    
                    // Adicionar uma linha em branco após a resposta
                    yPos += 5;
    
                    // Verificar se é necessário criar uma nova página
                    if (yPos >= 265) { // 280 é a altura máxima de uma página do jsPDF
                        doc.addPage();
                        yPos = 15; // Reiniciar a posição Y na nova página
                    }
                });
    
                // Adicionar um espaço entre sessões
                yPos += 10;
            }
        }

        //Adicionar nova página
        if(yPos != 25) {
            doc.addPage();
            yPos = 15; // Reiniciar a posição Y na nova página  
        }

        // Adicionar a sessão "Declaração"
        doc.setFontSize(12);
        doc.text(15, yPos, sessionCount + '. ' + "Declaração");
        doc.setFontSize(10);
        yPos += 15; // Ajustar a posição Y
        
        numberOfPages = doc.getNumberOfPages();

        //Declaration message
        declarationMessage = `Declaro que todas as informações deste questionário são verdadeiras, que não omiti, suprimi ou falsifiquei qualquer fato importante, assumindo toda responsabilidade por sua exatidão. Eu concordo que as declarações, detalhes e respostas contidas neste questionário de ${numberOfPages} páginas constituem parte do contrato proposto e que quaisquer alterações, procedimentos e/ou equipamentos de proteção sejam feitos somente após o aval da seguradora.`;

        // Adicionar o conteúdo da declaração
        const declarationLines = doc.splitTextToSize(declarationMessage, 180); // 180 é a largura máxima do texto
        declarationLines.forEach(line => {
            doc.text(20, yPos, line);
            yPos += 7; // Ajustar a posição Y para a próxima linha
        });

        // Adicionar quebras de linha após a declaração
        yPos += 10;

        // Adicionar a assinatura em negrito
        doc.setFont('helvetica', 'bold');
        doc.text(15, yPos, "Assinatura: ");
        doc.setFont('helvetica', 'normal');
        yPos += 7; // Ajustar a posição Y para a próxima linha


        // Adicionar quebras de linha após a assinatura
        yPos += 20;

        // Adicionar o local e a data
        const currentDate = new Date().toLocaleDateString('pt-BR');
        const locationAndDate = "Local e Data: São Paulo, " + currentDate;
        doc.text(15, yPos, locationAndDate);
        
        // Salvar ou exibir o PDF
        doc.save(pdfName+'.pdf');
    }

    createHeaders(keys) {
        let result = [];

        for(let i = 0; i < keys.length; i++) {
            result.push({
                id: keys[i],
                name: keys[i],
                prompt: keys[i],
                width: 35,
                align: 'center',
                padding: 0
            });
        }

        return result;
    }


    calculateTableHeight(data, headers, doc, headersLength) {
        const lineHeight = 7; // Altura estimada de cada linha
        let tableHeight = 0;
    
        // Calcular a altura de cada linha da tabela
        data.forEach(row => {
            let rowHeight = 0;
            headers.forEach(header => {
                const cellContent = row[header.id].toString();
                const numLines = Math.ceil(doc.getTextWidth(cellContent) / (35/headersLength)); // Dividir a largura máxima do texto (180) para obter o número de linhas
                rowHeight = Math.max(rowHeight, numLines);
            });
            tableHeight += rowHeight * lineHeight; // Adicionar a altura da linha à altura total da tabela
        });
    
        return tableHeight;
    }
}