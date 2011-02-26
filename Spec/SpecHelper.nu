(global true  1)
(global false 0)

(set trakt (Trakt sharedInstance))
(trakt setBaseURL:"http://localhost:9292/api")
(trakt setTraktBaseURL:"http://localhost:9292/trakt")
(trakt setApiKey:"apikey")
(trakt setApiUser:"bob")
(trakt setApiPassword:"secret")

; returns a block that's used by BaconShould to compare image data.
(function equalToImage (expectedImage)
  (do (actualImage)
    (eq true (Helper image:actualImage equalToImage:expectedImage))
  )
)
