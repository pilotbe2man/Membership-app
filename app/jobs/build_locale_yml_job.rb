class BuildLocaleYmlJob < ActiveJob::Base
  include ActiveJobStatus::Hooks
  queue_as :default

  def perform(content, language, job_id)
    puts "------------BuildLocaleYmlJob---------Start"
    job_status = BackJobStatus.find(job_id)

    doc = YAML.load(content)

    Translation.where(:locale => language.downcase).destroy_all

    doc.to_enum(:walk).each do |path, key, value|
      strvalue = value.is_a?(String) ? value : value.inspect
      trans_item = Translation.new
      trans_item.locale = language.downcase
      path_str = path.join(".")
      path_dot_index = path_str.index('.') + 1
      trans_item.key = "#{path_str[path_dot_index..-1]}.#{key}"
      trans_item.value = value
      trans_item.save
    end
    puts "------------BuildLocaleYmlJob---------Done"
    job_status.job_status = true unless job_status.nil?
    job_status.save
  rescue => e
    job_status.job_status = false unless job_status.nil?
    job_status.description = e.message unless job_status.nil?
    job_status.save
    puts "------------BuildLocaleYmlJob---------Error"
    puts e
  end
end
