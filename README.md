# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


BOOKS CONTROLLER > ApplicationController > QUERY ORCHESTRATOR: >> BOOK PRESENTER >> SERIALIZER >> FIELD PICKER >> EMBED PICKER

Query: http://localhost:3000/api/books?embed=author
- Books Controller:
	- books = orchestrate_query(Book.all)
		- calls orchestrate_query (in application controller) and passes in all books
- Application controller:
	- holds orchestrate_query: creates a QueryOrchestrator object
- QUERY ORCHESTRATOR:
	- creates the following object:
		scope: Books.all (all books)
		params:  <ActionController::Parameters {"embed"=>"author", "controller"=>"books", "action"=>"index"} permitted: false>
		request: 
		response:
		actions: <:all = [:paginate, :sort, :filter, :eager_load] >
	- call 'run' method:
		- loops through each action, and determines if its valid (by seeing if its in an array or acceptable methods)
		- if valid, calls each action with: @scope = send(action)
			- send(action) will call each of the private methods that correspond to the action
				- ie, passing '?sort=id&dir=desc' will reverse the order of the books (@scope)
			- @scope is now full or books which are paginated, sorted, filtered, eager_loaded

			
- Books Controller:
	- next, it calls Serlializer, which returns:
		- @actions=[:fields, :embeds],
 		  @data= <all books>
 		  @options={},
 		  @params=<ActionController::Parameters {"embed"=>"author", "controller"=>"books", "action"=>"index"} permitted: false>>
 	- lastly, controller calls 'render json: serializer.to_json'
 		- 'to_json' calls the 'build_data' method:
 			- { data: build_data }.to_json
- Serializer: build_data
	- critical line: 'presenter(entity).new(entity, @params).build(@actions)'
		- creates a 'BookPresenter' object, which inherits the 'build' method from 'BasePresenter'
		- @actions = [:fields, :embeds]
		- @params: <ActionController::Parameters {"embed"=>"author", "controller"=>"books", "action"=>"index"} permitted: false>
- BasePresenter
	- 'build' method:
		- uses the 'send' method to call actions: 'actions.each { |action| send(action)  }'
		- in this case, the 'fields' and 'embeds' symbols call the FieldPicker.pick & Embeds.embed methods
- FieldPicker
	- 'pick' calls 'build_fields'
	- 'build_fields':
		- @presenter: instance of BookPresenter
	- where do 'fields' come from?
		- in short, the 'build_fields' method calls the 'field' method
		- 'field' calls 'pickable'
		- 'pickable' runs '@presenter.class.build_attributes', which gets the attributes from the BookPresenter, which further inherits from the BasePresenter
		
- Embeds
 


