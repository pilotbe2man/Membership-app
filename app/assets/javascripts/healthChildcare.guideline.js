healthChildcare.guideline = {
  managerMessageSendStep: function(stepNumber, nextLabel, prevLabel, doneLabel, skipLabel){
    stepNumber++;
    intro = introJs().setOptions({
      doneLabel: doneLabel,
      nextLabel: nextLabel,
      prevLabel: prevLabel,
      skipLabel: skipLabel
    })
      .start().oncomplete(function() {
        window.location.href = 'send_step'+stepNumber+'?multipage=true';
      });    
  },
/*
  managerMessageSendStep2: function(){
    introJs().setOption('doneLabel', 'Next Step').start().oncomplete(function() {
      window.location.href = 'send_step3?multipage=true';
    });
  },

  managerMessageSendStep3: function(){
    introJs().setOption('doneLabel', 'Next Step').start().oncomplete(function() {
      window.location.href = 'send_step4?multipage=true';
    });
  },

  managerMessageSendStep4: function(){
    introJs().setOption('doneLabel', 'Next Step').start().oncomplete(function() {
      window.location.href = 'send_step5?multipage=true';
    });
  },

  managerMessageSendStep5: function(){
    intro = introJs().setOption('doneLabel', 'Done').start().oncomplete(function() {
      window.location.href = 'dash?multipage=true';
    });    
  },
*/
  dashboarStep: function(nextLabel, prevLabel, doneLabel, skipLabel){
    intro = introJs().setOptions({
      doneLabel: doneLabel,
      nextLabel: nextLabel,
      prevLabel: prevLabel,
      skipLabel: skipLabel      
    }).start().oncomplete(function() {
      window.location.href = 'dash?multipage=true';
    });    
  },

  // managerMessageSentStep1: function(){
  //   intro = introJs().setOption('doneLabel', 'Done').start().oncomplete(function() {
  //     window.location.href = 'dash?multipage=true';
  //   });    
  // },

  // managerMessageReceiveStep1: function(){
  //   intro = introJs().setOption('doneLabel', 'Done').start().oncomplete(function() {
  //     window.location.href = 'dash?multipage=true';
  //   });    
  // },

  // managerIllnessStep1: function(){
  //   introJs().setOption('doneLabel', 'Next Step').start().oncomplete(function() {
  //     window.location.href = 'graph_step2?multipage=true';
  //   });
  // },

  // managerIllnessStep2: function(){
  //   intro = introJs().setOption('doneLabel', 'Done').start().oncomplete(function() {
  //     window.location.href = 'graph_step1?multipage=true';
  //   });    
  // },

  // managerTodoStep1: function(){
  //   intro = introJs().setOption('doneLabel', 'Done').start().oncomplete(function() {
  //     window.location.href = 'dash?multipage=true';
  //   });    
  // },

  // managerTodoReportStep1: function(){
  //   introJs().setOption('doneLabel', 'Next Step').start().oncomplete(function() {
  //     window.location.href = 'report_step2?multipage=true';
  //   });
  // },

  // managerTodoReportStep2: function(){
  //   introJs().setOption('doneLabel', 'Next Step').start().oncomplete(function() {
  //     window.location.href = 'report_step3?multipage=true';
  //   });
  // },

  // managerTodoReportStep3: function(){
  //   intro = introJs().setOption('doneLabel', 'Done').start().oncomplete(function() {
  //     window.location.href = 'dash?multipage=true';
  //   });    
  // },

  // managerSurveyStep1: function(){
  //   introJs().start();
  // },

  introGoToStep: function(nextPage, nextLabel, prevLabel, doneLabel, skipLabel){
    introJs().setOptions({
      doneLabel: doneLabel,
      nextLabel: nextLabel,
      prevLabel: prevLabel,
      skipLabel: skipLabel
    }).start().oncomplete(function() {
      window.location.href = nextPage + '?multipage=true';
    });
  },

  introOnePageStep: function(){
    introJs().start();
  }, 

  initParent: function(){

  }
}