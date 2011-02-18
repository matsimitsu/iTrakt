(load "SpecHelper")

(describe "Episode" `(
  (before (do ()
    (set calendar (((NSBundle mainBundle) yajl_JSONFromResource:"user-calendar-shows.json") objectAtIndex:0))
    (set episodeDict ((calendar valueForKey:"episodes") objectAtIndex:0))
    (set @episode ((Episode alloc) initWithDictionary:episodeDict))
  ))

  (it "returns the show's and episode's title" (do ()
    (~ (@episode showTitle) should be:"Fringe")
    (~ (@episode title) should be:"Concentrate and Ask Again")
  ))

  (it "returns the TVDB ID" (do ()
    (~ (@episode tvdbID) should be:"82066")
  ))

  (it "returns the description" (do ()
    (~ (@episode overview) should match:/^When a scientist falls dead after ingesting a lethal cloud of blue powder/)
  ))

  (it "returns the time in the right locale" (do ()
    (~ (@episode localizedAirTime) should be:"3:00 AM")
  ))

  (it "returns where and when it will air" (do ()
    (~ (@episode network) should be:"FOX")
    (~ (@episode airTimeAndChannel) should be:"3:00 AM on FOX")
  ))

  (it "returns season and episode number info" (do ()
    (~ (@episode season) should be:3)
    (~ (@episode number) should be:1)
    (~ (@episode episodeNumber) should be:"3x01")
    (~ (@episode serieTitleAndEpisodeNumber) should be:"3x01 Fringe")
  ))

  (it "returns whether or not the user has seen it" (do ()
    (~ (@episode seen) should be:true)
  ))

  (it "returns the poster url" (do ()
    (~ (@episode posterURL) should be:(NSURL URLWithString:"http://localhost:9292/api/uploads/82066/poster-82066.jpg"))
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

  (describe "concerning its show poster" `(
    (it "returns the default poster if the poster hasn't been downloaded and isn't available in the cache" (do ()
      (set trakt (Trakt sharedInstance))
      (trakt removeCachedImageForURL:(@episode posterURL) scaledTo:`(44 66))
      (~ (@episode poster) should be:(equalToImage (UIImage imageNamed:"default-poster.png")))
    ))

    (it "downloads the poster image if it's not loaded from the cache" (do ()
      (set @called nil)
      (@episode ensureShowPosterIsLoadedWithNuBlock:(do ()
        (set @called t)
        (~ (@episode poster) should be:(equalToImage (UIImage imageNamed:"poster-thumbnail.jpg")))
      ))
      (wait 0.3 (do ()
        (~ @called should be:t)
      ))
    ))

    (it "loads the poster image from the cache when requested and available" (do ()
      ; it was downloaded in the previous spec. Yes I know, dependencies... sigh
      (~ (@episode poster) should be:(equalToImage (UIImage imageNamed:"poster-thumbnail.jpg")))
    ))
  ))

))
