jQuery(document).ready(function(){

		'use strict';

		// STICKY HEADER
		$(window).scroll(function() {
		    if ($(this).scrollTop() > 1){  
		        $('header').addClass("sticky");
		    }
		    else{
		        $('header').removeClass("sticky");
		    }
		});

		// SMOOTH SCROLL
		jQuery('#menu-nav ul li a').click(function(){
   			jQuery('#menu-nav').removeClass('in');
  		});
		jQuery('.nav li a').bind('click', function(e) {
            e.preventDefault();
            jQuery('html,body').animate({scrollTop: jQuery(this.hash).offset().top - 150});                                                         
        });


			// FLEXSLIDER
			jQuery('.flexslider').flexslider({
				animation: "fade",              //String: Select your animation type, "fade" or "slide"
				animationLoop: true,             //Boolean: Should the animation loop? If false, directionNav will received "disable" classes at either end
				slideshow: true,                //Boolean: Animate slider automatically
				slideshowSpeed: 3000,           //Integer: Set the speed of the slideshow cycling, in milliseconds
				animationSpeed: 1000,            //Integer: Set the speed of animations, in milliseconds
				// Primary Controls
				controlNav: true,               //Boolean: Create navigation for paging control of each clide? Note: Leave true for manualControls usage
				directionNav: false,             //Boolean: Create navigation for previous/next navigation? (true/false)
				pauseOnHover: true,            //Boolean: Pause the slideshow when hovering over slider, then resume when no longer hovering
			});


		// BXSLIDER
		jQuery('.gallery').bxSlider({
			slideWidth: 280,
			minSlides: 1,
			maxSlides: 4,
			moveSlides: 1,
			auto: true,
			pager: false,
			slideMargin: 10
		  });
				
			
		// ACCORDION - GALLERY
		jQuery(function() {
			jQuery( ".accordion" ).accordion({
				collapsible: true,
				heightStyle: "content",
				autoHeight: false,
			});
		
		});


		
		// SIMPLECART.JS
		simpleCart({
			checkout: {
				type: "PayPal",
				email: "wojciech@zeglin.co.uk"
			},
			 cartColumns: [
				{ attr: "name" , label: "Name" } ,
				{ attr: "price" , label: "Price", view: 'currency' } ,
				{ view: "decrement" , label: "&nbsp;" , text: "-" } ,
				{ attr: "quantity" , label: "Qty" } ,
				{ view: "increment" , label: "&nbsp;" , text: "+" } ,
				{ attr: "total" , label: "SubTotal", view: 'currency' } ,
				{ view: "remove" , text: "Remove" , label: "&nbsp;" }
			],
		
		});
		// simple callback example
		simpleCart.bind( 'beforeAdd' , function( item ){
			//alert("modal");
			jQuery('.modal').modal({
				backdrop:	true,
			});
		});
		
		
		// PLACEORDER Button
		jQuery('.placeorder').click(function(){
			jQuery('.modal').modal({backdrop:true,});
		});
		


		// SMOOTH SCROLL
		jQuery(".nav ul li a").on('click', function() {
		   alert("sss");
		});
		
			

		// CONTACT FORM
			jQuery("#contactform").submit(function() {
				var url = "contact.php"; // the script where you handle the form input.
				var emailcontact = jQuery('#emailcontact').val();
				var message = jQuery('#message').val();
				var email = document.getElementById('emailcontact');
				var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
				// validate email
				if (!filter.test(email.value) || jQuery('#emailcontact').val() == 'Enter your email') {
						email.focus;
						jQuery('#emailcontact').addClass('error');
						return false;
					 } else {
						jQuery('#emailcontact').removeClass('error');
					}
				
				// validate message
				if ( jQuery('#message').val() == '' || jQuery('#message').val() == 'Enter your message') {
					jQuery('#message').addClass('error');
					//alert("msg error");
					return false;
				} else {
					jQuery('#message').removeClass('error');
				}
				
				// send data
				jQuery.ajax({
					   type: "POST",
					   url: url,
					   data: jQuery("#contactform").serialize(), // serializes the form's elements.
					   success: function(data)
					   {
							jQuery("#emailcontact, #message, #sendmessage").attr("disabled","disabled");
							jQuery('#emailcontact').removeClass('error');
							
							//alert(data);
							alert("Thank you! We will be in touch."); // show response from the php script.
							return false; // avoid to execute the actual submit of the form.
					   }
					 });
				return false; // avoid to execute the actual submit of the form.
				//alert("after ajax");
			});



		// NEWSLETTER FORM
			jQuery("#newsletter").submit(function() {
				var url = "lib/newsletter.php"; // the script where you handle the form input.
				var emailnews = jQuery('#emailnews').val();
				var email = document.getElementById('emailnews');
				var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
				// validate email
				if (!filter.test(email.value) || jQuery('#emailnews').val() == 'Enter your email') {
						email.focus;
						jQuery('#emailnews').addClass('error');
						return false;
					 } else {
						jQuery('#emailnews').removeClass('error');
					}
				// send data
				jQuery.ajax({
					   type: "POST",
					   url: url,
					   data: jQuery("#newsletter").serialize(), // serializes the form's elements.
					   success: function(data)
					   {
							jQuery("#emailnews, #signup").attr("disabled","disabled");
							jQuery('#emailnews').removeClass('error');
							
							//alert(data);
							alert("Thank you for signing up!"); // show response from the php script.
							return false; // avoid to execute the actual submit of the form.
					   }
					   
					 });
					return false; // avoid to execute the actual submit of the form.
					//alert("after ajax");
			});		
		
		});