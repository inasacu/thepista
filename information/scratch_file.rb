<script type="text/javascript">
    var disqus_shortname = 'jtwang';

    var disqus_identifier = 'http://johntwang.com/blog/2011/09/13/remove-heroku-toolkit';
    var disqus_url = 'http://johntwang.com/blog/2011/09/13/remove-heroku-toolkit/';
	var disqus_title = 'Remove the Heroku Toolbelt';
	
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = 'http://jtwang.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
</script>

<script type="text/javascript">

	var disqus_shortname = 'haypista'; 
	var disqus_title = ' HayPista - TEAMName Jornada 9'; 
	var disqus_developer = 0; 
	var disqus_identifier = 'http://haypista.com/schedules/ac_la_maso_jornada_9';
	var disqus_url = 'http://haypista.com/schedules/ac_la_maso_jornada_9';				
	var disqus_category_id = '1410371';

	var disqus_config = function () { this.language = "es_ES"; };


	/* * * DON'T EDIT BELOW THIS LINE * * */
	(function() {
		var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
		dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
		(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
		})();

</script>




<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf8">
    <title> Heroku | Page Not Found</title>


    <meta name="viewport" content="width=device-width">

    <link href="//s3.amazonaws.com/heroku-help/error-pages/images/favicon.ico" rel="icon" type="image/ico" />
    <link href="//s3.amazonaws.com/heroku-help/error-pages/stylesheets/application.css" media="screen" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="//use.typekit.net/lpc2yow.js"></script>
    <script type="text/javascript">try{Typekit.load();}catch(e){}</script>
  </head>

  <body>
    <div class="error-404 l-wrapper">
      <h2>The page you were looking for does not exist.</h2>

      <p>
        You may have mistyped the address<br>
        or the page has moved.
      </p>
    </div>
  </body>
</html>




________________________________________________________________________________________________________________________________________________________________


<link rel="stylesheet" href="http://code.jquery.com/ui/1.9.1/themes/base/jquery-ui.css" />
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" href="/resources/demos/style.css" />
<script>
$(function() {
    // $( "#datepicker" ).datepicker();


$( "#datepicker" ).datepicker({
				
			
			// defaultDate: <%= "+#{Time.zone.now + @schedule.starts_at}" %>,
			firstDay: 1,
			// gotoCurrent: true,
            showOtherMonths: true,
            selectOtherMonths: true,
			dayNamesMin: ["<%= t('sunday_short') %>", "<%= t('monday_short') %>", "<%= t('tuesday_short') %>", "<%= t('wednesday_short') %>", 
						   "<%= t('thursday_short') %>", "<%= t('friday_short') %>", "<%= t('saturday_short') %>" ],
						
			// monthNames: ["<%= t('january') %>", "<%= t('february') %>", "<%= t('march') %>", "<%= t('april') %>", 
			// 			 "<%= t('may') %>", "<%= t('june') %>", "<%= t('july') %>", "<%= t('august') %>",
			// 			 "<%= t('september') %>", "<%= t('october') %>", "<%= t('november') %>", "<%= t('december') %>"],
					            showOn: "button",
            buttonImage: "/assets/icons/schedule.png",
            buttonImageOnly: true,
			dateFormat: "dd-mm-yy",
			navigationAsDateFormat: true,
			nextText: "Later" 
			 // numberOfMonths: [ 1, 2 ]


        });

$(  "#datepicker"  ).datepicker( $.datepicker.regional[ "<%= I18n.locale %>" ] );

});
</script>



