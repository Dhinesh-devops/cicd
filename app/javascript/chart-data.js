$(function() {
  if ($('body').has("#chartData").length) {
    var chartData = JSON.parse($("#chartData").text());
    
    var autumn_seasons = chartData.autumn_seasons;
    var spring_seasons = chartData.spring_seasons;
    var sizes =  chartData.sizes;
    var retek_subclasses =  chartData.retek_subclasses;
    var sold_dates =  chartData.sold_dates;

    var stockPieData = {
      datasets: [{
        data: [chartData.scanned_count, chartData.missed_count, chartData.sold_count],
        backgroundColor: [
          'rgb(71, 71, 161, 1)',
          'rgb(236, 84, 141, 1)',
          'rgb(71, 161, 134, 1)'
        ],
        borderColor: [
          'rgb(71, 71, 161, 1)',
          'rgb(236, 84, 141, 1)',
          'rgb(71, 161, 134, 1)'
        ],
      }],

      // These labels appear in the legend and in the tooltips when hovering different arcs
      labels: ["Stock", "Missed", "Sold"]
    };
    var stockPieOptions = {
      responsive: true,
      animation: {
        animateScale: true,
        animateRotate: true
      },
      legend: {
        display: true
      },
    };

    if ($("#stockPieChart").length) {
      var stockPieChartCanvas = $("#stockPieChart").get(0).getContext("2d");
      var stockPieChart = new Chart(stockPieChartCanvas, {
        type: 'pie',
        data: stockPieData,
        options: stockPieOptions
      });
    }

    if ($("#sizes-chart").length) {
      var SizeChartCanvas = $("#sizes-chart").get(0).getContext("2d");
      var SizesChart = new Chart(SizeChartCanvas, {
        type: 'bar',
        data: {
          labels: sizes,
          datasets: [
            {
              label: 'Sizes',
              data: chartData.size_count,
              backgroundColor: '#5050B2'
            }
          ]
        },
        options: {
          cornerRadius: 5,
          responsive: true,
          maintainAspectRatio: true,
          layout: {
            padding: {
              left: 0,
              right: 0,
              top: 20,
              bottom: 0
            }
          },
          scales: {
            yAxes: [{
              display: true,
              gridLines: {
                display: true,
                drawBorder: false,
                color: "#F2F2F2"
              },
              ticks: {
                display: true,
                min: 0,
                max: (chartData.size_count.length > 0) ? (Math.max.apply(Math, chartData.size_count) + 10) : 10,
                callback: function(value, index, values) {
                  return  value ;
                },
                autoSkip: true,
                maxTicksLimit: 10,
                fontColor:"#6C7383"
              }
            }],
            xAxes: [{
              stacked: false,
              ticks: {
                beginAtZero: true,
                fontColor: "#6C7383"
              },
              gridLines: {
                color: "rgba(0, 0, 0, 0)",
                display: false
              },
              barPercentage: 1
            }]
          },
          legend: {
            display: false
          },
          elements: {
            point: {
              radius: 0
            }
          }
        },
      });
      document.getElementById('sizes-legend').innerHTML = SizesChart.generateLegend();
    }

    if ($("#sales-chart").length) {
      var SalesChartCanvas = $("#sales-chart").get(0).getContext("2d");
      var SalesChart = new Chart(SalesChartCanvas, {
        type: 'bar',
        data: {
          labels: sold_dates,
          datasets: [
            {
              label: 'Sold',
              data: chartData.sold_date_wise_count,
              backgroundColor: '#47A186'
            }
          ]
        },
        options: {
          cornerRadius: 5,
          responsive: true,
          maintainAspectRatio: true,
          layout: {
            padding: {
              left: 0,
              right: 0,
              top: 20,
              bottom: 0
            }
          },
          scales: {
            yAxes: [{
              display: true,
              gridLines: {
                display: true,
                drawBorder: false,
                color: "#F2F2F2"
              },
              ticks: {
                display: true,
                min: 0,
                max: (chartData.sold_date_wise_count.length > 0) ? (Math.max.apply(Math, chartData.sold_date_wise_count) + 20) : 10,
                callback: function(value, index, values) {
                  return  value ;
                },
                autoSkip: true,
                maxTicksLimit: 10,
                fontColor:"#6C7383"
              }
            }],
            xAxes: [{
              stacked: false,
              ticks: {
                beginAtZero: true,
                fontColor: "#6C7383"
              },
              gridLines: {
                color: "rgba(0, 0, 0, 0)",
                display: false
              },
              barPercentage: 1
            }]
          },
          legend: {
            display: false
          },
          elements: {
            point: {
              radius: 0
            }
          }
        },
      });
      document.getElementById('sales-legend').innerHTML = SalesChart.generateLegend();
    }

    if ($("#autumn-chart").length) {
      var AutumnChartCanvas = $("#autumn-chart").get(0).getContext("2d");
      var AutumnChart = new Chart(AutumnChartCanvas, {
        type: 'bar',
        data: {
          labels: autumn_seasons,
          datasets: [
            {
              label: 'Autumn Winter Season',
              data: chartData.autumn_with_count,
              backgroundColor: '#D69C12'
            }
          ]
        },
        options: {
          cornerRadius: 5,
          responsive: true,
          maintainAspectRatio: true,
          layout: {
            padding: {
              left: 0,
              right: 0,
              top: 20,
              bottom: 0
            }
          },
          scales: {
            yAxes: [{
              display: true,
              gridLines: {
                display: true,
                drawBorder: false,
                color: "#F2F2F2"
              },
              ticks: {
                display: true,
                min: 0,
                max: (chartData.autumn_with_count.length > 0) ? (Math.max.apply(Math, chartData.autumn_with_count) + 10) : 10,
                callback: function(value, index, values) {
                  return  value ;
                },
                autoSkip: true,
                maxTicksLimit: 10,
                fontColor:"#6C7383"
              }
            }],
            xAxes: [{
              stacked: false,
              ticks: {
                beginAtZero: true,
                fontColor: "#6C7383"
              },
              gridLines: {
                color: "rgba(0, 0, 0, 0)",
                display: false
              },
              barPercentage: 1
            }]
          },
          legend: {
            display: false
          },
          elements: {
            point: {
              radius: 0
            }
          }
        },
      });
      document.getElementById('autumn-legend').innerHTML = AutumnChart.generateLegend();
    }

    if ($("#spring-chart").length) {
      var SpringChartCanvas = $("#spring-chart").get(0).getContext("2d");
      var SpringChart = new Chart(SpringChartCanvas, {
        type: 'bar',
        data: {
          labels: spring_seasons,
          datasets: [
            {
              label: 'Spring Summer Season',
              data: chartData.spring_with_count,
              backgroundColor: '#81366D'
            }
          ]
        },
        options: {
          cornerRadius: 5,
          responsive: true,
          maintainAspectRatio: true,
          layout: {
            padding: {
              left: 0,
              right: 0,
              top: 20,
              bottom: 0
            }
          },
          scales: {
            yAxes: [{
              display: true,
              gridLines: {
                display: true,
                drawBorder: false,
                color: "#F2F2F2"
              },
              ticks: {
                display: true,
                min: 0,
                max: (chartData.spring_with_count.length > 0) ? (Math.max.apply(Math, chartData.spring_with_count) + 10) : 10,
                callback: function(value, index, values) {
                  return  value ;
                },
                autoSkip: true,
                maxTicksLimit: 10,
                fontColor:"#6C7383"
              }
            }],
            xAxes: [{
              stacked: false,
              ticks: {
                beginAtZero: true,
                fontColor: "#6C7383"
              },
              gridLines: {
                color: "rgba(0, 0, 0, 0)",
                display: false
              },
              barPercentage: 1
            }]
          },
          legend: {
            display: false
          },
          elements: {
            point: {
              radius: 0
            }
          }
        },
      });
      document.getElementById('spring-legend').innerHTML = SpringChart.generateLegend();
    }

    if ($("#retek-class-chart").length) {
      var areaData = {
        labels: retek_subclasses,
        datasets: [{
            data: chartData.retek_subclass_count,
            backgroundColor: [
              "#63b4f5", "#1875d1", "#ee6b00", "#fed44e", "#445963",
            ],
            borderColor: "rgba(0,0,0,0)"
          }
        ]
      };
      var areaOptions = {
        responsive: true,
        maintainAspectRatio: true,
        segmentShowStroke: false,
        cutoutPercentage: 78,
        elements: {
          arc: {
              borderWidth: 4
          }
        },
        legend: {
          display: false
        },
        tooltips: {
          enabled: true
        },
        legendCallback: function(chart) {
          var text = [];
          if (chartData.retek_subclasses.length > 0) {
          text.push('<div class="report-chart">');
            text.push('<div class="d-flex justify-content-between mx-4 mx-xl-5 mt-3"><div class="d-flex align-items-center"><div class="mr-3" style="width:20px; height:20px; border-radius: 50%; background-color: ' + chart.data.datasets[0].backgroundColor[0] + '"></div><p class="mb-0">' + chartData.retek_subclasses[0] + '</p></div>');
            text.push('</div>');
            text.push('<div class="d-flex justify-content-between mx-4 mx-xl-5 mt-3"><div class="d-flex align-items-center"><div class="mr-3" style="width:20px; height:20px; border-radius: 50%; background-color: ' + chart.data.datasets[0].backgroundColor[1] + '"></div><p class="mb-0">' + chartData.retek_subclasses[1] + '</p></div>');
            text.push('</div>');
            text.push('<div class="d-flex justify-content-between mx-4 mx-xl-5 mt-3"><div class="d-flex align-items-center"><div class="mr-3" style="width:20px; height:20px; border-radius: 50%; background-color: ' + chart.data.datasets[0].backgroundColor[2] + '"></div><p class="mb-0">' + chartData.retek_subclasses[2] + '</p></div>');
            text.push('</div>');
            text.push('<div class="d-flex justify-content-between mx-4 mx-xl-5 mt-3"><div class="d-flex align-items-center"><div class="mr-3" style="width:20px; height:20px; border-radius: 50%; background-color: ' + chart.data.datasets[0].backgroundColor[3] + '"></div><p class="mb-0">' + chartData.retek_subclasses[3] + '</p></div>');
            text.push('</div>');
            text.push('<div class="d-flex justify-content-between mx-4 mx-xl-5 mt-3"><div class="d-flex align-items-center"><div class="mr-3" style="width:20px; height:20px; border-radius: 50%; background-color: ' + chart.data.datasets[0].backgroundColor[4] + '"></div><p class="mb-0">' + chartData.retek_subclasses[4] + '</p></div>');
            text.push('</div>');
          text.push('</div>');
          }
          return text.join("");
        },
        plugins: {
          customPlugin: {
            consoleText: "76"
          }
        }
      }
      var retekClassChartPlugins = {
        id: 'customPlugin',
        beforeDraw: function(chart, args, options) {
          if(chart.config.type=='doughnut') {
            var width = chart.chart.width,
                height = chart.chart.height,
                ctx = chart.chart.ctx;

            ctx.restore();
            var fontSize = 3.125;
            ctx.font = "600 " + fontSize + "em sans-serif";
            ctx.textBaseline = "middle";
            ctx.fillStyle = "#000";

            var text = chartData.retek_subclass_count.reduce(function(a,b){ return a+b }, 0),
                textX = Math.round((width - ctx.measureText(text).width) / 2),
                textY = height / 2;
            ctx.fillText(text, textX, textY);
            ctx.save();
          }
        }
      }
      Chart.pluginService.register(retekClassChartPlugins);
      var retekClassChartCanvas = $("#retek-class-chart").get(0).getContext("2d");
      var retekClassChart = new Chart(retekClassChartCanvas, {
        type: 'doughnut',
        data: areaData,
        options: areaOptions,
        plugins: retekClassChartPlugins
      });
      document.getElementById('retek-class-legend').innerHTML = retekClassChart.generateLegend();
    }
  }
})