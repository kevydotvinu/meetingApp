<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="style.css">
<!-- <link href="https://fonts.googleapis.com/css?family=Ubuntu&display=swap" rel="stylesheet"> -->
</head>
<body>
<div id="particles-background" class="vertical-centered-box"></div>
<div id="particles-foreground" class="vertical-centered-box"></div>
<div class="vertical-centered-box">
<div class="content">
      <ul class="main">
  <li class="date">
  <h3><?php echo date("M d");?></h3>
  <h4><?php echo date("G:i A");?></h4>
    <p>Schedule of Events</p>
  </li>
  <li class= "events">
    <ul class="events-detail">
      <li>
        <a href="#">
          <span class="event-time"><?php system('cat meetingRoomOneTime');?></span>&nbsp;&nbsp;
          <span class="event-name"><?php system('cat meetingRoomOneName');?></span>&nbsp;&nbsp;
          <br />
          <span class="event-location">Now:&ensp;<?php system('cat meetingRoomOneAgenda');?></span>
        </a>
      </li>
       <li>
        <a href="#">
          <span class="event-time"><?php system('cat meetingRoomOneNextTime');?></span>&nbsp;&nbsp;
          <span class="event-name"><?php system('cat meetingRoomOneNextName');?></span>&nbsp;&nbsp;
          <br />
          <span class="event-location">Upcoming:&ensp;<?php system('cat meetingRoomOneNextAgenda');?></span>
        </a>
      </li>
    </ul>
  </li>
</ul>
</div>
</div>
</body>
</html>
