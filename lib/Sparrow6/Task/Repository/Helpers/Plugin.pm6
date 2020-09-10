unit module Sparrow6::Task::Repository::Helpers::Plugin;

use JSON::Tiny;

use File::Directory::Tree;

role Role {

  method install-plugin-deps ($plg-src) {

      self!log("install deps for $plg-src",$plg-src);

      my $pip-command = 'pip3';

      if "$plg-src/cpanfile".IO ~~ :e && ! %*ENV<SP6_CARTON_OFF> {
        shell("bash -c 'cd $plg-src && carton install'");
      }

      if "$plg-src/Gemfile".IO ~~ :e {
        shell("bash -c 'cd $plg-src && bundle --path local'");
      }

      if "$plg-src/requirements.txt".IO ~~ :e {

        my %plg-meta = self!read-plugin-meta($plg-src);

        shell("bash -c 'cd $plg-src && $pip-command install -t ./python-lib -r requirements.txt'");

      }

      if "$plg-src/rakufile".IO ~~ :e {
        mkdir "{$plg-src}/raku-lib";
        for "{$plg-src}/rakufile".IO.lines -> $line {
          next if $line ~~ /^^ \s* '#' /;
          next unless $line ~~ /\S/;
          my @params = $line.split(/\s+/);
          my $module = @params.shift;
          my $zef-options = "--to=$plg-src/raku-lib";
          $zef-options ~=  " {@params}" if @params;
          self.console("install $module to $plg-src");
          shell("bash -c 'zef install $module $zef-options'");
        }
      }

  }

  method !read-plugin-meta ($plg-src) {
    from-json("$plg-src/sparrow.json".IO.slurp);
  }


  method plugin-man ( $pid ) {

    die "unknown plugin $pid" unless self.plugin-directory($pid).IO ~~ :d;

    if "{self.plugin-directory($pid)}/README.md".IO ~~ :f {
      say slurp("{self.plugin-directory($pid)}/README.md");
    } else {
      say "no manual found"
    }

  }

  method plugin-install ( $pid, %args? ) {

    my $ptype;

    my %list = self!read-plugin-list();

    if %list{$pid}:exists {

    # try to update existing plugin

    if %args<force> {
      self.console("force is set, remove plugin from {self.plugin-directory($pid)}");
      self.plugin-remove($pid) 
    }

    if "{self.plugin-directory($pid)}/sparrow.json".IO ~~ :e {

      my %plg-meta = self!read-plugin-meta("{self.plugin-directory($pid)}/");

      my $plg-v  = %list{$pid}<version>;

      my $plg-canonical-v = self!canonical-version($plg-v);

      my $inst-v = Version.new(%plg-meta<version>);

      if ($plg-canonical-v > $inst-v) {

        self.console("upgrading $pid from version $inst-v to version $plg-canonical-v");

        self!load-unpack-and-install($pid,"{$pid}-v{$plg-v}.tar.gz");

      } else {

          self.console("$pid is uptodate. version $inst-v") if %args<verbose>;

          # reinstall dependencies for already installed plugin
          # if options --force-install-deps passed

          if %args<force-install-deps> {
            self.console("force-install-deps is set, reinstalling plugin dependencies");
            self.install-plugin-deps("{self.plugin-directory($pid)}");
          }

      }

     # first installation of a plugin

     } else {

        my $v = %args<version> ||  %list{$pid}<version>;

        self.console("installing $pid, version $v");

        self!load-unpack-and-install($pid,"{$pid}-v{$v}.tar.gz");

      }

    # locally installed plugin

    } elsif "{self.plugin-directory($pid)}/".IO ~~ :d  {

      self.console("plugin {self.plugin-directory($pid)} installed locally, nothing to do here");

    } else {

      die "unknown plugin $pid";

    }

  }

  method !read-plugin-list ($index-file?) {

    my %list;

    my $file = $index-file || self!index-file;

    if $file.IO ~~ :e {

      for $file.IO.lines -> $i {
  
        next unless $i ~~ /\S+/;
  
        my @foo = split(/\s+/, $i);
  
        %list{@foo[0]} = %( name => @foo[0], version => @foo[1], canonical-version => self!canonical-version(@foo[1]) );
  
      }

      self!log("read index file", $file);

    } else {

      self!log("index file does not exist",$file);

    }


    return %list;

  }

  method distro-download ($distro) {

    run "curl", "-s", "-f", "-L", "-k", "-o", "{$.sparrow-root}/plugins/$distro", "{$.url}/plugins/{$distro}";

    self!log("plugin uploaded", $distro);

    return "{$.sparrow-root}/plugins/$distro";

  }

  method !load-unpack-and-install ($pid,$distro) {

    self.plugin-remove($pid);

    # create plugin directory
    mkdir(self.plugin-directory($pid));

    self.get-resource("plugins/$distro", "{self.plugin-directory($pid)}/$distro" );

    if $*DISTRO.is-win  {

       my $dir = $*CWD;
       chdir  "{self.plugin-directory($pid)}";
       run "tar", "-xzf" , $distro;
       chdir $dir;

    } else {

       run "tar", "-xzf" , "{self.plugin-directory($pid)}/$distro", "-C", self.plugin-directory($pid);

    }
    
  
    self!log("unpack {self.plugin-directory($pid)}/$distro to", self.plugin-directory($pid));

    self.install-plugin-deps(self.plugin-directory($pid));

  }

  method !canonical-version ($version) {

      "$version".split(".").map(-> $major, $decimal { Version.new: join ".", $major, |$decimal.comb(3)».Int })[0];

  }

  method !repository-version ($version) {

    my $major = Version.new($version).parts[0];
    my $minor = Version.new($version).parts[1];
    my $patch = Version.new($version).parts[2];
  
    if $minor < 10 {
      $minor = "00$minor";
    } elsif $minor < 100 {
      $minor = "0$minor";
    }

    if $patch < 10 {
      $patch = "00$patch";
    } elsif $patch < 100 {
      $patch = "0$patch";
    }

    return $major ~ '.' ~ $minor ~ $patch;
  
  }

  method plugin-directory ($pid) {

    return "{$.sparrow-root}/plugins/$pid"

  }


  method plugin-upload (%args?) {

      my $dir = $*CWD;

      self!log("plugin upload", $dir);

      my %plg-meta = self!read-plugin-meta($dir);

      my $plg-v  = %plg-meta<version> || die "plugin version not found";

      my $plg-name = %plg-meta<name> or die "plugin name not found";

      $plg-name ~~ /^ <[ a..zA..Z \d \- \. \_ ]> + $/ or die "plugin name parameter does not meet naming requirements - " ~
      '^ <[ a..zA..Z \d \- \. \_ ]> + $'.perl;

      self.console("upload {$plg-name}\@{$plg-v}");

      self!log("sparrow.json validated", "$dir/sparrow.json");

      my $repository-version = self!repository-version($plg-v);

      self!log("plugin version",$plg-v);

      self!log("plugin repository version",$repository-version);

      if %args<force> && self!target-exists("plugins/{$plg-name}-v{$repository-version}.tar.gz") {

        self.console("force is enabled, override current plugin plugins/{$plg-name}-v{$repository-version}.tar.gz");
  
      } elsif self!target-exists("plugins/{$plg-name}-v{$repository-version}.tar.gz") {

        self.console("plugin with this version exists, bump a version an upload again");

        return

      }


      unlink "{$.sparrow-root}/.cache/archive.tar.gz" if "{$.sparrow-root}/.cache/archive.tar.gz".IO ~~ :e;


      if $*DISTRO.is-win  {
         unlink "artifacts/archive.tar.gz" if "artifacts/archive.tar.gz".IO ~~ :f;
         rmdir "artifacts/" if "artifacts".IO ~~ :d;
         mkdir "artifacts/";
      }
	
      my @cmd = $*DISTRO.is-win ?? (
        'tar',
        '-zcf',
        "artifacts/archive.tar.gz", # some Windows distros have tar that does not understand absolute pathes )=:
        "--exclude=./artifacts",
        '.'
      ) !! (
        'tar', 
        '--exclude=.tom', 
        '--exclude=local', 
        '--exclude=*.log',
        '--exclude=log',
        '--exclude=cpanfile.snapshot',
        '--exclude=Gemfile.lock',
        '--exclude=local/',
        '--exclude-vcs',
        '-zcf',
        "{$.sparrow-root}/.cache/archive.tar.gz",
        '.'
      );

      self!log("creating package",@cmd);

      run @cmd;

      if $*DISTRO.is-win  {
        self!put-resource("artifacts/archive.tar.gz","plugins/{$plg-name}-v{$repository-version}.tar.gz");
        unlink "artifacts/archive.tar.gz";
        rmdir "artifacts/";
      } else {
        self!put-resource("{$.sparrow-root}/.cache/archive.tar.gz","plugins/{$plg-name}-v{$repository-version}.tar.gz");
      }	

      self.repository-index-update($plg-name,$repository-version);

  }

  method plugin-remove ($pid) {

    if self.plugin-directory($pid).IO ~~ :d {
      empty-directory(self.plugin-directory($pid));
      self!log("plugin base directory removed",self.plugin-directory($pid))
    }

  }


  method installed-plugins () {

    my %index = self!read-plugin-list();

    my @list;

    for %index.keys.sort({ %index{$^a}<name> cmp %index{$^b}<name> }) -> $pid {

      if "{self.plugin-directory($pid)}/sparrow.json".IO ~~ :e {

        my %plg-meta = self!read-plugin-meta("{self.plugin-directory($pid)}/");

        @list.push(( $pid, %plg-meta<version> , %index{$pid}<canonical-version> ));

      }

    }

    return @list;
  }

  method search-plugins ($search?) {

    my %index = self!read-plugin-list();

    my @list;

    for %index.keys.sort({ %index{$^a}<name> cmp %index{$^b}<name> }) -> $pid {

      if $search {

        next unless  $pid ~~ / $search /;
      }

      if "{self.plugin-directory($pid)}/sparrow.json".IO ~~ :e {

        my %plg-meta = self!read-plugin-meta("{self.plugin-directory($pid)}/");

        @list.push(( $pid, %plg-meta<version>, %index{$pid}<canonical-version> ));

      } else {

        @list.push(( $pid, Nil, %index{$pid}<canonical-version> ));

      }

    }

    return @list;
  }

}
