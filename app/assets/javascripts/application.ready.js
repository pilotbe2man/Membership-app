$(document).ready(function()
{
//  healthChildcare.app.multiInput();
  healthChildcare.app.toggleMenu();
  healthChildcare.app.printTodo();
  healthChildcare.app.datepickers();
  healthChildcare.app.showRegisteredChildcaresNotification();
  healthChildcare.app.showUpgradedChildcaresNotification();
  healthChildcare.app.addAnotherCertification();
  healthChildcare.app.homeSubContentLink();

  healthChildcare.survey.submitSurveyModule();
  healthChildcare.survey.updateSurveyAttemptSubject();
  healthChildcare.survey.switchSurveyAttemptSubject();
  healthChildcare.survey.trySurveyAttepmtSubject();
  healthChildcare.survey.showSurveySubjectResult();
  healthChildcare.survey.showSingleSurveyResult();
  healthChildcare.survey.showGroupSurveyResult();
  healthChildcare.survey.showGroupSurveyMembers();
  healthChildcare.survey.setPendingSurveyOptions();

    $('.graph-bar').each(function() {
        var dataWidth = $(this).data('value');
        $(this).css("width", dataWidth + "%");
    });

    $('.iteration-selector').change(function()
    {
        var value = $(this).val();
        if (value === 'single')
        {
            $('.frequency-fields').hide();
        }
        else
        {
            $('.frequency-fields').show();
        }

    });

    $('.frequency-selector').change(function(){
        var value = $(this).val();
        if (value === 'week')
        {
            $('.frequency-weekly-fields').show();
            $('.frequency-daily-fields').hide();
        }
        else
        {
            $('.frequency-weekly-fields').hide();
            $('.frequency-daily-fields').show();
        }
    });

    $('#allocation-slider').on("input change", function()
    {
        var planAllocation = $(this).val();
        $.ajax(
        {
            url: '/api/plans/' + planAllocation,
            type: 'GET',
            dataType: 'json',
            success: function (data)
            {
                $('.wizard-form2').attr('action', '/plans/' + data.id + '/subscriptions/new');
                $('.plan-value').html(data.allocation);
                $('.plan-price').html('$' + data.price);
            }
        });
    });

  $.notifyDefaults({
    element: 'body',
    position: null,
    type: 'white',
    icon_type: 'image',
    allow_dismiss: true,
    delay: 9000,
    newest_on_top: true,
    placement: {
      from: "top",
      align: "right"
    },
    animate: {
      enter: 'animated fadeInDown',
      exit: 'animated fadeOutDown'
    },
    template: '<div data-notify="container" class="col-xs-12 col-sm-4 alert alert-{0}" role="alert">' +
      '<button type="button" aria-hidden="true" class="close" data-notify="dismiss">×</button>' +
      '<img data-notify="icon" class="img-circle pull-left" ></span> ' +
      '<span data-notify="title">{1}</span> ' +
      '<span data-notify="message">{2}</span>' +
      '</div>'
  });

  $('.slick-carousel').slick({
    infinite: true,
    slidesToShow: 5,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 2000
  });

    $('#guild-btn').click(function(){
      startIntro()
    });
/*
    if (RegExp('multipage', 'gi').test(window.location.search)) {
        if(getLocation(window.location.href).pathname == '/welcome')
        {
           startIntro(extractStep())
           intro.goToStep(extractStep())
        }
        else
        {
          startIntro()
        }

    }
    */
    guideBar();
});

function startIntro(){
    intro = introJs().setOption('doneLabel', 'Next page').start().oncomplete(function() {
        if(getLocation(window.location.href).pathname == '/instruction')
        {
            window.location.href = 'welcome?multipage=true&step=6';
        }
        else if(getLocation(window.location.href).pathname == '/dashboard')
        {
            window.location.href = 'welcome';
        }
        else if(getLocation(window.location.href).pathname == '/welcome')
        {
            window.location.href = 'dashboard?multipage=true';
        }

    }).onafterchange(function(targetElement) {
        if(targetElement.getAttribute('data-step') == '5')
        {
          (window.location.href = 'instruction?multipage=true').delay( 800 );
        }
    });

}

function extractStep()
{
    current_step = 0;
    steps = getLocation(window.location.href).search.match(/step=([0-9]+)/)
    if(steps != null)
    {
      current_step =  parseInt(steps[1])
    }
    return current_step
}

