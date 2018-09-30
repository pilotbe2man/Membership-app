class IllnessGuide < ActiveRecord::Base

  enum target_role: [:parentee, :worker]
end
