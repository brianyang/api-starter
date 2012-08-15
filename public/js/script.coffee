dbFetch = ->
  $.ajax
    url:'/'
    success: (data) ->
      console.log data.length
      $(data).each ->
        console.log this.project_title
        $('body').append('<li>' + this.project_title + '</li>')
#dbFetch()

fetchMusicFolders = ->
  url = '/getMusicFolders'
  $.ajax
      url:url
      success: (dat) ->
          console.log $.parseJSON(dat)
          obj = $.parseJSON(dat)
          console.log obj['subsonic-response']['musicFolders']['musicFolder']
          $(obj['subsonic-response']['musicFolders']['musicFolder']).each ->
            $('#album').append '<li><a class=foldername href=/idView/' + this.id + ' >' + this.name + '</a></li>'

            musicFolderId = $('#music-folder').text()
            url = '/getIndexes/' + musicFolderId
            $.ajax
              url: url
              success: (dat) ->
                dat = $.parseJSON(dat)
                #$(dat['subsonic-response']['indexes']).each ->
                console.log dat['subsonic-response']
                $(dat['subsonic-response']['indexes']['index']).each ->
                  console.log 'loop1'
                  console.log this.artist.name

                  $('body').append this.artist.name
                  $(this.artist).each ->
                    console.log 'loop2'
                    $('body').append this.name
                    console.log this.name



fetchMusicFolders()

$ ->
  $('body').on 'click', '.foldername', (e) ->
    #e.preventDefault()
    console.log 'foo'



