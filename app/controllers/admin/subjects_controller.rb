class Admin::SubjectsController < AdminController

  # GET /subjects
  def index
    @subjects = Subject.active
  end

  # GET /subjects/1
  def show
    set_subject
  end

  # GET /subjects/new
  def new
    @subject = Subject.new
  end

  # GET /subjects/1/edit
  def edit
    set_subject
  end

  # POST /subjects
  def create
    @subject = Subject.new(subject_params)

    if @subject.save
      redirect_to admin_subjects_url, notice: 'Subject was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /subjects/1
  def update
    set_subject
    if @subject.update(subject_params)
      redirect_to admin_subjects_url, notice: 'Subject was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /subjects/1
  def destroy
    set_subject
    @subject.deactivate!
    redirect_to admin_subjects_url, notice: 'Subject was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def subject_params
      params.require(:subject).permit(:title)
    end
end
