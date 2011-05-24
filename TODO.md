General
-------

* Research which OSS license the app should have and that we adhere to the licenses of APIs.
  TVDB: http://forums.thetvdb.com/viewtopic.php?f=8&t=2507


iOS app
* Unify the feedSelector and cachedFeedProperty methods used in the root controllers
* Handle connection errors in some way which is needed to provide a good UX. I.e. should we retry, take a failure block, etc.
* Rename 'thumb' to 'banner' in Show and Episode.
* When an episode title is TBD, disable the checkbox or remove it.
* Use `#` for numeric values in the index in library
* Echofon style network failure notification
* On all view controllers that show a search field, scroll the tableview a bit down so the search field isn’t visible by default.
* First launch: load calendar, then visible row images + library & recommendations feeds
* Not first launch, i.e. the app was inactive, or the user hits the ‘reload’ button: reload _all_ feeds, but load the current visible one first.
* Make HTTPDownload post start/stop notifications so that the refresh/stop buttons in the top-level controllers can show them accurately.
* Cache show posters and thumbs indefinitely.
* Library tab when not signed in should give a description of what one could do there when one has a Trakt account. (show one of these handrwitten text with arrow to the sign in button)
* Finally fix the incorrect highlighting of rows in calendar and recommended lists

* Only show an index in library when over 50 shows. However, the iPod app does show the index, even with 22 albums.
* The download code that is already tested elsewhere, eg ensureThumbIsLoaded, don’t need to be tested in the Trakt specs.
* Rename -[Episode initWithDictionary:] to initWithEpisodeInfo and same for -[Show initWithDictionary:].
* Check which font style we should use and possibly unify that into a UILabel subclass.
* Add Calendar class which returns episodes grouped by broadcast date.
* The Calendar class should take a show title filter string which makes the Calendar return only those dates and episodes that match.
* Set the preferred show poster thumb size from the calendar controller.


webapp
* Trakt.tv is quite slow with returning the updated ‘seen’ value for an episode in the calendar feed. Or is that the proxy?
  - Bug in Trakt api, created ticket

* Do the digits really have to be at the end of the index in the library view? The data already comes sorted, but has the digits first...

Auth
----

* Way to check if username exists (API)
* Show modal auth view when trying to sign in with stored credentials but it fails.
* Auth button when not signed in: ‘Sign in’
* Auth button when signed in: ‘alloy’

Auth window when not signed in:
===============================

* Text:
  Could not sign in (if failed)

  Forgot your password? (underlined!)

  Trakt is a website... etc
  Don’t have an account yet? (underlined!)

Auth window when signed in:
===============================

* Done button: none
* Text:
  You are signed in as alloy.

  BIG RED ‘SIGN OUT’ BUTTON

API
---

* Search through all shows

Proxy
-----

* See if we can receive the json in chunks, enrich them and immediately send them out again
* Write specs!
