$(document).ready(function() {

  $('#selectAll').click(function() {
    if (this.checked) {
      $(':checkbox').each(function() {
        this.checked = true;
      });
    } else {
      $(':checkbox').each(function() {
        this.checked = false;
      });
    }
  });
  //
  // $('#modalPriceEdit input[type="submit"]').on('submit',function() {
  //   $("#modalPriceEdit").html("")
  // });
  //

  $('#faro_price_edit_button').click(function(event) {
    event.preventDefault();
    var array = [];
    $('#products_table :checked').each(function() {
      array.push($(this).val());
    });
// console.log(array)
    $.ajax({
      type: "POST",
      url: $(this).attr('href') + '.js',
      data: {
        ids: array
      },
      success: function(data) {
        $('#modalPriceEdit .close').click(function() {
          console.log("CLOSE")
          $("#modalPriceEdit").html("")
        });
      },
      error: function(jqXHR, textStatus, errorThrown) {
        console.log(jqXHR);
      }
    })
  });

});
