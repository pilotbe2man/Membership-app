$(document).ready(function() {

  //$.material.init();

  $(".multiple-select").select2();

  healthChildcare.message.initTemplateParser();
  healthChildcare.message.initMessageTemplateEditor();
  healthChildcare.message.initMessageEditor();
  healthChildcare.message.initMessageListFilters();
  healthChildcare.message.setSubSubjectFilter();
  healthChildcare.message.setRoleFilter();
  healthChildcare.message.initMessagePrinter();
  healthChildcare.message.initTruncator();

  // Worker's view, new child record
  healthChildcare.illness.initDatePickers();
  healthChildcare.illness.initChildIllnessForm();
  healthChildcare.illness.initSearchDepartment();
  healthChildcare.illness.childListUpdater();
  healthChildcare.illness.childProfileFetcher();
  healthChildcare.illness.determineIllness();
  healthChildcare.illness.initSearchIllness();
  healthChildcare.illness.determineSymptoms();
  healthChildcare.illness.showContactParentDetails();
  healthChildcare.illness.showContactDoctorDetails();
  healthChildcare.illness.initSearchWorkerDepartment();
  healthChildcare.illness.departmentWorkersFetcher();
  healthChildcare.illness.workerProfileFetcher();

  // Worker's view, new department record
  healthChildcare.illness.initDepartmentIllnessForm();

  // Worker's view, old illness records
  healthChildcare.illness.initChildDepartmentSelector();
  healthChildcare.illness.showDateFilters();
  healthChildcare.illness.initChildRecordFilters();
  healthChildcare.illness.initFilteredItemContentToggler();
  healthChildcare.illness.initHealthRecordPrinter();

  // Manager's view
  healthChildcare.illness.initTrendLine();
  healthChildcare.illness.initTrendPie();
  healthChildcare.illness.initTrendBar();
  healthChildcare.illness.initTrendPrinter();

  // Discussions, Parent's view
  healthChildcare.discussion.newDiscussionSubmit();
  healthChildcare.discussion.inviteCollaborator();
  healthChildcare.discussion.newCollaborationInviteSubmit();

  // Discussions, Medical Professional's view
  healthChildcare.discussion.toggleSearchChildInvitation();
  healthChildcare.discussion.searchChildInvitation();
  healthChildcare.discussion.filterDiscussions();
  healthChildcare.discussion.editMedicalProfessionalInfo();

});
