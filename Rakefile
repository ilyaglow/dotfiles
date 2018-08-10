#
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
#
ENV['HOMEBREW_CASK_OPTS'] = "--appdir=/Applications"

def brew_install(package, *args)
  versions = `brew list #{package} --versions`
  options = args.last.is_a?(Hash) ? args.pop : {}

  # if brew exits with error we install tmux
  if versions.empty?
    sh "brew install #{package} #{args.join ' '}"
  elsif options[:requires]
    # brew did not error out, verify tmux is greater than 1.8
    # e.g. brew_tmux_query = 'tmux 1.9a'
    installed_version = versions.split(/\n/).first.split(' ').last
    unless version_match?(options[:requires], installed_version)
      sh "brew upgrade #{package} #{args.join ' '}"
    end
  end
end

def app_path(name)
  path = "/Applications/#{name}.app"
  ["~#{path}", path].each do |full_path|
    return full_path if File.directory?(full_path)
  end

  return nil
end

def app?(name)
  return !app_path(name).nil?
end

def step(description)
  description = "-- #{description} "
  description = description.ljust(80, '-')
  puts
  puts "\e[32m#{description}\e[0m"
end

def get_backup_path(path)
  number = 1
  backup_path = "#{path}.bak"
  loop do
    if number > 1
      backup_path = "#{backup_path}#{number}"
    end
    if File.exists?(backup_path) || File.symlink?(backup_path)
      number += 1
      next
    end
    break
  end
  backup_path
end

def link_file(original_filename, symlink_filename)
  original_path = File.expand_path(original_filename)
  symlink_path = File.expand_path(symlink_filename)
  symlink_dir = File.dirname(symlink_path)

  unless File.directory?(symlink_dir)
    mkdir_p symlink_dir
  end

  if File.exists?(symlink_path) || File.symlink?(symlink_path)
    if File.symlink?(symlink_path)
      symlink_points_to_path = File.readlink(symlink_path)
      return if symlink_points_to_path == original_path
      # Symlinks can't just be moved like regular files. Recreate old one, and
      # remove it.
      ln_s symlink_points_to_path, get_backup_path(symlink_path), :verbose => true
      rm symlink_path
    else
      # Never move user's files without creating backups first
      mv symlink_path, get_backup_path(symlink_path), :verbose => true
    end
  end
  ln_s original_path, symlink_path, :verbose => true
end

def unlink_file(original_filename, symlink_filename)
  original_path = File.expand_path(original_filename)
  symlink_path = File.expand_path(symlink_filename)

  if File.symlink?(symlink_path)
    symlink_points_to_path = File.readlink(symlink_path)

    if symlink_points_to_path == original_path
      # the symlink is installed, so we should uninstall it
      rm_f symlink_path, :verbose => true
      backups = Dir["#{symlink_path}*.bak"]

      case backups.size
      when 0
        # nothing to do
      when 1
        mv backups.first, symlink_path, :verbose => true
      else
        $stderr.puts "found #{backups.size} backups for #{symlink_path}, please restore the one you want."
      end

    else
      $stderr.puts "#{symlink_path} does not point to #{original_path}, skipping."
    end

  else
    $stderr.puts "#{symlink_path} is not a symlink, skipping."
  end
end

def get_distributor
  begin
    lsb_release=`lsb_release -i`
  rescue Errno::ENOENT
    print "Non lsb_release compatible system"
    lsb_release=nil
  end

  uname=`uname`

  if lsb_release == nil
    case uname
       when /Darwin/
          :mac
    end
  else
    case lsb_release
      when /Arch/
        :arch
      when /Debian|Kali/
        :deb
      when /Ubuntu/
        :ubuntu
      when /CentOS|RedHat/
        :rpm
    end
  end

end

def repo_update(distrib)
  case distrib
  when :deb, :ubuntu
    sh 'sudo apt-get update'
  when :arch
    sh 'sudo pacman -Syu --noconfirm'
  when :rpm
    sh 'sudo yum update'
  when :mac
  end
end

def install_package(distrib, package)
  prefix = case distrib
           when :deb, :ubuntu
             'sudo apt-get install -y'
           when :arch
             'sudo pacman -S --noconfirm'
           when :rpm
             'sudo yum install -y'
           when :mac
             'brew install'
           end

  package = 
    case package

    when 'vim'
      case distrib
      when :deb, :ubuntu
        'vim-gtk'
      when :arch
        'gvim'
      when :rpm
        'vim-X11'
      when :mac
        'vim && brew install macvim'
      else
        'gvim'
      end 

    when 'ctags'
      case distrib
      when :deb, :ubuntu
        'exuberant-ctags'
      else
        'ctags'
      end

    else
      package
    end

  command = "#{prefix} #{package}"
  sh command
