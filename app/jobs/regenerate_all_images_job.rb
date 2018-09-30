class RegenerateAllImagesJob < ActiveJob::Base
    queue_as :default

    def perform *args
        p "Regenerating child profile images"
        Child.all.each do |child|
            next unless child.profile_image.file.nil?
            child.profile_image.file.recreate_versions!(:thumb, :square, :standard)
            child.profile_image.save!
        end

        p "Regenerating survey subject icon images"
        SurveySubject.all.each do |survey|
            next unless survey.icon.file.nil?
            survey.icon.file.recreate_versions!(:thumb, :square, :standard)
            survey.icon.save!
        end

        p "Regenerating icon icon images"
        Todo.all.each do |todo|
            next unless todo.icon.file.nil?
            todo.icon.file.recreate_versions!(:thumb, :square, :standard)
            todo.icon.save!
        end
    end
end
