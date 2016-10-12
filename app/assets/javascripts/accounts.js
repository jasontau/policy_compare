$(document).ready(function() {
  console.log("Accounts JS Loaded");
  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
      var ev = document.createEvent('Event');
      ev.initEvent('resize', true, true);
      window.dispatchEvent(ev);
    });
});
