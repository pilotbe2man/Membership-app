healthChildcare.illness = {

  initDatePickers: function() {
    $('.datepicker').datetimepicker({
      format: 'd/m/Y',
      timepicker: false,
      maxDate: new Date()
    });
  },

  initChildIllnessForm: function() {
    $('#new-child-record').steps({
      headerTag: "label",
      bodyTag: "section",
      transitionEffect: "slideLeft",
      stepsOrientation: "vertical",
      onInit: function() {$('#new-child-record').show()},
      labels: {
        finish: 'Submit'
      },
      onFinished: function() {
        $('form').trigger('submit');
      }
    });
  },

  initSearchDepartment: function() {
    var data = $('form').find('#search-department-name').data('department_names');

    $(document).find('#search-department-name .typeahead')
      .typeahead(
        {
          highlight: true
        },
        {
          limit: 10,
          source: function(query, process) {
            var names = [];
            var map = {};

            $.each(data, function(i, dept) {
              map[dept.name] = dept;
              names.push(dept.name);
            });

            process(names);
          },
          matcher: function (target) {
            if (target.toLowerCase().indexOf(this.query.trim().toLowerCase()) !== -1) {
              return true;
            }
          },
          sorter: function (departments) {
            return departments.sort();
          },
          highlighter: function (target) {
            var regex = new RegExp( '(' + this.query + ')', 'gi' );
            return target.replace( regex, "<strong>$1</strong>" );
          },
          updater: function (target) {
            selectedDept = map[target].id;
            return target;
          },
          templates: {
            suggestion: function(target) {
              return "<div>" + target + "</div>"
            }
          }
        })
      .bind('typeahead:select', function(ev, suggestion) {
        $('form').find('input[data-department_name="' + suggestion + '"]').prop('checked', true);
        $('form').find('input[name="department[id]"]').trigger('change');
      });
  },

  childListUpdater: function() {
    $('input[name="department[id]"]').on('change', function() {
      $('#search-child-name').typeahead('destroy');
      var deptId = $('input[name="department[id]"]:checked').val();

      $.ajax({
        url: '/illnesses/department_children',
        data: {department_id: deptId},
        type: 'GET',
        success: function(html) {
          $('form').find('.choose-child').html(html);
          //$.material.init();

          var data = $('form').find('#search-child-name').data('children_names');

          $('#search-child-name .typeahead')
            .typeahead(
              {
                highlight: true
              },
              {
                limit: 10,
                source: function(query, process) {
                  var names = [];
                  var map = {};

                  $.each(data, function(i, child) {
                    map[child.name] = child;
                    names.push(child.name);
                  });

                  process(names);
                },
                matcher: function (target) {
                  if (target.toLowerCase().indexOf(this.query.trim().toLowerCase()) !== -1) {
                    return true;
                  }
                },
                sorter: function (children) {
                  return children.sort();
                },
                highlighter: function (target) {
                  var regex = new RegExp( '(' + this.query + ')', 'gi' );
                  return target.replace( regex, "<strong>$1</strong>" );
                },
                updater: function (target) {
                  selectedChild = map[target].id;
                  return target;
                },
                templates: {
                  suggestion: function(target) {
                    return "<div>" + target + "</div>";
                  }
                }
              })
            .bind('typeahead:select', function(ev, suggestion) {
              $('form').find('input[data-child_name="' + suggestion + '"]').prop('checked', true);
              $('form').find('input[name="child[id]"]').trigger('change');
            });
        },
        error: function() {
          console.log('error');
        }
      })
    });
  },

  childProfileFetcher: function() {
    $('body').on('change', 'input[name="child[id]"]', function() {
      var childId = $('form').find('input[name="child[id]"]:checked').val();

      $.ajax({
        url: '/illnesses/child_profile',
        data: {child_id: childId},
        type: 'GET',
        success: function(html) {
          $('form').find('.child-profile').html(html);
          //$.material.init();
        }
      });
    });
  },

  determineIllness: function() {
    $('body').on('change', 'input[name="illness[known][answer]"]', function() {
      var illnessKnown = $(this).val();

      $('form').find('.illness-detail').hide();
      $('form').find('#illness-known-' + illnessKnown).show();
    });
  },

  initSearchIllness: function() {
    var data = $('form').find('#search-illness-name').data('illness_names');

    $(document).find('#search-illness-name .typeahead')
      .typeahead(
        {
          highlight: true
        },
        {
          limit: 10,
          source: function(query, process) {
            var names = [];
            var map = {};

            $.each(data, function(i, illness) {
              map[illness.name] = illness;
              names.push(illness.name);
            });

            process(names);
          },
          matcher: function (target) {
            if (target.toLowerCase().indexOf(this.query.trim().toLowerCase()) !== -1) {
              return true;
            }
          },
          sorter: function (illnesses) {
            return illnesses.sort();
          },
          highlighter: function (target) {
            var regex = new RegExp( '(' + this.query + ')', 'gi' );
            return target.replace( regex, "<strong>$1</strong>" );
          },
          updater: function (target) {
            selectedIllness = map[target].id;
            return target;
          },
          templates: {
            suggestion: function(target) {
              return "<div>" + target + "</div>"
            }
          }
        })
      .bind('typeahead:select', function(ev, suggestion) {
        $('form').find('input[data-illness_name="' + suggestion + '"]').prop('checked', true);
        $('form').find('input[name="record[illness_code]"]').trigger('change');
      });
  },

  determineSymptoms: function() {
    $('body').on('change', 'input[name="record[illness_code]"]:checked', function() {
      var illnessCode = $(this).val();
      var illnessName = $(this).data('illness_name');
      $('input#search-illness-name').val(illnessName);

      if (illnessCode.length > 0) {
        $.ajax({
          url: '/illnesses/symptoms',
          data: {illness_code: illnessCode},
          type: 'GET',
          success: function(html) {
            $('form').find('#symptoms').html(html);
            //$.material.init();
          }
        })
      }
    });
  },

  showContactParentDetails: function() {
    $('input[name="contact[parent][answer]"]').on('change', function() {
      var contactParent = $(this).val();

      $('form').find('.contact-parent-ans').hide();
      $('form').find('#contact-parent-' + contactParent).show();
    });
  },

  showContactDoctorDetails: function() {
    $('input[name="contact[doctor][answer]"]').on('change', function() {
      var contactDoctor = $(this).val();

      $('form').find('.contact-doctor-ans').hide();
      $('form').find('#contact-doctor-' + contactDoctor).show();
    });
  },

  initSearchWorkerDepartment: function() {
    var data = $('form').find('#search-worker-department-name').data('worker_department_names');

    $(document).find('#search-worker-department-name .typeahead')
      .typeahead(
        {
          highlight: true
        },
        {
          limit: 10,
          source: function(query, process) {
            var names = [];
            var map = {};

            $.each(data, function(i, dept) {
              map[dept.name] = dept;
              names.push(dept.name);
            });

            process(names);
          },
          matcher: function (target) {
            if (target.toLowerCase().indexOf(this.query.trim().toLowerCase()) !== -1) {
              return true;
            }
          },
          sorter: function (departments) {
            return departments.sort();
          },
          highlighter: function (target) {
            var regex = new RegExp( '(' + this.query + ')', 'gi' );
            return target.replace( regex, "<strong>$1</strong>" );
          },
          updater: function (target) {
            selectedDept = map[target].id;
            return target;
          },
          templates: {
            suggestion: function(target) {
              return "<div>" + target + "</div>"
            }
          }
        })
      .bind('typeahead:select', function(ev, suggestion) {
        $('form').find('input[data-worker_department_name="' + suggestion + '"]').prop('checked', true);
        $('form').find('input[name="worker[department_id]"]').trigger('change');
      });
  },

  departmentWorkersFetcher: function() {
    $('body').on('change', 'input[name="worker[department_id]"]', function() {
      var deptId = $(this).val();

      $.ajax({
        url: '/illnesses/department_workers',
        data: {department_id: deptId},
        type: 'GET',
        success: function(html) {
          $('form').find('.worker-names').html(html);
        }
      });
    });
  },

  workerProfileFetcher: function() {
    $('body').on('change', 'select#worker_id', function() {
      var workerId = $(this).val();

      if (workerId.length > 0) {
        $.ajax({
          url: '/illnesses/worker_profile',
          data: {worker_id: workerId},
          type: 'GET',
          success: function(html) {
            $('form').find('.worker-profile').html(html);
          }
        });
      }
    });
  },

  initDepartmentIllnessForm: function() {
    $('#new-department-record').steps({
      headerTag: "label",
      bodyTag: "section",
      transitionEffect: "slideLeft",
      stepsOrientation: "vertical",
      onInit: function() {$('#new-department-record').show()},
      labels: {
        finish: $('#new-department-record_submit').val(),
        next: $('#new-department-record_next').val(),
        previous: $('#new-department-record_previous').val()
      },
      onFinished: function() {
        $('form').trigger('submit');
      }
    });
  },

  initChildDepartmentSelector: function() {
    $('select#department_id').on('change', function() {
      var deptId = $(this).val();
      var recordType = $('#record_type').val();

      if (recordType === 'child') {
        $.ajax({
          url: '/illnesses/filter_children',
          data: {department_id: deptId},
          success: function(html) {
            $('.choose-child').html(html);
          }
        });
      }
    })
  },

  showDateFilters: function() {
    $('body').on('change', 'select#child_id', function() {
      $('.date-filters').show();
    });
  },

  initChildRecordFilters: function() {
    $('#apply-health-record-filters').on('click', function() {
      var recordType = $('#record_type').val();
      var deptId = $('#department_id').val();
      var childId = $('#child_id').val();
      var startDate = $('#start_date').val();
      var endDate = $('#end_date').val();
      var valid = true;

      if (deptId.length > 0 && childId !== undefined && childId.length < 1) {
        alert(window._trans['required_child_filter']);
        valid = false;
      }

      if (valid) {
        $.ajax({
          url: '/illnesses/' + recordType + '/list',
          data: {
            department_id: deptId,
            child_id: childId,
            start_date: startDate,
            end_date: endDate
          },
        success: function(html) {
          $('.filtered-contents').html(html);
          healthChildcare.illness.initFilteredItemContentToggler();
          window.location.href = '#';
        }
        });
      }
    })
  },

  initFilteredItemContentToggler: function() {
    $('.expandable').on('click', function() {
      var targetId = $(this).data('health_record_id');
      var targetEl = $("#health-record-" + targetId);

      if ($(targetEl).html().length === 0) {
        $.ajax({
          url: '/health_records/' + targetId,
          type: 'GET',
          success: function(html) {
            $(targetEl).html(html);
          }
        });
      }

      $(targetEl).slideToggle();
    })
  },

  initHealthRecordPrinter: function() {
    $('.print-record-btn').on('click', function() {
      var data = $(this).data();
      var target = data.target_record;

      $(this).parents('.filtered-item').find('.expandable').trigger('click');

      $(target).printThis({
        pageTitle: 'Healthier Childcare Alliance',
        importCSS: false,
        importStyle: false,
        formValues: false,
        printContainer: false
      });
    });
  },

  initTrendLine: function() {
    var trendData = $('#line-chart-div').data('trend_data');

    if (trendData !== undefined) {
      google.charts.setOnLoadCallback(function(){
        var data = google.visualization.arrayToDataTable(trendData);

        var options = {
          title: $('#line-chart-div').attr('title'),
          /*curveType: 'function',*/
          legend: { position: 'right' }
        };

        var chart = new google.visualization.LineChart(document.getElementById('line-chart-div'));
        chart.draw(data, options);
      });
    }
  },

  initTrendPie: function() {
    var trendData = $('#pie-chart-div').data('trend_data');

    if (trendData) {
      // Set a callback to run when the Google Visualization API is loaded.
      google.charts.setOnLoadCallback(function(){
        // Callback that creates and populates a data table,
        // instantiates the pie chart, passes in the data and
        // draws it.

        // Create the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Illness');
        data.addColumn('number', $('#pie-chart-div').attr('children-col-title'));
        data.addRows(trendData);

        // Set chart options
        var options = {'title': $('#pie-chart-div').attr('title'),
                       'width':  $('#pie-chart-div').width(),
                       'height': $('#pie-chart-div').width() / 2,
                       'is3D':   true
                      };

        // Instantiate and draw our chart, passing in some options.
        var chart = new google.visualization.PieChart(document.getElementById('pie-chart-div'));
        chart.draw(data, options);

      });
    }
  },

  initTrendBar: function(){
    var trendData = $('#bar-chart-div').data('trend_data');

    if (trendData) {
      // Set a callback to run when the Google Visualization API is loaded.
      google.charts.setOnLoadCallback(function(){
        // Callback that creates and populates a data table,
        // instantiates the pie chart, passes in the data and draws it.

        // Create the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Illness');
        data.addColumn('number', 'Affected Children');
        data.addRows(trendData);

        // Set chart options
        var options = {'title' : 'Sickness Among The Daycare Children',
                       'width':  $('#bar-chart-div').width(),
                       'height': $('#bar-chart-div').width() / 2
                      };

        // Instantiate and draw our chart, passing in some options.
        var chart = new google.visualization.BarChart(document.getElementById('bar-chart-div'));
        chart.draw(data, options);
      });
    }
  },

  initTrendPrinter: function() {
    $('.print-trend-btn').on('click', function() {
      $('#trends').printThis({
        pageTitle: 'Healthier Childcare Alliance',
        importCSS: false,
        importStyle: false,
        formValues: false,
        printContainer: false
      });
    });
  }

}
