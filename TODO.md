General
-------

* Research which OSS license the app should have and that we adhere to the licenses of APIs.
  TVDB: http://forums.thetvdb.com/viewtopic.php?f=8&t=2507

* When an episode title is TBD, disable the checkbox or remove it.
* Do the digits really have to be at the end of the index in the library view? The data already comes sorted, but has the digits first...
* Move some code from application delegate to a root view controllers superclass.
* Add -[NSArray objectAtIndexPath:] and refactor controllers.
* Check which font style we should use and possibly unify that into a UILabel subclass.
* Probably not really necessary to do things like: [[shows copy] autorelease] in Trakt.m
* Rename -[Episode initWithDictionary:] to initWithEpisodeInfo and same for -[Show initWithDictionary:].
* Episode watched field in the calendar feed is outside of the episode hash.
* Trakt.tv is quite slow with returning the updated ‘seen’ value for an episode in the calendar feed. Or is that the proxy?
* How do we deal with the Trakt API key?
* The download code that is already tested elsewhere, eg ensureThumbIsLoaded, don’t need to be tested in the Trakt specs.
* Refactor top-level controllers again to cleanup the code related to refreshing data as well.
* Add Calendar class which returns episodes grouped by broadcast date.
* The Calendar class should take a show title filter string which makes the Calendar return only those dates and episodes that match.
* Set the preferred show poster thumb size from the calendar controller.
* Handle connection errors in some way which is needed to provide a good UX. I.e. should we retry, take a failure block, etc.

Authentication
--------------

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

* See if we can receive the json in chunks, enrich them and immediately send them out again
* Write specs!


Design discussion
-----------------

* The Library list should be searchable.
* All top-level views should have a reload button

* First launch: load calendar, then visible row images + library & recommendations feeds
* Not first launch, i.e. the app was inactive, or the user hits the ‘reload’ button: reload _all_ feeds, but load the current visible one first.
* Make HTTPDownload post start/stop notifications so that the refresh/stop buttons in the top-level controllers can show them accurately.

* Use ‘today’ and ‘tomorrow’ in the calendar view? That might make the index weird, tho, plus due to timezone difference it may not always be correct.

* Shows and show episodes list views should show a quick alphabetic navigation thingie when it makes sense. See the HIG.

Design discussion V2
--------------------

* Echofon style network failure notification
* Recommendations => Recommended
* No index on calendar and only in library when over 50 shows
* On all view ontrollers that show a search field, scroll the tableview a bit down so the serarch field isn’t visible by default.
* Library tab when not signed in should give a description of what one could do there when one has a Trakt account. (show one of these handrwitten text with arrow to the sign in button)
* The description of show/episode should be helvetica, bit smaller.
* Episodes should be sorted most-recent-on-top
* Description text in recommended list shoudl span two rows by removing the ‘x watchers’ row.

Auth
----

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


Library
-------

* Index should always show the full alphabet with digits at the end (#) as in the ipod artists list.


Later
-----

* Use streaming parsing for json so large shows like COPS show stuff asap.
