lolHardcoded = '<head><title>Most Graffitied Pages in Last Week</title></head><body><div id="container"><div class="page"><a href="https://www.facebook.com/MarineLePen" title=""><p>Marine Le Pen</p><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/c0.7.50.50/p50x50/10428478_988861374463520_4719012667447954388_n.jpg?oh=472c53d776316fd0769a6ff4528f2db6&amp;oe=555F3811&amp;__gda__=1431957301_54341b48a56e7078c055202ea790c431" class="profile hasGraffiti"/></a></div><div class="page"><a href="https://www.facebook.com/dieudonneofficiel" title=""><p>Dieudonné Officiel</p><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/v/t1.0-1/p50x50/10403072_10152763141099006_8149730862439609461_n.jpg?oh=50030b095f44ca86b2a54e2c2b00b4d7&amp;oe=554EF12D&amp;__gda__=1433008424_09bc5845a57850083d8018e591b3796f" class="profile hasGraffiti"/></a></div><div class="page"><a href="https://www.facebook.com/Officialemilyratajkowski" title=""><p>Emily Ratajkowski</p><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/p50x50/10355384_673971456047685_4272295041462813592_n.jpg?oh=0f78486a0e24be88d219f96c93a3e27e&amp;oe=559579E8&amp;__gda__=1435694478_df669d538928547b8ed9200ab380c288" class="profile hasGraffiti"/></a></div><div class="page"><a href="https://www.facebook.com/LeGrandMix" title=""><p>Radio Nova</p><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/v/t1.0-1/p50x50/1457745_10151864896601843_2044688803_n.jpg?oh=2ac7310f5c15300867f09de8e014389a&amp;oe=55920FA5&amp;__gda__=1435548423_b4de4ad0cf24e604978a2c7cdb65d370" class="profile hasGraffiti"/></a></div><div class="page"><a href="https://www.facebook.com/VICE" title=""><p>VICE</p><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/p50x50/1503347_898321190201140_6093099325167080818_n.jpg?oh=00fb23d0bcdab70fe6c2a69e5c173fe7&amp;oe=556A85D2&amp;__gda__=1432399815_6efd5ff62901a6246845edb2a54add98" class="profile hasGraffiti"/></a></div></div></body>'
window.fbg.addTrending = () ->
  return if $('#pagelet_trending_graffiti')[0]?
  $.get fbg.topPagesUrl, (content) ->
    $('.rightColumnWrapper').append $('
      <div class="pagelet" id="pagelet_trending_graffiti">
        <div class="_5mym">

          <div class="uiHeader uiHeaderTopBorder pbs _2w2d">
            <div class="clearfix uiHeaderTop">
              <div><h6 class="uiHeaderTitle">
                <a class="_2w2e _24gw" target="_blank"  href="#" role="button" id="u_0_1k">
                  Trending Graffiti Pages
                </a>
              </h6></div></div></div>

          <div class="_5my7">'+
            content          
          +'</div>

        </div>
      </div>')