cb_dir  = ::File.dirname(__FILE__)
cb_name = ::File.basename(cb_dir)

task :clean do |t|
  ::Dir.chdir(cb_dir)

  ::File.unlink('metadata.json') if ::File.exists?('metadata.json')

  ::Dir.glob('*.lock').each do |f|
    ::File.unlink(f)
  end
end

task :distclean => [:clean] do |t|
  ::Dir.chdir(cb_dir)

  file = ::File.join('..', "#{cb_name}.tar")
  ::File.unlink(file) if ::File.exists? file
end

task :knife_test do |t|
  sh "bundle exec knife cookbook test #{cb_name}"
end

task :fc => [:foodcritic]
task :foodcritic do |t|
  sh "bundle exec foodcritic  #{cb_dir}"
end

task :rc => [:rubocop]
task :rubocop do |t|
  sh "bundle exec rubocop  #{cb_dir}"
end

task :chefspec do |t|
  ::Dir.chdir(cb_dir)
  sh 'bundle exec rspec --color --format documentation'
end

task :test do |t|
  if ::File.exists?(::File.join(cb_dir, 'Strainerfile'))
    sh 'bundle exec strainer test' if ::File.exists?(::File.join(cb_dir, 'Strainerfile'))
  else
    Rake::Task[:knife_test].execute
    Rake::Task[:foodcritic].execute
    Rake::Task[:rubocop].execute
    Rake::Task[:chefspec].execute
  end
end

task :release, [:type] => [:clean, :test] do |t, args|
  type = args.type

  if type.nil? || type.strip.empty?
    print "\nEnter release type (major|minor|patch (default)|manual): "
    type = STDIN.gets.chomp
  end

  type = 'patch' if type.nil? || type.strip.empty?

  if type.start_with? 'manual'
    ary = type.split(/\s+/)

    if ary.size != 2
      print 'ERROR: manual release type requires a version (ex. manual 1.2.3)\n'
      exit 1
    elsif !ary[1].strip.match(/^\d+\.\d+\.\d+$/)
      print 'ERROR: version format must be in the form of x.y.z\n'
      exit 1
    end
  elsif type.strip.match(/^\d+\.\d+\.\d+$/)
    type = "manual #{type}"
  else
    unless type.start_with?('major') || type.start_with?('minor') || type.start_with?('patch')
      print "ERROR: invalid release type of #{type} given\n"
      exit 1
    end
  end

  sh 'bundle exec berks install'
  sh "bundle exec knife spork bump #{cb_name} #{type}"
end

task :bundle => [:release] do |t|
  sh "bundle exec knife cookbook metadata #{cb_name}"

  ::Dir.chdir(::File.join(cb_dir, '..'))
  sh "tar --exclude-backups --exclude-vcs -cvf #{cb_name}.tar #{cb_name}"
end
