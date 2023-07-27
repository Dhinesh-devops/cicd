# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "https://ga.jspm.io/npm:@hotwired/turbo-rails@7.3.0/app/javascript/turbo/index.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "jquery3", to: "jquery3.min.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "turbo_power", to: "https://ga.jspm.io/npm:turbo_power@0.3.1/dist/turbo_power.js"
pin "@hotwired/turbo", to: "https://ga.jspm.io/npm:@hotwired/turbo@7.3.0/dist/turbo.es2017-esm.js"
pin "@rails/actioncable/src", to: "https://ga.jspm.io/npm:@rails/actioncable@7.0.5/src/index.js"
pin "jquery.validate", to: "jquery.validate.min.js", preload: true
pin "jquery.dataTables", to: "jquery.dataTables.min.js", preload: true
pin "toastr", to: "toastr.min.js", preload: true
pin "chart", to: "chart.min.js", preload: true
pin "bootstrap-datepicker", to: "bootstrap-datepicker.min.js", preload: true