function guideBar()
{
    // ["Label" , "website link" , link_id, "bar color" , "bar image"]
    var social = [
     ["User Guide", 'javascript:void()',"guild-btn", "#365ebf", "/assets/success-icon.png"],

     ];

////////////////////////////////////////////////
//// DO NOT EDIT ANYTHING BELOW THIS LINE! /////
////////////////////////////////////////////////

    $("#socialside").append('<ul class="mainul"></ul>');

    /// generating bars
    for(var i=0;i<social.length;i++){
    $(".mainul").append("<li>" + '<ul class="scli" style="background-color:' + social[i][3] + '">' +
                        '<li id='+social[i][2] +'>' + social[i][0] + '<img src="' + social[i][4] + '"/></li></ul></li>');
                    }

    /// bar click event
    $(".scli").click(function(){
        var link = $(this).text();
        for(var i=0;i<social.length;i++){
            if(social[i][0] == link){
                startIntro();
            }
        }
    });

    /// mouse hover event
    $(".scli").mouseenter(function() {
        $(this).stop(true);
        $(this).clearQueue();
            $(this).animate({
                right : "139px"
            }, 300);

    });

    /// mouse out event
    $(".scli").mouseleave(function(){
        $(this).animate({
            right:"0px"
        },700,'easeOutBounce');
    });
}

function getLocation(href) {
    var match = href.match(/^(https?\:)\/\/(([^:\/?#]*)(?:\:([0-9]+))?)(\/[^?#]*)(\?[^#]*|)(#.*|)$/);
    return match && {
        protocol: match[1],
        host: match[2],
        hostname: match[3],
        port: match[4],
        pathname: match[5],
        search: match[6],
        hash: match[7]
    }
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");

  if ($(link).hasClass('subtask-link')) {
    $(link).parent('.subtask').remove();
  } else {
    $(link).closest(".fields").remove();

  }
  return false;
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g")

    if($(link).hasClass('subtask-link')) {
      if($(link).parent().find('.form-group').length == 0){
        $(link).after(content.replace(regexp, new_id));
      } else {
        $(link).parent().find('.form-group').last().after(content.replace(regexp, new_id));
      }
    } else if(association == 'tasks') {
      $('#tasks').append(content.replace(regexp, new_id));
    } else {
      $(link).parent().append(content.replace(regexp, new_id));
    }

    $('.datepicker').datetimepicker({
        formatDate: 'd-m-Y',
        formatTime: '',
        theme:'default',
        timepicker: false
    });
    return false;
}
function resizeIframe(obj) {
     // debugger
    obj.style.width = '100%';
    obj.style['height'] = '100%';
    // obj.style['max-height'] = '80%';
}
function click_tab(id){
        $('.jcmc-tab').removeClass('jcmc-active-tab');
        $('.jcmc-tabs li').removeClass('jcmc-active-link');
        $("#li_"+id).addClass('jcmc-active-link');
        $('.jcmc-active-link').prev().addClass("jcmc-enabled");
        $('#tab_'+id).addClass("jcmc-active-tab"); 
    }

function drawSurveyProgressTrend() {
  var srcData = $('#progress-trend').data('trend_data');
  var trendData = google.visualization.arrayToDataTable(srcData);

  var options = {
    title: window._trans['worker_progress_chart_title'],
    curveType: 'function',
    legend: { position: 'bottom' },
    vAxis: {title: 'Score Percentage',
            maxValue: 100}
    };

  var chart = new google.visualization.LineChart(document.getElementById('progress-trend'));

  chart.draw(trendData, options);
}

function drawSurveyProgressPie() {
  var pieData = $('#progress-pie').data();
  var trendData = pieData.trend_data;
  var role = pieData.daycare_role;
  var data = new google.visualization.DataTable();

  data.addColumn('string', 'Answers');
  data.addColumn('number', 'Answers');
  data.addRows(trendData);

  // set chart options
  var options = {'title': 'Correct Answers Among the Daycare ' + role,
                 'width': 1000,
                 'height': 500,
                 'is3D': true
                };

  var chart = new google.visualization.PieChart(document.getElementById('progress-pie'));
  chart.draw(data, options);
}
