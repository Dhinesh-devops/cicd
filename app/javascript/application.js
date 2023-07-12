// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "jquery"
import "script"
import "toastr"
global.toastr = require("toastr")
import "jquery_ujs"
import "popper"
import "bootstrap"
import "./modules/off-canvas"
import "./modules/hoverable-collapse"
import "./modules/template"
import "./modules/settings"
import "./modules/todolist"
import "./modules/dashboard"
import "./modules/Chart.roundedBarCharts"
import "./dataTables/jquery.dataTables";

