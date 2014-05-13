# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#mapping_odk_formid, #mapping_salesforce_object_name').change ->
    window.location.href = '/mappings/new?' + $('#mapping_odk_formid').serialize()

  $('#salesforce_object_name').change ->
    $.ajax
      method: 'GET'
      url: '/mappings/get_salesforce_fields'
      data: $(@).serialize()

  $('#new_mapping, .edit_mapping').find( ".salesforce-fields, .saleforce-mapping-field" ).sortable
    connectWith: ".connected-sortable",
    receive: (event, ui) ->
      if ui.item.length > 0
        $parent = ui.item.closest('.odk-field')
        if $parent.length > 0
          $parent.find('.sf-mapping').val(ui.item.parent().sortable('toArray'))
        else
          console.log ui.sender.sortable('toArray')
          ui.sender.closest('.odk-field').find('.sf-mapping').val(ui.sender.sortable('toArray'))

  $('.saleforce-mapping-field').each((index, ele) ->
    $(ele).closest('.odk-field').find('.sf-mapping').val($(ele).sortable('toArray'))
  )

