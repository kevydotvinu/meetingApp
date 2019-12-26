<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="style.css">
<!-- <link href="https://fonts.googleapis.com/css?family=Ubuntu&display=swap" rel="stylesheet"> -->
</head>
<body>
<!---<div class="title">Meeting Room One</div>--->
<h3 class="title">PRIME</h3>
<h3 class="subtitle"><?php echo date("M d");?> - <?php echo date("g:i A");?></h3>
<ul class="main">
  <li class= "events">
    <ul class="events-detail">
      <li>
        <a href="javascript:history.go(0)">
          <span class="event-slot-ip">In Progress</span>
          <br>
          <span class="event-time-ip" id="now"><?php system('cat meetingRoomOneTime');?></span>
          <br>
          <span class="event-name-ip"><?php system('cat meetingRoomOneAgenda');?></span>
          <br>
          <span class="event-location-ip">Scheduled by <?php system('cat meetingRoomOneName');?></span>
        </a>
      </li>
    <h4 class="line"></h4>
      <li>
        <a href="javascript:history.go(0)">
          <span class="event-slot">Upcoming</span>
          <br>
          <span class="event-time" id="upcoming"><?php system('cat meetingRoomOneNextTime');?></span>
          <br>
          <span class="event-name"><?php system('cat meetingRoomOneNextAgenda');?></span>
          <br>
          <span class="event-location">Scheduled by <?php system('cat meetingRoomOneNextName');?></span>
        </a>
      </li>
    </ul>
  </li>
</ul>
<div class="footnote-right">Powered By<br><img src="ashtech.jpg" alt="ashinfo"/></div>
<div class="footnote-left"><br><img src="phoenix.jpg" alt="tdi"/></div>
<script type="text/javascript" src="color.js"></script>
</body>
</html>
