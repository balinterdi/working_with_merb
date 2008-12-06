namespace :test do
	desc "Loads the spec fixtures and starts merb console"
	task :load_fixtures do
		# this clearly does not work since environment is changed when 'merb -i' is started
		require File.join(File.dirname('__FILE__'), '/spec/spec_helper')
		system(%(merb -i))
	end
	
	desc "Generates model objects in the database (e.g like populate)"
	task :populate do
		require File.join(File.dirname('__FILE__'), '/spec/spec_populator')
		SpecPopulator.populate!(:users => 10, :recommendations => 40)
  end
end