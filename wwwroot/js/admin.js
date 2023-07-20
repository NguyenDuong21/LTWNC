$(document).ready(function () {
    load_gallery();
    function load_gallery() {
        sum = 0;
            listChecked = $('.bill-product input[name="id[]"]:checked');

            if (listChecked.length > 0) {
                $.each(listChecked, function (index) {
                    price = listChecked.eq(index).parent().parent().children('.price').text();
                    count = listChecked.eq(index).parent().parent().children('.count').children('input').val();

                    sum += parseInt(price) * parseInt(count);
                });
                $('.bill-product tfoot .totalPrice').html('Tổng tiền hàng : ' + (sum +'') );
                $('.bill-product tfoot input[name="totalPrice"]').val(sum);
            } else {
                sum = 0;
                $('.bill-product tfoot .totalPrice').html('Tổng tiền hàng : ' + (sum +'') );
                $('.bill-product tfoot input[name="totalPrice"]').val(sum);

            }
    }
    $('.bill-product input[name="id[]"]').click(function () {
        load_gallery();
    });
    $('.bill-product input[name="count"]').click(function () {
        load_gallery();
    });
})