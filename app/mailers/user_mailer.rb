class UserMailer < ApplicationMailer
    #default :from => "pluto@expensemanager.com"

    def password_reset_email(user)
        @name = user.name  || user.email
        @reset_password_token = user.reset_password_token
        mail(to: user.email,from: "pluto@expensemanager.com", subject: "Your password needs to reset.")
    end
end
  
