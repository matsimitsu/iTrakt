General
-------

* Research which OSS license the app should have and that we adhere to the licenses of APIs.
  TVDB: http://forums.thetvdb.com/viewtopic.php?f=8&t=2507

* Add -[NSArray objectAtIndexPath:] and refactor controllers.
* Probably not really necessary to do things like: [[shows copy] autorelease] in Trakt.m
* Rename -[Episode initWithDictionary:] to initWithEpisodeInfo and same for -[Show initWithDictionary:].
* Episode watched field in the calendar feed is outside of the episode hash.
* Trakt.tv is quite slow with returning the updated 'seen' value for an episode in the calendar feed. Or is that the proxy?
* How do we deal with the Trakt API key?
* The download code that is already tested elsewhere, eg ensureThumbIsLoaded, don't need to be tested in the Trakt specs.
* Refactor top-level controllers again to cleanup the code related to refreshing data as well.
* Add Calendar class which returns episodes grouped by broadcast date.
* The Calendar class should take a show title filter string which makes the Calendar return only those dates and episodes that match.
* Set the preferred show poster thumb size from the calendar controller.
* Handle connection errors in some way which is needed to provide a good UX. I.e. should we retry, take a failure block, etc.

Authentication
--------------

* Settings screen to enter username
* Way to check if username exists

Caching
-------

* Cache show posters and thumbs indefinitely.

API
---

* Search through all shows
* Get ids of all updated shows/episodes


Proxy
-----

* Port to rack / sinatra
* See if we can receive the json in chunks, enrich them and immediately send them out again
* Write specs!


Design discussion
-----------------

* The Library list should be searchable. Does it make sense for the trending list? Maybe not, as you're browsing for new shows.
* All top-level views should have a reload button

* First launch: load calendar, then visible row images + library & trending feeds
* Not first launch, i.e. the app was inactive, or the user hits the 'reload' button: reload _all_ feeds, but load the current visible one first.
* Make HTTPDownload post start/stop notifications so that the refresh/stop buttons in the top-level controllers can show them accurately.

* Use ‘today’ and ‘tomorrow’ in the calendar view? That might make the index weird, tho, plus due to timezone difference it may not always be correct.

* Shows that the user has in her library should *not* show up in 'trending' (Are we sure about this?)

* The seasons/episodes table view
**  with episode entries like: `[√] Episode title >`
**  The checkbox should be like the one in Things.

* The eipsode details view should have a disclosure entry to the show's episodes list
* The 'seen' entry in the episode details view should have the same checkbox as in the episodes list. (The one from Things)

* Shows and show episodes list views should show a quick alphabetic navigation thingie when it makes sense. See the HIG.

