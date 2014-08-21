# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# $ ->
#   $('#mapping_odk_formid, #mapping_salesforce_object_name').change ->
#     window.location.href = '/mappings/new?' + $('#mapping_odk_formid').serialize()

#   $('#salesforce_object_name').change ->
#     $.ajax
#       method: 'GET'
#       url: '/mappings/get_salesforce_fields'
#       data: $(@).serialize()

#   $('#new_mapping, .edit_mapping').find( ".salesforce-fields, .saleforce-mapping-field" ).sortable
#     connectWith: ".connected-sortable",
#     receive: (event, ui) ->
#       if ui.item.length > 0
#         $parent = ui.item.closest('.odk-field')
#         if $parent.length > 0
#           $parent.find('.sf-mapping').val(ui.item.parent().sortable('toArray'))
#         else
#           arr = ui.sender.sortable('toArray')
#           console.log arr
#           if arr.length is 0
#             # If there aren't anymore fields then set the delete on this
#             ui.sender.closest('.odk-field').find('.sf-delete').val(true)
#           else
#             ui.sender.closest('.odk-field').find('.sf-delete').val(false)
#             ui.sender.closest('.odk-field').find('.sf-mapping').val(arr)

#   $('#new_mapping, .edit_mapping').find('.saleforce-mapping-field').each((index, ele) ->
#     $(ele).closest('.odk-field').find('.sf-mapping').val($(ele).sortable('toArray'))
#   )
