(load "SpecHelper")

; TODO We really need a way to resume directly when finished instead of only time based. For example:
;
;   (self resume)
;
; Should resume the halted spec execution.

(class HTTPDownloadDelegateMock is NSObject
  (ivar (id)methodCalls)

  (- (id)init is
    (if (super init)
      (set @methodCalls (NSMutableDictionary dictionary))
      self
    )
  )

  (- (id) methodCalls is
    @methodCalls
  )

  (- (id)downloadFailed:(id)download is
    (@methodCalls setValue:download forKey:"downloadFailed:")
  )

  (- (id)downloadsAreInProgress is
    (set count (@methodCalls valueForKey:"downloadsAreInProgress"))
    (unless count (set count 0))
    (set count (+ count 1))
    (@methodCalls setValue:count forKey:"downloadsAreInProgress")
  )

  (- (id)downloadsAreFinished is
    (set count (@methodCalls valueForKey:"downloadsAreFinished"))
    (unless count (set count 0))
    (set count (+ count 1))
    (@methodCalls setValue:count forKey:"downloadsAreFinished")
  )
)

(describe "HTTPDownload" `(
  (before (do ()
    (set @delegate (HTTPDownloadDelegateMock new))
    (HTTPDownload setGlobalDelegate:@delegate)
  ))

  (it "yields the downloaded data" (do ()
    (HTTPDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/hello") nuBlock:(do (response)
      (set string (Helper stringFromUTF8Data:response))
      ;(puts string)
      (~ string should equal:"Hello world!")
    ))
    (wait 0.1 (do ()
      (~ ((@delegate methodCalls) valueForKey:"downloadFailed:") should be:nil)
    ))
  ))

  (it "calls the global connection delegate when a server side failure occurred" (do ()
    (set @called nil)
    (HTTPDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/status-code?code=500") nuBlock:(do (response)
      (set @called t)
    ))
    (wait 0.1 (do ()
      (~ @called should be:nil)
      (~ ((@delegate methodCalls) valueForKey:"downloadFailed:") should be kindOfClass:HTTPDownload)
    ))
  ))

  (it "calls the global connection delegate when a client side failure occurred" (do ()
    (set @called nil)
    (HTTPDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/status-code?code=404") nuBlock:(do (response)
      (set @called t)
    ))
    (wait 0.1 (do ()
      (~ @called should be:nil)
      (~ ((@delegate methodCalls) valueForKey:"downloadFailed:") should be kindOfClass:HTTPDownload)
    ))
  ))

  (it "adds itself to the global list of 'in progress' downloads and removes it when done" (do ()
    (set download (HTTPDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/hello") nuBlock:(do (response)
      ; nothing
    )))
    (~ (HTTPDownload inProgress) should equal:(NSSet setWithObject:download))
    (wait 0.1 (do ()
      (~ (HTTPDownload inProgress) should equal:(NSSet set))
    ))
  ))

  (it "notifies the global delegate that download(s) are in progress or stopped, but only once" (do ()
    (HTTPDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/hello") nuBlock:(do (response)
      ; nothing
    ))
    (HTTPDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/hello") nuBlock:(do (response)
      ; nothing
    ))
    (wait 0.1 (do ()
      (~ ((@delegate methodCalls) valueForKey:"downloadsAreInProgress") should be:1)
      (~ ((@delegate methodCalls) valueForKey:"downloadsAreFinished") should be:1)
    ))
  ))

  (it "cancels any downloads in progress" (do ()
    (set @called nil)
    (HTTPDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/hello") nuBlock:(do (response)
      (set @called t)
    ))
    (HTTPDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/hello") nuBlock:(do (response)
      (set @called t)
    ))
    (HTTPDownload cancelDownloadsInProgress)
    (wait 0.1 (do ()
      (~ @called should be:nil)
      (~ (HTTPDownload inProgress) should equal:(NSSet set))
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

(describe "ImageDownload" `(
  (it "yields the downloaded image data as a UIImage" (do ()
    (ImageDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/poster.jpg") nuBlock:(do (response)
      ;(puts response)
      (~ response should be:(equalToImage (UIImage imageNamed:"poster.jpg")))
    ))
    (wait 0.3 (do ()
      ; Nothing... We just wait with further spec execution until the ImageDownload is (probably) finished.
    ))
  ))
))
