(load "SpecHelper")

;(class UITextField
  ;(- (id)enterText:(id)text is
    ;(self setText:text)
    ;(self sendActionsForControlEvents:UIControlEventEditingDidEndOnExit)
  ;)
;)

(describe "AuthenticationViewController" `(
  (before (do ()
    (set @rootController ((UIViewController alloc) init))
    (set @controller ((AuthenticationViewController alloc) initWithNibName:"AuthenticationViewController" bundle:nil))
    ((UIBacon sharedWindow) setRootViewController:@rootController)
    (@rootController presentModalViewController:@controller animated:nil)

    (set @usernameField (@controller usernameField))
    (set @passwordField (@controller passwordField))
  ))

  (after (do ()
    (@controller dismissModalViewControllerAnimated:nil)
    ((UIBacon sharedWindow) setRootViewController:nil)
  ))

  (describe "when not authenticated" `(
    (before (do ()
      (@usernameField setText:nil)
      (@passwordField setText:nil)
      (@controller textDidChange:nil)
    ))

    (after (do ()
      (AuthenticationViewController saveAndAuthenticate:"bob" password:"secret")
    ))

    (it "has a `Sign in' button which is disabled when the username/password fields are empty" (do ()
      (set button ($ "Sign in"))
      (~ button should not be:nil)
      (~ button should not be enabled)

      (@usernameField setText:"bob")
      (@controller textDidChange:nil) ; action send by textfield
      (~ button should not be enabled)

      (@passwordField setText:"secret")
      (@controller textDidChange:nil) ; action send by textfield
      (~ button should be enabled)

      (@usernameField setText:"")
      (@controller textDidChange:nil) ; action send by textfield
      (~ button should not be enabled)
    ))

    (it "saves the credentials and if they're valid dismisses the view" (do ()
      (@usernameField setText:"bob")
      (@passwordField setText:"secret")
      (@controller textDidChange:nil) ; action send by textfield
      (($ "Sign in") touch)

      (~ ($ "Sign in") should not be enabled)
      (~ @usernameField should not be enabled)
      (~ @passwordField should not be enabled)

      (wait 0.8 (do ()
        (~ (@rootController modalViewController) should be:nil)
      ))
    ))

    (it "does not dismiss the view if the credentials are invalid" (do ()
      (@usernameField setText:"bob")
      (@passwordField setText:"wrong")
      (@controller textDidChange:nil) ; action send by textfield
      (($ "Sign in") touch)

      (~ ($ "Sign in") should not be enabled)
      (~ @usernameField should not be enabled)
      (~ @passwordField should not be enabled)

      (wait 0.1 (do ()
        (~ (@rootController modalViewController) should be:@controller)
        (~ ($ "Sign in") should be enabled)
        (~ @usernameField should be enabled)
        (~ @passwordField should be enabled)
      ))
    ))
  ))

  (describe "when authenticated" `(
    (it "fills in the username and password" (do ()
      (~ (@usernameField text) should be:"bob")
      (~ (@passwordField text) should be:"secret")
    ))
  ))
))
