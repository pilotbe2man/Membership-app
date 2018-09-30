healthChildcare.discussion = {

  getDiscussionTargets: function() {
    var allCollaboratorList = $('.collaborator:not(".pending")');
    var selectedCollaborators = [];
    var allCollaborators = [];

    allCollaboratorList.each(function() {
      collabId = $(this).data('collaborator_id');
      collabType = $(this).data('collaborator_type');
      collab = [collabId, collabType];
      allCollaborators.push(collab);

      if ($(this).hasClass('active')) {
        selectedCollaborators.push(collab);
      }
    });

    // if no particular discussion is selected, show/target all
    if (selectedCollaborators.length == 0) {
      selectedCollaborators = allCollaborators;
    }

    return selectedCollaborators;
  },

  newDiscussionSubmit: function() {
    var _this = this;

    $('form.new_discussion')
      .on('ajax:beforeSend', function(e, xhr, settings) {
        var collabs = _this.getDiscussionTargets();
        console.log(collabs);
        settings.data += '&' + $.param({discussion_participants: collabs});
        return true;
      })
      .on('ajax:success', function(e, data, status, xhr) {
        $('.discussions').append(data);
        $('.discussions').animate({scrollTop: $('.discussions').prop("scrollHeight")}, 500);

        $(this).find('textarea').val('');
      });
  },

  inviteCollaborator: function() {
    $('#submit-invite-form').on('click', function() {
      $('#new_collaboration_invite').trigger('submit');
    });

    $('#invite-collaborator-modal').modal('hide');
  },

  newCollaborationInviteSubmit: function() {
    $('form.new_collaboration_invite').on('ajax:success', function(e, data, status, xhr) {
      $('li.collaborator').after(data);
      $('#invite-collaborator-modal').modal('hide');

      $('.invite-limited').removeClass('hide');
      $('.invite-unlimited').html('')
    });
  },

  toggleSearchChildInvitation: function() {
    $('.toggle-child-invitation-link').on('click', function() {
      $('.find-child-invitation-option').toggle();
      $('.find-child-invitation-link').toggle();
    });
  },

  searchChildInvitation: function() {
    var dataDOM = $('#search-child-invitation');
    var dataSrc = dataDOM.data('child_names');
    var _this = this;
    $(dataDOM).data('child_names', null);

    $(document).find('#invitee_child').typeahead(
      {
        highlight: true,
        minLength: 1
      },
      {
        limit: 0,
        source: _this.substringMatcher(dataSrc)
      }
    );
  },

  substringMatcher: function(strs) {
    return function findMatches(q, cb) {
      var matches, substringRegex;

      // an array that will be populated with substring matches
      matches = [];

      // regex used to determine if a string contains the substring `q`
      substrRegex = new RegExp(q, 'i');

      // iterate through the pool of strings and for any string that
      // contains the substring `q`, add it to the `matches` array
      $.each(strs, function(i, str) {
        if (substrRegex.test(str)) {
          matches.push(str);
        }
      });

      cb(matches);
    }
  },

  filterDiscussions: function() {
    var _this = this;

    $('.collaborator').on('click', function() {
      $(this).toggleClass('active');

      _this.showDiscussions();
    });
  },

  showDiscussions: function(selectedOwnerIds) {
    var selectedCollaborators = this.getDiscussionTargets();

    if (selectedCollaborators.length == 0) {
      $('.discussion').show();
    }
    else {
      $('.discussion').each(function() {
        var discussionOwnerId = parseInt($(this).data('owner_id'));
        var discussionOwnerType = $(this).data('owner_type');
        var _this = this;
        var show = false;

        $.each(selectedCollaborators, function(idx, activeCollaborator) {
          collaboratorId = activeCollaborator[0];
          collaboratorType = activeCollaborator[1];

          if (collaboratorId == discussionOwnerId && collaboratorType == discussionOwnerType)
            show = true;
        });

        if (show) {
          $(_this).show();
        }
        else {
          $(_this).hide();
        }
      })
    }
  },

  editMedicalProfessionalInfo: function() {
    $('#submit-edit-medical-professional-form').on('click', function() {
      $('#edit_medical_professional').trigger('submit');
    });

    $('#edit-medical-professional-modal').modal('hide');
  }

}
