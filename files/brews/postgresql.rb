require 'formula'

class Postgresql < Formula
  homepage 'http://www.postgresql.org/'
  url 'http://ftp.postgresql.org/pub/source/v9.3.1/postgresql-9.3.1.tar.bz2'
  sha256 '8ea4a7a92a6f5a79359b02e683ace335c5eb45dffe7f8a681a9ce82470a8a0b8'
  version '9.3.1-boxen'

  depends_on 'readline'
  depends_on 'ossp-uuid'

  def options
    [
      ['--32-bit', 'Build 32-bit only.'],
      ['--no-python', 'Build without Python support.'],
      ['--no-perl', 'Build without Perl support.'],
      ['--enable-dtrace', 'Build with DTrace support.']
    ]
  end

  # Fix uuid-ossp build issues: http://archives.postgresql.org/pgsql-general/2012-07/msg00654.php
  def patches
    DATA
  end

  skip_clean :all

  fails_with :clang do
    build 211
    cause 'Miscompilation resulting in segfault on queries'
  end

  def install
    ENV.libxml2 if MacOS.snow_leopard?

    args = [
      "--disable-debug",
      "--prefix=#{prefix}",
      "--datadir=#{share}/#{name}",
      "--docdir=#{doc}",
      "--enable-thread-safety",
      "--with-bonjour",
      "--with-gssapi",
      "--with-krb5",
      "--with-openssl",
      "--with-libxml",
      "--with-libxslt",
      "--with-libedit"
    ]

    args << "--with-ossp-uuid" unless ARGV.include? '--no-ossp-uuid'
    args << "--with-python" unless ARGV.include? '--no-python'
    args << "--with-perl" unless ARGV.include? '--no-perl'
    args << "--with-tcl" unless ARGV.include? '--no-tcl'
    args << "--enable-dtrace" if ARGV.include? '--enable-dtrace'

    ENV.append 'CFLAGS', `uuid-config --cflags`.strip
    ENV.append 'LDFLAGS', `uuid-config --ldflags`.strip
    ENV.append 'LIBS', `uuid-config --libs`.strip

    if ARGV.build_32_bit?
      ENV.append 'CFLAGS', '-arch i386'
      ENV.append 'LDFLAGS', '-arch i386'
    end

    # Fails on Core Duo with O4 and O3
    ENV.O2 if Hardware.intel_family == :core

    system "./configure", *args
    system "make install-world"
  end
end

__END__
--- a/contrib/uuid-ossp/uuid-ossp.c 2012-07-30 18:34:53.000000000 -0700
+++ b/contrib/uuid-ossp/uuid-ossp.c 2012-07-30 18:35:03.000000000 -0700
@@ -9,6 +9,8 @@
  *-------------------------------------------------------------------------
  */

+#define _XOPEN_SOURCE
+
 #include "postgres.h"
 #include "fmgr.h"
 #include "utils/builtins.h"