end

def install_neovim(distrib)
  command = case distrib
    when :deb
      # https://github.com/neovim/neovim/wiki/Installing-Neovim
      install_package(distrib, 'python-dev python-pip python3-dev python3-pip')

      'sudo apt-get install -y neovim'
      sh 'pip install neovim --user'
      sh 'pip3 install neovim --user'
    when :ubuntu
      install_package(distrib, 'python-dev python-pip python3-dev python3-pip')
      'sudo apt-get install -y software-properties-common \
        && sudo add-apt-repository -y ppa:neovim-ppa/stable \
        && sudo apt-get update \
        && sudo apt-get install -y neovim'
      sh 'pip install neovim --user'
      sh 'pip3 install neovim --user'
    when :arch
      'sudo pacman -S --noconfirm neovim'
      sh 'pip install neovim --user'
      sh 'pip3 install neovim --user'
    when :rpm
      install_package(distrib, 'python-dev python-pip python3-dev python3-pip')
      'sudo yum -y install epel-release \
        && sudo curl -o /etc/yum.repos.d/dperson-neovim-epel-7.repo https://copr.fedorainfracloud.org/coprs/dperson/neovim/repo/epel-7/dperson-neovim-epel-7.repo \
        && yum -y install neovim'
      sh 'pip install neovim --user'
      sh 'pip3 install neovim --user'
    when :mac
      'brew install neovim'
  end

  sh command
end

namespace :install do
  distrib = get_distributor

  desc 'Repository Update'
  task :update do
    step 'repos update'
    repo_update(distrib)
  end

  desc 'Install curl'
  task :curl do
    step 'curl'
    install_package(distrib, 'curl')
  end

  desc 'Install git'
  task :git do
    step 'git'
    install_package(distrib, 'git')
  end

  desc 'Install vim'
  task :vim do
    step 'vim'
    install_package(distrib, 'vim')
  end

  desc 'Install neovim'
  task :neovim do
    step 'neovim'
    install_neovim(distrib)
  end

  desc 'Install tmux'
  task :tmux do
    step 'tmux'
    install_package(distrib, 'tmux')
  end

  desc 'Install xclip'
  task :xclip do
    step 'xclip'
    install_package(distrib, 'xclip')
  end

  desc 'Install ctags'
  task :ctags do
    step 'ctags'
    install_package(distrib, 'ctags')
  end

  desc 'Install Plug'
  task :plug do
    step 'plug'
    sh 'vim -c "PlugInstall" -c "q" -c "q"'
    sh 'nvim -c "PlugInstall" -c "q" -c "q"'
  end

  desc 'Install fzf'
  task :fzf do
    step 'fzf'
    install_package(distrib, 'fzf')
  end

end

def filemap(map)
  map.inject({}) do |result, (key, value)|
    result[File.expand_path(key)] = File.expand_path(value)
    result
  end.freeze
end

LINKED_FILES = filemap(
  'vim'           => '~/.vim',
  'tmux.conf'     => '~/.tmux.conf',
  'vimrc'         => '~/.vimrc',
  'vimrc.plugs'   => '~/.vimrc.plugs',
  'nvimrc'        => '~/.config/nvim/init.vim',
  'nvimrc.plugs'  => '~/.nvimrc.plugs'
)

distrib = get_distributor

desc 'Install these config files.'
task :install do
  if distrib != :mac
    Rake::Task['install:update'].invoke
    Rake::Task['install:curl'].invoke
    Rake::Task['install:xclip'].invoke
  end

  Rake::Task['install:vim'].invoke
  Rake::Task['install:git'].invoke
  Rake::Task['install:neovim'].invoke
  Rake::Task['install:tmux'].invoke
  Rake::Task['install:ctags'].invoke
  Rake::Task['install:gpg'].invoke

  step 'symlink'

  LINKED_FILES.each do |orig, link|
    link_file orig, link
  end

  # Install Plug and plugs
  Rake::Task['install:plug'].invoke

end

desc 'Uninstall these config files.'
task :uninstall do
  step 'un-symlink'

  # un-symlink files that still point to the installed locations
  LINKED_FILES.each do |orig, link|
    unlink_file orig, link
  end
end

task :default => :install
