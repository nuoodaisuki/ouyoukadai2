class GroupMailer < ApplicationMailer
  default from: ENV['YOUR_EMAIL_ADDRESS'] # 差出人メールアドレスを環境変数から取得

  def group_notification(group, owner, title, content)
    @group = group
    @owner = owner
    @title = title
    @content = content

    recipients = @group.users.pluck(:email)

    mail(
      to: recipients,
      subject: "#{@group.name}グループ: #{@title}"
    )
  end
end
