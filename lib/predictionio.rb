require 'json'
require 'predictionio/request'
require 'predictionio/connection'
require 'predictionio/event_client'
require 'predictionio/engine_client'
require 'predictionio/file_exporter'
require 'predictionio/version'

# The PredictionIO module contains classes that provide convenient access of
# PredictionIO Event API and Engine Instance over HTTP/HTTPS.
#
# To create an app and perform predictions, please download the PredictionIO
# suite from http://prediction.io.
#
# Most functionality is provided by PredictionIO::EventClient and
# PredictionIO::EngineClient classes.
#
# == Deprecation Notice
#
# Pre-0.7.x series support is now deprecated. All existing users are strongly
# encouraged to migrate to 0.8.x.
#
# The old Client interface is retained in case of any accidental Gem upgrade.
# It will be removed in the next minor version.
#
# == High-performance Asynchronous Backend
#
# All REST request methods come in both synchronous and asynchronous flavors.
# Both flavors accept the same set of arguments. In addition, all synchronous
# request methods can instead accept a PredictionIO::AsyncResponse object
# generated from asynchronous request methods as its first argument. In this
# case, the method will block until a response is received from it.
#
# Any network reconnection and request retry is automatically handled in the
# background. Exceptions will be thrown after a request times out to avoid
# infinite blocking.
#
# == Installation
# The easiest way is to use RubyGems:
#     gem install predictionio
module PredictionIO
end
