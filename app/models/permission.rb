class Permission < ActiveRecord::Base
    enum member_type: [:manager, :worker, :parentee, :partner]
    # enum sub_type: [:partner_daycare, :partner_certificate, :manager_chain, :manager_independent, :manager_govermantal]
    enum feature: [:survey, :online_training, :message, :todo, :illness_analysics, :illness_record, :illness_guide, :emergency, :'todo-b']

    def sub_type_label
        case self.sub_type
        when 1
            "Certification Partnership"
        when 0
            "Healthier and Safer Childcare Partnership"
        when 2
            "Chain Daycare"
        when 3
            "Independant Daycare"
        when 4
            "Govermantal Daycare"
        end
    end

    def feature_label
        case self.feature
        when 'survey'
            "Survey"
        when 'online_training'
            "Online Training"
        when 'message'
            "Message"
        when 'todo'
            "Todo"
        when 'illness_analysics'
            "Illness Analysics"
        when 'illness_record'
            "Illness Record"
        when 'illness_guide'
            "Illness Guide"
        end
    end
end
