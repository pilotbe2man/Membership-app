module SurveysHelper
  def link_to_remove_field(name, f)
    f.hidden_field(:_destroy) +
    __link_to_function(raw(name), "removeField(this)", 'red', :id =>"remove-attach")
  end

  def new_survey
    new_manager_survey_path
  end

  def edit_survey(resource)
    edit_manager_survey_path(resource)
  end

  def survey_scope(resource)
    if action_name =~ /new|create/
      manager_subject_surveys_path(resource)
    elsif action_name =~ /edit|update/
      manager_subject_survey_path(resource)
    end
  end

  def new_attempt
    new_survey_attempt_path
  end

  def attempt_scope(resource)
    if action_name =~ /new|create/
     survey_attempts_path(resource)
    elsif action_name =~ /edit|update/
      attempt_path(resource)
    end
  end

  def link_to_add_field(name, f, association, javascript_function)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object,:child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    __link_to_function(name, "#{javascript_function}(this, \"#{association}\", \"#{escape_javascript(fields)}\")", 'green', id: "add-attach")
  end

  private

  def __link_to_function name, on_click_event, button_color, opts={}
    link_to(name, 'javascript:void(0);', opts.merge(onclick: on_click_event, class: "btn btn-#{button_color} btn-normal"))
  end

  def choose_daycare_header
    "#{t('survey.breadcrumb.survey_options')} > " +
      "#{t('survey.breadcrumb.choose_daycare')}"    
  end
end
