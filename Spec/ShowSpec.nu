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
))
