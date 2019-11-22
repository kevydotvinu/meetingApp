<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="style.css">
<!-- <link href="https://fonts.googleapis.com/css?family=Ubuntu&display=swap" rel="stylesheet"> -->
</head>
<body>
<div class="title">Meeting Room One</div>
<ul class="main">
  <li class="date">
    <h3><?php echo date("M d");?></h3>
    <h4><?php echo date("g:i A");?></h4>
    <p>Schedule of Events</p>
  </li>
  <li class= "events">
    <ul class="events-detail">
      <li>
        <a href="javascript:history.go(0)">
          <span class="event-slot">In Progress</span>
          <br>
          <span class="event-time"><?php system('cat meetingRoomOneTime');?></span>
          <br>
          <span class="event-name"><?php system('cat meetingRoomOneAgenda');?></span>
          <br>
          <span class="event-location">Scheduled by <?php system('cat meetingRoomOneName');?></span>
        </a>
        </li>
        <li>
        <a href="javascript:history.go(0)">
          <span class="event-slot">Upcoming</span>
          <br>
          <span class="event-time"><?php system('cat meetingRoomOneNextTime');?></span>
          <br>
          <span class="event-name"><?php system('cat meetingRoomOneNextAgenda');?></span>
          <br>
          <span class="event-location">Scheduled by <?php system('cat meetingRoomOneNextName');?></span>
        </a>
      </li>
    </ul>
  </li>
</ul>
<div class="footnote">Powered By<br><img src="ashtech.png" alt="ashinfo"/></div>
</body>
</html>
