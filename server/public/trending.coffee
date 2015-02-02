lolHardcoded = '<html><head><title>Most Graffitied Pages in Last Week</title></head><body><div id="container"><div class="page"><a href="https://www.facebook.com/Spi0n" title=""><p>Spi0n</p><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/v/t1.0-1/p50x50/1004947_10152161957912171_1253888682_n.png?oh=4dc44adfdbd0bb6888f9057a620f56cc&amp;oe=5555C859&amp;__gda__=1431394675_514b01dc98f825d9664c05c2825337dc" class="profile hasGraffiti"/></a></div><div class="page"><a href="https://www.facebook.com/VICE" title=""><p>VICE</p><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/p50x50/1503347_898321190201140_6093099325167080818_n.jpg?oh=00fb23d0bcdab70fe6c2a69e5c173fe7&amp;oe=556A85D2&amp;__gda__=1432399815_6efd5ff62901a6246845edb2a54add98" class="profile hasGraffiti"/></a></div><div class="page"><a href="https://www.facebook.com/9gag" title=""><p>9GAG</p><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash2/v/t1.0-1/p50x50/1521688_10151918899386840_1106586360_n.png?oh=13ca94f662ad35cc3f9cd96dc7aa7cf4&amp;oe=5520C150&amp;__gda__=1432011578_5bce6eb4fd47e8a54a39a6913b3374c4" class="profile hasGraffiti"/></a></div><div class="page"><a href="https://www.facebook.com/MarineLePen" title=""><p>Marine Le Pen</p><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/c0.7.50.50/p50x50/10428478_988861374463520_4719012667447954388_n.jpg?oh=472c53d776316fd0769a6ff4528f2db6&amp;oe=555F3811&amp;__gda__=1431957301_54341b48a56e7078c055202ea790c431" class="profile hasGraffiti"/></a></div><div class="page"><a href="https://www.facebook.com/konbinifr" title=""><p>Konbini</p><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/v/t1.0-1/p50x50/1468559_10152119041139276_2137003748_n.jpg?oh=44140508f0ed84fd4926cd736219c9b8&amp;oe=555673DC&amp;__gda__=1431233150_bd99a875ed6b07239960fb31cc71b9a4" class="profile hasGraffiti"/></a></div></div></body><script type="text/javascript">'
window.fbg.addTrending = () ->
  return if $('#pagelet_trending_graffiti')[0]?
  # return
  # $.get fbg.host+'topPages', (body) ->
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
          lolHardcoded+
        
        +'</div>

      </div>
    </div>')