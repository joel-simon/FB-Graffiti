window.fbg.addTrending =  () ->
  return if $('#pagelet_trending_graffiti')[0]?
  $('.rightColumnWrapper').append $("""
    <div class="pagelet" id="pagelet_trending_graffiti">
      <div class="_5mym">

        <div class="uiHeader uiHeaderTopBorder pbs _2w2d">
          <div class="clearfix uiHeaderTop">
            <div><h6 class="uiHeaderTitle">
              <a class="_2w2e _24gw" target="_blank"  href="#" role="button" id="u_0_1k">
                Trending Graffiti Pages
              </a>
            </h6></div></div></div>

        <div class="_5my7">
        <iframe src="https://localhost/topPages" style="width: 100%;border:none;height:300px">
        </iframe>
        </div>

      </div>
    </div>
    """)