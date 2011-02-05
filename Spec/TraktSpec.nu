(load "SpecHelper")

; TODO We really need a way to resume directly when finished instead of only time based. For example:
;
;   (self resume)
;
; Should resume the halted spec execution.

(describe "HTTPDownload" `(
  (it "yields the downloaded data" (do ()
    (HTTPDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/hello") nuBlock:(do (response)
      (set string (Helper stringFromUTF8Data:response))
      ;(puts string)
      (~ string should equal:"Hello world!")
    ))
    (wait 0.1 (do ()
      ; Nothing... We just wait with further spec execution until the HTTPDownload is (probably) finished.
    ))
  ))
))

(describe "JSONDownload" `(
  (describe "with a serialized array" `(
    (it "yields the downloaded JSON as a deserialized array" (do ()
      (JSONDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/json/simple-array") nuBlock:(do (response)
        ;(puts response)
        (~ response should equal:(`("Muchos" "Bananas") array))
      ))
      (wait 0.1 (do ()
        ; Nothing... We just wait with further spec execution until the JSONDownload is (probably) finished.
      ))
    ))
  ))

  (describe "with a serialized dictionary" `(
    (it "yields the downloaded JSON as a deserialized dictionary" (do ()
      (JSONDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/json/simple-dictionary") nuBlock:(do (response)
        ;(puts response)
        (set dictionary (NSMutableDictionary dictionary))
        (dictionary setValue:"Bananas" forKey:"Muchos")
        (~ response should equal:dictionary)
      ))
      (wait 0.1 (do ()
        ; Nothing... We just wait with further spec execution until the JSONDownload is (probably) finished.
      ))
    ))
  ))
))

(describe "ImageDownload" `(
  (it "yields the downloaded image data as a UIImage" (do ()
    (ImageDownload downloadFromURL:(NSURL URLWithString:"http://localhost:9292/poster.jpg") nuBlock:(do (response)
      ;(puts response)
      (~ response should be:(equalToImage (UIImage imageNamed:"poster.jpg")))
    ))
    (wait 0.3 (do ()
      ; Nothing... We just wait with further spec execution until the ImageDownload is (probably) finished.
    ))
  ))
))

