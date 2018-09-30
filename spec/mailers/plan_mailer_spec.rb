require "rails_helper"

RSpec.describe PlanMailer, :type => :mailer do
  let(:user) { create(:user, name: 'john', email: 'johnsnow@got.com') }

  # currently no association has defined between a user and a plan
  # describe "send_confirmation" do
  #   let(:mail) { PlanMailer.send_confirmation(user) }

  #   it "renders the headers" do
  #     expect(mail.subject).to eq("You have successfully upgraded your account")
  #     expect(mail.to).to eq(["johnsnow@got.com"])
  #     expect(mail.from).to eq(["no-reply@healthierchildcare.org"])
  #   end

  #   it "renders the body" do
  #     expect(mail.body.encoded).to include 'Upgrade confirmation for john'
  #   end
  # end

  describe "send_reminder" do
    let(:mail) { PlanMailer.send_reminder(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("You still have time to upgrade")
      expect(mail.to).to eq(["johnsnow@got.com"])
      expect(mail.from).to eq(["no-reply@healthierchildcare.org"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include 'Upgrade reminder for john'
    end
  end
end