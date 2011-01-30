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

  (it "returns the description" (do ()
    (~ (@episode description) should match:/^When the Fringe Team visits Massive Dynamic/)
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
))