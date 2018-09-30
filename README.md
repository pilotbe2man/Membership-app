# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

*   Ruby version

*   System dependencies

*   Configuration

*   Database creation

*   Database initialization

*   How to run the test suite

*   Services (job queues, cache servers, search engines, etc.)

*   Deployment instructions

*   ...

# Getting started

Install rvm :

`rvm install ruby-2.2.2`

Install Redis :

`brew install redis`

Install PostgreSQL :

`brew install postgres`

Install gems:

`bundle install`

Install asset dependencies:

`bower install`

Seed the database

`bundle exec rake db:setup`

Start the web server and Sidekiq:

`foreman start -f Procfile.dev`


# Seed data

## Login details

Admin/Super Admin: admin@daycare.org / mypassword
Manager: manager@daycare.org / mypassword
Worker: worker@daycare.org / mypassword
Parent: parent@daycare.org / mypassword


# Stripe

When testing card authorisation and payments, please use the details in the following link:

https://stripe.com/docs/testing#cards

# Synopsis

## Affiliate

The Affiliate model is used to represent the company that the Daycare Partner is connected to. It belongs to a User record with a 'partner' role. When a partner registers, he/she is required to fill in data for the User record as well as for the related Affiliate record.

## Attachment

The Attachment model is a polymoprhic model which can be utilised by any other model to enable file attachments via the Carrierwave gem.

## Child

The Child model belongs to a User record with the 'parentee' role. A parentee User can create a Child record when the register for an account.

## ChildCollaborator

The ChildCollaborator is a polymorphic model which is used to represent the different users which collaborates around a particular child. It is used in the Health Conversations, and only those users which has the child_collaborator connected to a child can see the conversations, and/or receive notifications around the child.

## CollaboratorInvite

The CollaboratorInvite is a model used to represent the invitations to collaborate around a child. In the Health Conversations, the parents of the child can send an invitation to other users to collaborate around the child. When they do this, a collaborator_invite record is created, containing invite code and the email of the user being invited.

## Daycare

The Daycare model is created when a User record with the 'manger' role is registered on the system. A Daycare record can have multiple Users, Departments and local Todos.

## Department

The Department model belongs to a Daycare record. Department records are created when a User with a 'manager' role is registerd on the system; they need to be unique within the scope of the parent Daycare record.

## DepartmentTodo

The DepartmentTodo is a HABTM relationship handler between the Department and Todo models. A Department can have mutiple Todos, and a Todo can belong to multiple Departments.

## DiscountCode

The DiscountCode model is designed to define available DiscountCodes based around on percentage for the subscription part of the system. When creating a new DiscountCode, it should automtically create and/or update the linked Stripe account with the required information. Stripe needs to hold the DiscountCode information in order to apply the discount to the User's subscription every month. If you cannot find the DiscountCode information in your stripe dashboard, run the following command:

`rake stripe:prepare`

## DiscountCodeUser

The DiscountCodeUser is a HABTM relationship handler between the DiscountCode and User models. A DiscountCode can have mutiple Users, whereas a User can only have one DiscountCode.

## Discussion

The Discussion model is used to represent the messages being exchanged in the Health Conversations.

## DiscussionParticipant

The DiscussionParticipant model is used to represent the target users of the connected discussion. In the Health Conversation, when a discussion is created, the sender can select the collaborators that's going to receive notifications. This receiver list is saved in the Discussion's Discussion Participant record.

## DoctorSpecialization

A DoctorSpecialization is record used to save the doctor's medical specialization. It is created when an invited doctor registers in the app.

## HealthRecord

The HealthRecord model is used to save the health records related to a child or a department. It is based on a particular protocol and has many related health-record component records.

### Protocol

A protocol is a predefined set of data that is related to a child or a department. The currently available protocols are defined in the config/initializers/protocols.rb. One Health Record record is based on a protocol, and the associated Health Record components are based on the protocol's list of data_codes.

## Illness

An Illness record represents the different illnesses that a child or a department can have. It is a currently a built-in data, found in config/initializers/illnesses.yml and can be loaded by running

`rake setup:load_illnesses`

Future support to add/edit/delete illnesses can be added in the Admin panel.

## MedicalSpecialization

The DoctorSpecialization model is a builtin data used to populate the different specializationa doctor can have. The list is in config/initializers/medical_specializations.rb and can be loaded by running

`rake setup:load_medical_specializations`

## Message

The Message model is designed to define the message content sent between users of the app. It can be user created, or based on a Message Template. It can have multiple target roles. When a message is created, a corresponding notification is created for all the recipients of the message.

### User Stories

As an Admin, I can
- create regular messages

As a Manager, I can
- create messages based on the message templates

As a Partner, I can
- create regular messages

## MessageSubject

The MessageSubject model is designed to define a predefined set of subjects for Messages. It is a main subject when the parent_subject_id is null, or sub-subject when it has a parent_subject_id.

