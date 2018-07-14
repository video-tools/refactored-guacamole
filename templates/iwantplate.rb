require "erb"
require "optparse"
require "ostruct"
require "yaml"


variants = ["alpine", "debian", "centos", "ubuntu"]
dependencies = "config.yml"

cwd=File.dirname(__FILE__)
global_config = YAML.load_file(File.join(cwd, dependencies))

project = global_config["project"]
project_versions = project.keys

deps = global_config["libraries"]
options = OpenStruct.new
options.variant = variants[0]
options.project_version = project_versions[0]
options.minimal = false
options.list_versions = false
options.list_variants = false
options.quiet = false
options.show = false
OptionParser.new do |opt|
    opt.on("-q",
           "--quiet",
           "Only display values") do |o|
        options[:quiet] = true
    end
    opt.on("-V",
           "--variant VARIANT",
           "Set the base docker image (#{variants.join('|')}) (default: \"#{options.variant}\")") do |o|
               options[:variant] = o if variants.include? o
           end
    opt.on("-v", 
           "--project VERSION",
           "Set the project version (default: \"#{options.project_version}\")") do |o|
               options[:project_version] = o
           end
    opt.on("-l",
           "--list-versions",
          "List the currently supported version") do |o|
               options[:list_versions] = o
           end
    opt.on("-L",
           "--list-variants",
          "List the currently supported variants") do |o|
               options[:list_variants] = o
           end
    opt.on("-s",
           "--show",
           "Show the libraries and versions used") do |o|
                options[:show] = o
           end
	deps.each do |libname, config| 
		options[libname] = true
		opt.on("--[no-]#{libname}",
			   "Disable #{libname} (default: enabled)") do |o|
			options[libname] = o
		end
		opt.on("--#{libname}-version LIBVERSION", 
			   "Version to use for #{libname} (default: \"#{config["versions"].keys[0]}\")") do |o|
			if ! config["versions"].keys.include? o
				raise "No #{o} version found for #{libname}" 
			else
				options["#{libname}_version"] = o
			end
		end
	end
end.parse!

#semver = /[^0-9]*([0-9]*)[.]([0-9]*)[.]?([0-9]*)([0-9A-Za-z-]*)/.match(options.project_version.to_s)
#if options.project_version != 'snapshot' and semver[3] == '' then
#    idx = project_versions.index { |v| v.start_with? options.project_version.to_s }
#    if idx.nil? then
#        STDERR.puts "No suitable version found for %s" % options.project_version
#        exit (1)
#    end
#    options.project_version = project_versions[idx]
#end
project_semver = options.project_version

if ! options.variant.include? ":"
    options.variant += ':' + global_config['project'][options.project_version][options.variant]
end

options.to_h.each do | libname, value |
    unless deps[libname.to_s].nil? then 
        if options["#{libname}_version"] == nil 
            deps[libname.to_s]['versions'].each do |version, reqs|
                if reqs.nil? or (reqs["project"].nil? and reqs["blacklist"].nil?) then
                    options["#{libname}_version"] = version
                    break
                elsif !reqs["blacklist"].nil? and reqs["blacklist"].include? options.variant then
                    next
                elsif !reqs["project"].nil? and reqs["project"].include? project_semver then
                    options["#{libname}_version"] = version
                    break
                end
            end
        end
        if ! deps[libname.to_s]["versions"][options["#{libname}_version"]].nil? then
            deps[libname.to_s]["versions"][options["#{libname}_version"]].each do | param, val |
                if param =~ /sum/
                    options["#{libname}_#{param}"] = val 
                end
            end
        end
        if !options["#{libname}_version"]
            options[libname.to_s] = false
        end
    end
end

if options.list_versions
    project_versions.each do |version|
        puts version + ((!options.quiet and (version == options.project_version)) ? " *" : "")
    end
    exit(0)
end

if options.list_variants
    variants.each do |variant|
        puts variant + ((!options.quiet and (options.variant.start_with? variant)) ? " *" : "")
    end

    exit(0)
end

if options.show
    puts "project %{version} on %{variant}" % {:version=>options.project_version, :variant=>options.variant}
	deps.each do |libname, config|
        puts " - %s: %s" % [libname, options["#{libname}_version"]]
    end
    exit(0)
end

dockerfile_template = File.new(File.join(cwd, "Dockerfile.erb")).read()
renderer = ERB.new(dockerfile_template)
puts output = renderer.result()

