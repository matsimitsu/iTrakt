iTrakt, an iPhone client for trakt.tv
=====================================

The app shows you your [tv-show calendar][cal], allows you to browse your
[tv-show library][lib], and [recommendations][rec] based on your library.

It allows you to keep your library up-to-date by marking episodes as 'seen'.


Install
-------

Fetch the source and its dependencies:

    $ git clone --recursive git://github.com/matsimitsu/iTrakt.git

Tell the app what your API key is by copying the sample and upating it with
your [key][key]:

    $ cp Authentication.h.sample Authentication.h


Run specs
---------

Enable the `Accessibility Inspector` in the `iOS simulator` Settings app:

    General -> Accessibility -> Accessibility Inspector

Install `ios-sim` if you don't already have it:

    $ brew install ios-sim

Start the fixture server:

    $ rake serve_fixtures

And finally run the specs:

    $ rake spec


[cal]: http://trakt.tv/calendar/my-shows
[lib]: http://trakt.tv/user/USERNAME/library/shows/all
[rec]: http://trakt.tv/recommendations/shows
[key]: http://trakt.tv/settings/api
