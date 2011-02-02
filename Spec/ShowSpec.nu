(load "SpecHelper")

(describe "Show" `(
  (before (do ()
    (set showDict (NSMutableDictionary dictionary))
    (showDict setValue:"30 Rock" forKey:"title")
    (showDict setValue:2006      forKey:"year")
    (showDict setValue:"79488"   forKey:"tvdb_id")
    (set @show ((Show alloc) initWithDictionary:showDict))
  ))

  (it "returns the show's title" (do ()
    (~ (@show title) should be:"30 Rock")
  ))

  (it "returns the year the show started" (do ()
    (~ (@show year) should be:2006)
  ))

  (it "returns the show's TVDB ID" (do ()
    (~ (@show tvdbID) should be:"79488")
  ))

  ; TODO Can't run any specs yet concerning this as long as we don't have the poster urls in the JSON yet
  ;(describe "concerning its poster" `(
    ;(it "retrieves the poster image" (do ()
      ;(set trakt (Trakt sharedInstance))
      ;(trakt removeCachedImageForURL:(@episode posterURL) scaledTo:`(44 66))

      ;(set @called nil)
      ;(@episode ensureShowPosterIsLoadedWithNuBlock:(do ()
        ;(set @called t)
        ;(~ (@episode poster) should be:(equalToImage (UIImage imageNamed:"poster-thumbnail.jpg")))
      ;))
      ;(wait 0.3 (do ()
        ;(~ @called should be:t)
      ;))
    ;))
  ;))

))
