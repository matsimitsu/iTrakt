(load "SpecHelper")

(describe "Episode" `(
  (before (do ()
    (set calendar (((NSBundle mainBundle) yajl_JSONFromResource:"user-calendar-shows.json") objectAtIndex:0))
    (set episodeDict ((calendar valueForKey:"episodes") objectAtIndex:0))
    (set @episode ((Episode alloc) initWithDictionary:episodeDict))
  ))

  (describe "concerning the associated Show instance that's created if the dictionary contains a `show' dictionary" `(
    (before (do ()
      (set @show (@episode show))
    ))

    (it "returns the show's title" (do ()
      (~ (@show title) should be:"Fringe")
    ))

    (it "returns the show's TVDB ID" (do ()
      (~ (@show tvdbID) should be:"82066")
    ))

    (it "returns the airtime in the right locale" (do ()
      (~ (@show localizedAirtime) should be:"3:00 AM")
    ))

    (it "returns where and when it will air" (do ()
      (~ (@show network) should be:"FOX")
      (~ (@show airtimeAndChannel) should be:"3:00 AM on FOX")
    ))

    (it "returns the poster url" (do ()
      (~ (@show posterURL) should be:(NSURL URLWithString:"http://localhost:9292/api/uploads/82066/poster-82066.jpg"))
    ))
  ))

  (it "returns the episode's title" (do ()
    (~ (@episode title) should be:"Concentrate and Ask Again")
  ))

  (it "returns the description" (do ()
    (~ (@episode overview) should match:/^When a scientist falls dead after ingesting a lethal cloud of blue powder/)
  ))

  (it "returns season and episode number info" (do ()
    (~ (@episode season) should be:3)
    (~ (@episode number) should be:1)
    (~ (@episode episodeNumber) should be:"3x01")
    (~ (@episode serieTitleAndEpisodeNumber) should be:"3x01 Fringe")
  ))

  (it "returns whether or not the user has seen it" (do ()
    (~ (@episode seen) should be:true)
    (@episode setSeen:false)
    (~ (@episode seen) should be:false)
  ))

  (it "toggles the `seen' state" (do ()
    (set @called false)
    (@episode toggleSeenWithNuBlock:(do ()
      (set @called true)
    ))
    (~ (@episode seen) should be:true)
    (wait 0.1 (do ()
      (~ @called should be:true)
      (~ (@episode seen) should be:false)

      (set @called false)
      (@episode toggleSeenWithNuBlock:(do ()
        (set @called true)
      ))
      (~ (@episode seen) should be:false)
      (wait 0.1 (do ()
        (~ @called should be:true)
        (~ (@episode seen) should be:true)
      ))
    ))
  ))

  (it "returns the thumb url" (do ()
    (~ (@episode thumbURL) should be:(NSURL URLWithString:"http://localhost:9292/api/uploads/82066/thumb-82066-3-12.jpg"))
  ))

  (describe "concerning its episode thumb" `(
    (it "retrieves the thumb image" (do ()
      (set trakt (Trakt sharedInstance))
      (trakt removeCachedImageForURL:(@episode thumbURL))

      (set @called nil)
      (@episode ensureThumbIsLoadedWithNuBlock:(do ()
        (set @called t)
        (~ (@episode thumb) should be:(equalToImage (UIImage imageNamed:"thumb.jpg")))
      ))
      (wait 0.1 (do ()
        (~ @called should be:t)
      ))
    ))
  ))

))
