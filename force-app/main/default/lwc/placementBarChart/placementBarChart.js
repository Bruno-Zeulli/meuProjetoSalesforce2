import { LightningElement, api } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import chartJs from '@salesforce/resourceUrl/chartJs';

export default class PlacementBarChart extends LightningElement {

    @api valuesChart;
    chart;
    chartData = {};
    chartJsLoaded;
    loaded = false;
    //wrapper_func = this.template.querySelector('div');
    lColors = [
        'rgb(131, 134, 138)',
        'rgb(0,47,81)',
        'rgb(196,86,0)',
        'rgb(23,82,150)',
        'rgb(90, 53, 136)',
        'rgb(246,172,60)',
        'rgb(0,143,248)',
        'rgb(0,112,25)',
        'rgb(224,7,7)'
    ];

    connectedCallback() {
        
        this.loadChartJs().then(() => {
            this.generateChartData();
            
        }).catch(error => {
            console.error('Failed to load Chart.js', error);
        });
        
    }

    loadChartJs() {
        return new Promise((resolve, reject) => {
            loadScript(this, chartJs)
                .then(() => {
                    resolve();
                })
                .catch(error => {
                    console.error('Error loading Chart.js', error);
                    reject(error);
                });
        });
    }

    async generateChartData() {
        const statusCounts = {};
        this.valuesChart.forEach(quote => {
            if (statusCounts[quote.statusCase]) {
                statusCounts[quote.statusCase]++;
            } else {
                statusCounts[quote.statusCase] = 1;
            }
        });


        // Cria um array de datasets, um para cada statusCase
        const datasets = Object.keys(statusCounts).map((status, index) => ({
            label: status, // Label dinâmico baseado no statusCase
            backgroundColor: this.lColors[index % this.lColors.length], // Use uma cor de lColors para cada dataset
            data: [statusCounts[status]] // Contagem para cada status
        }));

        // Calcula o valor máximo das contagens
        const maxCount = Math.max(...Object.values(statusCounts));
        // Adiciona 5 ao valor máximo para evitar que a maior contagem bata no topo
        const maxYValue = maxCount + 5;

        this.chartData = {
            labels: ['Status'], // Array de labels para o gráfico, neste caso, apenas um ano
            datasets: datasets // Contém um dataset para cada statusCase
        };

        // Atualiza as opções do gráfico para definir o limite superior do eixo Y
        this.chartOptions = {
            scales: {
                y: {
                    min: 0,
                    max: maxYValue
                }
            }
        };

        this.renderChart();

    }

    renderChart() {
        const canvas = document.createElement('canvas');
        const wrapper = this.template.querySelector('#chart-container');
        const larguraDaTela = window.innerWidth;
        if (this.template.querySelector('canvas')) {
            this.template.querySelector('canvas').remove();
        }
        this.template.querySelector('div.chart').appendChild(canvas);
        const ctx = canvas.getContext('2d');
        if (this.chart) {
            this.chart.destroy();
        }

        this.chart = new Chart(ctx, {
            type: 'bar',
            data: this.chartData,
            options: {
                maintainAspectRatio: false,
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ...this.chartOptions.scales.y,
                        grid: {
                            display: false // Desativa as linhas de grade no eixo Y
                        }
                    }
                },
                layout: {
                    padding: {
                        left: 10,
                        right: 10,
                        
                    }
                },
                plugins: {
                    title: {
                        display: true,
                        text: 'Visão geral das negociações',
                        align: 'center',
                        padding: 10,
                        color: '#000',
                        font: { 
                            weight: 'bold',
                            size: 20
                        }
                    },
                    legend: {
                        display: true,
                        position: 'right',
                        
                    }
                }
            }
        });

        function ajustarLarguraDoComponente(){
            const canvas_func = window.document.querySelector('canvas');
            const warapper_func = canvas_func.parentElement;
            const larguraDaTela_func = window.innerWidth;
            const width = larguraDaTela_func - 300 + "px";
            canvas_func.style.width = width;
            canvas_func.style.height = "300px";
            warapper_func.style.maxWidth = width;
        }

        /* ajustarLarguraDoComponente();
        window.addEventListener("resize", ajustarLarguraDoComponente); */
        this.chart.update();
        this.chart.resize();
    }
}