(load "SpecHelper")

;(class UITextField
  ;(- (id)enterText:(id)text is
    ;(self setText:text)
    ;(self sendActionsForControlEvents:UIControlEventEditingDidEndOnExit)
  ;)
;)

(describe "AuthenticationViewController" `(
  (describe "when not authenticated" `(
    (before (do ()
      (set @controller ((AuthenticationViewController alloc) initWithNibName:"AuthenticationViewController" bundle:nil))
      ;(window setRootViewController:@controller)
      ((UIBacon sharedWindow) setRootViewController:@controller)
    ))

    (after (do ()
      ((UIBacon sharedWindow) setRootViewController:nil)
    ))

    (it "has a `Sign in' button which is disabled when the username/password fields are empty" (do ()
      (set button ($ "Sign in"))
      (~ button should not be:nil)
      (~ button should not be enabled)

      ((@controller usernameField) setText:"bob")
      (@controller textDidChange:nil) ; action send by textfield
      (~ button should not be enabled)

      ((@controller passwordField) setText:"secret")
      (@controller textDidChange:nil) ; action send by textfield
      (~ button should be enabled)

      ((@controller usernameField) setText:"")
      (@controller textDidChange:nil) ; action send by textfield
      (~ button should not be enabled)
    ))

    (it "saves the credentials and dismisses the view" (do ()
      ((@controller usernameField) setText:"bob")
      ((@controller passwordField) setText:"secret")
      (@controller textDidChange:nil) ; action send by textfield
      (($ "Sign in") touch)
    ))
  ))
))
