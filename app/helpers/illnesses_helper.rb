module IllnessesHelper

  def user_departments
    current_user.daycare.departments.inject([]){|list, dept| list << {id: dept.id, name: dept.name }; list }
  end

  def illness_list
    Illness.all.where(language: I18n.locale).sort_by(&:name).collect{|illness| {code: illness.code, name: illness.name}}
  end

end
