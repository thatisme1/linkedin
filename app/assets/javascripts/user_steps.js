// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.




!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');

		document.getElementById("fb-anchor").onclick = function(){
			var link = document.getElementById("fb-anchor");
				var string = "http://www.facebook.com/sharer.php?s=100&amp;&p[url]=http://localhost:3000;&amp;&p[title]=Join myLinkedIn network&amp;&p[summary]=";
	    			string+=document.getElementById("broadcastMessage-Form").textContent;
    
			link.setAttribute("href",string);
			myPopup(string);
			return false;
		}
	

			document.getElementById("tweet-anchor").onclick = function(){
			var link = document.getElementById("tweet-anchor").href+="?&text="+document.getElementById("broadcastMessage-Form").textContent;

    

			return true;
		}

function myPopup(url) {
window.open( url, "myWindow", "status = 1, height = 500, width = 360, resizable = 0" )
}
