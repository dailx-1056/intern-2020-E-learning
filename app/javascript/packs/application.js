const jquery = require('jquery')
const toastr = require('toastr')

require('./course')
require('@rails/ujs').start()
require('@rails/activestorage').start()
require('channels')
require('@fortawesome/fontawesome-free/js/all')
require('bootstrap/dist/js/bootstrap')
require('jquery')
require('jquery-ui')
require('@nathanvda/cocoon')

global.toastr = toastr;

require.context('file-loader?name=[path][name].[ext]&context=node_modules/jquery-ui-dist!jquery-ui-dist', true,    /jquery-ui\.css/ );
require.context('file-loader?name=[path][name].[ext]&context=node_modules/jquery-ui-dist!jquery-ui-dist', true,    /jquery-ui\.theme\.css/ );
