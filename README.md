## LetsEncrypt Client Installers

A suite of simple install scripts for the LetsEncrypt official certificate client on most major *nix OS (Debian, AWS, CentOS, RedHat, Ubuntu, and FreeBSD) 

This is a minimal, repeatable set of scripts to stand up the official [Let's Encrypt](https://letsencrypt.org/)
certificate management [ACME client tool](https://github.com/letsencrypt/letsencrypt). Let's Encrypt is a really important
project, and the team has made *amazing* progress in the past year.

The letsencrypt ("LE") client is written in Python, and though it attempts to automatically
detect your operating system and build environment, it can be fragile and error-prone on
some systems, particularly popular distros like Amazon Linux and older versions of CentOS
or RedHat.

This started because of so many false starts for me when trying to use the beta client. I was eventually able to reliably request and receive certificates on Debian and CentOS on GCE and AWS, and achieve an A+ rating with
[SSLLabs' test suite](https://www.ssllabs.com/ssltest/index.html). Woot!
These scripts are a cleanup and drastic simplification of that work (many dozens of VMs later). My message is: _you too_ can painlessly [generate certs](https://community.letsencrypt.org/t/beta-program-announcements/1631) for your systems.


### Abbreviated advice from the front line

*  For people who are not in the Beta program, the scripts by default will target the LE "staging" API endpoint, and on successful generation of certs, the CA will be a test authority ("Happy Hacker CA"). To enable trusted certificates, Beta testers can modify the scripts as indicated in each, but *only* against white-listed domains (and `example.com` doesn't whitelist `blog.example.com` by default).
*  Do __not__ run either these scripts or the client on production systems (yet). LE is still in beta and has some rough edges, including silently invoking sudo and installing [quite a few](#dependencies) development packages. __Please__ study the script for your platform. These were written quickly to help other people hopefully avoid some of the stumbling blocks I hit, and to expand the pool of testing volunteers.
*  The Apache and Nginx plugins to autoupdate are very much still works-in-progress. I encourage anyone to help improve them by testing & documenting your results. Constructive feedback is welcome!
*  Because the Nginx LE plugin in particular is still classified as highly experimental, I recommend spinning up a test VM (micro instances on GCE or AWS work great), and using the LE client as a certificate fetcher, pushing certs and keys to target servers via ssh.
*  Be patient during the build, because there may be long pauses (multi-minute on micro VMs) that are preceded by unrelated warning messages. If you're running on a platform that ships with Python v 2.6 (wheezy, Cent6, Amazon Linux), be aware that there are some [core limits](#urllib3) on the underlying library around TLS, but workarounds are in place during the "bootstrap" process of standing up the client, and additional 2.6 support is being added by the LE team.


As indicated in each script, if you get stuck, it's perfectly ok to tear down, rebuild, and try again, just make sure to run the following clean up to remove python and build fragments:

    cd ~/ && rm -rf ./letsencrypt && rm -rf ~/.local/share/letsencrypt && rm -rf /etc/letsencrypt && rm -rf ~/.cache/pip

	
### If you're just completely stuck and ready to give up

There are three non-official alternative LE clients, and they work pretty well: 

https://github.com/unixcharles/acme-client (a Ruby gem)   
https://github.com/xenolf/lego (a single cross-platform Go program)   
https://github.com/diafygi/letsencrypt-nosudo (as the name suggests, a non-sudo alternative—a single python script)   

I tried each, and was able to generate certs quite easily with both Lego and LE-nosudo. Might be worth checking out.


#### Must-read (latest on the beta program):

https://community.letsencrypt.org/t/beta-program-announcements/


#### Recommended Nginx config:

https://community.letsencrypt.org/t/nginx-configuration-sample/2173


#### <a name="dependencies"></a>Dependencies

Here is an inventory of files added to a stock Debian Jessie system by the LE client.
As mentioned earlier, the official python client installs *lots* of packages in the background,
so depending on your use case and tolerance for eventually adding a heavy tools footprint in production,
it may be preferred to run the client as a certificate generator of sorts, and push
certs and keys to a receiving web server or public API endpoint.

Alternatively, you may want to look at the Go-based [lego client](https://github.com/xenolf/lego) mentioned earlier.
It will compile on virtually any platform into a single binary that you can run on other
servers, and the installer dependencies are all self-contained packages.

    # Generated from a before/after: grep install /var/log/dpkg.log
    
    augeas-lenses
    binutils
    cpp
    cpp-4.9
    dh-python
    dialog
    gcc
    gcc-4.9
    git-core
    libasan1
    libatomic1
    libaugeas0
    libc-dev-bin
    libc6-dev
    libcilkrts5
    libcloog-isl4
    libexpat1-dev
    libffi-dev
    libgcc-4.9-dev
    libgomp1
    libisl10
    libitm1
    liblsan0
    libmpc3
    libmpdec2
    libmpfr4
    libpython-dev
    libpython2.7
    libpython2.7-dev
    libpython3-stdlib
    libpython3.4-minimal
    libpython3.4-stdlib
    libquadmath0
    libssl-dev
    libtsan0
    libubsan0
    linux-libc-dev
    python-chardet-whl
    python-colorama-whl
    python-dev
    python-distlib-whl
    python-html5lib-whl
    python-pip-whl
    python-requests-whl
    python-setuptools-whl
    python-six-whl
    python-urllib3-whl
    python-virtualenv
    python2.7-dev
    python3
    python3-minimal
    python3-pkg-resources
    python3-virtualenv
    python3.4
    python3.4-minimal
    virtualenv
    zlib1g-dev


#### <a name="urllib3">SSLContext warning from python urllib3

You may get this warning if you're running on a platform with python 2.6 (Wheezy, Cent6, Amazon Linux):

> InsecurePlatformWarning: A true SSLContext object is not available.
> This prevents urllib3 from configuring SSL appropriately and may cause
> certain SSL connections to fail. For more information, see https://urllib3.readthedocs.org/en/latest/security.html#insecureplatformwarning.

The bootstrap processes attempt to handle multiple libraries through python virtual environments,
but on some OS', the only solution at the moment is to run a parallel library manager that
(attempts) to not step over the core system dependencies for yum and apt.

For this suite of scripts I managed to avoid that in all cases but Debian Wheezy, which required
[pyenv](https://github.com/yyuu/pyenv), which offers a lot of benefits, but brings with
it additional package and environment variable dependencies.

#### Acknowledgements

Big shout out to Kubilay Kocak (@koobs) and Bernard Spil (@Sp1l) on getting LetsEncrypt packaged on FreeBSD, and to Jacob Hoffman-Andrews (@j4cob) from @letsencrypt on his support and suggestions.

#### Contact 

Ping me @kennwhite with questions. Have fun!


