healthChildcare.survey = {
  submitSurveyModule: function()
  {
    $("body").on("submit", '.submit-attempt', function() {
      var tabId = $(this).attr('data-tab');
      $.ajax(
        {
          url: $(this).attr('action'),
          type: 'POST',
          data: $(this).serialize(),
          dataType: 'json',
          success: function (data)
          {
            click_tab(tabId);
          }
        });
      return false;
    });
  },

  setPendingSurveyOptions: function() {
    $('.survey-option').on('click', function() {
      var option_id = $(this).val();
      var question_id = $(this).data("question");
      var survey_id = $(this).data("survey");
      var user_id = $(this).data("user");
      var subject_id = $(this).data("subject");

      pending_url = '/add_pending_option';
      $.ajax(
        {
          url: pending_url,
          type: 'POST',
          data: {
            survey_id: survey_id,
            question_id: question_id,
            option_id: option_id,
            user_id: user_id,
            subject_id: subject_id
          },
          dataType: 'json',
          success: function (data)
          {
          }
        });
    });
  },

  updateSurveyAttemptSubject: function() {
    $('.retake-radio').change(function() {
      var subjectId = $(this).val();
      $('#retake-form').attr('action', '/subjects/' + subjectId + '/attempts/new')
    });
  },

  switchSurveyAttemptSubject: function() {
    $('.retake-survey-radio').on('click', function() {
      $('.panel-body').find('a').removeClass('active');
      var subjectId = $(this).val();
      if($('#current_subject').val() != subjectId){
        window.location.href = '/subjects/' + subjectId + '/attempts/new';
      }
    });
  },

  trySurveyAttepmtSubject: function() {
    $('.jcmc-buttons .btn-next').on('click', function() {
      $(this).html("Next <i class='fa fa-icon fa-spinner load-animate'></i>");
    });
  },

  showSurveySubjectResult: function() {
    $('input.retake-radio').on('click', function() {
      // $('.panel-body').find('a').removeClass('active');
      // var subjectId = $(this).val();
      // var progressDiv = $('#progress_charts_partial');
      // var currentRole = $(this).data('current_role');
      // var userRole = $('#current_user_role').val();

      // var url = '/subjects/' + subjectId + '/result';
      // var methodType = (userRole == 'partner') ? 'POST' : 'GET';

      // $('.group-members').hide();

      // if (currentRole && currentRole.length > 0) {
      //   url = '/' + currentRole + url;
      // }

      // $.ajax({
      //   url: url,
      //   type: methodType,
      //   success: function(resultHtml) {
      //     progressDiv.html(resultHtml);
      //   }
      // });
      $('.group-members').find('a.active').click();
    });

    $('input.partner-radio').on('click', function() {
      var subjectId = $(this).val();
      var progressDiv = $('#progress_charts_partial');
      var currentRole = $(this).data('current_role');
      var url = '/subjects/' + subjectId + '/result';
      var daycares = $('#selected_daycares').val().split(',');

      if (currentRole && currentRole.length > 0) {
        url = '/' + currentRole + url;
      }

      $('.group-members').hide();

      $.ajax({
        url: url,
        type: 'POST',
        data:{
          target_daycare: daycares,
          start_date: $('#start_date').val(),
          end_date: $('#end_date').val()
        },
        success: function(resultHtml) {
          progressDiv.html(resultHtml);
        }
      });
    });


    $('input.municipal-subject-radio').on('click', function() {
      get_municipal_survey_result('input.municipal-subject-radio:checked', 'input.survey-municipal-radio:checked');
    });

    $('input.survey-municipal-radio').on('click', function() {
      get_municipal_survey_result('input.municipal-subject-radio:checked', 'input.survey-municipal-radio:checked');
    });

    function get_municipal_survey_result(subject_elem, municipal_elem){
      var subjectId = $(subject_elem).val();
      var progressDiv = $('#progress_charts_partial');
      var currentRole = $(subject_elem).data('current_role');
      var url = '/subjects/' + subjectId + '/result';
      var municipal = $(municipal_elem).val();

      if (currentRole && currentRole.length > 0) {
        url = '/' + currentRole + url;
      }

      $('.group-members').hide();
      if ( subjectId == undefined || municipal == undefined) return;
      $.ajax({
        url: url,
        type: 'POST',
        data:{
          target_municipal: municipal,
          start_date: $('#start_date').val(),
          end_date: $('#end_date').val()
        },
        success: function(resultHtml) {
          progressDiv.html(resultHtml);
        }
      });
    }

    $('input.partner-todo-radio').on('click', function() {
      var todoId = $(this).val();
      $('#todo_id').val(todoId);
      $('#todo_result_form').submit();
    });

    $('input.municipal-todo-radio').on('click', function() {
      get_municipal_todo_result('input.municipal-todo-radio:checked', 'input.todo-municipal-radio:checked');
    });

    $('input.todo-municipal-radio').on('click', function() {
      get_municipal_todo_result('input.municipal-todo-radio:checked', 'input.todo-municipal-radio:checked');
    });

    function get_municipal_todo_result(todo_elem, municipal_elem){
      var todoId = $(todo_elem).val();
      var progressDiv = $('.survey-charts');
      var url = '/partner/todos/' + todoId + '/task_result';
      var municipal = $(municipal_elem).val();

      if ( todoId == undefined || municipal == undefined) return;

      $.ajax({
        url: url,
        type: 'POST',
        data:{
          target_municipal: municipal,
          start_date: $('#start_date').val(),
          end_date: $('#end_date').val()
        },
        success: function(resultHtml) {
          progressDiv.html(resultHtml);
        }
      });
    }

    $('input.illness-municipal-radio').on('click', function() {
      var municipal = $(this).val();
      var illnesses = $('#illness_codes_').val();
      if ( illnesses == undefined || municipal == undefined) return;

      var progressDiv = $('#trends');
      var url = '/partner/illnesses/municipal_trends';
      $.ajax({
        url: url,
        type: 'POST',
        data:{
          target_municipal: municipal,
          illness_codes: illnesses,
          graph_type: $('#graph_type').val(),
          start_date: $('#start_date').val(),
          end_date: $('#end_date').val()
        },
        success: function(resultHtml) {
          progressDiv.html(resultHtml);
        }
      });

    });
  },

  showSingleSurveyResult: function() {
    $('.get-single-user-result').on('click', function() {
      var userId = $(this).attr('data-id'),
          subjectId = $('input[name="subject_id"]:checked').val(),
          _this = this;

      var userRole = $('#current_user_role').val();
      var reqUrl = '';

      if(userRole == 'partner'){
        reqUrl = '/partner/subjects/' + subjectId + '/user_result?user_id=' + userId;
      } else {
        reqUrl = '/manager/subjects/' + subjectId + '/user_result?user_id=' + userId;
      }

      $.ajax(
        {
          url: reqUrl,
          type: 'GET',
          success: function (html)
          {
            $('#progress_charts_partial').html(html);
            $('.panel-body').find('a').removeClass('active');
            $(_this).addClass('active');
          }
        });
      return false;
    });

    $('.get-single-daycare-result').on('click', function() {
      var daycareId = $(this).attr('data-id'),
          subjectId = $('input[name="subject_id"]:checked').val(),
          _this = this;
      var daycares = $('#selected_daycares').val().split(',');

      $.ajax(
        {
          url: '/partner/subjects/' + subjectId + '/daycare_result',
          type: 'POST',
          data:{
            daycare_id: daycareId,
            start_date: $('#start_date').val(),
            end_date: $('#end_date').val()
          },
          success: function (html)
          {
            $('#progress_charts_partial').html(html);
            $('.panel-body').find('a').removeClass('active');
            $(_this).addClass('active');
          }
        });
      return false;
    });

  },

  showGroupSurveyResult: function() {
    $('.get-group-result').on('click', function() {
      var subjectId = $('input[name="subject_id"]:checked').val(),
          subjectGroup = $(this).data('subject_group'),
          _this = this;

      var userRole = $('#current_user_role').val();
      var methodType = (userRole == 'partner') ? 'POST' : 'GET';
      var reqUrl = '';

      if(userRole == 'partner'){
        reqUrl = '/partner/subjects/' + subjectId + '/group_result?role=' + subjectGroup;
      } else {
        reqUrl = '/manager/subjects/' + subjectId + '/group_result?role=' + subjectGroup;
      }

      $.ajax(
        {
          url: reqUrl,
          type: methodType,
          success: function (html)
          {
            $('#progress_charts_partial').html(html);
            $('.panel-body').find('a').removeClass('active');
            $(_this).addClass('active');
          }
        });
      return false;
    });

    $('.get-daycare-result').on('click', function() {
      var subjectId = $('input[name="subject_id"]:checked').val(),
          subjectGroup = $(this).data('subject_group'),
          _this = this;
      var daycares = $('#selected_daycares').val().split(',');

      $.ajax(
        {
          url: '/partner/subjects/' + subjectId + '/daycare_group_result',
          type: 'POST',
          data:{
            target_daycare: daycares,
            start_date: $('#start_date').val(),
            end_date: $('#end_date').val()
          },
          success: function (html)
          {
            $('#progress_charts_partial').html(html);
            $('.panel-body').find('a').removeClass('active');
            $(_this).addClass('active');
          }
        });
      return false;
    });
  },

  showGroupSurveyMembers: function() {
    $('.group-header').on('click', function() {
      $(this).siblings('.group-members').slideToggle();
    });
  },

  initSurveyFilters: function(){
  }

}
