require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
p "Creating daycares and departments..."
2.times do
    daycare = Daycare.new(name: Faker::Company.name, address_line1: Faker::Address.street_address, postcode: Faker::Address.zip_code, country: Faker::Address.country, telephone: Faker::PhoneNumber.phone_number)
    2.times do
        daycare.departments.build(name: "Department-#{Faker::Lorem.word}")
    end
    daycare.save!
end

p "Create users..."
admin = User.create(name: 'Admin User', email: "admin@daycare.org", role: 3, password: "mypassword", password_confirmation: "mypassword", email_confirmed: true)
manager = User.new(name: 'Manager User', email: "manager@daycare.org", role: 2, password: "mypassword", password_confirmation: "mypassword", email_confirmed: true)
manager.build_user_daycare(daycare_id: Daycare.first.id)
manager.save!
manager2 = User.new(name: 'Manager 2 User', email: "manager2@daycare.org", role: 2, password: "mypassword", password_confirmation: "mypassword", email_confirmed: true)
manager2.build_user_daycare(daycare_id: Daycare.second.id)
manager2.save!
worker = User.new(name: 'Worker User', email: "worker@daycare.org", role: 1, password: "mypassword", password_confirmation: "mypassword", department_id: Department.all.map(&:id).sample, email_confirmed: true)
worker.build_user_daycare(daycare_id: Daycare.first.id)
worker.save!
parent = User.new(name: 'Parent User', email: "parent@daycare.org", role: 0, password: "mypassword", password_confirmation: "mypassword", email_confirmed: true)
parent.build_user_daycare(daycare_id: Daycare.first.id)
child = parent.children.build(name: Faker::Name.name, department_id: Department.all.map(&:id).sample, birth_date: Faker::Date.between(10.years.ago, 3.years.ago))
child.build_profile_image(file: File.open(File.join(Rails.root, '/lib/dummy_assets/child-sample.jpg')))
parent.save!

p "Creating example todos..."
#8.times do
#    todo = Todo.new(title: "Todo-#{Faker::Lorem.word}", iteration_type: rand(0..1), frequency: rand(0..3), user_id: admin.id)
#    todo.create_icon(file: File.open(File.join(Rails.root, '/lib/dummy_assets/ruby-icon.png')))
#    todo.save!
#    3.times do
#        todo.tasks.create(title: "Task-#{Faker::Lorem.word}", description: Faker::Lorem.sentence)
#    end
#end

# p "Creating example todo completes..."
# Todo.all.each do |todo|
#     15.times do
#         todo_complete = todo.todo_completes.build(submitter_id: worker.id)
#         todo_complete.save(validate: false)
#         todo_complete.task_completes.each do |task|
#             task.update_column(:result, rand(0..2))
#             task.update_column(:completion_date, Faker::Date.between(3.month.ago, Date.today)) if task.pass?
#         end
#     end
# end
# TodoComplete.all.each do |todo_complete|
#     todo_complete.update_column(:created_at, Faker::Date.between(3.month.ago, Date.today))
# end

p "Assigning todos to departments..."
#Todo.first(4).zip(Department.all).each do |todo, dp|
#    todo.department_todos.create(department_id: dp.id)
#end
#Todo.last(4).zip(Department.all).each do |todo, dp|
#    todo.department_todos.create(department_id: dp.id)
#end



p "Creating plans..."
Plan.create(name: 'Per Children Per Day', price: 5, allocation: 30, plan_type: 1, language: 'EN', currency: 'usd')
Plan.create(name: 'Deposit Amount', price: 100, allocation: 30, plan_type: 0, language: 'EN', currency: 'usd')
#Stripe::Plans.put!

p "Creating discount codes..."
#DiscountCode.create(code: 'FIRST100', value: 50)
#DiscountCode.create(code: 'REDUCE15', value: 15)
#DiscountCode.create(code: 'REDUCE25', value: 25)
#DiscountCode.create(code: 'REDUCE50', value: 50)
#Stripe::Coupons.put!

subjects = ['Food Handling', 'Outbreak Control Strategies', 'Exclusion Of Sick Children', 'Preventive Diapering', 'Cleaning Bodily Fluids', 'Preventive Hand Washing']

p "Creating subjects..."
#subjects.each do |sub|
#  subject = Subject.create(title: sub)
#end

p "Creating Message Subject"
#msg_subject = MessageSubject.create(title: 'Illness')

p "Creating Message Sub-subject"
#msg_sub_subject = msg_subject.sub_subjects.create(title: 'Flu')

p "Creating Message Template"
#msg_template = MessageTemplate.create(sub_subject_id: msg_sub_subject.id, target_role: 'worker', content: "The common cold, including chest cold and head cold, and seasonal flu are caused by viruses. Use over-the-counter cold medications to relieve symptoms including sore throat, runny nose, congestion, and cough. Flu symptoms are similar, but include fever, headache and muscle soreness. See a doctor who may prescribe antiviral medications Relenza or Tamiflu.")

p "Creating Message"
#msg = Message.create(message_template_id: msg_template.id, owner_id: manager.id, title: msg_sub_subject.title, content: msg_template.content, target_role: ['worker'].to_json)

p "Creating Notification"
#notif = msg.notifications.create(target_id: worker.id)

p "Creating Locale URL"
local_url = LocaleUrl.create(url: "www.healthierandsaferchildcare.org", language: "en")

p "Creating Locale Logo"
local_url = LocaleLogo.create(language: "EN", 
							  logo_type: 1,
							  description: "Default",
							  address1: "Stasjonsveien 23B",
							  address2: "2010 STROMMEN Norway",
							  email: "infectionpreventivecare@healthierandsaferchildcare.org",
							  phone_number: "+47 467 47 016",
							  title: "Healthier and Safer Childcare Alliance",
							  copyright: "© 2016",
							  upgrade_notifier: "Daycare has Reserved their spot on the accreditation program by making a deposit of $50.",
							  app_title: "Healthierandsaferchildcare")

p "Creating Payment Mode"
PaymentMode.create(period: 2, unit: 'week')
PaymentMode.create(period: 1, unit: 'month')
PaymentMode.create(period: 3, unit: 'month')
PaymentMode.create(period: 1, unit: 'year')

p "Creating Payment Start"
PaymentStart.create(period: 7, unit: 'day')
PaymentStart.create(period: 14, unit: 'day')

p "Creating Global Setting"
GlobalSetting.create(key: "Journey Page Mode", value: 'deposit_mode')
GlobalSetting.create(key: "ACUITY_SCHEDULE_URL", value: 'https://acuityscheduling.com/api/v1/')
GlobalSetting.create(key: "ACUITY_SCHEDULE_USER", value: '13092943')
GlobalSetting.create(key: "ACUITY_SCHEDULE_PASSWORD", value: 'b1a2264ff0dd67fb06c5fe2788c5802b')
GlobalSetting.create(key: "ACUITY_SCHEDULE_NUM_OF_CHILD_ID", value: '2412391')
GlobalSetting.create(key: "ACUITY_SCHEDULE_NUM_OF_WORKER_ID", value: '2412394')
GlobalSetting.create(key: "ACUITY_SCHEDULE_CARD_TYPE_ID", value: '2421634')
GlobalSetting.create(key: "INITIAL_MEMBER_LIMIT_DAY", value: '14')

