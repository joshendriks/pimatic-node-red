tc = pimatic.tryCatch
linkAdded = no
$(document).on( "pagebeforecreate", (event) ->
  if linkAdded then return
  # make sure that we are connected and logged in:
  pimatic.socket.on('connect', ->
    if linkAdded then return
    $.ajax({
      url: '/nodered/get',
      type: 'GET',
      global: false
    }).done( (url) ->
      if linkAdded then return
      divider = $ """
        <li 
            data-theme="f" 
            data-role="list-divider" 
            role="heading" 
            class="ui-li-divider ui-bar-f">
              Links
        </li>
      """
      $('#nav-panel ul li.ui-li-divider:last').before(divider)
      last = divider
      for link in links
        li = $ """
          <li data-theme="f">
            <a 
              href="" 
              data-transition="slidefade" 
              class="ui-btn ui-btn-f ui-btn-icon-right ui-icon-carat-r links-plugin"
              target="iframe">
                "Node-Red"
            </a>
          </li>
        """
        last.after(li)
        last = li
      linkAdded = yes
      pimatic.try => ul.listview('refresh')
    )
  )
)

$(document).on( "click", ".links-plugin", (event) ->
  a = $(this)
  iframe = $('#node-red-iframe')
  iframe.attr('src', a.attr('href'))
  $('#node-red-page h3').text("Node-Red")
  jQuery.mobile.changePage '#node-red-page', transition: 'slide'
  event.preventDefault()
  return false
)
