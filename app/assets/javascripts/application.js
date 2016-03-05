// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

function toggleDropdownMenu() {
	dropdownContent = document.getElementsByClassName("dropdown-content")[0];
	if (dropdownContent.style.display == "none")
		dropdownContent.style.display = "block";
	else
		dropdownContent.style.display = "none";
}

window.onclick = function(e) {
	if (!e.target.matches('.dropdown-button')) {
		var dropdowns = document.getElementsByClassName("dropdown-content");
		for (var d = 0; d < dropdowns.length; d++) {
			dropdowns[d].style.display = "none";
		}
	}
}