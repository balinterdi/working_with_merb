namespace :test do
	desc "Loads the spec fixtures and starts merb console"
	task :load_fixtures do
		# this clearly does not work since environment is changed on 'merb -i'
		require File.join(File.dirname('__FILE__'), '/spec/spec_helper')
		system(%(merb -i))
	end
end