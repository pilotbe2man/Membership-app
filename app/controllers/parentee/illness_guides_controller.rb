class Parentee::IllnessGuidesController < ApplicationController
  layout 'dashboard_v2'
  before_action -> { authenticate_role!(['parentee'])}

  def index

  end

  def illness
    # set_illnesses
    @illnesses = IllnessGuideUpdate.all
  end

  def content
    find_illness_guide
  end

  private

  def set_illnesses
    @illnesses ||= Illness.all
  end

  def set_illness
    # @illness = Illness.find params[:illness_id] if (params[:illness_id].present?)
    if params[:illness_id].present?
      local_illness = IllnessGuideUpdate.find_by_id(params[:illness_id])
      if local_illness.present?
        @title = local_illness.title
        @title_desc = local_illness.description
      end   
    end  
  end

  def find_illness_guide
    set_illness

    @illness_guide = ''
    if @illness && params['target_role'].present?
      if params['target_role'] == 'worker'
        @illness_guide = @illness.worker_guide.url unless @illness.worker_guide.blank?
      else
        @illness_guide = @illness.parent_guide.url unless @illness.parent_guide.blank?
      end
    end
  end
end
