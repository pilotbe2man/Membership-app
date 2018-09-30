ready = function()
{
    healthChildcare.admin.multiSelect();
    healthChildcare.admin.datepickers();

    soca.animation.loading();
    soca.animation.colourCaveat();
    soca.filter.tableRowTarget();
    soca.misc.multiSelect();
    soca.misc.updateTableHeight();
    soca.mobile.disableTooltips();
    soca.mobile.triggerMenu();

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
    
};
$(document).ready(ready);
$(document).on('page:change page:load', function()
{
    $('[data-toggle=tooltip]').tooltip('hide');
    $('.main .container').removeClass('fadeOut').addClass('animated fadeIn');
});
$(document).on('page:fetch', function()
{
    $('.main .container').addClass('animated fadeOut');
    return $('.loading5').addClass('active');
});

$(document).on("page:receive", function(){
    $('.loading-overlay').removeClass('active');
    return $('.loading5').removeClass('active');
});

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");

  if ($(link).hasClass('subtask-link')) {
    $(link).parent('.subtask').remove();
  } else {
    $(link).closest(".field").remove();
  }
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");

    if ($(link).hasClass('subtask-link')) {
      $(link).parent().find('.form-group').last().after(content.replace(regexp, new_id));
    } else {
      $(link).parent().next().find('.widget .fields').append(content.replace(regexp, new_id));
    }

}
function removeField(link) {
    $(link).prev("input[type=hidden]").val("true");
    tag = $(link).closest(".field")
    tag.hide("fade in").addClass("deleted");
}

function addField(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    var html = $(content.replace(regexp, new_id)).hide();
    html.appendTo($(link).parent().next().find('.widget .fields')).slideDown("slow");
}
function addOptionField(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    var html = $(content.replace(regexp, new_id)).hide();
    html.appendTo($(link).closest("div.field").find("ol").first()).slideDown("slow");
}
