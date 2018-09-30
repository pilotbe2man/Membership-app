class Admin::MessageSubjectsController < AdminController

	def destroy
    	@subject ||= MessageSubject.find(params[:id])
    	@subject.destroy
    	redirect_to admin_list_message_path
  	end
end