## MessageTemplate

The MessageTemplate model is designed to define a predefined message that the users can send to the other users of the app. It belongs to a main subject and sub-subject. It also has one target role.

### User Story

As an Admin, I can
- create message templates
- edit message templates
- delete message templates

As a Manager, I can
- can use the message templates created by the Admin to be sent to the parents and workers under my daycare

## Notification
The Notification model is designed to define any form of notifications out of any actions. It has a polymorphic field, which can be used to record the source of the notification. Possible source of notification are Message, Discussion, to name a few.

## Plan

The Plan model is designed to define available Plans for when a User would like to upgrade their subscription in the system. When creating a new Plan, it should automtically create and/or update the linked Stripe account with the required information. Stripe needs to hold the Plan information in order to charge the User with the correct amount for each month of their subscription. If you cannot find the Plan information in your stripe dashboard, run the following command:

`rake stripe:prepare`

## Subject

The Subject model is designed to define a predefined set of subjects for when a User with the 'manager' role creates a new Todo for their associated Daycare. Instead of a User with a 'manager' role submitting custom text for the Title of the Todo, they need to select from a list of predefined Subjects which have been created by a User with an 'admin' role. This has been designed in order support legacy functionality and is advisable to restructure later on.

## SubTask

A SubTask record is sub-task associated with a TodoTask record. A TodoTask record can have many SubTask records, each of which contain a Title and Description attribute.

## SubTaskComplete

Behaves similar to TodoTaskComplete for TodoTask, but for SubTask.

## SurveySubject

The SurveySubject model is designed to define the master subject for a Survey. Since there are mutliple modules (Survey model) in a Survey, it made sense to create a parent record which defined the survey Title, Description and Icon. After creating a SurveySubject record, a User can then create modules containing questions and answers with the Survey model. In order to create SurveySubject or Survey records, a User needs to have an 'admin' role.

## Symptom

A Symptom record represents the symptoms that the different illnesses can have. It belongs to a particular illness, and has unique code and name fields.

## Todo

The Todo logic is broken up into two types: Local and Global. Global Todos are created by an admin, and only an admin can create, edit and destroy. Managers can view global todos, but cannot modify their data. However, a Manager can create local todos, which are only assigned to their associated Daycare. Additionally, a Manager can generate reports based in start and end time/date for both global todo attempts and local todo attempts by their associated parents and managers.

As a Parent or Worker, you can view the global todos created by an admin and local todos created by your manager within your associated Daycare. Furthermore, Parents and Workers can start a Todo and mark its associated tasks as complete.

### User stories

As an admin I can...
- view all global todos
- create global todos

As a manager I can...
- view all global todos
- generate report on global and local todos
- iew all local todos in relation to my daycare
- create local todos which are assigned to my daycare

As a worker or parent I can...
- view available todos...
- view incomplete todos...
- mark a tasks on a todo as complete
- complete all tasks on a todo, thereby completing the todo

## TodoComplete

A TodoComplete record is a User's attempt at trying to complete a Todo which is associated with their Daycare. A TodoComplete record has many TodoTaskComplete records - one for each of the TodoTask records associated with a Todo record. When all TodoTaskComplete records are marked as either 'pass' or 'failed' the completion_date attribute is assigned and the status attribute is set to 'inactive'. Only a User record with a 'parentee' or 'worker' role may attempt at completing a Todo.

## TodoTask

A TodoTask record is task associated with a Todo record. A Todo record can have many TodoTask records, each of which contain a Title and Description attribute.

## TodoTaskComplete

A TodoTaskComplete record is a User's attempt at trying to complete TodoTask associated with a Todo record. When a TodoTaskComplete record is created, the result attribute is automatically set to 'pending'. If a User marks a TodoTaskComplete as 'completed', the result attribute is updated to 'pass'. Whereas if a User fails to complete a TodoTaskComplete within the completion date or frequency, the result attrbiute is marked as 'failed'. Only a User record with a 'parentee' or 'worker' role may attempt at completing a TodoTask.

## User

A User record is designed to allow people to create their own account, each of which is assigned either a 'parentee', 'worker', 'manager' and 'admin' role. Each of the aforementioned roles allow the User to perform different types of functionality inside the system. A User record is required in order to utilise alot of the dynamic functionality inside the system.

## UserAffiliate

A UserAffilate record is handler between the Users and the Affilicate models. Only users with 'partner' role can have have UserAffiliate records. An Affiliate can have multiple Users, whereas a User with a 'partner' role can only have one Affiliate.

## UserDaycare

The UserDaycare is a HABTM relationship handler between the Users and Daycares models. A Daycare can have mutiple Users, whereas a User can only have one Daycare.

## UserOccurrence

