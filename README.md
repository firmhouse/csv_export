# csv_export

CsvExport is a simple opinionated class for easily making CSV exports in Rails apps.
You can easily render CSV exports from model collections or add rows via raw data insertion.

It uses `;` as columns separator.

## Usage

Every export you create with `CsvExport` must have headings that you set
on initialization. Depending on the type of render method you use, it will
require the headings to be present on the objects you pass in or not.

For example:

```
customers = Customer.all
export = CsvExport.new :id, :name
export.render_collection(customers)
```

## Samples

### Providing a CSV export of an ActiveRecord collection

```
class CustomersController < ApplicationController

  def index
    @customers = Customer.all

    respond_to do |format|
      format.html
      format.csv do
        export = CsvExport.new :id, :name
        send_data export.render_collection(@customers), type: "text/csv"
      end
    end

end
```

This assumes that the records in the collection `@customers` have columns or
virtual attributes `id` and `name` available. If a given heading is not available
`CsvExport` will raise a `CsvExport::Error`.

This would return a file with contents:

```
Id;Name
1;Michiel
2;John
```

### Export some raw data

```
csv_export = CsvExport.new :something_neat, :something_cool
csv_export << %w(neat_thing cool_thing)
csv_export << %w(something_nice something_awesome)
csv_export.render
```

This will render a raw CsvExport with given headings and passed in data.

This would render a string like:

```
Something Neat;Something Cool
neat_thing;cool_thing
something_nice;something_awesome
```