(describe "Trakt" `(
  (before (do ()
    (set @trakt (Trakt sharedInstance))
  ))

  (it "returns a shared instance" (do ()
    (~ @trakt should be kindOfClass:Trakt)
  ))

  (describe "shared instance" `(
    (it "returns the base URL" (do ()
      (~ (@trakt baseURL) should be:"http://localhost:9292/api")
    ))

    ;(it "takes a remote API key" (do ()
      ;(~ (@trakt apiKey) should be:"secret")
    ;))

    (it "returns the user's name" (do ()
      (~ (@trakt apiUser) should be:"bob")
    ))

    (describe "concerning the user's calendar" `(
      (it "returns the user's calendar URL" (do ()
        (~ ((@trakt calendarURL) absoluteString) should be:"http://localhost:9292/api/users/calendar.json?name=bob")
      ))

      (it "yields the calendar as an array of BroadcastDate instances" (do ()
        (@trakt calendarWithNuBlock:(do (calendar)
          ;(puts calendar)
          (set date (calendar objectAtIndex:0))
          (~ date should be kindOfClass:BroadcastDate)
          (set episode ((date episodes) objectAtIndex:0))
          (~ (episode title) should be:"Concentrate and Ask Again")
        ))
        (wait 0.1 (do ()
          ; Nothing... We just wait with further spec execution until the ImageDownload is (probably) finished.
        ))
      ))

      (it "sorts the episodes on airtime and then by show name" (do ()
        (@trakt calendarWithNuBlock:(do (calendar)
          ;(puts calendar)
          (set date (calendar objectAtIndex:1))
          (~ date should be kindOfClass:BroadcastDate)

          (set episode ((date episodes) objectAtIndex:0))
          (~ (episode showTitle) should be:"Episodes")
          (~ (episode localizedAirTime) should be:"3:30 AM")

          (set episode ((date episodes) objectAtIndex:1))
          (~ (episode showTitle) should be:"Flashpoint")
          (~ (episode localizedAirTime) should be:"4:00 AM")

          (set episode ((date episodes) objectAtIndex:2))
          (~ (episode showTitle) should be:"Top Gear")
          (~ (episode localizedAirTime) should be:"4:00 AM")
        ))
        (wait 0.1 (do ()
          ; Nothing... We just wait with further spec execution until the ImageDownload is (probably) finished.
        ))
      ))
    ))

    (it "returns the user's library URL" (do ()
      (~ ((@trakt libraryURL) absoluteString) should be:"http://localhost:9292/api/users/library.json?name=bob")
    ))

    (it "yields the user's library as an array of Show instances" (do ()
      (@trakt libraryWithNuBlock:(do (library)
        ;(puts library)
        (set show (library objectAtIndex:0))
        (~ show should be kindOfClass:Show)
        (~ (show title) should be:"30 Rock")
      ))
      (wait 0.1 (do ()
        ; Nothing... We just wait with further spec execution until the ImageDownload is (probably) finished.
      ))
    ))

    (it "returns the trending shows URL" (do ()
      (~ ((@trakt trendingURL) absoluteString) should be:"http://localhost:9292/api/shows/trending.json")
    ))

    (it "yields the trending shows as an array of Show instances" (do ()
      (@trakt trendingWithNuBlock:(do (trending)
        ;(puts trending)
        (set show (trending objectAtIndex:0))
        (~ show should be kindOfClass:Show)
        (~ (show title) should be:"How I Met Your Mother")
      ))
      (wait 0.1 (do ()
        ; Nothing... We just wait with further spec execution until the ImageDownload is (probably) finished.
      ))
    ))

    (describe "concerning images" `(
      ; TODO possinly also check with the fixtures server whether or not a request was actually made. I.e. keep a request counter.
      (describe "and downloading/caching thereof" `(
        (it "downloads, caches, and yields the requested image" (do ()
          ((EGOCache currentCache) removeCacheForKey:"poster.jpg")
          (set url (NSURL URLWithString:"http://localhost:9292/poster.jpg"))
          (~ (@trakt cachedImageForURL:url) should be:nil)

          (@trakt loadImageFromURL:url nuBlock:(do (image cached)
            ;(puts image)
            ;(puts cached)
            (~ cached should be:false)
            (~ image should be:(equalToImage (UIImage imageNamed:"poster.jpg")))
          ))
          (wait 0.3 (do ()
            (~ (@trakt cachedImageForURL:url) should be:(equalToImage (UIImage imageNamed:"poster.jpg")))
          ))
        ))

        ; Depends on the previous spec to have run.
        (it "retrieves the image from the cache, if available" (do ()
          (set url (NSURL URLWithString:"http://localhost:9292/poster.jpg"))
          (~ (@trakt cachedImageForURL:url) should not be:nil)
          (@trakt loadImageFromURL:url nuBlock:(do (image cached)
            ;(puts image)
            ;(puts cached)
            (~ cached should be:true)
            (~ image should be:(equalToImage (UIImage imageNamed:"poster.jpg")))
          ))
          (wait 0.1 (do ()
            ; Nothing... This is only really necessary if the spec fails which means the image did not come from the cache.
          ))
        ))
      ))

      (describe "by URL" `(
        (it "yields a thumbail of a show poster" (do ()
          (set url (NSURL URLWithString:"http://localhost:9292/api/uploads/82066/poster-82066.jpg"))
          (@trakt removeCachedImageForURL:url scaledTo:`(44 66))
          (~ (@trakt cachedImageForURL:url scaledTo:`(44 66)) should be:nil)

          (@trakt showPosterForURL:url nuBlock:(do (poster cached)
            (~ cached should be:false)
            (~ poster should be:(equalToImage (UIImage imageNamed:"poster-thumbnail.jpg")))
          ))
          (wait 0.3 (do ()
            (~ (@trakt cachedImageForURL:url scaledTo:`(44 66)) should be:(equalToImage (UIImage imageNamed:"poster-thumbnail.jpg")))
          ))
        ))

        (it "yields a episode thumb" (do ()
          ((EGOCache currentCache) removeCacheForKey:"thumb-82066-3-12.jpg")

          (set url (NSURL URLWithString:"http://localhost:9292/api/uploads/82066/thumb-82066-3-12.jpg"))
          (~ (@trakt cachedImageForURL:url) should be:nil)

          (@trakt showThumbForURL:url nuBlock:(do (thumb cached)
            (~ cached should be:false)
            (~ thumb should be:(equalToImage (UIImage imageNamed:"thumb.jpg")))
          ))
          (wait 0.1 (do ()
            (~ (@trakt cachedImageForURL:url) should be:(equalToImage (UIImage imageNamed:"thumb.jpg")))
          ))
        ))
      )) ; by URL
    )) ; concerning images
  )) ; shared instance
))
