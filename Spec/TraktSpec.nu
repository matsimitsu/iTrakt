(global NSUTF8StringEncoding 4)

(describe "HTTPDownload" `(
  (it "yields the downloaded data" (do ()
    ((HTTPDownload alloc) initWithURL:(NSURL URLWithString:"http://localhost:9292/hello") nuBlock:(do (response)
      (set string (((NSString alloc) initWithData:response encoding:NSUTF8StringEncoding) chomp))
      (~ string should equal:"Hello world!")
    ))
    (wait 0.1 (do ()
      ; Nothing... We just wait with further spec execution until the HTTPDownload is (probably) finished.
      ;
      ; TODO We really need a way to resume directly when finished instead of only time based. For example:
      ;
      ;   (self resume)
      ;
      ; Should resume the halted spec execution.
    ))
  ))
))

;(describe "Trakt" `(
  ;(it "returns a shared instance" (do ()
    ;(~ (Trakt sharedInstance) should be kindOfClass:Trakt)
  ;))

  ;(describe "shared instance" `(
    ;(before (do ()
      ;(set @trakt (Trakt sharedInstance))
      ;(@trakt setApiUser:"bob")
      ;(@trakt setApiKey:"secret")
    ;))

    ;(it "returns the base URL" (do ()
      ;(~ (@trakt baseURL) should be:"http://api.trakt.tv")
    ;))

    ;(it "takes a remote API key" (do ()
      ;(~ (@trakt apiKey) should be:"secret")
    ;))

    ;(it "returns the user's name" (do ()
      ;(~ (@trakt apiUser) should be:"bob")
    ;))

    ;(it "returns the user's calendar URL" (do ()
      ;(~ (@trakt calendarURL) should be:"http://api.trakt.tv/user/calendar/shows.json/secret/bob")
    ;))
  ;))
;))
