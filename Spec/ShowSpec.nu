(load "SpecHelper")

(describe "Show" `(
  (before (do ()
    (set showDict (NSMutableDictionary dictionary))
    (showDict setValue:"Fringe" forKey:"title")
    (showDict setValue:2008      forKey:"year")
    (showDict setValue:"82066"   forKey:"tvdb_id")
    (showDict setValue:"http://localhost:9292/api/uploads/82066/poster-82066.jpg", forKey:"poster")
    (set @show ((Show alloc) initWithDictionary:showDict))
  ))

  (it "returns the show's title" (do ()
    (~ (@show title) should be:"Fringe")
  ))

  (it "returns the year the show started" (do ()
    (~ (@show year) should be:2008)
  ))

  (it "returns the show's TVDB ID" (do ()
    (~ (@show tvdbID) should be:"82066")
  ))

  (it "returns the poster URL" (do ()
    (~ (@show posterURL) should be:(NSURL URLWithString:"http://localhost:9292/api/uploads/82066/poster-82066.jpg"))
  ))

  (describe "concerning its poster" `(
    (it "retrieves the poster image" (do ()
      (set trakt (Trakt sharedInstance))
      (trakt removeCachedImageForURL:(@show posterURL) scaledTo:`(44 66))

      (set @called nil)
      (@show ensurePosterIsLoadedWithNuBlock:(do ()
        (set @called t)
        (~ (@show poster) should be:(equalToImage (UIImage imageNamed:"poster-thumbnail.jpg")))
      ))
      (wait 0.3 (do ()
        (~ @called should be:t)
      ))
    ))
  ))

))
