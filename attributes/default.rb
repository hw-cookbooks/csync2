default[:csync2][:source][:version] = 'csync2-1.34'
default[:csync2][:source][:downloads] = {
  'csync2-1.34.tar.gz' => 'http://oss.linbit.com/csync2/csync2-1.34.tar.gz',
  'librsync-0.9.7.tar.gz' => 'http://autobuild.itoc.com.au/csync2/librsync-0.9.7.tar.gz',
  'sqlite-2.8.17.tar.gz' => 'http://autobuild.itoc.com.au/csync2/sqlite-2.8.17.tar.gz',
}

default[:csync2][:build_packages][:rhel] = [
  'gcc',
  'gcc-c++',
  'make',
  'automake',
  'autoconf',
  'libtool',
  'byacc',
  'flex',
  'openssl-devel',
  'openssl-static',
  'rng-tools',
  'xinetd',
]
default[:csync2][:build_packages][:ubuntu] = %w(
  build-essential
  libtool
  byacc
  flex
  openssl
  rng-tools
  xinetd
)

default[:csync2][:src][:configure_opts] = './configure  --prefix=/usr --localstatedir=/var --with-librsync-source=../librsync-0.9.7.tar.gz --with-libsqlite-source=../sqlite-2.8.17.tar.gz --sysconfdir=/etc --disable-gnutls'

default[:csync2][:hosts] = [ 'localhost' ]
default[:csync2][:directories] = [ '/tmp/csync2' ]
