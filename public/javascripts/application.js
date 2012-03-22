document.observe('dom:loaded', function() {
	$$('li.thumb').each(function(element){ insertFloating(element)})
	$$("a.author","a.listen","a.play","a.expand").each(function(item,index) {	item.observe('click', show);	});
	$$("li.grid_2 a").each(function(item,index) {	item.observe('click', paginate); });
	Event.observe('search','submit', friendlyUrlSearch);
	Event.observe('q','focus', clearInputSearch);
})

function friendlyUrlSearch(event){
	tag = $F('q').gsub(' ','+')
	document.location='/buscar/'+tag;
	Event.stop(event)
}

function clearInputSearch(event){
	q = event.element();
	if (q._cleared) return
  q.clear()
  q._cleared = true
}

function insertFloating(element) {
	element.insert({before:"<li class='grid_10 view' style='display:none'></li>"})
}

function show(event) {
	var element = event.element();
	var url = element.readAttribute('href');
	var container = element.up(3);
	var floating = container.select('li.grid_10')[0];
	
	hideFloating();
	updateFloating();
	replaceThumbInFloating();
  floating.show();
	Event.stop(event);

		function replaceThumbInFloating() {
			switch(container.readAttribute("id")){
				case "podcast":
					replaceLinkByPodcastPlayer();
					break;
				case "video":
					replaceLinkByVideo();
					removeThumbMain();
					break;
				case "image":
					replaceImageThumb();
			}
		}

		function updateFloating() {
			floating.update(element.up().innerHTML);
			floating.insert({top: '<a href="#fechar" id="close" onClick="hideFloating(); return false">X</a>'});
			var share = '<ul class="share clearfix"> <li class="share_title"><span></span>Compartilhar:</li> <li><a href="http://www.addthis.com/bookmark.php?pub=cen2010&v=250&source=tbx-250&tt=0&s=twitter&url='+url+'&title=CEN2010" class="twitter">Twitter</a></li> <li><a href="http://www.addthis.com/bookmark.php?pub=cen2010&v=250&source=tbx-250&tt=0&s=delicious&url='+url+'&title=CEN2010" class="delicious">Delicious</a></li> <li><a href="http://www.addthis.com/bookmark.php?pub=cen2010&v=250&source=tbx-250&tt=0&s=facebook&url='+url+'&title=CEN2010" class="facebook">Facebook</a></li> </ul>';
			floating.insert(share);
		}
	
		function replaceLinkByPodcastPlayer () {
			var podcast = url.gsub(/http:\/\/podcast.cancaonova.com\/programa.php\?id=/,"");
		 	floating.select("a.listen")[0].replace('<object width="303" height="54" id="PodPlayerCN"><param value="podcast='+podcast+'" name="flashVars"> <param value="http://podcast.cancaonova.com/cn_player.swf" name="movie"> <param value="always" name="allowScriptAccess">	<embed width="303" height="54" flashvars="podcast='+podcast+'" allowscriptaccess="always" name="PodPlayerCN" type="application/x-shockwave-flash" src="http://podcast.cancaonova.com/cn_player.swf">	</object>');
		}
	
		function replaceLinkByVideo() {
			if(url.match( /youtube/))
				replaceLinkByYoutubePlayer();
			else
				replaceLinkByWebtvcnPlayer();
		}
	
		function replaceLinkByYoutubePlayer () {
			var video = url.toQueryParams().v;	
			floating.select("a.play")[0].replace('<object width="640" height="385"><param name="movie" value="http://www.youtube.com/v/'+video+'&hl=en_US&fs=1&"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/'+video+'&hl=en_US&fs=1&" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="640" height="385"></embed></object>');
		}
	
		function replaceLinkByWebtvcnPlayer () {
			var video = floating.select('img')[0].readAttribute('src').gsub(/http:\/\/img.cancaonova.com\/webtv\/webtvcn\/img_/,"").gsub(/\.jpg/,'');
			floating.select("a.play")[0].replace('<object type="application/x-shockwave-flash" data="http://www.webtvcn.com/player/v/'+video+'" width="490" height="303"><param name="movie" value="http://www.webtvcn.com/player/v/'+video+'" /><param name="allowScriptAccess" value="aways" /><param name="wmode" value="window" /><param name="loop" value="false" /><param name="menu" value="true" /><param name="allowFullScreen" value="true" /></object>');
		}
	
		function removeThumbMain() {
			floating.select('img')[0].remove();
		}

		function replaceImageThumb () {
			var image = floating.select('img')[0];
			image.src = image.src.gsub(/_m.jpg/,".jpg");
			image.writeAttribute('height').writeAttribute('width');
			floating.select("img")[0].replace(image);
		}
}

function hideFloating(){
	$$('li.grid_10').invoke('hide');
}

function paginate(event){
	
	Event.stop(event);
 	var element = event.element();
	if(element.hasClassName("disable")) return;
	
	var path = 840 ;
	var direction = -1;
	if (element.readAttribute('href') == "#next") {
		path *= -1;
		direction *= -1;
	};

	var container = element.up(1);
 	var container_thumb = container.select("li.thumb")[0];
	var floating = container.select('li.grid_10')[0];

	floating.hide();
	updatePaginate();
	movePage();

		function movePage () {
			new Effect.Move(container_thumb.down(), {
			  x: path, y: 0, mode: 'relative', queue: 'end',
			  transition: Effect.Transitions.sinoidal
			});
		}

		function updatePaginate() {
			setPaginate();
			setAnchorPaginate();
			enablaDisableAnchorPaginate();
		}

		function setPaginate() {
			_rel = container.readAttribute("rel");
			page = (_rel != null) ? parseInt(_rel) + direction : 1 ;
		}

		function setAnchorPaginate(){
			container.writeAttribute("rel", page );  
		}

		function enablaDisableAnchorPaginate(pag){
			anchor = container.select("li.grid_2 a").invoke('removeClassName','disable');
			lastPage = (container_thumb.select('li.grid_3').size() / 4).floor();
			if(page > lastPage-1)	anchor[0].addClassName("disable");
			else if(page < 1) anchor[1].addClassName("disable");
		}	
}