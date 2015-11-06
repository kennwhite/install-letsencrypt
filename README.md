## LetsEncrypt Client Installers

### A Suite of simple install scripts for the LetsEncrypt official client on every major *nix OS (Debian, AWS, CentOS/RedHat, FreeBSD) 

This is a minimal, repeatable set of scripts to stand up the official [Let's Encrypt](https://letsencrypt.org/)
certificate managment client tool. Let's Encrypt is a really important project, and the team has made
*amazing* progress in the past year.

The letsencrypt ("LE") client is written in Python, and though it attempts to automatically
detect your operating system and build environment, it can be fragile and error-prone on
some systems, particuarly popular distros like Amazon Linux and older versions of CentOS
or RedHat.

### Abbreviated advice from the front line

*  For people who are not in the Beta program, the scripts by default will target the LE "staging" API endpoint, and on successful generation of certs, the CA will be a test authority ("Happy Hacker CA"). To enable trusted certificates, Beta testers can modify the scripts as indicated in each, but *only* against white-listed domains (and `example.com` doesn't whitelist `blog.example.com` by default).
*  Do __not__ run either these scripts or the client on production systems (yet). LE is still in beta and has some rough edges, including silently invoking sudo and installing quite a few development packages. __Please__ study the script for your platform. These were written quickly to help other people hopefully avoid some of the stumbling blocks I hit, and to expand the pool of testing volunteers.
*  The Apache and Nginx plugins to autoupdate are very much still works-in-progress. I encourage anyone to help improve them by testing & documenting your results. Constructive feedback is welcome!
*  Because Nginx in particular is still classified as highly experimental, I recommend spinning up a test VM (micro instances on GCE or AWS work great), and using the LE client as a certificate fetcher, pushing certs and keys to target servers via ssh.
*  Be patient during the build, because there may be long pauses that are preceded by unrelated warning messages.

As indicated in each script, if you get stuck, it's perfectly ok to tear down, rebuild, and try again, just make sure to run the following clean up to remove python and build fragments:

    cd ~/ && rm -rf ./letsencrypt && rm -rf ~/.local/share/letsencrypt && rm -rf /etc/letsencrypt && rm -rf ~/.cache/pip

	
### If you're just completely stuck and ready to give up

There are three non-official alternative LE clients, and they work pretty well: 

https://github.com/unixcharles/acme-client (a Ruby gem)   
https://github.com/xenolf/lego (a single cross-platform Go program)   
https://github.com/diafygi/letsencrypt-nosudo (as the name suggests, a non-sudo alternative—a single python script)   

I tried each, and was able to generate certs quite easily with both Lego and LE-nosudo. Might be worth checking out.

