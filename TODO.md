General
-------

* Research which OSS license the app should have and that we adhere to the licenses of APIs.
  TVDB: http://forums.thetvdb.com/viewtopic.php?f=8&t=2507

* Load images for rows visible after using the index to quickly navigate to a section.
* Add Calendar class which returns episodes grouped by broadcast date.
* The Calendar class should take a show title filter string which makes the Calendar return only those dates and episodes that match.
* Add a Show property to a Episode, which holds the show related data that we now store on the episode itself.
* Set the preferred show poster thumb size from the calendar controller.
* Handle connection errors in some way which is needed to provide a good UX. I.e. should we retry, take a failure block, etc.

Authentication
--------------

* Settings screen to enter username
* Way to check if username exists
* Add user credentials as basic-auth headers to _all_ requests to itrakt.matsimitsu.com.
  Ideally to trakt.tv as well, but this has to be discussed with them first, so for now wait with calls like 'seen' POSTs. - Requested - Implemented

Caching
-------

* Cache show posters and thumbs indefinitely.

API
---
* Search through all shows

Design discussion
-----------------

* The Library list should be searchable. Does it make sense for the trending list? Maybe not, as you're browsing for new shows.
* All top-level views should have a reload button

* First launch: load calendar, then visible row images + library & trending feeds
* Not first launch, i.e. the app was inactive, or the user hits the 'reload' button: reload _all_ feeds, but load the current visible one first.

* Use ‘today’ and ‘tomorrow’ in the calendar view? That might make the index weird, tho, plus due to timezone difference it may not always be correct.

* Shows that the user has in her library should *not* show up in 'trending' (Are we sure about this?)

* The seasons/episodes table view
**  with episode entries like: `[√] Episode title >`
**  The checkbox should be like the one in Things.

* The eipsode details view should have a disclosure entry to the show's episodes list
* The 'seen' entry in the episode details view should have the same checkbox as in the episodes list. (The one from Things)

* Shows and show episodes list views should show a quick alphabetic navigation thingie when it makes sense. See the HIG.

