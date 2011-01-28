(describe "Trakt" `(
  (it "returns a shared instance" (do ()
    (~ (Trakt sharedInstance) should be kindOfClass:Trakt)
  ))

  (describe "shared instance" `(
    (before (do ()
      (set @trakt (Trakt sharedInstance))
      (@trakt setApiKey:"secret")
    ))

    (it "takes a remote API key" (do ()
      (~ (@trakt apiKey) should be:"secret")
    ))
  ))
))
