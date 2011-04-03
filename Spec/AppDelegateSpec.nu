(load "SpecHelper")

(class HTTPDownloadMock is HTTPDownload
  (- (id)errorMessage is
    "Ohnoes!"
  )
)

(describe "AppDelegate" `(
  (before (do ()
    (set @app (UIApplication sharedApplication))
    (set @delegate (iTraktAppDelegate new))
  ))

  (it "shows and hides the network activity indicator when downloads are in progress or finished" (do ()
    (~ (@app isNetworkActivityIndicatorVisible) should be:false)
    (@delegate downloadsAreInProgress)
    (~ (@app isNetworkActivityIndicatorVisible) should be:true)
    (@delegate downloadsAreFinished)
    (~ (@app isNetworkActivityIndicatorVisible) should be:false)
  ))

  (it "shows an alert when a download fails" (do ()
    (@delegate downloadFailed:((HTTPDownloadMock new)))
    (wait 0.1 (do ()
      (set window ((UIApplication sharedApplication) keyWindow))
      (set alert ((window subviews) objectAtIndex:0))
      (~ (alert message) should be:"Ohnoes!")

      (alert dismissWithClickedButtonIndex:0 animated:nil)
      (wait 1 (do ()))
    ))
  ))
))
