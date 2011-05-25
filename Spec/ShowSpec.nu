(load "SpecHelper")

(describe "Show" `(
  (before (do ()
    (set @showDict (NSMutableDictionary dictionary))
    (@showDict setValue:"Fringe" forKey:"title")
    (@showDict setValue:2008      forKey:"year")
    (@showDict setValue:"82066"   forKey:"tvdb_id")
    (@showDict setValue:"http://localhost:9292/api/uploads/82066/poster-82066.jpg", forKey:"poster")
    (set @show ((Show alloc) initWithDictionary:@showDict))
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

  (it "returns a formatted season and episode count label" (do ()
    (~ (@show seasonsAndEpisodes) should be:"Episodes")
    (@showDict setValue:0 forKey:"season_count")
    (@showDict setValue:0 forKey:"episode_count")
    (~ (@show seasonsAndEpisodes) should be:"Episodes")
    (@showDict setValue:3 forKey:"season_count")
    (@showDict setValue:0 forKey:"episode_count")
    (~ (@show seasonsAndEpisodes) should be:"Episodes")
    (@showDict setValue:3 forKey:"season_count")
    (@showDict setValue:60 forKey:"episode_count")
    (~ (@show seasonsAndEpisodes) should be:"3 Seasons, 60 Episodes")
  ))

  (describe "concerning episode data" `(
    (it "retrieves the seasons and episodes" (do ()
      (set @called nil)
      (@show ensureSeasonsAreLoadedWithNuBlock:(do ()
        (set @called t)
        (set seasons (@show seasons))

        (set season (seasons objectAtIndex:0))
        (~ (season label) should be:"Season 3")
        (~ (((season episodes) objectAtIndex:0) title) should be:"Olivia")

        (set season (seasons objectAtIndex:1))
        (~ (season label) should be:"Season 2")
        (~ (((season episodes) objectAtIndex:0) title) should be:"A New Day in the Old Town")

        (set season (seasons objectAtIndex:2))
        (~ (season label) should be:"Season 1")
        (~ (((season episodes) objectAtIndex:0) title) should be:"Pilot")

        (set season (seasons objectAtIndex:3))
        (~ (season label) should be:"Specials")
        (~ (((season episodes) objectAtIndex:0) title) should be:"Unaired Pilot")
      ))
      (wait 0.3 (do ()
        (~ @called should be:t)
      ))
    ))
  ))

  (describe "concerning its poster" `(
    (it "returns the default poster if the poster hasn't been downloaded and isn't available in the cache" (do ()
      (set trakt (Trakt sharedInstance))
      (trakt removeCachedImageForURL:(@show posterURL) scaledTo:`(44 66))
      (~ (@show poster) should be:(equalToImage (UIImage imageNamed:"placeholder-portrait.png")))
    ))

    (it "downloads the poster image if it's not loaded from the cache" (do ()
      (set @called nil)
      (@show ensurePosterIsLoadedWithNuBlock:(do ()
        (set @called t)
        (~ (@show poster) should be:(equalToImage (UIImage imageNamed:"poster-thumbnail.jpg")))
      ))
      (wait 0.3 (do ()
        (~ @called should be:t)
      ))
    ))

    (it "loads the poster image from the cache when requested and available" (do ()
      ; it was downloaded in the previous spec. Yes I know, dependencies... sigh
      (~ (@show poster) should be:(equalToImage (UIImage imageNamed:"poster-thumbnail.jpg")))
    ))
  ))

))
