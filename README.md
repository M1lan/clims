# ims
An inventory managment system built with various things.

# Links
Server side
---
* [Clack](http://clacklisp.org/) - A minimal (flask/bottle from python) like web framework. Finalized barring some grave error discovered in developemnt. Since we are just making a json api type thing, this should be sufficient. Has some very useful included middlwares we can use or base ours off of (things like auth, logging, sessions).
* [Postmodern postgresql interface](http://clacklisp.org/) - Rad stuff.
* [A possible json lib](https://github.com/madnificent/jsown) - Has some nicer object conversion/access properties than the below json lib.
* [Another json lib](https://github.com/hankhero/cl-json) - Used at offersavvy.
* [CL encryption lib](http://method-combination.net/lisp/ironclad/) - Used at offersavvy.

Front end
---
* [Javascript graph/chart libs](http://www.jsgraphs.com/) - A site that shows various options of charting/graphing libs in javascript.
* [Javascript utility lib](http://mootools.net/) - Similar to Jquery but slimmed down. Simple AJAX api, dom interaction, etc.
* [Light CSS lib](http://getskeleton.com/)
* [Fonts and icons](http://fortawesome.github.io/Font-Awesome/)

Database
---
* [Postgresql](http://www.postgresql.org/) - The good ol' PG

Deployment
---
* [Nginx](http://nginx.org/en/) - Something we should both be familiar with since it will play a role in security.
* [Redis](http://redis.io/) - Key-value store that is commonly used for session management.
* [Memcached](http://memcached.org/) - Something similar to the above. I don't know detailed differences. 

Security
---
* [On http cookies and security](http://crypto.stanford.edu/cs142/papers/web-session-management.pdf) - some notes on cookie attributes and related security.
