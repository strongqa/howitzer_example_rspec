class ConfirmationInstructionEmail < Email
  SUBJECT = "Confirmation instructions"

  def confirm_my_account
    WebPage.visit confirmation_link
  end

  def confirmation_link
    res = plain_text_body[/Confirm my account \((.+?)\)/, 1]
    log.error("Confirmation link was not found") if res.nil?
    res
  end
end
