(load "SpecHelper")

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
))
