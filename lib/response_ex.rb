require 'json'
require 'httparty'
class ResponseEx
  include SurveyGizmo::Resource

  # Filters
  NO_TEST_DATA =   { field: 'istestdata', operator: '<>', value: 1 }
  ONLY_COMPLETED = { field: 'status',     operator: '=',  value: 'Complete' }

  def self.submitted_since_filter(time)
    {
      field: 'datesubmitted',
      operator: '>=',
      value: time.in_time_zone(SurveyGizmo.configuration.api_time_zone).strftime('%Y-%m-%d %H:%M:%S')
    }
  end

  attribute :id,                   Integer
  attribute :survey_id,            Integer
  attribute :contact_id,           Integer
  attribute :data,                 String
  attribute :status,               String
  attribute :is_test_data,         Boolean
  attribute :sResponseComment,     String
  attribute :variable,             Hash       # READ-ONLY
  attribute :meta,                 Hash       # READ-ONLY
  attribute :shown,                Hash       # READ-ONLY
  attribute :url,                  Hash       # READ-ONLY
  attribute :answers,              Hash       # READ-ONLY
  attribute :datesubmitted,        DateTime
  alias_attribute :submitted_at, :datesubmitted

  @route = '/survey/:survey_id/surveyresponse'

  def survey
    @survey ||= Survey.first(id: survey_id)
  end

  def parsed_answers
    filtered_answers = answers.select do |k, v|
      next false unless v.is_a?(FalseClass) || v.present?

      # Strip out "Other" answers that don't actually have the "other" text (they come back as two responses - one
      # for the "Other" option_id, and then a whole separate response for the text given as an "Other" response.
      if /\[question\((?<question_id>\d+)\),\s*option\((?<option_id>\d+)\)\]/ =~ k
        !answers.keys.any? { |key| key =~ /\[question\((#{question_id})\),\s*option\("(#{option_id})-other"\)\]/ }
      elsif /\[question\((?<question_id>\d+)\)\]/ =~ k
        !answers.keys.any? { |key| key =~ /\[question\((#{question_id})\),\s*option\("\d+-other"\)\]/ }
      else
        true
      end
    end

    filtered_answers.map do |k, v|
      Answer.new(children_params.merge(key: k, value: v, answer_text: v, submitted_at: submitted_at))
    end
  end

  def save
    method, path = id ? [:post, :update] : [:put, :create]
    attributes_without_blanks
    self.attributes = send_req(method, create_route(path), attributes_without_blanks)['data']
    self
    #self.attributes = SurveyGizmo::Connection.send(method, create_route(path), attributes_without_blanks).body['data']
    #self
  end

  def send_req(method, path, input)
    api_path = "https://restapi.surveygizmo.com/#{path.first(path.length-2)}&_method=PUT&api_token=#{ENV['SURVEYGIZMO_API_TOKEN']}&api_token_secret=#{ENV['SURVEYGIZMO_API_TOKEN_SECRET']}#{input}"

    case method
    when :post
      response = HTTParty.post(api_path,:body=>nil, :default_timeout=> nil, :headers => {"content-type"=>"application/json"})
    when :put
      response = HTTParty.put(api_path,:body=>nil, :default_timeout=> nil, :headers => {"content-type"=>"application/json"})
    end
    JSON.parse(response.body)
  end

  def attributes_without_blanks
    result_hash = attributes.reject { |k, v| v.blank? || k == :data }    
    data.each do |k, v|
      result_hash["data#{k}"] = v
    end
    api_path = ""
    result_hash.each do |k, v|
      api_path = api_path + "&#{k}=#{URI.encode(v.to_s)}"      
    end
    return api_path
  end  

end
