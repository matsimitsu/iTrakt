(describe "HTTPDownload" `(
  (before (do ()
    (set @dl ((HTTPDownload alloc) initWithURL:(NSURL URLWithString:"http://127.0.0.1:3000/hello-world") delegate:self))
  ))

  ;(it "has a reference to the delegate" (do ()
    ;(~ (@dl delegate) should be:self)
  ;))

  (it "returns the downloaded data" (do ()
    (wait 1 (do ()
      (~ ((NSString alloc) initWithData:(@dl data) encoding:"NSUTF8StringEncoding") should be:"Hello world!")
    ))
  ))
))

(describe "Trakt" `(
  (it "returns a shared instance" (do ()
    (~ (Trakt sharedInstance) should be kindOfClass:Trakt)
  ))

  (describe "shared instance" `(
    (before (do ()
      (set @trakt (Trakt sharedInstance))
      (@trakt setApiUser:"bob")
      (@trakt setApiKey:"secret")
    ))

    (it "returns the base URL" (do ()
      (~ (@trakt baseURL) should be:"http://api.trakt.tv")
    ))

    (it "takes a remote API key" (do ()
      (~ (@trakt apiKey) should be:"secret")
    ))

    (it "returns the user's name" (do ()
      (~ (@trakt apiUser) should be:"bob")
    ))

    (it "returns the user's calendar URL" (do ()
      (~ (@trakt calendarURL) should be:"http://api.trakt.tv/user/calendar/shows.json/secret/bob")
    ))
  ))
))
