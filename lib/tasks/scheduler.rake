task :todo_frequencies => :environment do
	puts "Running TodoFrequenciesJob"
	TodoFrequenciesJob.perform_later
end

task :todo_completion_date => :environment do
	puts "Running TodoCompletionDateJob"
	TodoCompletionDateJob.perform_later
end

task :auto_payment => :environment do
	puts "Running AutoPaymentJob"
	AutoPaymentJob.perform_later
end
