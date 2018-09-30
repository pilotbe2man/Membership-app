# require "rails_helper"

# RSpec.describe CollaborationMailer, :type => :mailer do
#   let(:user) { create(:user, name: 'john', email: 'johnsnow@got.com') }

#   describe "send_confirmation" do
#     let(:mail) { CollaborationMailer.invite('test@exampl.com','SJECMLB',user) }

#     it "renders the headers" do
#       expect(mail.subject).to eq("You have been invited to collaborate on a child using Health Childcare")
#       expect(mail.to).to eq(["test@exampl.com"])
#       expect(mail.from).to eq(["no-reply@healthierchildcare.org"])
#     end
 
#     it "renders the body" do
#       expect(mail.body.encoded).to include ''
#     end
#   end
# end