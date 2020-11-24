const jquery = require('jquery')
const toastr = require('toastr')

require('./course')
require('./filter')
require('turbolinks').start()
require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')
require('@fortawesome/fontawesome-free/js/all')
require('bootstrap/dist/js/bootstrap')
require('jquery')
require('jquery-ui')
require('@nathanvda/cocoon')
require('chosen-js')

toastr.options = {
  'preventDuplicates': true,
  'preventOpenDuplicates': true
}

global.toastr = toastr;

function chosen_init() {
  $('.chosen-select').chosen().change();
}

$(document).on('turbolinks:load', function(){chosen_init()});

require.context('file-loader?name=[path][name].[ext]&context=node_modules/jquery-ui-dist!jquery-ui-dist', true,    /jquery-ui\.css/ );
require.context('file-loader?name=[path][name].[ext]&context=node_modules/jquery-ui-dist!jquery-ui-dist', true,    /jquery-ui\.theme\.css/ );
