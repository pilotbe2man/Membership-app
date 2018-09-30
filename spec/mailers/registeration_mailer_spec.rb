require "rails_helper"

RSpec.describe RegistrationMailer, :type => :mailer do
  let(:user) { create(:user, name: 'john', email: 'johnsnow@got.com') }
  let(:subject) { 'Register' }
  let(:content) { 'Register to get notifications' }

  describe "send_confirmation" do
    let(:mail) { RegistrationMailer.send_confirmation(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirm Your Account")
      expect(mail.to).to eq(["johnsnow@got.com"])
      expect(mail.from).to eq(["no-reply@healthierchildcare.org"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include 'Thank you for signing up!'
    end
  end
end