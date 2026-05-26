Feature: Resetting password via email

    Background:
        Given I have a registered account with the email "usuario@unb.br"

    Scenario: Request password reset email
        Given I am on the login page
        When I click on "Esqueci minha senha"
        And I fill in the email field with "usuario@unb.br"
        And I click on "Enviar"
        Then I should see a confirmation message "E-mail de redefinição enviado"
        And an email with a reset link should be sent to "usuario@unb.br"

    Scenario: Redefine password successfully using email link
        Given I have requested a password reset for "usuario@unb.br"
        And I have received the reset link in my email
        When I access the reset link
        And I fill in the new password field with "NovaSenha123"
        And I fill in the confirmation field with "NovaSenha123"
        And I click on "Redefinir Senha"
        Then I should see a confirmation message "Senha redefinida com sucesso"
        And I should be able to log in with "usuario@unb.br" and "NovaSenha123"

    Scenario: Fail to redefine password with mismatched confirmation
        Given I have requested a password reset for "usuario@unb.br"
        And I have received the reset link in my email
        When I access the reset link
        And I fill in the new password field with "NovaSenha123"
        And I fill in the confirmation field with "OutraSenha456"
        And I click on "Redefinir Senha"
        Then I should see an error message "As senhas não coincidem"

    Scenario: Fail to use an expired reset link
        Given I have requested a password reset for "usuario@unb.br"
        And the reset link has expired
        When I access the reset link
        Then I should see an error message "Link de redefinição expirado"

    Scenario: Request reset with unregistered email
        Given I am on the login page
        When I click on "Esqueci minha senha"
        And I fill in the email field with "naoexiste@unb.br"
        And I click on "Enviar"
        Then I should see an error message "E-mail não encontrado"
