# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#mapping_odk_formid, #mapping_salesforce_object_name').change ->
    window.location.href = '/mappings/new?' + $('#mapping_odk_formid').serialize() + '&' + $('#mapping_salesforce_object_name').serialize()