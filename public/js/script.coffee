$.ajax
  url:'/'
  success: (data) ->
    console.log data.length
    $(data).each ->
      console.log this.project_title
      $('body').append('<li>' + this.project_title + '</li>')
