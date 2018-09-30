healthChildcare.message = {

  initTemplateParser: function() {
    // readable files : [*.html, *.txt]
    $('#upload-template').on('change', function() {
      /*
      var file = this.files[0]
      var reader = new FileReader();

      if (file.type.match('text.*')) {
        reader.onload = function(progressEvent){
          $('#message_template_content').val(this.result)
          $('#message_template_content').froalaEditor('html.set', this.result);
        };
        reader.readAsText(file);
      }
      else {
        alert(window._trans['invalid_template_file']);
      }
      */
    });
  },

  initMessageTemplateEditor: function() {
    // $('#message_template_content').froalaEditor({
    //   heightMin: 200
    // });
  },

  setSubSubjectFilter: function() {
    $('select#subject_id').on('change', function() {
      var subjectId = $(this).val();

      $.ajax({
        url: '/messages/sub_subjects',
        data: {subject_id: subjectId},
        success: function(html) {
          $('#sub-subject-filter').html(html);
        }
      })
    });
  },

  setRoleFilter: function() {
    $('#target_role').on('change', function() {
      var targetRole = $(this).val();

      if (targetRole.length > 0) {
        $('#subject-filter').removeClass('hidden');
        $('#sub-subject-filter').removeClass('hidden');
      }
    });
  },

  initMessageListFilters: function() {
    $('#apply-message-filters').on('click', function() {
      var userRole = $('#user_role').val();
      var listType = $('#list_type').val();
      var targetRole = $('#target_role').val();
      var subjectId = $('#subject_id').val();
      var subSubjectId = $('#sub_subject_id').val();
      var startDate = $('#start_date').val();
      var endDate = $('#end_date').val();
      var valid = true;

      if (targetRole.length < 1 ) {
        alert(window._trans['required_filter_role']);
        valid = false;
      }

      if (subjectId != undefined && subjectId.length < 1) {
      alert(window._trans['required_filter_subject']);
        valid = false;
      }

      if (subSubjectId != undefined && subSubjectId.length < 1) {
        alert(window._trans['required_filter_sub_subject']);
        valid = false;
      }

      if (valid) {
        $.ajax({
          url: "/" + userRole + "/messages/" + listType + "/list",
          type: 'GET',
          data: {
          target_role: targetRole,
            subject_id: subjectId,
            sub_subject_id: subSubjectId,
            start_date: startDate,
            end_date: endDate
          },
          success: function(data) {
            $('.filtered-contents').html(data);
            healthChildcare.message.initTruncator();
            window.location.href = '#';
          }
        });
      }
    });
  },

  initMessagePrinter: function() {
    $('.print-msg-btn').on('click', function() {
      var data = $(this).data();
      var target = data.target_message;
      var subject = data.subject;
      var subSubject = data.sub_subject;
      var header = '';

      if (subject.length > 0) {
        header = 'Subject : ' + subject + '</br>';
        header += 'Sub-subject : ' + subSubject;
      }

      $(target).printThis({
        header: header,
        pageTitle: 'Healthier Childcare Alliance',
        importCSS: false,
        importStyle: false,
        formValues: false,
        printContainer: false
      });
    });
  },

  initTruncator: function() {
    $('.truncate').shorten({
      showChars: 600,
      moreText: '<i class="fa fa-chevron-down"></i>',
      lessText: '<i class="fa fa-chevron-up"></i>'
    });
  },

  initMessageEditor: function() {
  }
}
