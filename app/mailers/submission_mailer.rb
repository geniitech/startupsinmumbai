class SubmissionMailer < ActionMailer::Base
  default 'no-reply@startupsinmumbai.com'

  def thanks(organization)
    @organization = organization
    mail(to: @organization.submitter_email, subject: 'Welcome to My Awesome Site')
  end

end