The UserOccurrence model is designed to prevent Users from repeating a Todo with a 'recurring' iteration type within the defined frequency defined for the aforementioned Todo. For example, if a Todo has a 'recurring' iteration type and a 'weekly' frequency, they cannot perform the Todo more than once a week.

## UserProfile

The UserProfile model is used to save additional information about the users. Currently, it is created when an invited doctor registers in the app.

## Vote

The Vote model is used to save any votes made by the user. As of writing, only Daycare Parents and Daycare Workers are allowed to vote. They can only vote once per VoteCandidate Record.

## VoteCandidate

The VoteCandidate model represents the possible votes that the user can do. As of writing, users can only vote on the survey about the app itself.

# Troubleshooting

When stripe or rollbar causes error in the initial migration, temporarily comment out the codes in their respective files in the config/, and run the migration.

If there are missing files related to bootstrap-material-design, download and use the version from the repo https://github.com/FezVrasta/bootstrap-material-design.

## using RESTful API

### SendingBlue API
Sendingblue API is the transactional email platform. It has a very structured REST, webhooks and a next-generation websockets API to take care of all your needs.

Reference - https://apidocs.sendinblue.com/

- Installation
  Copy mailin.rb to lib directory
- Prepare API key and secret key for user
- Call Sendingblue API for SMTP

- Example
```ruby
    m = Mailin.new("https://api.sendinblue.com/v2.0","<YOUR-API-KEY>")
	data = { "to" => {email => "Daycare"},
		"from" => [message.owner.email, message.owner.name],
		"subject" => message.title,
		"html" => message.content
	}
 
	result = m.send_email(data)
```

### SurveyGizmo API
It's easier than ever for team members to collaborate across multiple survey projects while maintaining administrative control over users and their roles.

API Reference - https://apihelp.surveygizmo.com/help/authentication

- Ruby on Rails gem for SurveyGizmo 
	https://github.com/jarthod/survey-gizmo-ruby/
	
	Currently supports SurveyGizmo API v4 (default) and v3.
- Installation
	`gem 'survey-gizmo-ruby'`
- Examples
```ruby
# Iterate over your all surveys directly with the iterator
SurveyGizmo::API::Survey.all(all_pages: true).each { |survey| do_something_with(survey) }
# Iterate over the 1st page of your surveys
SurveyGizmo::API::Survey.all(page: 1).each { |survey| do_something_with(survey) }

# Retrieve the survey with id: 12345
survey = SurveyGizmo::API::Survey.first(id: 12345)
survey.title # => "My Title"
survey.pages # => [page1, page2,...]
survey.number_of_completed_responses # => 355
survey.server_has_new_results_since?(Time.now.utc - 2.days) # => true
survey.team_names # => ['Development', 'Test']
survey.belongs_to?('Development') # => true

# Retrieve all questions for all pages of this survey
questions = survey.questions
# Strip out instruction, urlredirect, logic, media, and other non question "questions"
questions = survey.actual_questions

# Create a question for your survey.  The returned object will be given an :id parameter by SG.
question = SurveyGizmo::API::Question.create(survey_id: survey.id, title: 'Do u ruby?', type: 'checkbox')
# Update a question
question.title = "Do u <3 Ruby?"
question.save
# Destroy a question
question.destroy

# Iterate over all your Responses
survey.responses.each { |response| do_something_with(response) }
# Use filters to limit results - this example will iterate over page 3 of completed, non test data
# SurveyResponses submitted within the past 3 days for contact 999. The example `filters` array
# demonstrates how to use some of the gem's built in filters/generators as well as how to construct
# an ad hoc filter hash.
# See: http://apihelp.surveygizmo.com/help/article/link/filters for more info on filters
filters = [
  SurveyGizmo::API::Response::NO_TEST_DATA,
  SurveyGizmo::API::Response::ONLY_COMPLETED,
  SurveyGizmo::API::Response.submitted_since_filter(Time.now - 72.hours),
  {
    field: 'contact_id',
    operator: '=',
    value: 999
  }
]
survey.responses(page: 3, filters: filters).each { |response| do_stuff_with(response) }

# Parse the answer hash into a more usable format.
# Answers with keys but empty values will not be returned.
# "Other" text for some questions is parsed to Answer#other_text; all other answers to Answer#answer_text
# Custom table question answers have the question_pipe string parsed out to Answer#question_pipe.
# See http://apihelp.surveygizmo.com/help/article/link/surveyresponse-per-question for more info on answers
response.parsed_answers => # [#<SurveyGizmo::API::Answer @survey_id=12345, @question_id=1, @option_id=2, @answer_text='text'>]

# Retrieve all answers from all responses to all surveys, write rows to your database
SurveyGizmo::API::Survey.all(all_pages: true).each do |survey|
  survey.responses.each do |response|
    response.parsed_answers.each do |answer|
      MyLocalSurveyGizmoResponseModel.create(answer.to_hash)
    end
  end
end
```