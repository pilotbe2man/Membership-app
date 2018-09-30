# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  file            :string
#  attachable_id   :integer
#  attachable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deactivated_at  :datetime
#

class Attachment < ActiveRecord::Base
    #include CopyCarrierwaveFile  
    belongs_to :attachable,           polymorphic: true

    #mount_uploader :file,             FileUploader
    #validates :file,                  format: { with: /\.(jpeg|gif|jpg|png)\z/i, message: "must be a URL for GIF, JPG, JPEG or PNG image." }


    has_attached_file :file, 	styles: { medium: "300x300>", thumb: "100x100>" }, path: "attachable/:id_partition/:filename"
    validates_attachment_content_type :file, content_type: /\Aimage\/.*\z/

    def duplicate_file original
#        copy_carrierwave_file(original, self, :file)
#        self.save!
    end
end
