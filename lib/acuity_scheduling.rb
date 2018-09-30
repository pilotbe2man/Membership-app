require 'json'
require 'httparty'

class AcuityScheduling
  @base_url = ""
  @auth = {}

  def initialize(u, p, url)
    @auth = {:username => u, :password => p}
    @base_url = url
  end

  def get_appointment_types(options = {})
    called_url = @base_url + "appointment-types"
    options.merge!({ basic_auth: @auth })
    response = HTTParty.get(called_url, options)
    return JSON.parse(response.body)
  end

  def get_available_schedule_time(params, options = {})
    called_url = @base_url + "availability/times?appointmentTypeID="+params[:appointment] + "&date=" + params[:date] + "&timezone=" + params[:timezone]    
    options.merge!({ basic_auth: @auth })
    response = HTTParty.get(called_url, options)
    return JSON.parse(response.body)    
  end

  def put_appointment(options = {})
    called_url = @base_url + "appointments"
    response = HTTParty.post(called_url, :body => options.to_json, basic_auth: @auth, :headers => { 'Content-Type' => 'application/json' })
    return JSON.parse(response.body)    
  end
end