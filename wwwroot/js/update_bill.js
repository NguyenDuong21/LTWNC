$(document).ready(function () {
    //update bill
    $(".update_bill").click(function(){
        let isUpdate = confirm("Bạn xác nhận hoàn thành thanh toán?");
        if(isUpdate) {
            $.ajax({
                url: "DetailOrder/Update",
                type: "POST",
                data: {
                    id: $(this).data("id")
                }
            }).done(function(response){
                if(response == "success"){
                    alert("Update thành công");
                }
                else{
                    alert("Update thất bại");
                }
            })
        }
    })
})