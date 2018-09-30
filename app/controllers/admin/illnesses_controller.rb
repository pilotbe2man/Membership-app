class Admin::IllnessesController < AdminController

  before_filter :set_illness, only: [:edit, :update, :destroy]

  def index
    @illnesses = Illness.all.order(:name)
    @illnesses = @illnesses.name_like(params[:name]) unless params[:name].nil?
    @illnesses = @illnesses.code_like(params[:code]) unless params[:code].nil?
    @illnesses = @illnesses.by_language(params[:language]) unless params[:language].nil? || params[:language].blank?    
  end

  def new
    @illness = Illness.new
    @illness.symptoms.build
  end

  def create
    @illness = Illness.new(illness_params)

    respond_to do |format|
      if @illness.save
        format.html { redirect_to admin_illnesses_path, notice: 'Illness was successfully created.' }
        format.json { render :show, status: :created, location: @illness }
      else
        format.html { render :new }
        format.json { render json: @illness.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @illness.update(illness_params)
        format.html { redirect_to admin_illnesses_path, notice: 'Illness was successfully updated.' }
        format.json { render :show, status: :ok, location: @illness }
      else
        format.html { render :edit }
        format.json { render json: @illness.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @illness.destroy

    respond_to do |format|
      format.html { redirect_to admin_illnesses_path, notice: 'Illness was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload
    if request.post?
      build_illness_from_spreadsheet
      redirect_to admin_illnesses_path(), notice: 'You have successfully uploaded a illness module'
    end
  end

  private

  def set_illness
    @illness = Illness.find(params[:id])
  end

  def illness_params
    params.require(:illness).permit(
      :name,
      :code,
      :worker_guide,
      :parent_guide,
      :language,
      symptoms_attributes: [:_destroy, :id, :name, :code, :illness_id]
    )
  end

  def build_illness_from_spreadsheet
    file_data = params[:spreadsheet_file]

    if file_data
      xlsx = Roo::Spreadsheet.open(file_data.path, extension: :xlsx)
      if xlsx.sheets.count > 0
        if xlsx.last_row > 1
          index = Time.now.to_i          
          2.upto(xlsx.last_row) do |line|
            index += 1
            unless xlsx.cell(line, 'A').nil?
              @illness = Illness.new(:code => "IL-#{index}", :name => xlsx.cell(line, 'A'))
              @illness.save(validate: true)
            end
            symptom = @illness.symptoms.new(:code => "SY-#{index}", :name => xlsx.cell(line, 'B')) unless xlsx.cell(line, 'B').nil?
            symptom.save(validate: true)
          end        
        end
      end
    end
  end
end
