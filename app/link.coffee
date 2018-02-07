tc = pimatic.tryCatch
linkAdded = no
$(document).on( "pagebeforecreate", (event) ->
  if linkAdded then return
  # make sure that we are connected and logged in:
  pimatic.socket.on('connect', ->
    if linkAdded then return
    $.ajax({
      url: '/links/get',
      type: 'GET',
      global: false
    }).done( (links) ->
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
              href="#{link.url}" 
              data-transition="slidefade" 
              class="ui-btn ui-btn-f ui-btn-icon-right ui-icon-carat-r links-plugin"
              target="#{link.target or '_blank'}">
                #{link.title}
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
  if a.attr('target') is 'iframe'
    iframe = $('#node-red-iframe')
    iframe.attr('src', a.attr('href'))
    $('#node-red-page h3').text(a.text())
    jQuery.mobile.changePage '#node-red-page', transition: 'slide'
    event.preventDefault()
    return false
)
