class SurveyTrendsGenerator
include ActionView::Helpers::NumberHelper

=begin
 params :
    subject : SurveySubject
    population: user ids of the participants to generate data out of
=end
  def initialize(subject, user_population, start_date = '', end_date = '')
    @subject = subject
    @user_population = user_population
    @start_date = start_date
    @end_date = end_date
  end
  # check for results availability

  def individual_survey_result_over_time
    survey_attempt_dates

#    date_labels(survey_attempt_dates).each do |date|
#      trend_data << generate_trend_row(date, trend_data[0], survey_attempt_dates)
#    end    
  end
=begin
  output :
  => [[0] [[0] "Date", [1] "Infection Preventive Outbreak Control"],
      [1] [[0] "Jul 2016", [1] 96],
      [2] [[0] "Aug 2016",[1] 86]
=end
  def group_survey_result_over_time
    trend_data = [['Date', @subject.title]]

    date_labels(subject_attempt_dates).each do |date|
      trend_data << generate_trend_row(date, trend_data[0], subject_attempt_dates)
    end

    trend_data
  end

  def group_survey_result_right_over_wrong
    trend_data = []
    correct_percentages = []

    group_survey_result_over_time.each_with_index do |data, index|
      next if index == 0 # header
      correct_percentages << data.last
    end

    if correct_percentages.present?
       average_correct = correct_percentages.sum / correct_percentages.size
      trend_data << ['Correct Answers', average_correct]
      trend_data << ['Wrong Answers', 100 - average_correct]
    end

    trend_data
  end

  def has_available_individual_results?
    survey_attempt_dates.present?
  end

  def has_available_group_results?
    subject_attempt_dates.present?
  end

  private

  def survey_attempts_population
    @survey_attempts_involved ||= SurveyAttempts.where(survey_id: subject.survey_ids, participant_id: @user_population)
  end

  def header_columns
    @header_columns ||= ['Date'] + survey_attempt_dates.keys
  end

=begin
  output :
  {
    "Exclusion of Sick Children" => {
      2016-06-01 00:00:00 UTC => 1,
      2016-07-01 00:00:00 UTC => 3
    },
    "Infection Preventive Outbreak Control" => {
      2016-06-01 00:00:00 UTC => 3,
      2016-07-01 00:00:00 UTC => 7
    }
  }
=end
  def survey_attempt_dates
    @survey_attempt_dates ||= (
      @subject.surveys.inject({}) do |list, survey|
        attempts = attempts_per_survey([survey.id])

        if attempts.present?
          # get rate percentage for every attempt groupings
          # formula : average of correct rates / average # of questions * 100
          #attempts.each_pair{|date, rate| attempts[date] = (rate / survey.questions.size * 100).to_i}
          list[survey.name] = number_with_precision(attempts, precision: 0)
        end
        list
      end
    )
  end

  def subject_attempt_dates
    @subject_attempt_dates ||= (
      rates_per_date = Hash.new{|h, k| h[k] = []}

      survey_attempt_dates.values.each do |date_hash|
        date_hash.each_pair do |date, rate_percentage|
          rates_per_date[date] << rate_percentage
        end
      end

      # get the average rate per date
      rates_per_date.each_pair{|date, rate| rates_per_date[date] = rate.sum / rate.size}
      if scores_per_date.present?
        {@subject.title => scores_per_date}
      else
        {}
      end
    )
  end

  def attempts_per_survey(survey_id)
    start_date = @start_date.blank? ? Date.new(1970, 1, 1) : Date.parse(@start_date)
    end_date = @end_date.blank? ? Date.tomorrow : Date.parse(@end_date)

    SurveyAttempts.where(survey_id: survey_id, participant_id: @user_population, :created_at => start_date..end_date).average('rate')
  end

  def date_labels(attempt_dates)
    attempt_dates.values.map(&:keys).flatten.uniq.sort
  end

  def generate_trend_row(date, headers, attempt_dates)
    row = Array.new(headers.size, 0)
    row[0] = date.strftime('%b %Y')

    headers.each_with_index do |survey, index|
      next if index == 0

      row[index] = attempt_dates[survey][date] || 0
    end

    row
  end
end
