
$(document).ready(function(){
  $('.timepicker').timepicker()
  $('#save_card').click(function(e){
    data = {
      rounds: $("#japa_rounds").val(),

    }
    console.log(data)
    
  });

  $('#create').click(function(e){
    data = {
      japa_rounds: $('input#japa_rounds').val(),
      service: $('input#service').val(),
      hearing: $('input#hearing').val(),
      chad_chapter: $('input#chad_chapter').val(),
      chad_start: $('input#chad_start').val(),
      chad_end: $('input#chad_end').val(),
      reading: $('input#reading').val(),
      wake_up: $('input#wake_up').val(),
      slept_at: $('input#slept_at').val()
    }

    $.ajax({
      url: "/sadhna_cards", 
      method: "post",
      data: data,
      sucess: function(e){
        alert("saved")
      },
      failure: function(e){
        alert(e)
      }
    });

  })


});

