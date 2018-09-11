# Ruby SDK for convenient access of PredictionIO Output API.
#
# Author::    PredictionIO Team (support@prediction.io)
# Copyright:: Copyright (c) 2014 TappingStone, Inc.
# Copyright:: Copyright (c) 2016 Perpetto BG Ltd.
# License::   Apache License, Version 2.0

require 'date'

module PredictionIO
  class EventClient
    # Raised when an event is not created after a synchronous API call.
    class NotCreatedError < StandardError; end

    def initialize(access_key, apiurl = 'http://localhost:7070')
      @access_key = access_key
      @http = PredictionIO::Connection.new(URI(apiurl)) do |faraday|
       yield faraday if block_given?
     end
    end

    # Returns PredictionIO's status in string.
    def get_status
      status = @http.get(PredictionIO::Request.new('/'))
      begin
        status.body
      rescue
        status
      end
    end

    # Request to create an event and return the response.
    #
    # Corresponding REST API method: POST /events.json
    def create_event(event, entity_type, entity_id, optional = {})
      h = optional
      h.key?('eventTime') || h['eventTime'] = DateTime.now.to_s
      h['event'] = event
      h['entityType'] = entity_type
      h['entityId'] = entity_id
      @http.post(PredictionIO::Request.new(
        "/events.json?accessKey=#{@access_key}", h.to_json
      ))
    end

    # Request to delete an event and return the response.
    #
    # Corresponding REST API method: DELETE events/<your_eventId>.json
    def delete_event(event_id)
      @http.delete(PredictionIO::Request.new(
        "/events/#{event_id}.json?accessKey=#{@access_key}", {}.to_json
      ))
    end

    # Corresponding REST API method: GET events.json
    def find_events(params = {})
      @http.get(PredictionIO::Request.new(
        '/events.json', params.merge('accessKey' => @access_key)
      ))
    end

    # Request to set properties of a user and return the response.
    #
    # Corresponding REST API method: POST /events.json
    def set_user(uid, optional = {})
      create_event('$set', 'user', uid, optional)
    end

    # Request to unset properties of a user and return the response.
    #
    # properties must be a non-empty Hash.
    #
    # Corresponding REST API method: POST /events.json
    def unset_user(uid, optional)
      check_unset_properties(optional)
      create_event('$unset', 'user', uid, optional)
    end

    # Request to delete a user and return the response.
    #
    # Corresponding REST API method: POST /events.json
    def delete_user(uid)
      create_event('$delete', 'user', uid)
    end

    # Request to set properties of an item and return the response.
    #
    # Corresponding REST API method: POST /events.json
    def set_item(iid, optional = {})
      create_event('$set', 'item', iid, optional)
    end

    # Request to unset properties of an item and return the response.
    #
    # properties must be a non-empty Hash.
    #
    # Corresponding REST API method: POST /events.json
    def unset_item(iid, optional)
      check_unset_properties(optional)
      create_event('$unset', 'item', iid, optional)
    end

    # Request to delete an item and return the response.
    #
    # Corresponding REST API method: POST /events.json
    def delete_item(uid)
      create_event('$delete', 'item', uid)
    end

    # Request to record an action on an item and return the response.
    #
    # Corresponding REST API method: POST /events.json
    def record_user_action_on_item(action, uid, iid, optional = {})
      optional['targetEntityType'] = 'item'
      optional['targetEntityId'] = iid
      create_event(action, 'user', uid, optional)
    end

    private
    def check_unset_properties(optional)
      optional.key?('properties') ||
        fail(ArgumentError, 'properties must be present when event is $unset')
      optional['properties'].empty? &&
        fail(ArgumentError, 'properties cannot be empty when event is $unset')
    end
  end
end
