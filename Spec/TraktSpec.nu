; TODO We really need a way to resume directly when finished instead of only time based. For example:
;
;   (self resume)
;
; Should resume the halted spec execution.

(describe "HTTPDownload" `(
  (it "yields the downloaded data" (do ()
    (HTTPDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/hello") nuBlock:(do (response)
      (set string (Helper stringFromUTF8Data:response))
      ;(puts string)
      (~ string should equal:"Hello world!")
    ))
    (wait 0.1 (do ()
      ; Nothing... We just wait with further spec execution until the HTTPDownload is (probably) finished.
    ))
  ))
))

(describe "JSONDownload" `(
  (describe "with a serialized array" `(
    (it "yields the downloaded JSON as a deserialized array" (do ()
      (JSONDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/json/simple-array") nuBlock:(do (response)
        ;(puts response)
        (~ response should equal:(`("Muchos" "Bananas") array))
      ))
      (wait 0.1 (do ()
        ; Nothing... We just wait with further spec execution until the JSONDownload is (probably) finished.
      ))
    ))
  ))

  (describe "with a serialized dictionary" `(
    (it "yields the downloaded JSON as a deserialized dictionary" (do ()
      (JSONDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/json/simple-dictionary") nuBlock:(do (response)
        ;(puts response)
        (set dictionary (NSMutableDictionary dictionary))
        (dictionary setValue:"Bananas" forKey:"Muchos")
        (~ response should equal:dictionary)
      ))
      (wait 0.1 (do ()
        ; Nothing... We just wait with further spec execution until the JSONDownload is (probably) finished.
      ))
    ))
  ))
))

; returns a block that's used by BaconShould to compare image data.
(function equalToImage (expectedImage)
  (do (actualImage)
    (eq 1 (Helper image:actualImage equalToImage:expectedImage))
  )
)

(describe "ImageDownload" `(
  (it "yields the downloaded image data as a UIImage" (do ()
    (ImageDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/poster.jpg") nuBlock:(do (response)
      ;(puts response)
      (set image (UIImage imageNamed:"poster.jpg"))
      (~ response should be:(equalToImage image))
    ))
    (wait 0.1 (do ()
      ; Nothing... We just wait with further spec execution until the ImageDownload is (probably) finished.
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
      (@trakt setBaseURL:"http://localhost:9292/api")
      (@trakt setApiUser:"bob")
      ;(@trakt setApiKey:"secret")
    ))

    (it "returns the base URL" (do ()
      (~ (@trakt baseURL) should be:"http://localhost:9292/api")
    ))

    ;(it "takes a remote API key" (do ()
      ;(~ (@trakt apiKey) should be:"secret")
    ;))

    (it "returns the user's name" (do ()
      (~ (@trakt apiUser) should be:"bob")
    ))

    (it "returns the user's calendar URL" (do ()
      (~ ((@trakt calendarURL) absoluteString) should be:"http://localhost:9292/api/users/calendar.json?name=bob")
    ))

    (it "yields the user's calendar as an array of BroadcastDate instances" (do ()
      (@trakt calendarWithNuBlock:(do (calendar)
        ;(puts calendar)
        (set date (calendar objectAtIndex:0))
        (~ date should be kindOfClass:BroadcastDate)
        (set episode ((date episodes) objectAtIndex:0))
        (~ (episode title) should be:"Reciprocity")
      ))
      (wait 0.1 (do ()
        ; Nothing... We just wait with further spec execution until the ImageDownload is (probably) finished.
      ))
    ))
  ))
))
