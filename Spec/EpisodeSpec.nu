(load "SpecHelper")

(describe "Episode" `(
  (before (do ()
    (set calendar (((NSBundle mainBundle) yajl_JSONFromResource:"user-calendar-shows.json") objectAtIndex:0))
    (set episodeDict ((calendar valueForKey:"episodes") objectAtIndex:0))
    (set @episode ((Episode alloc) initWithDictionary:episodeDict))
  ))

  (it "returns the show's and episode's title" (do ()
    (~ (@episode showTitle) should be:"Fringe")
    (~ (@episode title) should be:"Reciprocity")
  ))

  (it "returns the TVDB ID" (do ()
    (~ (@episode tvdbID) should be:"82066")
  ))

  (it "returns the overview" (do ()
    (~ (@episode overview) should match:/^When the Fringe Team visits Massive Dynamic/)
  ))

  (it "returns where and when it will air" (do ()
    (~ (@episode network) should be:"FOX")
    (~ (@episode airtime) should be:"9:00 PM")
    (~ (@episode airTimeAndChannel) should be:"9:00 PM on FOX")
  ))

  (it "returns season and episode number info" (do ()
    (~ (@episode season) should be:3)
    (~ (@episode number) should be:1)
    (~ (@episode episodeNumber) should be:"3x01")
    (~ (@episode serieTitleAndEpisodeNumber) should be:"Fringe 3x01")
  ))

  (it "returns the poster url" (do ()
    (~ (@episode posterURL) should be:"http://localhost:9292/api/uploads/82066/poster-82066.jpg")
  ))

  (it "returns the thumb url" (do ()
    (~ (@episode thumbURL) should be:"http://localhost:9292/api/uploads/82066/thumb-82066-3-12.jpg")
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

  ;(describe "concerning its show poster" `(
  ;  (it "retrieves the poster image" (do ()
  ;    (set trakt (Trakt sharedInstance))
  ;    (trakt removeCachedImageForURL:(@episode posterURL))
  ;
  ;    (set @called nil)
  ;    (@episode ensureShowPosterIsLoadedWithNuBlock:(do ()
  ;      (set @called t)
  ;      (~ (@episode thumb) should be:(equalToImage (UIImage imageNamed:"poster-thumbnail.jpg")))
  ;    ))
  ;    (wait 0.1 (do ()
  ;      (~ @called should be:t)
  ;    ))
  ;  ))
  ;))

))
